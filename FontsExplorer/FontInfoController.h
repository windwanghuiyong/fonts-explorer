//
//  FontInfoController.h
//  FontsExplorer
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontInfoController : UIViewController

// 由父控制器传来的参数
@property (strong, nonatomic) UIFont		*font;
@property (assign, nonatomic) BOOL		isFavorite;

@end
