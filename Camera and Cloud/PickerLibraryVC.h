//
//  PickerLibraryVC.h
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 10/4/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>
#import <AFNetworking.h>

@interface PickerLibraryVC : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIImage *pictureTaken;
@property (nonatomic, strong) NSString *pictureTakenReference;


@end
