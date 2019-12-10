//
//  PKShortener.h
//  PKShortenURL
//
//  Created by spraveenk91 on 12/26/13.
//  Copyright (c) 2013 spraveenk91. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

// Custom Delegate inspired by - http://stackoverflow.com/a/1218098/940096
@protocol PKShortenerDelegate <NSObject>

@required
-(void)shortenerResult:(NSString *)result;

@end

@interface PKShortener : NSObject <MBProgressHUDDelegate>

/**
 * A Shared instance for PKShortner class.
 *
 * @returns Instance of PKShortner class.
 */
+ (instancetype)sharedInstance;

/**
 * A method to assign the string URL value. This method will convert the NSString object to NSURL Object.
 *
 * @param stringURL a NSString object which holds the URL string to shorten it.
 */
-(void)setURL:(NSString *)stringURL;

/** A PKShortenerDelegate object */
@property (nonatomic)id<PKShortenerDelegate> delegate;

/**
 * A common method to show AlertController in overall application.
 * @param title will holds the Title to display in the alert.
 * @param message will hold the message value to display in the alert.
 * @param buttonTitle will show what exactly the string has to display for the button.
 */
- (void)showAlertController:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;

@end
