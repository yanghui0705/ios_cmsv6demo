//
//  TempSearchFoundtion.m
//  cmsv6demo
//
//  Created by tongtianxing on 2018/8/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TempSearchFoundtion.h"
#import "netmediaapi.h"
#import "iToast.h"

#import "Singleton.h"

#import "EquipmentInfoModel.h"

#import "VehicleInfoModel.h"

@interface TempSearchFoundtion()
{
    long mSearchHandle;
    int mStorageType; //1:设备录像 2:存储服务器录像
    NSString *selectIdno;
}
@end
@implementation TempSearchFoundtion

-(NSMutableArray *)mSearchList{
    if(_mSearchList == nil)
    {
        _mSearchList = [NSMutableArray array];
    }
    return _mSearchList;
}

-(void)onsearch:(NSString *)devIdno location:(int)location channel:(int)channel type:(int)fileType date:(NSString *)queryDate beginTime:(int)beginSecond endTime:(NSInteger)endSecond
{
 int nYear = [[queryDate substringWithRange:NSMakeRange(0, 4)] intValue];
 int nMonth = [[queryDate substringWithRange:NSMakeRange(5, 2)] intValue];
 int nDay = [[queryDate substringWithRange:NSMakeRange(8, 2)] intValue];

    if (mSearchHandle == 0) {//设备终端
        
        if ([_mSearchList count] != 0) {
            [_mSearchList removeAllObjects];
        }
    selectIdno = devIdno;
        
        if(location == 0)
        {
            mStorageType = 1;
                                                    //设备号码
            NETMEDIA_SFOpenSrchFile(&mSearchHandle, [selectIdno UTF8String], 1, GPS_FILE_ATTRIBUTE_RECORD);
        }else if (location == 1){//存储服务器
            mStorageType = 2;
                                                    //车牌号码
            NETMEDIA_SFOpenSrchFile(&mSearchHandle, [selectIdno UTF8String], 2, GPS_FILE_ATTRIBUTE_RECORD);
        }
//        BOOL is1078 = true;
//        if (!is1078) {
    NETMEDIA_SFStartSearchFile(mSearchHandle, nYear, nMonth, nDay, fileType, channel, (int)beginSecond, (int)endSecond);
//        }else{
//            GPSRecFileSearchParam_S pParam;
//            pParam.nChannel = channel;
//            pParam.nYearS = nYear;
//            pParam.nMonthS = nMonth;
//            pParam.nDayS = nDay;
//            pParam.nYearE = nYear;
//            pParam.nMonthE = nMonth;
//            pParam.nDayE = nDay;
//            pParam.nBegTime = beginSecond;
//            pParam.nEndTime = (int)endSecond;
//            pParam.nRecType = fileType;
//            pParam.nFileAttr = GPS_FILE_ATTRIBUTE_RECORD;
//            pParam.nLoc = mStorageType; // 0 1
//            pParam.nAlarmFlag1 =1073483775;
//            pParam.nAlarmFlag2 = 127;
//            pParam.cResourceType = 0;
//            pParam.cStreamType = -1;
//            pParam.cStoreType = 0;
//            //默认搜索全部音视频
//            NETMEDIA_SFStartSearchFileMoreEx(mSearchHandle, &pParam);
//        }
        
        
   
//        [self showTipView:false];
//        [self showIndicatorView:true];
        [self performSelector:@selector(search) withObject:nil afterDelay:0.2];
        
    }
}

-(void)search
{
    BOOL isFinish = false;
    if(mSearchHandle != 0){
        while (true) {
            char result[1024] = {0};
            //            Byte result[1024];
            //            memset(result, 0, 1024);
            int ret  = NETMEDIA_SFGetSearchFile(mSearchHandle, result, 1024);
            NSLog(@"ret = %d",ret);
            if(ret == NETMEDIA_OK){
                int i = 0;
                for (i = 0; i < 1024 ; i++) {
                    if (result[i] == 0) {
                        break;
                    }
                }
                char temp[1024] = {0};
                memcpy(temp, result, i);
                NSMutableString *fileInfo = [[NSMutableString alloc]init];
                for (int n = 0; n < i; n++) {
                    [fileInfo appendFormat:@"%c",temp[n]];
                }
                NSArray *array = [fileInfo componentsSeparatedByString:@";"];
                int index = 0;
                TTXPlaybackSearchModel *searchModel = [[TTXPlaybackSearchModel alloc]init];
                searchModel.orginalFileInfo =(char*)malloc(i);
                memcpy(searchModel.orginalFileInfo, temp, i);
                searchModel.fileInfo = [NSString stringWithString:fileInfo];
                searchModel.name = array[index++];
                searchModel.year = [array[index++] integerValue];
                searchModel.month = [array[index++] integerValue];
                searchModel.day = [array[index++] integerValue];
                searchModel.beginTime = [array[index++] integerValue];
                searchModel.endTime = [array[index++] integerValue];
                
                
                if (mStorageType == 1) {
                    searchModel.devIdno = array[index++];
                }else{
                    index ++; //这个是车牌号
                    //                    search.setDevIdno(mDevIdNumPlate);
                    searchModel.devIdno = selectIdno;
                }
                searchModel.chn = [array[index++] integerValue];
                searchModel.fileLength = [array[index++] integerValue];
                searchModel.fileType = [array[index++] integerValue];
                searchModel.location = [array[index++] integerValue];
                searchModel.svrId = [array[index++] integerValue];
                searchModel.chnMask = [array[index++] integerValue];
                searchModel.alarmInfo = [array[index++] integerValue];
                searchModel.fileOffset = [array[index++] integerValue];
                searchModel.recording = [array[index++] integerValue] > 0 ? true : false;
                searchModel.stream = [array[index++] integerValue] > 0 ? true : false;
                
                //                if ((searchModel.chnMask > 0 && searchModel.chn == 0) || searchModel.chn > nChn){
                //                    searchModel.chn = nChn;
                //                }
                
                
                VehicleInfoModel *model = [[Singleton singleton].vicles  valueForKey:searchModel.devIdno];
                EquipmentInfoModel *model1 = model.dl[0];
                
//                TTXVehicleInfo *vehicle = [getApp() findVehicleWithDevIdno:searchModel.devIdno];
                if (searchModel.chnMask > 0 && searchModel.chn == 0){
                    searchModel.chn = model1.cc;
                }
                [self.mSearchList addObject:searchModel];
                continue;
            }else if (ret == NETMEDIA_SEARCH_FINISHED){
                if ([_mSearchList count] == 0) {
                    [[iToast makeText:NSLocalizedString(@"Cannot find playback",@"")] show];
                }else{
                    [self.delegate searchFinishHavePlayback:_mSearchList];
                }
                
                isFinish = true;
                
//                [playbackList reloadData];
                [self cancelSearch];
                break;
            }else if (ret == NETMEDIA_SEARCH_FAILED){
                isFinish = true;
                [self cancelSearch];
                [[iToast makeText:NSLocalizedString(@"find failure",@"")] show];
            }else{
                [NSThread sleepForTimeInterval:0.01];
                break;
            }
        }
        if (!isFinish) {
            [self performSelector:@selector(search) withObject:nil afterDelay:0.2];
        }
    }
}
-(void)cancelSearch
{
    [self stopSearch];
//    [self showIndicatorView:false];
//    [self showTipView:true];
    //    hideWaitDialog();
}
-(void)stopSearch
{
    if (mSearchHandle != 0) {
        NETMEDIA_SFStopSearchFile(mSearchHandle);
        NETMEDIA_SFCloseSearchFile(mSearchHandle);
        mSearchHandle = 0;
    }
}
@end
