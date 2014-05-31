//
//  PEActivityCalendarViewController.h
//  SatitCMU
//
//  Created by MRG on 2/17/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "TKCalendarMonthTableViewController.h"
#import "TapkuLibrary.h"
#import "NSDate+Helper.h"
#import "AFNetworking.h"
#import "monthCell.h"
#import "PFActivityDetailViewController.h"

@protocol PFActivityCalendarViewControllerDelegate <NSObject>

- (void)PFActivityCalendarViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFActivityCalendarViewControllerBack;

@end

@interface PFActivityCalendarViewController : TKCalendarMonthTableViewController

@property (assign, nonatomic) id delegate;
@property (nonatomic,strong) NSMutableArray *dataArray1;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *actArray;
@property (nonatomic,strong) NSMutableDictionary *dataDictionary;
@property (nonatomic,strong) NSMutableDictionary *stuDictionary;
@property (nonatomic,strong) NSMutableDictionary *actDictionary;
@property (nonatomic, retain) NSDictionary *obj;
@property (nonatomic, retain) NSDate *dateStart;
@property (nonatomic, retain) NSDate *dateEnd;
@property (nonatomic, retain) NSMutableArray *allDataArray;

- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end;

@end
