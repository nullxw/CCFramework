//
//  CCCaptureHelper.m
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


#import "CCCaptureHelper.h"

@interface CCCaptureHelper ()

@property (nonatomic, copy) DidOutputSampleBufferBlock didOutputSampleBuffer;

@property (nonatomic, strong) dispatch_queue_t captureSessionQueue;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *captureInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *captureOutput;

@end

@implementation CCCaptureHelper

- (void)setDidOutputSampleBufferHandle:(DidOutputSampleBufferBlock)didOutputSampleBuffer {
    self.didOutputSampleBuffer = didOutputSampleBuffer;
}

- (void)showCaptureOnView:(UIView *)preview {
    dispatch_async(self.captureSessionQueue, ^{
        [self.captureSession startRunning];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.captureVideoPreviewLayer.frame = preview.bounds;
            [preview.layer addSublayer:self.captureVideoPreviewLayer];
        });
    });
}

#pragma mark - Propertys

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];

        AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

        _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
        if ([_captureSession canAddInput:self.captureInput])
            [self.captureSession addInput:self.captureInput];

        _captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        _captureOutput.alwaysDiscardsLateVideoFrames = YES;
        [_captureOutput setSampleBufferDelegate:self queue:self.captureSessionQueue];
        NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [_captureOutput setVideoSettings:videoSettings];
        [self.captureSession addOutput:self.captureOutput];

        NSString* preset = 0;
        if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
            [UIScreen mainScreen].scale > 1 &&
            [inputDevice
             supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
                preset = AVCaptureSessionPresetiFrame960x540;
            }
        if (!preset) {
            preset = AVCaptureSessionPresetMedium;
        }
        self.captureSession.sessionPreset = preset;
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer {
    if (!_captureVideoPreviewLayer) {
        _captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _captureVideoPreviewLayer;
}

#pragma mark - Life Cycle

- (id)init {
    self = [super init];
    if (self) {
        _captureSessionQueue = dispatch_queue_create("com.CC.captureSessionQueue", 0);
    }
    return self;
}

- (void)dealloc {
    _captureSessionQueue = nil;
    _captureVideoPreviewLayer = nil;

    if (![_captureSession canAddOutput:self.captureOutput])
        [_captureSession removeOutput:self.captureOutput];
    self.captureOutput = nil;

    [_captureSession stopRunning];
    _captureSession = nil;
}

#pragma mark - AVCaptureVideoDataOutputSampleBuffer Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (self.didOutputSampleBuffer) {
        self.didOutputSampleBuffer(sampleBuffer);
    }
}

@end
