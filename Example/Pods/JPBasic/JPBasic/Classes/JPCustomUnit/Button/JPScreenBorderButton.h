//
//  JPScreenBorderButton.h
//  DesignSpaceRestructure
//
//  Created by 周健平 on 2017/12/16.
//  Copyright © 2017年 周健平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPScreenBorderButton : UIButton
@property (nonatomic, copy) void (^highlightedDidChangedBlock)(BOOL jp_isHighlighted);
@end
