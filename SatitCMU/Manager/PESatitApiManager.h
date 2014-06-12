//
//  PESatitApiManager.h
//  SatitCMU
//
//  Created by MRG on 2/10/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol PESatitApiManagerDelegate <NSObject>

#pragma mark - Core Api Protocol
/*
 Core Api Protocol
 */
- (void)PESatitApiManager:(id)sender getCommentObjectIdResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender getCommentObjectIdErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender CommentObjectIdResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender CommentObjectIdErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender likeObjectResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender likeObjectErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender unlikeObjectResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender unlikeObjectErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender checkLikeObjectResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender checkLikeObjectErrorResponse:(NSString *)errorResponse;
/*
 End Core Api Protocol
 */

#pragma mark - User Api Protocol
/*
 User Api Protocol
 */

- (void)PESatitApiManager:(id)sender loginWithFacebookResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender loginWithFacebookErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender signupWithUsernameResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender signupWithUsernameErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender loginWithEmailResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender loginWithEmailErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender getUserSettingResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender getUserSettingErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender getUserByIdResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender getUserByIdErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender getNotifyResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender getNotifyErrorResponse:(NSString *)errorResponse;


/*
 End Api Protocol
 */
#pragma mark - Gallery Api Protocol
/*
 Gallery Api Protocol
 */
- (void)PESatitApiManager:(id)sender galleryResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender galleryErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender galleryPictureByIdResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender galleryPictureByIdErrorResponse:(NSString *)errorResponse;

/*
 End Gallery Api Protocol
 */
#pragma mark - Feeds Api Protocol
/*
 Feeds Api
 */

- (void)PESatitApiManager:(id)sender feedResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender feedErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender getNewsByIdResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender getNewsByIdErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender getNewsLikeCommentsResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender getNewsLikeCommentsErrorResponse:(NSString *)errorResponse;


/*
 End Feeds Api Protocol
 */
#pragma mark - Activity Api Protocol
/*
 Activity Api
 */

- (void)PESatitApiManager:(id)sender activityResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender activityErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender getActivitiesByMResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender getActivitiesByMErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender joinActivityResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender joinActivityErrorResponse:(NSString *)errorResponse;
- (void)PESatitApiManager:(id)sender unjoinActivityResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender unjoinActivityErrorResponse:(NSString *)errorResponse;

/*
 End Activity Api Protocol
 */
#pragma mark - Contact Api Protocol
/*
 Contact Api Protocol
 */
- (void)PESatitApiManager:(id)sender getContactResponse:(NSDictionary *)response;
- (void)PESatitApiManager:(id)sender getContactErrorResponse:(NSString *)errorResponse;
/*
 End Contact Api Protocol
 */
@end

@interface PESatitApiManager : NSObject
#pragma mark - Property
/*
 Property
 */

@property AFHTTPRequestOperationManager *manager;
@property NSUserDefaults *userDefaults;
@property (assign, nonatomic) id delegate;

/* 
 End Property
 */

#pragma mark - Core Api

/*
 Core Api
 */
- (NSString *)getUserToken;
- (void)getObjectWithObjectId:(NSString *)objectId;
- (void)getCommentObjectId:(NSString *)commentId limit:(NSString *)limit next:(NSString *)next;
- (void)CommentObjectId:(NSString *)objectId msg:(NSString *)msg;
- (NSString *)genTokenForGuest;
- (NSString *)getAuth;
- (NSString *)getTokenGuest;
- (void)setTokenForGuest;
- (void)saveCoreData:(NSString *)data;
- (void)saveToCoreData:(NSDictionary *)data;
- (void)saveUserSettingToCoreDataWithUpdare:(NSString *)update showcase:(NSString *)showcase newsFromSatit:(NSString *)newsFromSatit;
- (void)saveUserProfileUpdate:(NSString *)email phone:(NSString *)phone;
- (NSDictionary *)getUserSettingFromCoreData;
- (NSDictionary *)getCoreData;
- (void)saveGalleryDesc:(NSString *)text;
- (NSDictionary *)getGalleryDesc;

- (void)saveGalleryName:(NSString *)text;
- (NSDictionary *)getGalleryName;

- (void)clearCoreData;
- (void)likeObject:(NSString *)objId;
- (void)unlikeObject:(NSString *)objId;
- (void)checkLikeObject:(NSString *)objId;
/*
 End Core Api
 */
#pragma mark - User Api
/*
 User Api
 */
- (void)loginWithFacebook:(NSString *)email fbid:(NSString *)fbid firstName:(NSString *)firstName lastName:(NSString *)lastName username:(NSString *)username deviceToken:(NSString *)deviceToken;
- (void)signupWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password gender:(NSString *)gender dateOfBirth:(NSString *)dateOfBirth;
- (void)loginWithEmail:(NSString *)email Password:(NSString *)password deviceToken:(NSString *)deviceToken;
- (void)uploadPicture:(NSData *)imageData;
- (void)getUserSetting;
- (void)setPushNews:(NSString *)type onoff:(NSString *)onoff;
- (void)setPushShowcase:(NSString *)type onoff:(NSString *)onoff;
- (void)setPushActivity:(NSString *)type onoff:(NSString *)onoff;
- (void)setPushFrom:(NSString *)type onoff:(NSString *)onoff;
- (void)updateUserProfileEmail:(NSString *)email phone:(NSString *)phone;
- (void)getUserById:(NSString *)userId;
- (void)getNotify;

/*
 End User Api
 */
#pragma mark - Gallery Api
/*
 Gallery Api
 */

- (void)galleryLimit:(NSString *)limit link:(NSString *)link;
- (void)galleryPictureByid:(NSString *)pictureId;

/*
 End Gallery Api
 */
#pragma mark - Feeds Api
/* 
 Feeds Api
 */

- (void)feedLimit:(NSString *)limit link:(NSString *)link;
- (void)getNewsById:(NSString *)idObj;
- (void)getNewsLikeComments:(NSString *)newsId;
- (void)getLikeComment:(NSString *)newsId;
/* 
 End Feeds Api
 */
#pragma mark - Activity Api
/* 
 Activity Api
 */
- (void)activityLimit:(NSString *)limit link:(NSString *)link;
- (void)getActivitiesByM:(NSString *)m year:(NSString *)year;
- (void)joinActivityById:(NSString *)actId;
- (void)unjoinActivityById:(NSString *)actId;
/*
 End Activity Api
 */
#pragma mark - Contact Api
/* 
 Contact Api
 */
- (NSDictionary *)getContact;
/*
 End Contact Api
*/
#pragma mark - Helper Function
/*
 Helper Function
 */
- (NSString *)genRandStringLength:(int)len;
- (NSString *)getUdid;
/*
 End Helper Function
 */
@end












