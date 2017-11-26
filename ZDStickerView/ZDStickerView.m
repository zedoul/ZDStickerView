//
// ZDStickerView.m
//
// Created by Seonghyun Kim on 5/29/13.
// Copyright (c) 2013 scipi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ZDStickerView.h"
#import "SPGripViewBorderView.h"


#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0
#define kZDStickerViewControlSize 36.0



@interface ZDStickerView ()

@property (nonatomic, strong) SPGripViewBorderView *borderView;

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *deleteControl;
@property (strong, nonatomic) UIImageView *customControl;

@property (nonatomic) BOOL preventsLayoutWhileResizing;

@property (nonatomic) CGFloat deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;

@end



@implementation ZDStickerView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */

#ifdef ZDSTICKERVIEW_LONGPRESS
- (void)longPress:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidLongPressed:)])
        {
            [self.stickerViewDelegate stickerViewDidLongPressed:self];
        }
    }
}
#endif


- (void)singleTap:(UIPanGestureRecognizer *)recognizer
{
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidClose:)])
    {
        [self.stickerViewDelegate stickerViewDidClose:self];
    }

    if (NO == self.preventsDeleting)
    {
        UIView *close = (UIView *)[recognizer view];
        [close.superview removeFromSuperview];
    }
}



- (void)customTap:(UIPanGestureRecognizer *)recognizer
{
    if (NO == self.preventsCustomButton)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCustomButtonTap:)])
        {
            [self.stickerViewDelegate stickerViewDidCustomButtonTap:self];
        }
    }
}


- (void)pinchTranslate:(UIPinchGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)rotateTranslate:(UIRotationGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        [self enableTransluceny:YES];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        [self enableTransluceny:YES];
        
        // preventing from the picture being shrinked too far by resizing
        if (self.bounds.size.width < self.minWidth || self.bounds.size.height < self.minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     self.minWidth+1,
                                     self.minHeight+1);
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                   self.bounds.size.height-kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize);
            self.deleteControl.frame = CGRectMake(0, 0,
                                                  kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                 0,
                                                 kZDStickerViewControlSize,
                                                 kZDStickerViewControlSize);
            self.prevPoint = [recognizer locationInView:self];
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;

            wChange = (point.x - self.prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);

            hChange = wRatioChange * self.bounds.size.height;

            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                self.prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }

            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (wChange),
                                     self.bounds.size.height + (hChange));
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                   self.bounds.size.height-kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.deleteControl.frame = CGRectMake(0, 0,
                                                  kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                 0,
                                                 kZDStickerViewControlSize,
                                                 kZDStickerViewControlSize);
            
            self.prevPoint = [recognizer locationOfTouch:0 inView:self];
        }

        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);

        float angleDiff = self.deltaAngle - ang;

        if (NO == self.preventsResizing)
        {
            self.transform = CGAffineTransformMakeRotation(-angleDiff);
        }

        self.borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
        [self.borderView setNeedsDisplay];

        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        [self enableTransluceny:NO];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}



- (void)setupDefaultAttributes
{
    self.borderView = [[SPGripViewBorderView alloc] initWithFrame:CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset)];
    self.borderView.borderColor = self.borderColor;
    self.borderView.borderWidth = self.borderWidth;
    [self.borderView setHidden:YES];
    [self addSubview:self.borderView];

    if (kSPUserResizableViewDefaultMinWidth > self.bounds.size.width*0.5)
    {
        self.minWidth = kSPUserResizableViewDefaultMinWidth;
        self.minHeight = self.bounds.size.height * (kSPUserResizableViewDefaultMinWidth/self.bounds.size.width);
    }
    else
    {
        self.minWidth = self.bounds.size.width*0.5;
        self.minHeight = self.bounds.size.height*0.5;
    }

    self.preventsPositionOutsideSuperview = YES;
    self.preventsLayoutWhileResizing = YES;
    self.preventsResizing = NO;
    self.preventsDeleting = NO;
    self.preventsCustomButton = YES;
    self.translucencySticker = YES;
    self.allowPinchToZoom = YES;
    self.allowRotationGesture = YES;
    self.allowDragging = YES;

#ifdef ZDSTICKERVIEW_LONGPRESS
    UILongPressGestureRecognizer*longpress = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self
                                                      action:@selector(longPress:)];
    [self addGestureRecognizer:longpress];
#endif

    self.deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                      kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.deleteControl.backgroundColor = [UIColor clearColor];
    self.deleteControl.image = [UIImage imageNamed:@"ZDStickerView.bundle/ZDBtn3.png"];
    self.deleteControl.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                                 action:@selector(singleTap:)];
    [self.deleteControl addGestureRecognizer:singleTap];
    [self addSubview:self.deleteControl];

    self.resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kZDStickerViewControlSize,
                                                                        self.frame.size.height-kZDStickerViewControlSize,
                                                                        kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.resizingControl.backgroundColor = [UIColor clearColor];
    self.resizingControl.userInteractionEnabled = YES;
    self.resizingControl.image = [UIImage imageNamed:@"ZDStickerView.bundle/ZDBtn2.png.png"];
    UIPanGestureRecognizer*panResizeGesture = [[UIPanGestureRecognizer alloc]
                                               initWithTarget:self
                                                       action:@selector(resizeTranslate:)];
    [self.resizingControl addGestureRecognizer:panResizeGesture];
    [self addSubview:self.resizingControl];

    self.customControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kZDStickerViewControlSize,
                                                                      0,
                                                                      kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.customControl.backgroundColor = [UIColor clearColor];
    self.customControl.userInteractionEnabled = YES;
    self.customControl.image = nil;
    
    if (self.allowPinchToZoom) {
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(pinchTranslate:)];
        [self addGestureRecognizer:pinchGesture];
    }
    
    if (self.allowRotationGesture) {
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(rotateTranslate:)];
        [self addGestureRecognizer:rotationGesture];
    }
    
    UITapGestureRecognizer *customTapGesture = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                        action:@selector(customTap:)];
    [self.customControl addGestureRecognizer:customTapGesture];
    [self addSubview:self.customControl];

    self.deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                            self.frame.origin.x+self.frame.size.width - self.center.x);
}



- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setupDefaultAttributes];
    }

    return self;
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupDefaultAttributes];
    }

    return self;
}



- (void)setContentView:(UIView *)newContentView
{
    [self.contentView removeFromSuperview];
    _contentView = newContentView;

    self.contentView.frame = CGRectInset(self.bounds,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:self.contentView];

    for (UIView *subview in [self.contentView subviews])
    {
        [subview setFrame:CGRectMake(0, 0,
                                     self.contentView.frame.size.width,
                                     self.contentView.frame.size.height)];

        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    [self bringSubviewToFront:self.borderView];
    [self bringSubviewToFront:self.resizingControl];
    [self bringSubviewToFront:self.deleteControl];
    [self bringSubviewToFront:self.customControl];
}



- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    self.contentView.frame = CGRectInset(self.bounds,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    for (UIView *subview in [self.contentView subviews])
    {
        [subview setFrame:CGRectMake(0, 0,
                                     self.contentView.frame.size.width,
                                     self.contentView.frame.size.height)];

        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    self.borderView.frame = CGRectInset(self.bounds,
                                        kSPUserResizableViewGlobalInset,
                                        kSPUserResizableViewGlobalInset);

    self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                           self.bounds.size.height-kZDStickerViewControlSize,
                                           kZDStickerViewControlSize,
                                           kZDStickerViewControlSize);

    self.deleteControl.frame = CGRectMake(0, 0,
                                          kZDStickerViewControlSize, kZDStickerViewControlSize);

    self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                         0,
                                         kZDStickerViewControlSize,
                                         kZDStickerViewControlSize);

    [self.borderView setNeedsDisplay];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.allowDragging)
    {
        return;
    }

    [self enableTransluceny:YES];

    UITouch *touch = [touches anyObject];
    self.touchStart = [touch locationInView:self.superview];
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidBeginEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidBeginEditing:self];
    }
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self enableTransluceny:NO];

    // Notify the delegate we've ended our editing session.
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidEndEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidEndEditing:self];
    }
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self enableTransluceny:NO];

    // Notify the delegate we've ended our editing session.
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCancelEditing:)])
    {
        [self.stickerViewDelegate stickerViewDidCancelEditing:self];
    }
}



- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - self.touchStart.x,
                                    self.center.y + touchPoint.y - self.touchStart.y);

    if (self.preventsPositionOutsideSuperview)
    {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > self.superview.bounds.size.width - midPointX)
        {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }

        if (newCenter.x < midPointX)
        {
            newCenter.x = midPointX;
        }

        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > self.superview.bounds.size.height - midPointY)
        {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }

        if (newCenter.y < midPointY)
        {
            newCenter.y = midPointY;
        }
    }

    self.center = newCenter;
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.allowDragging)
    {
        return;
    }

    [self enableTransluceny:YES];

    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.resizingControl.frame, touchLocation))
    {
        return;
    }

    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    self.touchStart = touch;
}



- (void)hideDelHandle
{
    self.deleteControl.hidden = YES;
}



- (void)showDelHandle
{
    self.deleteControl.hidden = NO;
}



- (void)hideEditingHandles
{
    self.resizingControl.hidden = YES;
    self.deleteControl.hidden = YES;
    self.customControl.hidden = YES;
    [self.borderView setHidden:YES];
}



- (void)showEditingHandles
{
    if (NO == self.preventsCustomButton)
    {
        self.customControl.hidden = NO;
    }
    else
    {
        self.customControl.hidden = YES;
    }

    if (NO == self.preventsDeleting)
    {
        self.deleteControl.hidden = NO;
    }
    else
    {
        self.deleteControl.hidden = YES;
    }

    if (NO == self.preventsResizing)
    {
        self.resizingControl.hidden = NO;
    }
    else
    {
        self.resizingControl.hidden = YES;
    }

    [self.borderView setHidden:NO];
}



- (void)showCustomHandle
{
    self.customControl.hidden = NO;
}



- (void)hideCustomHandle
{
    self.customControl.hidden = YES;
}



- (void)setButton:(ZDStickerViewButton)type image:(UIImage*)image
{
    switch (type)
    {
        case ZDStickerViewButtonResize:
            self.resizingControl.image = image;
            break;
        case ZDStickerViewButtonDel:
            self.deleteControl.image = image;
            break;
        case ZDStickerViewButtonCustom:
            self.customControl.image = image;
            break;

        default:
            break;
    }
}



- (BOOL)isEditingHandlesHidden
{
    return self.borderView.hidden;
}



- (void)enableTransluceny:(BOOL)state
{
    if (self.translucencySticker == YES)
    {
        if (state == YES)
        {
            self.alpha = 0.65;
        }
        else
        {
            self.alpha = 1.0;
        }
    }
}

- (UIColor *)borderColor {
    return self.borderView.borderColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.borderView.borderColor = borderColor;
}

- (CGFloat)borderWidth {
    return self.borderView.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.borderView.borderWidth = borderWidth;
}


@end
