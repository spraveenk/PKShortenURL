//
//  PKShortener.m
//  PKShortenURL
//
//  Created by spraveenk91 on 12/26/13.
//  Copyright (c) 2013 spraveenk91. All rights reserved.
//

#import "PKShortener.h"
#import "PKAppDelegate.h"

@interface PKShortener ()

@end

@implementation PKShortener {
    
    NSString *_resultString;
}

#pragma mark - Shared Instance
+ (instancetype)sharedInstance {
    static PKShortener *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PKShortener alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Actions
/**
 * Assigning the URL which needs to be shorten.
 * @param stringURL will hold the actual url string.
 */
-(void)setURL:(NSString *)stringURL
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%@", Shorten_URL, stringURL]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [self parseResponseWithError:error responseData:data];
        
    }] resume];
}

#pragma mark - Custom Methods
- (void)parseResponseWithError:(NSError *)error responseData:(NSData *)data {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    if (error) {
        [self showAlertController:@"Error" message:[error localizedDescription] buttonTitle:@"Yeah, understood!"];
    } else {
        _resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if ([_resultString length] == 0 || _resultString == nil) {
            [self showAlertController:nil message:@"Nothing returns!!" buttonTitle:@"Okay"];
        } else {
            
            if ([[self delegate] respondsToSelector:@selector(shortenerResult:)]) {
                [[self delegate] shortenerResult:_resultString];
            }
        }
    }
}


#pragma mark - UIAlertController Common method

- (void)showAlertController:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:buttonTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    
    UIViewController *rootViewController = [[(PKAppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
