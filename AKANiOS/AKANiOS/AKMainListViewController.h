//
//  AKMainListViewController.h
//  AKANiOS
//
//  Created by Matheus Fonseca on 07/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKToolBar.h"

@interface AKMainListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolBarContainer;
@property (weak, nonatomic) IBOutlet UILabel *noResultsLabel;
@property(nonatomic) NSNumber *idParliamentaryFromNotification;

@end
