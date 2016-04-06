//
//  Document+CoreDataProperties.h
//  DocKeeper
//
//  Created by Admin on 06.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Document.h"

NS_ASSUME_NONNULL_BEGIN

@interface Document (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSData *preview;
@property (nullable, nonatomic, retain) NSSet<Picture *> *pictures;

@end

@interface Document (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSSet<Picture *> *)values;
- (void)removePictures:(NSSet<Picture *> *)values;

@end

NS_ASSUME_NONNULL_END
