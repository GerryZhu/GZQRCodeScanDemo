//
//  QRCodeCreateTools.h
//  QRCodeDemo
//
//  Created by elion on 17/3/23.
//  Copyright © 2017年 elion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeCreateTools : NSObject

/**
 *  生成二维码
 *
 *  @param urlString 二维码链接
 *  @param width      二维码图片宽度
 *
 *  @return 二维码图片
 */
+ (UIImage *)creatQRCodeWithUrlstring:(NSString *)urlString imageWidth:(CGFloat)width;

/**
 *  生成二维码中间加 icon
 *
 *  @param urlString 二维码链接
 *  @param width         二维码图片宽度
 *  @param icon         中间图片icon
 *  @param scale        中间图片占二维码的比例
 *
 *  @return 二维码图片
 */
+ (UIImage *)creatQRCodeWithUrlstring:(NSString *)urlString imageWidth:(CGFloat)width withIcon:(UIImage *)icon withScale:(CGFloat)scale;

/**
 *  生成条形码
 *
 *  @param codeString 条形码信息
 *  @param width      条形码宽度
 *  @param height     条形码长度
 *
 *  @return 条形码图片
 */
+ (UIImage *)creatBarCode:(NSString *)codeString width:(CGFloat)width height:(CGFloat)height;

@end
