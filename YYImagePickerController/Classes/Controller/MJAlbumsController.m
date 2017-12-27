//
//  MJAlbumsController.m
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/26.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "MJAlbumsController.h"
#import "MJImageManager.h"
#import "AlbumsCell.h"
#import "MJPhotoPickerController.h"

#define kAlbumsTableCellID    @"kMJAlbumsTableCellID"

@interface MJAlbumsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableAlbums;

@property (nonatomic, strong) NSArray *arrAlbums;

@end

@implementation MJAlbumsController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self viewConfig];
    [self dataConfig];
    
}

#pragma mark- Data

- (void)dataConfig {
    
    [[MJImageManager defaultManager] authorizationStatusAuthorized];
    
    [[MJImageManager defaultManager] getAllAlbumsCompletion:^(NSArray<MJAlbumModel *> *arrAlbums) {
        _arrAlbums = arrAlbums;
        [_tableAlbums reloadData];
    }];
}

#pragma mark- View

- (void)viewConfig {
    _tableAlbums = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableAlbums.backgroundColor = [UIColor whiteColor];
    _tableAlbums.delegate = self;
    _tableAlbums.dataSource = self;
    /// 设置footerView后 没有数据了分割线会消失
    _tableAlbums.tableFooterView = [[UIView alloc] init];
    [_tableAlbums registerClass:[AlbumsCell class] forCellReuseIdentifier:kAlbumsTableCellID];
    [self.view addSubview:_tableAlbums];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancle" style:UIBarButtonItemStyleDone target:self action:@selector(actionCancle)];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableAlbums.frame = self.view.bounds;
}

#pragma mark- Action
- (void)actionCancle {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrAlbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlbumsTableCellID forIndexPath:indexPath];
    cell.model = _arrAlbums[indexPath.item];
    return cell;
}

#pragma mark- Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MJPhotoPickerController *picker = [[MJPhotoPickerController alloc] init];
    picker.modelAlbum = _arrAlbums[indexPath.item];
    [self.navigationController pushViewController:picker animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



@end
