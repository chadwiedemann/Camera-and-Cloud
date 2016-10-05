//
//  Photo.h
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/29/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property NSInteger *photoID;
@property NSMutableArray *commentsArray;
@property NSInteger *numberOfLikes;
@property NSInteger *timeStamp;
@property NSString *fileReference;

@end
