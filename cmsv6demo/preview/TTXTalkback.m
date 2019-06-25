//
//  TTXTalkback.m
//  gMonitor
//
//  Created by Apple on 13-11-7.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "TTXTalkback.h"
#import "netmediaapi.h"

@implementation TTXTalkback

- (BOOL)startTalkback:(NSString*)devIdno
{
    BOOL ret = NO;
    if (mTalkbackHandle == 0) {
        NETMEDIA_TBOpenTalkback([devIdno UTF8String], 0, 0, &mTalkbackHandle);
        NETMEDIA_TBStartTalkback(mTalkbackHandle);
        if (mTalkbackHandle != 0) {
            [self playSound];
            if ([self startRecord]) {
                ret = YES;
                [self startTimer];
            } else {
                [self stopTalkback];
            }
        }
    }
    return ret;
}

- (BOOL)stopTalkback
{
    BOOL ret = FALSE;
    if (mTalkbackHandle != 0) {
        [self stopTimer];
        [self stopSound];
        [self stopRecord];
        
        NETMEDIA_TBStopTalkback(mTalkbackHandle);
        NETMEDIA_TBCloseTalkback(mTalkbackHandle);
        mTalkbackHandle = 0;
        ret = YES;
    }
    
    return ret;
}

- (BOOL)isTalkback
{
    return mTalkbackHandle != 0 ? YES : NO;
}

/*
 * 取得音频格式
 */
- (BOOL)getWavFormat {
    int lChannels;
    int lSamplePerSec;
    int lBitPerSample;
    int lWavBufLen;
    if (NETMEDIA_OK == NETMEDIA_TBGetWavFormat(mTalkbackHandle, &lChannels, &lSamplePerSec, &lBitPerSample, &lWavBufLen)) {
        [mAudioPlay setWavFormat:lChannels Sample:lSamplePerSec Bit:lBitPerSample wavLen:lWavBufLen];
        return true;
    } else {
        return false;
    }
}

- (void)playSound
{
    if (mTalkbackHandle != 0) {
        if (mAudioPlay == nil) {
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
}

- (void)stopSound
{
    if (mAudioPlay != nil) {
        mIsAudioPlay = NO;
        [mAudioPlay stopSound];
//        [mAudioPlay release];
        mAudioPlay = nil;
    }
}

/*
 * 开始声音录制
 */
- (BOOL)startRecord {
    BOOL ret = NO;
    if (mTalkbackHandle != 0) {
        mAudioRecord = [[TTXAudioRecord alloc] init];
        mAudioRecord.delegate = self;
        ret = [mAudioRecord startRecord];
    }
    return ret;
}

/*
 * 开始声音录制
 */
- (void)stopRecord {
    if (mAudioRecord != nil) {
        
        [mAudioRecord stopRecord];
//        [mAudioRecord release];
        mAudioRecord = nil;
    }
}

- (void)onTimerPlay
{
    if (mIsAudioPlay && !mIsAudioSounding) {
        if ([self getWavFormat]) {
            mIsAudioSounding = YES;
            [mAudioPlay playSound];
        }
    }
}

- (void)startTimer
{
    //自动登录
    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                 target:self
                                               selector:@selector(onTimerPlay)
                                               userInfo:nil
                                                repeats:YES ];
}

- (void)stopTimer
{
    if( mTimer != nil)
    {
        [mTimer invalidate ];
        mTimer = nil;
    }
}

#pragma mark TTXAudioPlayDelegate Methods
- (int)playAudio:(TTXAudioPlay *)realplay inBuffer:(void*)buffer length:(int)len
{
    int nReadLen = len;
    NETMEDIA_TBGetWavData(mTalkbackHandle, buffer, &nReadLen);
    //NSLog(@"NETMEDIA_TBGetWavData len:%d, nReadLen:%d", len, nReadLen);
    return nReadLen;
}

#pragma mark TTXAudioRecordDelegate Methods
- (void)recordAudio:(TTXAudioRecord *)record inBuffer:(void*)buffer length:(int)len;
{
    NETMEDIA_TBSendWavData(mTalkbackHandle, buffer, len);
}

@end
