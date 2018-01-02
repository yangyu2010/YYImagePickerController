//
//  MJPhotoPickerController.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/27.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "MJPhotoPickerController.h"
#import "PhotoCollectionCell.h"
#import "MJImageManager.h"
#import "NSObject+Utils.h"
#import "MJPhotoPreviewController.h"

#define kPhotoCollectionCellID      @"PhotoCollectionCell.h"

#define kPhotoCollectionRowCount    4

#define kPhotoCollectionCellMargin  5.0f

@interface MJPhotoPickerController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionPhoto;

@property (nonatomic, strong) NSArray <MJAssetModel *> *arrAssets;

@end

@implementation MJPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self viewConfig];
    [self dataConfig];
}

#pragma mark- Data

- (void)dataConfig {
   
    [[MJImageManager defaultManager] getAssetFromAlbum:_modelAlbum completion:^(NSArray<MJAssetModel *> *arrAssets) {
        
        _arrAssets = arrAssets;
        
        [self.collectionPhoto reloadData];
    }];
}

#pragma mark- View

- (void)viewConfig {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancle" style:UIBarButtonItemStyleDone target:self action:@selector(actionCancle)];
    self.title = _modelAlbum.name;
    
    _collectionPhoto = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    _collectionPhoto.backgroundColor = [UIColor whiteColor];
    _collectionPhoto.delegate = self;
    _collectionPhoto.dataSource = self;
    [self.view addSubview:_collectionPhoto];
    _collectionPhoto.contentInset = UIEdgeInsetsMake(kPhotoCollectionCellMargin, kPhotoCollectionCellMargin, kPhotoCollectionCellMargin, kPhotoCollectionCellMargin);
    
    [_collectionPhoto registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:kPhotoCollectionCellID];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _collectionPhoto.frame = self.view.bounds;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionPhoto.collectionViewLayout;
    
    layout.minimumLineSpacing = kPhotoCollectionCellMargin;
    layout.minimumInteritemSpacing = kPhotoCollectionCellMargin;
    
    CGFloat wh = (self.view.bounds.size.width - (kPhotoCollectionRowCount + 1) * kPhotoCollectionCellMargin) / kPhotoCollectionRowCount;
    layout.itemSize = CGSizeMake(wh, wh);
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self actionCollectionViewScrollBottom];
}

#pragma mark- Action
- (void)actionCancle {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/// 滚到最底部
- (void)actionCollectionViewScrollBottom {
    
    [_collectionPhoto scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_arrAssets.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

#pragma mark- DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionCellID forIndexPath:indexPath];
    cell.model = _arrAssets[indexPath.item];
    return cell;
}

#pragma mark- Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MJPhotoPreviewController *photoPreviewVc = [[MJPhotoPreviewController alloc] init];
    photoPreviewVc.currentIndex = indexPath.item;
    photoPreviewVc.arrAssetModels = _arrAssets.mutableCopy;
    [self.navigationController pushViewController:photoPreviewVc animated:YES];
}

@end
