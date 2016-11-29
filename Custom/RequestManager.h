//
//  RequestManager.h
//  Basic
//
//  Created by 李伟宾 on 15/11/30.
//  Copyright © 2015年 李伟宾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface FileModel : NSObject

/** 服务器给的字段名称*/
@property(nonatomic, copy) NSString *name;
/** 图片数据 */
@property(nonatomic, strong) NSData *fileData;

+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename;

@end

/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,HttpRequestType) {

    HttpRequestTypeGet = 0,     //get请求
    HttpRequestTypePost         //post请求
};

@interface RequestManager : NSObject

/**
 *  发送网络请求
 *
 *  @param URLString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param type        请求的类型
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 */
+ (NSURLSessionTask *)requestWithURLString:(NSString *)URLString
                                parameters:(NSMutableDictionary *)parameters
                                      type:(HttpRequestType)type
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *error))failure;

/**
 *  上传或者下载的进度
 *
 *  @param progress 进度
 */
typedef void (^RequestProgress)(NSProgress *progress);

/**
 *  上传图片
 *
 *  @param URLString   上传图片的网址字符串
 *  @param parameters  上传图片的参数
 *  @param uploadParam 上传图片的信息
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 */
+ (NSURLSessionTask *)uploadWithURLString:(NSString *)URLString
                               parameters:(NSMutableDictionary *)parameters
                                 progress:(RequestProgress)progress
                              uploadParam:(FileModel *)uploadParam
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *error))failure;

/**
 *  下载文件
 *
 *  @param URLString 下载请求地址
 *  @param fileURL   文件保存地址
 *  @param progress  进度
 *  @param success   请求成功回调
 *  @param failure   请求失败回调
 *
 *  @return NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，重新开启下载调用resume方法
 */
+(NSURLSessionDownloadTask *)downloadWithURLString:(NSString *)URLString
                                       savePathURL:(NSURL *)fileURL
                                          progress:(RequestProgress )progress
                                           success:(void (^)(id response))success
                                           failure:(void (^)(NSError *error))failure;


@end
