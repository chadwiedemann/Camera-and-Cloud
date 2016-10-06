//
//  CollectionViewVC.m
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/30/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "CollectionViewVC.h"

@interface CollectionViewVC ()

@end

@implementation CollectionViewVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fileReferences = [[NSMutableArray alloc]init];
    self.imagesArray = [[NSMutableArray alloc]init];
    self.photoDetailVC.currentComments = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getPictureReferenceFromAPIData)
                                                 name:@"startDownloadingImage"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:@"loadView"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downLoadNextPhoto)
                                                 name:@"getNextPicture"
                                               object:nil];
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    

}



-(void)viewWillAppear:(BOOL)animated
{
    self.downloadCounter = 0;
    [self.photoDetailVC.currentComments removeAllObjects];
    [self.fileReferences removeAllObjects];
    [self.imagesArray removeAllObjects];
    [self GETDataFromAPI];
}

-(void)reload
{
    
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return [self.fileReferences count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    UIImage *image = [self.imagesArray objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    cell.backgroundView = imageView;
    return cell;
    
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

-(void)downloadImageFromFirebaseStorage: (NSString*) reference
{
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://camera-and-cloud-22204.appspot.com/images"];
    FIRStorageReference *imageRef = [storageRef child:reference];
    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    [imageRef dataWithMaxSize:1 * 10240 * 1024 completion:^(NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"%@",error.localizedDescription);
        } else {
            UIImage *image = [UIImage imageWithData:data];
            [self.imagesArray addObject:image];
            self.downloadCounter = self.downloadCounter + 1;
            
            
            
            if(self.downloadCounter == self.fileReferences.count)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"loadView"
                     object:nil];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"getNextPicture"
                     object:nil];
                });
            }
        }
    }];
    
    
}

-(void)downLoadNextPhoto
{
    NSString *next = [self.fileReferences objectAtIndex:self.downloadCounter];
    [self downloadImageFromFirebaseStorage:next];
}

-(void)getPictureReferenceFromAPIData
{
    NSArray *fileReference = [self.firebaseGETData allKeys];
    
    for(int i=0;i<fileReference.count;i++)
    {
        NSDictionary *tempDic = [self.firebaseGETData objectForKey:fileReference[i]];
        NSString *reference = [tempDic objectForKey:@"FileReference"];
        [self.fileReferences addObject:reference];
    }
    
    
    [self downLoadNextPhoto];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedPhoto  = [self.imagesArray objectAtIndex:indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.photoDetailVC = (PhotoDetailVC*)[sb instantiateViewControllerWithIdentifier:@"PhotoDetailVC"];
    self.photoDetailVC.selectedPhoto = self.selectedPhoto;
    self.photoDetailVC.fileReference = [self.fileReferences objectAtIndex:indexPath.row];
    NSArray *fileReference = [self.firebaseGETData allKeys];
    NSDictionary *tempDic = [self.firebaseGETData objectForKey: fileReference[indexPath.row]];
    NSArray *reference = [tempDic objectForKey:@"Comments"];
    NSMutableArray *reference1 = [reference mutableCopy];
    self.currentComments=reference1;
    self.photoDetailVC.firebaseGETData = self.firebaseGETData;
    self.photoDetailVC.currentComments = self.currentComments;
    [self.navigationController pushViewController:self.photoDetailVC animated:YES];
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
