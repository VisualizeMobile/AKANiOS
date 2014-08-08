//
//  AKDetailViewController.h
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKParliamentary.h"

@interface AKDetailViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) AKParliamentary *parliamentary;
@end
