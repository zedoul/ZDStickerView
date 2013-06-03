//
//  ZDStickerView.h
//  ZDStickerViewApp
//
//  Created by zedoul on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPGripViewBorderView.h"

@interface ZDStickerView : UIView
{
    SPGripViewBorderView *borderView;
}

@property (assign, nonatomic) UIView *contentView;
@property (nonatomic) BOOL preventsPositionOutsideSuperview;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

- (void)hideEditingHandles;
- (void)showEditingHandles;

@end

