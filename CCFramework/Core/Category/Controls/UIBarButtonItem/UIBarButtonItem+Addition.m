//
//  UIBarButtonItem+Addition.m
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
#import "UIBarButtonItem+Addition.h"
#import "UIButton+BUIButton.h"
#import "NSString+BNSString.h"
#import "UIControl+BUIControl.h"

@implementation UIBarButtonItem (Addition)

/**
 *  @author CC, 2016-12-30
 *  
 *  @brief  设置背景图片
 *
 *  @param backgroundImage 图片路径
 */
- (void)setItemImage:(NSString *)backgroundImage
{
    UIButton *button = self.customView;
    if (button) {
        UIImage *image = [UIImage imageNamed:backgroundImage];
        if (image)
            [button setImage:backgroundImage];
    }
}


/**
 *  @author CC, 15-09-28
 *
 *  @brief  图片按钮
 *
 *  @param backgroundImage 背景图片
 *  @param target          当前页面
 *  @param action          页面回调函数
 *
 *  @return 返回当前对象
 */
+ (UIBarButtonItem *)filletWithAction:(NSString *)backgroundImage
                     placeholderImage:(NSString *)placeholder
                               Target:(id)target
                               Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [UIImage imageNamed:backgroundImage];
    if (!image)
        image = [UIImage imageNamed:placeholder];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [[button layer] setCornerRadius:15];
    [[button layer] setMasksToBounds:YES];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itme = [[UIBarButtonItem alloc] initWithCustomView:button];
    return itme;
}

/**
 *  @author CC, 2016-01-04
 *  
 *  @brief  图片文
 *
 *  @param title                 标题
 *  @param backgroundImage       背景图片
 *  @param onButtonTouchUpInside 回调函数
 *
 *  @return 返回当前对象
 */
+ (UIBarButtonItem *)buttonItemWithTitle:(NSString *)title
                         BackgroundImage:(NSString *)backgroundImage
                didOnButtonTouchUpInside:(void (^)(UIButton *sender))onButtonTouchUpInside
{
    UIButton *button = [UIButton buttonWithTitleBackgroundImage:title BackgroundImage:backgroundImage];
    button.frame = CGRectMake(0, 0, [title calculateTextWidthHeight:[UIFont systemFontOfSize:[UIFont systemFontSize]]].width + 40, 40);
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:onButtonTouchUpInside];
    UIBarButtonItem *itme = [[UIBarButtonItem alloc] initWithCustomView:button];
    return itme;
}

/**
 *  @author C C, 2015-09-28
 *
 *  @brief  左图右文
 *
 *  @param backgroundImage 左图
 *  @param title           文字
 *  @param target          当前页面
 *  @param action          页面回调函数
 *
 *  @return 返回当前对象
 */
+ (UIBarButtonItem *)buttonItemWithImageTitle:(NSString *)backgroundImage
                                         Tile:(NSString *)title
                                       Target:(id)target
                                       Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithImageTitle:backgroundImage
                                                Title:title
                                                Frame:CGRectMake(0, 0, [title calculateTextWidthHeight:[UIFont systemFontOfSize:[UIFont systemFontSize]]].width + 40, 40)];
    [button setTitleColor:[UIColor whiteColor]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itme = [[UIBarButtonItem alloc] initWithCustomView:button];
    return itme;
}

/**
 *  @author CC, 2016-01-04
 *  
 *  @brief  左图右文
 *
 *  @param backgroundImage       左图
 *  @param title                 标题
 *  @param onButtonTouchUpInside 回调函数
 *
 *  @return 返回当前对象
 */
+ (UIBarButtonItem *)buttonItemWithImageTitle:(NSString *)backgroundImage
                                         Tile:(NSString *)title
                     didOnButtonTouchUpInside:(void (^)(UIButton *sender))onButtonTouchUpInside
{
    UIButton *button = [UIButton buttonWithImageTitle:backgroundImage
                                                Title:title
                                                Frame:CGRectMake(0, 0, [title calculateTextWidthHeight:[UIFont systemFontOfSize:[UIFont systemFontSize]]].width + 40, 40)];
    
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:onButtonTouchUpInside];
    [button setTitleColor:[UIColor whiteColor]];
    UIBarButtonItem *itme = [[UIBarButtonItem alloc] initWithCustomView:button];
    return itme;
}

@end
