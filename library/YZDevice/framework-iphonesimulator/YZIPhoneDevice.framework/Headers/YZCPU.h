//
//  YZCPU.h
//
//  Created by yanzhen.
//

#import <UIKit/UIKit.h>

@interface YZCPU : NSObject
/**
 * @brief 创建YZActionSheet
 *
 * @param interval          检测时间间隔
 * @param usage             用来返回CPU占用比
 *
 */
- (void)startMonitorCPUUsageWithTimeInterval:(NSTimeInterval)interval usage:(void (^)(CGFloat usage))usage;
@end
