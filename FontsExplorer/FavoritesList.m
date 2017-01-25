//
//  FavoritesList.m
//  FontsExplorer
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

#import "FavoritesList.h"

@interface FavoritesList ()		// 类扩展

@property (strong, nonatomic) NSMutableArray *favorites;		// 分类的属性, 收藏列表数组, 对内是可变数组

@end

@implementation FavoritesList

+ (instancetype)sharedFavoritesList {
    static FavoritesList		*shared = nil;
    static dispatch_once_t	onceToken;
    // 只执行一次, 保证对象为单例模式
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        // 程序启动时, 读取用户默认设置, 初始化收藏列表数组
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *storedFavorites = [defaults objectForKey:@"favorites"];
        // 偏好设置中是否有已经收藏的内容
        if (storedFavorites) {
            self.favorites = [storedFavorites mutableCopy];	// 不论是否为空都直接此分支
        } else {
            self.favorites = [NSMutableArray array];
        }
    }
    return self;
}

// 添加
- (void)addFavorite:(id)item {
    [_favorites insertObject:item atIndex:0];	// 直接访问底层实例变量, 避免同分类中声明可变数组冲突, 插入到最前面
    [self saveFavorites];
}
// 删除
- (void)removeFavorite:(id)item {
    [_favorites removeObject:item];
    [self saveFavorites];
}
// 移动
- (void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to {
    id item = _favorites[from];
    [_favorites removeObjectAtIndex:from];
    [_favorites insertObject:item atIndex:to];
    [self saveFavorites];
}
// 保存
- (void)saveFavorites {
    // 将数组数据同步到用户默认设置中, 以便程序下次启动时读取
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.favorites forKey:@"favorites"];
    [defaults synchronize];
}

@end
