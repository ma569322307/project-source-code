
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XTWaterFallViewCellType) {
    XTWaterFallViewCellType_imageAndTopic,
    XTWaterFallViewCellType_imageAndUserAvatar,
    XTWaterFallViewCellType_imageAndDescription,
    XTWaterFallViewCellType_imageAndLike,
    XTWaterFallViewCellType_imageAndCollection,
    XTWaterFallViewCellType_other,
};

FOUNDATION_EXPORT NSString *const RAMCollectionViewFlemishBondHeaderKind;
FOUNDATION_EXPORT NSString *const RAMCollectionViewFlemishBondFooterKind;

@class RAMCollectionViewFlemishBondLayout;

@protocol RAMCollectionViewFlemishBondLayoutDelegate <NSObject>

@optional

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout estimatedSizeForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout estimatedSizeForFooterInSection:(NSInteger)section;

@end

@interface RAMCollectionViewFlemishBondLayout : UICollectionViewLayout

@property (nonatomic, weak) id<RAMCollectionViewFlemishBondLayoutDelegate> delegate;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,assign) XTWaterFallViewCellType cellType;

@end
