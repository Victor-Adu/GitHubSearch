//
//  Code.m
//  GithubSearch
//
//  Created by Victor  Adu on 4/12/15.
//  Copyright (c) 2015 Victor  Adu. All rights reserved.
//

#import "Code.h"

@implementation Code

-(instancetype)initFromDictionary:(NSDictionary *)responseDict {
    self = [super init];
    
    if (self) {
        self.name = [responseDict objectForKey:@"name"];
        self.html_url = [responseDict objectForKey:@"html_url"];
    }
    return self;
}

@end
