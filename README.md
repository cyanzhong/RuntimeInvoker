# RuntimeInvoker
![Language](https://img.shields.io/badge/language-objc-orange.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

Invoke any selector with name from an Objective-C Object

🇨🇳[中文介绍](https://github.com/cyanzhong/RuntimeInvoker/blob/master/README_CN.md)

# Purpose
Invoke a selector with name, for some trick or private method debugging

# Usage

# 1. Build & Run Demo
# 2. Check ViewController.m
```objc
# import "ViewController.h"
# import "RuntimeInvoker.h"

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
}

@end
```
