//
//  AKDetailViewController.m
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import "AKDetailViewController.h"
#import "AKQuotaCollectionViewCell.h"
#import "AKQuotaDao.h"
#import "AKParliamentaryDao.h"
#import "AKQuota.h"
#import "AKStatistic.h"
#import "AKUtil.h"
#import "AKQuotaDetailViewController.h"
#import "AKWebServiceConsumer.h"
#import "MBProgressHUD.h"
#import "AKAppDelegate.h"
#import "AKStatisticDao.h"
#import "Reachability.h"
#import "AKSettingsManager.h"

@interface AKDetailViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *quotaCollectionView;
@property (nonatomic) AKQuotaDao *quotaDao;
@property (nonatomic) AKParliamentaryDao *parliamentaryDao;
@property (nonatomic) AKStatisticDao *statisticDao;
@property (nonatomic) NSArray *quotas;
@property (nonatomic) NSArray *allQuotas;
@property (nonatomic) UIPickerView *datePickerView;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic) AKWebServiceConsumer *webService;
@property (nonatomic) BOOL toBeUnfollowed;
@property (nonatomic) NSInteger olderYear;
@property (nonatomic) NSInteger actualYear;
@property(nonatomic) NSInteger selectedYear;
@property(nonatomic) NSInteger selectedMonth;
@property MBProgressHUD *hud;
@end

@implementation AKDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    self.quotaDao = [AKQuotaDao getInstance];
    self.parliamentaryDao = [AKParliamentaryDao getInstance];
    self.statisticDao = [AKStatisticDao getInstance];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    
    self.selectedMonth = components.month;
    self.actualYear = self.selectedYear = components.year;
    self.olderYear = [[self.quotaDao getOldestYear] integerValue];

    [self configureViewVisualComponentes];
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.webService = [[AKWebServiceConsumer alloc] init];

    if([self.parliamentary.followed isEqual:@0]) {
        [self downloadQuotasForParliamentary];
        
    } else {
        self.allQuotas = [self.quotaDao getQuotaByIdParliamentary:self.parliamentary.idParliamentary];
        
        if(self.allQuotas == nil || self.allQuotas.count == 0) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.color = [AKUtil color1clear];
            self.hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15];
            self.hud.detailsLabelColor = [AKUtil color4];
            self.hud.detailsLabelText = @"Carregando cotas do parlamentar";
            [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(checkIfQuotasWereDownloadedAndUpdate:) userInfo:nil repeats:YES];
        }
        else {
            [self filterQuotas];
        }
    }
}

-(void) checkIfQuotasWereDownloadedAndUpdate:(NSTimer *)timer {
    static int numberOfChecks = 0;
    
    self.allQuotas = [self.quotaDao getQuotaByIdParliamentary:self.parliamentary.idParliamentary];
    
    if(self.allQuotas.count > 0) {
        [self filterQuotas];
        [self.quotaCollectionView reloadData];
        [timer invalidate];
        [self.hud hide:YES afterDelay:0.3];
        self.hud = nil;
    } else if(numberOfChecks >= 4) {
        [timer invalidate];
        [self.hud hide:YES];
        self.hud = nil;
        [self downloadQuotasForParliamentary];
    } else {
        numberOfChecks++;
    }
}

-(void) configureViewVisualComponentes {
    //registering cell nib that is required for collectionView te dequeue it.
    [self.quotaCollectionView registerNib:[UINib nibWithNibName:@"AKQuotaCollectionViewCell" bundle:[NSBundle mainBundle]]
               forCellWithReuseIdentifier:@"AKCell"];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeQuotas:)];
    [leftSwipe setDirection: UISwipeGestureRecognizerDirectionLeft ];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeQuotas:)];
    [rightSwipe setDirection: UISwipeGestureRecognizerDirectionRight ];
    
    [self.quotaCollectionView addGestureRecognizer: rightSwipe];
    [self.quotaCollectionView addGestureRecognizer: leftSwipe];
    
    self.datePickerView = [[UIPickerView  alloc] init];
    self.datePickerView.delegate = self;
    self.datePickerView.dataSource =self;
    [self.datePickerView selectRow:self.selectedMonth-1 inComponent:0 animated:NO];
    [self.datePickerView selectRow:self.actualYear-self.olderYear inComponent:1 animated:NO];
    [self.datePickerView reloadAllComponents];
    
    self.datePickerView.backgroundColor = [AKUtil color4];
    self.datePickerField.inputView = self.datePickerView;
    self.datePickerField.layer.borderWidth = 1;
    self.datePickerField.layer.cornerRadius = 5;
    self.datePickerField.font = [UIFont fontWithName:@"PTMono-Regular" size:14];
    
    self.datePickerField.text = [NSString stringWithFormat:@"%@ de %@", [self monthForPickerRow:self.selectedMonth-1], [@(self.selectedYear) stringValue] ];
    
    //loading data from parliamentary inside view components
    UIImage *backButtonImage = [UIImage imageNamed:@"backImage"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = [self.parliamentary nickName];

    // Parliamentary photo
        self.photoView.image = [UIImage imageNamed:@"placeholder_foto"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *parliamentaryPhotoFilePath = [NSString stringWithFormat:@"%@/%@.jpg", [AKSettingsManager photoCacheDirPath], self.parliamentary.idParliamentary];
        BOOL photoExistsInCache = [fileManager fileExistsAtPath:parliamentaryPhotoFilePath];
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        // Have photo in DB
        if (self.parliamentary.photoParliamentary != nil) {
            self.photoView.image=[UIImage imageWithData:self.parliamentary.photoParliamentary];
        // Has WiFi OR dont have photo in cache
        } else if(reachability.currentReachabilityStatus == ReachableViaWiFi || photoExistsInCache == NO) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.camara.gov.br/internet/deputado/bandep/%@.jpg", self.parliamentary.idParliamentary]]];
                
                if (photoData) {
                    UIImage *image = [UIImage imageWithData:photoData];
                    
                    if (image) {
                        [photoData writeToFile:parliamentaryPhotoFilePath atomically:YES];
                        
                        [self.parliamentaryDao updateParliamentary:self.parliamentary.idParliamentary withPhoto:photoData];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.photoView.image = image;
                        });
                    }
                }
            });
        // Have photo in cache
        } else if(photoExistsInCache) {
            NSData *photoData = [NSData dataWithContentsOfFile:parliamentaryPhotoFilePath];
            [self.parliamentaryDao updateParliamentary:self.parliamentary.idParliamentary withPhoto:photoData];
            self.photoView.image = [UIImage imageWithData:photoData];
        }
    
    
    self.rankPositionLabel.text=[NSString stringWithFormat:@"%@º",self.parliamentary.posRanking];
    self.parliamentaryLabel.text=self.parliamentary.fullName;
    self.ufLabel.text=[NSString stringWithFormat:@"%@ - %@", self.parliamentary.party, self.parliamentary.uf];
    if ([self.parliamentary.followed isEqual:@1]) {
        [self setButtonFollowedState];
    }
    else{
        [self setButtonUnfollowedState];
    }
    
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(didTapAnywhere:)];
    
    //recieve notifications of when the keyborad is going to appear or hide
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    //create tap recognizer for dismissing the picker when any touches outside it happends
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    // Customize photoView
    self.photoView.layer.cornerRadius = self.photoView.frame.size.height /2;
    self.photoView.layer.masksToBounds = YES;
    self.photoView.layer.borderWidth = 0;
    self.photoView.layer.borderColor = [AKUtil color1].CGColor;
    
    if([self.quotas count] == 0){
        self.quotaCollectionView.alpha = 0.1;
    }
    else{
        self.quotaCollectionView.alpha = 1;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation  duration:(NSTimeInterval)duration
{
    [self loanNibforOrientation:toInterfaceOrientation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loanNibforOrientation:self.interfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PickerView Delegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return  [self monthForPickerRow:row];
    } else {
        return [@(self.olderYear + row) stringValue];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger monthRow =  [pickerView selectedRowInComponent:0];

    NSInteger yearRow =  [pickerView selectedRowInComponent:1];
    
    self.selectedYear = self.olderYear+yearRow;
    self.selectedMonth = monthRow+1;
    
    self.datePickerField.text = [NSString stringWithFormat:@"%@ de %ld", [self monthForPickerRow:monthRow], self.olderYear+yearRow ];
}

#pragma mark - PickerView Data Source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 12;
    } else {
        return (self.actualYear - self.olderYear) + 1;
    }
}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.quotas count];
}

#pragma mark - CollectionView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"AKCell";
    
    AKQuota *quota = self.quotas[indexPath.row];
    AKQuotaCollectionViewCell *cell = (AKQuotaCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.quota = quota;
    
    //get from dao
    @try {
        AKStatistic *statistic = (AKStatistic *)[[self.statisticDao getStatisticByYear:@0 andNumQuota:quota.numQuota] objectAtIndex:0];
        cell.average = [statistic.average doubleValue];
        cell.stdDeviation = [statistic.stdDeviation doubleValue];
        [cell imageForQuotaValue];
    } @catch(NSException *e) {
        ALog(@"EXCECAO = %@", [e description]);
        cell.imageView = nil;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AKQuota *quota = self.quotas[indexPath.row];
    AKQuotaDetailViewController *quotaDetailController = [[AKQuotaDetailViewController alloc] init];
    quotaDetailController.quota = quota;
    quotaDetailController.parliamentary = self.parliamentary;
    
    [self.navigationController pushViewController:quotaDetailController animated:YES];
    
}

#pragma mark - Action methods

- (IBAction)followParliamentary:(id)sender {

    if ([self.parliamentary.followed isEqual:@1]) {
        [self.parliamentaryDao updateFollowedByIdParliamentary:self.parliamentary.idParliamentary andFollowedValue:@0];
        [self.parliamentary setFollowed:@0];

        [self setButtonUnfollowedState];

    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [AKUtil color1clear];
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:14];
        hud.detailsLabelColor = [AKUtil color4];
        hud.detailsLabelText = [NSString stringWithFormat:@"Parlamentar %@ seguido", self.parliamentary.nickName];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        [hud show:YES];
        [hud hide:YES afterDelay:1.75];

        
        [self.parliamentaryDao updateFollowedByIdParliamentary:self.parliamentary.idParliamentary andFollowedValue:@1];
        [self.parliamentary setFollowed:@1];
        
        [self setButtonFollowedState];
        
        if(self.allQuotas == nil || self.allQuotas.count == 0)
            [self downloadQuotasForParliamentary];
    }
}

#pragma mark - Custom Methods

-(void)changeQuotas:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        self.selectedMonth = (self.selectedMonth-1 > 0)? self.selectedMonth-1 : self.selectedMonth;
    }
    else{
        self.selectedMonth = (self.selectedMonth+1 <= 12)? self.selectedMonth+1 : self.selectedMonth;
    }
    [self.datePickerView selectRow:self.selectedMonth-1 inComponent:0 animated:NO];
    self.datePickerField.text = [NSString stringWithFormat:@"%@ de %ld",[self monthForPickerRow:self.selectedMonth-1],(long)self.selectedYear ];
    [self animateDatePickerField];
    [self filterQuotas];
}

-(void)animateDatePickerField{
    CGRect beginRect = self.datePickerField.frame;
    [UIView animateWithDuration:0.5 animations:^{
        float x = self.datePickerField.frame.origin.x - 50;
        float y = self.datePickerField.frame.origin.y - 60;
        float height = self.datePickerField.frame.size.height;
        float width = self.datePickerField.frame.size.width;
        
        self.datePickerField.frame = CGRectMake(x, y, width, height);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.datePickerField.frame = beginRect;
            }];
        }
    }];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self filterQuotas];
    [self.datePickerField resignFirstResponder];
}

- (void)setButtonUnfollowedState {
    [self.followButton setImage:[UIImage imageNamed:@"seguidooff"] forState:UIControlStateNormal];
    self.followLabel.text = @"Seguir";
    self.followLabel.textColor = [AKUtil color1];
}

- (void)setButtonFollowedState {
    [self.followButton setImage:[UIImage imageNamed:@"seguido"] forState:UIControlStateNormal];
    self.followLabel.text = @"Seguido";
    self.followLabel.textColor = [AKUtil color3];
}

-(void)popViewController{
    if([self.parliamentary.followed isEqual:@0]) {
        [self.quotaDao deleteQuotasByIdParliamentary:self.parliamentary.idParliamentary];
    }

    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loanNibforOrientation:(UIInterfaceOrientation)orientation {
    if( UIInterfaceOrientationIsLandscape(orientation) )
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"AKLandscapeDetailViewController"
                                                   owner: self
                                                 options: nil] objectAtIndex:0];
        
        if(self.hud != nil && self.hud.alpha != 0) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.color = [AKUtil color1clear];
            self.hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15];
            self.hud.detailsLabelColor = [AKUtil color4];
            self.hud.detailsLabelText = @"Carregando cotas do parlamentar";
        }

        
        [self configureViewVisualComponentes];
    }
    else
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed: @"AKPortraitDetailViewController"
                                                   owner: self
                                                 options: nil] objectAtIndex:0];
        
        if(self.hud != nil && self.hud.alpha != 0) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.color = [AKUtil color1clear];
            self.hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15];
            self.hud.detailsLabelColor = [AKUtil color4];
            self.hud.detailsLabelText = @"Carregando cotas do parlamentar";
        }
        
        [self configureViewVisualComponentes];
    }
}

- (NSString *)monthForPickerRow:(NSInteger)row {
    switch (row) {
        case 0:
            return @"Janeiro";
            break;
        case 1:
            return @"Fevereiro";
            break;
        case 2:
            return @"Março";
            break;
        case 3:
            return @"Abril";
            break;
        case 4:
            return @"Maio";
            break;
        case 5:
            return @"Junho";
            break;
        case 6:
            return @"Julho";
            break;
        case 7:
            return @"Agosto";
            break;
        case 8:
            return @"Setembro";
            break;
        case 9:
            return @"Otubro";
            break;
        case 10:
            return @"Novembro";
            break;
        default:
            return @"Dezembro";
            break;
    }
}

-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:self.tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
}

-(void) downloadQuotasForParliamentary {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.color = [AKUtil color1clear];
        self.hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15];
        self.hud.detailsLabelColor = [AKUtil color4];
        self.hud.detailsLabelText = @"Carregando cotas do parlamentar";
    });
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.webService downloadDataWithPath:[NSString stringWithFormat:@"/cota/parlamentar/%@", self.parliamentary.idParliamentary] andFinishBlock:^(NSArray *jsonArray, BOOL success, BOOL isConnectionError) {
            
            if(success) {
                NSNumber * idParliamentary;
                NSNumber * idQuota;
                NSNumber * numQuota;
                NSString *nameQuota;
                NSDecimalNumber * value;
                NSNumber * updateVersion;
                NSNumber * year;
                NSNumber * month;
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];                
                
                for(NSDictionary *jsonDict in jsonArray) {
                    idQuota = jsonDict[@"pk"];
                    value = [NSDecimalNumber decimalNumberWithString:jsonDict[@"fields"][@"valor"]];
                    idParliamentary = jsonDict[@"fields"][@"idparlamentar"];
                    numQuota = jsonDict[@"fields"][@"numsubcota"];
                    nameQuota = jsonDict[@"fields"][@"descricao"];
                    month = jsonDict[@"fields"][@"mes"];
                    year = jsonDict[@"fields"][@"ano"];
                    updateVersion = jsonDict[@"fields"][@"versaoupdate"];
                   

                    [self.quotaDao insertQuotaWithId:idQuota andNumQuota:numQuota andNameQuota:nameQuota andMonth:month andYear:year andIdUpdate:updateVersion andValue:value andIdParliamentary:idParliamentary];
                }
                
                self.allQuotas = [self.quotaDao getQuotaByIdParliamentary:self.parliamentary.idParliamentary];
                [self filterQuotas];
                
                self.olderYear = [[self.quotaDao getOldestYear] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.quotaCollectionView reloadData];
                    
                    [self.datePickerView selectRow:self.actualYear-self.olderYear inComponent:1 animated:NO];
                    self.datePickerField.inputView = self.datePickerView;
                    [self.datePickerView reloadAllComponents];
                    
                    self.datePickerField.text = [NSString stringWithFormat:@"%@ de %@", [self monthForPickerRow:[self.datePickerView selectedRowInComponent:0]], [@(self.actualYear) stringValue] ];
                    
                    [self.hud hide:YES afterDelay:0.5f];
                    self.hud = nil;
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.hud hide:YES];
                    self.hud = nil;
                });
                
                [self showError:isConnectionError];
            }
        }];
    });
}

-(void) showError:(BOOL) isConnectionError {
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertView *alert = nil;
        
        if(isConnectionError)
            alert = [[UIAlertView alloc] initWithTitle:@":(" message:@"Não foi possível carregar os dados, verifique sua conexão com a internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        else
            alert = [[UIAlertView alloc] initWithTitle:@":(" message:@"Ocorreu algum erro com o nosso servidor, por conta disso o AKAN não conseguiu carregar novos dados. Abra o app mais tarde para tentar novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    });
}

- (void) dealloc {
    if([self.parliamentary.followed isEqual:@0]) {
        [self.quotaDao deleteQuotasByIdParliamentary:self.parliamentary.idParliamentary];
    }
}

-(void)filterQuotas{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.month == %ld && SELF.year == %d", [self.datePickerView selectedRowInComponent:0]+1, [self.datePickerView selectedRowInComponent:1]+self.olderYear];
    self.quotas = [self.allQuotas filteredArrayUsingPredicate:predicate];
    [self.quotaCollectionView reloadData];
    if([self.quotas count] == 0){
        self.quotaCollectionView.alpha = 0.1;
    }
    else{
        self.quotaCollectionView.alpha = 1;
    }
}

@end
