//
//  PhotoLibraryVC.h
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 10/1/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>
#import <AFNetworking.h>

@interface PhotoLibraryVC : UICollectionViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, strong) UIImagePickerController *picker;

@property(nonatomic, strong) NSMutableArray *imageStringArray;
@property NSInteger *selectedIndex;
@property NSString *uniqueImagePath;


@end
