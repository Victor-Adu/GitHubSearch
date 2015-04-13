//
//  Repository.h
//  GithubSearch
//
//  Created by Victor  Adu on 4/12/15.
//  Copyright (c) 2015 Victor  Adu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

//@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *html_url;
@property (strong, nonatomic) NSNumber *repoID;
@property (strong, nonatomic) NSString *full_name;
@property (strong, nonatomic) NSString *language;

-(instancetype)initFromDictionary:(NSDictionary *)responseDict;

@end
