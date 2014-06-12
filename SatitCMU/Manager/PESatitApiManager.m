//
//  PESatitApiManager.m
//  SatitCMU
//
//  Created by MRG on 2/10/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PESatitApiManager.h"

@implementation PESatitApiManager
#pragma mark - Core Api Implementation
/* 
 Core Api Implementation
 */

- (void)getObjectWithObjectId:(NSString *)objectId {
    
}
- (void)getCommentObjectId:(NSString *)commentId limit:(NSString *)limit next:(NSString *)next{
    NSString *urlStr = [[NSString alloc] init];
    if (![limit isEqualToString:@"NO"] && [next isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@dz_object/%@/comment?limit=%@",API_URL,commentId,limit];
    } else if ([limit isEqualToString:@"NO"] && [next isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@dz_object/%@/comment",API_URL,commentId];
    } else if (![next isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@",next];
    }
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self getCommentObjectIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self getCommentObjectIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)CommentObjectId:(NSString *)objectId msg:(NSString *)msg {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@dz_object/%@/comment",API_URL,objectId];
    NSDictionary *parameters = @{@"message":msg };
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self CommentObjectIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self CommentObjectIdErrorResponse:[error localizedDescription]];
    }];
}
- (NSString *)getAuth {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    if ([data objectForKey:@"login"] == nil || [[data objectForKey:@"login"] isEqualToString:@"NO"]) {
        return @"NO Login";
    } else {
        return @"Yes Login";
    }
    return false;
}
- (NSString *)genTokenForGuest {
    return [self genRandStringLength:256];
}
- (void)setTokenForGuest {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    if ([[data valueForKey:@"guestToken"] length] != 256) {
        [data setObject:[self genTokenForGuest] forKey:@"guestToken"];
        [data setObject:@"NO" forKey:@"login"];
        [data writeToFile:plistPath atomically:YES];
    }
}
- (NSString *)getTokenGuest {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    return [data valueForKey:@"guestToken"];
}
- (void)saveCoreData:(NSString *)data{
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *coreData = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    [coreData setObject:@"YES" forKey:@"login"];
    [coreData setObject:data forKey:@"token"];
    [coreData setObject:data forKey:@"user"];
    [coreData setObject:data forKey:@"email"];
    [coreData setObject:data forKey:@"email_show"];
    [coreData setObject:data forKey:@"username"];
    [coreData setObject:data forKey:@"gender"];
    [coreData setObject:data forKey:@"birth_date"];
    [coreData setObject:data forKey:@"type"];
    [coreData setObject:data forKey:@"id"];
    [coreData setObject:data forKey:@"updated_at"];
    [coreData setObject:data forKey:@"created_at"];    
    [coreData writeToFile:plistPath atomically:YES];
}
- (void)saveToCoreData:(NSDictionary *)data{
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *coreData = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    [coreData setObject:@"YES" forKey:@"login"];
    [coreData setObject:[data objectForKey:@"token"] forKey:@"token"];
    [coreData setObject:[data objectForKey:@"birth_date"] forKey:@"birth_date"];
    [coreData setObject:[data objectForKey:@"created_at"] forKey:@"created_at"];
    [coreData setObject:[data objectForKey:@"email"] forKey:@"email"];
    [coreData setObject:[data objectForKey:@"email_show"] forKey:@"email_show"];
    [coreData setObject:[data objectForKey:@"facebook_id"] forKey:@"facebook_id"];
    [coreData setObject:[data objectForKey:@"first_name"] forKey:@"first_name"];
    [coreData setObject:[data objectForKey:@"gender"] forKey:@"gender"];
    [coreData setObject:[data objectForKey:@"id"] forKey:@"id"];
    [coreData setObject:[data objectForKey:@"ios_device_token"] forKey:@"ios_device_token"];
    [coreData setObject:[data objectForKey:@"last_name"] forKey:@"last_name"];
    [coreData setObject:[data objectForKey:@"member_timeout"] forKey:@"member_timeout"];
    [coreData setObject:[data objectForKey:@"phone_number"] forKey:@"phone_number"];
    [coreData setObject:[data objectForKey:@"phone_show"] forKey:@"phone_show"];
    [coreData setObject:[data objectForKey:@"type"] forKey:@"type"];
    [coreData setObject:[data objectForKey:@"updated_at"] forKey:@"updated_at"];
    [coreData setObject:[data objectForKey:@"username"] forKey:@"username"];
    [coreData writeToFile:plistPath atomically:YES];
}
- (NSDictionary *)getCoreData {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    return data;
}
- (NSString *)getUserID {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    return [data objectForKey:@"id"];
}
- (NSString *)getUserToken {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    return [data objectForKey:@"token"];
}
- (void)saveUserSettingToCoreDataWithUpdare:(NSString *)update showcase:(NSString *)showcase newsFromSatit:(NSString *)newsFromSatit {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *coreData = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    [coreData setObject:update forKey:@"update_setting"];
    [coreData setObject:showcase forKey:@"showcase_setting"];
    [coreData setObject:newsFromSatit forKey:@"news_satit_setting"];
    [coreData writeToFile:plistPath atomically:YES];
}
- (NSDictionary *)getUserSettingFromCoreData {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[data objectForKey:@"update_setting"] forKey:@"update_setting"];
    [dict setObject:[data objectForKey:@"showcase_setting"] forKey:@"showcase_setting"];
    [dict setObject:[data objectForKey:@"news_satit_setting"] forKey:@"news_satit_setting"];
    return dict;
}
- (void)saveUserProfileUpdate:(NSString *)email phone:(NSString *)phone {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *coreData = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    [coreData setObject:phone forKey:@"phone_show"];
    [coreData setObject:email forKey:@"email_show"];
    [coreData writeToFile:plistPath atomically:YES];
}
- (void)saveGalleryDesc:(NSString *)text {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *coreData = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    [coreData setObject:text forKey:@"galleryDesc"];
    [coreData writeToFile:plistPath atomically:YES];
}
- (NSDictionary *)getGalleryDesc {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[data objectForKey:@"galleryDesc"] forKey:@"galleryDesc"];
    return dict;
}
//
- (void)saveGalleryName:(NSString *)text {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *coreData = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    [coreData setObject:text forKey:@"galleryName"];
    [coreData writeToFile:plistPath atomically:YES];
}
- (NSDictionary *)getGalleryName {
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[data objectForKey:@"galleryName"] forKey:@"galleryName"];
    return dict;
}
//
- (void)clearCoreData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plistPath = [self copyFileToDocumentDirectory:@"CoreData.plist"];
    [fileManager removeItemAtPath:plistPath error:NULL];
}
- (void)likeObject:(NSString *)objId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@dz_object/%@/like",API_URL,objId];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"likeObject%@",responseObject);
        //[self.delegate PESatitApiManager:self likeObjectResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        //[self.delegate PESatitApiManager:self likeObjectErrorResponse:[error localizedDescription]];
    }];
}
- (void)unlikeObject:(NSString *)objId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@dz_object/%@/like",API_URL,objId];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager DELETE:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"unlikeObject%@",responseObject);
        //[self.delegate PESatitApiManager:self unlikeObjectResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        //[self.delegate PESatitApiManager:self unlikeObjectErrorResponse:[error localizedDescription]];
    }];
}
- (void)checkLikeObject:(NSString *)objId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@news/%@?fields=like,comment&auth_token=%@",API_URL,objId,[self getUserToken]];
    
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.delegate PESatitApiManager:self checkLikeObjectResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self checkLikeObjectErrorResponse:[error localizedDescription]];
    }];
}

/*
 End Core Api Implementation
 */
#pragma mark - User Api Implementation
/* 
 User Api Implementation
 */

- (void)loginWithFacebook:(NSString *)email fbid:(NSString *)fbid firstName:(NSString *)firstName lastName:(NSString *)lastName username:(NSString *)username deviceToken:(NSString *)deviceToken {
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@facebook/login",API_URL];
    self.manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email":email , @"facebook_id":fbid , @"first_name":firstName , @"last_name":lastName , @"username":username , @"deviceToken":deviceToken };
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self loginWithFacebookResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self loginWithFacebookErrorResponse:[error localizedDescription]];
    }];
}
- (void)signupWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password gender:(NSString *)gender dateOfBirth:(NSString *)dateOfBirth {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@register",API_URL];
    self.manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"username":username , @"email":email, @"password":password,@"birth_date":dateOfBirth,@"gender":gender};
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self signupWithUsernameResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self signupWithUsernameErrorResponse:[error localizedDescription]];
    }];
}
- (void)loginWithEmail:(NSString *)email Password:(NSString *)password deviceToken:(NSString *)deviceToken{
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@auth",API_URL];
    self.manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"username":email , @"password":password, @"deviceToken":deviceToken};
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self loginWithEmailResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self loginWithEmailErrorResponse:[error localizedDescription]];
    }];
}
- (void)uploadPicture:(NSData *)imageData {
    NSDictionary *parameters = @{@"uid":[self getUserID]};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@user/%@/picture",API_URL,[self getUserID]];
    /*
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager POST:strUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"picture" fileName:@"picture.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
        */
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:strUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"picture" fileName:@"picture.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    [request setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"%@",progress);
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}
- (void)getUserSetting {
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@user/%@/setting",API_URL,[self getUserID]];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        [self.delegate PESatitApiManager:self getUserSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self getUserSettingErrorResponse:[error localizedDescription]];
        NSLog(@"Error: %@", error);
    }];
}
- (void)setPushNews:(NSString *)type onoff:(NSString *)onoff {
    NSDictionary *parameters = @{@"new_update":onoff};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@user/%@/setting",API_URL,[self getUserID]];
     self.manager = [AFHTTPRequestOperationManager manager];
     self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
     self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
     [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)setPushShowcase:(NSString *)type onoff:(NSString *)onoff {
    NSDictionary *parameters = @{@"new_showcase":onoff};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@user/%@/setting",API_URL,[self getUserID]];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)setPushActivity:(NSString *)type onoff:(NSString *)onoff {
    NSDictionary *parameters = @{@"new_lesson":onoff};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@user/%@/setting",API_URL,[self getUserID]];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)setPushFrom:(NSString *)type onoff:(NSString *)onoff {
    NSDictionary *parameters = @{@"news_from_dancezone":onoff};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@user/%@/setting",API_URL,[self getUserID]];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)updateUserProfileEmail:(NSString *)email phone:(NSString *)phone {
    NSDictionary *parameters = @{@"email_show":email,@"phone_show":phone};
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,[self getUserID]];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.manager PUT:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Success: %@", responseObject);
        [self saveUserProfileUpdate:[responseObject objectForKey:@"email_show"] phone:[responseObject objectForKey:@"phone_show"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)getUserById:(NSString *)userId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,userId];
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self getUserByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self getUserByIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)getNotify {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@notification",API_URL];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

/*
 End User Api Implementation
 */
#pragma mark - Gallery Api Implementation
/*
 Gallery Api Implementation
 */

- (void)galleryLimit:(NSString *)limit link:(NSString *)link {
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [[NSString alloc] init];
    if ([limit isEqualToString:@"NO"] && [link isEqualToString:@"NO"] ) {
        urlStr = [[NSString alloc] initWithFormat:@"%@gallery",API_URL];
    } else if (![limit isEqualToString:@"NO"] && [link isEqualToString:@"NO"] ) {
        urlStr = [[NSString alloc] initWithFormat:@"%@gallery?limit=%@",API_URL,limit];
    } else if (![link isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@",link];
    }
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self galleryResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self galleryErrorResponse:[error localizedDescription]];
    }];
}
- (void)galleryPictureByid:(NSString *)pictureId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@gallery_picture/%@",API_URL,pictureId];
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self galleryPictureByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self galleryPictureByIdErrorResponse:[error localizedDescription]];
    }];
}
/*
 End Gallery Api Implementation
 */
#pragma mark - Feeds Api Implementation
/*
 Feeds Api Implementation
 */
- (void)feedLimit:(NSString *)limit link:(NSString *)link {
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [[NSString alloc] init];
    
    if ([limit isEqualToString:@"NO"] && [link isEqualToString:@"NO"] ) {
        urlStr = [[NSString alloc] initWithFormat:@"%@feed?ios_token=%@",API_URL,[self getTokenGuest]];
    } else if (![limit isEqualToString:@"NO"] && [link isEqualToString:@"NO"] ) {
        urlStr = [[NSString alloc] initWithFormat:@"%@feed?limit=%@&ios_token=%@",API_URL,limit,[self getTokenGuest]];
    } else if (![link isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@",link];
    }
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self feedResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self feedErrorResponse:[error localizedDescription]];
    }];
}
- (void)getNewsById:(NSString *)idObj {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@news/%@",API_URL,idObj];
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self getNewsByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self getNewsByIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)getNewsLikeComments:(NSString *)newsId {
    //NSLog(@"%@",[self getUserToken]);
    //NSString *urlStr = [[NSString alloc] initWithFormat:@"%@news/%@",API_URL,newsId];
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@news/%@?fields=like,comment&auth_token=%@",API_URL,newsId,[self getUserToken]];

    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.delegate PESatitApiManager:self getNewsLikeCommentsResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self getNewsLikeCommentsErrorResponse:[error localizedDescription]];
    }];
}
- (void)getLikeComment:(NSString *)newsId {
    NSLog(@"%@",newsId);
}
/* 
 End Feeds Api Implementation
 */
#pragma mark - Activity Api Implementation
/* 
 Activity Api Implementation
 */

- (void)activityLimit:(NSString *)limit link:(NSString *)link {
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [[NSString alloc] init];
    if ([limit isEqualToString:@"NO"] && [link isEqualToString:@"NO"] ) {
        urlStr = [[NSString alloc] initWithFormat:@"%@activity",API_URL];
    } else if (![limit isEqualToString:@"NO"] && [link isEqualToString:@"NO"] ) {
        urlStr = [[NSString alloc] initWithFormat:@"%@activity?limit=%@",API_URL,limit];
    } else if (![link isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@",link];
    }
   
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self activityResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self activityErrorResponse:[error localizedDescription]];
    }];
}
- (void)getActivitiesByM:(NSString *)m year:(NSString *)year {
    //NSLog(@"%@",[self getUserToken]);
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@activity?month=%@&year=%@?auth_token=%@",API_URL,m,year,[self getTokenGuest]];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self getActivitiesByMResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self getActivitiesByMErrorResponse:[error localizedDescription]];
    }];
}
- (void)joinActivityById:(NSString *)actId {
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@activity/%@/user",API_URL,actId];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self joinActivityResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self joinActivityErrorResponse:[error localizedDescription]];
    }];
    
}
- (void)unjoinActivityById:(NSString *)actId {
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@activity/%@/user",API_URL,actId];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:[self getUserToken] forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager DELETE:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self unjoinActivityResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self unjoinActivityErrorResponse:[error localizedDescription]];
    }];
}
/* 
 End Activity Api Implementation
 */
#pragma mark - Contact Api Implementation
/*
 Contact Api Implementaion
 */
- (NSDictionary *)getContact {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [[NSString alloc] init];
    urlStr = [[NSString alloc] initWithFormat:@"%@setting",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PESatitApiManager:self getContactResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PESatitApiManager:self getContactErrorResponse:[error localizedDescription]];
    }];
    return dict;
}
/*
 End Contact Api Implementaion
 */
#pragma mark - Helper Function Implementation
/*
 Helper Function Implementation
 */

- (NSString *)genRandStringLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

- (NSString *)getUdid {
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (__bridge NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return uuidString;
}
- (NSString *)copyFileToDocumentDirectory:(NSString *)fileName {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *documentDirPath = [documentsDir
                                 stringByAppendingPathComponent:fileName];
    
    NSArray *file = [fileName componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle]
                          pathForResource:[file objectAtIndex:0]
                          ofType:[file lastObject]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:documentDirPath];
    
    if (!success) {
        success = [fileManager copyItemAtPath:filePath
                                       toPath:documentDirPath
                                        error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable txt file file with message \
                      '%@'.", [error localizedDescription]);
        }
    }
    
    return documentDirPath;
}
/*
 End Helper Function Implementation
 */

@end











