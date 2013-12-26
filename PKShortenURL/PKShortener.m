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
}

#pragma mark - Actions
-(void)setURL:(NSString *)stringURL
{
    _connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%@", Shorten_URL, stringURL]]] delegate:self];
    
    _mutableData = [[NSMutableData alloc] init];
    [_connection start];
}

#pragma mark - NSURLConnection Actions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_mutableData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Message" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
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
