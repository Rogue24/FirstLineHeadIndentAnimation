//
//  PUGCViewController.m
//  FirstLineHeadIndentAnimation-Example_Example
//
//  Created by 周健平 on 2020/5/14.
//  Copyright © 2020 zhoujianping24@hotmail.com. All rights reserved.
//

#import "PUGCViewController.h"
#import "WTVPUGCProfileCollectionView.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"

@interface PUGCViewController () <WTVPUGCProfileCellDelegate>
@property (nonatomic, weak) WTVPUGCProfileCollectionView *collectionView;
@property (nonatomic, strong) NSOperationQueue *serialQueue;
@property (nonatomic, strong) JPBounceView *failedBtn;
@end

@implementation PUGCViewController
{
    BOOL _isDidAppear;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupBase];
    [self __setupCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isDidAppear) return;
    _isDidAppear = YES;
    [self refreshNewData];
}

- (void)dealloc {
    [_serialQueue cancelAllOperations];
    _serialQueue.suspended = NO;
    _serialQueue = nil;
}

#pragma mark - 初始布局

- (void)__setupBase {
    self.title = @"Example";
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)__setupCollectionView {
    WTVPUGCProfileCollectionView *collectionView = [WTVPUGCProfileCollectionView profileCollectionViewWithCellStyle:WTVPUGCProfileCellStyle_1 cellDelegate:self sectionHeaderSize:CGSizeZero sectionHeaderClass:nil sectionHeaderID:nil];
    [self jp_contentInsetAdjustmentNever:collectionView];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    collectionView.mj_header.ignoredScrollViewContentInsetTop = -JPNavTopMargin;
    
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    collectionView.mj_footer.ignoredScrollViewContentInsetBottom = -JPDiffTabBarH;
    collectionView.mj_footer.hidden = YES;
}

#pragma mark - setter & getter

- (NSOperationQueue *)serialQueue {
    if (!_serialQueue) {
        _serialQueue = [[NSOperationQueue alloc] init];
        _serialQueue.maxConcurrentOperationCount = 1;
    }
    return _serialQueue;
}

- (JPBounceView *)failedBtn {
    if (!_failedBtn) {
        _failedBtn = [[JPBounceView alloc] initWithFrame:CGRectMake(0, 0, JPScaleValue(75), JPScaleValue(28))];
        _failedBtn.scale = 0.93;
        CAGradientLayer *gLayer = [CAGradientLayer layer];
        gLayer.frame = _failedBtn.bounds;
        gLayer.startPoint = CGPointMake(0, 0.5);
        gLayer.endPoint = CGPointMake(1, 0.5);
        gLayer.colors = @[(id)JPRGBColor(255, 151, 0).CGColor,
                          (id)JPRGBColor(255, 191, 0).CGColor];
        gLayer.cornerRadius = _failedBtn.jp_height * 0.5;
        [_failedBtn.layer addSublayer:gLayer];
        UILabel *titleLabel = ({
            UILabel *aLabel = [[UILabel alloc] initWithFrame:_failedBtn.bounds];
            aLabel.font = JPScaleBoldFont(12);
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.textColor = UIColor.whiteColor;
            aLabel.tag = 233;
            aLabel;
        });
        [_failedBtn addSubview:titleLabel];
    }
    return _failedBtn;
}

#pragma mark - 请求方法

- (void)refreshNewData {
    
    if (self.collectionView.mj_footer.alpha > 0) [self.collectionView.mj_footer endRefreshing];
    
    if (self.collectionView.cellModelsCount) {
        [self requestNewData];
    } else {
        @jp_weakify(self);
        [self.collectionView.esView loadingWithTitle:@"正在加载..." imageName:@"panda_error" animated:YES complete:^{
            @jp_strongify(self);
            if (!self) return;
            [self requestNewData];
        }];
    }
}

- (void)requestNewData {
    if (self.collectionView.mj_footer.alpha > 0) [self.collectionView.mj_footer endRefreshing];
    
    // 创建任务
    @jp_weakify(self);
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        @jp_strongify(self);
        if (!self) return;
        self.serialQueue.suspended = YES; // 暂停
        
        JPLog(@"假装在请求数据...");
        sleep(1);
        
        NSString *path = JPMainBundleResourcePath(@"pugc_0", @"json");
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSString *faildStr;
        NSInteger dataCount = dataArray.count;
        NSMutableArray<WTVPUGCProfileCellModel *> *cellModels;
        if (dataCount) {
            NSArray<WTVPUGCProfileModel *> *models = [WTVPUGCProfileModel mj_objectArrayWithKeyValuesArray:dataArray];
            cellModels = [NSMutableArray array];
            for (NSInteger i = 0; i < dataCount; i++) {
                WTVPUGCProfileModel *model = models[i];
                WTVPUGCProfileCellModel *cellModel = [WTVPUGCProfileCellModel cellModelForCellStyle_1withModel:model index:i contrastUid:@"" isNoProfileStyle:YES];
                [cellModels addObject:cellModel];
            }
        } else {
            faildStr = @"暂无视频~";
        }

        // 回到主队列
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            @jp_strongify(self);
            if (!self) return;
            [self.collectionView reloadCellModels:cellModels complete:^{
                [self requestDone:faildStr dataCount:dataCount isRequestUserInfo:NO isSuccess:YES];
                self.serialQueue.suspended = NO; // 继续
            }];
        }];
    }];

    // 添加任务
    [self.serialQueue addOperation:operation];
}

- (void)requestMoreData {
    [self.collectionView.mj_header endRefreshing];
    
    @jp_weakify(self);
    // 创建任务
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        @jp_strongify(self);
        if (!self) return;
        self.serialQueue.suspended = YES; // 暂停
        
        JPLog(@"假装在请求数据...");
        sleep(1);

        NSString *path = JPMainBundleResourcePath(@"pugc_1", @"json");
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        NSInteger dataCount = dataArray.count;
        NSMutableArray<WTVPUGCProfileCellModel *> *cellModels;
        if (dataCount) {
            NSArray<WTVPUGCProfileModel *> *models = [WTVPUGCProfileModel mj_objectArrayWithKeyValuesArray:dataArray];
            cellModels = [NSMutableArray array];
            NSInteger beginIndex = self.collectionView.cellModelsCount;
            for (NSInteger i = 0; i < dataCount; i++) {
                WTVPUGCProfileModel *model = models[i];
                WTVPUGCProfileCellModel *cellModel = [WTVPUGCProfileCellModel cellModelForCellStyle_1withModel:model index:(beginIndex + i) contrastUid:@"" isNoProfileStyle:YES];
                [cellModels addObject:cellModel];
            }
        } else {
            dataCount = 1; // 没数据了，说明全部请求完了，写个1判定全部都拿了
        }

        // 回到主队列
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            @jp_strongify(self);
            if (!self) return;
            [self.collectionView addCellModels:cellModels complete:^{
                if (dataCount) {
                    [self requestDone:nil dataCount:self.collectionView.cellModelsCount isRequestUserInfo:NO isSuccess:YES];
                } else {
                    [self requestDone:nil dataCount:1 isRequestUserInfo:NO isSuccess:YES]; // 没数据了，说明全部请求完了，写个1判定全部都拿了
                }
                self.serialQueue.suspended = NO; // 继续
            }];
        }];
    }];

    // 添加任务
    [self.serialQueue addOperation:operation];
}

- (void)requestDone:(NSString *)faildStr dataCount:(NSInteger)dataCount isRequestUserInfo:(BOOL)isRequestUserInfo isSuccess:(BOOL)isSuccess {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    if (dataCount) {
        if (self.collectionView.mj_footer.hidden) {
            self.collectionView.mj_footer.hidden = NO;
            self.collectionView.mj_footer.alpha = 0;
            [self.collectionView.mj_footer jp_addPOPBasicAnimationWithPropertyNamed:kPOPViewAlpha toValue:@1 duration:0.2];
        }
        if (dataCount % 10 == 0) {
            [self.collectionView.mj_footer resetNoMoreData];
        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        if (faildStr.length) [JPProgressHUD showErrorWithStatus:faildStr userInteractionEnabled:YES];
    } else {
        if (!self.collectionView.mj_footer.hidden) {
            [self.collectionView.mj_footer jp_addPOPBasicAnimationWithPropertyNamed:kPOPViewAlpha toValue:@0 duration:0.2 completionBlock:^(POPAnimation *anim, BOOL finished) {
                if (finished) self.collectionView.mj_footer.hidden = YES;
            }];
        }
        if (faildStr.length) {
            NSString *imageName = isSuccess ? @"panda_favorite" : @"panda_networkerror";
            UIView *otherBtn = self.failedBtn;
            UILabel *titleLabel = [self.failedBtn viewWithTag:233];
            titleLabel.text = @"刷新下";
            @jp_weakify(self);
            self.failedBtn.viewTouchUpInside = ^(JPBounceView *bounceView) {
                @jp_strongify(self);
                if (!self) return;
                [self refreshNewData]; // 刷新用户信息+视频
            };
            [self.collectionView.esView noDataWithTitle:faildStr imageName:imageName otherBtn:otherBtn animated:YES];
        }
    }
}

#pragma mark - <WTVPUGCProfileCellDelegate>

- (void)tapCellIcon:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
    WTVPUGCProfileCellModel *cm = cell.cm;
    [cm setIsLiving:!cm.isLiving animated:YES];
}

- (void)moreAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
}

- (void)zanAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
    WTVPUGCProfileCellModel *cm = cell.cm;
    [cm setIsZaned:!cm.isZaned byUserInteraction:YES];
}

- (void)commentAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
}

- (void)forwardAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
}

- (void)relatePlayAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
}

- (void)cellFollowAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
    [cell.cm setIsFollowed:!cell.cm.isFollowed byUserInteraction:YES];
}

- (void)cetegoryAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
}

- (void)collectAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
    WTVPUGCProfileCellModel *cm = cell.cm;
    [cm setIsCollected:!cm.isCollected byUserInteraction:YES];
}

- (void)relateCollectAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
    WTVPUGCProfileCellModel *cm = cell.cm;
    [cm setIsRelateCollected:!cm.isRelateCollected byUserInteraction:YES];
}

- (void)playAction:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
}

- (void)tapCellEmptyPlace:(WTVPUGCProfileCell *)cell {
    JPLog(@"%s", __func__);
}

@end
