//
//  DropDownBox.h
//  Valve Game
//
//  Created by Александр Демидов on 19.01.13.
//  Copyright (c) 2013 Александр Демидов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DropDownBox : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    UITableView *_dropDownTable;
    UILabel *_selectedOption;
    CALayer *_tableMask;
    BOOL _isTableViewVisible;
    
    CGPoint _hidePoint;
    CGPoint _showPoint;
}

@property (readonly) int selectedRow;
@property (strong, nonatomic) NSArray *optionsList;

@end
