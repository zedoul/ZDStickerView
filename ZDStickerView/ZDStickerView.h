//
//  ZDStickerView.h
//  ZDStickerViewApp
//
//  Created by zedoul on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPGripViewBorderView;

@protocol ZDStickerViewDelegate;

@interface ZDStickerView : UIView {
    SPGripViewBorderView *borderView;
}

@property (assign, nonatomic) UIView *contentView;
@property (nonatomic, assign) id <ZDStickerViewDelegate> delegate;

- (void)hideEditingHandles;
- (void)showEditingHandles;

@end

@protocol SPUserResizableViewDelegate <NSObject>
@optional
@end

