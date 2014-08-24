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

@interface AKDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *quotaCollectionView;
@property (nonatomic) AKQuotaDao *quotaDao;
@property (nonatomic) AKParliamentaryDao *parliamentaryDao;
@property (nonatomic) NSArray *quotas;
@property (nonatomic) UIPickerView *datePickerView;
@property (nonatomic) NSString *month;
@property (nonatomic) NSString *year;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;

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
    [super viewDidLoad];
    
    self.quotaDao = [AKQuotaDao getInstance];
    self.parliamentaryDao = [AKParliamentaryDao getInstance];
    self.quotas=[self.quotaDao getQuotaByIdParliamentary:self.parliamentary.idParliamentary];
    
    
    //registering cell nib that is required for collectionView te dequeue it.
    [self.quotaCollectionView registerNib:[UINib nibWithNibName:@"AKQuotaCollectionViewCell" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"AKCell"];

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
    
    self.datePickerView = [[UIPickerView  alloc] init];
    self.datePickerView.delegate = self;
    self.datePickerView.dataSource =self;
    self.datePickerView.backgroundColor = [AKUtil color4];
    self.datePickerField.inputView = self.datePickerView;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
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
    switch (component) {
        case 0:
            self.month = [self monthForPickerRow:row];
            break;
        case 1:
            self.year = [self yearForPickerRow:row];
            break;
        default:
            break;
    }
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
        [cell imageForQuotaValue];
        return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AKQuota *quota = self.quotas[indexPath.row];
    
    AKQuotaDetailViewController *quotaDetailController = [[AKQuotaDetailViewController alloc] init];
   
    quotaDetailController.quotaName = quota.nameQuota;
    quotaDetailController.parliamentary = self.parliamentary;
   
    [self.navigationController pushViewController:quotaDetailController animated:YES];
    
}

#pragma mark - Action methods

- (IBAction)followParliamentary:(id)sender {

    if ([self.followLabel.text isEqualToString: @"Seguido"]) {
        [self updateFollowParliamentaryWithId:self.parliamentary.idParliamentary andValue:@0];
        [self setButtonUnfollowedState];
    }
    else{
        [self updateFollowParliamentaryWithId:self.parliamentary.idParliamentary andValue:@1];
        [self setButtonFollowedState];
    }
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    self.datePickerField.text = [NSString stringWithFormat:@"%@ de %@", self.month, self.year ];
    [self.datePickerField resignFirstResponder];
}

#pragma mark - Custom Methods

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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateFollowParliamentaryWithId:(NSString *)parliamentaryId andValue:(NSNumber *)followed{
    [self.parliamentary setFollowed:followed];
    [self.parliamentaryDao updateFollowedByIdParliamentary:parliamentaryId andFollowedValue:followed];
    if ([followed isEqual: @0]) {
        //[self.quotaDao deleteQuotaByIdParliamentary:parliamentaryId];
    }
    else{
        [self.quotaDao insertQuotasFromArray: self.quotas];
    }
    
}

-(void)loanNibforOrientation:(UIInterfaceOrientation)orientation {
    if( UIInterfaceOrientationIsLandscape(orientation) )
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"AKLandscapeDetailViewController"
                                                   owner: self
                                                 options: nil] objectAtIndex:0];
        [self viewDidLoad];
    }
    else
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed: @"AKPortraitDetailViewController"
                                                   owner: self
                                                 options: nil] objectAtIndex:0];
        [self viewDidLoad];
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



@end
