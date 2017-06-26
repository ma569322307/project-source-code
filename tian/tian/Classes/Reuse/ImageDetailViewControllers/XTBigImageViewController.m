//
//  XTBigImageViewController.m
//  tian
//
//  Created by loong on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTBigImageViewController.h"
#import "XTSeriesContentStore.h"
#import "Define.h"
#import "XTBigImageViewCell.h"
#import "XTOriginImgModel.h"
@interface XTBigImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,XTBigImageViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *bigImgInfoArr;



@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@property (weak, nonatomic) IBOutlet UIButton *originalBtn;

@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;


@property (nonatomic,strong)UIImage *curImage;

@end

@implementation XTBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.view.constraints);
    self.view.clipsToBounds = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    self.pageLabel.hidden = YES;

    [self.collectionView registerClass:[XTBigImageViewCell class] forCellWithReuseIdentifier:@"XTBigImageViewCell"];

    if (self.pidArr) {
        [self imgOriginalRequestWithPidArr];
    }else if (self.topicID){
        [self imgOriginalRequestWithTopicID];
    }
    
}


-(void)imgOriginalRequestWithPidArr{
    NSString *url = [[XT_API stringByAppendingString:XT_PICIMAGES] stringByAppendingString:[self parametersStr]];
    NSLog(@"url ===== %@",url);
    
    [XTSeriesContentStore fatchImgOriginalWithUrl:url andParameters:nil successBlock:^(id responseObject) {
        self.bigImgInfoArr = responseObject;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_curIndex+1,self.bigImgInfoArr.count];
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.curIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        //NSLog(@"arr ===== %@",self.bigImgInfoArr);
        self.pageLabel.hidden = NO;
    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)imgOriginalRequestWithTopicID{
    NSString *url = [XT_API stringByAppendingString:XT_TOPICPOSTIMAGES];
    
    NSDictionary *dic = @{@"postId":self.topicID};
    
    [XTSeriesContentStore topicPostsImagesWithUrl:url andParameters:dic successBlock:^(id responseObject) {
        self.bigImgInfoArr = responseObject;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_curIndex+1,self.bigImgInfoArr.count];
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.curIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.pageLabel.hidden = NO;
    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)setPidArr:(NSArray *)aPidArr{
    _pidArr = aPidArr;
}

-(void)setCurIndex:(NSInteger)curIndex{
    _curIndex = curIndex;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_curIndex+1,self.bigImgInfoArr.count];
}

-(NSString *)parametersStr{
    NSString *parameters = @"";
    for (int i=0; i < self.pidArr.count; i++) {
        NSString *obj = self.pidArr[i];
        parameters = [parameters stringByAppendingString:[NSString stringWithFormat:@"&pid=%@",obj]];
    }
    NSLog(@"parameters ==== %@",parameters);
    return parameters;
}

- (IBAction)originalImageBtnClick:(UIButton *)sender {
    XTBigImageViewCell *cell = (XTBigImageViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.curIndex inSection:0]];
    
    XTOriginImgModel *model = self.bigImgInfoArr[self.curIndex];
    
    [cell configureOriginalImg:model.originalPic existsBlock:^{
        sender.enabled = NO;
    }];
}

- (IBAction)downLoadBtnClick:(UIButton *)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.curImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        // 保存失败
        [YYTHUD showPromptAddedTo:self.view withText:@"下载失败" withCompletionBlock:nil];
        //[MBProgressHUD showError:@"保存失败"];
    }else{
        // 保存成功
        //[MBProgressHUD showSuccess:@"保存成功"];
        
        [YYTHUD showPromptAddedTo:self.view withText:@"下载成功" withCompletionBlock:nil];
        
    }
}


- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {

    if ([self.delegate respondsToSelector:@selector(bigImageViewControllerDidClickedDismissButton:)]) {
        [self.delegate bigImageViewControllerDidClickedDismissButton:self];
    }
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.bigImgInfoArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexp === %ld",indexPath.row);
    self.downLoadBtn.enabled = NO;
    
    static NSString *cellID = @"XTBigImageViewCell";
    
    XTBigImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate  = self;
    XTOriginImgModel *model = self.bigImgInfoArr[indexPath.row];
    //cell.model = model;
    [cell configureModel:model andPlaceholderImage:self.placeholderImage];
    self.placeholderImage = nil;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"self.frame ==== %@",NSStringFromCGRect(self.view.frame));
    return CGSizeMake(CGRectGetWidth(self.view.frame) + 10, CGRectGetHeight(self.view.frame));
}

#pragma -mark XTBigImageViewCellDelegate

-(void)scrollActionWithOriginalImg:(BOOL)isExists andCurImg:(UIImage *)image{
    self.curImage = image;
    self.downLoadBtn.enabled = YES;
    self.originalBtn.enabled = !isExists;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollview.contentOffset ==== %f",scrollView.contentOffset.x);
    
    self.curIndex = scrollView.contentOffset.x / (CGRectGetWidth(self.view.frame) + 10);
    
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDeceleratingWith:)]) {
        [self.delegate scrollViewDidEndDeceleratingWith:self.curIndex];
    }    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    NSLog(@"dealloc ---- XTBigImageViewController");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
