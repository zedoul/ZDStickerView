//
//  ZDStickerView.h
//  ZDStickerViewApp
//
//  Created by zedoul on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPGripViewBorderView.h"

@protocol ZDStickerViewDelegate;

@interface ZDStickerView : UIView
{
    SPGripViewBorderView *borderView;
}

@property (assign, nonatomic) UIView *contentView;
@property (nonatomic) BOOL preventsPositionOutsideSuperview; //default = YES
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

@property (strong, nonatomic) id <ZDStickerViewDelegate> delegate;

- (void)hideDelHandle;
- (void)showDelHandle;
- (void)hideEditingHandles;
- (void)showEditingHandles;

@end

@protocol ZDStickerViewDelegate <NSObject>
@required
@optional
- (void)stickerViewDidBeginEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidEndEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidCancelEditing:(ZDStickerView *)sticker;
@end


