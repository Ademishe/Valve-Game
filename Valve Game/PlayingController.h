//
//  PlayingController.h
//  Valve Game
//
//  Created by Александр Демидов on 19.01.13.
//  Copyright (c) 2013 Александр Демидов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingController : UIViewController {
    NSMutableArray *_arrayWithValves;
    NSInteger _sideSize;
}

- (IBAction)backToMainMenu;

@end
