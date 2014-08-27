//
//  AKUtil.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 07/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKUtil.h"

@implementation AKUtil

+(UIColor*) color1clear {
    return [UIColor colorWithRed:83/255.0f green:101/255.0f blue:113/255.0f alpha:0.9];
}

+(UIColor*) color1 {
    return [UIColor colorWithRed:83/255.0f green:101/255.0f blue:113/255.0f alpha:1];
}

+(UIColor*) color2 {
    return [UIColor colorWithRed:243/255.0f green:209/255.0f blue:113/255.0f alpha:1];
}

+(UIColor*) color3 {
    return [UIColor colorWithRed:0/255.0f green:166/255.0f blue:154/255.0f alpha:1];
}

+(UIColor*) color4 {
    return [UIColor colorWithRed:241/255.0f green:241/255.0f blue:242/255.0f alpha:1];
}

+(UIColor*) color5 {
    return [UIColor colorWithRed:241/255.0f green:96/255.0f blue:104/255.0f alpha:1];
}


+(UIImage *)downloadImagensInUrls:(NSString *)urlPhoto
{
    NSData *dataImage;
    dataImage=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlPhoto]];
    return [UIImage imageWithData:dataImage];
}

@end
