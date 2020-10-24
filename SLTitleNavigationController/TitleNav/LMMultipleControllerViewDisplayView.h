//
//  LMMultipleControllerViewDisplayView.h
//  lmps-driver
//
//  Created by 孙立 on 2020/1/13.
//  Copyright © 2020 Come56. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMTitleNavigationView.h"

@interface LMMultipleControllerViewDisplayView : UIView

- (instancetype)initWithChildVCs:(NSArray *)childVCs titles:(NSArray *)titles selectedIndex:(NSInteger)index;

@property (nonatomic, strong, readonly) LMTitleNavigationView *titleNavigationView;

@end
