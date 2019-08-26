//
//  PKViewController.m
//  PKShortenURL
//
//  Created by spraveenk91 on 12/26/13.
//  Copyright (c) 2013 spraveenk91. All rights reserved.
//

#import "PKViewController.h"

@interface PKViewController ()

@end

@implementation PKViewController {
    NSString *_resultString;
}

#pragma mark - Actions
/**
 * This method will validate given URL is a valid one with Regex
 * @return Returns a Boolean value whether TRUE or FALSE
 * @param Parameter urlString will have the actual URL String
 */
- (BOOL)validateUrl:(NSString *)urlString {
    NSString *urlRegEx =
    @"((http|https)://(\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:urlString];
}

/**
 * IBAction for copying the generated shorten URL.
 * @param sender will hold the reference of the IBAction
 */
-(IBAction)copyIT:(id)sender {
    
    if ([_resultString length] == 0 || ![_resultString length]) {
        PKShortener *shortner = [PKShortener sharedInstance];
        [shortner showAlertController:nil message:@"Empty result cannot be copied" buttonTitle:@"Okay :("];
    } else {
        [UIPasteboard generalPasteboard].URL = [NSURL URLWithString:_resultString];
    }
}

/**
 * IBAction for generating shorten URL.
 * @param sender will hold the reference of the IBAction
 */
-(IBAction)shortIT:(id)sender {
    
    [self.textField resignFirstResponder];
    if ([[self.textField text] length] == 0 || [self.textField text] == nil) {
        [[PKShortener sharedInstance] showAlertController:nil message:@"Empty URL cannot shorten" buttonTitle:@"Understood!"];
    } else {
        if (![self validateUrl:[self.textField text]]) {
            [[PKShortener sharedInstance] showAlertController:nil message:@"Invalid URL" buttonTitle:@"Understood!"];
        } else {
            PKShortener *shortner = [PKShortener sharedInstance];
            [shortner setURL:self.textField.text];
            shortner.delegate = self;
        }
    }
}

#pragma mark - PKShortner Delegate
/**
 * This method will append the shorten URL to the textView
 * @param result will contain the shortel URL
 */
-(void)shortenerResult:(NSString *)result
{
    _resultString = result;
    self.textView.text = _resultString;
    NSLog(@"Result - %@", result);
}

#pragma mark - UIView Touches
/*
 * This method will helps to dismiss the Keyboard by tapping on view
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
