//
//  YYTUICommon.h
//  StarPicture
//
//  Created by 曹亚云 on 15-2-12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#ifndef StarPicture_YYTUICommon_h
#define StarPicture_YYTUICommon_h
/**
 * 判断是否是IOS7以后系统
 */
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

/**
 * 判断手机是否为iphone5
 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 * 判断手机是否为iphone4
 */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 * 判断手机是否为iphone6
 */
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 * 判断手机是否为iphone6P
 */
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 * 系统字体获取
 */
#define FONT_SYSTEM(_size_) [UIFont systemFontOfSize:(_size_)]
#define FONT_SYSTEM_BOLD(_size_) [UIFont boldSystemFontOfSize:(_size_)]

/**
 * 自定义字体获取
 */
#define FONT_NAME(_name_, _size_) [UIFont fontWithName:(_name_) size:(_size_)]

/**
 * 根据RGBA各自的值来获取颜色对象
 */
#define COLOR_RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define COLOR_RGB(r, g, b) COLOR_RGBA((r), (g), (b), 1)

/**
 * 根据RGBA的值来获取颜色对象
 * usage:
 *      COLOR_RGB_HEX(0xa1a1a1)
 *      COLOR_RGB_HEX(0xa1a1a1FF)
 */
#define COLOR_RGB_HEX(rgbValue) COLOR_RGB((((rgbValue) & 0xFF0000) >> 16), (((rgbValue) & 0xFF00) >> 8), (((rgbValue) & 0xFF)))
#define COLOR_RGBA_HEX(rgbValue) COLOR_RGBA((((rgbValue) & 0xFF000000) >> 24), (((rgbValue) & 0xFF0000) >> 16), (((rgbValue) & 0xFF00) >> 8), (((rgbValue) & 0xFF)/255.0f))


#define COLOR_CLEAR [UIColor clearColor]

/**
 * 导航栏颜色值
 */
#define NAVIGATION_BAR_BGCOLOR COLOR_RGB_HEX(0x1557a4)
#endif
