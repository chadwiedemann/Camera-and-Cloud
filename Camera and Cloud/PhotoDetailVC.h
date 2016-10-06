//
//  PhotoDetailVC.h
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/30/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>
#import <AFNetworking.h>
#import "CommentTableViewCell.h"


@interface PhotoDetailVC : UIViewController <UITableViewDataSource, UITableViewDelegate , UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoDetailImageView;
@property (nonatomic, strong) UIImage *selectedPhoto;
@property (nonatomic, strong) NSMutableDictionary *firebaseGETData;

@property (weak, nonatomic) IBOutlet UITextField *commentTextFieldText;

- (IBAction)deleteButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) NSDictionary *dataToUpdate;

- (IBAction)commentButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;
@property BOOL photoCurrentLikeStatus;
@property int currentLikes;
@property (nonatomic, strong) NSMutableArray *currentComments;
@property (nonatomic, strong) NSString *fileReference;
@property (nonatomic, strong) NSString *currentFirebaseRandomKey;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
- (IBAction)commentTextField:(id)sender;

- (IBAction)sendCommentButton:(id)sender;




@end
