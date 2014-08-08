//
//  AKQuotaCollectionViewCell.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 07/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import "AKQuotaCollectionViewCell.h"

@implementation AKQuotaCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AKQuotaCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1)
            return nil;
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
            return nil;
        
        self = [arrayOfViews objectAtIndex:0];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushQuotaDetail:)];
        
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;

}

-(void)pushQuotaDetail:(UIGestureRecognizer *)recognizer{
    NSLog(@"Toque na celula");
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
