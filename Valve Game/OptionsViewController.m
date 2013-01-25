//
//  OptionsViewController.m
//  Valve Game
//
//  Created by Александр Демидов on 19.01.13.
//  Copyright (c) 2013 Александр Демидов. All rights reserved.
//

#import "OptionsViewController.h"
#import "DropDownBox.h"

@implementation OptionsViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    _fieldSizeBox = [[DropDownBox alloc] initWithFrame:CGRectMake(self.view.center.x,
                                                                  self.view.center.y,
                                                                  0.4 * self.view.bounds.size.width,
                                                                  0.06 * self.view.bounds.size.height)];
    NSArray *list = [NSArray arrayWithObjects:@"2x2", @"4x4", @"8x8", @"16x16", nil];
    [_fieldSizeBox setOptionsList:list];
    [self.view addSubview:_fieldSizeBox];
}

- (void)dealloc
{
    _fieldSizeBox = nil;
}

#pragma mark - Public Methods
#pragma mark Actions

- (IBAction)backToMainMenu
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
