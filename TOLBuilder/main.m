//
//  main.m
//  TOLBuilder
//
//  Created by Mark Dixon on 5/4/14.
//  Copyright (c) 2014 Mark Dixon. All rights reserved.
//

#import "Node.h"

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
    NSString *path = @"TOLBuilder";
    path = [path stringByDeletingPathExtension];
    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString *path = [[NSProcessInfo processInfo] arguments][0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}

@interface XmlParserDelegate : NSObject<NSXMLParserDelegate>
@property NSManagedObjectContext *context;

@end

@implementation XmlParserDelegate
NSString *currentCharacters;
Node *currentNode;
int32_t parents[50];
int parentDepth = 0;

- (id) init
{
    if (self = [super init]) {
        parents[0] = 0;
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"NODE"]) {
        currentNode = [NSEntityDescription insertNewObjectForEntityForName:@"Node" inManagedObjectContext:self.context];
        currentNode.id = (int32_t)[[attributeDict objectForKey:@"ID"] integerValue];
        currentNode.parentId = parents[parentDepth++];
        parents[parentDepth] = currentNode.id;
        currentNode.isLeaf = [[attributeDict objectForKey:@"LEAF"] boolValue] || [[attributeDict objectForKey:@"CHILDCOUNT"] integerValue] == 0;
        currentNode.italicizeName = [[attributeDict objectForKey:@"ITALICIZENAME"] boolValue];
        currentNode.hasPage = [[attributeDict objectForKey:@"HASPAGE"] boolValue];
    }
    else {
        currentCharacters = nil;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"NODE"]) {
        NSError *error = nil;
        if (![self.context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
        --parentDepth;
    }
    else if ([elementName isEqualToString:@"NAME"] && currentNode.name == nil) {
        currentNode.name = currentCharacters;
    }
    else if ([elementName isEqualToString:@"DESCRIPTION"] && currentNode.desc == nil) {
        currentNode.desc = currentCharacters;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (currentCharacters == nil) {
        currentCharacters = string;
    }
    else {
        currentCharacters = [currentCharacters stringByAppendingString:string];
    }
}

@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();

        NSURL *dataXml = [NSURL fileURLWithPath:@"/Users/mark/Downloads/tolweb.xml"];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:dataXml];
        XmlParserDelegate *delegate = [[XmlParserDelegate alloc] init];
        delegate.context = context;
        [parser setDelegate:delegate];
        if (![parser parse]) {
            NSError *error = [parser parserError];
            NSLog(@"Error while parsing %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
        // Save the managed object context
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
    }
    return 0;
}

