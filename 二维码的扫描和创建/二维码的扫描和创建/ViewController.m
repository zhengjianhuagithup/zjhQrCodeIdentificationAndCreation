//
//  ViewController.m
//  二维码生成和扫描
//
//  Created by tusm on 16/6/20.
//  Copyright © 2016年 zhengjinahua. All rights reserved.
//

#import "ViewController.h"
#import "Produce.h"
#import "Identify.h"

@interface ViewController ()

@property (nonatomic,retain) Produce  *produce;
@property (nonatomic,retain) UIButton *sweepBT;
@property (nonatomic,retain) UIButton *cancelBT;
@property (nonatomic,retain) UIButton *backBT;
@property (nonatomic,retain) Identify *identify;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.identify = [[Identify alloc]init];
    [self createbutton];
}

//配置按钮
- (void)createbutton {
    
    self.sweepBT = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sweepBT.frame = CGRectMake(50, self.view.frame.size.height - 80, 50, 30);
    [self.sweepBT addTarget:self action:@selector(sweepTheYard:) forControlEvents:UIControlEventTouchUpInside];
    [self.sweepBT setTitle:@"扫一扫" forState:UIControlStateNormal];
    
    _createQrBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _createQrBT.frame = CGRectMake(220, self.view.frame.size.height - 80, 80, 30);
    [_createQrBT addTarget:self action:@selector(createQrcode:) forControlEvents:UIControlEventTouchUpInside];
    [_createQrBT setTitle:@"创建二维码" forState:UIControlStateNormal];
    
    
    _cancelBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelBT.frame = CGRectMake(50, self.view.frame.size.height - 80, 50, 30);
    [_cancelBT addTarget:self action:@selector(sweepTheYard:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBT setTitle:@"重扫" forState:UIControlStateNormal];
    _cancelBT.hidden = YES;
    
    _backBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBT.frame = CGRectMake(200, self.view.frame.size.height - 80, 50, 30);
    [_backBT addTarget:self action:@selector(cancelBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backBT setTitle:@"返回" forState:UIControlStateNormal];
    _backBT.hidden = YES;

    
    [self.view addSubview:_sweepBT];
    [self.view addSubview:_createQrBT];
    [self.view addSubview:_cancelBT];
    [self.view addSubview:_backBT];
}

//点击实现扫一扫
- (void)sweepTheYard:(UIButton *)sender {
    
    _produce = [[Produce alloc]init];
    [self.produce.textView removeFromSuperview];
    self.produce.textView = nil;
    [self.view.layer addSublayer: (CALayer *)[_produce configurationDeviceAddToView:self.view]];
    [self.view.layer addSublayer:_cancelBT.layer];
    [self.view.layer addSublayer:_backBT.layer];
    [_produce viewForScanningScope:self.view];
    _cancelBT.hidden = NO;
    _backBT.hidden = NO;
}

//返回按钮，移除所有子视图
- (void)cancelBTAction:(UIButton *)sender {
 
    [_produce removeFromParentViewController];
    [(CALayer *)_produce.videoPreviewLayer removeFromSuperlayer];
    [_produce.textView removeFromSuperview];
    [_produce.viewWithRect removeFromSuperview];
    _produce.viewWithRect      = nil;
    _produce.textView          = nil;
    _produce.videoPreviewLayer = nil;
    _cancelBT.hidden = YES;
    _backBT.hidden   = YES;
    
}

//二维码制作
- (void)createQrcode:(UIButton *)sender {
    
    [self presentViewController:self.identify animated:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
