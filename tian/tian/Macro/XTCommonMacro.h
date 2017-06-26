//
//  XTCommonMacro.h
//  StarPicture
//
//  Created by cc on 15-2-12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#ifndef StarPicture_XTCommonMacro_h
#define StarPicture_XTCommonMacro_h

#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define UIIMAGE(imageName) ([UIImage imageNamed:imageName])
#define VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define SETIMAGEBTN(btnObj,normalImageName,highlightedImageName)  btnObj = [UIButton   buttonWithType:UIButtonTypeCustom];\
[btnObj setImage:UIIMAGE(normalImageName) forState:UIControlStateNormal];\
[btnObj setImage:UIIMAGE(highlightedImageName) forState:UIControlStateHighlighted];\

#define INITIMAGEVIEW(imageViewObj, imageName) {\
imageViewObj = [[UIImageView alloc] initWithImage:UIIMAGE(imageName)];\
imageViewObj.frame = CGRectZero;\
}\

#define INITIMAGEVIEWWITHIMAGE(imageViewObj, imageObj) {\
imageViewObj = [[UIImageView alloc] initWithImage:imageObj];\
imageViewObj.frame = CGRectZero;\
}\
//view圆角
#define CHANGETOFILLET(viewObj) viewObj.layer.cornerRadius = viewObj.bounds.size.width/2;\
viewObj.layer.masksToBounds = YES;\

//屏幕size
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

//#define CLog(format, ...) do{                                               \
//fprintf(stderr, "<_%s : _%d> %s\n",                                         \
//[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
//__LINE__, __func__);                                                        \
//(NSLog)((format), ##__VA_ARGS__);                                           \
//fprintf(stderr, "-------\n");                                               \
//} while (0)

//iphone6
#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)

//iphone6P
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)


// 清除NSLog
#ifndef DEBUG
#define NSLog //
#endif

#ifdef DEBUG
#define CLog(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define CLog(s, ...) //
#endif

#endif
