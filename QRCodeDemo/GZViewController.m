//
//  ViewController.m
//  QRCodeDemo
//
//  Created by elion on 17/3/23.
//  Copyright © 2017年 elion. All rights reserved.
//

#import "GZViewController.h"
#import "GZScanViewController.h"
#import "GZQRCodeViewController.h"
#import "GZBarCodeViewController.h"

@interface GZViewController ()

@end

@implementation GZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)scanAction:(UIButton *)sender 
{
    GZScanViewController *scanVc = [[GZScanViewController alloc] init];
    [self.navigationController pushViewController:scanVc animated:YES];
}

- (IBAction)showQRCodeAction:(UIButton *)sender 
{
    GZQRCodeViewController *codeVc = [[GZQRCodeViewController alloc] init];
    [self.navigationController pushViewController:codeVc animated:YES];
}

- (IBAction)showBarCodeAction:(UIButton *)sender 
{
    GZBarCodeViewController *barCodeVc = [[GZBarCodeViewController alloc] init];
    [self.navigationController pushViewController:barCodeVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
