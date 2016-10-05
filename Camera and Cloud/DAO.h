//
//  DAO.h
//  Camera and Cloud
//
//  Created by Chad Wiedemann on 9/29/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase.h>
#import <AFNetworking.h>

@interface DAO : NSObject

+ (DAO*)sharedInstanceOfDAO;
@property (nonatomic, strong) NSMutableDictionary *firebaseGETData;
@property (nonatomic, strong) NSMutableArray *JSONArray;

@end
