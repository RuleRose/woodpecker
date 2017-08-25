//
//  LeieNetworkManager.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/8.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"

typedef NS_ENUM(NSUInteger, NetworkMethod) { GET = 0, POST, PUT, DELETE };

#define kForceUpdateVersionNotification @"kForceUpdateVersionNotification"
#define kShouldFetchForceUpdateInfoNotification @"kShouldFetchForceUpdateInfoNotification"
#define kAppID @"1040400126"
#define kPagingNum 20

#define KEY_CUSTOM_IGNORE_BABYID @"CUSTOM_IGNORE_BABYID"

@interface XJFNetworkManager : AFHTTPSessionManager
@property(nonatomic, strong) AFNetworkReachabilityManager *networkReachability;
@property(nonatomic, strong) NSError *errorDataNotDiction;
+ (XJFNetworkManager *)shareManager;
+ (instancetype)networkManager;

/**
 *  判断网络状态
 */
- (BOOL)isReachable;

/**
 *  网络类型
 */
- (AFNetworkReachabilityStatus)NetworkType;

/**
 *  设置accessToken
 *
 *  @param accessToken 用户token
 */
- (void)setAuthorization:(NSString *)accessToken;

/**
 *  请求服务器数据
 *
 *  @param path      API接口
 *  @param params    参数
 *  @param method    GET/POST/PUT/DELETE
 *  @param block     成功/失败回调
 */
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                                 callback:(void (^)(id data, NSError *error))block;

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                               needPaging:(BOOL)needPaging
                                 callback:(void (^)(id data, NSError *error))block;
/**
 * @param needCheck 是否验证强制更新
 */
//- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
//                            requestParams:(NSDictionary *)params
//                            networkMethod:(NetworkMethod)method
//                         checkForceUpdate:(BOOL)needCheck
//                                 callback:(void (^)(id data, NSError *error))block;

/**
 *  请求服务器数据
 *
 *  @param path      API接口
 *  @param params    参数
 *  @param method    GET/POST/PUT/DELETE
 *  @param showError 是否显示错误
 *  @param block     成功/失败回调
 */
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                            autoShowError:(BOOL)showError
                                 callback:(void (^)(id data, NSError *error))block;

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                            requestParams:(NSDictionary *)params
                            networkMethod:(NetworkMethod)method
                               needPaging:(BOOL)needPaging
                            autoShowError:(BOOL)showError
                                 callback:(void (^)(id data, NSError *error))block;

/**
 * @param needCheck 是否验证强制更新
 */
//- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
//                            requestParams:(NSDictionary *)params
//                            networkMethod:(NetworkMethod)method
//                         checkForceUpdate:(BOOL)needCheck
//                            autoShowError:(BOOL)showError
//                                 callback:(void (^)(id data, NSError *error))block;
@end

#pragma mark - Force Update version
@interface AFHTTPSessionManager (ForceUpdate)
- (void)ForceUpdateDetectInject:(BOOL)needCheck;

+ (void)ForceUpdateResponseAnalyze:(id)response;
@end

#pragma mark - AF PUT/POST upload file.
@interface AFHTTPSessionManager (UploadData)
- (NSURLSessionDataTask *)requestWithMethod:(NetworkMethod)method
                                        url:(NSString *)URLString
                                 parameters:(id)parameters
                  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                                   progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))upLoadProgress
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 * @param needCheck 是否验证强制更新
 */
//- (NSURLSessionDataTask *)requestWithMethod:(NetworkMethod)method
//                                        url:(NSString *)URLString
//                                 parameters:(id)parameters
//                           checkForceUpdate:(BOOL)needCheck
//                  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
//                                   progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten,
//                                                      long long totalBytesExpectedToWrite))upLoadProgress
//                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

#pragma mark DownLoadFile -
@interface AFHTTPSessionManager (DownLoadData)
- (NSURLSessionDownloadTask *)downloadWithUrl:(NSString *)url
                                   tofilePath:(NSString *)file
                                     progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block
                                      success:(void (^)(NSURLSessionDownloadTask *task, NSURLResponse *response))success
                                      failure:(void (^)(NSURLSessionDownloadTask *task, NSError *error))failure;

/**
 *  task 在方法里面已经自动开始([task resume]),
 *  返回出来是给外部提供 暂停([task suspend])、取消([task cancel])、或续传
 *
 *  @param url               需要下载文件的链接
 *  @param progress          下载进度
 *  @param destination ！！!需要返回一个本地路径,用以保存下载的文件
 *  @param completionHandler 下载完成的回调
 *
 *  @return 当前下载任务实例
 */
- (NSURLSessionDownloadTask *)downloadTaskWithUrl:(NSString *)url
                                         progress:(NSProgress *)progress
                                      destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@end
