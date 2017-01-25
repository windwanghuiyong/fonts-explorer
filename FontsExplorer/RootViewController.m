//
//  RootViewController.m
//  FontsExplorer
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

#import "RootViewController.h"
#import "FavoritesList.h"
#import "FontListViewController.h"	// 子控制器

@interface RootViewController ()

@property (copy, nonatomic) NSArray			*familyNames;		// 使用 copy
@property (assign, nonatomic) CGFloat		cellPointSize;		// 表单元字体大小
@property (strong, nonatomic) FavoritesList	*favoritesList;		// 指向 FavoritesList 单例的指针

@end

@implementation RootViewController
{
    NSInteger	_sectionNums;			// 根控制器表视图分区个数
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *preferredTableViewFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    // 初始化根控制器视图属性
    self.familyNames = [[UIFont familyNames] sortedArrayUsingSelector:@selector(compare:)];	// 拷贝字体库, 仅获取名称
    self.cellPointSize = preferredTableViewFont.pointSize;					// 根视图控制器标题字体大小
    self.favoritesList = [FavoritesList sharedFavoritesList];				// 初始化并引用收藏列表
    NSLog(@"载入根视图控制器完成");
}

// 从其他视图回到根视图时, 重新加载表视图, 以显示新增的收藏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 收藏列表数组中是否有数据
    _sectionNums = [self.favoritesList.favorites count] > 0 ? 2 : 1;
    return _sectionNums;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sectionNums == 1) {
    	return [self.familyNames count];	
    } else {
        if (section == 0) {
            return 1;
        } else {
            return [self.familyNames count];	
        }
    }
}

// 表视图分区的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_sectionNums == 1) {
        return @"All Font Families";
    } else {
        if (section == 0) {
            return @"My Favorite Fonts";
        } else {
            return @"All Font Families";
        }
    }
}

// 配置表单元
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 该分区表单元标识符
    static NSString *FavoritesCell = @"FavoritesCell";
    static NSString *FamilyNameCell = @"FamilyNameCell";
    UITableViewCell *cell = nil;
    
    // 依据表单元样式更新标签
    if (_sectionNums == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:FamilyNameCell forIndexPath:indexPath];
        cell.textLabel.font = [self fontForDisplayAtIndexPath:indexPath];	// title 按原字体
        cell.textLabel.text = self.familyNames[indexPath.row];				// title 名称取该行字体名
        cell.detailTextLabel.text = self.familyNames[indexPath.row];			// subtitle 按默认字体
    } else {
        if(indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:FavoritesCell forIndexPath:indexPath];
            cell.textLabel.text = @"Favorites List";								// title 字符串常量
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:FamilyNameCell forIndexPath:indexPath];
            cell.textLabel.font = [self fontForDisplayAtIndexPath:indexPath];	// title 按原字体
            cell.textLabel.text = self.familyNames[indexPath.row];				// title 名称取该行字体名
            cell.detailTextLabel.text = self.familyNames[indexPath.row];			// subtitle 按默认字体
        }
    }
    return cell;
}

// 按原样显示所有字体
- (UIFont *)fontForDisplayAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *familyName = self.familyNames[indexPath.row];
        NSString *fontName = [[UIFont fontNamesForFamilyName:familyName] firstObject];
        return [UIFont fontWithName:fontName size:self.cellPointSize];	// 获取字体系列的列表
    } else {
        return nil;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	// sender 指示被点击的行
    // 使用 segue destinationViewController 获取新的视图控制器
    // 将选定对象传入新的视图控制器
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];				// 由点击获取 section
    FontListViewController *listViewController = segue.destinationViewController;	// 向 segue 请求目标视图控制器
    
    if (_sectionNums == 1) {
        NSString *familyName = self.familyNames[indexPath.row];		// 本行字体名称
        listViewController.fontNames = [[UIFont fontNamesForFamilyName:familyName] sortedArrayUsingSelector:@selector(compare:)];
        listViewController.navigationItem.title = familyName;		// 导航条的标题(当前选择的字体名称)
        listViewController.showsFavorites = NO;
    } else {
        if (indexPath.section == 0) {
            listViewController.fontNames = self.favoritesList.favorites;
            listViewController.navigationItem.title = @"Favorites";
            listViewController.showsFavorites = YES;
        } else {
            NSString *familyName = self.familyNames[indexPath.row];		// 本行字体名称
            listViewController.fontNames = [[UIFont fontNamesForFamilyName:familyName] sortedArrayUsingSelector:@selector(compare:)];
            listViewController.navigationItem.title = familyName;		// 导航条的标题(当前选择的字体名称)
            listViewController.showsFavorites = NO;
        }
    }
}

@end
