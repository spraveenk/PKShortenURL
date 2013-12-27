//
//  PKShortener.m
//  PKShortenURL
//
//  Created by spraveenk91 on 12/26/13.
//  Copyright (c) 2013 spraveenk91. All rights reserved.
//

#import "PKShortener.h"

@implementation PKShortener {
    
    NSURLConnection *_connection;
    NSMutableData *_mutableData;
    NSString *_resultString;
    MBProgressHUD *HUD;
    
    long long expectedLength;
    long long currentLength;
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark - Actions
-(void)setURL:(NSString *)stringURL
{
    HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HUD.delegate = self;
    
    _connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%@", Shorten_URL, stringURL]]] delegate:self];
    
    _mutableData = [[NSMutableData alloc] init];
    [_connection start];
}

#pragma mark - NSURLConnection Actions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_mutableData setLength:0]; currentLength = 0;
    HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableData appendData:data];
    
    HUD.progress = currentLength / (float)expectedLength;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[[UIAlertView alloc] initWithTitle:@"Message" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
    
    _resultString = [[NSString alloc] initWithData:_mutableData encoding:NSUTF8StringEncoding];
    
    if ([_resultString length] == 0 || _resultString == nil) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Nothing returns!!" delegate:nil cancelButtonTitle:@"Yeah i can see :(" otherButtonTitles:nil, nil] show];
    } else {
        
        if ([[self delegate] respondsToSelector:@selector(shortenerResult:)]) {
            [[self delegate] shortenerResult:_resultString];
        }
    }
}

@end
