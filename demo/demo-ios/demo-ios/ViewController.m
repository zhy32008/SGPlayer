//
//  ViewController.m
//  demo-ios
//
//  Created by Single on 2017/3/15.
//  Copyright © 2017年 single. All rights reserved.
//

#import "ViewController.h"
#import "PlayerViewController.h"

@interface ViewController()

@property(nonatomic, strong) NSArray *testVideoList;
@property(nonatomic, strong) NSArray *testWebVideoList;

@end

@implementation ViewController

- (NSArray *)testVideoList {
    
    if (!_testVideoList) {
        NSString * resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"testvideo"];
        NSError * error;
        _testVideoList =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:&error];
    }
    return _testVideoList;
}

-(void)viewDidLoad {
   
    [self.tableView reloadData];
    [self fetchFromNetwork];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9 + self.testVideoList.count + self.testWebVideoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row < 9) {
       cell.textLabel.text = [PlayerViewController displayNameForDemoType:indexPath.row];
    } else if (indexPath.row >=9 && indexPath.row < (self.testVideoList.count + 9)) {
       cell.textLabel.text =   [self.testVideoList objectAtIndex:indexPath.row - 9];
    } else {
        cell.textLabel.text = [self.testWebVideoList objectAtIndex:indexPath.row - 9 - self.testVideoList.count];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewController * obj = [[PlayerViewController alloc] init];
    if (indexPath.row < 9) {
        obj.demoType = indexPath.row;
    } else if (indexPath.row >=9 && indexPath.row < (self.testVideoList.count + 9)) {
        obj.demoType = DemoType_Default_FFmpeg;
        obj.filename = [self.testVideoList objectAtIndex:indexPath.row - 9];
    } else {
        obj.demoType = DemoType_Default_FFmpeg_url;
        obj.filename = [self.testWebVideoList objectAtIndex:indexPath.row - 9 - self.testVideoList.count];
    }
    
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - fetch from network

-(void)fetchFromNetwork {
    
    NSURLSession *session = [NSURLSession sharedSession];
   NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://api.mobilezhao.com/file/filelist"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *errorjson;
            self.testWebVideoList =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorjson];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@",error);
        }
        
    }];
    [task resume];
}

@end
