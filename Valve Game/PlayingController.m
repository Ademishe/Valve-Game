//
//  PlayingController.m
//  Valve Game
//
//  Created by Александр Демидов on 19.01.13.
//  Copyright (c) 2013 Александр Демидов. All rights reserved.
//

#import "PlayingController.h"
#import <QuartzCore/QuartzCore.h>

#define SIDE_BORDER 0.05
#define TOP_BORDER 0.07
#define VALVE_SIZE 0.08
#define kMyAnimationDuration 0.5
#define STARTING_RAND_MOVES 7

@interface CALayer (MyAdditions)

@property BOOL isClosed;
@property int row;
@property int column;
- (CABasicAnimation *)getRotationAnimation;
- (void)toggleIsClosed;

@end

@implementation CALayer (MyAdditions)

@dynamic isClosed;
@dynamic row;
@dynamic column;

- (CABasicAnimation *)getRotationAnimation
{
    NSNumber *rotationAtStart = [self valueForKeyPath:@"transform.rotation"];
    CGFloat myRotationAngle;
    if (self.isClosed) myRotationAngle = M_PI / 2;
    else myRotationAngle = -M_PI / 2;
    
    CATransform3D myRotationTransform = CATransform3DRotate(self.transform, myRotationAngle, 0.0, 0.0, 1.0);
    self.transform = myRotationTransform;
    CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    myAnimation.duration = kMyAnimationDuration;
    myAnimation.fromValue = rotationAtStart;
    myAnimation.toValue = [NSNumber numberWithFloat:([rotationAtStart floatValue] + myRotationAngle)];
    return myAnimation;
}

- (void)toggleIsClosed
{
    if (self.isClosed) self.isClosed = NO;
    else self.isClosed = YES;
}

@end


@interface PlayingController ()

- (void)generateNewLevel;
- (BOOL)hasGameFinished;
- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer;
- (void)toggleValvesAtRow:(int)row andColumn:(int)column;

@end

@implementation PlayingController

#pragma mark - Lifecycle Methods
- (void)viewDidLoad
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tapRecognizer];
    
    NSString *fieldSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"fieldSize"];
    if (fieldSize == nil) {
        fieldSize = @"4x4";
    }
    NSScanner *scanner = [NSScanner scannerWithString:fieldSize];
    [scanner scanInteger:&_sideSize];
    
    _arrayWithValves = [NSMutableArray new];
    CGFloat sideBorder      = self.view.layer.bounds.size.width * SIDE_BORDER;
    CGFloat topBorder       = self.view.layer.bounds.size.width * TOP_BORDER;
    CGFloat valveSize       = self.view.layer.bounds.size.width * VALVE_SIZE;
    CGFloat valveInterval   = (self.view.layer.bounds.size.width - 2*sideBorder - _sideSize*valveSize) / (_sideSize - 1);
    CGFloat columnInterval  = valveInterval + valveSize;
    CGFloat rowInterval     = columnInterval;
    UIImage *image = [UIImage imageNamed:@"valve.png"];
    for (int i = 0; i < _sideSize; i++) {
        for (int j = 0; j < _sideSize; j++) {
            CALayer *valve = [CALayer layer];
            [valve setIsClosed:NO];
            [valve setContents:(id)image.CGImage];
            valve.row = i;
            valve.column = j;
            [valve setFrame:CGRectMake(sideBorder + j*columnInterval, topBorder + i*rowInterval, valveSize, valveSize)];
            [self.view.layer addSublayer:valve];
            [_arrayWithValves addObject:valve];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self generateNewLevel];
}

- (void)dealloc
{
    _arrayWithValves = nil;
}

#pragma mark - Private Methods

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint tappedPoint = [gestureRecognizer locationInView:self.view];
        for (CALayer *valve in _arrayWithValves) {
            if (CGRectContainsPoint(valve.frame, tappedPoint)) {
                [self toggleValvesAtRow:valve.row andColumn:valve.column];
                break;
            }
        }
    }
}

- (void)toggleValvesAtRow:(int)row andColumn:(int)column
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if ([self hasGameFinished]) {
            [self backToMainMenu];
        }
    }];
    
    for (CALayer *valve in _arrayWithValves) {
        if (valve.row == row || valve.column == column) {
            CABasicAnimation *rotate = [valve getRotationAnimation];
            [valve addAnimation:rotate forKey:@"transform.rotation"];
            [valve toggleIsClosed];
        }
    }
    [CATransaction commit];
}

- (BOOL)hasGameFinished
{
    for (CALayer *valve in _arrayWithValves) {
        if (valve.isClosed) return NO;
    }
    return YES;
}

- (void)generateNewLevel
{
    [self.view setUserInteractionEnabled:NO];
    for (int i = 0; i < STARTING_RAND_MOVES; i++) {
        int randRow = arc4random() % _sideSize;
        int randColumn = arc4random() % _sideSize;
        
        [self toggleValvesAtRow:randRow andColumn:randColumn];
    }
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark - Public Methods
#pragma mark Actions

- (IBAction)backToMainMenu
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //here i should highlight touched calayer
//    NSArray *touchesArray = [touches allObjects];
//    for (int i = 0; i < [touchesArray count]; i++) {
//        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:i];
//        CGPoint point = [touch locationInView:self.view];
//        NSLog(@"touchesBegan x = %f, y = %f", point.x, point.y);
//    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //here i should deselect calayer
}

@end
