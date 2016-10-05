//
//  FirstViewController.m
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/27/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "FirstViewController.h"
#import "DAO.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DAO *dataAccessObject = [DAO sharedInstanceOfDAO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadImageFromFirebaseStorage)
                                                name:@"startDownloadingImage"
                                               object:nil];
    self.firebaseGETData = [[NSMutableDictionary alloc]init];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma methods to create JSON data
-(NSArray*)createArrayToConvertToJSON
{
    NSDictionary *photo1 = @{@"PhotoID":@1,@"TimeStamp":@1,@"FileReference":@"PUTTEST",@"FileType":@"PUTTEST3",@"Comments":@[@"great Pic"],@"Likes":@4};
    NSDictionary *photo2 = @{@"PhotoID":@1,@"TimeStamp":@1,@"FileReference":@"PUTTEST",@"FileType":@"PUTTEST3",@"Comments":@[@"great Pic"],@"Likes":@4};
    NSArray *metaData = @[photo1,photo2];
    return metaData;
    
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

-(void)GETDataFromAPI
{
    
    //AF Datatask
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://camera-and-cloud-22204.firebaseio.com/images.json"];
    NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc]initWithURL:URL];
    request3.HTTPMethod = @"GET";
    request3.URL = URL;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request3 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            self.firebaseGETData = [[NSMutableDictionary alloc]init];
            self.firebaseGETData = responseObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"startDownloadingImage"
                 object:nil];
            });
        }
        
    }];
    [dataTask resume];
    
}

-(void)sendLocalPictureToFirebase
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

-(NSString*)getPictureReferenceFromAPIData: (NSMutableDictionary*) data
{
    NSArray *pictureArray = (NSArray*)[data objectForKey:@"-KSrxIeOtamAxNavYPlg"];
    NSDictionary *picInfo = (NSDictionary*)[pictureArray objectAtIndex:0];
    NSString *photoreference = (NSString*)[picInfo objectForKey:@"FileReference"];
    return photoreference;
}

-(void)downloadImageFromFirebaseStorage
{
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://camera-and-cloud-22204.appspot.com"];
    FIRStorageReference *imageRef = [storageRef child:[self getPictureReferenceFromAPIData:self.firebaseGETData]];
    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    [imageRef dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
        if (error != nil) {
            // Uh-oh, an error occurred!
        } else {
            self.testDownloadImageView.image = [UIImage imageWithData:data];
        }
    }];
    
    
}

-(void)addACommentToAPhotoPUT
{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self createArrayToConvertToJSON] options:NSJSONWritingPrettyPrinted error:&error];
    //AF Datatask
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://camera-and-cloud-22204.firebaseio.com/images/-KSrxIeOtamAxNavYPlg.json"];
    NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc]initWithURL:URL];
    request3.HTTPMethod = @"PUT";
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



@end
