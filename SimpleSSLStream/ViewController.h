//
//  ViewController.h
//  SimpleSSLStream
//
//  Created by sban@netspectrum.com on 7/9/12.
//  Copyright (c) 2012 Netspectrum Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLStream.h"

#define PAYEE
@interface ViewController : UIViewController<SSLStreamDelegate>{
    NSMutableString *str1;
    UITextField *channel;
    SSLStream *stream;
    
    NSMutableData *mtData;
    UIImageView *imgView;
    UITextView *concol;
}

@end
