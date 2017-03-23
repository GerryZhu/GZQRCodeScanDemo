//
//  GZQRCodeViewController.m
//  QRCodeDemo
//
//  Created by elion on 17/3/23.
//  Copyright © 2017年 elion. All rights reserved.
//

#import "GZQRCodeViewController.h"
#import "QRCodeCreateTools.h"

@interface GZQRCodeViewController ()

@end

@implementation GZQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *qrcodeView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 200)/2.0, 80, 200, 200)];
    UIImage *qrcode = [QRCodeCreateTools creatQRCodeWithUrlstring:@"这是一个二维码" imageWidth:200];
    qrcodeView.image = qrcode;
    [self.view addSubview:qrcodeView];

    UIImageView *iconQrcodeView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 200)/2.0, 300, 200, 200)];
    UIImage *icon = [UIImage imageNamed:@"icon"];
    UIImage *iconQrcode = [QRCodeCreateTools creatQRCodeWithUrlstring:@"这是一个带头像的二维码" imageWidth:200 withIcon:icon withScale:0.2];
    iconQrcodeView.image = iconQrcode;
    [self.view addSubview:iconQrcodeView];
    
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
