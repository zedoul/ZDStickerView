//
//  ZDStickerView.m
//  ZDStickerViewApp
//
//  Created by zedoul on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "ZDStickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewDefaultMinHeight 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0

@interface ZDStickerView ()

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *rotationControl;
@property (strong, nonatomic) UIImageView *deleteControl;

@property (nonatomic) float deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

@property (nonatomic) CGPoint touchStart;

@property (nonatomic) BOOL isResizing;
@property (nonatomic) BOOL isRotating;

@end

@implementation ZDStickerView
@synthesize contentView, delegate, touchStart;

@synthesize prevPoint,preventsLayoutWhileResizing; //resizing
@synthesize deltaAngle, startTransform; //rotation
@synthesize resizingControl, rotationControl, deleteControl;
@synthesize preventsPositionOutsideSuperview;
@synthesize isRotating, isResizing;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)singleTap:(UIPanGestureRecognizer *)recognizer
{
    UIView * close = (UIView *)[recognizer view];
    [close.superview removeFromSuperview];
}

-(void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    isResizing = YES;
    if ([recognizer state]== UIGestureRecognizerStateBegan)
    {
        prevPoint = [recognizer locationInView:self.superview];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        if (self.bounds.size.width < 20)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     20,
                                     self.bounds.size.height);
            contentView.frame = CGRectMake(12, 12,
                                     self.bounds.size.width-24, self.bounds.size.height-27);
            resizingControl.frame =CGRectMake(self.bounds.size.width-25,
                                       self.bounds.size.height-25, 25, 25);
            rotationControl.frame = CGRectMake(0, self.bounds.size.height-25,
                                        25, 25);
            deleteControl.frame = CGRectMake(0, 0, 25, 25);
        }
        
        if(self.bounds.size.height < 20)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     self.bounds.size.width, 20);
            contentView.frame = CGRectMake(12, 12, self.bounds.size.width-24,
                                           self.bounds.size.height-27);
            resizingControl.frame =CGRectMake(self.bounds.size.width-25,
                                              self.bounds.size.height-25,
                                              25, 25);
            rotationControl.frame = CGRectMake(0, self.bounds.size.height-25, 25, 25);
            deleteControl.frame = CGRectMake(0, 0, 25, 25);
        }
        
        CGPoint point = [recognizer locationInView:self.superview];
        float wChange = 0.0, hChange = 0.0, change = 0.0f;
        
        wChange = (point.x - prevPoint.x); //Slow down increment
        hChange = (point.y - prevPoint.y); //Slow down increment
        if (ABS(wChange) < ABS(hChange)){
            change = hChange;
        } else {
            change = wChange;
        }
        /*
        NSLog(@"X[%d] = %d + %d - %d", (int)newCenter.x,(int)self.center.x,
              (int)touchPoint.x,(int)touchStart.x);
        NSLog(@"Y[%d] = %d + %d - %d", (int)newCenter.y,(int)self.center.y,
              (int)touchPoint.y,(int)touchStart.y);
        */
        if (self.preventsPositionOutsideSuperview) {
            CGFloat midPointX = CGRectGetMidX(self.bounds);
            CGFloat midPointY = CGRectGetMidY(self.bounds);
            if (YES == preventsLayoutWhileResizing) {
                /*
                if (newCenter.x > self.superview.bounds.size.width - midPointX) {
                    newCenter.x = self.superview.bounds.size.width - midPointX;
                }
                if (newCenter.x < midPointX) {
                    newCenter.x = midPointX;
                }
                 */
            } else {
                
            }
        }
        
        if (YES == preventsLayoutWhileResizing) {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (change),
                                     self.bounds.size.height + (change));
        } else {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (wChange),
                                     self.bounds.size.height + (hChange));
        }
        
        contentView.frame = CGRectMake(12, 12,
                                 self.bounds.size.width-24, self.bounds.size.height-27);
        resizingControl.frame =CGRectMake(self.bounds.size.width-25,
                                   self.bounds.size.height-25, 25, 25);
        rotationControl.frame = CGRectMake(0, self.bounds.size.height-25, 25, 25);
        deleteControl.frame = CGRectMake(0, 0, 25, 25);
        
        prevPoint = [recognizer locationInView:self.superview];
        
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        isResizing = NO;
        prevPoint = [recognizer locationInView:self.superview];
        [self setNeedsDisplay];
    }
}

-(void)rotateViewPanGesture:(UIPanGestureRecognizer *)recognizer
{
    isRotating = YES;
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        deltaAngle = atan2([recognizer locationInView:self].y-self.center.y,
                           [recognizer locationInView:self].x-self.center.x);
        startTransform = self.transform;
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);
        float angleDiff = deltaAngle - ang;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        isRotating = NO;
        deltaAngle = atan2([recognizer locationInView:self].y-self.center.y,
                           [recognizer locationInView:self].x-self.center.x);
        startTransform = self.transform;
        [self setNeedsDisplay];
    }
}


- (void)setupDefaultAttributes {
    self.minWidth = kSPUserResizableViewDefaultMinWidth;
    self.minHeight = kSPUserResizableViewDefaultMinHeight;
    self.preventsPositionOutsideSuperview = YES;
    self.preventsLayoutWhileResizing = NO;
    self.isResizing = NO;
    self.isRotating = NO;
    
    deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    deleteControl.backgroundColor = [UIColor clearColor];
    deleteControl.image = [UIImage imageNamed:@"close_gold.png" ];
    deleteControl.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(singleTap:)];
    [deleteControl addGestureRecognizer:singleTap];
    [self addSubview:deleteControl];
    
    resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-25,
                                                                   self.frame.size.height-25,
                                                                   25, 25)];
    resizingControl.backgroundColor = [UIColor clearColor];
    resizingControl.userInteractionEnabled = YES;
    resizingControl.image = [UIImage imageNamed:@"button_02.png" ];
    UIPanGestureRecognizer* panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(resizeTranslate:)];
    [resizingControl addGestureRecognizer:panResizeGesture];
    [self addSubview:resizingControl];
    
    //Rotating view which is in bottom left corner
    rotationControl = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                   self.frame.size.height-25,
                                                                   25, 25)];
    rotationControl.backgroundColor = [UIColor clearColor];
    rotationControl.image = [UIImage imageNamed:@"button_01.png" ];
    rotationControl.userInteractionEnabled = YES;
    UIPanGestureRecognizer * panRotateGesture = [[UIPanGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(rotateViewPanGesture:)];
    [rotationControl addGestureRecognizer:panRotateGesture];
    [panRotateGesture requireGestureRecognizerToFail:panResizeGesture];
    [self addSubview:rotationControl];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (void)setContentView:(UIView *)newContentView {
    [contentView removeFromSuperview];
    contentView = newContentView;
    contentView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    [self addSubview:contentView];
}

- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    contentView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (YES == isResizing || YES == isRotating) {
        // When resizing/rotating, all calculations are done in the superview's coordinate space.
        NSLog(@"Resizing | Rotating");
        touchStart = [touch locationInView:self.superview];
    } else {
        // When translating, all calculations are done in the view's coordinate space.
        NSLog(@"Translating");
//        touchStart = [touch locationInView:self];
        touchStart = [touch locationInView:self.superview];
        NSLog(@"X[%d] Y[%d]", (int)touchStart.x,(int)touchStart.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y);
    
    if (self.preventsPositionOutsideSuperview) {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > self.superview.bounds.size.width - midPointX) {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }
        if (newCenter.x < midPointX) {
            newCenter.x = midPointX;
        }
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > self.superview.bounds.size.height - midPointY) {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }
        if (newCenter.y < midPointY) {
            newCenter.y = midPointY;
        }
    }
    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    touchStart = touch;
}

@end
