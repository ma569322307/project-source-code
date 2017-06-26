//
//  XTPicDetailCell.m
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPicDetailCell.h"
#import "XTImgDetailView.h"
#import "XTCommentsCell.h"
#import "XTCommentItemModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Define.h"
#import "XTSeriesContentStore.h"
#import "XTImgShowModel.h"
#import "XTCommentsModel.h"
#import "UIImage+Capture.h"
@interface XTPicDetailCell()<UITableViewDataSource,UITableViewDelegate,XTCommentsCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property(nonatomic,strong) XTImgDetailView *imgDetailView;

@property(nonatomic,strong) XTImgShowModel *model;

@end


@implementation XTPicDetailCell

static NSString *cellID = @"XTCommentsCell";


- (void)awakeFromNib {
    
    UITapGestureRecognizer *imgDetailViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgDetailViewTapGesture:)];
    [self.imgDetailView addGestureRecognizer:imgDetailViewTap];
    
    
    
    [self.commentTableView registerNib:[UINib nibWithNibName:@"XTCommentsCell" bundle:nil] forCellReuseIdentifier:cellID];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 0)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.commentTableView.tableFooterView = footerView;
    
    self.commentTableView.footer = [XTGifFooter footerWithRefreshingBlock:^{
        [self fatchNextPageCommnetRequest];
    }];
    
    
    
}

-(XTImgDetailView *)imgDetailView{
    if (!_imgDetailView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XTImgDetailView" owner:self options:nil];
        _imgDetailView = nib[0];
         @weakify(self)
        [_imgDetailView setImgLoadFinish:^(UIImage *image) {
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(imgLoadFinish:)]) {
                [self.delegate imgLoadFinish:image];
            }
        }];
    }
    return _imgDetailView;
}
/*
-(void)setModel:(XTImgShowModel *)aModel{
    
    _model = aModel;

    self.imgDetailView.model = _model;
    
    [self layoutIfNeeded];
    
    CGSize size = [self.imgDetailView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    self.imgDetailView.frame = CGRectMake(0, 0, size.width, size.height);

    self.commentTableView.tableHeaderView = self.imgDetailView;

}
 */

-(void)configureDataWithModel:(XTImgShowModel *)aModel{
    self.model = aModel;
    
    self.imgDetailView.placeholderImageURL = self.placeholderImageURL;
    
    self.imgDetailView.model = self.model;
    
    [self layoutIfNeeded];
    
    CGSize size = [self.imgDetailView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    self.imgDetailView.frame = CGRectMake(0, 0, size.width, size.height);

    self.commentTableView.tableHeaderView = self.imgDetailView;
    
    
}


-(void)setPlaceholderImageURL:(NSURL *)aPlaceholderImageURL{
    NSLog(@"placeholderImage ==== %@",aPlaceholderImageURL);
    
    
    _placeholderImageURL = aPlaceholderImageURL;
    NSLog(@"placeholderImage ==== %@",_placeholderImageURL);
    if (!_placeholderImageURL) {
        self.imgDetailView.placeholderImageURL = _placeholderImageURL;
        return;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 266)];
    
//    headerView.backgroundColor = [UIColor magentaColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    NSLog(@"placeholderImage ==== %@",_placeholderImageURL);

    [imageView sd_setImageWithURL:_placeholderImageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            return ;
        }
        
        NSLog(@"image.size ==== %@ scale === %f",NSStringFromCGSize(image.size),image.scale);
        CGFloat scale = (SCREEN_SIZE.width - 30) / image.size.width;
        
        CGFloat height = ((image.size.height / image.size.width) > 1.5) ? (SCREEN_SIZE.width - 30) * 1.5 : image.size.height * scale;
        
        
        imageView.frame = CGRectMake(15, 13, SCREEN_SIZE.width - 30, height);
        
        headerView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, CGRectGetMaxY(imageView.frame) + 13);
        
        [headerView addSubview:imageView];
        
        self.commentTableView.tableHeaderView = headerView;
    }];
}


-(void)setDataSource:(NSArray *)aDataSource{
    _dataSource = aDataSource;
    [self.commentTableView reloadData];
    //[self.commentTableView setContentOffset:CGPointMake(0., 100)];
}

-(void)imgDetailViewTapGesture:(UITapGestureRecognizer *)tapGesture{
    if ([self.delegate respondsToSelector:@selector(imgDetailViewTapAction)]) {
        [self.delegate imgDetailViewTapAction];
    }
}



-(void)fatchNextPageCommnetRequest{
    
    NSString *url = [XT_API stringByAppendingString:XT_PICCOMMENTSSHOW];
    NSLog(@"url === %@",url);
    NSNumber *pid = self.model.itemID;
    
    if (!pid) {
        [self.commentTableView.footer endRefreshing];
        return;
    }
    
    XTCommentItemModel *commentItem = [self.dataSource lastObject];
    
    NSNumber *maxId = commentItem.itemID ? commentItem.itemID : @0;
    
    NSDictionary *dic = @{@"pid":pid,@"maxId":maxId,@"size":@20};
    
    [XTSeriesContentStore fatchCommentsWithUrl:url andParameters:dic successBlock:^(id responseObject) {
        //NSLog(@"responseObject === %@",responseObject);
        [self.commentTableView.footer endRefreshing];
        XTCommentsModel *commnetsModel = responseObject;
        
        if (!commnetsModel.comments || commnetsModel.comments.count == 0) {
            [self.commentTableView.footer setHidden:YES];
            return ;
        }
        NSMutableArray *arr_m = [NSMutableArray arrayWithArray:self.dataSource];
        
        [arr_m addObjectsFromArray:commnetsModel.comments];
        self.dataSource = [arr_m copy];
        
        if ([self.delegate respondsToSelector:@selector(fatchNextPageFinsih:)]) {
            [self.delegate fatchNextPageFinsih:self.dataSource];
        }
        
        [self.commentTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        //failureBlock(error);
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
    [cell congfigurateDataWithModel:self.dataSource[indexPath.row]];
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.controllerDelegate = self.delegate;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(tableViewDidSelectedWithCommentsInfo:)]) {
        
        XTCommentItemModel *model = self.dataSource[indexPath.row];
        [self.delegate tableViewDidSelectedWithCommentsInfo:model];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:cellID cacheByIndexPath:indexPath configuration:^(XTCommentsCell *cell) {
        [cell congfigurateDataWithModel:self.dataSource[indexPath.row]];
    }];
}


-(void)setDelegate:(id)aDelegate{
    _delegate = aDelegate;
    self.imgDetailView.delegate = _delegate;
    
}

-(void)setIndex:(NSInteger)aIndex{
    _index = aIndex;
    self.imgDetailView.index = _index;
}

#pragma -mark XTCommentsCellDelegate

-(void)commentCommendActionWith:(NSInteger)index{
    XTCommentItemModel *model = self.dataSource[index];
    NSInteger commendCount = [model.commendCount integerValue];
    model.commendCount = [NSNumber numberWithInteger:commendCount + 1];
    model.supported = YES;
    
    
    NSString *url = [XT_API stringByAppendingString:XT_PICCOMMENTSCOMMEND];
    
    NSDictionary *dic = @{@"cid":model.itemID};
    
    [XTSeriesContentStore pictureCommentsCommendWithUrl:url andParameters:dic successBlock:^{
        [self.commentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        //[self.commentTableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];

}

-(void)cancelCommentCommendActionWith:(NSInteger)index{
    XTCommentItemModel *model = self.dataSource[index];
    NSInteger commendCount = [model.commendCount integerValue];
    model.commendCount = [NSNumber numberWithInteger:commendCount - 1];
    model.supported = NO;
    
    NSString *url = [XT_API stringByAppendingString:XT_PICCOMMENTSCOMMENDCANCEL];
    
    NSDictionary *dic = @{@"cid":model.itemID};
    
    [XTSeriesContentStore pictureCommentsCommendCancelWithUrl:url andParameters:dic successBlock:^{
        [self.commentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        //[self.commentTableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (-scrollView.contentOffset.y > 64) {
        if (self.pullDownAction) {
            self.pullDownAction(scrollView.contentOffset);
        }
    }
}


-(void)dealloc{
    NSLog(@"XTPicDetailCell >>>>>>> dealloc");
}

@end
