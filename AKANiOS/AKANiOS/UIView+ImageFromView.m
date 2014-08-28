//
//  UIView+ImageFromView.m
//  AKAN
//
//  Created by Matheus Fonseca on 28/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "UIView+ImageFromView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (ImageFromView)

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
