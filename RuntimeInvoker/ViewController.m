//
//  ViewController.m
//  RuntimeInvoker
//
//  Created by cyan on 16/5/27.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ViewController.h"
#import "RuntimeInvoker.h"

#pragma mark - Super Test Helper

@interface Father : NSObject

@end

@implementation Father

+ (NSString *)classSample:(NSString *)content {
    return [NSString stringWithFormat:@"%@ From Father Class", content];
}

- (NSString *)instanceSample:(NSString *)content {
    return [NSString stringWithFormat:@"%@ From Father Instance", content];
}

@end

@interface Child : Father

@end

@implementation Child

+ (NSString *)classSample:(NSString *)content {
    return [NSString stringWithFormat:@"%@ From Child Class", content];
}

- (NSString *)instanceSample:(NSString *)content {
    return [NSString stringWithFormat:@"%@ From Child Instance", content];
}

@end

/**********/

@implementation ViewController

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
    
    // test super
    Child *child = [Child new];
    NSLog(@"super class test: %@", [child.class invokeSuper:@"classSample:" arguments:@[@"haha"]]);
    NSLog(@"super instance test: %@", [child invokeSuper:@"instanceSample:" arguments:@[@"haha"]]);
}

@end
