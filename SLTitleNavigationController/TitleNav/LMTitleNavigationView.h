//
//  LMTitleNavigationView.h
//  lmps-driver
//
//  Created by 孙立 on 2020/1/13.
//  Copyright © 2020 Come56. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMTitleNavigationViewDelegate <NSObject>

- (void)lm_titleNavigationViewDidMoveToIndex:(NSInteger)index;

@end

@interface LMTitleNavigationView : UIView

@property (nonatomic, weak) UIScrollView *vcScrollView;

- (instancetype)initWithTitles:(NSArray *)titles selectedIndex:(NSInteger)selectedIndex;

@property (nonatomic, weak) id <LMTitleNavigationViewDelegate> delegate;

@property (nonatomic, strong) UIColor *underline_color;
/** 字体颜色  普通 **/
@property (nonatomic, strong) UIColor *titleColor_Normal;
/** 字体颜色  选中 **/
@property (nonatomic, strong) UIColor *titleColor_Selected;

@end
