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
#define kSPUserResizableViewInteractiveBorderSize 10.0

@interface ZDStickerView ()

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *rotationControl;
@property (strong, nonatomic) UIImageView *deleteControl;

@property (nonatomic) float deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;

@end

@implementation ZDStickerView
@synthesize contentView, touchStart;

@synthesize prevPoint,preventsLayoutWhileResizing; //resizing
@synthesize deltaAngle, startTransform; //rotation
@synthesize resizingControl, rotationControl, deleteControl;
@synthesize preventsPositionOutsideSuperview;
@synthesize minWidth, minHeight;

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
    if ([recognizer state]== UIGestureRecognizerStateBegan)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
        
        /* Rotation */
        /*
        deltaAngle = atan2([recognizer locationInView:self.superview].y-self.center.y,
                           [recognizer locationInView:self.superview].x-self.center.x);
        startTransform = self.transform;
         */
        /*
        deltaAngle = atan2([recognizer locationInView:self].y - self.center.y,
                           [recognizer locationInView:self].x - self.center.x);
         */
        /*
        deltaAngle = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);
        NSLog(@"recognizer [%f : %f]", [recognizer locationInView:self.superview].x,[recognizer locationInView:self.superview].y);
        NSLog(@"self.center [%f : %f]", self.center.x,self.center.y);
        NSLog(@"deltaAngle [%f]", deltaAngle);
        */
        //originalCenter = self.center;
        //self.transform = CGAffineTransformMakeRotation(-1 * 180.0f * M_PI / 180.0f);
        //startTransform = self.transform;
        //NSLog(@"deltaAngle[%f]", deltaAngle);
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        if (self.bounds.size.width < minWidth || self.bounds.size.width < minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     minWidth,
                                     minHeight);
            contentView.frame = CGRectMake(12, 12,
                                     self.bounds.size.width-24, self.bounds.size.height-27);
            resizingControl.frame =CGRectMake(self.bounds.size.width-25,
                                       self.bounds.size.height-25, 25, 25);
            rotationControl.frame = CGRectMake(0, self.bounds.size.height-25,
                                        25, 25);
            deleteControl.frame = CGRectMake(0, 0, 25, 25);
            prevPoint = [recognizer locationInView:self];
            return;
        }
        
        CGPoint point = [recognizer locationInView:self];
        float wChange = 0.0, hChange = 0.0;
        
        wChange = (point.x - prevPoint.x);
        hChange = (point.y - prevPoint.y);
        
        if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
            prevPoint = [recognizer locationInView:self];
            return;
        }
        
        if (YES == preventsLayoutWhileResizing) {
            if (wChange < 0.0f && hChange < 0.0f) {
                float change = MIN(wChange, hChange);
                wChange = change;
                hChange = change;
            }
            if (wChange < 0.0f) {
                hChange = wChange;
            } else if (hChange < 0.0f) {
                wChange = hChange;
            } else {
                float change = MAX(wChange, hChange);
                wChange = change;
                hChange = change;
            }
        }
        
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                 self.bounds.size.width + (wChange),
                                 self.bounds.size.height + (hChange));
        
        contentView.frame = CGRectMake(12, 12,
                                 self.bounds.size.width-24, self.bounds.size.height-27);
        resizingControl.frame =CGRectMake(self.bounds.size.width-25,
                                   self.bounds.size.height-25, 25, 25);
        rotationControl.frame = CGRectMake(0, self.bounds.size.height-25, 25, 25);
        deleteControl.frame = CGRectMake(0, 0, 25, 25);
        
        prevPoint = [recognizer locationInView:self];
        
        
        /* Rotation */
        /*
        [self setCenter:CGPointMake(originalCenter.x + [recognizer translationInView:self].x ,
                                    originalCenter.y + [recognizer translationInView:self].y )];
        
        CGPoint p1 = [recognizer locationInView:self.superview];
        CGPoint p2 = self.center;
        
        float adjacent = p2.x-p1.x;
        float opposite = p2.y-p1.y;
        
        float angle = atan2f(adjacent, opposite);
        
        [self setTransform:CGAffineTransformMakeRotation(angle*-1)];
         */
        
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);
        float angleDiff = deltaAngle - ang;
        //deltaAngle = ang;
        
        //NSLog(@"angleDiff [%f] (deltaAngle[%f] - ang[%f])", angleDiff, deltaAngle, ang);
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
        NSLog(@"ang [%f]", ang);
        //self.transform = CGAffineTransformRotate(self.transform, angleDiff);
        
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        prevPoint = [recognizer locationInView:self];
        
        [self setNeedsDisplay];
    }
}

-(void)rotateViewPanGesture:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        deltaAngle = atan2([recognizer locationInView:self.superview].y-self.center.y,
                           [recognizer locationInView:self.superview].x-self.center.x);
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
        deltaAngle = atan2([recognizer locationInView:self.superview].y-self.center.y,
                           [recognizer locationInView:self.superview].x-self.center.x);
        startTransform = self.transform;
        [self setNeedsDisplay];
    }
}

- (void)setupDefaultAttributes {
    if (kSPUserResizableViewDefaultMinWidth > self.bounds.size.width*0.5) {
        self.minWidth = kSPUserResizableViewDefaultMinWidth;
        self.minHeight = self.bounds.size.height * (kSPUserResizableViewDefaultMinWidth/self.bounds.size.width);
    } else {
        self.minWidth = self.bounds.size.width*0.5;
        self.minHeight = self.bounds.size.height*0.5;
    }
    self.preventsPositionOutsideSuperview = YES;
    self.preventsLayoutWhileResizing = NO;
    
    deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    deleteControl.backgroundColor = [UIColor clearColor];
    deleteControl.image = [UIImage imageNamed:@"ZDBtn3.png" ];
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
    resizingControl.image = [UIImage imageNamed:@"ZDBtn2.png.png" ];
    UIPanGestureRecognizer* panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(resizeTranslate:)];
    [resizingControl addGestureRecognizer:panResizeGesture];
    [self addSubview:resizingControl];
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x);
    
    //Rotating view which is in bottom left corner
    rotationControl = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                   self.frame.size.height-25,
                                                                   25, 25)];
    rotationControl.backgroundColor = [UIColor clearColor];
    rotationControl.image = [UIImage imageNamed:@"ZDBtn1.png.png" ];
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
    touchStart = [touch locationInView:self.superview];
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

- (void)hideEditingHandles
{
    resizingControl.hidden = YES;
    rotationControl.hidden = YES;
    deleteControl.hidden = YES;
}

- (void)showEditingHandles
{
    resizingControl.hidden = NO;
    rotationControl.hidden = NO;
    deleteControl.hidden = NO;
}

@end
