//
//  CCPopMenu.m
//  CCFramework
//
// Copyright (c) 2015 CC ( http://www.ccskill.com )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import "CCPopMenu.h"
#import "CCPopMenuItemView.h"
#import "CCPageIndicatorView.h"

@interface CCPopMenu () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView *menuContainerView;
@property(nonatomic, strong) CCPageIndicatorView *indicatorView;

@property(nonatomic, strong) UITableView *menuTableView;

@property(nonatomic, weak) UIView *currentSuperView;
@property(nonatomic, assign) CGPoint targetPoint;

@property(nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic, assign) CGFloat fromTheTop;

@property(nonatomic, assign) BOOL isShow;

@end

@implementation CCPopMenu

- (void)showMenuAtPoint:(CGPoint)point
{
    [self showMenuOnView:[[UIApplication sharedApplication] keyWindow] atPoint:point];
}

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point
{
    self.currentSuperView = view;
    self.targetPoint = point;
    [self showMenu];
}

#pragma mark - animation

- (void)showMenu
{
    if (![self.currentSuperView.subviews containsObject:self]) {
        self.isShow = YES;
        self.alpha = 0.0;

        if ([self.currentSuperView isKindOfClass:[UIWindow class]]) {
            self.fromTheTop = 64;
            [self layoutSubviews];
        }
        [self.currentSuperView addSubview:self];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;

            CGFloat x = 0;
            if (self.CCAlignment == CCPopMenuAlignmentLeft) {
                x = 6;
            } else if (self.CCAlignment == CCPopMenuAlignmentCenter) {
                x = (CGRectGetWidth(self.bounds) - kCCMenuTableViewWidth) / 2;
            } else if (self.CCAlignment == CCPopMenuAlignmentRight) {
                x = CGRectGetWidth(self.bounds) - kCCMenuTableViewWidth - 6;
            }

            self.menuContainerView.frame = CGRectMake(x, _fromTheTop + 8, kCCMenuTableViewWidth, self.menuItems.count * (kCCMenuItemViewHeight + kCCSeparatorLineImageViewHeight) + kCCMenuTableViewSapcing);
            self.menuTableView.frame = CGRectMake(0, kCCMenuTableViewSapcing, CGRectGetWidth(_menuContainerView.bounds), CGRectGetHeight(_menuContainerView.bounds) - kCCMenuTableViewSapcing);

        } completion:^(BOOL finished){

        }];
    } else {
        [self dissMissPopMenuAnimatedOnMenuSelected:NO];
    }
}

- (void)dissMissPopMenuAnimatedOnMenuSelected:(BOOL)selected
{
    self.isShow = NO;
    if (selected) {
        if (self.popMenuDidDismissCompled) {
            self.popMenuDidDismissCompled(self.indexPath.row, self.menuItems[self.indexPath.row]);
        }
    }

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
        CGFloat x = 0;
        if (self.CCAlignment == CCPopMenuAlignmentLeft) {
            x = 6;
        } else if (self.CCAlignment == CCPopMenuAlignmentCenter) {
            x = (CGRectGetWidth(self.bounds) - kCCMenuTableViewWidth) / 2;
        } else if (self.CCAlignment == CCPopMenuAlignmentRight) {
            x = CGRectGetWidth(self.bounds) - kCCMenuTableViewWidth - 6;
        }
        self.menuContainerView.frame = CGRectMake(x, _fromTheTop + 8, kCCMenuTableViewWidth, 0);
        self.menuTableView.frame = CGRectMake(0, kCCMenuTableViewSapcing, CGRectGetWidth(_menuContainerView.bounds), 0);
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (BOOL)isShowed
{
    return self.isShow;
}

#pragma mark - Propertys

- (void)setMenuItems:(NSMutableArray *)menuItems
{
    _menuItems = menuItems;
    [self.menuTableView reloadData];
}

- (void)layoutSubviews
{
    CGRect frame = self.indicatorView.frame;
    frame.origin.y = _fromTheTop;
    self.indicatorView.frame = frame;

    frame = self.menuContainerView.frame;
    frame.origin.y = _fromTheTop + 8;
    self.menuContainerView.frame = frame;
}

- (UIView *)menuContainerView
{
    if (!_menuContainerView) {

        CGFloat x = 0;
        if (self.CCAlignment == CCPopMenuAlignmentLeft) {
            x = 6;
        } else if (self.CCAlignment == CCPopMenuAlignmentCenter) {
            x = (CGRectGetWidth(self.bounds) - kCCMenuTableViewWidth) / 2;
        } else if (self.CCAlignment == CCPopMenuAlignmentRight) {
            x = CGRectGetWidth(self.bounds) - kCCMenuTableViewWidth - 6;
        }

        _menuContainerView = [[UIView alloc] initWithFrame:CGRectMake(x, _fromTheTop + 8, kCCMenuTableViewWidth, 0)];
        _menuContainerView.backgroundColor = [UIColor whiteColor];
        _menuContainerView.layer.cornerRadius = 5;
        _menuContainerView.layer.masksToBounds = YES;
        _menuContainerView.userInteractionEnabled = YES;

        [_menuContainerView addSubview:self.menuTableView];
    }
    return _menuContainerView;
}

- (CCPageIndicatorView *)indicatorView
{
    if (!_indicatorView) {

        CGFloat x = 0;
        if (self.CCAlignment == CCPopMenuAlignmentLeft) {
            x = 35;
        } else if (self.CCAlignment == CCPopMenuAlignmentCenter) {
            x = (CGRectGetWidth(self.bounds) - 20) / 2;
        } else if (self.CCAlignment == CCPopMenuAlignmentRight) {
            x = CGRectGetWidth(self.bounds) - 35;
        }

        _indicatorView = [[CCPageIndicatorView alloc] initWithFrame:CGRectMake(x, _fromTheTop, 20, 8)];
        _indicatorView.color = [UIColor whiteColor];
        _indicatorView.indicatorType = CCPageIndicatorViewTypeTriangle;
    }
    return _indicatorView;
}

- (UITableView *)menuTableView
{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kCCMenuTableViewSapcing, CGRectGetWidth(_menuContainerView.bounds), 0) style:UITableViewStylePlain];
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.separatorColor = [UIColor clearColor];
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.rowHeight = kCCMenuItemViewHeight;
        _menuTableView.scrollEnabled = NO;
    }
    return _menuTableView;
}

/**
 *  @author CC, 2015-10-16
 *
 *  @brief  设置菜单栏背景颜色
 *
 *  @param menuBackgroundColor 颜色值
 */
- (void)setMenuBackgroundColor:(UIColor *)menuBackgroundColor
{
    _menuContainerView.backgroundColor = menuBackgroundColor;
    _indicatorView.color = menuBackgroundColor;
}

/**
 *  @author CC, 2015-10-16
 *
 *  @brief  设置菜单文字颜色
 *
 *  @param menuItemTextColor 颜色值
 */
- (void)setMenuItemTextColor:(UIColor *)menuItemTextColor
{
    _menuItemTextColor = menuItemTextColor;
    [self.menuTableView reloadData];
}

#pragma mark - Life Cycle

- (void)setup
{
    _fromTheTop = 0;
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
    [self addSubview:self.indicatorView];
    [self addSubview:self.menuContainerView];
}

- (id)initWithMenus:(NSArray *)menus
          Alignment:(CCPopMenuAlignment)alignment
{
    self = [super init];
    if (self) {
        self.CCAlignment = alignment;
        self.menuItems = [[NSMutableArray alloc] initWithArray:menus];
        [self setup];
    }
    return self;
}

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [super init];
    if (self) {
        NSMutableArray *menuItems = [[NSMutableArray alloc] init];
        CCPopMenuItem *eachItem;
        va_list argumentList;
        if (firstObj) {
            [menuItems addObject:firstObj];
            va_start(argumentList, firstObj);
            while ((eachItem = va_arg(argumentList, CCPopMenuItem *))) {
                [menuItems addObject:eachItem];
            }
            va_end(argumentList);
        }
        self.menuItems = menuItems;
        [self setup];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint localPoint = [touch locationInView:self];
    if (CGRectContainsPoint(_menuContainerView.frame, localPoint)) {
        [self hitTest:localPoint withEvent:event];
    } else {
        [self dissMissPopMenuAnimatedOnMenuSelected:YES];
    }
}

#pragma mark - UITableView DataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cellIdentifer";
    CCPopMenuItemView *popMenuItemView = (CCPopMenuItemView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!popMenuItemView) {
        popMenuItemView = [[CCPopMenuItemView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }

    if (indexPath.row < self.menuItems.count) {
        [popMenuItemView setupPopMenuItem:self.menuItems[indexPath.row]
                              atIndexPath:indexPath
                                 isBottom:(indexPath.row == self.menuItems.count - 1)];
    }

    popMenuItemView.paddedSeparator = self.paddedSeparator;
    if (self.lineColor)
        popMenuItemView.lineColor = self.lineColor;

    popMenuItemView.textLabel.textColor = self.menuItemTextColor;

    return popMenuItemView;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    [self dissMissPopMenuAnimatedOnMenuSelected:YES];
    if (self.popMenuDidSlectedCompled) {
        self.popMenuDidSlectedCompled(indexPath.row, self.menuItems[indexPath.row]);
    }
}

@end
