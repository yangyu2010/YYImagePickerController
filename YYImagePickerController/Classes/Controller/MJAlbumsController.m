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

#define kAlbumsTableCellID    @"kMJAlbumsTableCellID"

@interface MJAlbumsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableAlbums;


@property (nonatomic, strong) NSArray *arrAlbums;


@end

@implementation MJAlbumsController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableAlbums = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableAlbums.backgroundColor = [UIColor whiteColor];
    _tableAlbums.delegate = self;
    _tableAlbums.dataSource = self;
    /// 设置footerView后 没有数据了分割线会消失
    _tableAlbums.tableFooterView = [[UIView alloc] init];
    [_tableAlbums registerClass:[AlbumsCell class] forCellReuseIdentifier:kAlbumsTableCellID];
    [self.view addSubview:_tableAlbums];
    
    [MJImageManager getAllAlbumsCompletion:^(NSArray<MJAlbumModel *> *arrAlbums) {
        _arrAlbums = arrAlbums;
        [_tableAlbums reloadData];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _tableAlbums.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrAlbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlbumsTableCellID forIndexPath:indexPath];
    cell.model = _arrAlbums[indexPath.item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
