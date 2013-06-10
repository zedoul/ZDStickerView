//
//  ViewController.m
//  ZDStickerViewApp
//
//  Created by zedoul on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "ViewController.h"
#import "ZDStickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc]
                              initWithImage:[UIImage imageNamed:@"sampleImage.jpg"]];
    
    CGRect gripFrame1 = CGRectMake(50, 50, 140, 140);
    ZDStickerView *userResizableView1 = [[ZDStickerView alloc] initWithFrame:gripFrame1];
    userResizableView1.contentView = imageView;
    userResizableView1.preventsPositionOutsideSuperview = NO;
    [userResizableView1 showEditingHandles];
    [self.view addSubview:userResizableView1];
    
    CGRect gripFrame2 = CGRectMake(50, 200, 180, 140);
    UITextView *textView = [[UITextView alloc] initWithFrame:gripFrame2];
    textView.text = @"ZDStickerView is Objective-C module for iOS and offer complete configurability, including movement, resizing, rotation and more, with one finger.";
    ZDStickerView *userResizableView2 = [[ZDStickerView alloc] initWithFrame:gripFrame2];
    userResizableView2.contentView = textView;
    userResizableView2.preventsPositionOutsideSuperview = NO;
    [userResizableView2 showEditingHandles];
    [self.view addSubview:userResizableView2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
