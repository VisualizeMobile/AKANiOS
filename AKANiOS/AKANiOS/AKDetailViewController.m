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
#import "AKUtil.h"
#import "AKQuotaDetailViewController.h"
#import "AKWebServiceConsumer.h"
#import "MBProgressHUD.h"
#import "AKAppDelegate.h"

@interface AKDetailViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *quotaCollectionView;
@property (nonatomic) AKQuotaDao *quotaDao;
@property (nonatomic) AKParliamentaryDao *parliamentaryDao;
@property (nonatomic) NSArray *quotas;
@property (nonatomic) NSArray *allQuotas;
@property (nonatomic) UIPickerView *datePickerView;
@property (nonatomic) NSString *monthLabel;
@property (nonatomic) NSString *yearLabel;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic) AKWebServiceConsumer *webService;
@property (nonatomic) NSInteger monthNumber;
@property (nonatomic) NSInteger yearNumber;
@property (nonatomic) BOOL toBeUnfollowed;

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
        
        if(self.allQuotas == nil || self.allQuotas.count == 0)
            [self downloadQuotasForParliamentary];
        else
            [self filterQuotas];
    }
}

-(void) configureViewVisualComponentes {
    //registering cell nib that is required for collectionView te dequeue it.
    [self.quotaCollectionView registerNib:[UINib nibWithNibName:@"AKQuotaCollectionViewCell" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"AKCell"];
    
    //loading data from parliamentary inside view components
    UIImage *backButtonImage = [UIImage imageNamed:@"backImage"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = [self.parliamentary nickName];
    self.photoView.image=[UIImage imageWithData:self.parliamentary.photoParliamentary];
    self.rankPositionLabel.text=[NSString stringWithFormat:@"%@º",self.parliamentary.posRanking];
    self.parliamentaryLabel.text=self.parliamentary.fullName;
    self.partyLabel.text=self.parliamentary.party;
    self.ufLabel.text=self.parliamentary.uf;
    if ([self.parliamentary.followed isEqual:@1]) {
        [self setButtonFollowedState];
    }
    else{
        [self setButtonUnfollowedState];
    }
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    
    self.monthNumber = [components month];
    self.monthLabel = [self monthForPickerRow:self.monthNumber-1];
    self.yearNumber = [components year];
    self.yearLabel = [self yearForPickerRow:self.yearNumber-2013];
    
    self.datePickerView = [[UIPickerView  alloc] init];
    self.datePickerView.delegate = self;
    self.datePickerView.dataSource =self;
    [self.datePickerView selectRow:self.monthNumber-1 inComponent:0 animated:NO];
    [self.datePickerView selectRow:self.yearNumber-2013 inComponent:1 animated:NO];
    
    self.datePickerView.backgroundColor = [AKUtil color4];
    self.datePickerField.inputView = self.datePickerView;
    //set textField with the current month and year relative to quotas
    self.datePickerField.text = [NSString stringWithFormat:@"%@ de %@", self.monthLabel, self.yearLabel ];
    
    
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
    }else{
        return [self yearForPickerRow:row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger monthRow =  [pickerView selectedRowInComponent:0];
    self.monthLabel = [self monthForPickerRow:monthRow];
    self.monthNumber = monthRow+1;

    NSInteger yearRow =  [pickerView selectedRowInComponent:1];
    self.yearLabel = [self yearForPickerRow:yearRow];
    //TODO: dao number of years
    self.yearNumber = yearRow+2013;
}

#pragma mark - PickerView Data Source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 12;
    }
    if(component == 1){
        //TODO: dao number of years
        return 2;
    }
    return 1;
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
    cell.average = 60000;
    cell.stdDeviation = 40000;
    [cell imageForQuotaValue];
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
        [self.parliamentaryDao updateFollowedByIdParliamentary:self.parliamentary.idParliamentary andFollowedValue:@1];
        [self.parliamentary setFollowed:@1];
        
        [self setButtonFollowedState];
        
        if(self.allQuotas == nil || self.allQuotas.count == 0)
            [self downloadQuotasForParliamentary];
    }
}

#pragma mark - Custom Methods

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    self.datePickerField.text = [NSString stringWithFormat:@"%@ de %@", self.monthLabel, self.yearLabel];
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
        [self configureViewVisualComponentes];
    }
    else
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed: @"AKPortraitDetailViewController"
                                                   owner: self
                                                 options: nil] objectAtIndex:0];
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

- (NSString *)yearForPickerRow:(NSInteger)row {
    //TODO year
    switch (row) {
        case 0:
            return @"2013";
            break;
        case 1:
            return @"2014";
            break;
        default:
            return @"2015";
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
    __block MBProgressHUD *hud = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [AKUtil color1clear];
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15];
        hud.detailsLabelColor = [AKUtil color4];
        hud.detailsLabelText = @"Carregando cotas do parlamentar";
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
                    value = [NSDecimalNumber decimalNumberWithDecimal:[[formatter numberFromString:jsonDict[@"fields"][@"valor"]] decimalValue]];
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.quotaCollectionView reloadData];
                    [hud hide:YES afterDelay:0.5f];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
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
            alert = [[UIAlertView alloc] initWithTitle:@"Erro!" message:@"Não foi possível carregar os dados, verifique sua conexão com a internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    if (!self.monthNumber) {
        NSDate *currentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
        
        self.monthNumber = [components month];
        self.monthLabel = [self monthForPickerRow:self.monthNumber-1];
        self.yearNumber = [components year];
        self.yearLabel = [self yearForPickerRow:self.yearNumber-2013];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.month == %d && SELF.year == %d", self.monthNumber, self.yearNumber];
    self.quotas = [self.allQuotas filteredArrayUsingPredicate:predicate];
    [self.quotaCollectionView reloadData];
    if([self.quotas count] == 0){
        self.quotaCollectionView.hidden = YES;
    }
    else{
        self.quotaCollectionView.hidden = NO;
    }
}

@end
