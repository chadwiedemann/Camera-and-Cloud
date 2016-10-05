//
//  CollectionViewVC.h
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/30/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>
#import <AFNetworking.h>

@interface CollectionViewVC : UICollectionViewController
@property (nonatomic, strong) NSMutableDictionary *firebaseGETData;
@property (nonatomic, strong) NSMutableArray *fileReferences;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property NSInteger downloadCounter;
@end
