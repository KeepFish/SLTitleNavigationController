//
//  LMMultipleControllerViewDisplayView.m
//  lmps-driver
//
//  Created by 孙立 on 2020/1/13.
//  Copyright © 2020 Come56. All rights reserved.
//

#import "LMMultipleControllerViewDisplayView.h"
#import <Masonry.h>

@interface LMMultipleControllerViewDisplayView () <LMTitleNavigationViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) LMTitleNavigationView *titleNavigationView;

@property (nonatomic, strong) NSArray *childs;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *bgViews;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation LMMultipleControllerViewDisplayView

- (instancetype)initWithChildVCs:(NSArray *)childVCs titles:(NSArray *)titles selectedIndex:(NSInteger)index {
    if (self = [super initWithFrame:CGRectZero]) {
        _childs = childVCs.copy;
        _titles = titles.copy;
        _selectedIndex = index;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.titleNavigationView];
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.contentView];

    [self.titleNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(40);
    }];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleNavigationView.mas_bottom);
        make.bottom.left.right.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainScrollView);
        make.height.equalTo(self.mainScrollView);
    }];
    
    UIView *lastView;
    for (int i=0; i<self.childs.count; i++) {
        UIViewController *childVC = self.childs[i];
        UIView *bgView;
        if (i == 0) {
            bgView = childVC.view;
        } else {
            bgView = [UIView new];
        }
        [self.bgViews addObject:bgView];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.top.bottom.equalTo(self.contentView);
                make.width.equalTo(self.mainScrollView);
            } else {
                make.left.equalTo(lastView.mas_right);
                make.top.bottom.width.equalTo(lastView);
            }
        }];
        lastView = bgView;
    }
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView);
    }];
}

- (void)lm_titleNavigationViewDidMoveToIndex:(NSInteger)index {
    UIViewController *childVC = self.childs[index - 1];
    if ([childVC isViewLoaded]) return;
    else {
        UIView *bgView = self.bgViews[index - 1];
        [bgView addSubview:childVC.view];
        [childVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView);
        }];
    }
}

#pragma mark -
#pragma mark ---------Getter
- (UIScrollView *)mainScrollView {
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainScrollView;
}

- (LMTitleNavigationView *)titleNavigationView {
    if (_titleNavigationView == nil) {
        _titleNavigationView = [[LMTitleNavigationView alloc] initWithTitles:self.titles selectedIndex:self.selectedIndex];
        _titleNavigationView.vcScrollView = self.mainScrollView;
        _titleNavigationView.delegate = self;
    }
    return _titleNavigationView;
}

- (NSMutableArray *)bgViews {
    if (_bgViews == nil) {
        _bgViews = [NSMutableArray array];
    }
    return _bgViews;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

@end
