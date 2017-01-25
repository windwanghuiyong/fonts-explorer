//
//  FavoritesList.h
//  FontsExplorer
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesList : NSObject

+ (instancetype)sharedFavoritesList;		// 工厂方法, 返回消息接受者类型或其子类类型, 作用类似于 Swift 的类属性

- (NSArray *)favorites;					// 实例变量, 收藏列表数组, 对外是不可变数组

- (void)addFavorite:(id)item;
- (void)removeFavorite:(id)item;

- (void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to;

@end
