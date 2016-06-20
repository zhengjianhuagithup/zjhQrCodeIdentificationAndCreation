//
//  Produce.m
//  二维码生成和扫描
//
//  Created by tusm on 16/6/21.
//  Copyright © 2016年 zhengjinahua. All rights reserved.
//

#import "Produce.h"
#import <AVFoundation/AVFoundation.h>

@interface Produce ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,retain)AVCaptureSession  *captureSession;
@property (nonatomic,retain)CALayer           *layer;
@property (nonatomic,assign)BOOL              up;
@end

@implementation Produce

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (AVCaptureVideoPreviewLayer *)configurationDeviceAddToView:(UIView *)withView{
    
    //初始化捕捉设备，并配置类型。
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    //输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //范围设置
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    _captureSession = [[AVCaptureSession alloc] init];
    //添加输入输出
    if ([_captureSession canAddInput:input] && [_captureSession canAddOutput:captureMetadataOutput]) {
        
        [_captureSession addInput:input];
        [_captureSession addOutput:captureMetadataOutput];

    }
    
    //输出代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置输出媒体数据类型为QRCode类型的二维码，同时还可以添加更多的类型，比如条形码，Aztec类型的二维码等
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //预览层配置
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:withView.bounds];
    
    

    
    //开始
    [_captureSession startRunning];
    
    return _videoPreviewLayer;
}

- (void)viewForScanningScope:(UIView *)withView {
    
    _viewWithRect = [[UIView alloc]initWithFrame:CGRectMake(0, 0, withView.frame.size.width * 0.6, withView.frame.size.height * 0.5)];
    _viewWithRect.center = withView.center;
    _viewWithRect.layer.borderColor = [UIColor orangeColor].CGColor;
    _viewWithRect.layer.borderWidth = 2;
    
    [withView addSubview:_viewWithRect];

    //扫描线设置并加入到框中,并为其创建一个定时器，实现流动效果
    _layer = [[CALayer alloc]init];
    _layer.frame    = CGRectMake(0, 0, _viewWithRect.frame.size.width, 1);
    _layer.backgroundColor = [UIColor whiteColor].CGColor;
    [_viewWithRect.layer addSublayer:_layer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [timer fire];
    
}

//每次改变y值，实现移动效果
- (void)timerAction {
    
    CGFloat layerOY  = _layer.frame.origin.y;
    CGFloat viewWRSY = _viewWithRect.frame.size.height;
    if (layerOY < viewWRSY && !_up) {
        
        layerOY += 10;
        CGRect rect = _layer.frame;
        rect.origin.y = layerOY;
        _layer.frame = rect;
    } else {
        
        layerOY = 0;
        CGRect rect = _layer.frame;
        rect.origin.y = 0;
        _layer.frame = rect;
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            NSRange range4 = NSMakeRange(0, 4);
            NSRange range3 = NSMakeRange(0, 3);
            
            NSString *string3 = [[metadataObj stringValue] substringWithRange:range3];
            NSString *string4 = [[metadataObj stringValue] substringWithRange:range4];
            
            //判断是否为网址，如果是就调用浏览器打开
            if ([string4 isEqualToString:@"http"] || [string3 isEqualToString:@"www"]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[metadataObj stringValue]]];

            }else {
                
                [self.captureSession stopRunning];
                self.textView = [[UITextView alloc]initWithFrame:_viewWithRect.bounds];
                [_viewWithRect addSubview:self.textView];
                self.textView.text = [metadataObj stringValue];
            }
        }
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
