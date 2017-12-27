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

#define kPhotoCollectionCellID  @"PhotoCollectionCell.h"

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
   
    [MJImageManager getAssetFromAlbum:_modelAlbum completion:^(NSArray<MJAssetModel *> *arrAssets) {
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
    
    [_collectionPhoto registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:kPhotoCollectionCellID];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _collectionPhoto.frame = self.view.bounds;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionPhoto.collectionViewLayout;
    
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    
    CGFloat wh = self.view.bounds.size.width / 4.0;
    layout.itemSize = CGSizeMake(wh, wh);
    
}


#pragma mark- Action
- (void)actionCancle {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

@end
