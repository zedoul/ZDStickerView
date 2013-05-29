//
//  ZDStickerView.m
//  ZDStickerViewApp
//
//  Created by zedoul on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "ZDStickerView.h"
#import "SPGripViewBorderView.h"
#import <QuartzCore/QuartzCore.h>

#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewDefaultMinHeight 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0

static SPUserResizableViewAnchorPoint SPUserResizableViewNoResizeAnchorPoint = { 0.0, 0.0, 0.0, 0.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewUpperLeftAnchorPoint = { 1.0, 1.0, -1.0, 1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewMiddleLeftAnchorPoint = { 1.0, 0.0, 0.0, 1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewLowerLeftAnchorPoint = { 1.0, 0.0, 1.0, 1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewUpperMiddleAnchorPoint = { 0.0, 1.0, -1.0, 0.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewUpperRightAnchorPoint = { 0.0, 1.0, -1.0, -1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewMiddleRightAnchorPoint = { 0.0, 0.0, 0.0, -1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewLowerRightAnchorPoint = { 0.0, 0.0, 1.0, -1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewLowerMiddleAnchorPoint = { 0.0, 0.0, 1.0, 0.0 };

@interface ZDStickerView ()

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *rotationControl;
@property (strong, nonatomic) UIImageView *deleteControl;

@property (nonatomic) float deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) BOOL preventsPositionOutsideSuperview;

@property (nonatomic) SPUserResizableViewAnchorPoint anchorPoint;
@property (nonatomic) CGPoint touchStart;

@end

@implementation ZDStickerView
@synthesize contentView, delegate, touchStart,anchorPoint;

@synthesize prevPoint; //resizing
@synthesize deltaAngle, startTransform; //rotation
@synthesize resizingControl, rotationControl, deleteControl;

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
        float wChange = 0.0, hChange = 0.0;
        
        wChange = (point.x - prevPoint.x); //Slow down increment
        hChange = (point.y - prevPoint.y); //Slow down increment
        
        
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                 self.bounds.size.width + (wChange),
                                 self.bounds.size.height + (hChange));
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
        prevPoint = [recognizer locationInView:self.superview];
        [self setNeedsDisplay];
    }
}

-(void)rotateViewPanGesture:(UIPanGestureRecognizer *)recognizer
{
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
        deltaAngle = atan2([recognizer locationInView:self].y-self.center.y,
                           [recognizer locationInView:self].x-self.center.x);
        startTransform = self.transform;
        [self setNeedsDisplay];
    }
}


- (void)setupDefaultAttributes {
    borderView = [[SPGripViewBorderView alloc] initWithFrame:CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset)];
    [borderView setHidden:YES];
    //[self addSubview:borderView];
    self.minWidth = kSPUserResizableViewDefaultMinWidth;
    self.minHeight = kSPUserResizableViewDefaultMinHeight;
    self.preventsPositionOutsideSuperview = YES;
    
    
    
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
    
    // Ensure the border view is always on top by removing it and adding it to the end of the subview list.
    [borderView removeFromSuperview];
    //[self addSubview:borderView];
}

- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    contentView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
    [borderView setNeedsDisplay];
}




static CGFloat SPDistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
};

typedef struct CGPointSPUserResizableViewAnchorPointPair {
    CGPoint point;
    SPUserResizableViewAnchorPoint anchorPoint;
} CGPointSPUserResizableViewAnchorPointPair;


- (SPUserResizableViewAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint {
    // (1) Calculate the positions of each of the anchor points.
    CGPointSPUserResizableViewAnchorPointPair upperLeft = { CGPointMake(0.0, 0.0), SPUserResizableViewUpperLeftAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair upperMiddle = { CGPointMake(self.bounds.size.width/2, 0.0), SPUserResizableViewUpperMiddleAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair upperRight = { CGPointMake(self.bounds.size.width, 0.0), SPUserResizableViewUpperRightAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair middleRight = { CGPointMake(self.bounds.size.width, self.bounds.size.height/2), SPUserResizableViewMiddleRightAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair lowerRight = { CGPointMake(self.bounds.size.width, self.bounds.size.height), SPUserResizableViewLowerRightAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair lowerMiddle = { CGPointMake(self.bounds.size.width/2, self.bounds.size.height), SPUserResizableViewLowerMiddleAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair lowerLeft = { CGPointMake(0, self.bounds.size.height), SPUserResizableViewLowerLeftAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair middleLeft = { CGPointMake(0, self.bounds.size.height/2), SPUserResizableViewMiddleLeftAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair centerPoint = { CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), SPUserResizableViewNoResizeAnchorPoint };
    
    // (2) Iterate over each of the anchor points and find the one closest to the user's touch.
    CGPointSPUserResizableViewAnchorPointPair allPoints[9] = { upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight, centerPoint };
    CGFloat smallestDistance = MAXFLOAT; CGPointSPUserResizableViewAnchorPointPair closestPoint = centerPoint;
    for (NSInteger i = 0; i < 9; i++) {
        CGFloat distance = SPDistanceBetweenTwoPoints(touchPoint, allPoints[i].point);
        if (distance < smallestDistance) {
            closestPoint = allPoints[i];
            smallestDistance = distance;
        }
    }
    return closestPoint.anchorPoint;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [borderView setHidden:NO];
    UITouch *touch = [touches anyObject];
    anchorPoint = [self anchorPointForTouchLocation:[touch locationInView:self]];
    
    // When resizing, all calculations are done in the superview's coordinate space.
    touchStart = [touch locationInView:self.superview];
    
    //if (![self isResizing]) {
        // When translating, all calculations are done in the view's coordinate space.
        touchStart = [touch locationInView:self];
    //}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x, self.center.y + touchPoint.y - touchStart.y);
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
    /*
    if ([self isResizing]) {
        [self resizeUsingTouchLocation:[[touches anyObject] locationInView:self.superview]];
    } else {
     */
        [self translateUsingTouchLocation:[[touches anyObject] locationInView:self]];
    //}
}

@end
