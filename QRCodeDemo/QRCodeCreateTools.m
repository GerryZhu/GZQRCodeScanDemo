//
//  QRCodeCreateTools.m
//  QRCodeDemo
//
//  Created by elion on 17/3/23.
//  Copyright © 2017年 elion. All rights reserved.
//

#import "QRCodeCreateTools.h"

@implementation QRCodeCreateTools

+ (UIImage *)creatQRCodeWithUrlstring:(NSString *)urlString imageWidth:(CGFloat)width withIcon:(UIImage *)icon withScale:(CGFloat)scale
{
    UIImage *QRImage = [self creatQRCodeWithUrlstring:urlString imageWidth:width];
    return [self addIconToQRCodeImage:QRImage withIcon:icon withScale:scale];
}

+ (UIImage *)creatQRCodeWithUrlstring:(NSString *)urlString imageWidth:(CGFloat)width
{
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data=[urlString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];//纠错等级越高，识别越易识别，L |  M | Q | H
    CIImage *outputImage=[filter outputImage];
    
    CGFloat scaleX = width / outputImage.extent.size.width;
    CGFloat scaleY = width / outputImage.extent.size.height;
    CIImage *transformedImage = [outputImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    return [UIImage imageWithCIImage:transformedImage];
}

+(UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale 
{
     UIGraphicsBeginImageContext(image.size);
     //通过两张图片进行位置和大小的绘制，实现两张图片的合并
     CGFloat widthOfImage = image.size.width;
     CGFloat heightOfImage = image.size.height;
     CGFloat widthOfIcon = widthOfImage * scale;
     CGFloat heightOfIcon = heightOfImage * scale;
     [image drawInRect:CGRectMake(0, 0, widthOfImage, heightOfImage)];
    icon = [self circleImage:icon withParam:0];
     [icon drawInRect:CGRectMake((widthOfImage-widthOfIcon)/2, (heightOfImage-heightOfIcon)/2,widthOfIcon, heightOfIcon)];
     UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
     
     UIGraphicsEndImageContext();
     return img;
 }

+ (UIImage *)creatBarCode:(NSString *)codeString width:(CGFloat)width height:(CGFloat)height
{
    CIImage *barcodeImage;
    NSData *data = [codeString dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    CGFloat scaleX = width / barcodeImage.extent.size.width;
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

+ (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset 
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,1);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    //在圆区域内画出image原图
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end
