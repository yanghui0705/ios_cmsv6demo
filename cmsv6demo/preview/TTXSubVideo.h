//
//  TTXSubVideo.h
//  cmsv6
//
//  Created by Apple on 13-4-5.
//  Copyright (c) 2013年 babelstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTXAudioPlay.h"

@interface TTXSubVideo : UIView<TTXAudioPlayDelegate>
{
    BOOL isFocus;
    UIImageView* imageViewVideo;
    UILabel* tipLabel;
    UIActivityIndicatorView* indicatorView; //指示，菊花旋转

    long realHandle;
    BOOL isRecording;
    BOOL isLoading;
    
    int	videoWidth;	//视频宽度和高度
    int videoHeight;	//视频高度
    int videoRgb565Length;
    NSMutableData* videoBuffer;
    BOOL isVideoBmpVaild;
	NSTimeInterval invalidateTime;	//刷新时间
    int realRate;
    NSTimer* timerPlay;
    
    NSString* devName;
    NSString* devIdno;
    NSString* chnName;
    
    NSString* lanIp;
    int lanPort;
    
    TTXAudioPlay* mAudioPlay;
    BOOL mIsAudioPlay;
	BOOL mIsAudioSounding;
}

@property(nonatomic, assign ) BOOL isFocus;          //窗口序号
@property(nonatomic, strong )UILabel* labelChannel;         //显示通道号
@property(nonatomic, strong )UIImageView* imageViewVideo;   //显示视频图像
@property(nonatomic, assign ) NSInteger channel;            //通道号
@property(nonatomic, assign ) NSInteger viewIndex;          //窗口序号

- (void)reflash;

/*
 * 设置devceidno 配置获取视频的参数 Set the devceidno configuration to get video parameters
 */
- (void)setViewInfo:(NSString*)_devName idno:(NSString*)_devIdno chn:(int)_channel name:(NSString*)_chnName;

- (void)setLanInfo:(NSString*)_lanIp port:(int)_lanPort;
/*
 * 开始视频预览 Start the video preview
 */
- (BOOL)StartAV;
/*
 * 停止视频预览 Stop the video preview
 */
- (BOOL)StopAV;

/*
 * 判断是否正在预览 Determine if video is previewing
 */
- (BOOL)isViewing;

/*
 * 刷新视频视图 Refresh the video view
 */
- (void) updateView;

/*
 * 初始化图像 Initialization image
 */
- (void)initVideoBuf:(int )nWidth height:(int)nHeight;

/*
 * 重置图像缓存 Reset image cache
 */
- (void)resetVideoBuf;

/*
 * 保存成BMP图片 Save BMP image
 */
- (BOOL)savePngFile;

/*
 * 云台控制 Cloud control
 */
- (void)ptzControl:(int)command speed:(int )nSpeed param:(int)nParam;

/*
 * 判断是否正在录像 Determine if the video is being recorded
 */
- (BOOL)isRecording;

/*
 * 启动或停止录像 Start or stop recording
 */
- (void)record;

/*
 * 启动录像 start Record
 */
- (BOOL)startRecord;

/*
 * 停止录像 stop Record
 */
- (BOOL)stopRecord;

/*
 * 开始声音播放 play Sound
 */
- (void)playSound;

/*
 * 停止声音播放 stop Sound
 */
- (void)stopSound;

/*
 * 是否正在声音播放 stop Sound
 */
- (BOOL)isSounding;

+ (NSString*)getFileFolder:(NSString*)folder;

@end
