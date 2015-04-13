//
//  Code.h
//  GithubSearch
//
//  Created by Victor  Adu on 4/12/15.
//  Copyright (c) 2015 Victor  Adu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Code : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *html_url;


-(instancetype)initFromDictionary:(NSDictionary *)responseDict;

@end
