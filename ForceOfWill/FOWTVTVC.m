//
//  FOWTVTVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/22/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//
#import <RestKit/RestKit.h>

#import "FOWTVTVC.h"
#import "FOWTVDetailVC.h"
#import "Constants.h"
#import "YTVideoREST.h"
#import "YTVideoTVCell.h"

@interface FOWTVTVC ()

@property (strong, nonatomic) NSArray * youtubeVideos;

@end

@implementation FOWTVTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getYTVideosSearching:@"Force of Will"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - GET Youtube Videos

- (void)getYTVideosSearching:(NSString *)queryString
{
    //Example: https://www.googleapis.com/youtube/v3/search?part=id%2Csnippet&maxResults=10&q=Force+of+Will&type=videos&key={YOUR_API_KEY}
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kGoogleYoutubeAPIBaseUrl]];
    
    // setup object mappings
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[YTVideoREST class]];
    [videoMapping addAttributeMappingsFromDictionary:@{
                                                       @"id.videoId":  @"videoId",
                                                       @"snippet.title": @"title",
                                                       @"snippet.description":@"videoDescription",
                                                       @"snippet.thumbnails.default.url":@"thumbnailUrl"
                                                       }];
    
    NSString * pathPattern = [NSString stringWithFormat:@"%@%@", kGoogleYoutubeAPIBasePath, @"/search"];
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:videoMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathPattern
                                                keyPath:@"items"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    NSDictionary * params = @{
                              @"key":kGoogleAPIiOSKey,
                              @"part":@"id,snippet",
                              @"q":queryString,
                              @"type":@"videos",
                              @"maxResults":@"30"
                              };
    
    [objectManager getObjectsAtPath:pathPattern
                         parameters:params
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                
                                UIApplication* app = [UIApplication sharedApplication];
                                app.networkActivityIndicatorVisible = NO;
                                self.youtubeVideos = mappingResult.array;
                                [self.tableView reloadData];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"YouTube API Error': %@", error.localizedDescription);
                            }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.youtubeVideos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTVideoTVCell *cell = (YTVideoTVCell *)[tableView dequeueReusableCellWithIdentifier:@"FOWTVCell" forIndexPath:indexPath];
    cell.video = (YTVideoREST *)[self.youtubeVideos objectAtIndex:indexPath.row];
    [cell updateCell];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"fowtvdetail"]){
        FOWTVDetailVC * detailVC = (FOWTVDetailVC *)[segue destinationViewController];
        NSIndexPath * selectedInedexPath = [self.tableView indexPathForSelectedRow];
        
        detailVC.video = [self.youtubeVideos objectAtIndex:selectedInedexPath.row];
    }
}


@end
