//
//  PEWebViewViewController.h
//  SatitCMU
//
//  Created by MRG on 3/7/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFWebViewViewControllerDelegate <NSObject>

- (void)PFWebViewViewControllerBack;

@end

@interface PFWebViewViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) id<PFWebViewViewControllerDelegate> delegate;
@property NSString *url;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
