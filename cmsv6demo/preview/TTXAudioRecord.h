//
//  TTXAudioRecord.h
//  gMonitor
//
//  Created by Apple on 13-11-7.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define AUDIO_PLAY_BUFFERS_NUMBER                        10


@class TTXAudioRecord;
@protocol TTXAudioRecordDelegate <NSObject>
- (void)recordAudio:(TTXAudioRecord *)record inBuffer:(void*)buffer length:(int)len;
@end

@interface TTXAudioRecord : NSObject
{
    AudioQueueRef d_audio_recording;
    AudioQueueBufferRef d_audio_recording_buffers[AUDIO_PLAY_BUFFERS_NUMBER];
    BOOL isRecording;
}
@property(nonatomic, assign) id<TTXAudioRecordDelegate> delegate;
- (BOOL) startRecord;
- (BOOL) stopRecord;
@end
