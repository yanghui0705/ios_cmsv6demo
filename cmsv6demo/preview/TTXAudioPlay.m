//
//  TTXAudioPlay.m
//  gMonitor
//
//  Created by Apple on 13-11-7.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "TTXAudioPlay.h"
#define AUDIO_BUFFER_SIZE                               640
@implementation TTXAudioPlay

- (void) dealloc
{
//    [super dealloc];
    NSLog(@"TTXAudioPlay dealloc");
}

static void HowardAudioQueueOutputCallback ( void *                  inUserData,
                                            AudioQueueRef           inAQ,
                                            AudioQueueBufferRef     inBuffer) {
    TTXAudioPlay *audioPlay = (__bridge TTXAudioPlay *)(inUserData);
    int nFillLength = 0;
    int nWavBufLen = [audioPlay getWavBufLen];
    if (audioPlay.delegate != Nil) {
        nFillLength = [audioPlay.delegate playAudio:audioPlay inBuffer:inBuffer->mAudioData length:nWavBufLen];
    }
    
    if (nFillLength < nWavBufLen) {
        memset(inBuffer->mAudioData + nFillLength, 0, nWavBufLen - nFillLength);
    }
    
    inBuffer->mAudioDataByteSize = nWavBufLen;
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

- (void) setWavFormat: (int)lChannels Sample:(int)lSamplePerSec Bit:(int)lBitPerSample wavLen:(int)lWavBufLen {
    mChanne = lChannels;
    mSamplePerSec = lSamplePerSec;
    mBitPerSample = lBitPerSample;
    mWavBufLen = lWavBufLen;
}

- (BOOL) playSound {
    //Howard 2013-08-14 添加,设置话筒模式(声音播放的两种模式：听筒模式和话筒模式）
    if (!isAudioPlay) {
            UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
           AudioSessionSetProperty( kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRoute), &audioRoute );
     
        
        if (!_defaultFormat) {
            AudioStreamBasicDescription format;  // 声音格式设置，这些设置要和采集时的配置一致
            memset(&format, 0, sizeof(format));
            format.mSampleRate = mSamplePerSec; // 采样率 (立体声 = 8000)
            format.mFormatID = kAudioFormatLinearPCM; // PCM 格式
            format.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
            format.mChannelsPerFrame = mChanne;  // 1:单声道；2:立体声
            format.mBitsPerChannel = mBitPerSample; // 语音每采样点占用位数
            format.mBytesPerFrame = (format.mBitsPerChannel/8)  * format.mChannelsPerFrame;;
            format.mFramesPerPacket = 1;
            format.mBytesPerPacket = format.mBytesPerFrame * format.mFramesPerPacket;
            //const AudioStreamBasicDescription asbd = {8000.0, kAudioFormatLinearPCM, 12, 2, 1, 2, 1, 16, 0};
            //const AudioStreamBasicDescription asbd = {mSamplePerSec, kAudioFormatLinearPCM, 12, 2, 1, 2, mChanne, 16, 0};
            AudioQueueNewOutput(&format , HowardAudioQueueOutputCallback, (__bridge void * _Nullable)(self), CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 0, &d_audio_play);
        }else{
             const AudioStreamBasicDescription asbd = {8000.0, kAudioFormatLinearPCM, 12, 2, 1, 2, 1, 16, 0};
            mWavBufLen = AUDIO_BUFFER_SIZE;
            AudioQueueNewOutput(&asbd , HowardAudioQueueOutputCallback, (__bridge void * _Nullable)(self), CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 0, &d_audio_play);
        }
       
        for (int i = 0; i < AUDIO_PLAY_BUFFERS_NUMBER; i++) {
            AudioQueueAllocateBuffer(d_audio_play, mWavBufLen, &d_audio_play_buffers[i]);
            d_audio_play_buffers[i]->mUserData = (__bridge void * _Nullable)(self);
            memset(d_audio_play_buffers[i]->mAudioData, 0, mWavBufLen);
            d_audio_play_buffers[i]->mAudioDataByteSize = mWavBufLen;
            AudioQueueEnqueueBuffer(d_audio_play, d_audio_play_buffers[i], 0, NULL);
        }
        
        AudioQueueSetParameter(d_audio_play, kAudioQueueParam_Volume, 1.0);
        AudioQueueStart(d_audio_play, NULL);
        isAudioPlay = YES;
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) stopSound {
    if (isAudioPlay) {
        [[NSNotificationCenter defaultCenter] removeObserver: self];
        
        AudioQueueStop(d_audio_play, YES);
        for (int i = 0; i < AUDIO_PLAY_BUFFERS_NUMBER; i++) {
            AudioQueueFreeBuffer(d_audio_play, d_audio_play_buffers[i]);
        }
        AudioQueueDispose(d_audio_play, YES);
        isAudioPlay = NO;
        return YES;
    } else {
        return NO;
    }
}

- (int) getWavBufLen {
    return mWavBufLen;
}



@end
