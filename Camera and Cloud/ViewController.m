//
//  ViewController.m
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/30/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.tabBar1 = (ViewController*)[sb instantiateViewControllerWithIdentifier:@"tabBar"];
    UITabBar *tabBar = self.tabBar1.tabBar;
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"photo_01@3x.jpg"] selectedImage:[UIImage imageNamed:@"photo_02@3x.jpg"]];
    UITabBarItem *tabBarItem2 =  [[UITabBarItem alloc]initWithTitle:@"Camera" image:[UIImage imageNamed:@"inactivecamera.pdf"] selectedImage:[UIImage imageNamed:@"activecamera.pdf"]];
    tabBarItem1 = [tabBar.items objectAtIndex:0];
    tabBarItem2 = [tabBar.items objectAtIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
