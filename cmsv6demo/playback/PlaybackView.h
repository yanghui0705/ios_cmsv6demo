//
//  PlaybackView.h
//  cmsv6
//
//  Created by tongtianxing on 2018/8/23.
//  Copyright © 2018年 babelstar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTXAudioPlay.h"

@class TTXPlaybackSearchModel;
@class PlaybackView;
@protocol PlaybcakViewDelegate <NSObject>
- (void)onBeginPlay:(PlaybackView *)playback;
-(void)onUpdatePlay:(PlaybackView*)playback downSecond:(int)down playSecond:(int)play downFinish:(BOOL)finish;
-(void)onEndPlay:(PlaybackView*)playback;
@optional
- (void)onPlayBack:(PlaybackView *)playback rate:(int)realRate;
@end


@interface PlaybackView : UIView
{

    UIActivityIndicatorView *indicatorView;
    long realHandle;
    
    BOOL isLoading;
    BOOL isBeginPlay;
    
    int    videoWidth;    //视频宽度和高度
    int videoHeight;    //视频高度
    int videoRgb565Length;
    NSMutableData* videoBuffer;
    BOOL isVideoBmpVaild;
    
    NSTimeInterval mRateTime;    //刷新时间
    int playRate;
    NSTimer* timerPlay;
    
    TTXAudioPlay* mAudioPlay;
    BOOL mIsAudioPlay;
    BOOL mIsAudioSounding;
    
    BOOL isPause;
    
}
@property (nonatomic , assign)id<PlaybcakViewDelegate> delegate;
 @property(nonatomic, strong )UIImageView* playbackView;//显示视频图像
-(BOOL)startVod:(TTXPlaybackSearchModel*)model;
-(BOOL)stopVod;
-(BOOL)isViewing;
-(void)pause:(BOOL)isPause;
-(void)setPlayTime:(int)second;

- (void)playSound;
- (void)stopSound;
- (BOOL)isSounding;

- (BOOL)savePngFile;


@end
