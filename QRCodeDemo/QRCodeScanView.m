//
//  QRCodeScanView.m
//  QRCodeDemo
//
//  Created by elion on 17/3/23.
//  Copyright © 2017年 elion. All rights reserved.
//

#import "QRCodeScanView.h"
#import <AudioToolbox/AudioToolbox.h>

//扫描框四个角的颜色
#define BordColor  [UIColor redColor]
//扫描线的颜色
#define ScanLineColor  [UIColor redColor]

@interface QRCodeScanView ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
{
    NSTimer *_timer;
    CGFloat _minX;
    CGFloat _minY;
}

@property (nonatomic, strong)AVCaptureSession *session;
@property (nonatomic, strong)AVCaptureDeviceInput *input;
@property (nonatomic, strong)AVCaptureMetadataOutput *output;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *scanView;
@property (nonatomic, strong)UIImageView *scanLine;

@property (nonatomic, strong)UIView *boxView;
@end


@implementation QRCodeScanView


- (void)awakeFromNib
{
    [super awakeFromNib];
    _minX = 0.2;
    _minY = 0.2;
    [self setupUIWithMinX:0.2 minY:0.2];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _minX = 0.2;
        _minY = 0.2;
        [self setupUIWithMinX:0.2 minY:0.2];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame minX:(CGFloat)minX minY:(CGFloat)minY
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _minX = minX;
        _minY = minY;
        [self setupUIWithMinX:minX minY:minY];
    }
    return self;
}

- (void)setupUIWithMinX:(CGFloat)minX minY:(CGFloat)minY
{
    _session = [AVCaptureSession new];

    if (self.input != nil) {
        [_session addInput:self.input];
    } else {
    
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        NSString *message = nil;
        switch (status) {
            case AVAuthorizationStatusNotDetermined:
                message = @"用户尚未作出关于应用是否可以访问相机的选择";
                break;
            case AVAuthorizationStatusRestricted:
                message = @"应用没有被授权访问媒体类型的硬件";
                break;
            case AVAuthorizationStatusDenied:
                message = @"应用未被授权访问相机,可在设置中打开权限";
                break;
            case AVAuthorizationStatusAuthorized:
                
                break;
            default:
                message = @"";
                break;
        }
        if (message != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    [_session addOutput:self.output];
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeUPCECode];
    [self.layer addSublayer:self.scanView];
    
    CGFloat boxWidth = self.bounds.size.width * (1 - 2*minX);
    //设置扫描范围
    _output.rectOfInterest = CGRectMake(minY, minX, boxWidth/self.bounds.size.height, boxWidth/self.bounds.size.width);
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:maskView];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width * minX, self.bounds.size.height * minY, boxWidth, boxWidth) cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskView.layer.mask = maskLayer;
 
    CGFloat cornerW = boxWidth/10;
    UIView *topLeftView = [self cornImageWithWidth:cornerW position:CGPointMake(1, 1)];
    topLeftView.frame = CGRectMake(self.bounds.size.width * minX, self.bounds.size.height * minY, cornerW, cornerW);
    [self insertSubview:topLeftView belowSubview:maskView];
    
    UIView *topRightView = [self cornImageWithWidth:cornerW position:CGPointMake(-1, 1)];
    topRightView.frame = CGRectMake(self.bounds.size.width * minX + boxWidth - cornerW, self.bounds.size.height * minY, cornerW, cornerW);
    [self insertSubview:topRightView belowSubview:maskView];
    
    UIView *bottomLeftView = [self cornImageWithWidth:cornerW position:CGPointMake(1, -1)];
    bottomLeftView.frame = CGRectMake(self.bounds.size.width * minX, self.bounds.size.height *minY + boxWidth - cornerW, cornerW, cornerW);
    [self insertSubview:bottomLeftView belowSubview:maskView];
    
    UIView *bottomRightView = [self cornImageWithWidth:cornerW position:CGPointMake(-1, -1)];
    bottomRightView.frame = CGRectMake(self.bounds.size.width * minX + boxWidth - cornerW, self.bounds.size.height *minY + boxWidth - cornerW, cornerW, cornerW);
    [self insertSubview:bottomRightView belowSubview:maskView];
    
    //扫描线
    _scanLine = [[UIImageView alloc] init];
    _scanLine.frame = CGRectMake(self.bounds.size.width * minX, self.bounds.size.height * minY, boxWidth, 1.5);
    _scanLine.backgroundColor = ScanLineColor;
    [self insertSubview:_scanLine belowSubview:maskView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [_timer fire];
    
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * minY + boxWidth + 15, self.bounds.size.width, 20)];
    _detailLabel.textColor = [UIColor whiteColor];
    _detailLabel.font = [UIFont systemFontOfSize:15];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.text = @"将二维码放入扫描框内,即可自动扫描";
    [self addSubview:_detailLabel];
        
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width - 100)/2.0, CGRectGetMaxY(_detailLabel.frame) + 30, 100, 40)];
    [button addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"打开手电筒" forState:UIControlStateNormal];
    [button setTitle:@"关闭手电筒" forState:UIControlStateSelected];
    [self addSubview:button];
    
    [self startScan];
}

- (UIView *)cornImageWithWidth:(CGFloat)width position:(CGPoint)point
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    view.backgroundColor = BordColor;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x * width/5.0, point.y * width/5.0, width, width) cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    return view;
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLine.frame;
    
    CGFloat boxWidth = self.bounds.size.width * (1 - 2*_minX);
    
    if (self.frame.size.height * _minY + boxWidth - 3 < _scanLine.frame.origin.y) {
        frame.origin.y = self.bounds.size.height * _minY;
        _scanLine.frame = frame;
    }else{
        frame.origin.y += 3;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLine.frame = frame;
        }];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        [self stopScan];
        if (self.scanFinishBlock != nil) {
            [self playBeep];
            self.scanFinishBlock(captureOutput,metadataObjects,connection);
        }
    }
}


#pragma mark - 开始/暂停扫描
- (void)startScan
{
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate date]];
    [self.session startRunning];
}

- (void)stopScan
{
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate distantFuture]];
    [self.session stopRunning];
}

//扫描震动
- (void)playBeep
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)openLight:(UIButton *)sender
{
    sender.selected = !sender.selected;
    BOOL isopen = sender.selected;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    if (![device hasTorch]) {
    } else {
        if (isopen) {
            // 开启闪光灯
            if(device.torchMode != AVCaptureTorchModeOn ||
               device.flashMode != AVCaptureFlashModeOn){
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                [device unlockForConfiguration];
            }
        } else {
            // 关闭闪光灯
            if(device.torchMode != AVCaptureTorchModeOff ||
               device.flashMode != AVCaptureFlashModeOff){
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                [device unlockForConfiguration];
            }
        }
    }
}

#pragma mark - 懒加载
- (AVCaptureMetadataOutput *)output
{
    if (_output == nil) {
        _output = [AVCaptureMetadataOutput new];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _output;
}
- (AVCaptureDeviceInput *)input
{
    if (_input == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        NSLog(@"二维码扫描 error------%@",error);
    }
    return _input;
}

- (AVCaptureVideoPreviewLayer *)scanView
{
    if (_scanView == nil) {
        _scanView = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
        _scanView.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _scanView.frame = self.bounds;
    }
    return _scanView;
}

@end
