//
//  DropDownBox.m
//  Valve Game
//
//  Created by Александр Демидов on 19.01.13.
//  Copyright (c) 2013 Александр Демидов. All rights reserved.
//

#import "DropDownBox.h"

#define ANIMATION_DURATION 0.5f

@interface DropDownBox ()

- (void)toggleDropDownTableView;
- (void)showTableView;
- (void)hideTableView;

@end


@implementation DropDownBox

@synthesize optionsList = _optionsList;
@synthesize selectedRow = _selectedRow;

#pragma mark - Lifecycle methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		//configuring label
        _selectedOption = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, self.bounds.size.height)];
        [_selectedOption setBackgroundColor:[UIColor whiteColor]];
        [_selectedOption setNumberOfLines:1];
        [_selectedOption setTextAlignment:NSTextAlignmentCenter];
        [_selectedOption setText:@"Hello!"];
        [_selectedOption setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(toggleDropDownTableView)];
        [_selectedOption addGestureRecognizer:tapRecognizer];
        
        [self addSubview:_selectedOption];
        
		//configuring drop down table view
        _dropDownTable = [[UITableView alloc] initWithFrame:CGRectMake(0.f, self.bounds.size.height, self.bounds.size.width, 4.0 * self.bounds.size.height)
                                                      style:UITableViewStylePlain];
        [_dropDownTable setDelegate:self];
        [_dropDownTable setDataSource:self];
        [self addSubview:_dropDownTable];
        
        _tableMask = [CALayer layer];
        [_tableMask setBackgroundColor:[[UIColor blackColor] CGColor]];
        [_tableMask setFrame:_dropDownTable.bounds];
        _showPoint = _tableMask.position;
        _hidePoint = CGPointMake(_tableMask.position.x, _tableMask.position.y - _tableMask.bounds.size.height);
        [_tableMask setPosition:_hidePoint];
        [_dropDownTable.layer setMask:_tableMask];
        
        _isTableViewVisible = NO;
    }
    return self;
}

- (void)setOptionsList:(NSArray *)optionsList
{
    _optionsList = optionsList;
    id param = [[NSUserDefaults standardUserDefaults] objectForKey:@"fieldSize"];
    if (param == nil) [_selectedOption setText:[_optionsList objectAtIndex:0]];
    else [_selectedOption setText:(NSString *)param];
}

- (void)dealloc
{
    [self setOptionsList:nil];
    _selectedOption = nil;
    _dropDownTable = nil;
    _tableMask = nil;
}

#pragma mark - Private Methods

- (void)toggleDropDownTableView
{
    if (_isTableViewVisible) {
        [self hideTableView];
        _isTableViewVisible = NO;
    }
    else {
        [self showTableView];
        _isTableViewVisible = YES;
    }
}

- (void)showTableView
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + _dropDownTable.frame.size.height)];
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
    [_tableMask setPosition:_showPoint];
    [CATransaction commit];
}

- (void)hideTableView
{
    [_dropDownTable setContentOffset:CGPointZero animated:NO];
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
    [_tableMask setPosition:_hidePoint];
    [CATransaction commit];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - _dropDownTable.frame.size.height)];
}

#pragma mark - Delegate Methods
#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _selectedOption.bounds.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedRow = indexPath.row;
    [[NSUserDefaults standardUserDefaults] setObject:[self.optionsList objectAtIndex:_selectedRow] forKey:@"fieldSize"];
    [_selectedOption setText:[self.optionsList objectAtIndex:_selectedRow]];
    [self toggleDropDownTableView];
}

#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.optionsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"DropDownTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.optionsList objectAtIndex:row];
    return cell;
}

#pragma mark Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [_tableMask setPosition:CGPointMake(_showPoint.x - scrollView.contentOffset.x, _showPoint.y + scrollView.contentOffset.y)];
    [CATransaction commit];
}

@end
