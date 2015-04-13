//
//  User.h
//  GithubSearch
//
//  Created by Victor  Adu on 4/12/15.
//  Copyright (c) 2015 Victor  Adu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *avatar_url;
@property (strong, nonatomic) NSString *html_url;
@property (strong, nonatomic) NSString *followers_url;
@property (strong, nonatomic) NSString *login;
@property (nonatomic) UIImage *avatarImage;

-(instancetype)initFromDictionary:(NSDictionary *)responseDict;


@end
