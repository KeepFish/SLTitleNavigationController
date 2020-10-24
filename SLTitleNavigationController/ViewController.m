//
//  ViewController.m
//  SLTitleNavigationController
//
//  Created by 孙立 on 2020/10/22.
//  Copyright © 2020 sl. All rights reserved.
//

#import "ViewController.h"
#import "DisplayViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
}

#pragma mark -
#pragma mark ---------UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"2个标题";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"3个标题";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"4个标题";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"n个标题";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DisplayViewController *vc = [[DisplayViewController alloc] initWithTitles:self.titles[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"123"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)titles {
    if (_titles == nil) {
        _titles = @[
            @[@"收件人", @"寄件人"],
            @[@"待付款", @"待发货", @"已发货"],
            @[@"全部", @"待付款", @"待发货", @"已发货"],
            @[@"军事", @"体育", @"政治新闻", @"娱乐", @"赛事", @"视频", @"微博", @"科技", @"国际新闻"],
        ];
    }
    return _titles;
}

@end
