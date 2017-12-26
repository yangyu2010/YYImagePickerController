//
//  MJAlbumsController.m
//  MJImagePicker
//
//  Created by Yang Yu on 2017/12/26.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "MJAlbumsController.h"
#import "MJImageManager.h"

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
    [_tableAlbums registerClass:[UITableViewCell class] forCellReuseIdentifier:kAlbumsTableCellID];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlbumsTableCellID forIndexPath:indexPath];
    MJAlbumModel *model = _arrAlbums[indexPath.item];
    
    cell.textLabel.text = model.name;
    cell.imageView.image = [UIImage imageNamed:@"default"];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
