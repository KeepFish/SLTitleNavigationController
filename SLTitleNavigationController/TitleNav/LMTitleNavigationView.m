//
//  LMTitleNavigationView.m
//  lmps-driver
//
//  Created by 孙立 on 2020/1/13.
//  Copyright © 2020 Come56. All rights reserved.
//

#import "LMTitleNavigationView.h"
#import "LMTitleNavigationLabel.h"
#import <Masonry.h>

CGFloat const LMTitleNavigationViewUnderLineHeight = 2.0f;

@interface LMTitleNavigationView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView *contentView;
/** 下面的横线 **/
@property (nonatomic, strong) UIView *underLineView;

@property (nonatomic, copy) NSArray *titles;


@property (nonatomic, assign) CGFloat totalLabelWidth;

@property (nonatomic, assign) NSInteger currentIndex;
/** 上一个选中的label **/
@property (nonatomic, strong) LMTitleNavigationLabel *lastSelectedLabel;

/** 下划线对比label的放大宽度 **/
@property (nonatomic, assign) CGFloat expansionWidth;

@end

@implementation LMTitleNavigationView

- (instancetype)initWithTitles:(NSArray *)titles selectedIndex:(NSInteger)selectedIndex {
    if (self = [super initWithFrame:CGRectZero]) {
        _currentIndex = selectedIndex;
        _titles = titles;
        [self setAttribute];
    }
    return self;
}

- (void)setAttribute {
    _titleColor_Normal = [UIColor blackColor];
    _titleColor_Selected = [UIColor redColor];
    _underline_color = [UIColor blueColor];
    _expansionWidth = _titles.count > 2 ? 0 : 40;
    [self caculateLabelWidth];
}

- (void)buildUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self buildUI];
}

#pragma mark -
#pragma mark ---------UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == self.vcScrollView) {
        if (self.underLineView.constraints.count > 0) {
            CGRect frame = self.underLineView.frame;
            [self.underLineView removeConstraints:self.underLineView.constraints];
            [self.underLineView removeFromSuperview];
            self.underLineView = nil;

            [self.scrollView addSubview:self.underLineView];
            self.underLineView.frame = frame;
        }
        
        CGFloat index = scrollView.contentOffset.x / scrollView.bounds.size.width;
        if (index < 0 || index > self.titles.count - 1) return;
        
        
        NSInteger leftLabelTag = index + 1;
        NSInteger rightLabelTag = index + 2;
        
        LMTitleNavigationLabel *rightLabel = rightLabelTag <= self.titles.count ? [self.scrollView viewWithTag:rightLabelTag] : nil;
        
        LMTitleNavigationLabel *leftLabel = [self.scrollView viewWithTag:leftLabelTag];
        NSInteger currentScale = index;
        CGFloat rightScale = index - currentScale;
        CGFloat leftScale = 1 - rightScale;
        
        // 缩放当前的label  两个
        leftLabel.scale = leftScale;
        rightLabel.scale = rightScale;
        
        // 判断下面横线滚动的方向
        LMTitleNavigationLabel *destinyLabel;
        CGFloat underlineScale = 0.f;
        if (index > self.currentIndex) {
            destinyLabel = [self.scrollView viewWithTag:self.currentIndex + 2];
            underlineScale = rightScale;
            // 当直接点击label的时候 就会进入这里
            if (underlineScale == 0.f) {
                underlineScale = 1.0;
            }
        } else if (index < self.currentIndex) {
            destinyLabel = [self.scrollView viewWithTag:self.currentIndex];
            underlineScale = leftScale;
        }
        if (underlineScale == 1.0) {
            destinyLabel = [self.scrollView viewWithTag:index + 1];
            for (LMTitleNavigationLabel *label in self.contentView.subviews) {
                if (label != leftLabel && [label isKindOfClass:[LMTitleNavigationLabel class]]) {
                    label.scale = 0;
                }
            }
        }
        
        CGFloat dis_offsetX = 0;
        CGFloat dex_width = 0;
        CGFloat current_offsetx = self.lastSelectedLabel.frame.origin.x;
        CGFloat current_width = self.lastSelectedLabel.frame.size.width;
        
        dis_offsetX = destinyLabel.frame.origin.x - self.lastSelectedLabel.frame.origin.x;
        dex_width = destinyLabel.frame.size.width - self.lastSelectedLabel.frame.size.width;
        
        self.underLineView.frame = CGRectMake(current_offsetx + dis_offsetX * underlineScale - 0.5 * self.expansionWidth, CGRectGetHeight(self.scrollView.frame) - LMTitleNavigationViewUnderLineHeight, current_width + dex_width * underlineScale + self.expansionWidth, LMTitleNavigationViewUnderLineHeight);
            
        
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView == self.vcScrollView) {
        CGFloat index = targetContentOffset->x / scrollView.bounds.size.width;
        if (index < 0 || index > self.titles.count - 1) return;
        
        NSInteger labelIndex = index + 1;
        if ([self.delegate respondsToSelector:@selector(lm_titleNavigationViewDidMoveToIndex:)]) {
            [self.delegate lm_titleNavigationViewDidMoveToIndex:labelIndex];
        }
        LMTitleNavigationLabel *currentLabel = [self.scrollView viewWithTag:labelIndex];
        if (self.lastSelectedLabel != currentLabel) {
            self.lastSelectedLabel = currentLabel;
        }
        self.currentIndex = index;
        
        // 计算当前lebel的位置和需要的偏移量
        CGFloat tap_x = currentLabel.center.x;
        CGFloat selfWidth = self.bounds.size.width;
        CGFloat contentWidth = self.scrollView.contentSize.width;
        CGFloat halfWidth = selfWidth * 0.5;
        CGFloat target_x = tap_x - halfWidth;
        
        // 如果需要使label居中的距离大于所能滚动的最大距离 那么就让滚动到最大范围就行了
        if (target_x > contentWidth - selfWidth) {
            target_x = contentWidth - selfWidth;
        }
        // 同理 最小范围为0 不可能为负
        if (target_x < 0) {
            target_x = 0;
        }
        
        CGPoint targetPoint = CGPointMake(target_x, 0);
        
        
        [self.scrollView setContentOffset:targetPoint animated:YES];
        
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView == self.vcScrollView) {
        struct CGPoint *p;
        CGPoint point_x = scrollView.contentOffset;
        p = &point_x;
        [self scrollViewWillEndDragging:scrollView withVelocity:CGPointZero targetContentOffset:p];
    }
}

#pragma mark -
#pragma mark ---------Method
- (void)caculateLabelWidth {
    self.totalLabelWidth = 0.0f;
    for (NSString *title in self.titles) {
        CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
        self.totalLabelWidth += size.width;
    }
}

- (LMTitleNavigationLabel *)labelWithIndex:(NSInteger)index title:(NSString *)title {
    LMTitleNavigationLabel *label = [LMTitleNavigationLabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = self.titleColor_Normal;
    label.textColor_Nor = self.titleColor_Normal;
    label.textColor_Sel = self.titleColor_Selected;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelDidClicked:)];
    [label addGestureRecognizer:tap];
    label.tag = index + 1;
    
    return label;
}

- (void)labelDidClicked:(UITapGestureRecognizer *)tap {
    if (tap.view == self.lastSelectedLabel) {
        return;
    }
    [self.vcScrollView setContentOffset:CGPointMake((tap.view.tag - 1) * self.vcScrollView.frame.size.width, 0)];
    [self scrollViewDidEndScrollingAnimation:self.vcScrollView];
}

- (void)changeTextColor {
    for (LMTitleNavigationLabel *label in self.contentView.subviews) {
        if ([label isKindOfClass:[LMTitleNavigationLabel class]]) {
            label.textColor_Nor = self.titleColor_Normal;
            label.textColor_Sel = self.titleColor_Selected;
            if (label.tag == self.currentIndex + 1) {
                label.textColor = self.titleColor_Selected;
            } else {
                label.textColor = self.titleColor_Normal;
            }
        }
    }
}
 
#pragma mark -
#pragma mark ---------Setter
- (void)setVcScrollView:(UIScrollView *)vcScrollView {
    _vcScrollView = vcScrollView;
    _vcScrollView.delegate = self;
}

- (void)setTitleColor_Normal:(UIColor *)titleColor_Normal {
    if (titleColor_Normal == nil) return;
    _titleColor_Normal = titleColor_Normal;
    [self changeTextColor];
}

- (void)setTitleColor_Selected:(UIColor *)titleColor_Selected {
    if (titleColor_Selected == nil) return;
    _titleColor_Selected = titleColor_Selected;
    [self changeTextColor];
}

- (void)setUnderline_color:(UIColor *)underline_color {
    if (underline_color == nil) return;
    _underline_color = underline_color;
    self.underLineView.backgroundColor = underline_color;
}

#pragma mark -
#pragma mark ---------Getter
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
        
        // 不需要增加滚动距离 以当前屏幕的宽度 可以排列下这么多label
        BOOL isLayoutLabelInScreenWidth = YES;
        // 一般从左开始排 如果只有两个 那就排在中间
        BOOL isLayoutLabelFromEdge = self.titles.count <= 3 ? NO : YES;
        // 大概需要的宽度 默认间距35 20为边距
        CGFloat fixSpace = 35;

        CGFloat needWidth = self.totalLabelWidth + (self.titles.count - 1) * fixSpace + 20;
        if (needWidth > screen_width) {
            isLayoutLabelInScreenWidth = NO;
        } else {
            fixSpace = (screen_width - self.totalLabelWidth - 20.f) / (self.titles.count - 1);
        }
        
        [_scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.height.offset(40);
            if (isLayoutLabelInScreenWidth) {
                make.width.offset(screen_width);
            }
        }];
        UIView *lastView;

        for (int i=0; i<self.titles.count; i++) {
            LMTitleNavigationLabel *label = [self labelWithIndex:i title:self.titles[i]];
            if (i == self.currentIndex) {
                self.lastSelectedLabel = label;
                self.lastSelectedLabel.scale = 1;
            }
            [self.contentView addSubview:label];
            
            if (!isLayoutLabelFromEdge) {
                CGFloat x = (i + 1) / (self.titles.count + 1.0) * screen_width;
                CGFloat y = 20.0;
                [label sizeToFit];
                label.center = CGPointMake(x, y);
                CGRect originFrame = label.frame;
                originFrame.size.height = 40;
                originFrame.origin.y = 0;
                label.frame = originFrame;
            } else {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (i == 0) {
                        make.left.equalTo(self.contentView).offset(10);
                    } else {
                        make.left.equalTo(lastView.mas_right).offset(fixSpace);
                    }
                    make.centerY.equalTo(self.contentView);
                    make.height.equalTo(self.contentView);
                    if (i == self.titles.count - 1) {
                        if (!isLayoutLabelInScreenWidth) {
                            make.right.equalTo(self.contentView).offset(-10);
                        }
                    }
                }];
            }
            lastView = label;
        }
        
        [self.contentView addSubview:self.underLineView];
        [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lastSelectedLabel).offset(- 0.5 * self.expansionWidth);
            make.right.equalTo(self.lastSelectedLabel).offset(0.5 * self.expansionWidth);
            make.bottom.equalTo(self.contentView);
            make.height.offset(LMTitleNavigationViewUnderLineHeight);
        }];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = !isLayoutLabelInScreenWidth;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}

- (UIView *)underLineView {
    if (_underLineView == nil) {
        _underLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _underLineView.backgroundColor = self.underline_color;
    }
    return _underLineView;
}

// 所有title排布在屏幕宽度内
- (BOOL)isLayoutInScreen {
    return self.titles.count < 6 && (self.totalLabelWidth < ([UIScreen mainScreen].bounds.size.width * 0.5));
}

@end

