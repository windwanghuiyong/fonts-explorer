//
//  FontListViewController.m
//  FontsExplorer
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

#import "FontListViewController.h"
#import "FavoritesList.h"
#import "FontSizeController.h"	// 子控制器
#import "FontInfoController.h"	// 子控制器

@interface FontListViewController ()

@property (assign, nonatomic) CGFloat cellPointSize;		// 每个字体的优先显示尺寸

@end

@implementation FontListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *preferredTableViewFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.cellPointSize = preferredTableViewFont.pointSize;	// 表单元字体大小和标题一致
    NSLog(@"载入当前字体列表");
    
    if (self.showsFavorites) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;			// 只有一个分区, 可以从字体列表或收藏列表中得到
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fontNames count];	// 表视图行数
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FontName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [self fontForDisplayAtIndexPath:indexPath];
    cell.textLabel.text = self.fontNames[indexPath.row];
    cell.detailTextLabel.text = self.fontNames[indexPath.row];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.showsFavorites) {
        self.fontNames = [FavoritesList sharedFavoritesList].favorites;
        [self.tableView reloadData];
    }
}

- (UIFont *)fontForDisplayAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fontName = self.fontNames[indexPath.row];
    return [UIFont fontWithName:fontName size:self.cellPointSize];	// 获取字体的名称列表
}

// 在显示收藏列表时, 启用编辑功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.showsFavorites;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.showsFavorites)
        return;
    if (editingStyle == UITableViewCellEditingStyleDelete) {							// 删除手势
        // 从数据源中删除改行
        NSString *favorite = self.fontNames[indexPath.row];
        [[FavoritesList sharedFavoritesList] removeFavorite:favorite];
        self.fontNames = [FavoritesList sharedFavoritesList].favorites;							// 真的删除
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];	// 删除动画
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [[FavoritesList sharedFavoritesList] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    self.fontNames = [FavoritesList sharedFavoritesList].favorites;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 使用 segue destinationViewController 获取新的视图控制器
    // 将选定对象传入新的视图控制器
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    UIFont *font = [self fontForDisplayAtIndexPath:indexPath];
    [segue.destinationViewController navigationItem].title = font.fontName;
    
    if ([segue.identifier isEqualToString:@"ShowFontSizes"]){
        FontSizeController *sizesViewController = segue.destinationViewController;
        sizesViewController.font = font;
    } else if ([segue.identifier isEqualToString:@"ShowFontInfo"]) {
        FontInfoController *infoViewController = segue.destinationViewController;
        infoViewController.font = font;
        infoViewController.isFavorite = [[FavoritesList sharedFavoritesList].favorites containsObject:font.fontName];
    }
}

@end
