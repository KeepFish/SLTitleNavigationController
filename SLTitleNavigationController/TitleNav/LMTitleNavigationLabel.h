//
//  LMTitleNavigationLabel.h
//  lmps-driver
//
//  Created by 孙立 on 2020/1/13.
//  Copyright © 2020 Come56. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMTitleNavigationLabel : UILabel

/** 普通状态下字体颜色 **/
@property (nonatomic, strong) UIColor *textColor_Nor;
/** 选中状态下字体颜色 **/
@property (nonatomic, strong) UIColor *textColor_Sel;

/** 当前比例 **/
@property (nonatomic, assign) CGFloat scale;

@end
