

#import "RAMCollectionViewFlemishBondLayout.h"
#import "XTWaterFallPicInfo.h"

#define XTWaterViewSpace 16
#define XTWaterViewBottomHeight 84
#define XTWaterViewImageAndUserAvatarHeight 43
static NSString *const RAMCollectionViewFlemishBondCellKind = @"RAMCollectionViewFlemishBondCellKind";
NSString *const RAMCollectionViewFlemishBondHeaderKind = @"RAMCollectionViewFlemishBondHeaderKind";
NSString *const RAMCollectionViewFlemishBondFooterKind = @"RAMCollectionViewFlemishBondFooterKind";

@interface RAMCollectionViewFlemishBondLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic, strong) NSDictionary *headerLayoutInfo;
@property (nonatomic, strong) NSDictionary *footerLayoutInfo;
@property (nonatomic, strong) NSMutableDictionary *headerSizes;
@property (nonatomic, strong) NSMutableDictionary *footerSizes;
@property (nonatomic, readonly) CGFloat cellWidth;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, readonly) NSInteger numberOfSections;
@property (nonatomic, readonly) NSInteger totalGroupsInCollectionView;
@property (nonatomic, readonly) CGFloat totalHeaderHeight;
@property (nonatomic, readonly) CGFloat totalFooterHeight;

@property (nonatomic, assign) NSUInteger numberOfElements;
@property (nonatomic, assign) CGFloat highlightedCellWidth;
@property (nonatomic, assign) CGFloat highlightedCellHeight;


@end

@implementation RAMCollectionViewFlemishBondLayout

#pragma mark - Lifecycle
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Custom Getter
- (CGFloat)cellWidth
{
    return self.collectionView.bounds.size.width - self.highlightedCellWidth;
}

- (CGFloat)cellHeight
{
    return self.highlightedCellHeight / (self.numberOfElements - 1);
}

- (NSInteger)numberOfSections
{
    return [self.collectionView numberOfSections];
}

- (NSInteger)totalGroupsInCollectionView
{
    NSInteger totalGroups = 0;
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        totalGroups += [self totalGroupsAtIndexPath:indexPath];
    }
    
    return totalGroups;
}

- (CGFloat)totalHeaderHeight
{
    CGFloat totalHeight = 0.0f;
    
    for (NSIndexPath *indexPath in self.headerSizes) {
        NSValue *value = [self.headerSizes objectForKey:indexPath];
        
        CGSize size = [value CGSizeValue];
        
        totalHeight += size.height;
    }
    
    return totalHeight;
}

- (CGFloat)totalFooterHeight
{
    CGFloat totalHeight = 0.0f;
    
    for (NSIndexPath *indexPath in self.footerSizes) {
        NSValue *value = [self.footerSizes objectForKey:indexPath];
        
        CGSize size = [value CGSizeValue];
        
        totalHeight += size.height;
    }
    
    return totalHeight;
}

#pragma mark - Setup
- (void)setup
{
    // Default values
    self.numberOfElements = 3;
    self.highlightedCellHeight = 200.0f;
    self.highlightedCellWidth = 0.0f;
}

#pragma mark - UICollectionViewLayout
+ (Class)layoutAttributesClass
{
    return [UICollectionViewLayoutAttributes class];
}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerLayoutDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *footerLayoutDictionary = [NSMutableDictionary dictionary];
    
    self.headerSizes = [NSMutableDictionary dictionary];
    self.footerSizes = [NSMutableDictionary dictionary];
    [self checkHighlightedCellWidth];
    
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:section];
        if(itemsCount == 0) {
            CGSize size = [self estimatedSizeForHeaderInSection:section];
            
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                self.headerSizes[firstIndexPath] = [NSValue valueWithCGSize:size];
                
                UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes
                                                                      layoutAttributesForSupplementaryViewOfKind:RAMCollectionViewFlemishBondHeaderKind
                                                                      withIndexPath:firstIndexPath];
                headerAttributes.frame = [self frameForHeaderAtIndexPath:firstIndexPath withSize:size];
                
                headerLayoutDictionary[firstIndexPath] = headerAttributes;
            }
        }
        
        for (NSInteger item = 0; item < itemsCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            if (indexPath.item == 0) {
                CGSize size = [self estimatedSizeForHeaderInSection:section];
                
                if (!CGSizeEqualToSize(size, CGSizeZero)) {
                    self.headerSizes[indexPath] = [NSValue valueWithCGSize:size];
                    
                    UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes
                                                                          layoutAttributesForSupplementaryViewOfKind:RAMCollectionViewFlemishBondHeaderKind
                                                                          withIndexPath:indexPath];
                    headerAttributes.frame = [self frameForHeaderAtIndexPath:indexPath withSize:size];
                    
                    headerLayoutDictionary[indexPath] = headerAttributes;
                }
            } else if([self isTheLastItemAtIndexPath:indexPath]) {
                CGSize size = [self estimatedSizeForFooterInSection:section];
                
                if (!CGSizeEqualToSize(size, CGSizeZero)) {
                    self.footerSizes[indexPath] = [NSValue valueWithCGSize:size];
                    
                    UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes
                                                                          layoutAttributesForSupplementaryViewOfKind:RAMCollectionViewFlemishBondFooterKind
                                                                          withIndexPath:indexPath];
                    footerAttributes.frame = [self frameForFooterAtIndexPath:indexPath withSize:size];
                    
                    footerLayoutDictionary[indexPath] = footerAttributes;
                }
            }
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
            
            //不规则的瀑布流
            CGFloat width = ([UIScreen mainScreen].bounds.size.width - XTWaterViewSpace*3)/2.0f;
            
            CGFloat height = 0;
            switch (self.cellType) {
                case XTWaterFallViewCellType_imageAndDescription:
                {
                  XTImageInfo *imgInfo = self.array[indexPath.item];
                    if (imgInfo.width > 0 && imgInfo.height > 0) {
                        if (imgInfo.height>imgInfo.width*1.5) {
                            height =  width*1.5*imgInfo.width/imgInfo.width;
                        }else{
                            height =  width*imgInfo.height/imgInfo.width;
                        }
                    }
                   // NSString *ttext = [imgInfo.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    NSString *ttext = [imgInfo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                    if ((ttext == nil|| ttext.length<1||[ttext isEqualToString:@""])&&([imgInfo.commendCount isEqualToString:@"0"]&&[imgInfo.commentCount isEqualToString:@"0"]))
//                    {
//                        
//                    }
//                    else if (!(ttext == nil&&ttext.length<1&&[ttext isEqualToString:@""]))
//                    {
//                        height+=XTWaterViewBottomHeight/2;
//                        
//                    }else if (!([imgInfo.commendCount isEqualToString:@"0"]) || !([imgInfo.commentCount isEqualToString:@"0"]))
//                    {
//                        height+=XTWaterViewBottomHeight/2;
//                    }
//                    else
//                    {
//                        height+=XTWaterViewBottomHeight;
//                    }
                    BOOL needTextSpace = NO;
                    BOOL needDescriptionSpace = NO;
                    if (!(ttext == nil||ttext.length<1||[ttext isEqualToString:@""]))
                    {
                        height+=XTWaterViewBottomHeight/2;
                        needTextSpace = YES;
                        
                    }
                    if ((imgInfo.commendCount && !([imgInfo.commendCount isEqualToString:@"0"])) || (imgInfo.commendCount && !([imgInfo.commentCount isEqualToString:@"0"])))
                    {
                        height+=XTWaterViewBottomHeight/2;
                        needDescriptionSpace = YES;
                    }
                    // 都不需要
                    if (!needTextSpace && !needDescriptionSpace) {
                        height+=XTWaterViewSpace;
                    }
                    // 都需要
                    if (needTextSpace && needDescriptionSpace) {
                        height -=XTWaterViewBottomHeight/2;
                        height += 6;
                    }
                    break;
                }
                case XTWaterFallViewCellType_imageAndUserAvatar:
                {
                    XTWaterFallPicInfo *waterFallInfo = self.array[indexPath.item];
                    if (waterFallInfo.width>0&&waterFallInfo.height>0) {
                        if (waterFallInfo.height>waterFallInfo.width*1.5) {
                            height =  width*1.5*waterFallInfo.width/waterFallInfo.width +XTWaterViewImageAndUserAvatarHeight;
                        }else{
                        height =width *waterFallInfo.height/waterFallInfo.width+ XTWaterViewImageAndUserAvatarHeight;
                        }
                        
                    }
                    
                    break;
                }
                case XTWaterFallViewCellType_imageAndTopic:
                {
                    XTWaterFallPicInfo *wfallPicInfo = self.array[indexPath.item];
                    XTImageInfo *imgInfo = [wfallPicInfo.images firstObject];
                    if (imgInfo.width > 0 && imgInfo.height > 0) {
                        if (imgInfo.height>imgInfo.width*1.5) {
                            height =  width*1.5*imgInfo.width/imgInfo.width +XTWaterViewBottomHeight/2;
                        }else{
                        height =  width*imgInfo.height/imgInfo.width +XTWaterViewBottomHeight/2;
                        }
                    }
                    break;
                }
                case XTWaterFallViewCellType_imageAndLike:
                {
                    XTImageInfo *imgInfo = self.array[indexPath.item];
                    if (imgInfo.width > 0 && imgInfo.height > 0) {
                        if (imgInfo.height>imgInfo.width*2) {
                            height =  width*2*imgInfo.width/imgInfo.width;
                        }else{
                        height =  width*imgInfo.height/imgInfo.width;
                        }
                    }
                    NSString *ttext = [imgInfo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (!(ttext == nil||ttext.length<1||[ttext isEqualToString:@""]))
                    {
                        height+= XTWaterViewBottomHeight/2;
                        
                    }else{
                        height += XTWaterViewSpace;
                    }
                    break;
                }
                case XTWaterFallViewCellType_imageAndCollection:
                {
                    XTImageInfo *imgInfo = self.array[indexPath.item];
                    if (imgInfo.width > 0 && imgInfo.height > 0) {
                        if (imgInfo.height>imgInfo.width*1.5) {
                            height =  width*1.5*imgInfo.width/imgInfo.width +XTWaterViewBottomHeight/2;
                        }else{
                        height =  width*imgInfo.height/imgInfo.width +XTWaterViewBottomHeight/2;
                        }
                    }
                    break;
                }
                case XTWaterFallViewCellType_other:
                {
                    
                    XTImageInfo *imgInfo = self.array[indexPath.item];
                    if (imgInfo.width > 0 && imgInfo.height > 0) {
                        if (imgInfo.height>imgInfo.width*1.5) {
                            height =  width*1.5*imgInfo.width/imgInfo.width +XTWaterViewBottomHeight;
                        }else{
                        height =  width*imgInfo.height/imgInfo.width +XTWaterViewBottomHeight;
                        }
                    }
                    break;
                }
                default:
                    break;
            }
            if (height == 0) {
                height = 200 +XTWaterViewBottomHeight;
            }
            
            
            if (indexPath.item == 0) {
                leftY = [self getYAtIndexPath:indexPath];
                rightY = 0;
                NSInteger x = XTWaterViewSpace;
                NSInteger y = leftY;
                attributes.frame = CGRectMake(x, y, width, height);
                leftY = leftY + height;
                
            } else if (indexPath.item == 1) {
                rightY = [self getYAtIndexPath:indexPath];
                NSInteger x = (width + XTWaterViewSpace + XTWaterViewSpace);
                NSInteger y = rightY;
                attributes.frame = CGRectMake(x, y, width, height);
                
                rightY = rightY + height;
                
            } else {
                
                if (leftY > rightY) {
                    NSInteger x = (width + XTWaterViewSpace + XTWaterViewSpace);
                    NSInteger y = rightY;
                    attributes.frame = CGRectMake(x, y, width, height);
                    
                    rightY = rightY + height;
                } else {
                    NSInteger x = XTWaterViewSpace;
                    NSInteger y = leftY;
                    attributes.frame = CGRectMake(x, y, width, height);
                    
                    leftY = leftY + height;
                }
            }
            cellLayoutDictionary[indexPath] = attributes;
        
        }
    }
    
    newLayoutDictionary[RAMCollectionViewFlemishBondCellKind] = cellLayoutDictionary;
    
    newLayoutDictionary[RAMCollectionViewFlemishBondHeaderKind] = headerLayoutDictionary;
    newLayoutDictionary[RAMCollectionViewFlemishBondFooterKind] = footerLayoutDictionary;
    
    self.layoutInfo = newLayoutDictionary;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[RAMCollectionViewFlemishBondCellKind][indexPath];
}

static NSInteger leftY = 0;
static NSInteger rightY = 0;

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[kind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    if ([self itemCountAtSection:0] == 0) {
        CGSize headerSize = [self estimatedSizeForHeaderInSection:0];
        headerSize.height+=64;
		return headerSize;
	}
   return CGSizeMake([UIScreen mainScreen].bounds.size.width, (leftY > rightY ? leftY : rightY));
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (CGRect)frameForHeaderAtIndexPath:(NSIndexPath *)indexPath withSize:(CGSize)size
{
    CGRect frame = CGRectZero;
    if (indexPath.section == 0) {
        frame.origin.y = 0;
    } else {
        frame.origin.y = [self getYAtIndexPath:indexPath] - size.height;
    }
    frame.size = size;
    
    return frame;
}

- (CGRect)frameForFooterAtIndexPath:(NSIndexPath *)indexPath withSize:(CGSize)size
{
    CGRect frame = CGRectZero;
    frame.origin.y = [self getYAtIndexPath:indexPath] + self.highlightedCellHeight;
    frame.size = size;
    
    return frame;
}

- (CGFloat)getYAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentGroup = [self currentGroupAtIndexPath:indexPath];
    CGFloat yValue = 0.0f;
    NSIndexPath *indexPathFirstElementCurrentSection = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
    if ([self isHighLightedElementAtIndexPath:indexPath]) {
        yValue = (currentGroup - 1) * self.highlightedCellHeight + [self heightHeaderAtIndexPath:indexPathFirstElementCurrentSection];
    } else {
        NSInteger position;
        if (indexPath.row <= self.numberOfElements) {
            position = (indexPath.row - 1);
        } else {
            NSInteger maxElement = self.numberOfElements * currentGroup;
            position = (indexPath.row - 1) - (maxElement - self.numberOfElements);
        }
        
        yValue = ((currentGroup - 1) * self.highlightedCellHeight) + (self.cellHeight * position) + [self heightHeaderAtIndexPath:indexPathFirstElementCurrentSection];
    }
    
    if (indexPath.section > 0) {
        yValue += (self.highlightedCellHeight * indexPath.section * [self totalGroupsAtIndexPath:indexPath]) + [self headerAndFooterHeightsPreviouslyAtIndexPath:indexPath];
    }

    return yValue+XTWaterViewSpace;
}

- (CGFloat)headerAndFooterHeightsPreviouslyAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat totalHeight = 0.f;
    for (NSInteger section = 0; section < indexPath.section; section++) {
        CGSize sizeHeader = [self estimatedSizeForHeaderInSection:section];
        CGSize sizeFooter = [self estimatedSizeForFooterInSection:section];
        
        totalHeight += sizeHeader.height + sizeFooter.height;
    }
    
    return totalHeight;
}

- (CGSize)estimatedSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeZero;
    
    if ([self.delegate conformsToProtocol:@protocol(RAMCollectionViewFlemishBondLayoutDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForHeaderInSection:)]) {
        size = [self.delegate collectionView:self.collectionView layout:self estimatedSizeForHeaderInSection:section];
    }
    
    return size;
}

- (CGSize)estimatedSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeZero;
    
    if ([self.delegate conformsToProtocol:@protocol(RAMCollectionViewFlemishBondLayoutDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForFooterInSection:)]) {
        size = [self.delegate collectionView:self.collectionView layout:self estimatedSizeForFooterInSection:section];
    }
    
    return size;
}

- (BOOL)isHighLightedElementAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row % self.numberOfElements) == 0) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)currentGroupAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.row + 1;
    
    NSInteger resultValue = item / self.numberOfElements;
    
    NSUInteger mod = item % self.numberOfElements;
    if (mod > 0) {
        resultValue += 1;
    }
    
    return resultValue;
}

- (NSInteger)totalGroupsAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:indexPath.section];
    
    if (itemsCount <= self.numberOfElements) {
        return 1;
    }
    
    NSInteger resultValue = itemsCount / self.numberOfElements;
    
    NSUInteger mod = itemsCount % self.numberOfElements;
    if (mod > 0) {
        resultValue += 1;
    }
    
    return resultValue;
}

- (CGFloat)heightHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self.headerSizes[indexPath] CGSizeValue];
    
    return size.height;
}

- (NSInteger)itemCountAtSection:(NSInteger)section
{
    if (self.numberOfSections == 0) {
        return 0;
    }
    
    return [[self collectionView] numberOfItemsInSection:section];
}

- (BOOL)isTheLastItemAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.row + 1) == [self itemCountAtSection:indexPath.section]) {
        return YES;
    }
    
    return NO;
}

- (void)checkHighlightedCellWidth
{
    if (self.highlightedCellWidth == 0) {
        self.highlightedCellWidth = self.collectionView.bounds.size.width / 2;
    }
}

@end
