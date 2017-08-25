//
//  LeieNetworkManager.m
//  storyhouse2
//
//  Created by 肖君 on 16/7/8.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import "XJFNetworkManager.h"
#import "XJFHUDManager.h"
#import "XJFServerManager.h"

#define NetworkMethodList @[ @"Get", @"Post", @"Put", @"Delete" ]

static XJFNetworkManager *_shareManager = nil;
static NSURL *_baseurl = nil;
// static NSString *_acesstoken = nil;

@implementation XJFNetworkManager
+ (XJFNetworkManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      XJFServerManager *serverManager = [XJFServerManager shareManager];
      NSString *serverURL = [NSString stringWithFormat:@"http://%@", serverManager.serverURL];
      DDLogDebug(@"server url is %@", serverURL);
      _baseurl = [NSURL URLWithString:serverURL];
      _shareManager = [[XJFNetworkManager alloc] initWithBaseURL:_baseurl];

      _shareManager.networkReachability = [AFNetworkReachabilityManager sharedManager];
      _shareManager.errorDataNotDiction = [NSError errorWithDomain:serverManager.serverURL code:100 userInfo:nil];
    });
    return _shareManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }

    self.responseSerializer.acceptableContentTypes =
        [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"image/png", @"image/jpg", @"video/mpeg4",
                              @"image/gif", @"application/x-zip-compressed", @"application/binary", nil];

    //超时设置
    self.requestSerializer.timeoutInterval = 60.0f;

    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];

    self.securityPolicy.allowInvalidCertificates = YES;
    return self;
}

- (BOOL)isReachable {
    return self.networkReachability.reachable;
}

- (AFNetworkReachabilityStatus)NetworkType {
    return self.networkReachability.networkReachabilityStatus;
}

+ (instancetype)networkManager {
    XJFNetworkManager *networkMgr = [[self alloc] initWithBaseURL:_baseurl];
    //    [networkMgr setAuthorization:_acesstoken];
    return networkMgr;
}

- (void)setAuthorization:(NSString *)accessToken {
    //    _acesstoken = accessToken;
    //    [self.requestSerializer setValue:accessToken forHTTPHeaderField:@"AccessToken"];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                                 callback:(void (^)(id data, NSError *error))block {
    return [self requestWithPath:path requestParams:params networkMethod:method needPaging:NO checkForceUpdate:NO autoShowError:NO callback:block];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                               needPaging:(BOOL)needPaging
                                 callback:(void (^)(id data, NSError *error))block {
    return [self requestWithPath:path requestParams:params networkMethod:method needPaging:needPaging checkForceUpdate:NO autoShowError:NO callback:block];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                         checkForceUpdate:(BOOL)needCheck
                                 callback:(void (^)(id data, NSError *error))block {
    return [self requestWithPath:path requestParams:params networkMethod:method needPaging:NO checkForceUpdate:needCheck autoShowError:NO callback:block];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                            autoShowError:(BOOL)showError
                                 callback:(void (^)(id data, NSError *error))block {
    return [self requestWithPath:path requestParams:params networkMethod:method needPaging:NO checkForceUpdate:NO autoShowError:showError callback:block];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                               needPaging:(BOOL)needPaging
                            autoShowError:(BOOL)showError
                                 callback:(void (^)(id data, NSError *error))block {
    return
        [self requestWithPath:path requestParams:params networkMethod:method needPaging:needPaging checkForceUpdate:NO autoShowError:showError callback:block];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                               needPaging:(BOOL)needPaging
                         checkForceUpdate:(BOOL)needCheck
                            autoShowError:(BOOL)showError
                                 callback:(void (^)(id data, NSError *error))block {
    if (!path || path.length <= 0) {
        return nil;
    }
    // log请求数据
    DDLogDebug(@"\n===========request===========\n%@\n%@:\n%@", NetworkMethodList[method], path, params);
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // add token
    NSMutableDictionary *tempParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    //    LeieBabyData *myBabyInfo = (LeieBabyData *)[[LeieUserDataManager defaultInstance] loadObject:APPBABYDATA];
    //    [tempParams setObject:_acesstoken forKey:@"sno"];
    //    [tempParams setObject:_platformID forKey:@"plat"];
    //    DDLogDebug(@"babyId = %@", myBabyInfo.babyId);
    //    if (myBabyInfo.babyId && ![[tempParams leie_getObjectByPath:KEY_CUSTOM_IGNORE_BABYID] boolValue]) {
    //        [tempParams setObject:myBabyInfo.babyId forKey:@"babyId"];
    //    }
    //    [tempParams setObject:@"IOS_Temp" forKey:@"appId"];
    //
    //    if (needPaging) {
    //        [tempParams setObject:[NSString stringWithFormat:@"%d", kPagingNum] forKey:@"limit"];
    //    }

    // 注入验证强制更新参数
    [self ForceUpdateDetectInject:needCheck];
    @weakify(self);
    //    发起请求
    switch (method) {
        case GET: {
            return [self GET:path
                parameters:tempParams
                success:^(NSURLSessionTask *task, id responseObject) {
                  @strongify(self);
                  DDLogDebug(@"\n===========response===========\n%@:\n%@", path, responseObject);
                  if (needCheck) {
                      [XJFNetworkManager ForceUpdateResponseAnalyze:responseObject]; /* 判断是否需要提示强制更新 */
                  }
                  id error = [self handleResponse:responseObject autoShowError:showError];
                  if (error) {
                      [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_common_request_failed")];
                      block(responseObject, error);
                  } else {
                      block(responseObject, nil);
                  }
                }
                failure:^(NSURLSessionTask *task, NSError *error) {
                  //                  @strongify(self);
                  DDLogDebug(@"\n===========response===========\n%@:\n%@", path, error);
                  //                  !showError || [self showError:error];
                  block(nil, error);
                }];
            break;
        }
        case POST: {
            //            return [self POST:path
            //                parameters:tempParams
            //                success:^(NSURLSessionTask *task, id responseObject) {
            //                  @strongify(self);
            //                  DDLogDebug(@"\n===========response===========\n%@:\n%@", path, responseObject);
            //                  if (needCheck) {
            //                      [UNICNetworkManager ForceUpdateResponseAnalyze:responseObject]; /* 判断是否需要提示强制更新 */
            //                  }
            //                  id error = [self handleResponse:responseObject autoShowError:showError];
            //                  if (error) {
            //                      [[UNICHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_common_request_failed")];
            //                      block(responseObject, error);
            //                  } else {
            //                      block(responseObject, nil);
            //                  }
            //                }
            //                failure:^(NSURLSessionTask *task, NSError *error) {
            //                  //                  @strongify(self);
            //                  DDLogDebug(@"\n===========response===========\n%@:\n%@", path, error);
            //                  //                  !showError || [self showError:error];
            //                  block(nil, error);
            //                }];
            NSString *reqURL = [NSString stringWithFormat:@"http://%@", [XJFServerManager shareManager].serverURL];
            reqURL = [reqURL stringByAppendingString:path];
            NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:reqURL parameters:nil error:nil];
            [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            req.timeoutInterval = 60.0f;
            [req setHTTPBody:[tempParams mj_JSONData]];
            [[self dataTaskWithRequest:req
                     completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
                       if (!error) {
                           if ([responseObject isKindOfClass:[NSDictionary class]]) {
                               if ([[responseObject leie_getObjectByPath:@"result"] integerValue] == 0) {
                                   block(responseObject, nil);
                               } else {
                                   DDLogDebug(@"\n===========response===========\n%@:\n%@", path, [responseObject leie_getObjectByPath:@"message"]);
                                   block(responseObject, [XJFNetworkManager shareManager].errorDataNotDiction);
                               }
                           } else {
                               block(nil, [XJFNetworkManager shareManager].errorDataNotDiction);
                           }
                       } else {
                           [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_common_request_failed")];
                           DDLogDebug(@"\n===========response===========\n%@:\n%@", path, error);
                           block(responseObject, error);
                       }
                     }] resume];
            break;
        }
        case PUT: {
            return [self PUT:path
                parameters:tempParams
                success:^(NSURLSessionTask *task, id responseObject) {
                  @strongify(self);
                  DDLogDebug(@"\n===========response===========\n%@:\n%@", path, responseObject);
                  if (needCheck) {
                      [XJFNetworkManager ForceUpdateResponseAnalyze:responseObject]; /* 判断是否需要提示强制更新 */
                  }
                  id error = [self handleResponse:responseObject autoShowError:showError];
                  if (error) {
                      [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_common_request_failed")];
                      block(responseObject, error);
                  } else {
                      block(responseObject, nil);
                  }
                }
                failure:^(NSURLSessionTask *task, NSError *error) {
                  //                  @strongify(self);
                  DDLogDebug(@"\n===========response===========\n%@:\n%@", path, error);
                  //                  !showError || [self showError:error];
                  block(nil, error);
                }];
            break;
        }
        case DELETE: {
            return [self DELETE:path
                parameters:tempParams
                success:^(NSURLSessionTask *task, id responseObject) {
                  @strongify(self);
                  DDLogDebug(@"\n===========response===========\n%@:\n%@", path, responseObject);
                  if (needCheck) {
                      [XJFNetworkManager ForceUpdateResponseAnalyze:responseObject]; /* 判断是否需要提示强制更新 */
                  }
                  id error = [self handleResponse:responseObject autoShowError:showError];
                  if (error) {
                      [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_common_request_failed")];
                      block(responseObject, error);
                  } else {
                      block(responseObject, nil);
                  }
                }
                failure:^(NSURLSessionTask *task, NSError *error) {
                  //                  @strongify(self);
                  DDLogDebug(@"\n===========response===========\n%@:\n%@", path, error);
                  //                  !showError || [self showError:error];
                  block(nil, error);
                }];
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - NetError
- (id)handleResponse:(id)responseJSON {
    return [self handleResponse:responseJSON autoShowError:YES];
}

- (id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError {
    NSError *error = nil;
    // status为非0值时，表示有错
    NSNumber *status = [responseJSON valueForKeyPath:@"status"];

    if (status.intValue != 0) {
        error = [NSError errorWithDomain:[XJFServerManager shareManager].serverURL code:status.intValue userInfo:responseJSON];
    }
    return error;
}
@end

#pragma mark - Force Update version
@implementation AFHTTPSessionManager (ForceUpdate)
- (void)ForceUpdateDetectInject:(BOOL)needCheck {
    if (needCheck) {
        // 强制更新所需参数注入
        [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"device"];
        //        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        [self.requestSerializer setValue:version forHTTPHeaderField:@"version"];  // 0.0.20160419.0
    } else {
        // 因为是单例的,如果之前有请求注册过强制验证,需要删除强制更新所需参数注入
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"device"];
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"version"];
    }
}

#define kForceUpdateErrorCode @"999999"
#define kNormalUpdateErrorCode @"99904"
+ (void)ForceUpdateResponseAnalyze:(id)response {
    NSString *status = [response leie_getObjectByPath:@"head/status"];
    if (status && (1 == [status intValue])) {
        NSString *errorCode = [response leie_getObjectByPath:@"body/errorcode"];

        if (errorCode && [errorCode isEqualToString:kForceUpdateErrorCode]) {
            /* 通知需要强制更新,各模块需要做自己相应的处理 */
            [[NSNotificationCenter defaultCenter] postNotificationName:kForceUpdateVersionNotification object:nil];
            /* 由于服务器端无法在此处返回弹框信息,所以还需要再post一个消息让,登陆模块去获取更新信息 */
            [[NSNotificationCenter defaultCenter] postNotificationName:kShouldFetchForceUpdateInfoNotification object:nil];
        }
    }
}
@end

#pragma mark - Upload Data
@implementation AFHTTPSessionManager (UploadData)
- (NSURLSessionDataTask *)requestWithMethod:(NetworkMethod)method
                                        url:(NSString *)URLString
                                 parameters:(id)parameters
                  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                                   progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))upLoadProgress
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    return [self requestWithMethod:method
                               url:URLString
                        parameters:parameters
                  checkForceUpdate:NO
         constructingBodyWithBlock:block
                          progress:upLoadProgress
                           success:success
                           failure:failure];
}

- (NSURLSessionDataTask *)requestWithMethod:(NetworkMethod)method
                                        url:(NSString *)URLString
                                 parameters:(id)parameters
                           checkForceUpdate:(BOOL)needCheck
                  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                                   progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))upLoadProgress
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSString *requestMethod = @"POST";
    if (PUT == method) {
        requestMethod = @"PUT";
    }
    NSError *serializationError = nil;
    NSMutableURLRequest *request =
        [self.requestSerializer multipartFormRequestWithMethod:requestMethod
                                                     URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
                                                    parameters:parameters
                                     constructingBodyWithBlock:block
                                                         error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
              failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }

        return nil;
    }

    // 注入验证强制更新参数
    [self ForceUpdateDetectInject:needCheck];

    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request
                                                                    progress:nil
                                                           completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
                                                             if (error) {
                                                                 if (failure) {
                                                                     failure(task, error);
                                                                 }
                                                             } else {
                                                                 if (success) {
                                                                     success(task, responseObject);
                                                                 }
                                                             }
                                                           }];

    [task resume];

    return task;
}

@end

#pragma mark - Download File
@implementation AFHTTPSessionManager (DownLoadData)
- (NSURLSessionDownloadTask *)downloadWithUrl:(NSString *)url
                                   tofilePath:(NSString *)file
                                     progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
                                      success:(void (^)(NSURLSessionDownloadTask *task, NSURLResponse *response))success
                                      failure:(void (^)(NSURLSessionDownloadTask *task, NSError *error))failure {
    NSURL *remoteUrl;
    if ([url isKindOfClass:[NSURL class]]) {
        remoteUrl = (NSURL *)url;
    } else {
        remoteUrl = [NSURL URLWithString:url];
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:remoteUrl];
    NSString *token = [self.requestSerializer valueForHTTPHeaderField:@"AccessToken"];
    [request setValue:token forHTTPHeaderField:@"AccessToken"];

    NSURLSessionDownloadTask *task = [self downloadTaskWithRequest:request
        progress:nil
        destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
          return [NSURL fileURLWithPath:file];
        }
        completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
          if (!error) {
              if (success) {
                  success(task, response);
              }
          } else {
              if (failure) {
                  failure(task, error);
              }
          }
        }];

    [task resume];

    return task;
}

- (NSURLSessionDownloadTask *)downloadTaskWithUrl:(NSString *)url
                                         progress:(NSProgress *)progress
                                      destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    NSURL *remoteUrl;
    if ([url isKindOfClass:[NSURL class]]) {
        remoteUrl = (NSURL *)url;
    } else {
        remoteUrl = [NSURL URLWithString:url];
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:remoteUrl];
    NSString *token = [self.requestSerializer valueForHTTPHeaderField:@"AccessToken"];
    [request setValue:token forHTTPHeaderField:@"AccessToken"];

    NSURLSessionDownloadTask *task = [self downloadTaskWithRequest:request progress:nil destination:destination completionHandler:completionHandler];
    [task resume];
    return task;
}
@end
