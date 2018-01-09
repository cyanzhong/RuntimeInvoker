//
//  ViewController.m
//  RuntimeInvoker
//
//  Created by cyan on 16/5/27.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ViewController.h"
#import "RuntimeInvoker.h"

@interface ExampleItem : NSObject

@property (nonatomic, assign, readonly) SEL actionSelector;
@property (nonatomic, weak, readonly) id actionTarget;
- (instancetype)initWithTarget:(id)target action:(SEL)actionSelector;

@end

@implementation ViewController {
    NSMutableArray<ExampleItem *> *_items;
}

- (CGRect)aRect {
    return CGRectMake(0, 0, 100, 100);
}

+ (UIEdgeInsets)aInsets {
    return UIEdgeInsetsMake(0, 0, 100, 100);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // public selector
    CGRect rect = [[self invoke:@"aRect"] CGRectValue];
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    // public selector with argument
    [self.view invoke:@"setBackgroundColor:" arguments:@[ [UIColor whiteColor] ]];
    [self.view invoke:@"setAlpha:" arguments:@[ @(0.5) ]];
    [UIView animateWithDuration:3 animations:^{
        [self.view invoke:@"setAlpha:" arguments:@[ @(1.0) ]];
    }];
    
    // private selector
    int sizeClass = [[self invoke:@"_verticalSizeClass"] intValue];
    NSLog(@"sizeClass: %d", sizeClass);
    
    // private selector with argument
    [self invoke:@"_setShowingLinkPreview:" args:@(NO), nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self invoke:@"_setShowingLinkPreview:" args:@(YES), nil];
    });
    
    // class method selector
    UIEdgeInsets insets = [[self.class invoke:@"aInsets"] UIEdgeInsetsValue];
    NSLog(@"insets: %@", NSStringFromUIEdgeInsets(insets));
    
    // class method selector with argument
    UIColor *color = [UIColor invoke:@"colorWithRed:green:blue:alpha:"
                                args:@(0), @(0.5), @(1), nil];
    NSLog(@"color: %@", color);
    
    [self variableParameterExample];
}

/// Flexible use of variable parameters.
- (void)variableParameterExample {
    _items = @[].mutableCopy;
    ExampleItem *item0 = [[ExampleItem alloc] initWithTarget:self action:@selector(actionTest)];
    ExampleItem *item1 = [[ExampleItem alloc] initWithTarget:self action:@selector(actionTestWithArg1:)];
    ExampleItem *item2 = [[ExampleItem alloc] initWithTarget:self action:@selector(actionTestWithArg1:arg2:)];
    ExampleItem *item3 = [[ExampleItem alloc] initWithTarget:self action:@selector(actionTestWithArg1:arg2:arg3:)];
    [_items addObject:item0];
    [_items addObject:item1];
    [_items addObject:item2];
    [_items addObject:item3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_items enumerateObjectsUsingBlock:^(ExampleItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            [item.actionTarget invoke:NSStringFromSelector(item.actionSelector) args:@"index", item, self, @"superfluous parameters", nil];
        }];
    });
}

- (void)actionTest {
    NSLog(@"%s", __FUNCTION__);
}

- (void)actionTestWithArg1:(id)arg1 {
    NSLog(@"%@__%s", arg1, __FUNCTION__);
}

- (void)actionTestWithArg1:(id)arg1 arg2:(id)arg2 {
    NSLog(@"%@__%@__%s", arg1, arg2, __FUNCTION__);
}

- (void)actionTestWithArg1:(id)arg1 arg2:(id)arg2 arg3:(id)arg3 {
    NSLog(@"%@__%@__%@__%s", arg1, arg2, arg3, __FUNCTION__);
}




@end

@implementation ExampleItem
{
    SEL _actionSelector;
    __weak id _actionTarget;
}

@synthesize actionSelector = _actionSelector, actionTarget = _actionTarget;

- (instancetype)initWithTarget:(id)target action:(SEL)actionSelector {
    if (self = [super init]) {
        _actionTarget = target;
        _actionSelector = actionSelector;
    }
    return self;
}

@end
