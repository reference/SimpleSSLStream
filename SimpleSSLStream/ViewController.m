//
//  ViewController.m
//  SimpleSSLStream
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc {
#ifdef PAYEE
    [str1 release];
    [mtData release];
#endif
    
    [stream closeSSLStream];
    [stream release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    stream = [[SSLStream alloc] initWithHost:your host port:your port];
    stream.delegate = self;
    
#ifdef PAYEE
    NSString *alloc_channel = [NSString stringWithFormat:@"protocol=%@&signature=%@&id=ios_%@&cmd=xxxxx", @"fafsdfasfljafsa1.0", @"yyyyyy", @"23423489aslksldfj"];
    [stream sendString:alloc_channel];
    
    str1=[[NSMutableString alloc] initWithCapacity:0];
    
    mtData = [[NSMutableData alloc] initWithCapacity:0];
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:imgView];
    [imgView release];
    
    concol = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    concol.backgroundColor = [UIColor blackColor];
    concol.textColor = [UIColor greenColor];
    concol.alpha = 0.5f;
    [self.view addSubview:concol];
    [concol release];
    
#else
    channel = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    channel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:channel];
    [channel release];
    
    UIButton *connect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [connect setTitle:@"conn" forState:UIControlStateNormal];
    [connect addTarget:self action:@selector(connectChnannel) forControlEvents:UIControlEventTouchUpInside];
    connect.frame = CGRectMake(130, 0, 100, 30);
    [self.view addSubview:connect];
    
#endif
    
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

- (void)connectChnannel{
    NSString *connect_channel = [NSString stringWithFormat:@"protocol=%@&id=ios_%@&channel=%@&cmd=connect_channel", @"flashme.communication.1.0",@"asdfasklnvaosv8as979", channel.text];
    [stream sendString:connect_channel];
}

#pragma mark - SSLStreamDelegate
- (void)SSLStream:(SSLStream*)sslStream didReceiveString:(NSString*)string{
    NSLog(@"-----response string is %@",string);
    
#ifndef PAYEE
    NSData *imgData = UIImagePNGRepresentation([UIImage imageNamed:@"Default.png"]);
    NSInteger len = [sslStream sendData:imgData];
    
    NSLog(@"pic len is %i, len is %i",[imgData length],len);
#endif
}

- (void)SSLStream:(SSLStream*)sslStream didReceiveData:(NSData*)data{
    NSLog(@"-----response data  len is %i",[data length]);
    
#ifdef PAYEE
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!output) {
        [mtData appendData:data];
    }
    
    [str1 appendFormat:[NSString stringWithFormat:@"receive data len is %i\n Resaponse string is %@\n",[data length],output]];
    concol.text = str1;
    
    UIImage *img = [UIImage imageWithData:mtData];
    if (img) {
        imgView.image = img;
        imgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    }
#endif
}

@end
