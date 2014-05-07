//
//  Node.h
//  TOLBuilder
//
//  Created by Mark Dixon on 5/4/14.
//  Copyright (c) 2014 Mark Dixon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Node : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic) int32_t id;
@property (nonatomic) BOOL isLeaf;
@property (nonatomic) int32_t parentId;
@property (nonatomic) BOOL italicizeName;
@property (nonatomic) BOOL hasPage;

@end
