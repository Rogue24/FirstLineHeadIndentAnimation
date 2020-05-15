//
//  JPProxy.h
//  JPBasic
//
//  Created by 周健平 on 2019/12/12.
//

#import <Foundation/Foundation.h>

#define JPTargetProxy(target) [JPProxy proxyWithTarget:target]

@interface JPProxy : NSProxy
+ (instancetype)proxyWithTarget:(id)target;
@property (nonatomic, weak) id target;
@end
