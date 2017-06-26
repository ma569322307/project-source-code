//
//  YYTActionSheet.h
//  Promp
//
//  Created by Jiajun Zheng on 15/7/3.
//  Copyright (c) 2015年 zjProject. All rights reserved.
//

//#import "YYTHUD.h"
#import "XTActionBase.h"

@interface YYTActionSheet : XTActionBase
/// 显示一系列标题
+(void)showWithTitleArray:(NSArray *)titles withCompletionBlock:(AlertViewBlock)completion;
///// 显示一系列标题有遮盖
//+(void)showHasMaskWithTitleArray:(NSArray *)titles withCompletionBlock:(AlertViewBlock)completion;
@end
