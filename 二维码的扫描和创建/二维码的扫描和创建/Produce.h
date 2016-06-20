//
//  Produce.h
//  二维码生成和扫描
//
//  Created by tusm on 16/6/21.
//  Copyright © 2016年 zhengjinahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureVideoPreviewLayer;
@interface Produce : UIViewController

- (AVCaptureVideoPreviewLayer *)configurationDeviceAddToView:(UIView *)withView;
- (void)viewForScanningScope:(UIView *)withView;
@property (nonatomic,retain)NSString                   *metadataStr;
@property (nonatomic,retain)AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic,retain)UITextView                 *textView;
@property (nonatomic,retain)UIView                     *viewWithRect;

@end
