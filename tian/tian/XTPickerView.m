//
//  XTPickerView.m
//  tian
//
//  Created by huhuan on 15/6/13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPickerView.h"
#import "UIImage+rn_Blur.h"
#import "UIImage+Capture.h"

@interface XTPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, weak) IBOutlet UIView *pickerViewBgView;
@property (nonatomic, strong) UIImageView *realImageView;
@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, strong) UIView *maskView;



@property (nonatomic, weak) IBOutlet UIView *pickerBgView;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property (nonatomic, copy) NSArray *data;
@property (nonatomic, assign) NSInteger lastSelectedRow;
@property (nonatomic, assign) NSInteger selectedRow;
//记录选择的列
@property (nonatomic, assign) NSInteger selectedComponent;
@property (nonatomic, assign) NSInteger lastSelectedComponent;
@end

@implementation XTPickerView

+ (XTPickerView *)pickerViewWithDataSource:(NSArray *)dataArray {
    XTPickerView *pickerView = [[NSBundle mainBundle] loadNibNamed:@"XTPickerView" owner:nil options:nil][0];
    pickerView.data = dataArray;
    [pickerView.pickerViewBgView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
    }];
    
    [pickerView.pickerBgView updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(SCREEN_SIZE.height);
        make.left.offset(@10);
        make.right.offset(@-10);
        make.height.equalTo(@200);
    }];
    
    [pickerView.pickerView updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(@0);
        make.left.offset(@0);
        make.right.offset(@0);
        make.bottom.equalTo(pickerView.confirmButton.mas_top);
    }];
    
    [pickerView.cancelButton updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(@0);
        make.left.offset(@0);
        make.right.equalTo(pickerView.confirmButton.mas_left);
        make.width.equalTo(pickerView.confirmButton);
        make.height.equalTo(@50);
    }];
    
    [pickerView.confirmButton updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(@0);
        make.left.equalTo(pickerView.cancelButton.mas_right);
        make.right.offset(@0);
        make.width.equalTo(pickerView.cancelButton);
        make.height.equalTo(@50);
    }];
    
    pickerView.lastSelectedRow = -1;
 
    return pickerView;
}

- (IBAction)cancelClick:(id)sender {
    [self hide];
}

- (IBAction)confirmClick:(id)sender {
    [self hide];
    NSLog(@"第一列%zd，第二列%zd",self.selectedComponent,self.selectedRow);
    if((self.pickerSelectedBlock && (self.lastSelectedRow != self.selectedRow || self.lastSelectedComponent != self.selectedComponent)) || self.alwaysRefresh) {
        self.lastSelectedRow = self.selectedRow;
        self.lastSelectedComponent = self.selectedComponent;
        if (self.componentNumber == 2) {
            NSDictionary *dic = @{
                                  @"language" : self.data[0][self.selectedComponent],
                                  @"artist" : self.data[1][self.selectedRow]
                                  };
            self.pickerSelectedBlock(dic);
            return;
        }
        self.pickerSelectedBlock(self.data[self.selectedRow]);
    }
}

- (void)show {

    UIView *bgView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    bgView.backgroundColor = [UIColor blackColor];
    UIImage *windowSnap = [self snapshot];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:windowSnap];
    [bgView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
    }];

    [imageView layoutIfNeeded];
    
    //添加不模糊图片和模糊图片到view上
    UIImage *realImage = windowSnap;
    self.realImageView = [[UIImageView alloc] initWithImage:realImage];
    
    UIImage *blurImage = [[UIImage captureShotWithView:bgView] applyBlurWithRadius:3 tintColor:[UIColor colorWithWhite:0 alpha:0.10] saturationDeltaFactor:1.0 maskImage:nil];
    self.blurImageView = [[UIImageView alloc] initWithImage:blurImage];
    
    self.blurImageView.alpha = 0.f;
    
    [self.pickerViewBgView addSubview:self.realImageView];
    [self.pickerViewBgView addSubview:self.blurImageView];
    
    
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.pickerViewBgView addSubview:self.maskView];
    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.maskView layoutIfNeeded];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
    }];
    [self.pickerBgView layoutIfNeeded];
    
    [self.realImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.blurImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(-20, -20, -20, -20));
    }];
    [self.realImageView layoutIfNeeded];
    [self.blurImageView layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blurImageView.alpha = 1.f;
        self.maskView.alpha = 0.2;
        
        [self.realImageView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
        }];
        
        [self.blurImageView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.pickerBgView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(SCREEN_SIZE.height-200-20);
            make.left.offset(@10);
            make.right.offset(@-10);
            make.height.equalTo(@200);
        }];
        [self.realImageView layoutIfNeeded];
        [self.blurImageView layoutIfNeeded];
        [self.pickerBgView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self layoutIfNeeded];
    }];
    
}

- (void)hide {

    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        self.blurImageView.alpha = 0.f;
        self.maskView.alpha = 0.f;
        [self.realImageView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.blurImageView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(-20, -20, -20, -20));
        }];
        
        [self.pickerBgView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(SCREEN_SIZE.height);
            make.left.offset(@10);
            make.right.offset(@-10);
            make.height.equalTo(@200);
        }];
        [self.realImageView layoutIfNeeded];
        [self.blurImageView layoutIfNeeded];
        [self.pickerBgView layoutIfNeeded];
    } completion:^(BOOL finished) {

        for(UIView *v in [self.pickerViewBgView subviews]) {
            [v removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
}

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, YES, 0);
    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:[[UIApplication sharedApplication].delegate window].bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.componentNumber == 2) {
        return self.data.count;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.componentNumber == 2) {
        NSArray *componentList = self.data[component];
        return componentList.count;
    }
    return [self.data count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.componentNumber == 2) {
        NSArray *componentList = self.data[component];
        return componentList[row][@"text"];
    }
    return self.data[row][@"text"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.componentNumber == 2) {
        if (component == 0) {
            self.selectedComponent = row;
            return;
        }
    }
    self.selectedRow = row;
}

@end
