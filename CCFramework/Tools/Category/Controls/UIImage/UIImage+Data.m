//
//  UIImage+Data.m
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

#import "UIImage+Data.h"
#import "UIImage+BUIImage.h"

@implementation UIImage (Data)

/**
 *  @author CC, 15-08-27
 *
 *  @brief  Image转data
 *
 *  @return 返回ImageData
 *
 *  @since 1.0
 */
- (NSData *)data
{
    NSData *datas;
    if (UIImagePNGRepresentation(self))
        datas = UIImagePNGRepresentation(self);
    else
        datas = UIImageJPEGRepresentation(self, 1.0f);
    return datas;
}

/**
 *  @author CC, 15-08-27
 *
 *  @brief  Image转base64位字符串
 *
 *  @return 返回Image字符串
 *
 *  @since <#1.0#>
 */
- (NSString *)base64
{
    return [[self data] base64Encoding];
}

/**
 *  @author CC, 15-08-27
 *
 *  @brief  Image压缩转base64位字符串
 *
 *  @param targetSize 压缩图片大小
 *
 *  @return 返回Image字符串
 *
 *  @since 1.0
 */
- (NSString *)base64: (CGSize)targetSize
{
    return [[self compression:targetSize] base64];
}

/**
 *  @author CC, 15-08-27
 *
 *  @brief  Image压缩转base64位字符串
 *
 *  @param size    压缩图片大小
 *  @param percent 压缩比例
 *
 *  @return 返回Image字符串
 *
 *  @since 1.0
 */
- (NSString *)baset64:(CGSize)size
              Percent:(float)percent
{
    return [[self compressionData:size Percent:percent] base64];
}

@end
