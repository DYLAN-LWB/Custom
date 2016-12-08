//
//  Network.h
//  Dealer
//
//  Created by 李伟宾 on 16/5/30.
//  Copyright © 2016年 Dealer_lwb. All rights reserved.
//

#ifndef Network_h
#define Network_h

#import "RequestManager.h"

#define HTTP_POST    @"POST"
#define HTTP_GET     @"GET"

#define WBUserID @"3"
#define WBUserKey @"de7f1f42282da6c604a882350909fd94"


#define BasicUrl @"http://shop.51titi.net"   // 线上测试环境

#define RequestName(name)   [NSString stringWithFormat:@"%@/%@", BasicUrl, name]

#define TEST1  RequestName(@"showbooks/booklist")
#define TEST2  RequestName(@"showbooks/photolist")


#endif /* Network_h */






//-----------GET-----------

//NSString *url = [NSString stringWithFormat:@"%@", GET_BookGategory];
//[[RequestManager sharedManger] requestWithMethod:HTTP_GET url:GET_AddressList params:nil
//                                         success:^(id response) {
//
//                                             if (WBInteger(response[@"code"]) == 0) {
//
//                                             }
//                                         }
//                                         failure:^(NSError *error) {
//                                             WBShowToastMessage(ErrorMsg);
//                                         }];

 //-----------POST-----------
 
 //NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
 //param[@"uid"] = WBUserID;
 //param[@"key"] = WBUserKey;
 //
 //[[RequestManager sharedManger] requestWithMethod:HTTP_POST
 //                                             url:POST_ApplyForms
 //                                          params:param
 //                                         success:^(id response) {
 //
 //                                             if (WBInteger(response[@"code"]) == 0) {
 //                                             }
 //
 //                                         }
 //                                         failure:^(NSError *error) {
 //                                             WBShowToastMessage(ErrorMsg);
 //                                         }];
 
 
