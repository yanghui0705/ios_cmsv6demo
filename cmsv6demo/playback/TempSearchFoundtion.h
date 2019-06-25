//
//  TempSearchFoundtion.h
//  cmsv6demo
//
//  Created by tongtianxing on 2018/8/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTXPlaybackSearchModel.h"

@protocol TempSearchFoundtionDelegate<NSObject>

-(void)searchFinishHavePlayback:(NSArray *)searchList;
@end
@interface TempSearchFoundtion : NSObject


@property (nonatomic , strong)NSMutableArray *mSearchList;
@property (nonatomic , assign)id<TempSearchFoundtionDelegate> delegate;

-(void)onsearch:(NSString *)devIdno location:(int)location channel:(int)channel type:(int)fileType date:(NSString *)queryDate beginTime:(int)beginSecond endTime:(NSInteger)endSecond;
@end
