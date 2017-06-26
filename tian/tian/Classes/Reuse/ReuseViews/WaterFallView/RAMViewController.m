//
//  RAMViewController.m
//  RAMCollectionViewFlemishBondLayoutDemo
//
//  Created by Rafael Aguilar Martín on 20/10/13.
//  Copyright (c) 2013 Rafael Aguilar Martín. All rights reserved.
//

#import "RAMViewController.h"
#import "RAMCollectionViewCell.h"
#import "RAMCollectionAuxView.h"
#import "XTPlazaWaterFallInfo.h"
#import "RAMCollectionViewFlemishBondLayout.h"

static NSString * const CellIdentifier = @"MyCell";
static NSString * const HeaderIdentifier = @"HeaderIdentifier";
static NSString * const FooterIdentifier = @"FooterIdentifier";

@interface RAMViewController ()

@property (nonatomic, strong) RAMCollectionViewFlemishBondLayout *collectionViewLayout;
@property (nonatomic, readonly) UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *modelsArray;

@end

@implementation RAMViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Getter
- (UICollectionView *)collectionView
{
    return (UICollectionView *)self.view;
}

#pragma mark - Setup
- (void)setup
{
     _modelsArray = [[NSMutableArray alloc]init];
    
    self.collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    self.collectionViewLayout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor yellowColor];
    [collectionView registerClass:[RAMCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [collectionView registerClass:[RAMCollectionAuxView class] forSupplementaryViewOfKind:RAMCollectionViewFlemishBondHeaderKind withReuseIdentifier:HeaderIdentifier];
    
    self.view = collectionView;
    
    [self loadPic];
}

- (void)loadPic {
    XTPlazaWaterFallInfo *model = [[XTPlazaWaterFallInfo alloc]init];
    model.text = @"假数据1";
    model.width = 100;
    model.height = 200;
    
    XTPlazaWaterFallInfo *model1 = [[XTPlazaWaterFallInfo alloc]init];
    model1.text = @"假数据2";
    model1.width = 50;
    model1.height = 50;
    
    XTPlazaWaterFallInfo *model2 = [[XTPlazaWaterFallInfo alloc]init];
    model2.text = @"假数据3";
    model2.width = 50;
    model2.height = 50;
    
    XTPlazaWaterFallInfo *model3 = [[XTPlazaWaterFallInfo alloc]init];
    model3.text = @"假数据4";
    model3.width = 540;
    model3.height = 250;
    
    XTPlazaWaterFallInfo *model4 = [[XTPlazaWaterFallInfo alloc]init];
    model4.text = @"假数据5";
    model4.width = 50;
    model4.height = 50;
    
    XTPlazaWaterFallInfo *model5 = [[XTPlazaWaterFallInfo alloc]init];
    model5.text = @"假数据6";
    model5.width = 650;
    model5.height = 250;
    
    XTPlazaWaterFallInfo *model6 = [[XTPlazaWaterFallInfo alloc]init];
    model6.text = @"假数据7";
    model6.width = 350;
    model6.height = 250;
    
    XTPlazaWaterFallInfo *model7 = [[XTPlazaWaterFallInfo alloc]init];
    model7.text = @"假数据8";
    model7.width = 245;
    model7.height = 250;
    
    XTPlazaWaterFallInfo *model8 = [[XTPlazaWaterFallInfo alloc]init];
    model8.text = @"假数据9";
    model8.width = 100;
    model8.height = 200;
    
    XTPlazaWaterFallInfo *model9 = [[XTPlazaWaterFallInfo alloc]init];
    model9.text = @"假数据10";
    model9.width = 150;
    model9.height = 450;
    
    XTPlazaWaterFallInfo *model10 = [[XTPlazaWaterFallInfo alloc]init];
    model10.text = @"假数据11";
    model10.width = 50;
    model10.height = 50;
    
    XTPlazaWaterFallInfo *model11 = [[XTPlazaWaterFallInfo alloc]init];
    model11.text = @"假数据12";
    model11.width = 540;
    model11.height = 250;
    
    XTPlazaWaterFallInfo *model12 = [[XTPlazaWaterFallInfo alloc]init];
    model12.text = @"假数据13";
    model12.width = 50;
    model12.height = 50;
    
    XTPlazaWaterFallInfo *model13 = [[XTPlazaWaterFallInfo alloc]init];
    model13.text = @"假数据14";
    model13.width = 650;
    model13.height = 250;
    [self.modelsArray addObjectsFromArray:@[model,model1,model2,model3,model4,model5,model6,model7,model8,model9]];
    RAMCollectionViewFlemishBondLayout *layout = (RAMCollectionViewFlemishBondLayout*)self.collectionView.collectionViewLayout;
    layout.array = self.modelsArray;
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RAMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell configureCellWithIndexPath:indexPath andWithModel:_modelsArray[indexPath.item]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionReusableView *titleView;
    
    if (kind == RAMCollectionViewFlemishBondHeaderKind) {
        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        ((RAMCollectionAuxView *)titleView).label.text = @"Header";
    }
    return titleView;
}

#pragma mark - RAMCollectionViewVunityLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout estimatedSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 100);
}

@end
