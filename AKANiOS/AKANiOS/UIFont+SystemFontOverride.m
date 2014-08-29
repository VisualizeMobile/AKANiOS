//
//  UIFont+PumaGafferOverride.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 26/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "UIFont+SystemFontOverride.h"

@implementation UIFont (SystemFontOverride)

+(UIFont *)regularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Chalkboard SE" size:size+4];
}

+(UIFont *)boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Chalkboard SE" size:size+4];
}

// Method Swizzling
+(void)load
{
    SEL original = @selector(systemFontOfSize:);
    SEL modified = @selector(regularFontWithSize:);
    SEL originalBold = @selector(boldSystemFontOfSize:);
    SEL modifiedBold = @selector(boldFontWithSize:);
    
    Method originalMethod = class_getClassMethod(self, original);
    Method modifiedMethod = class_getClassMethod(self, modified);
    method_exchangeImplementations(originalMethod, modifiedMethod);
    
    Method originalBoldMethod = class_getClassMethod(self, originalBold);
    Method modifiedBoldMethod = class_getClassMethod(self, modifiedBold);
    method_exchangeImplementations(originalBoldMethod, modifiedBoldMethod);
}

@end
