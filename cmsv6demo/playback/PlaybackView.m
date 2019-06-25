//
//  PlaybackView.m
//  cmsv6
//
//  Created by tongtianxing on 2018/8/23.
//  Copyright © 2018年 babelstar. All rights reserved.
//

#import "PlaybackView.h"
#import "TTXPlaybackSearchModel.h"
#import "netmediaapi.h"
#import "ttxtype.h"
@interface PlaybackView()<TTXAudioPlayDelegate>
{
    //        NSObject *object;
    
}
@end

@implementation PlaybackView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCtrl];
        //        object = [NSObject new];
    }
    return self;
    
}
- (void)createCtrl
{
    self.backgroundColor = [UIColor whiteColor];
    _playbackView = [[UIImageView alloc]init];
    [_playbackView setBackgroundColor:[UIColor blackColor]];
    [self addSubview:_playbackView];
    indicatorView = [[ UIActivityIndicatorView alloc ]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicatorView setColor:[ UIColor whiteColor ]];
    //    indicatorView.hidden = YES;
    CGPoint center = self.center;
    indicatorView.center = center;
    [self addSubview: indicatorView];
    
    _playbackView.frame = self.bounds;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _playbackView.frame = self.bounds;
    CGPoint center = self.center;
    indicatorView.center = center;
    [self bringSubviewToFront:indicatorView];
    
}


- (void)startPlayTimer
{
    if (timerPlay == nil) {
        timerPlay = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(onTimePlay) userInfo:nil repeats:YES];
    }
    //    [[NSRunLoop currentRunLoop]addTimer:timerPlay forMode:NSRunLoopCommonModes];
}
-(void)stopPlayTimer
{
    if (timerPlay != nil) {
        [timerPlay invalidate];
        timerPlay = nil;
    }
}

-(void)onTimePlay
{
    [self updateView];
}
/*
 * 判断是否正在预览
 */
-(void)updateView
{
    if (realHandle != 0) {
        BOOL suc = (NETMEDIA_PBGetRPlayStatus(realHandle) == NETMEDIA_OK);
        NSLog(@"suc = %d",suc);
        if (isLoading != !suc) {
            [self reflash];
            isLoading = !suc;
        }
    }
    if (!isLoading) {
        int videoSize[2] = {0,0};
        BOOL ret  = NETMEDIA_PBGetRPlayImage(realHandle, videoRgb565Length, (char*)videoBuffer.bytes, videoSize, TTX_RGB_FORMAT_888);
        NSLog(@"ret = %d",ret);
        if ( ret != NETMEDIA_OK ) {
            if (videoSize[0] > 0 && videoSize[1] > 0) {
                [self initVideoBuf:videoSize[0] height:videoSize[1]];
            }
        }else{
            if(!isBeginPlay)
            {
                isBeginPlay = true;
                if (self.delegate != nil) {
                    [self.delegate onBeginPlay:self];
                }
            }
            if ([indicatorView isAnimating]) {
                [indicatorView stopAnimating];
            }
            isVideoBmpVaild = YES;
            if (!isPause) {
                _playbackView.image = [self formatImage:videoWidth height:videoHeight];
            }
            
            
        }
    }
    
    BOOL isPlaying = realHandle != 0 ? YES : NO;
    BOOL isPlayFinished = NETMEDIA_PBIsPlayFinished(realHandle) == NETMEDIA_OK ? YES : NO;
    BOOL isDownFinished = NETMEDIA_PBIsDownFinished(realHandle) == NETMEDIA_OK ? YES : NO;
    if (([[NSDate date] timeIntervalSince1970] - mRateTime) >= 1.0 ) {
        if (isPlaying && !isDownFinished && !isLoading && !isPause) {
            int realRate = 0;
            NETMEDIA_PBGetFlowRate(realHandle, &realRate);//  [NSString stringWithFormat:@"%dKB/S", realRate];
            //            NSLog(@"realRate = %d",realRate);
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onPlayBack:rate:)]) {
                [self.delegate onPlayBack:self rate:realRate];
            }
        }
        
        if (isPlaying && !isPause) {
            int playTime = 0;
            int downTime = 0;
            NETMEDIA_PBGetPlayTime(realHandle, &playTime);
            NETMEDIA_PBGetDownTime(realHandle, &downTime);
            if (self.delegate != nil) {
                [self.delegate onUpdatePlay:self downSecond:downTime/1000 playSecond:playTime/1000  downFinish:isDownFinished];
            }
        }
        
        if (isPlayFinished) {//结束
            
        }
        mRateTime = [[NSDate date] timeIntervalSince1970];
    }
    
    //    NETMEDIA_PBGetFlowRate(realHandle, &playRate);
    
    
    
}
-(void)reflash
{
    [self setNeedsDisplay];
}
//把AVPicture转成图片
-(UIImage *)formatImage:(int)width height:(int)height
{
    UIImage *image = nil;
    @try
    {
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
        CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, videoBuffer.bytes, width*3*height, kCFAllocatorNull);
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGImageRef cgImage = CGImageCreate(width,
                                           height,
                                           8,
                                           24,
                                           width*3,
                                           colorSpace,
                                           bitmapInfo,
                                           provider,
                                           NULL,
                                           NO,
                                           kCGRenderingIntentDefault);
        CGColorSpaceRelease(colorSpace);
        image = [UIImage imageWithCGImage:cgImage] ;
        
        CGImageRelease(cgImage);
        CGDataProviderRelease(provider);
        CFRelease(data);
    }
    @catch (NSException *exception)
    {
        image = nil;
    }
    @catch (...)
    {
        image = nil;
    }
    @finally
    {
    }
    
    return image;
}



- (void)resetVideoBuf {
    videoWidth = 0;
    videoHeight = 0;
    videoRgb565Length = 0;
    if (videoBuffer != nil)
    {
        videoBuffer = [NSMutableData data];
    }
    isVideoBmpVaild = NO;
}
- (void)initVideoBuf:(int )nWidth height:(int)nHeight
{
    videoWidth = nWidth;
    videoHeight = nHeight;
    videoRgb565Length = videoWidth * videoHeight * 3;
    videoBuffer = [[NSMutableData alloc]initWithCapacity:videoRgb565Length];
    isVideoBmpVaild = false;
}

-(void)dealloc
{
    NSLog(@"PlaybackView delloc");
}
/*  */
-(BOOL)stopVod
{
    BOOL ret = false;
    if (realHandle != 0) {
        [self stopPlayTimer];
        NETMEDIA_PBStopPlayback(realHandle);
        NETMEDIA_PBClosePlayback(realHandle);
        realHandle = 0;
        isLoading = false;
        playRate = 0;
        [self resetVideoBuf];
        _playbackView.image = nil;
        if ([indicatorView isAnimating])
        {
            [indicatorView stopAnimating ];
        }
        
        //        [self stopSound];
        //        [self updateTitle];
        
        ret = true;
    }
    return ret;
}
-(BOOL)startVod:(TTXPlaybackSearchModel*)model
{
    [self stopVod];
    BOOL ret = false;
    
    NSString *tmpDir =  NSTemporaryDirectory();
    //    NSString *path =  [tmpDir stringByAppendingString:@"/"];
    //      [[NSFileManager defaultManager] createDirectoryAtPath: path withIntermediateDirectories:YES attributes:nil error:nil];
    NETMEDIA_PBOpenPlayBack(&realHandle, [tmpDir UTF8String]);
    //    NETMEDIA_PBStartPlayback(realHandle, model.orginalFileInfo, (int)model.chn, 0, 0, 0);
    if(model.is1078)
    {
         NETMEDIA_PBStartPlayback(realHandle, model.orginalFileInfo, (int)model.chn, 0, 0, false);
    }else{
        if (model.isMultChn) {
        NETMEDIA_PBStartPlayback(realHandle, model.orginalFileInfo, (int)model.selectChn, 0, 0, false);
        }else{
            int chn =(int)model.chn;
            if (model.chn == 98) {
                chn = 0;
            }
         NETMEDIA_PBStartPlayback(realHandle, model.orginalFileInfo, chn, 0, 0, false);
        }
    }
   
    if (realHandle != 0) {
        [indicatorView startAnimating];
        isLoading = true;
        isBeginPlay = false;
        ret = true;
        [self startPlayTimer];
    }
    return ret;
}



//暂停播放
-(void)pause:(BOOL)pause
{
    isPause = pause;
    NETMEDIA_PBPause(realHandle, pause ? 1 : 0);
}
//设置播放时间
- (void)setPlayTime: (int) second {
    NETMEDIA_PBSetPlayTime(realHandle, second * 1000);
}
/*
 * 保存成图片
 */
- (BOOL)savePngFile {
    
    if (isVideoBmpVaild)
    {
        UIImageWriteToSavedPhotosAlbum(_playbackView.image, nil, nil, NULL);
        //NSString  *jpgPath = [self getFileName:@"picture" extend:@"jpg" ];
        //[UIImageJPEGRepresentation(imageViewVideo.image, 1.0) writeToFile:jpgPath atomically:YES];
        return YES;
    }
    else
    {
        return NO;
    }
}
//正在预览
-(BOOL)isViewing
{
    return realHandle != 0 ? true : false;
}

/*
 * 取得音频格式
 */
//- (BOOL)getWavFormat {
////    int lChannels;
////    int lSamplePerSec;
////    int lBitPerSample;
//    int lWavBufLen;
//    char wavBuf[1024];
//
// if(NETMEDIA_OK == NETMEDIA_PBGetWavData(realHandle, wavBuf , &lWavBufLen))
// {
//     return YES;
// }else{
//     return false;
// }
//
//
////    if (NETMEDIA_OK == NETMEDIA_GetWavFormat(realHandle, &lChannels, &lSamplePerSec, &lBitPerSample, &lWavBufLen)) {
////        [mAudioPlay setWavFormat:lChannels Sample:lSamplePerSec Bit:lBitPerSample wavLen:lWavBufLen];
////        return true;
////    } else {
////        return false;
////    }
//}

/*
 * 开始声音播放
 */
- (void)playSound
{
    if(isBeginPlay == true){
    if (realHandle != 0 && mAudioPlay == nil) {
        NETMEDIA_PBPlaySound(realHandle, 1);
        //        NETMEDIA_SetVolume(realHandle, 1);
        mAudioPlay = [[TTXAudioPlay alloc] init];
        mAudioPlay.delegate = self;
        mAudioPlay.defaultFormat = true;
        
        [mAudioPlay playSound];
    }
    }
}
/*
 * 停止声音播放
 */
- (void)stopSound {
    if (mAudioPlay != nil) {
        NETMEDIA_PBPlaySound(realHandle, 0);
        [mAudioPlay stopSound];
        mAudioPlay = nil;
    }
}

- (BOOL)isSounding {
    return mAudioPlay != nil ? YES : NO;
}

#pragma mark TTXAudioPlayDelegate Methods
- (int)playAudio:(TTXAudioPlay *)realplay inBuffer:(void*)buffer length:(int)len
{
    int nReadLen = len;
    NETMEDIA_PBGetWavData(realHandle, buffer, &nReadLen);
    //NSLog(@"NETMEDIA_TBGetWavData len:%d, nReadLen:%d", len, nReadLen);
    return nReadLen;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
