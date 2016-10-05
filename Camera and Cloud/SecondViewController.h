//
//  SecondViewController.h
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/27/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoLibraryVC.h"
#import "PickerLibraryVC.h"


@interface SecondViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *GoToCameraView;
@property (weak, nonatomic) IBOutlet UIImageView *takeAPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageLibaryImageView;
@property (weak, nonatomic) IBOutlet UIView *goToCollectionViewView;
@property (weak, nonatomic) PickerLibraryVC *pickerLibraryVC;
@property (weak, nonatomic) UIStoryboard *storyBoard;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIImage *pictureTaken;
@property (nonatomic, strong) NSString *pictureTakenReference;

@end

