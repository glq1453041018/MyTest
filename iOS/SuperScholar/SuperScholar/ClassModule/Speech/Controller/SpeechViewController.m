//
//  SpeechViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "SpeechViewController.h"
#import "TZImagePickerController.h"
#import "TZVideoPlayerController.h"     // 视频
#import "TZPhotoPreviewController.h"    // 图像
// !!!: 视图类
#import "TZTestCell.h"                  // collection的cell样式
#import "LLListPickView.h"              // 选择视图
// !!!!: 数据类
#import "SpeechManager.h"
// !!!: 其他
#import "TZImageManager.h"
#import "LxGridViewFlowLayout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define kCollectionHeader @"collectionHeader"
#define kCollectionCell @"collectionCell"

const NSInteger numberOfRow = 4;  // 一行几张图片

@interface SpeechViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,LLListPickViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
// !!!: 视图类
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong ,nonatomic) UITextView *contentView;
@property (strong ,nonatomic) UILabel *tipLabel;                // 用来提示
@property (strong ,nonatomic) LLListPickView *pickView;
@property (copy ,nonatomic) NSArray *items;                     // 可操作item
// !!!: 数据类
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (strong ,nonatomic) NSData *videoData;                // 视频数据
@property (copy ,nonatomic) NSString *contentString;    // 说说内容
@property (assign ,nonatomic) BOOL lock;
@end

@implementation SpeechViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化视图
    [self initUI];
}



#pragma mark - <************************** 获取数据 **************************>



#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 导航栏
    [self.navigationBar setTitle:self.title leftText:@"取消" rightText:@"发表"];
    [self changeSenderBtnToUnEnable];
    
    [self.view addSubview:self.collectionView];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
// !!!: UITextView
-(UITextView *)contentView{
    if (_contentView==nil) {
        _contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-10*2, 100 - 10)];
        _contentView.delegate = self;
        _contentView.font = [UIFont systemFontOfSize:FontSize_16];
        [_contentView addSubview:self.tipLabel];
        self.tipLabel.frame = CGRectMake(5, 2.5, _contentView.viewWidth-5*2, 30);
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        [_contentView becomeFirstResponder];
    }
    return _contentView;
}
// !!!: collectioView视图初始化
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
        _margin = 10;
        _itemWH = (kScreenWidth - 2 * _margin - numberOfRow) / numberOfRow - _margin;
        layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 100);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, kScreenWidth, kScreenHeight-self.navigationBar.bottom) collectionViewLayout:layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(_margin, _margin, _margin, _margin);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:kCollectionCell];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionHeader];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
-(UILabel *)tipLabel{
    if (_tipLabel==nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"这一刻的想法...";
        _tipLabel.textColor = FontSize_colorlightgray;
        _tipLabel.font = [UIFont systemFontOfSize:16];
    }
    return _tipLabel;
}

-(LLListPickView *)pickView{
    if (_pickView==nil) {
        _pickView = [LLListPickView new];
        _pickView.delegate = self;
    }
    return _pickView;
}

// !!!: 图片选择器
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationBar.backgroundColor;
        _imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


-(NSMutableArray *)selectedAssets{
    if (_selectedAssets==nil) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}
-(NSMutableArray *)selectedPhotos{
    if (_selectedPhotos==nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

-(NSArray *)items{
    if (_items==nil) {
        _items = @[@"拍照",@"录像",@"去相册选择"];
    }
    return _items;
}


#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)navigationViewRightClickEvent{
    if ([[self.contentString stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0&&self.selectedPhotos.count==0) {
        [[LLAlertView new] showSystemAlertViewClickBlock:nil message:@"请填写内容哦" buttonTitles:@"好的", nil];
    }else{
        [SpeechManager uploadMessageToServerWithMessage:self.contentString classId:self.classId response:^(NSDictionary *res, id error) {
            if (error) {
                [[LLAlertView new] showSystemAlertViewClickBlock:nil message:@"发表失败，请重新上传" buttonTitles:@"好的", nil];
            }
            else{
                NSString *articleId = [NSString stringWithFormat:@"%@",[res objectForKeyNotNull:@"articleId"]];
                if (articleId.length) {
                    // 图片数组
                    NSArray *pics,*videos = nil;
                    if ([self existImage]) {        // 用户选择的是图片类型
                        pics = self.selectedPhotos;
                    }else if ([self existVideo]){   // 用户选择的是视频类型
                        videos = @[self.videoData];
                    }
                    
                    [SpeechManager uploadMediaToServerWithArticleId:articleId.integerValue classId:self.classId images:pics videos:videos response:^(NSArray *resArray, id error) {
                        if (error) {
                            [[LLAlertView new] showSystemAlertViewClickBlock:nil message:@"发表失败，请重新上传" buttonTitles:@"好的", nil];
                        }
                        else{
                            NSString *tip = nil;
                            for (int i=0; i<resArray.count; i++) {
                                if (i) {
                                    tip = [NSString stringWithFormat:@"%@,%@",tip,resArray[i]];
                                }else{
                                    tip = resArray[i];
                                }
                            }
                            [self.contentView resignFirstResponder];
                            WS(ws);
                            [[LLAlertView new] showSystemAlertViewClickBlock:^(NSInteger index) {
                                [ws navigationViewLeftClickEvent];
                            } message:tip buttonTitles:@"好的", nil];
                        }
                    }];
                }
                else{
                    [[LLAlertView new] showSystemAlertViewClickBlock:nil message:@"发表失败，请重新上传" buttonTitles:@"好的", nil];
                }
            }
        }];
    }
}


// !!!: TextView的代理方法
-(void)textViewDidChange:(UITextView *)textView{
    DLog(@"说说内容：%@",textView.text);
    self.contentString = textView.text;
    if ([textView.text isEqualToString:@""]) {
        self.tipLabel.hidden = NO;
        if (self.selectedPhotos.count==0) {
            [self changeSenderBtnToUnEnable];
        }else{
            [self changeSenderBtnToEnable];
        }
    }else{
        self.tipLabel.hidden = YES;
        if ([self.contentString stringByReplacingOccurrencesOfString:@" " withString:@""].length!=0) {
            [self changeSenderBtnToEnable];
        }
    }
}



// !!!: UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self existVideo]) {
        return 1;
    }
    return MIN(self.selectedPhotos.count + 1, 9);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCell forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.hidden = NO;
    if (indexPath.row == self.selectedPhotos.count) {
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
        cell.tipLabel.hidden = NO;
        cell.tipIconImageView.hidden = NO;
        cell.imageView.hidden = YES;
        if (self.selectedPhotos.count>=9) {
            cell.hidden = YES;
            return cell;
        }
    } else {
        cell.imageView.hidden = NO;
        cell.imageView.image = self.selectedPhotos[indexPath.row];
        cell.asset = self.selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
        cell.deleteBtn.tag = indexPath.row;
        cell.tipLabel.hidden = YES;
        cell.tipIconImageView.hidden = YES;
    }
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedPhotos.count) {
        if (self.lock) {
            return;
        }
        [self.view endEditing:YES];
        self.lock = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.lock = NO;
        });
        self.items = @[@"拍照",@"录像",@"去相册选择"];
        if ([self existImage]) {
            self.items = @[@"拍照",@"去相册选择"];
        }
        [self.pickView showItems:self.items];
    }
    else{
        // preview photos or video / 预览照片或者视频
        id asset = self.selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
//            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
//            vc.model = model;
//            [self.navigationController presentViewController:vc animated:YES completion:nil];
        } else if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:indexPath.row];
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self.selectedAssets = [NSMutableArray arrayWithArray:assets];
                [self reloadCollectionView];
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}


// !!!: LxGridViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionHeader forIndexPath:indexPath];
        [headerView addSubview:self.contentView];
        reusableview = headerView;
    }
    return reusableview;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.selectedPhotos.count;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.selectedPhotos.count && destinationIndexPath.item < self.selectedPhotos.count);
}
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = self.selectedPhotos[sourceIndexPath.item];
    [self.selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    id asset = self.selectedAssets[sourceIndexPath.item];
    [self.selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    [self reloadCollectionView];
}


// !!!: LLListPickView代理事件
-(void)lllistPickViewItemSelected:(NSInteger)index{
    NSString *title = self.items[index];
    if ([title isEqualToString:@"拍照"]) {
        [self takePhotoAndCamera:0];
    }
    else if ([title isEqualToString:@"录像"]){
        [self takePhotoAndCamera:1];
    }
    else{
        [self pushImagePickerController];
    }
}



// !!!: imagePickerController的代理方法实现
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                DLog(@"图片保存失败 %@",error);
            } else {
                WS(ws);
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [ws.selectedAssets addObject:assetModel.asset];
                        [ws.selectedPhotos addObject:image];
                        [ws reloadCollectionView];
                    }];
                }];
            }
        }];
    }
    else if([type isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path])) {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

// !!!: TZImagePickerController的代理方法实现
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    DLog(@"user click cancel button");
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    [self reloadCollectionView];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    self.selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    self.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [self reloadCollectionView];
}

//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
//    self.selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
//    self.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
//    [self reloadCollectionView];
//}



#pragma mark - <************************** 点击事件 **************************>
// !!!: 拍照
- (void)takePhotoAndCamera:(NSInteger)tag{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([TZImageManager authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhotoAndCamera:tag];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            if (tag==0) {   // 拍照
                self.imagePickerVc.sourceType = sourceType;
                self.imagePickerVc.mediaTypes=@[(NSString *)kUTTypeImage];
                self.imagePickerVc.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
                if(iOS8Later) {
                    self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                }
            }
            else{
                self.imagePickerVc.sourceType=sourceType;
                self.imagePickerVc.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
                self.imagePickerVc.mediaTypes=@[(NSString *)kUTTypeMovie];
                self.imagePickerVc.videoQuality=UIImagePickerControllerQualityTypeMedium;// 录制质量
                self.imagePickerVc.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
                self.imagePickerVc.videoMaximumDuration = 30; // 最大时长
            }
            [self presentViewController:self.imagePickerVc animated:YES completion:nil];
        } else {
            DLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}
// !!!: push到第三方图片选择控制器中
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // 设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.navigationBar.barTintColor = KColorTheme;
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];
    imagePickerVc.allowPickingImage = ![self existVideo];
    imagePickerVc.allowPickingVideo = ![self existImage];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


// !!!: 删除图片
- (void)deleteBtnClik:(UIButton *)sender {
    [self.selectedPhotos removeObjectAtIndex:sender.tag];
    [self.selectedAssets removeObjectAtIndex:sender.tag];
    DLog(@"%ld",sender.tag);
    [self reloadCollectionView];
}


#pragma mark - <************************** 其他方法 **************************>
// !!!: 刷新CollectionView
-(void)reloadCollectionView{
    [self.collectionView reloadData];
    // 发表按钮的样式
    if (self.selectedPhotos.count==0&&self.contentString.length==0) {
        [self changeSenderBtnToUnEnable];
    }else{
        [self changeSenderBtnToEnable];
    }
}

// !!!: 改变发表按钮
-(void)changeSenderBtnToUnEnable{
    self.navigationBar.rightBtn.userInteractionEnabled = NO;
    self.navigationBar.rightBtn.hidden = YES;
}

-(void)changeSenderBtnToEnable{
    self.navigationBar.rightBtn.userInteractionEnabled = YES;
    self.navigationBar.rightBtn.hidden = NO;
}



// !!!: 是否存在视频资源
-(BOOL)existVideo{
    for (id asset in self.selectedAssets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            if (phAsset.mediaType == PHAssetMediaTypeVideo) {
                return YES;
            }
        }
        else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            if ([[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                return YES;
            }
        }
    }
    return NO;
}

// !!!: 是否存在图片资源
-(BOOL)existImage{
    for (id asset in self.selectedAssets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            if (phAsset.mediaType == PHAssetMediaTypeImage) {
                return YES;
            }
        }
        else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            if ([[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                return YES;
            }
        }
    }
    return NO;
}




// !!!: 保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        DLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        DLog(@"保存视频成功");
        // 记录视频数据
        self.videoData = [NSData dataWithContentsOfFile:videoPath];
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        WS(ws);
        [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO needFetchAssets:NO completion:^(TZAlbumModel *model) {
            [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:YES allowPickingImage:NO completion:^(NSArray<TZAssetModel *> *models) {
                [tzImagePickerVc hideProgressHUD];
                TZAssetModel *assetModel = [models firstObject];
                if (tzImagePickerVc.sortAscendingByModificationDate) {
                    assetModel = [models lastObject];
                }
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                [[PHImageManager defaultManager] requestImageForAsset:assetModel.asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                    [ws.selectedAssets addObject:assetModel.asset];
                    [ws.selectedPhotos addObject:result];
                    [ws reloadCollectionView];
                }];
            }];
        }];
    }
    
}

#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
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
