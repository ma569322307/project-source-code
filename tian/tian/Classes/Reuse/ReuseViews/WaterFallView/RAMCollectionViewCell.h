//
//  RAMCollectionViewCell.h
//  RAMCollectionViewFlemishBondLayoutDemo
//
//  Created by Rafael Aguilar Martín on 20/10/13.
//  Copyright (c) 2013 Rafael Aguilar Martín. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTPlazaWaterFallInfo.h"

@interface RAMCollectionViewCell : UICollectionViewCell


- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath andWithModel:(XTPlazaWaterFallInfo *)model;


@end
