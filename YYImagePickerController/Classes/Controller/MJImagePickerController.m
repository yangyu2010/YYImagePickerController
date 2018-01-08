//
//  MJImagePickerController.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2018/1/6.
//  Copyright © 2018年 Yang Yu. All rights reserved.
//

#import "MJImagePickerController.h"
#import "MJAlbumsController.h"
#import "MJImageManager.h"
#import "MJPhotoPickerController.h"

@interface MJImagePickerController ()
{
    NSInteger _columnNumber;
    BOOL _pushPhotoPickerVc;
    
    /// 没有授权时, 监听授权状态的timer
    NSTimer *_timerNoAuthorized;
}

/// 没有授权时提示用户的label
@property (nonatomic, strong) UILabel *lblNoAuthorized;

/// 没有授权时按钮
@property (nonatomic, strong) UIButton *btnNoAuthorized;


@end

@implementation MJImagePickerController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<ImagePickerControllerDelegate>)delegate pushPhotoPickerVc:(BOOL)pushPhotoPickerVc {
    
    MJAlbumsController *vcAlbums = [[MJAlbumsController alloc] init];
    
    self = [super initWithRootViewController:vcAlbums];
    if (self) {
        
        _maxImagesCount = maxImagesCount;
        _columnNumber = columnNumber;
        _pushPhotoPickerVc = pushPhotoPickerVc;

        if (![[MJImageManager defaultManager] authorizationStatusAuthorized]) {
            /// 当前未授权
            self.lblNoAuthorized.frame = CGRectMake(0, 100, 150, 50);
            self.btnNoAuthorized.frame = CGRectMake(0, 150, 150, 50);
            [self.view addSubview:self.lblNoAuthorized];
            [self.view addSubview:self.btnNoAuthorized];

            _timerNoAuthorized = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(actionObserveAuthrizationStatusChange) userInfo:nil repeats:YES];
        } else {
            [self actionPushToPhotoPickerVc];
        }
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrSelectedModels = [[NSMutableArray alloc] init];
}

- (void)dealloc {
    
    NSLog(@"imagePicker dealloc");
    
    if (_timerNoAuthorized) {
        [_timerNoAuthorized invalidate];
        _timerNoAuthorized = nil;
    }
}

#pragma mark- Public

/// 判断当前ImagePicker还能否继续添加资源
- (BOOL)isImagePickerCanAddAssets {
    if (_maxImagesCount == 0) {
        return YES;
    }
    
    return (self.arrSelectedModels.count >= self.maxImagesCount);
}

#pragma mark- Action

/// App设置
- (void)actionSetting {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

/// 监听相册授权状态
- (void)actionObserveAuthrizationStatusChange {
    
    if ([[MJImageManager defaultManager] authorizationStatusAuthorized]) {
        [self.lblNoAuthorized removeFromSuperview];
        [self.btnNoAuthorized removeFromSuperview];
        [_timerNoAuthorized invalidate];
        _timerNoAuthorized = nil;
        [self actionPushToPhotoPickerVc];
    }
}

/// 默认跳到相机胶卷页面
- (void)actionPushToPhotoPickerVc {

    if (_timerNoAuthorized) {
        [_timerNoAuthorized invalidate];
        _timerNoAuthorized = nil;
    }
    
    [[MJImageManager defaultManager] getAllAlbumsCompletion:^(NSArray<MJAlbumModel *> *arrAlbums) {
        
        // push到第一个默认相册中
        MJPhotoPickerController *picker = [[MJPhotoPickerController alloc] init];
        picker.modelAlbum = arrAlbums.firstObject;
        [self pushViewController:picker animated:YES];
        
        MJAlbumsController *vcAlbums = (MJAlbumsController *)self.visibleViewController;
        if ([vcAlbums isKindOfClass:[MJAlbumsController class]]) {
            vcAlbums.arrAllAlbums = arrAlbums.copy;
        }
    }];
    
}

#pragma mark- Getter

- (UIButton *)btnNoAuthorized {
    if (_btnNoAuthorized == nil) {
        _btnNoAuthorized = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnNoAuthorized setTitle:@"Setting" forState:UIControlStateNormal];
        _btnNoAuthorized.titleLabel.font = [UIFont systemFontOfSize:18];
        [_btnNoAuthorized addTarget:self action:@selector(actionSetting) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNoAuthorized;
}

- (UILabel *)lblNoAuthorized {
    if (_lblNoAuthorized == nil) {
        _lblNoAuthorized = [[UILabel alloc] init];
        _lblNoAuthorized.textAlignment = NSTextAlignmentCenter;
        _lblNoAuthorized.numberOfLines = 0;
        _lblNoAuthorized.font = [UIFont systemFontOfSize:16];
        _lblNoAuthorized.textColor = [UIColor blackColor];
        _lblNoAuthorized.text = @"没有权限";
    }
    return _lblNoAuthorized;
}


@end
