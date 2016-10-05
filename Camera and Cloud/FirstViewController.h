//
//  FirstViewController.h
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/27/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>
#import <AFNetworking.h>

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *testDownloadImageView;
@property (nonatomic, strong) NSMutableDictionary *firebaseGETData;
@property (nonatomic, strong) NSMutableArray *JSONArray;
@end

