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
#import "MJAlbumModel.h"
#import "MJImagePickerController.h"
#import "PhotoPickerToolView.h"


#define kPhotoCollectionCellID      @"PhotoCollectionCell.h"

#define kPhotoCollectionRowCount    4

#define kPhotoCollectionCellMargin  5.0f

#define kPhotoBottomViewHeight      49.0f

@interface MJPhotoPickerController () <UICollectionViewDelegate, UICollectionViewDataSource, PhotoPickerToolViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionPhoto;

@property (nonatomic, strong) PhotoPickerToolView *viewBottomTool;


@property (nonatomic, strong) NSArray <MJAssetModel *> *arrAssets;

@property (nonatomic, weak) MJImagePickerController *navPicker;

@end

@implementation MJPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self viewConfig];
    [self dataConfig];
}

- (void)dealloc {
    NSLog(@"MJPhotoPickerController dealloc");
}

#pragma mark- Data

- (void)dataConfig {
   
    _arrAssets = self.modelAlbum.arrModels;
    
    MJImagePickerController *navPicker = (MJImagePickerController *)self.navigationController;
    if ([navPicker isKindOfClass:[MJImagePickerController class]]) {
        self.navPicker = navPicker;
    }

    _viewBottomTool.countSelected = self.navPicker.arrSelectedModels.count;
    if ((_arrAssets.count > 0) && (_arrAssets.count == self.navPicker.arrSelectedModels.count)) {
        [_viewBottomTool setSelectedAll];
    }
    
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
    
    
    _viewBottomTool = [[PhotoPickerToolView alloc] init];
    _viewBottomTool.delegate = self;
    [self.view addSubview:_viewBottomTool];
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _viewBottomTool.frame = CGRectMake(0, self.view.bounds.size.height - kPhotoBottomViewHeight, self.view.bounds.size.width, kPhotoBottomViewHeight);
    
    _collectionPhoto.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kPhotoBottomViewHeight);
    
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
    if (_arrAssets.count == 0) {
        return ;
    }
    [_collectionPhoto scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_arrAssets.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

/// 点击cell, 添加或者删除Model
- (void)actionAddSelectedModelAtIndexPath:(NSIndexPath *)indexPath {

    if (self.navPicker == nil) {
        return ;
    }

    MJAssetModel *model = _arrAssets[indexPath.item];

    if (model.isSelected) {
        /// 已经添加了, 要移除
        for (MJAssetModel *oldModel in self.navPicker.arrSelectedModels) {
            if ([oldModel isEqual:model]) {
                // 如果是相同的Model, 代表是一个相册, 直接删除
                [self.navPicker.arrSelectedModels removeObject:oldModel];
                break;
            } else {
                // 如果不是, 对比id, 可能是同一张照片, 放在不同的相簿中
                if ([oldModel isSameAssetModel:model]) {
                    oldModel.isSelected = NO;
                    [self.navPicker.arrSelectedModels removeObject:oldModel];
                    break;
                }
            }
        }
    }
    else {
        // 需要判断当前最大数
        if (![self.navPicker isImagePickerCanAddAssets]) {
            NSString *message = [NSString stringWithFormat:@"您最多只能选择%ld", (long)self.navPicker.maxImagesCount];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        [self.navPicker.arrSelectedModels addObject:model];
    }
    
    model.isSelected = !model.isSelected;
    [_collectionPhoto reloadItemsAtIndexPaths:@[indexPath]];
    
    self.viewBottomTool.countSelected = self.navPicker.arrSelectedModels.count;
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
    
//    MJAssetModel *model = _arrAssets[indexPath.item];
    //model.isSelected = !model.isSelected;
    //[collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [self actionAddSelectedModelAtIndexPath:indexPath];
}

#pragma mark- Bottom ToolView Delegate
/// 选中所有
- (void)photoPickerToolViewSelectAllClick:(BOOL)isSelected {
    
    if (self.navPicker == nil) {
        return ;
    }
    
    [self.navPicker.arrSelectedModels removeAllObjects];

    // 是选择就全部加进来, 返选就直接删除就行
    for (MJAssetModel *model in self.modelAlbum.arrModels) {
        model.isSelected = isSelected;
        if (isSelected) {
            [self.navPicker.arrSelectedModels addObject:model];
        }
    }
    
    self.viewBottomTool.countSelected = self.navPicker.arrSelectedModels.count;
    [_collectionPhoto reloadData];
}

/// 预览
- (void)photoPickerToolViewPreviewClick {
    
    if (self.navPicker == nil) {
        return ;
    }
    
    if (self.navPicker.arrSelectedModels.count == 0) {
        return ;
    }
    
    MJPhotoPreviewController *previewVc = [[MJPhotoPreviewController alloc] init];
    previewVc.arrAssetModels = self.navPicker.arrSelectedModels.copy;
    [self.navigationController pushViewController:previewVc animated:YES];
}

/// 完成
- (void)photoPickerToolViewDoneClick {
    
}

@end
