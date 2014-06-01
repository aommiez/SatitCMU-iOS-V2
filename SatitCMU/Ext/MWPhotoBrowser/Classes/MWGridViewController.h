//
//  MWGridViewController.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "PSTCollectionView.h"
#import "PESatitApiManager.h"

@interface MWGridViewController : PSTCollectionViewController {}

@property (nonatomic, assign) MWPhotoBrowser *browser;
@property (nonatomic) BOOL selectionMode;
@property (nonatomic) CGPoint initialContentOffset;
@property (nonatomic, weak) NSString *desText;

@end