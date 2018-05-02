//
//  GroupQRCodeViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/5/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "GroupQRCodeViewController.h"
#import "SPUtil.h"

@interface GroupQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end

@implementation GroupQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tips setText:self.tribe.tribeType == YWTribeTypeNormal ? @"扫描上面的二维码，加入群" : @"扫描上面的二维码，加入讨论组"];
    
    self.nameLabel.text = self.tribe.tribeName;
    self.avatarImageView.image = [[SPUtil sharedInstance] avatarForTribe:self.tribe];
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) * 0.5;
    self.avatarImageView.clipsToBounds = YES;
    
    NSString *qrcodeContent = [NSString stringWithFormat:@"openimdemo://mp.wangxin.taobao.com/searchTribe?tribeId=%@", self.tribe.tribeId];
    UIImage *image = [self generateQRCodeImageWithText:qrcodeContent size:self.qrCodeImageView.frame.size];
    
    self.qrCodeImageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)generateQRCodeImageWithText:(NSString *)text size:(CGSize)size {
    if ([[UIDevice currentDevice].systemVersion compare:@"7.0"] == NSOrderedAscending) {
        return nil;
    }
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    CIImage *qrcodeImage = [filter outputImage];
    
    CGFloat scaleX = size.width / qrcodeImage.extent.size.width;
    CGFloat scaleY = size.height / qrcodeImage.extent.size.height;
    CGAffineTransform transform = CGAffineTransformMakeScale(scaleX, scaleY);
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:transform];
    
    UIImage *image = [UIImage imageWithCIImage:transformedImage];
    return image;
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
