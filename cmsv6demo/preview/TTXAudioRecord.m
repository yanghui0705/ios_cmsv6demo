//
//  TTXAudioRecord.m
//  gMonitor
//
//  Created by Apple on 13-11-7.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "TTXAudioRecord.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#define AUDIO_BUFFER_SIZE   320
@implementation TTXAudioRecord

//Howard 2013-07-29 修改函数名，并加上static ,限于本文件使用 //MyAudioQueueInputCallback
static void HowardAudioQueueInputCallback (void *                          inUserData,
                                           AudioQueueRef                   inAQ,
                                           AudioQueueBufferRef             inBuffer,
                                           const AudioTimeStamp *          inStartTime,
                                           UInt32                          inNumberPacketDescriptions,
                                           const AudioStreamPacketDescription *inPacketDescs) {
    TTXAudioRecord *audioRecord = (__bridge TTXAudioRecord *) inUserData;
    if (audioRecord.delegate != Nil) {
        [audioRecord.delegate recordAudio:audioRecord inBuffer:inBuffer->mAudioData length:AUDIO_BUFFER_SIZE];
    }
    //audioRecord->PlayRecord();
    //[a talk: inBuffer->mAudioData];
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

- (BOOL) startRecord {
    if (!isRecording) {
        const AudioStreamBasicDescription asbd = {8000.0, kAudioFormatLinearPCM, 12, 2, 1, 2, 1, 16, 0};
        AudioQueueNewInput(&asbd, HowardAudioQueueInputCallback ,(__bridge void * _Nullable)(self), nil, nil, 0, &d_audio_recording);
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        for (int i = 0; i < AUDIO_PLAY_BUFFERS_NUMBER; i++) {
            AudioQueueAllocateBuffer(d_audio_recording, AUDIO_BUFFER_SIZE, &d_audio_recording_buffers[i]);
            AudioQueueEnqueueBuffer(d_audio_recording, d_audio_recording_buffers[i], 0, nil);
        }
        
        AudioQueueSetParameter(d_audio_recording, kAudioQueueParam_Volume,  1.0);
        AudioQueueStart(d_audio_recording, NULL);
        isRecording = YES;
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) stopRecord {
    if (isRecording) {
        AudioQueueFlush(d_audio_recording);
        AudioQueueStop(d_audio_recording,  YES);
        for (int i = 0; i < AUDIO_PLAY_BUFFERS_NUMBER; i++) {
            AudioQueueFreeBuffer(d_audio_recording, d_audio_recording_buffers[i]);
        }
        AudioQueueDispose(d_audio_recording, YES);
        isRecording = NO;
        return YES;
    } else {
        return NO;
    }
}

@end
