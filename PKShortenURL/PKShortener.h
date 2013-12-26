//
//  PKShortener.h
//  PKShortenURL
//
//  Created by spraveenk91 on 12/26/13.
//  Copyright (c) 2013 spraveenk91. All rights reserved.
//

#import <Foundation/Foundation.h>

// Custom Delegate inspired by - http://stackoverflow.com/a/1218098/940096
@protocol PKShortenerDelegate <NSObject>

@required
-(void)shortenerResult:(NSString *)result;

@end

@interface PKShortener : NSObject

-(void)setURL:(NSString *)stringURL;

@property (nonatomic)id<PKShortenerDelegate> delegate;

@end
