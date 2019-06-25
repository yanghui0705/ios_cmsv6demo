//
//  UserVehicleManager.m
//  cmsv6demo
//
//  Created by tongtianxing on 2018/8/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "UserVehicleManager.h"
@implementation UserVehicleManager



-(void)getUserVehicleWithServer:(NSString*)server port:(NSString*)port jsession:(NSString*)jsession manager:(AFHTTPSessionManager*)manager success:(void(^)(id  _Nullable responseObject))success failure:(void(^)(NSError * _Nonnull error))failure
{
    NSString *url;
    if (port.length == 0 ) {
         url  =  [NSString stringWithFormat:@"http://%@/StandardApiAction_queryUserVehicle.action?jsession=%@",server,jsession];
    }else{
        
           url  =  [NSString stringWithFormat:@"http://%@:%@/StandardApiAction_queryUserVehicle.action?jsession=%@",server,port,jsession];
    }
    

//    NSDictionary *parameters = @{@"jsession":jsession};
    
    [manager POST:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
