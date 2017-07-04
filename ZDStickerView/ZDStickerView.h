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

@property (nonatomic, strong, nullable) UIView *contentView;

@property (nonatomic) BOOL preventsPositionOutsideSuperview;    // default = YES
@property (nonatomic) BOOL preventsResizingOutsideSuperview;    // default = YES
@property (nonatomic) BOOL preventsResizing;                    // default = NO
@property (nonatomic) BOOL preventsDeleting;                    // default = NO
@property (nonatomic) BOOL preventsCustomButton;                // default = YES
@property (nonatomic) BOOL translucencySticker;                // default = YES
@property (nonatomic) BOOL isLongPressedEnable;
@property (nonatomic) BOOL isSingleTapEnable;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

@property (weak, nonatomic) id <ZDStickerViewDelegate> stickerViewDelegate;

@property (nonatomic, copy, nullable) void (^singleTapBlock)(ZDStickerView * _Nonnull sticker);
@property (nonatomic, copy, nullable) void (^customButtonTapBlock)(ZDStickerView * _Nonnull sticker);
@property (nonatomic, copy, nullable) void (^didBeginEditingBlock)(ZDStickerView * _Nonnull sticker);
@property (nonatomic, copy, nullable) void (^didEndEditingBlock)(ZDStickerView * _Nonnull sticker);
@property (nonatomic, copy, nullable) void (^didCancelEditingBlock)(ZDStickerView * _Nonnull sticker);
@property (nonatomic, copy, nullable) void (^didCloseBlock)(ZDStickerView * _Nonnull sticker);

- (void)hideDelHandle;
- (void)showDelHandle;
- (void)hideEditingHandles;
- (void)showEditingHandles;
- (void)showCustomHandle;
- (void)hideCustomHandle;
- (void)setButton:(ZDSTICKERVIEW_BUTTONS)type image:(UIImage *_Nullable)image;
- (BOOL)isEditingHandlesHidden;
@end


@protocol ZDStickerViewDelegate <NSObject>
@required
@optional
- (void)stickerViewDidBeginEditing:(ZDStickerView *_Nonnull)sticker;
- (void)stickerViewDidEndEditing:(ZDStickerView *_Nonnull)sticker;
- (void)stickerViewDidCancelEditing:(ZDStickerView *_Nonnull)sticker;
- (void)stickerViewDidClose:(ZDStickerView *_Nonnull)sticker;
- (void)stickerViewDidSingleTap:(ZDStickerView *_Nonnull)sticker;
- (void)stickerViewDidLongPressed:(ZDStickerView *_Nonnull)sticker;
- (void)stickerViewDidCustomButtonTap:(ZDStickerView *_Nonnull)sticker;
@end
