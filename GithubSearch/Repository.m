//
//  Repository.m
//  GithubSearch
//
//  Created by Victor  Adu on 4/12/15.
//  Copyright (c) 2015 Victor  Adu. All rights reserved.
//

#import "Repository.h"

@implementation Repository

-(instancetype)initFromDictionary:(NSDictionary *)responseDict {
    
    self = [super init];
    
    if (self) {
        //        self.name = [responseDict objectForKey:@"name"];
        self.html_url = [responseDict objectForKey:@"html_url"];
        self.repoID = [responseDict objectForKey:@"id"];
        self.full_name = [responseDict objectForKey:@"full_name"];
        self.language = [responseDict objectForKey:@"language"];
        if ([self.language isEqual:[NSNull null]]) {
            self.language = @"Language not found";
        }
    }
    return self;
    
}


@end
