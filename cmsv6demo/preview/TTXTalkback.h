//
//  TTXTalkback.h
//  gMonitor
//
//  Created by Apple on 13-11-7.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTXAudioPlay.h"
#import "TTXAudioRecord.h"

@interface TTXTalkback : NSObject<TTXAudioPlayDelegate, TTXAudioRecordDelegate>
{
    long mTalkbackHandle;
    TTXAudioPlay* mAudioPlay;
    TTXAudioRecord* mAudioRecord;
    BOOL mIsAudioPlay;
    BOOL mIsAudioSounding;
    NSTimer* mTimer;
}
- (BOOL)startTalkback:(NSString*)devIdno;
- (BOOL)stopTalkback;
- (void)playSound;
- (void)stopSound;
- (BOOL)isTalkback;
@end
