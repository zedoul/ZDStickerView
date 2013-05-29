//
//  ZDStickerView.h
//  ZDStickerViewApp
//
//  Created by zedoul on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDStickerViewDelegate;

@interface ZDStickerView : UIView

@property (assign, nonatomic) UIView *contentView;
@property (nonatomic) BOOL preventsLayoutWhileResizing;
@property (nonatomic) BOOL preventsPositionOutsideSuperview;
@property (nonatomic, assign) id <ZDStickerViewDelegate> delegate;

//- (void)hideEditingHandles;
//- (void)showEditingHandles;

@end

@protocol ZDStickerViewDelegate <NSObject>
@optional
@end

