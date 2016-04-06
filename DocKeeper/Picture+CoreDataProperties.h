//
//  Picture+CoreDataProperties.h
//  DocKeeper
//
//  Created by Admin on 05.04.16.
//  Copyright © 2016 Anton Glezman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Picture.h"

NS_ASSUME_NONNULL_BEGIN

@interface Picture (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSData *preview;
@property (nullable, nonatomic, retain) Document *document;

@end

NS_ASSUME_NONNULL_END
