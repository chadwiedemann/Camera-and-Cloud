//
//  PhotoDetailVC.m
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/30/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "PhotoDetailVC.h"


@interface PhotoDetailVC ()

@end

@implementation PhotoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentTableView.estimatedRowHeight = 400;
    
    [self currentNumberOfLikes];
    if(!self.currentComments){
    self.currentComments = [[NSMutableArray alloc]init];
    }
    self.likeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
    [self.likeImageView addGestureRecognizer:(likeTap)];
    
    self.photoDetailImageView.image = self.selectedPhoto;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popViewController)
                                                 name:@"pictureDeleted"
                                               object:nil];
}


-(void) tapMethod: (UITapGestureRecognizer*) sender
{
    if(self.photoCurrentLikeStatus){
        self.photoCurrentLikeStatus = NO;
        self.likeImageView.image = [UIImage imageNamed:@"activelike"];
    }else{
        self.photoCurrentLikeStatus = YES;
        self.likeImageView.image = [UIImage imageNamed:@"activelike"];
        [self addLike];
    }
    
}

-(void)addLike
{
    NSArray *fileReference = [self.firebaseGETData allKeys];
    
    for(NSString *s in fileReference){
        NSString *ref = [[self.firebaseGETData objectForKey:s] objectForKey:@"FileReference"];
        if([ref isEqualToString:self.fileReference]){
            self.currentFirebaseRandomKey = s;
        };
    }
    NSNumber *num = [NSNumber numberWithInt:self.currentLikes+1];
    
    NSArray *array = [self.currentComments copy];
    NSDictionary *photo1 = @{@"FileReference":self.fileReference,@"Comments":array,@"Likes":num};
    
    

    self.dataToUpdate = photo1;
    [self updateMetatData];
    self.currentLikes = self.currentLikes + 1;
    self.numberOfLikesLabel.text = [NSString stringWithFormat:@"%d likes",self.currentLikes];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateMetatData
{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dataToUpdate options:NSJSONWritingPrettyPrinted error:&error];
    //AF Datatask
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://camera-and-cloud-22204.firebaseio.com/images/%@.json",self.currentFirebaseRandomKey]];
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

-(void)updateMetatDataDelete
{
    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dataToUpdate options:NSJSONWritingPrettyPrinted error:&error];
    //AF Datatask
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://camera-and-cloud-22204.firebaseio.com/images/%@.json",self.currentFirebaseRandomKey]];
    NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc]initWithURL:URL];
    request3.HTTPMethod = @"DELETE";
//    request3.HTTPBody = jsonData;
    request3.URL = URL;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request3 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"pictureDeleted"
                 object:nil];
            });
        } else {
            NSLog(@"%@ %@", response, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"pictureDeleted"
                 object:nil];
            });
        }
    }];
    [dataTask resume];
    
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(NSDictionary*)createArrayToConvertToJSONAddComment
//{
//    NSDictionary *photo1 = @{@"FileReference":self.pictureTakenReference,@"Comments":@[],@"Likes":@0};
//    return photo1;
//    
//}

-(void)currentNumberOfLikes
{
    NSArray *fileReference = [self.firebaseGETData allKeys];
    
    for(int i=0;i<fileReference.count;i++)
    {
        NSDictionary *tempDic = [self.firebaseGETData objectForKey:fileReference[i]];
        if([self.fileReference isEqualToString:[tempDic objectForKey:@"FileReference"]])
        {
            NSNumber *likes = [tempDic objectForKey:@"Likes"];
            self.currentLikes = [likes integerValue];
            self.numberOfLikesLabel.text = [NSString stringWithFormat:@"%d likes",self.currentLikes];
            break;
        }
    }
}

- (IBAction)deleteButton:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete photo from Instapic" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *upload = [UIAlertAction actionWithTitle:@"Delete Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletePhoto];
        
    }];
    [alert addAction:upload];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)deletePhoto
{
    
    NSArray *fileReference = [self.firebaseGETData allKeys];
    
    for(NSString *s in fileReference){
        NSString *ref = [[self.firebaseGETData objectForKey:s] objectForKey:@"FileReference"];
        if([ref isEqualToString:self.fileReference]){
            self.currentFirebaseRandomKey = s;
        };
    }
//    NSNumber *num = [NSNumber numberWithInt:self.currentLikes+1];
//    NSDictionary *photo1 = @{@"FileReference":self.fileReference,@"Comments":@[],@"Likes":num};
//    self.dataToUpdate = photo1;
    [self updateMetatDataDelete];

    
}

- (IBAction)commentButton:(id)sender {
    
    
    NSArray *fileReference = [self.firebaseGETData allKeys];
    
    for(NSString *s in fileReference){
        NSString *ref = [[self.firebaseGETData objectForKey:s] objectForKey:@"FileReference"];
        if([ref isEqualToString:self.fileReference]){
            self.currentFirebaseRandomKey = s;
        };
    }
    NSNumber *num = [NSNumber numberWithInt:self.currentLikes];
    NSString *string = [[NSString alloc]initWithString:self.commentTextFieldText.text];
    
    [self.currentComments addObject:string];
    NSArray *array = [self.currentComments copy];
    NSDictionary *photo1 = @{@"FileReference":self.fileReference,@"Comments":array  ,@"Likes":num};
    
    
    
    self.dataToUpdate = photo1;
    [self updateMetatData];
    [self.commentTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CommentCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    cell.comment.text = self.currentComments[indexPath.row];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentComments count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 200;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (IBAction)commentTextField:(id)sender {
//    NSArray *fileReference = [self.firebaseGETData allKeys];
//    
//    for(NSString *s in fileReference){
//        NSString *ref = [[self.firebaseGETData objectForKey:s] objectForKey:@"FileReference"];
//        if([ref isEqualToString:self.fileReference]){
//            self.currentFirebaseRandomKey = s;
//        };
//    }
//    NSNumber *num = [NSNumber numberWithInt:self.currentLikes];
//    NSString *string = [[NSString alloc]initWithString:self.commentTextFieldText.text];
//    
//    [self.currentComments addObject:string];
//    NSArray *array = [self.currentComments copy];
//    NSDictionary *photo1 = @{@"FileReference":self.fileReference,@"Comments":array  ,@"Likes":num};
//    
//    
//    
//    self.dataToUpdate = photo1;
//    [self updateMetatData];
    
}

- (IBAction)sendCommentButton:(id)sender {
    
    
    NSArray *fileReference = [self.firebaseGETData allKeys];
    
    for(NSString *s in fileReference){
        NSString *ref = [[self.firebaseGETData objectForKey:s] objectForKey:@"FileReference"];
        if([ref isEqualToString:self.fileReference]){
            self.currentFirebaseRandomKey = s;
        };
    }
    NSNumber *num = [NSNumber numberWithInt:self.currentLikes];
    NSString *string = [[NSString alloc]initWithString:self.commentTextFieldText.text];
    
    [self.currentComments addObject:string];
    NSArray *array = [self.currentComments copy];
    NSDictionary *photo1 = @{@"FileReference":self.fileReference,@"Comments":array  ,@"Likes":num};
    [self.commentTableView reloadData];
    
    
    self.dataToUpdate = photo1;
    [self updateMetatData];
    
    
    
    
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

-(void)dismissKeyboard {
    [self.commentTextFieldText resignFirstResponder];
}

@end
