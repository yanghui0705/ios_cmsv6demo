//
//  UserVehicleManager.h
//  cmsv6demo
//
//  Created by tongtianxing on 2018/8/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface UserVehicleManager : NSObject

-(void)getUserVehicleWithServer:(NSString*_Nullable)server port:(NSString*_Nullable)port jsession:(NSString*_Nullable)jsession manager:(AFHTTPSessionManager*_Nullable)manager success:(void(^_Nullable)(id  _Nullable responseObject))success failure:(void(^_Nonnull)(NSError * _Nonnull error))failure;
@end
