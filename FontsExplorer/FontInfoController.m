//
//  FontInfoController.m
//  FontsExplorer
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

#import "FontInfoController.h"
#import "FavoritesList.h"

@interface FontInfoController ()

@property (weak, nonatomic) IBOutlet UILabel		*fontSampleLabel;
@property (weak, nonatomic) IBOutlet UISlider	*fontSizeSlider;
@property (weak, nonatomic) IBOutlet UILabel		*fontSizeLabel;
@property (weak, nonatomic) IBOutlet UISwitch	*favoriteSwitch;

@end

@implementation FontInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 前两个是转场传过来的两个属性
    self.favoriteSwitch.on = self.isFavorite;			// 开关状态
    self.fontSampleLabel.font = self.font;				// 字体
    self.fontSampleLabel.text = @"Apple Incorporation Steven Jobs Tim Cook 12345 67890";
    self.fontSizeSlider.value = self.font.pointSize;		// 字号
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%.0f", self.font.pointSize];
    NSLog(@"载入字体信息控制器");
}

// 滑动条变化操作方法
- (IBAction)sliderFontSize:(UISlider *)sender {
    float newSize = roundf(sender.value);
    self.fontSampleLabel.font = [self.font fontWithSize:newSize];
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%.0f", newSize];
}

// 开关变化操作方法
- (IBAction)toggleFavorite:(UISwitch *)sender {
    FavoritesList *favoritesList = [FavoritesList sharedFavoritesList];
    if (sender.on) {
        [favoritesList addFavorite:self.font.fontName];
    } else {
        [favoritesList removeFavorite: self.font.fontName];
    }
}

@end
