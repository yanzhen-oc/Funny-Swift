//
//  YZNetwork.h
//
//  Created by yanzhen.
//

#import <UIKit/UIKit.h>
#import "YZNetWorkFluxStatistics.h"

typedef void(^NetStatusChangedBlock)(YZNetworkStatus status);
@interface YZNetwork : NSObject
/**        监测网络状态发生变化            */
@property (nonatomic, copy) NetStatusChangedBlock block;

/**        获得当前网络的网络状态           */
- (YZNetworkStatus)getCurrentNetStatus;

/**        获得当前网络的网络数据           */
- (void)getCurrentNetSpeed:(void (^)(YZNetWorkFluxStatistics *netWorkFlux))netWorkFlux;

/**        获得当前网络IP                 */
- (NSString*)getCurrentNetworkIP;

/**        获得当前网络的子网掩码           */
- (NSString*)getCurrentNetmask;
@end
