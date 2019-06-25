#import <Foundation/Foundation.h>
@interface DeviceSearch : NSObject
@property (nonatomic, copy) NSString* devIdno;
@property (nonatomic, assign) NSInteger netType;
@property (nonatomic, copy) NSString* netName;		
@property (nonatomic, copy) NSString* ipAddr;
@property (nonatomic, assign) NSInteger devType;
@property (nonatomic, assign) NSInteger channel;
@property (nonatomic, assign) NSInteger webPort;
@property (nonatomic, copy) NSString* webUrl;
@end
