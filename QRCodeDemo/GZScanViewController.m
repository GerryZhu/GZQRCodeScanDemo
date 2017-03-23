//
//  GZScanViewController.m
//  QRCodeDemo
//
//  Created by elion on 17/3/23.
//  Copyright © 2017年 elion. All rights reserved.
//

#import "GZScanViewController.h"
#import "QRCodeScanView.h"

@interface GZScanViewController () <UIAlertViewDelegate>

@property (nonatomic, strong)QRCodeScanView *scanView;

@end

@implementation GZScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view insertSubview:self.scanView atIndex:0];
}

- (QRCodeScanView *)scanView
{
    if (_scanView == nil) {
        _scanView = [[QRCodeScanView alloc] initWithFrame:[UIScreen mainScreen].bounds minX:0.2 minY:0.2];
        
        __weak typeof(self) weakSelf = self;
        _scanView.scanFinishBlock = ^(AVCaptureOutput *captureOutput, NSArray *metadataObjects, AVCaptureConnection *connection) {
            __strong typeof(weakSelf) self = weakSelf;
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            NSString *result;
            NSString *title;
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                result = metadataObj.stringValue;
                title = @"二维码";
                NSLog(@"这是二维码码");
                
            } else {
                result = metadataObj.stringValue;
                title = @"条形码";
                NSLog(@"这是条形码");
            }

            [self reportScanResult:result title:title];
            
        };
    }
    return _scanView;
}

- (void)reportScanResult:(NSString *)result title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:result delegate:self cancelButtonTitle:@"重新扫描" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 0) {
        [self.scanView startScan];
    }
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
