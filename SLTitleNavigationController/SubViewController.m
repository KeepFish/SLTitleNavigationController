//
//  SubViewController.m
//  SLTitleNavigationController
//
//  Created by 孙立 on 2020/10/24.
//  Copyright © 2020 sl. All rights reserved.
//

#import "SubViewController.h"
#import <Masonry.h>

@interface SubViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label2;

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0 blue:arc4random()%256 / 255.0 alpha:1];
    self.label = [UILabel new];
    self.label.text = self.title;
    self.label.font = [UIFont systemFontOfSize:30];
    
    self.label2 = [UILabel new];
    self.label2.text = @"底部";
    
    // 这里通过获取self.view的frame来布局会有问题 拿到的高度不是实际展示的高度 所以要用约束
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [self.view addSubview:self.label2];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self.view);
    }];
}

@end
