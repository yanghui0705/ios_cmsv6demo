//
//  TTXPlayblackSearchModel.h
//  cmsv6
//
//  Created by tongtianxing on 2018/8/22.
//  Copyright © 2018年 babelstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTXPlaybackSearchModel : NSObject
{
//    char *_orginalFileInfo;
}
@property (nonatomic , copy)NSString *fileInfo;
@property (nonatomic , copy)NSString *name;
@property (nonatomic , assign)NSInteger year;
@property (nonatomic , assign)NSInteger month;
@property (nonatomic , assign)NSInteger day;
@property (nonatomic , assign)NSInteger beginTime;
@property (nonatomic , assign)NSInteger endTime;
@property (nonatomic , copy)NSString *devIdno;
@property (nonatomic , assign)NSInteger chn;
@property (nonatomic , assign)NSInteger fileLength;
@property (nonatomic , assign)NSInteger fileType;
@property (nonatomic , assign)NSInteger location;
@property (nonatomic , assign)NSInteger svrId;
@property (nonatomic , assign)NSInteger chnMask;
@property (nonatomic , assign)NSInteger alarmInfo;
@property (nonatomic , assign)NSInteger fileOffset;
@property (nonatomic , assign)BOOL recording;
@property (nonatomic , assign)BOOL stream;
@property (nonatomic , assign)char *orginalFileInfo;



@property (nonatomic , assign)BOOL is1078;
@property (nonatomic , assign)BOOL isMultChn;
@property (nonatomic , assign)NSInteger selectChn;

-(BOOL)checkIsMultChn;

@end
