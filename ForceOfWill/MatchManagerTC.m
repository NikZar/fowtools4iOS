//
//  MatchManagerTC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/30/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "MatchManager.h"
#import "Constants.h"

@interface MatchManagerTC : XCTestCase

@property (strong, nonatomic) MatchManager *matchManager;
@property (strong, nonatomic) NSManagedObjectContext *moc;

@end

@implementation MatchManagerTC

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ForceOfWill" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.moc = [[NSManagedObjectContext alloc] init];
    self.moc.persistentStoreCoordinator = psc;
    
    self.matchManager = [MatchManager sharedManager];
    self.matchManager.moc = self.moc;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.moc = nil;
}

- (void)testInitialLPs {

    NSComparisonResult comparisonResult;
    
    NSNumber *p1LP = self.matchManager.player1LP;
    comparisonResult = [p1LP compare:kFOWStartLifePoints];
    
    XCTAssertTrue(comparisonResult == NSOrderedSame);
    
    NSNumber *p2LP = self.matchManager.player2LP;
    comparisonResult = [p2LP compare:kFOWStartLifePoints];
    
    XCTAssertTrue(comparisonResult == NSOrderedSame);
}

- (void)testPlayer1LifeLoss
{
    NSComparisonResult comparisonResult;
    
    NSNumber *newP1LP = @3000;
    self.matchManager.player1LP = newP1LP;
    
    comparisonResult = [self.matchManager.player1LP compare:kFOWStartLifePoints];
    XCTAssertFalse(comparisonResult==NSOrderedSame);
    
    comparisonResult = [self.matchManager.player1LP compare:newP1LP];
    XCTAssertTrue(comparisonResult==NSOrderedSame);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
