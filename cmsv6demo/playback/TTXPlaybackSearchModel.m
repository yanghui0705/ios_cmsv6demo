//
//  TTXPlayblackSearchModel.m
//  cmsv6
//
//  Created by tongtianxing on 2018/8/22.
//  Copyright © 2018年 babelstar. All rights reserved.
//

#import "TTXPlaybackSearchModel.h"

@implementation TTXPlaybackSearchModel



//-(void)setorginalFileInfo:(char *)_orginalFileInfo
//{
//    
//}
//-(char *)orginalFileInfo
//{
//    return orginalFileInfo;
//}
//
-(void)dealloc
{
    free(self.orginalFileInfo);
//    NSLog(@"TTXPlaybackSearchModel dealloc");
}

-(BOOL)checkIsMultChn
{
    NSInteger chnMask = self.chnMask;
    NSInteger chn = self.chn;
    BOOL isEmpty = true;
    for (int k = 0; k < chn; k++) {
        if ( (chnMask >> k) & 0x01 ) {
            isEmpty = false;
        }
    }
    self.isMultChn = !isEmpty;
     if (isEmpty) {
         return false;
     }else{
         return true;
     }
}

@end
