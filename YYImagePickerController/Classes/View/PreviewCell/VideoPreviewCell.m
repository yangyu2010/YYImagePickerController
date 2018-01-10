//
//  VideoPreviewCell.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/28.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "VideoPreviewCell.h"
#import "UIView+Sugar.h"
#import "MJImageManager.h"

@interface VideoPreviewCell ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIButton *playButton;
//@property (nonatomic, strong) UIImage *cover;

@end

@implementation VideoPreviewCell


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewConfig {
    [super viewConfig];
    
//
//    self.contentView.backgroundColor = [UIColor redColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pausePlayerAndShowNaviBar) name:UIApplicationWillResignActiveNotification
                                               object:nil];
}



- (void)configPlayButton {
    if (_playButton) {
        [_playButton removeFromSuperview];
    }
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"MMVideoPreviewPlayHL"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
}

- (void)setModel:(MJAssetModel *)model {
    [super setModel:model];
    [self configMoviePlayer];
}

- (void)configMoviePlayer {
    if (_player) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
        [_player pause];
        _player = nil;
    }

//    [[MJImageManager defaultManager] getPhotoWithAsset:self.model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//        _cover = photo;
//    }];
    
    [[MJImageManager defaultManager] getVideoWithAsset:self.model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:_playerLayer];
        [self setNeedsDisplay];
        [self layoutIfNeeded];
        [self configPlayButton];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_player.currentItem];
    }];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _playerLayer.frame = CGRectMake(0, 0, self.width - 20, self.height);
    
    _playButton.frame = CGRectMake(0, 64, self.width, self.height - 64 - 44);
}

- (void)photoPreviewCollectionViewDidScroll {
    [self pausePlayerAndShowNaviBar];
}

#pragma mark - Click Event

- (void)playButtonClick {
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        [_player play];
        [_playButton setImage:nil forState:UIControlStateNormal];
        [UIApplication sharedApplication].statusBarHidden = YES;
        if (self.singleTapGestureBlock) {
            self.singleTapGestureBlock();
        }
    } else {
        [self pausePlayerAndShowNaviBar];
    }
}

- (void)pausePlayerAndShowNaviBar {
    [_playButton setImage:[UIImage imageNamed:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];

    if (_player.rate != 0.0) {
        [_player pause];
        if (self.singleTapGestureBlock) {
            self.singleTapGestureBlock();
        }
    }
}

#pragma mark- Public
/// 结束播放视频
- (void)stopPlay {
    [self pausePlayerAndShowNaviBar];
}

@end
