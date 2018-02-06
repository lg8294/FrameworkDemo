//
//  LGLog.m
//  FrameworkDemo
//
//  Created by iOS on 2018/2/5.
//  Copyright © 2018年 lg. All rights reserved.
//

#import "LGLog.h"

@implementation LGLog

+ (instancetype)defaultLog {
    static LGLog *instance;
    
    
    return instance;
}

- (void)test {
    NSLog(@"test");
}

+ (void)bundleForSelfClass {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    NSLog(@"%@", bundle);
}
@end
