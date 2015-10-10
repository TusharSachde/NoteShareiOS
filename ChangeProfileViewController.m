//
//  ChangeProfileViewController.m
//  NoteShare
//
//  Created by Heba khan on 03/10/15.
//  Copyright © 2015 Heba khan. All rights reserved.
//

#import "ChangeProfileViewController.h"
#import "DataManger.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface ChangeProfileViewController ()<DataManageDelegate>

@end

@implementation ChangeProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [[DataManger sharedmanager]setDatamanagerdelegate:self];
    
    [self updateProfilePic];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateProfilePic
{
    _profilePic.layer.cornerRadius = _profilePic.frame.size.width / 2;
    [_profilePic.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [_profilePic.layer setBorderWidth: 2.0];
    _profilePic.clipsToBounds = YES;
    
    if ([[DataManger sharedmanager] getProfileImageStatus])
    {
        [_profilePic setImage:[UIImage imageWithData:[[DataManger sharedmanager] getProfileImage]]];
    }
    else{
        [_profilePic setImage:[UIImage imageNamed:@"userdefault_bg.png"]];
    }
    
    
    
}

- (IBAction)changeBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
            
        case 0:
            //camera clicked
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            
            break;
        case 1:
            //gallery clicked
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
        case 2:
            //Cancel Button Clicked"
            break;
    }
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    _profilePic.layer.cornerRadius = _profilePic.frame.size.width / 2;
    [_profilePic.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [_profilePic.layer setBorderWidth: 2.0];
    _profilePic.clipsToBounds = YES;
    
    _profilePic.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.videoURL = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.videoController = [[MPMoviePlayerController alloc] init];
    
    [self.videoController setContentURL:self.videoURL];
    
    [self.view addSubview:self.videoController.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.videoController];
    
    
    [self.videoController play];
    [self postProfilepic];
    
}

- (void)videoPlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // Stop the video player and remove it from view
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
    
    // Display a message
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Video Playback" message:@"Just finished the video playback. The video is now removed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}

-(void)postProfilepic
{
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *hashKey=@"";
        
       // NSString *imgName = [NSString stringWithFormat:@"Imagetest.jpg"];
        NSData *imgData=UIImagePNGRepresentation(_profilePic.image);
        
        [[DataManger sharedmanager]setProfileImage:imgData];
        [[DataManger sharedmanager]setProfileImageStatus:YES];
        NSString* urlstring = [NSString stringWithFormat:@"http://104.154.57.170/user/uploadfile"];
        
        
        NSURL *requestURL = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        
        [_params setObject:[NSString stringWithFormat:@"%@", [[DataManger sharedmanager] getUserId]] forKey:@"user"];
        
        // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
        NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
        
        // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
        NSString* FileParamConstant = @"file";
        
        
        // create request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:90];
        [request setHTTPMethod:@"POST"];
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        // add params (all params are strings)
        for (NSString *param in _params) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // add image data
        NSData *imageData = UIImageJPEGRepresentation((_profilePic.image), 1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        // set URL
        [request setURL:requestURL];
        
        NSURLResponse *response;
        NSError *error = nil;
        
        
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"result = %@",result);
        
        
        if (data)
        {
            id jsonResponse=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if([jsonResponse isKindOfClass:[NSDictionary class]])
                
            {
                
                hashKey=[jsonResponse valueForKey:@"fileid"];
                
                
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            
            [[DataManger sharedmanager]setProfileHashKey:hashKey];
            
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            
            
        });
    });
    
}


-(void)uploadProfilePic{
    
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        
        NSString *hashKey=@"";
        
        NSString *imgName = [NSString stringWithFormat:@"Imagetest.jpg"];
        NSData *imgData=UIImagePNGRepresentation(_profilePic.image);
        
        [[DataManger sharedmanager]setProfileImage:imgData];
        [[DataManger sharedmanager]setProfileImageStatus:YES];
        
        
        //UserDetail *detail=[[DataManger sharedmanager]getLoogedInUserdetail];
        
        NSString* urlstring = [NSString stringWithFormat:@"http://104.154.57.170/user/uploadfile"];
        
        
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //===============================================
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
        [postRequest setURL:url];
        [postRequest setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData  *body = [[NSMutableData alloc] init];
        //[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"file\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.png\"\".jpg\"\".jpeg\"\".gif\"\r\n",imgName]] dataUsingEncoding:NSUTF8StringEncoding]];//img name
        
        
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Add Image imgData is Declare as Above.
        [body appendData:[NSData dataWithData:imgData]];
        
        NSLog(@"Image Name %@",imgName);
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postRequest setHTTPBody:body];
        
        NSURLResponse *response;
        NSError *error = nil;
        
        
        NSData* data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
        NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"result = %@",result);
        
        
        if (data)
        {
            id jsonResponse=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if([jsonResponse isKindOfClass:[NSDictionary class]])
                
            {
                
                hashKey=[jsonResponse valueForKey:@"fileid"];
                
                
            }
            
        }

        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            
            
            [[DataManger sharedmanager]setProfileHashKey:hashKey];
            // [self parsing:hashKey];
            
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            
        });
    });
    
    
}

- (IBAction)choosePicBtn:(id)sender {
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
}
@end
