//
//  FontListViewController.h
//  FontsExplorer
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontListViewController : UITableViewController

// 由父控制器传来的参数
@property (copy, nonatomic) NSArray *fontNames;
@property (assign, nonatomic) BOOL showsFavorites;

@end
