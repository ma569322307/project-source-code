//
//  XTShareModel.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/10.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTShareModel.h"

@implementation XTShareModel
+(instancetype)shareModelWithShareType:(XTShareSheetItemType)type{
    if (type == XTShareSheetItemCancelTop) {
        //取消置顶
        XTShareModel *cancelTop = [[self alloc] initWithTitle:@"取消置顶" imageName:@"ShareTop"];
        NSString *temp = cancelTop.imageName;
        cancelTop.imageName = cancelTop.imageNameSelected;
        cancelTop.imageNameSelected = temp;
        return cancelTop;
    }
    if (type == XTShareSheetItemTop) {
        return [[self alloc] initWithTitle:@"置顶" imageName:@"ShareTop"];
    }
    if (type == XTShareSheetItemTips){
        return [[self alloc] initWithTitle:@"打赏" imageName:@"ShareTips"];
    }
    if (type == XTShareSheetItemWarning) {
        return [[self alloc] initWithTitle:@"举报" imageName:@"ShareWarning"];
    }
    if (type == XTShareSheetItemMove) {
        return [[self alloc] initWithTitle:@"移动" imageName:@"ShareMoving"];
    }
    return [[self alloc] initWithTitle:@"删除" imageName:@"ShareDelete"];
}

-(instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName{
    if (self = [super init]) {
        self.title = title;
        self.imageName = imageName;
        self.imageNameSelected = [NSString stringWithFormat:@"%@_sel",imageName];
    }
    return self;
}

+(NSArray *)shareModelOtherListWithShareType:(XTShareSheetItemType)type{
    NSMutableArray *arryM = [NSMutableArray array];
    if (type & XTShareSheetItemTop) {
        XTShareModel *model = [self shareModelWithShareType:XTShareSheetItemTop];
        [arryM addObject:model];
    }
    if (type & XTShareSheetItemCancelTop) {
        XTShareModel *model = [self shareModelWithShareType:XTShareSheetItemCancelTop];
        [arryM addObject:model];
    }
    if (type & XTShareSheetItemTips) {
        XTShareModel *model = [self shareModelWithShareType:XTShareSheetItemTips];
        [arryM addObject:model];
    }
    if (type & XTShareSheetItemWarning) {
        XTShareModel *model = [self shareModelWithShareType:XTShareSheetItemWarning];
        [arryM addObject:model];
    }
    if (type & XTShareSheetItemMove) {
        XTShareModel *model = [self shareModelWithShareType:XTShareSheetItemMove];
        [arryM addObject:model];
    }
    if (type & XTShareSheetItemDelete) {
        XTShareModel *model = [self shareModelWithShareType:XTShareSheetItemDelete];
        [arryM addObject:model];
    }
    return arryM.copy;
}
+(NSArray *)shareModelListWithShareType:(XTShareSheetItemType)type{
    XTShareModel *weixin = [[self alloc] initWithTitle:@"微信" imageName:@"ShareWeiXin"];
    XTShareModel *pengyouquan = [[self alloc] initWithTitle:@"朋友圈" imageName:@"SharePengYouQuan"];
    XTShareModel *qq = [[self alloc] initWithTitle:@"QQ" imageName:@"ShareQQ"];
    XTShareModel *qqZone = [[self alloc] initWithTitle:@"QQ空间" imageName:@"ShareQQZone"];
    XTShareModel *status = [[self alloc] initWithTitle:@"微博" imageName:@"ShareStatus"];
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:@[weixin,pengyouquan,qq,qqZone,status]];
    [arrayM addObjectsFromArray:[self shareModelOtherListWithShareType:type]];
    return arrayM.copy;
}
@end
