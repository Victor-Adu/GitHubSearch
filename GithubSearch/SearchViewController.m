//
//  SearchViewController.m
//  GithubSearch
//
//  Created by Victor  Adu on 4/12/15.
//  Copyright (c) 2015 Victor  Adu. All rights reserved.
//

#import "SearchViewController.h"
#import "NetworkController.h"
#import "Repository.h"
#import "Code.h"
#import "User.h"
#import "UserCollectionViewCell.h"
#import "WebViewViewController.h"

@interface SearchViewController () <UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *repositories;
@property (strong, nonatomic) NSArray *users;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSOperationQueue *imageQueue;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.imageQueue = [[NSOperationQueue alloc]init];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    
    if (self.users) {
        self.collectionView.hidden = false;
        self.tableView.hidden = true;
    } else {
        self.tableView.hidden = false;
        self.collectionView.hidden = true;
    }
}

-(void)fetchUserImages:(NSString *)avatar_url withCompletion:(void (^)(UIImage *avatarImage))completion {
    
    [self.imageQueue addOperationWithBlock:^{
        NSURL *avatarURL = [NSURL URLWithString:avatar_url];
        NSData *data = [NSData dataWithContentsOfURL:avatarURL];
        UIImage *avatarImage = [UIImage imageWithData:data];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            completion(avatarImage);
        }];
    }];
    
}

#pragma mark Table View Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repositories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search" forIndexPath:indexPath];
    
    
    
    if (self.searchBar.selectedScopeButtonIndex == 0) {
        Repository *result = self.repositories[indexPath.row];
        if (result) {
            cell.textLabel.text = result.full_name;
            cell.textLabel.adjustsFontSizeToFitWidth = true;
            cell.detailTextLabel.text = result.language;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = true;
        } else {
            cell.textLabel.text = @"Nothing Found";
        }
    }
    return cell;
}

#pragma mark Collection View Data Source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"users" forIndexPath:indexPath];
    
    
    //Tagging for loading cells individually (see kirby's). If image == nil...
    if (self.searchBar.selectedScopeButtonIndex == 1) {
        User *user = self.users[indexPath.row];
        
        NSInteger currentTag = cell.tag + 1;
        cell.tag = currentTag;
        
        if (user.avatarImage == nil) {
            [self fetchUserImages:user.avatar_url withCompletion:^(UIImage *avatarImage) {
                if (cell.tag == currentTag) {
                    cell.avatarImageView.image = avatarImage;
                    user.avatarImage = avatarImage;
                }
                [self.activityIndicator stopAnimating];
            }];
        } else {
            cell.avatarImageView.image = user.avatarImage;
        }
        cell.nameLabel.text = user.login;
        cell.nameLabel.adjustsFontSizeToFitWidth = true;
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.users.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"webView" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    WebViewViewController *webViewVC = segue.destinationViewController;
    
    NSIndexPath *indexPath = sender;
    User *user = self.users[indexPath.row];
    webViewVC.html_url = user.html_url;
    
}

#pragma mark Search Bar Delegate Methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = searchBar.text;
    [searchBar resignFirstResponder];
    self.tableView.hidden = true;
    self.collectionView.hidden = true;
    
    if (searchBar.selectedScopeButtonIndex == 0) {
        NSString *repositories = @"repositories";
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        self.activityIndicator.center = self.collectionView.center;
        [self.activityIndicator startAnimating];
        [self.view addSubview:self.activityIndicator];
        
        [NetworkController downloadSearchResults:searchTerm forScope:repositories withCompletion:^(NSArray *repositories, NSString *errorDescription) {
            _repositories = repositories;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Reloading Table");
                [self.activityIndicator stopAnimating];
                
                self.tableView.hidden = false;
                [self.tableView reloadData];
            }];
        }];
    }
    //    else if (searchBar.selectedScopeButtonIndex == 1) {
    //        NSString *code = @"code";
    //        [NetworkController downloadSearchResults:searchTerm forScope:code withCompletion:^(NSArray *code, NSString *errorDescription) {
    //            _results = code;
    //            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //                NSLog(@"Reloading Table");
    //                [self.tableView reloadData];
    //                self.tableView.hidden = false;
    //            }];
    //        }];
    //    }
    else {
        self.collectionView.hidden = false;
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.center = self.collectionView.center;
        [self.activityIndicator startAnimating];
        [self.view addSubview:self.activityIndicator];
        
        NSString *users = @"users";
        [NetworkController downloadSearchResults:searchTerm forScope:users withCompletion:^(NSArray *users, NSString *errorDescription) {
            _users = users;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Reloading Table");
                [self.collectionView reloadData];
            }];
        }];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
