//
//  PKShortener.m
//  PKShortenURL
//
//  Created by spraveenk91 on 12/26/13.
//  Copyright (c) 2013 spraveenk91. All rights reserved.
//

#import "PKShortener.h"

@interface PKShortener () <NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@implementation PKShortener {
    
    NSString *_resultString;
    MBProgressHUD *HUD;
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidden
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark - Actions
-(void)setURL:(NSString *)stringURL
{
    HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%@", Shorten_URL, stringURL]]];
    
    [task resume];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    [HUD hide:YES];
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil] show];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
    
    _resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([_resultString length] == 0 || _resultString == nil) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Nothing returns!!" delegate:nil cancelButtonTitle:@"Yeah i can see :(" otherButtonTitles:nil, nil] show];
    } else {
        
        if ([[self delegate] respondsToSelector:@selector(shortenerResult:)]) {
            [[self delegate] shortenerResult:_resultString];
        }
    }
}

@end
