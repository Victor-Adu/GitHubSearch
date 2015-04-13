//
//  NetworkController.h
//  GithubSearch
//
//  Created by Victor  Adu on 4/12/15.
//  Copyright (c) 2015 Victor  Adu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repository.h"

@protocol NetworkControllerDelegate <NSObject>

@optional
-(void)reposFinishedParsing:(NSArray *)jsonArray;
-(void)followersFinishedParsing:(NSArray *)jsonArray;

@end

@interface NetworkController : NSObject

+(void)downloadSearchResults:(NSString *)searchterm forScope:(NSString *)scope withCompletion:(void(^)(NSArray *repositories, NSString *errorDescription))completionHandler;


@property (nonatomic, weak) id<NetworkControllerDelegate> delegate;

@end
