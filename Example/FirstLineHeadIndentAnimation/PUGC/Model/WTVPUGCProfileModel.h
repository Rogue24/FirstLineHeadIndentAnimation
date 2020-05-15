//
//  WTVPUGCProfileModel.h
//  FirstLineHeadIndentAnimation-Example_Example
//
//  Created by 周健平 on 2020/5/14.
//  Copyright © 2020 zhoujianping24@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTVPUGCProfileModel : NSObject
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *authorId;
@property (nonatomic, assign) NSInteger videoType;
@property (nonatomic, assign) BOOL portrait;
@property (nonatomic, copy) NSString *headPhoto;
@property (nonatomic, assign) NSInteger authorCategory;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, assign) NSInteger updateState;
@property (nonatomic, assign) BOOL attentioned;
@property (nonatomic, copy) NSString *screenUrl;
@property (nonatomic, copy) NSString *screenShotUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *onlinetime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger good;
@property (nonatomic, assign) NSInteger collects;
@property (nonatomic, assign) NSInteger shares;
@property (nonatomic, assign) NSInteger comments;
@property (nonatomic, assign) NSInteger watchs;
@property (nonatomic, assign) NSInteger fans;
@property (nonatomic, assign) BOOL hasGiveUp;
@property (nonatomic, assign) BOOL love;
@property (nonatomic, strong) WTVPUGCProfileModel *relateModel;
@end

