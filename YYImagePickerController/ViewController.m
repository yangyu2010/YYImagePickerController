//
//  ViewController.m
//  YYImagePickerController
//
//  Created by Yang Yu on 2017/12/26.
//  Copyright © 2017年 Yang Yu. All rights reserved.
//

#import "ViewController.h"
#import "MJAlbumsController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)push:(id)sender {
    
    MJAlbumsController *vc = [[MJAlbumsController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
}




@end
