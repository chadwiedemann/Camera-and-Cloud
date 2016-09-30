//
//  FirstViewController.m
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/27/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self sendHTTPPost];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma methods to create JSON data
-(NSArray*)createArrayToConvertToJSON
{
    NSDictionary *photo1 = @{@"PhotoID":@1,@"TimeStamp":@1,@"FileReference":@"testForAF",@"FileType":@"jpg",@"Comments":@[@"great Pic"],@"Likes":@[@"user1like"]};
    NSArray *metaData = @[photo1];
    return metaData;
    
}

-(void)sendHTTPPost
{

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self createArrayToConvertToJSON] options:NSJSONWritingPrettyPrinted error:&error];
    
    //normal request
//    NSURL *url = [NSURL URLWithString:@"https://camera-and-cloud-22204.firebaseio.com/images.json"];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = jsonData;
//    request.URL = url;
//    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"success");
//        NSLog(@"%@",error.localizedDescription);
//    }];
//    [dataTask resume];
    
    
    
    //request from AFNetworking
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://camera-and-cloud-22204.firebaseio.com/images.json"];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc]initWithURL:URL];
    request2.HTTPBody = jsonData;
    request2.HTTPMethod = @"POST";
    request2.URL = URL;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request2 fromFile:URL progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            NSLog(@"%@",error.localizedDescription);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}

-(void)sendLocalFileToFireBase
{
   
        FIRStorage *storage = [FIRStorage storage];
        FIRStorageReference *storageRef = [storage referenceForURL:@"gs://camera-and-cloud-22204.appspot.com"];
        UIImage *image = [UIImage imageNamed:@"photo_02@3x.jpg"];
        NSData *data = UIImageJPEGRepresentation(image, .9);
        FIRStorageReference *imagesDirectory = [storageRef child:@"images/photo_02@3x.jpg"];
        FIRStorageUploadTask *uploadTask = [imagesDirectory putData:data metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
            if (error != nil) {
                NSLog(@"%@",error.localizedDescription);
            } else {
                NSURL *downloadURL = metadata.downloadURL;
                NSLog(@"%@",downloadURL);
                NSLog(@"SUSSESS");
            }
        }];

}

@end
