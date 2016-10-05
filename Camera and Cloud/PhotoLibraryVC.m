//
//  PhotoLibraryVC.m
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 10/1/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "PhotoLibraryVC.h"

@interface PhotoLibraryVC ()

@end

@implementation PhotoLibraryVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageStringArray = [[NSMutableArray alloc]init];
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.allowsEditing = NO;
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    
    
    
    for(int i=1; i<17; i++){
        if(i>9){
            NSString *imageString = [NSString stringWithFormat:@"photo_%d@3x.jpg",i];
                        [self.imageStringArray addObject:imageString];
        }else{
        NSString *imageString = [NSString stringWithFormat:@"photo_0%d@3x.jpg",i];
                [self.imageStringArray addObject:imageString];
        }
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
//    self.pictureTakenReference =timeStampObj.stringValue;
    [self dismissViewControllerAnimated:true completion:^{
        [self uploadPhoto];
        [self sendHTTPPost];
    }];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.imageStringArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *imageString = [self.imageStringArray objectAtIndex:[indexPath row]];
    UIImage *image = [UIImage imageNamed:imageString];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];

    
    cell.backgroundView = imageView;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"picture selected");
    NSLog(@"%ld",(long)indexPath.row);
    self.selectedIndex = indexPath.row;
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    self.uniqueImagePath = timeStampObj.stringValue;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"upload photo" message:@"would you like to upload this photo" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *upload = [UIAlertAction actionWithTitle:@"upload photo to InstaPic" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self uploadPhoto];
        [self sendHTTPPost];
        
    }];
    
    [alert addAction:upload];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    return YES;
}

-(void)uploadPhoto
{
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://camera-and-cloud-22204.appspot.com"];
    NSString *imageString = [self.imageStringArray objectAtIndex:self.selectedIndex];
    UIImage *image = [UIImage imageNamed:imageString];
    NSData *data = UIImageJPEGRepresentation(image, .9);
    NSString *imagePath = [NSString stringWithFormat:@"images/%@",self.uniqueImagePath];
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
    NSDictionary *photo1 = @{@"FileReference":self.uniqueImagePath,@"Comments":@[],@"Likes":@0};
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


                             

// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    cell.highlighted = NO;
}

                  

@end
