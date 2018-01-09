//
//  MJPhotoPreviewController.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "MJPhotoPreviewController.h"
#import "PhotoPreviewCell.h"
#import "UIView+Sugar.h"
#import "NSObject+Utils.h"
#import "VideoPreviewCell.h"
#import "LivePhotoPreviewCell.h"

#define kPhotoPreviewCellID         @"kPhotoPreviewCellID"
#define kVideoPreviewCellID         @"KVideoPreviewCellID"
#define kLivePhotoPreviewCellID     @"kLivePhotoPreviewCellID"

@interface MJPhotoPreviewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat _offsetItemCount;
}
@property (nonatomic, strong) UICollectionView *collectionPreview;


@end

@implementation MJPhotoPreviewController

#pragma mark- Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewConfig];
    [self dataConfig];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark- Data

- (void)dataConfig {
    // 默认是0
    _currentIndex = 0;
}

#pragma mark- View

- (void)viewConfig {
    
    self.view.backgroundColor = [UIColor whiteColor];

    _collectionPreview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    _collectionPreview.backgroundColor = [UIColor blackColor];
    _collectionPreview.delegate = self;
    _collectionPreview.dataSource = self;
    _collectionPreview.pagingEnabled = YES;
    _collectionPreview.scrollsToTop = NO;
//    _collectionPreview.bounces = NO;
    _collectionPreview.showsHorizontalScrollIndicator = NO;
    _collectionPreview.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_collectionPreview];
    
    [_collectionPreview registerClass:[PhotoPreviewCell class] forCellWithReuseIdentifier:kPhotoPreviewCellID];
    [_collectionPreview registerClass:[VideoPreviewCell class] forCellWithReuseIdentifier:kVideoPreviewCellID];
    if (@available(iOS 9_1, *)) {
        [_collectionPreview registerClass:[LivePhotoPreviewCell class] forCellWithReuseIdentifier:kLivePhotoPreviewCellID];
    }
    
    if (@available(iOS 11, *)) {
        _collectionPreview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Back" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 20, 44, 44);
    [btn addTarget:self action:@selector(actionCancle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    /// self.view增加20, cell里 scrollViewview 宽度-20
    /// 这样每个cell都有20px的像素
    self.view.width += 20;
    
    _collectionPreview.frame = CGRectMake(0, 0, self.view.width, self.view.height);

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionPreview.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    [_collectionPreview setCollectionViewLayout:layout];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_currentIndex) {
        [_collectionPreview setContentOffset:CGPointMake((self.view.width) * _currentIndex, 0) animated:NO];
    }
}

#pragma mark- Action
- (void)actionCancle {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrAssetModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MJAssetModel *model = _arrAssetModels[indexPath.item];
    
    AssetPreviewBaseCell *cell;
    if (model.type == MJAssetModelMediaTypeVideo) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoPreviewCellID forIndexPath:indexPath];
    } else if (model.type == MJAssetModelMediaTypeLivePhoto) {
        if (@available(iOS 9_1, *)) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLivePhotoPreviewCellID forIndexPath:indexPath];
        }
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoPreviewCellID forIndexPath:indexPath];
    }
    cell.model = _arrAssetModels[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[VideoPreviewCell class]]) {
        VideoPreviewCell *videoCell = (VideoPreviewCell *)cell;
        [videoCell stopPlay];
    }
    
}


@end
