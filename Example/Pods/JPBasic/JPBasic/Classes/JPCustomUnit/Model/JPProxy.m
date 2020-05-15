//
//  JPProxy.m
//  JPBasic
//
//  Created by 周健平 on 2019/12/12.
//

#import "JPProxy.h"

@implementation JPProxy

+ (instancetype)proxyWithTarget:(id)target {
    JPProxy *proxy = [self alloc]; // NSProxy没有init方法
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

//- (void)dealloc {
//    NSLog(@"%s", __func__);
//}

@end
