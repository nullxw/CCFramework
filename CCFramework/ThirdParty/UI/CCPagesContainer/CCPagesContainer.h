//
//  CCPageContainerScrollView.h
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

#import <UIKit/UIKit.h>

/**
 *  @author CC, 15-09-11
 *
 *  @brief  CCPageIndicatorView类型
 *
 *  @since 1.0
 */
typedef NS_ENUM(NSInteger, CCPageIndicatorViewType) {
    /** 倒三角 **/
    CCPageIndicatorViewTypeInvertedTriangle = 0,
    /** 水平横线 **/
    CCPageIndicatorViewTypeHorizontalLine,
    /** 正三角 */
    CCPageIndicatorViewTypeTriangle,
    /** 横粗线 */
    CCPageIndicatorViewTypeLine,
};

/**
 *  @author CC, 15-09-11
 *
 *  @brief  CCPageContainer按钮类型
 *
 *  @since 1.0
 */
typedef NS_ENUM(NSInteger, CCPageContaiinerTopBarType) {
    /** 纯文本 **/
    CCPageContaiinerTopBarTypeText = 0,
    /** 上图下文本 **/
    CCPageContaiinerTopBarTypeUPMapNextText,
    /** 左文右图 */
    CCPageContaiinerTopBarTypeLeftTextRightMap,
    /** 左图右文本 **/
    CCPageContaiinerTopBarTypeLeftMapRightText,
};


@interface CCPagesContainer : UIViewController

/**
 The view controllers to be displayed in DAPagesContainer in order they appear in this array.
 @discussion view objects for all the view controllers will be resized to fit the container bounds together with topBar. Normally you should have more than one view controller.
 @warning all view controllers should have nonempty titles which are displayed in the top bar.
 */
@property(strong, nonatomic) NSArray *viewControllers;

/**
 An index of the selected view controller.
 */
@property(assign, nonatomic) NSUInteger selectedIndex;

/**
 A hight of the top bar. Every time this value is changed, view objects for all the view controllers are resized.
 This is 44. by default.
 */
@property(assign, nonatomic) NSUInteger topBarHeight;

/**
 *  @author C C, 2015-09-23
 *
 *  @brief  菜单是否显示顶部
 */
@property(assign, nonatomic) BOOL isBarTop;
/**
 *  @author CC, 15-09-29
 *
 *  @brief  是否铺满
 */
@property(assign, nonatomic) BOOL IsCoverd;

/**
 *  @author C C, 2015-09-29
 *
 *  @brief  隐藏菜单栏
 */
@property(assign, nonatomic) BOOL HidetabBar;

/**
 *  @author C C, 2015-09-29
 *
 *  @brief  是否可以滑动
 */
@property(assign, nonatomic) BOOL scrollEnabled;

@property(assign, nonatomic) CGFloat topBarItemsOffset;

@property(assign, nonatomic) CCPageContaiinerTopBarType topBarType;

@property(strong, nonatomic) NSArray *topBarImageAry;
@property(strong, nonatomic) NSArray *topBarSelectedImageAry;

@property(assign, nonatomic) CCPageIndicatorViewType indicatorType;

/**
 *  @author C C, 2015-09-23
 *
 *  @brief  是否可以反弹
 *
 */
@property(assign, nonatomic) BOOL bounces;

/**
 An optional image page for the page indicator view
 This is {22., 9.} by default.
 */
@property(strong, nonatomic) UIImage *pageIndicatorImage;

/**
 A size of the page indicator view.
 @discussion if this property is not nil 'pageIndicatorViewSize' property value will be ignored, size for the page indicator image view will equal the size of 'pageIndicatorImage'
 */
@property(assign, nonatomic) CGSize pageIndicatorViewSize;

/**
 An optional background image of the top bar.
 */
@property(strong, nonatomic) UIImage *topBarBackgroundImage;

/**
 A background color of the top bar.
 This is black by default.
 */
@property(strong, nonatomic) UIColor *topBarBackgroundColor;

@property(strong, nonatomic) UIColor *topIndicatiorColor;

/**
 A font for all the buttons displayed in the top bar.
 This is system font of sixe 12. by default.
 */
@property(strong, nonatomic) UIFont *topBarItemLabelsFont;

/**
 A color of all the view titles displayed on the top bar except for the selected one.
 This is light gray by default.
 */
@property(strong, nonatomic) UIColor *pageItemsTitleColor;

/**
 A color of the selected view titles displayed on the top bar.
 This is white by default.
 */
@property(strong, nonatomic) UIColor *selectedPageItemTitleColor;

/**
 Changes 'selectedIndex' property value and navigates to the newly selected view controller
 @param selectedIndex This mathod throws exeption if selectedIndex is out of range of the 'viewControllers' array
 @param animated Defines whether to present the corresponding view controller animated
 @discussion If 'animated' is YES and the newly selected view is not "the closest neighbor" of the previous selected view, all the intermediate views will be skipped for the sake of nice animation
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

/**
 Makes sure that view objects for all the view controllers are properly resized to fit the container bounds after device orientation was changed
 */
- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation;

@end