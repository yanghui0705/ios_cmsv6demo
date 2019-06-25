//
//  TTXAudioPlay.h
//  gMonitor
//
//  Created by Apple on 13-11-7.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class TTXAudioPlay;
@protocol TTXAudioPlayDelegate <NSObject>
- (int)playAudio:(TTXAudioPlay *)realplay inBuffer:(void*)buffer length:(int)len;
@end


#define AUDIO_PLAY_BUFFERS_NUMBER						10

@interface TTXAudioPlay : NSObject
{
    AudioQueueRef d_audio_play;
    AudioQueueBufferRef d_audio_play_buffers[AUDIO_PLAY_BUFFERS_NUMBER];
    BOOL isAudioPlay;
    int mChanne;
    int mSamplePerSec;
    int mBitPerSample;
    int mWavBufLen;
}
@property(nonatomic, assign) id<TTXAudioPlayDelegate> delegate;
@property(nonatomic, assign) BOOL defaultFormat;



- (void) setWavFormat: (int)lChannels Sample:(int)SamplePerSec Bit:(int)lBitPerSample wavLen:(int)lWavBufLen;
- (BOOL) playSound;
- (BOOL) stopSound;
- (int) getWavBufLen;
@end
