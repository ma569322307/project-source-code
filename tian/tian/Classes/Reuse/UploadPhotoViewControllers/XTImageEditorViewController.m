//
//  XTImageEditorViewController.m
//  tian
//
//  Created by huhuan on 15/7/20.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTImageEditorViewController.h"

@interface XTImageEditorViewController ()

@property (nonatomic, assign) CGSize imageSize;

@end

@implementation XTImageEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

+ (XTImageEditorViewController *)editorWithImage:(UIImage *)image {
    
    XTImageEditorViewController *editorVC = [[XTImageEditorViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    editorVC.avoidEmptySpaceAroundImage = YES;
    editorVC.moveAndScaleLabel.text = @"";
    [editorVC.cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [editorVC.chooseButton setTitle:@"确定" forState:UIControlStateNormal];
    NSLog(@"%@",@(image.scale));
    editorVC.imageSize = image.size;
    return editorVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
