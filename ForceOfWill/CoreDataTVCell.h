//
//  CoreDataTVCell.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/30/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTVCell : UITableViewCell

@property (weak, nonatomic) NSManagedObject *managedObject;

- (void)updateCell;

@end
