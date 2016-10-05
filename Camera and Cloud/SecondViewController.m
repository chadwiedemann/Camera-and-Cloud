//
//  SecondViewController.m
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/27/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UITapGestureRecognizer *moveToPics = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
    [self.goToCollectionViewView addGestureRecognizer:moveToPics];
    
    UITapGestureRecognizer *moveToCamera = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCamera:)];
    [self.GoToCameraView addGestureRecognizer:moveToCamera];
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//        [self moveToPhotoAlbum];
    }
    
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showCamera: (UITapGestureRecognizer*) sender
{
    self.picker.allowsEditing = NO;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.pictureTaken = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    self.pictureTakenReference =timeStampObj.stringValue;
    [self dismissViewControllerAnimated:true completion:^{
        [self uploadPhoto];
        [self sendHTTPPost];
    }];
}

-(void)uploadPhoto
{
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://camera-and-cloud-22204.appspot.com"];
    UIImage *image = self.pictureTaken;
    NSData *data = UIImageJPEGRepresentation(image, .9);
    NSString *imagePath = [NSString stringWithFormat:@"images/%@",self.pictureTakenReference];
    FIRStorageReference *imagesDirectory = [storageRef child:imagePath];
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

-(NSDictionary*)createArrayToConvertToJSON
{
    NSDictionary *photo1 = @{@"FileReference":self.pictureTakenReference,@"Comments":@[],@"Likes":@0};
    //    NSArray *metaData = @[photo1];
    return photo1;
    
}

-(void)sendHTTPPost
{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self createArrayToConvertToJSON] options:NSJSONWritingPrettyPrinted error:&error];
    //AF Datatask
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://camera-and-cloud-22204.firebaseio.com/images.json"];
    NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc]initWithURL:URL];
    request3.HTTPMethod = @"POST";
    request3.HTTPBody = jsonData;
    request3.URL = URL;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request3 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
}

-(void) moveToPhotoAlbum
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.pickerLibraryVC = (PickerLibraryVC*)[sb instantiateViewControllerWithIdentifier:@"PhotoLibrary1"];
    [self.navigationController pushViewController:self.pickerLibraryVC animated:YES];
}

-(void) tapMethod: (UITapGestureRecognizer*) sender
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.pickerLibraryVC = (PickerLibraryVC*)[sb instantiateViewControllerWithIdentifier:@"PhotoLibrary1"];
    [self.navigationController pushViewController:self.pickerLibraryVC animated:YES];
    
}

@end
