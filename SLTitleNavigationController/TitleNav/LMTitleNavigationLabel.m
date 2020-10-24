//
//  LMTitleNavigationLabel.m
//  lmps-driver
//
//  Created by 孙立 on 2020/1/13.
//  Copyright © 2020 Come56. All rights reserved.
//

#import "LMTitleNavigationLabel.h"

typedef struct ColorStruct {
    CGFloat Color_R;
    CGFloat Color_G;
    CGFloat Color_B;
} RGBColor;

@interface LMTitleNavigationLabel ()

#define RGBColor(R,G,B) [UIColor colorWithRed:R green:G blue:B alpha:1]

@property (nonatomic, assign) RGBColor normalTextColor;
@property (nonatomic, assign) RGBColor selectedTextColor;

@end

@implementation LMTitleNavigationLabel

// 将UIColor对象换成rgb值
- (RGBColor)changeColor:(UIColor *)color {

    RGBColor rgbColor;
    
    CIColor *ciColor = [CIColor colorWithCGColor:color.CGColor];
    
    rgbColor.Color_R = ciColor.red;
    rgbColor.Color_B = ciColor.blue;
    rgbColor.Color_G = ciColor.green;
    return rgbColor;
}

- (void)setTextColor_Nor:(UIColor *)textColor_Nor {
    self.normalTextColor = [self changeColor:textColor_Nor];
}

- (void)setTextColor_Sel:(UIColor *)textColor_Sel {
    self.selectedTextColor = [self changeColor:textColor_Sel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    
//    _scale = scale * (KMaxScale - 1) + 1;
//    _scale = 1;
    CGFloat red = self.normalTextColor.Color_R + (self.selectedTextColor.Color_R - self.normalTextColor.Color_R) * scale;
    CGFloat green = self.normalTextColor.Color_G + (self.selectedTextColor.Color_G - self.normalTextColor.Color_G) * scale;
    CGFloat blue = self.normalTextColor.Color_B + (self.selectedTextColor.Color_B - self.normalTextColor.Color_B) * scale;
    self.textColor = RGBColor(red, green, blue);
//    self.transform = CGAffineTransformMakeScale(_scale, _scale);
}

@end
