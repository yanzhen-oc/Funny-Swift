//
//  YZNetWorkFluxStatistics.h
//
//  Created by yanzhen.
//

#import <UIKit/UIKit.h>

typedef enum : int {
    YZNETWORK_NOTCONNECT = 0,
    YZNETWORK_WIFI,
    YZNETWORK_4G,
    YZNETWORK_3G,
    YZNETWORK_2G
} YZNetworkStatus;
//数据统计-上次开机之后
@interface YZNetWorkFluxStatistics : NSObject
@property (nonatomic, assign) YZNetworkStatus  netStatus;
@property (nonatomic, strong) NSDate    *timestamp;

@property (nonatomic, assign) float     sent;
@property (nonatomic, assign) uint64_t  totalWiFiSent;
@property (nonatomic, assign) uint64_t  totalWWANSent;
@property (nonatomic, assign) float     received;
@property (nonatomic, assign) uint64_t  totalWiFiReceived;
@property (nonatomic, assign) uint64_t  totalWWANReceived;
@end
