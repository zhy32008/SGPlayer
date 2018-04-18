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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9 + self.testVideoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row < 9) {
       cell.textLabel.text = [PlayerViewController displayNameForDemoType:indexPath.row];
    } else {
       cell.textLabel.text =   [self.testVideoList objectAtIndex:indexPath.row - 9];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewController * obj = [[PlayerViewController alloc] init];
    if (indexPath.row < 9) {
        obj.demoType = indexPath.row;
    } else {
        obj.demoType = DemoType_Default_FFmpeg;
        obj.filename = [self.testVideoList objectAtIndex:indexPath.row - 9];
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

@end
