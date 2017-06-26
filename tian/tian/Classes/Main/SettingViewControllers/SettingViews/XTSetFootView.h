//
//  XTSetFootView.h
//  StarPicture
//
//  Created by 曹亚云 on 15-3-13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SetFootViewDelegate <NSObject>
@required
- (void)clickDeleteBtn:(UIButton *)button;
@end

@interface XTSetFootView : UIView
@property(nonatomic, weak) IBOutlet UIButton *logoutBtn;
@property(nonatomic, assign)id<SetFootViewDelegate>delegate;

- (IBAction)clickBtn:(UIButton *)button;

@end
