//
//  TTXSubVideo.m
//  cmsv6
//
//  Created by Apple on 13-4-5.
//  Copyright (c) 2013年 babelstar. All rights reserved.
//

#import "TTXSubVideo.h"
//#import "TTXAppDelegate.h"
#import "netmediaapi.h"
#import "ttxtype.h"


typedef enum TTXFilmMode: NSUInteger
{
    E_FilmMode_Original     = 0,
    E_FilmMode_Full         = 1,
    E_FilmMode_16_9         = 2,
    E_FilmMode_4_3          = 3
}E_FilmMode;
@interface TTXSubVideo ()
-(void)createCtrl;
-(void)setCtrlPos;
- (void)addRoundedRectToPath: (CGContextRef)context rc: (CGRect )rect width:(float )ovalWidth height:( float )ovalHeight;
-(CGRect)getFilmRect:(CGRect)rcArea mode:(E_FilmMode)mode;
-(UIImage *)formatImage:(int)width height:(int)height;
-(void)updateTitle;
@end

@implementation TTXSubVideo
@synthesize isFocus;
@synthesize labelChannel;
@synthesize imageViewVideo;
@synthesize channel;
@synthesize viewIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createCtrl ];
    }
    return self;
}

-(void)dealloc
{
    labelChannel = nil;
    imageViewVideo = nil;
//    m_player = nil;
    indicatorView = nil;
//    [super dealloc ];
}

-(void)setFrame:(CGRect)theFrame
{
    [super setFrame:theFrame ];
    [self setCtrlPos ];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    
    float red = isFocus ? 0.0: 100.0/255.0;
    float green = isFocus ? 1.0: 100.0/255.0;
    float blue = isFocus ? 0.0: 100.0/255.0;
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    //画矩形
    //CGContextAddRect( context, rect );
    [self addRoundedRectToPath: context rc:rect width:4 height:4 ];
    //连接上面定义的坐标点
    CGContextStrokePath(context);
    //CGContextClosePath( context );
}

//画圆角矩形
- (void)addRoundedRectToPath: (CGContextRef)context rc: (CGRect )rect width:(float )ovalWidth height:( float )ovalHeight
{
    
    if ( 0 == ovalWidth || 0 == ovalHeight )
    {
        CGContextAddRect(context, rect);
        return;
    }
    float fw = 0.0;
    float fh = 0.0;
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    //CGContextClosePath(context);
    CGContextRestoreGState(context);
    
    CGContextMoveToPoint(context, rect.origin.x + rect.size.width , rect.origin.y + ovalHeight );
    CGContextAddLineToPoint( context, rect.origin.x + rect.size.width ,  rect.origin.y + rect.size.height - ovalHeight );
}

- (void)createCtrl
{
    isFocus = NO;
    
    [self setBackgroundColor:[ UIColor blackColor ]];
    
    imageViewVideo = [[ UIImageView alloc ]init ];
    imageViewVideo.backgroundColor = [UIColor blackColor ];
    [self addSubview: imageViewVideo ];
    
    UIFont* font = [ UIFont fontWithName:@"Arial" size:12 ];
    labelChannel = [[ UILabel alloc] init ];
    [labelChannel setTextAlignment:NSTextAlignmentLeft ];
    [labelChannel setTextColor: [ UIColor whiteColor] ];
    [labelChannel setBackgroundColor:[ UIColor clearColor ] ];
    [labelChannel setFont: font ];
    [self addSubview:labelChannel ];
    
    //m_player = [[ RPPlayer alloc ]init ];
    //[m_player setDelegate: self ];
    
    tipLabel = [[UILabel alloc]init ];
    [tipLabel setTextAlignment:NSTextAlignmentCenter ];
    [tipLabel setTextColor:[ UIColor whiteColor ] ];
    [tipLabel setBackgroundColor:[ UIColor clearColor ] ];
    [tipLabel setFont:font ];
    [tipLabel setText: NSLocalizedString(@"loading", @"") ];
    tipLabel.hidden = YES;
    [self addSubview:tipLabel ];
    
    indicatorView = [[ UIActivityIndicatorView alloc ]init ];
    [self addSubview: indicatorView ];
}

-(void)setCtrlPos
{
    CGRect rcClient = self.bounds;
    const int BORDER_WIDTH = 1;
    
    CGRect rcLabel = rcClient;
    rcLabel.origin.x += 2;
    rcLabel.origin.y += 2;
    rcLabel.size.width = rcClient.size.width - 4 ;
    rcLabel.size.height = 20;
    [labelChannel setFrame: rcLabel ];
    
    CGRect rcArea = rcClient;
    rcArea.origin.x += BORDER_WIDTH;
    rcArea.origin.y += BORDER_WIDTH;
    rcArea.size.width -= 2 * BORDER_WIDTH;
    rcArea.size.height -= 2 * BORDER_WIDTH;
    
    CGRect rcVideo = rcArea;
    //if( isPad )
    {
        rcVideo = [self getFilmRect:rcArea mode:E_FilmMode_16_9 ];
    }
    imageViewVideo.frame = rcVideo;
    
    
    CGRect rcTip = rcClient;
    rcTip.size.height = 20;
    rcTip.origin.y = ( rcClient.size.height - rcTip.size.height ) / 2;
    tipLabel.frame = rcTip;
    
    CGRect rcIndicator;
    int nIndicatorWidth = 24;
    int nIndecatorHeight = 24;
    rcIndicator.origin.x = ( rcClient.size.width -  nIndicatorWidth ) /2;
    rcIndicator.origin.y = rcTip.origin.y;//( rcClient.size.height -  nIndecatorHeight ) /2;
    rcIndicator.size.width = nIndicatorWidth;
    rcIndicator.size.height = nIndecatorHeight;
    indicatorView.frame = rcIndicator;
}

-(CGRect)getFilmRect:(CGRect)rcArea mode:(E_FilmMode)mode
{
    if( rcArea.size.width <= 0 || rcArea.size.height <= 0
       || E_FilmMode_Full == mode )
    {
        return rcArea;
    }
    CGRect rcDest = rcArea;
    double fWidth = rcArea.size.width;
    double fHeight = rcArea.size.height;
    double fRateHW = fHeight / fWidth;
    double fRateDest  = fRateHW;
    if( E_FilmMode_16_9 == mode )
    {
        fRateDest = 0.75;//3.0/4.0
    }
    else if( E_FilmMode_4_3 == mode )
    {
        fRateDest = 0.5625;//9.0/16.0
    }
    double fDestWidth = fWidth;
    double fDestHeight = fHeight;
    if( fRateHW > fRateDest )
    {
        fDestHeight = fDestWidth * fRateDest;
    }
    else
    {
        fDestWidth = fDestHeight / fRateDest;
    }
    
    rcDest.size.width = fDestWidth;
    rcDest.size.height = fDestHeight;
    rcDest.origin.x = rcArea.origin.x + ( fWidth - fDestWidth ) / 2;
    rcDest.origin.y = rcArea.origin.y + ( fHeight - fDestHeight ) / 2;
    return rcDest;
}

- (void)reflash
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

- (void)setViewInfo:(NSString*)_devName idno:(NSString*)_devIdno chn:(int)_channel name:(NSString*)_chnName
{
    devName = [_devName copy];
    devIdno = [_devIdno copy];
    channel = _channel;
    chnName = [_chnName copy];
    [self updateTitle];
}

- (void)setLanInfo:(NSString*)_lanIp port:(int)_lanPort {
    lanIp = [_lanIp copy];
    lanPort = _lanPort;
}

- (void)startPlayTimer
{
    //自动登录
    timerPlay = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                   target:self
                                                 selector:@selector(onTimerPlay)
                                                 userInfo:nil
                                                  repeats:YES ];
}

- (void)stopPlayTimer
{
    if( timerPlay != nil)
    {
        [timerPlay invalidate ];
        timerPlay = nil;
    }
}

- (void)onTimerPlay
{
    [self updateView];
}

- (BOOL)StartAV {
    //先停止
    [self StopAV];
    BOOL ret = NO;
    //启动视频预览
    NETMEDIA_OpenRealPlay([devIdno UTF8String], (int)channel, 1, 0, true, &realHandle);
    BOOL isDirectMode = NO;
    if( nil == lanIp || 0 == lanIp.length ) {
        
    } else {
        NETMEDIA_SetRealAddress(realHandle, [lanIp UTF8String], lanPort);
        NETMEDIA_SetStreamMode(realHandle, 2);
        isDirectMode = YES;
    }
    NETMEDIA_StartRealPlay(realHandle, true);
    // if (getApp().isRealMode || isDirectMode) new
    if (isDirectMode) {
        // TTXPLAY_STREAM_MODE_REAL 2
        NETMEDIA_SetStreamMode(realHandle, 2);
    }
    if (realHandle != 0) {
        [indicatorView startAnimating ];
        isLoading = true;
        ret = YES;
        [self startPlayTimer];
    }
    return ret;
}

- (BOOL)StopAV {
    BOOL ret = NO;
    if (realHandle != 0) {
        [self stopPlayTimer];
        
        NETMEDIA_StopRealPlay(realHandle);
        NETMEDIA_CloseRealPlay(realHandle);
        realHandle = 0;
        isLoading = NO;
        realRate = 0;
        isRecording = NO;
        [self resetVideoBuf];
        ret = YES;
        
        imageViewVideo.image = nil;
        
        if ([indicatorView isAnimating])
        {
            [indicatorView stopAnimating ];
        }
        
        [self stopSound];
        
        [self updateTitle];
    }
    return ret;
}

/*
 * 判断是否正在预览
 */
- (BOOL)isViewing {
    return realHandle != 0 ? YES : NO;
}

/*
 * 判断是否正在预览
 */
- (void) updateView
{
    if (realHandle != 0) {
        BOOL suc = (NETMEDIA_GetRPlayStatus(realHandle) == 0 ? YES : NO);
        if (isLoading != !suc) {
            [self reflash];
            isLoading = !suc;
        }
        if (!isLoading) {
            int videoSize[2] = {0, 0};
            if (NETMEDIA_GetRPlayImage(realHandle, videoRgb565Length, (char*)videoBuffer.bytes, videoSize, TTX_RGB_FORMAT_888) != 0) {
                if (videoSize[0] > 0 && videoSize[1] > 0) {
                    [self initVideoBuf:videoSize[0] height:videoSize[1]];
                }
            } else {
                if ([indicatorView isAnimating])
                {
                    [indicatorView stopAnimating];
                }
                isVideoBmpVaild = YES;
                // 对解码后的图像传入UIImageView，即可进行视频播放
                imageViewVideo.image = [self formatImage:videoWidth height:videoHeight];

            }
        }
        /*
        NETMEDIA_GetFlowRate(realHandle, &realRate);
        if (isPostInvalidate) {
            invalidateTime = [[NSDate date]timeIntervalSince1970];
        } else {
            if ([[NSDate date]timeIntervalSince1970] - invalidateTime > 1000) {
                [self reflash];
                invalidateTime = [[NSDate date]timeIntervalSince1970];
            }
        }*/
        
        if (mIsAudioPlay && !mIsAudioSounding) {
            if ([self getWavFormat]) {
                mIsAudioSounding = YES;
                [mAudioPlay playSound];
            }
        }
    }
}

/*
 * 初始化图像
 */
- (void)initVideoBuf:(int )nWidth height:(int)nHeight
{
    videoWidth = nWidth;
    videoHeight = nHeight;
    videoRgb565Length = videoWidth * videoHeight * 3;
    videoBuffer = [[NSMutableData alloc]initWithCapacity:videoRgb565Length];
    isVideoBmpVaild = false;
}

/*
 * 重置图像缓存
 */
- (void)resetVideoBuf {
    videoWidth = 0;
    videoHeight = 0;
    videoRgb565Length = 0;
    if (videoBuffer != nil)
    {
        videoBuffer = [[NSMutableData alloc]init];
//        [videoBuffer release]; videoBuffer = nil;
    }
    isVideoBmpVaild = NO;
}

- (NSString*)getFileName:(NSString*)folder extend:(NSString*)extendName
{
    //文件名:日期时间+车辆编号+通道号
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    NSString* filename = [ NSString stringWithFormat:@"%@/%@-%@-%@.%@", folder, strDateTime, devName, chnName, extendName ];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDir = [ paths objectAtIndex: 0 ];
    
    //创建子目录
    NSString* subDir = [ documentsDir stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@", folder ] ];
    [[NSFileManager defaultManager] createDirectoryAtPath: subDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString  *filePath = [documentsDir stringByAppendingPathComponent:filename ];
    return filePath;
}

+ (NSString*)getFileFolder:(NSString*)folder
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDir = [ paths objectAtIndex: 0 ];
    NSString* subDir = [ documentsDir stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@", folder ] ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:subDir isDirectory:&isDir];
    if(!(isDir == YES && existed == YES)){
        [fileManager createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return subDir;
}

/*
 * 保存成BMP图片
 */
- (BOOL)savePngFile {
    
    if (isVideoBmpVaild)
    {
        UIImageWriteToSavedPhotosAlbum(imageViewVideo.image, nil, nil, NULL);
        //NSString  *jpgPath = [self getFileName:@"picture" extend:@"jpg" ];
        //[UIImageJPEGRepresentation(imageViewVideo.image, 1.0) writeToFile:jpgPath atomically:YES];
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
 * 云台控制
 */
- (void)ptzControl:(int)command speed:(int )nSpeed param:(int)nParam
{
    NETMEDIA_RPlayPtzCtrl(realHandle, command, nSpeed, nParam);
}

/*
 * 判断是否正在预览
 */
- (BOOL)isRecording {
    return isRecording;
}

/*
 * 启动或停止录像
 */
- (void)record
{
    if (realHandle != 0) {
        if (!isRecording) {
            NETMEDIA_StartRecord(realHandle, "", [devName UTF8String]);
        } else {
            NETMEDIA_StopRecord(realHandle);
        }
        isRecording = !isRecording;
    }
}

- (void)updateTitle
{
    if (isRecording)
    {
        if (chnName != nil && [chnName length] > 0)
        {
            labelChannel.text = [NSString stringWithFormat:@"%@ - %@ - REC", devName, chnName];
        }
        else
        {
            labelChannel.text = [NSString stringWithFormat:@"%@ - REC", devName];
        }
    }
    else
    {
        if ((devName != nil && devName.length > 0) || (chnName != nil && [chnName length] > 0))
        {
            if (chnName != nil && [chnName length] > 0)
            {
                labelChannel.text = [NSString stringWithFormat:@"%@ - %@", devName, chnName];
            }
            else
            {
                labelChannel.text = [NSString stringWithFormat:@"%@", devName];
            }
        }
        else
        {
            labelChannel.text = [NSString stringWithFormat:@"CH %d", (int)(channel + 1)];
        }
    }
}

/*
 * 启动录像
 */
- (BOOL)startRecord
{
    if (realHandle != 0) {
        if (!isRecording) {
            NSString* recordPath = [TTXSubVideo getFileFolder:@"record"];
            NETMEDIA_StartRecord(realHandle, [recordPath UTF8String], [devName UTF8String]);
            isRecording = YES;
            [self updateTitle];
        }
    }
    return isRecording;
}

/*
 * 停止录像
 */
- (BOOL)stopRecord
{
    BOOL ret = NO;
    if (realHandle != 0) {
        if (isRecording) {
            char fileFullPath[256] = {0};
            BOOL saveFile = false;
            NSString *sFPath = nil;
            if(NETMEDIA_GetFileFullPath(realHandle, fileFullPath) == NETMEDIA_OK)
            {
                sFPath = [NSString stringWithUTF8String:fileFullPath];
                saveFile = true;
            }
            NETMEDIA_StopRecord(realHandle);
            if (saveFile == true && sFPath != nil ) {
                NSArray *sPaths = [sFPath componentsSeparatedByString:@","];
                for (NSString *sPath in sPaths) {
                    if (sPath.length > 0) {
                        [self saveRecordToAlbum:sPath];
                    }
                }
            }
    
            isRecording = NO;
            ret = YES;
            [self updateTitle];
        }
    }
    return ret;
}

-(void)saveRecordToAlbum:(NSString *)videoPath
{
    if(videoPath) {
        //iphone7 ios11.0以上才支持h265
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath);
        if (compatible) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }else{
            //删除损坏的
            NSFileManager *fm = [NSFileManager defaultManager];
            if([fm fileExistsAtPath:videoPath])
                [fm removeItemAtPath:videoPath error:nil];
        }
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:videoPath])
            [fm removeItemAtPath:videoPath error:nil];
    }else{
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:videoPath])
            [fm removeItemAtPath:videoPath error:nil];
    }
}

/*
 * 取得音频格式
 */
- (BOOL)getWavFormat {
    int lChannels;
    int lSamplePerSec;
    int lBitPerSample;
    int lWavBufLen;
    if (NETMEDIA_OK == NETMEDIA_GetWavFormat(realHandle, &lChannels, &lSamplePerSec, &lBitPerSample, &lWavBufLen)) {
        [mAudioPlay setWavFormat:lChannels Sample:lSamplePerSec Bit:lBitPerSample wavLen:lWavBufLen];
        return true;
    } else {
        return false;
    }
}

/*
 * 开始声音播放
 */
- (void)playSound
{
    if (realHandle != 0 && mAudioPlay == nil) {
        NETMEDIA_PlaySound(realHandle, 1);
        
        mAudioPlay = [[TTXAudioPlay alloc] init];
        mAudioPlay.delegate = self;
        
        mIsAudioPlay = YES;
        mIsAudioSounding = NO;
        if ([self getWavFormat]) {
            mIsAudioSounding = YES;
            [mAudioPlay playSound];
        }
    }
}

/*
 * 开始声音播放
 */
- (void)stopSound
{
    if (mAudioPlay != nil) {
        mIsAudioPlay = NO;
        [mAudioPlay stopSound];
        mAudioPlay = nil;
//        [mAudioPlay release];
    }
}

- (BOOL)isSounding
{
    return mAudioPlay != nil ? YES : NO;
}

#pragma mark TTXAudioPlayDelegate Methods
- (int)playAudio:(TTXAudioPlay *)realplay inBuffer:(void*)buffer length:(int)len
{
    int nReadLen = len;
    NETMEDIA_GetWavData(realHandle, buffer, &nReadLen);
    //NSLog(@"NETMEDIA_TBGetWavData len:%d, nReadLen:%d", len, nReadLen);
    return nReadLen;
}

@end
