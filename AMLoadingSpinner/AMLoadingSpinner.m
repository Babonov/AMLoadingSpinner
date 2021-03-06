//
//  AMLoadingSpinner.m
//  RedWhite
//
//  Created by Artem Mihaylov on 02.08.17.
//  Copyright © 2017 Mihaylov Artem. All rights reserved.
//

#import "AMLoadingSpinner.h"

@interface AMLoadingSpinner ()

@property (strong, nonatomic) NSArray *imagesArray;
@property (strong, nonatomic) UIImageView *foregroundImageView;
@property (strong, nonatomic) UIView *backgroundView;
@property (nonatomic) AMLoadingSpinnerBackgroundType maskType;
@property (nonatomic) BOOL isShowing;

@end

@implementation AMLoadingSpinner

#pragma mark - Init

+(AMLoadingSpinner *) sharedManager {
    static AMLoadingSpinner *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        [sharedInstance setFrame:[UIScreen mainScreen].bounds];
        sharedInstance.imagesArray = [[NSArray alloc] init];
        sharedInstance.backgroundView = [[UIView alloc] initWithFrame:sharedInstance.bounds];
        [sharedInstance addSubview:sharedInstance.backgroundView];
        
        sharedInstance.foregroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - [self defaultForegroundImageViewSize].width) / 2,
                                                                                           (screenSize.height - [self defaultForegroundImageViewSize].height) / 2,
                                                                                           [self defaultForegroundImageViewSize].width,
                                                                                           [self defaultForegroundImageViewSize].height)];
        sharedInstance.foregroundImageView.animationDuration = [self defaultAnimationDuration];
        [sharedInstance addSubview:sharedInstance.foregroundImageView];
        
        sharedInstance.isShowing = NO;
        sharedInstance.maskType = AMLoadingSpinnerBackgroundTypeClear;
    });
    return sharedInstance;
}

#pragma mark - Getters

+(BOOL) isSpinnerShowing {
    return [[AMLoadingSpinner sharedManager] isShowing];
}

#pragma mark - Singleton (Full screen spinner)

#pragma mark - Default values

+(CGSize)defaultBackgroundViewSize {
    return CGSizeMake(200, 200);
}

+(CGSize)defaultForegroundImageViewSize {
    return CGSizeMake(100, 100);
}

+(UIColor *)defaultBackgroundViewColor {
    return [UIColor colorWithWhite:1.0 alpha:0.7];
}

+(CGFloat)defaultBackgroundViewCornerRadius {
    return 10.0;
}

+(CGFloat)defaultAnimationDuration {
    return 5.0;
}

#pragma mark - Foreground configuration

+(void)setAnimationImages:(NSArray<UIImage *> *)images {
    if (!images) {
        NSLog(@"Error! Animation images array is nil");
        return;
    }
    
    if (!images.count) {
        NSLog(@"Error! Animation images array is empty");
        return;
    }
    [AMLoadingSpinner sharedManager].imagesArray = images;
}

+(void)setAnimationDuration:(NSTimeInterval)duration {
    if (duration == 0) {
        NSLog(@"Warning! Animation duration is 0");
    }
    [[AMLoadingSpinner sharedManager].foregroundImageView setAnimationDuration:duration];
}

+(void)setForegroundImageViewSize:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        NSLog(@"Warning! foreground image view size is zero");
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [[AMLoadingSpinner sharedManager].foregroundImageView setFrame:CGRectMake((screenSize.width - size.width) / 2,
                                                                       (screenSize.height - size.height) / 2,
                                                                       size.width,
                                                                       size.height)];
}

#pragma mark - Background customization

+(void)setBackgroundType:(AMLoadingSpinnerBackgroundType)type {
    [[[AMLoadingSpinner sharedManager].backgroundView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (type) {
        case AMLoadingSpinnerBackgroundTypeClear: {
            [[AMLoadingSpinner sharedManager].backgroundView setFrame:CGRectZero];
            break;
        }
        case AMLoadingSpinnerBackgroundTypeCustomView: {
            [[AMLoadingSpinner sharedManager].backgroundView setFrame:[UIScreen mainScreen].bounds];
            [[AMLoadingSpinner sharedManager].backgroundView setBackgroundColor:UIColor.clearColor];
            [[AMLoadingSpinner sharedManager].backgroundView.layer setCornerRadius:0];
            break;
        }
        case AMLoadingSpinnerBackgroundTypeFullScreen: {
            [[AMLoadingSpinner sharedManager].backgroundView setFrame:[UIScreen mainScreen].bounds];
            [[AMLoadingSpinner sharedManager].backgroundView setBackgroundColor:[self defaultBackgroundViewColor]];
            [[AMLoadingSpinner sharedManager].backgroundView.layer setCornerRadius:0];
            break;
        }
        case AMLoadingSpinnerBackgroundTypeDefaultView: {
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            [[AMLoadingSpinner sharedManager].backgroundView setFrame:CGRectMake((screenSize.width - [self defaultBackgroundViewSize].width) / 2,
                                                                          (screenSize.height - [self defaultBackgroundViewSize].height) / 2,
                                                                          [self defaultBackgroundViewSize].width,
                                                                          [self defaultBackgroundViewSize].height)];
            [[AMLoadingSpinner sharedManager].backgroundView setBackgroundColor:[self defaultBackgroundViewColor]];
            [[AMLoadingSpinner sharedManager].backgroundView.layer setCornerRadius:[self defaultBackgroundViewCornerRadius]];
            break;
        }
        default:
            break;
    }
}

#pragma mark Custom view

+(void)setBackgroundView:(UIView *)view {
    [[[AMLoadingSpinner sharedManager].backgroundView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!view) {
        NSLog(@"Error! Can't set nil background view");
        return;
    }
    
    if (CGRectEqualToRect(view.bounds, CGRectZero)) {
        NSLog(@"Warning! Background view has zero size");
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [view setFrame:CGRectMake((screenSize.width - view.bounds.size.width) / 2,
                              (screenSize.height - view.bounds.size.height) / 2,
                              view.bounds.size.width,
                              view.bounds.size.height)];
}

#pragma mark Default view

+(void)setBackgroundViewColor:(UIColor *)color {
    [[AMLoadingSpinner sharedManager].backgroundView setBackgroundColor:color];
}

+(void)setBackgroundViewCornerRadius:(CGFloat)radius {
    [[AMLoadingSpinner sharedManager].backgroundView.layer setCornerRadius:radius];
}

+(void)setBackgroundViewSize:(CGSize)size {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [[AMLoadingSpinner sharedManager].backgroundView setFrame:CGRectMake((screenSize.width - size.width) / 2,
                                                                  (screenSize.height - size.height) / 2,
                                                                  size.width,
                                                                  size.height)];
}

#pragma mark - Actions

+(void)setIsShowing:(BOOL)isShowing {
    [AMLoadingSpinner sharedManager].isShowing = isShowing;
    if (isShowing) {
        if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:[AMLoadingSpinner sharedManager]]) {
            [[UIApplication sharedApplication].keyWindow addSubview:[AMLoadingSpinner sharedManager]];
        }
    } else {
        if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:[AMLoadingSpinner sharedManager]]) {
            [[AMLoadingSpinner sharedManager] removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:AMLoadingSpinnerDismissedNotification object:nil];
        }
    }
}

+(void)show {
    if ([AMLoadingSpinner sharedManager].isShowing) {
        return;
    }
    [AMLoadingSpinner setIsShowing:YES];
    [[AMLoadingSpinner sharedManager].foregroundImageView setAnimationImages:[AMLoadingSpinner sharedManager].imagesArray];
    [[AMLoadingSpinner sharedManager].foregroundImageView startAnimating];
}

+(void) showProgress:(CGFloat)progress {
    if (progress > 1.0) {
        NSLog(@"Error! Progress cannot be more than 1.0");
        return;
    }
    if (progress < 0.0) {
        NSLog(@"Error! Progress cannot be less than 0.0");
        return;
    }
    if (![AMLoadingSpinner sharedManager].isShowing) {
        [AMLoadingSpinner setIsShowing:YES];
    }
    NSArray *images = [AMLoadingSpinner sharedManager].imagesArray;
//    NSLog(@"%f", truncf(progress*images.count));
    [[AMLoadingSpinner sharedManager].foregroundImageView setImage:[images objectAtIndex:truncf(progress*images.count)]];
}

+(void)dismiss {
    if (![AMLoadingSpinner sharedManager].isShowing) {
        return;
    }
    [[AMLoadingSpinner sharedManager].foregroundImageView stopAnimating];
    [AMLoadingSpinner setIsShowing:NO];
}

+(void)dismissWithDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AMLoadingSpinner dismiss];
    });
}

@end
