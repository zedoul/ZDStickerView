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
                              initWithImage:[UIImage imageNamed:@"sampleImage.png"]];
    
    CGRect gripFrame = CGRectMake(50, 50, 200, 150);
    ZDStickerView *userResizableView = [[ZDStickerView alloc] initWithFrame:gripFrame];
    userResizableView.contentView = imageView;
//    userResizableView.backgroundColor = [UIColor yellowColor];
    userResizableView.preventsPositionOutsideSuperview = YES;
    [userResizableView showEditingHandles];
    [self.view addSubview:userResizableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
