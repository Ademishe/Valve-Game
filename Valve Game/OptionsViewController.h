//
//  OptionsViewController.h
//  Valve Game
//
//  Created by Александр Демидов on 19.01.13.
//  Copyright (c) 2013 Александр Демидов. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownBox;

@interface OptionsViewController : UIViewController {
    DropDownBox *_fieldSizeBox;
}

- (IBAction)backToMainMenu;

@end
