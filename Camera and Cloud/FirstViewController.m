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
   
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://camera-and-cloud-22204.appspot.com"];
    
    
    
    
    // Data in memory
    UIImage *image = [UIImage imageNamed:@"photo_01@3x.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, .9);
    
    // Create a reference to the file you want to upload
    FIRStorageReference *imagesRef = [storageRef child:@"photo_01@3x.jpg"];
    
    // Upload the file to the path "images/rivers.jpg"
    FIRStorageUploadTask *uploadTask = [imagesRef putData:data metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
            NSLog(@"%@",error.localizedDescription);
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            NSURL *downloadURL = metadata.downloadURL;
            NSLog(@"%@",downloadURL);
        }
    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
