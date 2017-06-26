//
//  YYTButton.h
//  StarPicture
//
//  Created by 曹亚云 on 15-2-12.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTButton : UIButton
/**
 * Create and return a new image-based button.
 * @param baseName The baseName of image button, baseName for normal state, baseName_focus for hightlighted state.
 *
 * @return An instance of the new button to be used.
 */
+ (YYTButton *)buttonWithImageName:(NSString *)baseName;
/**
 * Create and return a new image-based button.
 * @param imgName imgName for normal state.
 * @param focusImgName imgName for hightlighted state.
 *
 * @return An instance of the new button to be used.
 */
+ (YYTButton *)buttonWithImageName:(NSString *)imgName focusImageName:(NSString *)focusImgName;

- (void)setButtonImageName:(NSString *)baseName;

- (void)setAttributeTitle:(NSString *)title attribute:(NSDictionary *)attr;

- (void)startAnimating;
- (void)stopAnimating;
- (void)spin;

@property (nonatomic) CGFloat animationDuration;
@property (nonatomic, getter = isAnimating) BOOL animating;

@end
