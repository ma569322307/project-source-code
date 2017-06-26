//
//  XTAttentionLayout.m
//  tian
//
//  Created by sz42c on 15/6/5.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAttentionLayout.h"


//以iphone6屏幕宽度为基本宽度
#define XTAttentionCellBaseWidth	103.0f
#define XTAttentionCellBaseHeight	135.0f
#define XTAttentionStartY           17.0f

@interface XTAttentionLayout()

@property(nonatomic, assign) CGFloat leftY;
@property(nonatomic, assign) CGFloat centerY;
@property(nonatomic, assign) CGFloat rightY;

@end

@implementation XTAttentionLayout

- (void)prepareLayout
{
	[super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	_leftY = XTAttentionStartY;
	_centerY = XTAttentionStartY;
	_rightY = XTAttentionStartY;
	
	NSMutableArray* array = [NSMutableArray array];
	NSInteger sections = [self.collectionView numberOfSections];
	
	for (NSInteger i = 0; i < sections; ++i) {
		
		NSInteger items = [self.collectionView numberOfItemsInSection:i];
		
		for (NSInteger j = 0; j < items; ++j) {
			
			NSIndexPath* path = [NSIndexPath indexPathForItem:j inSection:i];
			[array addObject:[self layoutAttributesForItemAtIndexPath:path]];
		}
	}
	
	return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes* att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	
	CGFloat w = [self realCellWidth];
	CGFloat h = [self realCellHeight];
	
	CGRect frame = CGRectMake(0, 9, w, h);
	
	NSInteger index = indexPath.item;
	NSInteger ruler = index % 3;
	
	if (ruler == 0) {
		
		//第一列
		frame.origin.x = XTAttentionStartY;
		frame.origin.y = _leftY;
		
		_leftY += (h + XTAttentionStartY);
		
	} else if (ruler == 1) {
		
		//第二列
		frame.origin.x = (XTAttentionStartY * 2 + w);
		frame.origin.y = _centerY;
		
		_centerY += (h + XTAttentionStartY);
		
	} else {
		
		//第三列
		frame.origin.x = (XTAttentionStartY * 3 + w * 2);
		frame.origin.y = _rightY;
		
		_rightY += (h + XTAttentionStartY);
		
	}
	
	att.frame = frame;
	
	return att;
}

- (CGSize)collectionViewContentSize
{
	CGFloat ruler = _leftY >= _centerY ? _leftY : _centerY;
	
	CGFloat maxH = ruler >= _rightY ? ruler : _rightY;
	
	return CGSizeMake(SCREEN_SIZE.width, maxH);
}

- (CGFloat)realCellHeight
{
    return XTAttentionCellBaseHeight / XTAttentionCellBaseWidth * [self realCellWidth];
}

- (CGFloat)realCellWidth
{
    return (SCREEN_SIZE.width - XTAttentionStartY * 4) / 3;
}
@end
