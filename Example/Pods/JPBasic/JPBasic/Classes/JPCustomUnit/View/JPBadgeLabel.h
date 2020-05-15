//
//  JPBadgeLabel.h
//  WoLive
//
//  Created by 周健平 on 2018/10/19.
//  Copyright © 2018 zhanglinan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JPBadgeLabelState) {
    JPBadgeLabelHidingState,
    JPBadgeLabelShowingState
};

@interface JPBadgeLabel : UILabel
+ (JPBadgeLabel *)baseBadgeLabel;
@property (nonatomic, assign) JPBadgeLabelState state;
@property (nonatomic, assign) NSInteger badgeCount;
@end

NS_ASSUME_NONNULL_END
