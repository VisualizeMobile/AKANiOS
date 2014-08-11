//
//  AKEmptyQuotaCollectionViewCell.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKEmptyQuotaCollectionViewCell.h"

@implementation AKEmptyQuotaCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AKEmptyQuotaCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1)
            return nil;
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
            return nil;
        
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;

}


-(void)awakeFromNib{
}

#pragma mark - custom methods
-(void)imageForQuotaValue{
    self.imageView.image = [UIImage imageNamed:[self.quota imageName]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
