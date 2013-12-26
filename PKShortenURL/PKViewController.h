//
//  PKViewController.h
//  PKShortenURL
//
//  Created by spraveenk91 on 12/26/13.
//  Copyright (c) 2013 spraveenk91. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKShortener.h"

@interface PKViewController : UIViewController <UITextFieldDelegate, PKShortenerDelegate>

-(IBAction)copyIT:(id)sender;
-(IBAction)shortIT:(id)sender;

@end
