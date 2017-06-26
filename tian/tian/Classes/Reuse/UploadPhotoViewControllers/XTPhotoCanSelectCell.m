//
//  XTPhotoCanSelectCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/21.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTPhotoCanSelectCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JKAssets.h"
@interface XTPhotoCanSelectCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation XTPhotoCanSelectCell

-(void)setDisplaying:(BOOL)displaying{
    _displaying = displaying;
    self.backgroundColor = displaying?[UIColor whiteColor]:[UIColor clearColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor clearColor];
        [self imageView];
        
    }
    
    return self;
}

- (void)setAsset:(JKAssets *)asset{
    if (asset) {
        [self.imageView setImage:nil];
        _asset = asset;
        
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:_asset.assetPropertyURL
                 resultBlock:^(ALAsset *asset)
         {
             if (asset){
                 self.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
             }
             else {
                 // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                 
                 [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                        usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                  {
                      [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                          if([result.defaultRepresentation.url isEqual:_asset.assetPropertyURL])
                          {
                              self.imageView.image = [UIImage imageWithCGImage:[result thumbnail]];
                              *stop = YES;
                          }
                      }];
                  }
                  
                                      failureBlock:^(NSError *error)
                  {
                      NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                      
                      
                  }];
             }
             
         }
                failureBlock:^(NSError *error)
         {
             NSLog(@"Error: Cannot load asset - %@", [error localizedDescription]);
             
         }
         ];
    }else {
        [self.imageView setImage:UIIMAGE(@"compose_pic_add")];
    }
    
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        @weakify(self);
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.left.equalTo(self).offset(@1);
            make.right.bottom.equalTo(self).offset(@-1);
        }];
    }
    return _imageView;
}
@end
