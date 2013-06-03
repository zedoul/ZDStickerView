//
//  ZDStickerView.h
//  ZDStickerViewApp
//
//  Created by zedoul on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDStickerView : UIView
{
    //CGPoint originalCenter;
}

@property (assign, nonatomic) UIView *contentView;
@property (nonatomic) BOOL preventsLayoutWhileResizing;
@property (nonatomic) BOOL preventsPositionOutsideSuperview;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

- (void)hideEditingHandles;
- (void)showEditingHandles;

@end

