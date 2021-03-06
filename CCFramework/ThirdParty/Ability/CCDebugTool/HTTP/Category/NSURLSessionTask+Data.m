//
//  NSURLSessionTask+Data.m
//  CCFramework
//
//  Created by CC on 16/3/5.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "NSURLSessionTask+Data.h"
#import <objc/runtime.h>

@implementation NSURLSessionTask (Data)

- (NSString *)taskDataIdentify
{
    return objc_getAssociatedObject(self, @"taskDataIdentify");
}
- (void)setTaskDataIdentify:(NSString *)name
{
    objc_setAssociatedObject(self, @"taskDataIdentify", name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableData *)responseDatas
{
    return objc_getAssociatedObject(self, @"responseDatas");
}

- (void)setResponseDatas:(NSMutableData *)data
{
    objc_setAssociatedObject(self, @"responseDatas", data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
