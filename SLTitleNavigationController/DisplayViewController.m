//
//  DisplayViewController.m
//  SLTitleNavigationController
//
//  Created by 孙立 on 2020/10/24.
//  Copyright © 2020 sl. All rights reserved.
//

#import "DisplayViewController.h"
#import "LMMultipleControllerViewDisplayView.h"
#import <Masonry.h>
#import "SubViewController.h"

@interface DisplayViewController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) LMMultipleControllerViewDisplayView *displayView;

@end

@implementation DisplayViewController

- (instancetype)initWithTitles:(NSArray *)titles {
    if (self = [super init]) {
        _titles = titles;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    // Do any additional setup after loading the view.
}

- (void)buildUI {
    self.title = @"效果";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.displayView];
    [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (LMMultipleControllerViewDisplayView *)displayView {
    if (_displayView == nil) {
        for (int i=0; i<self.titles.count; i++) {
            SubViewController *childVC = [SubViewController new];
            childVC.title = self.titles[i];
            [self addChildViewController:childVC];
        }
        // 这句之前不要调用childVCview有关的方法 比如childVC.view.backgroundColor = xxx
        // 这样会使view提前加载 会影响后续view的懒加载 导致显示不出来
        _displayView = [[LMMultipleControllerViewDisplayView alloc] initWithChildVCs:self.childViewControllers titles:self.titles selectedIndex:0];
        _displayView.titleNavigationView.titleColor_Normal = [UIColor blackColor];
        _displayView.titleNavigationView.titleColor_Selected = [UIColor orangeColor];
        _displayView.titleNavigationView.underline_color = [UIColor redColor];
    }
    return _displayView;
}

@end
