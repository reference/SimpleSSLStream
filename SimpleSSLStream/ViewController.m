//
//  ViewController.m
//  SimpleSSLStream
//
//  Created by sban@netspectrum.com on 7/9/12.
//  Copyright (c) 2012 Netspectrum Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SSLStream *stream = [[SSLStream alloc] initWithHost:@"flash2pay.com" port:60001];
    
    NSString *str = [NSString stringWithFormat:@"protocol=%@&signature=%@&id=ios_%@&cmd=allocate_channel", @"flashme.communication.1.0", @"device-signature-001", @"23423489aslksldfj"];
    [stream sendString:str];
    
    stream.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - SSLStreamDelegate
- (void)SSLStream:(SSLStream*)sslStream didReceiveString:(NSString*)string{
    NSLog(@"-----response string is %@",string);
}

- (void)SSLStream:(SSLStream*)sslStream didReceiveData:(NSData*)data{
    NSLog(@"-----response data is %@",data);
}

@end
