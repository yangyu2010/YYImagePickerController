//
//  PhotoCollectionCell.h
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/27.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//  照片Cell

#import <UIKit/UIKit.h>
#import "MJAssetModel.h"
//@class PhotoCollectionCell;
//
//@protocol PhotoCollectionCellDelegate <NSObject>
//
//- (void)photoCollectionCell:(PhotoCollectionCell *)cell
//                didSelected:(BOOL)isSelected;
//
//@end

@interface PhotoCollectionCell : UICollectionViewCell

@property (nonatomic, strong) MJAssetModel *model;

@end
