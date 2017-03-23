//
//  QRCodeScanView.h
//  QRCodeDemo
//
//  Created by elion on 17/3/23.
//  Copyright © 2017年 elion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRCodeScanView : UIView

@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UILabel *descriptionLabel;

@property (nonatomic, copy)void (^scanFinishBlock)(AVCaptureOutput *captureOutput, NSArray *metadataObjects, AVCaptureConnection *connection);

/**
 *  初始化扫描视图
 *
 *  @param frame 扫描视图的frame
 *  @param minX  扫描区域距视图左边界的比例
 *  @param minY  扫描区域距视图上边界的比例
 */
- (instancetype)initWithFrame:(CGRect)frame minX:(CGFloat)minX minY:(CGFloat)minY;

/**
 *  开始扫描
 */
- (void)startScan;

/**
 *  暂停扫描
 */
- (void)stopScan;

@end
