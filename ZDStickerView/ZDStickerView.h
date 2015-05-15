//
// ZDStickerView.h
//
// Created by Seonghyun Kim on 5/29/13.
// Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    ZDSTICKERVIEW_BUTTON_NULL,
    ZDSTICKERVIEW_BUTTON_DEL,
    ZDSTICKERVIEW_BUTTON_RESIZE,
    ZDSTICKERVIEW_BUTTON_CUSTOM,
    ZDSTICKERVIEW_BUTTON_MAX
} ZDSTICKERVIEW_BUTTONS;

@protocol ZDStickerViewDelegate;


@interface ZDStickerView : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic) BOOL preventsPositionOutsideSuperview;    // default = YES
@property (nonatomic) BOOL preventsResizing;                    // default = NO
@property (nonatomic) BOOL preventsDeleting;                    // default = NO
@property (nonatomic) BOOL preventsCustomButton;                // default = YES
@property (nonatomic) BOOL translucencySticker;                // default = YES
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

@property (weak, nonatomic) id <ZDStickerViewDelegate> stickerViewDelegate;

- (void)hideDelHandle;
- (void)showDelHandle;
- (void)hideEditingHandles;
- (void)showEditingHandles;
- (void)showCustomHandle;
- (void)hideCustomHandle;
- (void)setButton:(ZDSTICKERVIEW_BUTTONS)type image:(UIImage *)image;
- (BOOL)isEditingHandlesHidden;
@end


@protocol ZDStickerViewDelegate <NSObject>
@required
@optional
- (void)stickerViewDidBeginEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidEndEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidCancelEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidClose:(ZDStickerView *)sticker;
#ifdef ZDSTICKERVIEW_LONGPRESS
- (void)stickerViewDidLongPressed:(ZDStickerView *)sticker;
#endif
- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker;
@end
