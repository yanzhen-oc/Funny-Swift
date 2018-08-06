//
//  YZDevice.h
//
//  Created by yanzhen.
//

#import <Foundation/Foundation.h>

@interface YZDevice : NSObject

/**           iOS设备型号          */
+ (const NSString *)getDeviceName;

/**           iOS设备名称          */
+ (NSString *)getDeviceHostName;

/**           返回"Darwin"        */
+ (NSString *)getDeviceOSType;

/**           设备的系统版本        */
+ (NSString *)getDeviceSystemVersion;


/**           OS Build           */
+ (NSString *)getOSBuild;

/**           KernelInfo         */
+ (NSString *)getKernelInfo;

/**           最大可用的 vnode     */
+ (NSUInteger)getMaxVNodes;


/**  手机上次开机时间(0000-00-00 00:00:00)     */
+ (NSString *)getBootTime;




#pragma mark -  >>>>>>>>>  RAM  <<<<<<<<<
/**           RAM大小 -- 单位B     */
+ (long long)getTotalMemorySize;

/**           可用RAM             */
+ (long long)getAvailableMemorySize;//统计方式不同所得结果会有偏差

#pragma mark -  >>>>>>>>>  ROM  <<<<<<<<<
/**           ROM大小 -- 单位B     */
+ (long long)getTotalDiskSize;

/**           可用ROM             */
+ (long long)getAvailableDiskSize;
@end
