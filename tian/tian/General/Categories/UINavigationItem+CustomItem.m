//
//  UINavigationItem+CustomItem.m
//  EXO
//
//  Created by cc on 14-1-8.
//  Copyright (c) 2014年 airspuer . All rights reserved.
//

#import "UINavigationItem+CustomItem.h"

@implementation UINavigationItem (CustomItem)
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem{
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        spaceButtonItem.width = -12;
    }else
    {
        spaceButtonItem.width = 0;
    }
    if (_leftBarButtonItem){
        [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem]];
    }  else {
        [self setLeftBarButtonItems:@[spaceButtonItem]];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        spaceButtonItem.width = -12;
    }else
    {
        spaceButtonItem.width = 0;
    }
    if (_rightBarButtonItem) {
        [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem]];
    } else   {
        [self setRightBarButtonItems:@[spaceButtonItem]];
    }
}
@end
