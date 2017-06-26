//
//  YYTBarButtonItem.h
//  StarPicture
//
//  Created by 曹亚云 on 15-2-13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTBarButtonItem : UIBarButtonItem
/**
 * Create and return a new image-based bar button item.
 * @param baseName baseName for normal image, baseName_focus for highlighted image.
 * @param target The target of the selector
 * @param action The selector to perform when the button is tapped
 *
 * @return An instance of the new button to be used like a normal UIBarButtonItem
 */
+ (YYTBarButtonItem *)barItemWithImageName:(NSString *)baseName
                                   target:(id)target
                                   action:(SEL)action;

/**
 * Create and return a new image-based bar button item.
 * @param image The image of the button to show when unselected. Works best with images under 44x44.
 * @param selectedImage The image of the button to show when the button is tapped. Works best with images under 44x44.
 * @param target The target of the selector
 * @param action The selector to perform when the button is tapped
 *
 * @return An instance of the new button to be used like a normal UIBarButtonItem
 */
+ (YYTBarButtonItem *)barItemWithImage:(UIImage *)image
                        selectedImage:(UIImage *)selectedImage
                               target:(id)target
                               action:(SEL)action;

/**
 * Create and return a new text-based bar button item (like iOS 7).
 * @param title The title string of the button. These have no length limit,
 * but use wisely.
 * @param themeColor The color of the text, much like an app's "theme" color
 in iOS 7. Note: a gray tint is automatically applied for the "down" state.
 * @param target The target of the selector
 * @param action The selector to perform when the button is tapped
 *
 * @return An instance of the new button to be used like a normal UIBarButtonItem
 */
+ (YYTBarButtonItem *)barItemWithTitle:(NSString *)title
                                 font:(UIFont*)font
                           themeColor:(UIColor *)themeColor
                               target:(id)target
                               action:(SEL)action;

- (void)setCustomImage:(UIImage *)image;
- (void)setCustomSelectedImage:(UIImage *)image;
- (void)setCustomAction:(SEL)action;

- (void)setContentEdgeInsets:(UIEdgeInsets)insets;

- (void)startAnimating;
- (void)stopAnimating;
- (void)spin;
- (BOOL)isAnimating;

@property (nonatomic, readonly) UIImage     *customImage;
@property (nonatomic, readonly) UIImage     *customSelectedImage;

@end
