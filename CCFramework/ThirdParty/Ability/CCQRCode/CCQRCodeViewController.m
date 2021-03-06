//
//  CCQRCodeViewController.m
//  CCFramework
//
// Copyright (c) 2015 CC ( http://www.ccskill.com )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "CCQRCodeViewController.h"
#import "CCCaptureHelper.h"
#import "CCVideoOutputSampleBufferFactory.h"
#import "CCScanningView.h"
#import "CCFoundationCommon.h"
#import "UIButton+Additions.h"
#import "CCCameraViewController.h"
#import "CCQRCodeDisplayViewController.h"
#import "UIView+Frame.h"

#define kCCScanningButtonPadding 36

typedef void (^Outcomeblock)(NSString *outcome);

@interface CCQRCodeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CCCaptureHelperDelegate>

@property(nonatomic, strong) UIView *preview;

@property(nonatomic, strong) CCScanningView *scanningView;
@property(nonatomic, strong) UIButton *scanQRCodeButton;
@property(nonatomic, strong) UIButton *scanBookButton;
@property(nonatomic, strong) UIButton *scanStreetButton;
@property(nonatomic, strong) UIButton *scanWordButton;
@property(nonatomic, strong) UIButton *analysisToast;

@property(nonatomic, strong) CCCaptureHelper *captureHelper;

@property(nonatomic, strong) CCCameraViewController *cameraViewController;

@property(nonatomic, strong) Outcomeblock outcomeblock;

@end

@implementation CCQRCodeViewController

#pragma mark - Action

- (void)scanButtonClicked:(UIButton *)sender
{
    if (sender.tag != 999) {
        self.scanQRCodeButton.selected = (sender == self.scanQRCodeButton);
        self.scanBookButton.selected = (sender == self.scanBookButton);
        self.scanStreetButton.selected = (sender == self.scanStreetButton);
        self.scanWordButton.selected = (sender == self.scanWordButton);

        [self.scanningView transformScanningTypeWithStyle:sender.tag];
    } else {
        sender.hidden = YES;
        [self.captureHelper startRunning];
    }
}

#pragma mark - Propertys

- (UIButton *)createBottomButton
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self
               action:@selector(scanButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)preview
{
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _preview;
}

- (CCScanningView *)scanningView
{
    if (!_scanningView) {
        _scanningView = [[CCScanningView alloc] initWithFrame:CGRectMake(0, (CURRENT_SYS_VERSION >= 7.0 ? 0 : 0), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - (CURRENT_SYS_VERSION >= 7.0 ? 0 : 44))];
    }
    return _scanningView;
}

- (UIView *)buttonContainerView
{
    if (!_buttonContainerView) {
        _buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 140 - [CCFoundationCommon getAdapterHeight], CGRectGetWidth(self.view.bounds), 80)];
        _buttonContainerView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];

        [_buttonContainerView addSubview:self.scanQRCodeButton];
        [_buttonContainerView addSubview:self.scanBookButton];
        [_buttonContainerView addSubview:self.scanStreetButton];
        [_buttonContainerView addSubview:self.scanWordButton];
    }
    return _buttonContainerView;
}

- (UIButton *)scanQRCodeButton
{
    if (!_scanQRCodeButton) {
        _scanQRCodeButton = [self createBottomButton];
        _scanQRCodeButton.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - kCCScanningButtonPadding * 1.5 - 35 * 2, 8, 35, CGRectGetHeight(self.buttonContainerView.bounds) - 16);
        _scanQRCodeButton.tag = 0;
        [_scanQRCodeButton setImage:CCResourceImage(@"ScanQRCode")
                           forState:UIControlStateNormal];
        [_scanQRCodeButton setImage:CCResourceImage(@"ScanQRCode_HL")
                           forState:UIControlStateSelected];
        _scanQRCodeButton.selected = YES;
        [_scanQRCodeButton setTitle:@"扫码" forState:UIControlStateNormal];
        //        [_scanQRCodeButton setTitlePositionWithType:CCButtonTitlePostionTypeBottom];
    }
    return _scanQRCodeButton;
}
- (UIButton *)scanBookButton
{
    if (!_scanBookButton) {
        _scanBookButton = [self createBottomButton];
        CGRect scanBookButtonFrame = self.scanQRCodeButton.frame;
        scanBookButtonFrame.origin.x += kCCScanningButtonPadding + CGRectGetWidth(self.scanQRCodeButton.bounds);
        _scanBookButton.frame = scanBookButtonFrame;
        _scanBookButton.tag = 1;
        [_scanBookButton setImage:CCResourceImage(@"ScanBook")
                         forState:UIControlStateNormal];
        [_scanBookButton setImage:CCResourceImage(@"ScanBook_HL")
                         forState:UIControlStateSelected];
        [_scanBookButton setTitle:@"封面" forState:UIControlStateNormal];
        //        [_scanBookButton setTitlePositionWithType:CCButtonTitlePostionTypeBottom];
    }
    return _scanBookButton;
}
- (UIButton *)scanStreetButton
{
    if (!_scanStreetButton) {
        _scanStreetButton = [self createBottomButton];
        CGRect scanBookButtonFrame = self.scanBookButton.frame;
        scanBookButtonFrame.origin.x += kCCScanningButtonPadding + CGRectGetWidth(self.scanQRCodeButton.bounds);
        _scanStreetButton.frame = scanBookButtonFrame;
        _scanStreetButton.tag = 2;
        [_scanStreetButton setImage:CCResourceImage(@"ScanStreet")
                           forState:UIControlStateNormal];
        [_scanStreetButton setImage:CCResourceImage(@"ScanStreet_HL")
                           forState:UIControlStateSelected];
        [_scanStreetButton setTitle:@"街景" forState:UIControlStateNormal];
        //        [_scanStreetButton setTitlePositionWithType:CCButtonTitlePostionTypeBottom];
    }
    return _scanStreetButton;
}
- (UIButton *)scanWordButton
{
    if (!_scanWordButton) {
        _scanWordButton = [self createBottomButton];
        CGRect scanBookButtonFrame = self.scanStreetButton.frame;
        scanBookButtonFrame.origin.x += kCCScanningButtonPadding + CGRectGetWidth(self.scanQRCodeButton.bounds);
        _scanWordButton.frame = scanBookButtonFrame;
        _scanWordButton.tag = 3;
        [_scanWordButton setImage:CCResourceImage(@"ScanWord")
                         forState:UIControlStateNormal];
        [_scanWordButton setImage:CCResourceImage(@"ScanWord_HL")
                         forState:UIControlStateSelected];
        [_scanWordButton setTitle:@"翻译" forState:UIControlStateNormal];
        //        [_scanWordButton setTitlePositionWithType:CCButtonTitlePostionTypeBottom];
    }
    return _scanWordButton;
}

- (CCCaptureHelper *)captureHelper
{
    if (!_captureHelper) {
        _captureHelper = [[CCCaptureHelper alloc] init];
        _captureHelper.delegate = self;
    }
    return _captureHelper;
}

/**
 *  @author CC, 16-02-22
 *
 *  @brief 切换照明
 */
- (void)switchTorch
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash])
        [self.captureHelper switchTorch];
}

/**
 *  @author CC, 16-02-23
 *
 *  @brief 扫描提示
 */
- (UIView *)analysisToast
{
    if (!_analysisToast) {
        _analysisToast = [self createBottomButton];
        _analysisToast.frame = self.view.bounds;
        _analysisToast.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        _analysisToast.hidden = YES;
        _analysisToast.tag = 999;
        [self.view addSubview:_analysisToast];
        [self.view bringSubviewToFront:_analysisToast];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, (_analysisToast.height - 40) / 2, _analysisToast.width, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"未发现二维码";
        [_analysisToast addSubview:title];

        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, title.bottom, _analysisToast.width, 20)];
        content.font = [UIFont systemFontOfSize:12];
        content.backgroundColor = [UIColor clearColor];
        content.textColor = [UIColor lightGrayColor];
        content.textAlignment = NSTextAlignmentCenter;
        content.text = @"轻触屏幕继续扫描";
        [_analysisToast addSubview:content];
    }
    return _analysisToast;
}

#pragma mark - 扫描委托
/**
 *  @author CC, 2015-10-12
 *
 *  @brief  扫描返回结果系统自带
 *
 *  @param capture 当前对象
 *  @param result  扫描之后的结果
 */
- (void)DidOutputSampleBufferBlock:(CCCaptureHelper *)capture
                        ScanResult:(NSString *)result
{
    [self.captureHelper stopRunning];
    [self scanDealWithResult:result];
}

/**
 *  @author CC, 2015-10-12
 *
 *  @brief  扫描返回的结果
 *
 *  @param capture      当前对象
 *  @param sampleBuffer 扫描结果对象
 */
- (void)DidOutputSampleBufferBlock:(CCCaptureHelper *)capture
                 CMSampleBufferRef:(CMSampleBufferRef)sampleBuffer
{
    [self analysisQRCode:[CCVideoOutputSampleBufferFactory
                          imageFromSampleBuffer:sampleBuffer]];
}

/**
 *  @author CC, 2015-10-09
 *
 *  @brief  分析二维码
 *
 *  @param qrCode 二维码图片
 */
- (void)analysisQRCode:(UIImage *)qrCode
{
    //检测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];

    //监测到的结果数组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:qrCode.CGImage]];

    if (features.count >= 1) {
        /**结果对象 */
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        [self scanDealWithResult:scannedResult];
    } else {
        //        [self.captureHelper startRunning];
        self.analysisToast.hidden = NO;
    }
}

/**
 *  @author CC, 2015-10-20
 *
 *  @brief  处理方式
 *
 *  @param resultAddress 扫描结果地址
 */
- (void)scanDealWithResult:(NSString *)resultAddress
{
    if (_scanDealWithResult) { //系统处理
        MainThread(^() {
            CCQRCodeDisplayViewController *viewController = [[CCQRCodeDisplayViewController alloc] init];
            viewController.baseURL = resultAddress;
            [self pushNewViewController:viewController];
        });
    } else { // 自行处理
        if (_outcomeblock)
            _outcomeblock(resultAddress);

        [self didDiAnalysisOutcome:resultAddress];
    }
}

/**
 *  @author CC, 2015-10-09
 *
 *  @brief  二维码分析结果
 *
 *  @param block 返回结果回调函数
 */
- (void)diAnalysisOutcome:(void (^)(NSString *))block
{
    _outcomeblock = block;
}

/**
 *  @author CC, 16-08-16
 *
 *  @brief 判断是否有使用相机权限
 */
- (BOOL)isCameraUsageRights
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]; //读取设备授权状态
    BOOL isCamera = YES;
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        NSDictionary *applicationInfo = [[NSBundle mainBundle] infoDictionary];
        NSString *applicationName = [applicationInfo objectForKey:(NSString *)kCFBundleNameKey]; //app名称
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机。", applicationName] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alerView show];
        isCamera = NO;
    }
    return isCamera;
}

/**
 *  @author CC, 16-09-18
 *
 *  @brief 二维码解析结果
 *
 *  @param outcome 解析结果
 */
- (void)didDiAnalysisOutcome:(NSString *)outcome
{
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.captureHelper showCaptureOnView:self.preview];

    [self isCameraUsageRights];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = CCLocalization(@"扫一扫");

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(showPhotoLibray)];

    self.view.backgroundColor = [UIColor grayColor];

    [self.view addSubview:self.preview];
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.buttonContainerView];
    _scanDealWithResult = YES;
}

- (void)showPhotoLibray
{
    [self.captureHelper stopRunning];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)startRunning
{
    [self.captureHelper startRunning];
}

- (void)stopRunning
{
    [self.captureHelper stopRunning];
}

- (void)imagePickerController:(UIImagePickerController *)picke didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    WEAKSELF;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf analysisQRCode:image];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.captureHelper = nil;
    self.scanningView = nil;
}

@end
