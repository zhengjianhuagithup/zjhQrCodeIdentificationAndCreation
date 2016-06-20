//
//  Identify.m
//  二维码生成和扫描
//
//  Created by tusm on 16/6/21.
//  Copyright © 2016年 zhengjinahua. All rights reserved.
//

#import "Identify.h"

@interface Identify ()

@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)UITextView  *textVie;
@property (nonatomic,retain)UIButton    *sureBT;
@property (nonatomic,retain)UIButton    *cencelBT;
@end

@implementation Identify

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textVie = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    _textVie.center = self.view.center;
    [self.view addSubview:self.textVie];
    _textVie.backgroundColor = [UIColor orangeColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createButton];
    
}

- (void)createButton {
    
    self.sureBT = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sureBT.frame = CGRectMake(50, self.view.frame.size.height - 80, 50, 30);
    [self.sureBT addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBT setTitle:@"确定" forState:UIControlStateNormal];
    
    _cencelBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _cencelBT.frame = CGRectMake(220, self.view.frame.size.height - 80, 80, 30);
    [_cencelBT addTarget:self action:@selector(createAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cencelBT setTitle:@"取消" forState:UIControlStateNormal];
    
    [self.view addSubview:_sureBT];
    [self.view addSubview:_cencelBT];

}


- (void)sureAction:(UIButton *)button {
    
    if (self.textVie.text.length == 0) {
        
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提箱" message:@"请输入内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alerView show];
        return;
    }
    [self configuration];
}

- (void)createAction:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)configuration {
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    
    //创建一个二维码的滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    //将字符串转换成NSData
    NSData *data = [self.textVie.text dataUsingEncoding:NSUTF8StringEncoding];
    //赋给滤镜数据
    [filter setValue:data forKey:@"inputMessage"];
    //获得滤镜输出的图像
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,然后放大
    self.imageView.image=[self image:outputImage forSize:150];
    
    //为相框加上阴影效果
    self.imageView.layer.shadowOffset  = CGSizeMake(0, 0.5);            //设置阴影的偏移量
    self.imageView.layer.shadowRadius  = 3;                             //设置阴影的半径
    self.imageView.layer.shadowColor   = [UIColor blackColor].CGColor;  //设置阴影的颜色为黑色
    self.imageView.layer.shadowOpacity = 0.4;                           //设置引用透明的
}


//将CIiamge转化为UIimage，并设置尺寸
- (UIImage *)image:(CIImage *)image forSize:(CGFloat) size {
    
    //返回一个整数，将矩形的值转变成整数，得到一个最小的矩形
    CGRect rect = CGRectIntegral(image.extent);
    //得到宽长比
    CGFloat scale = MIN(size/CGRectGetWidth(rect), size/CGRectGetHeight(rect));
    
    // 创建位图;
    size_t width  = CGRectGetWidth(rect)  * scale;
    size_t height = CGRectGetHeight(rect) * scale;
    CGColorSpaceRef ref    = CGColorSpaceCreateDeviceGray();
    //配置bitmap
    CGContextRef contxteRef = CGBitmapContextCreate(nil, width, height, 8, 0, ref, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *ci = [CIContext contextWithOptions:nil];
    CGImageRef bitmap = [ci createCGImage:image fromRect:rect];
    CGContextSetInterpolationQuality(contxteRef, kCGInterpolationNone);
    CGContextScaleCTM(contxteRef, scale, scale);
    CGContextDrawImage(contxteRef, rect, bitmap);
    
    // 转换为图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(contxteRef);
    CGContextRelease(contxteRef);
    CGImageRelease(bitmap);
    return [UIImage imageWithCGImage:scaledImage];
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
