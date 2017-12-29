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

#define kPhotoPreviewCellID   @"kPhotoPreviewCellID"
#define kVideoPreviewCellID   @"KVideoPreviewCellID"
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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
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
    
   
}

#pragma mark- View

- (void)viewConfig {

    _collectionPreview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    _collectionPreview.backgroundColor = [UIColor blackColor];
    _collectionPreview.delegate = self;
    _collectionPreview.dataSource = self;
    _collectionPreview.pagingEnabled = YES;
    _collectionPreview.scrollsToTop = NO;
    _collectionPreview.showsHorizontalScrollIndicator = NO;
    _collectionPreview.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_collectionPreview];
    
    [_collectionPreview registerClass:[PhotoPreviewCell class] forCellWithReuseIdentifier:kPhotoPreviewCellID];
    [_collectionPreview registerClass:[VideoPreviewCell class] forCellWithReuseIdentifier:kVideoPreviewCellID];
    if (@available(iOS 9_1, *)) {
        [_collectionPreview registerClass:[LivePhotoPreviewCell class] forCellWithReuseIdentifier:kLivePhotoPreviewCellID];
    }

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionPreview.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width + 20, self.view.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    [_collectionPreview setCollectionViewLayout:layout];

    _collectionPreview.frame = CGRectMake(-10, 0, self.view.width + 20, self.view.height);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_currentIndex) {
        [_collectionPreview setContentOffset:CGPointMake((self.view.width + 20) * _currentIndex, 0) animated:NO];
    }
    
//    if (_offsetItemCount > 0) {
//        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionPreview.collectionViewLayout;
//        CGFloat offsetX = _offsetItemCount * layout.itemSize.width;
//        [_collectionPreview setContentOffset:CGPointMake(offsetX, 0)];
//    }
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offSetWidth = scrollView.contentOffset.x;
//    offSetWidth = offSetWidth +  ((self.view.width + 20) * 0.5);
//
//    NSInteger currentIndex = offSetWidth / (self.view.width + 20);
//
//    if (currentIndex < _arrAssetModels.count && _currentIndex != currentIndex) {
//        _currentIndex = currentIndex;
////        [self refreshNaviBarAndBottomBarState];
//    }
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
//}


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
    }
    
    else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoPreviewCellID forIndexPath:indexPath];
    }
    cell.model = _arrAssetModels[indexPath.item];
    return cell;
}



//#pragma mark- Notification
//- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionPreview.collectionViewLayout;
//    _offsetItemCount = _collectionPreview.contentOffset.x / layout.itemSize.width;
//}


@end
