//
//  GZBarCodeViewController.m
//  QRCodeDemo
//
//  Created by elion on 17/3/23.
//  Copyright © 2017年 elion. All rights reserved.
//

#import "GZBarCodeViewController.h"
#import "QRCodeCreateTools.h"

@interface GZBarCodeViewController ()

@end

@implementation GZBarCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *qrcodeView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 300)/2.0, 180, 300, 100)];
    UIImage *qrcode = [QRCodeCreateTools creatBarCode:@"11234598765" width:300 height:100];
    qrcodeView.image = qrcode;
    [self.view addSubview:qrcodeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
