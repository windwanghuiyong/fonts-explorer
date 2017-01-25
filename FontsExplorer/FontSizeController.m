//
//  FontSizeController.m
//  FontsExplorer
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

#import "FontSizeController.h"

@interface FontSizeController ()

@end

@implementation FontSizeController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pointSizes count];		// 表的行数
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIentifier = @"FontNameAndSize";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIentifier forIndexPath:indexPath];
    cell.textLabel.font = [self fontForDisplayAtIndexPath:indexPath];
    cell.textLabel.text = self.font.fontName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ point", self.pointSizes[indexPath.row]];
    return cell;
}

// 初始化表中每行字体的点数尺寸属性
-(NSArray *)pointSizes {
    static NSArray *pointSizes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pointSizes = @[@9, @10, @11, @12, @13, @14, @18, @24, @36, @48, @64, @72, @96, @144];
    });
    return  pointSizes;
}

-(UIFont *)fontForDisplayAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *pointSize = self.pointSizes[indexPath.row];
    return [self.font fontWithSize:pointSize.floatValue];
}

@end
