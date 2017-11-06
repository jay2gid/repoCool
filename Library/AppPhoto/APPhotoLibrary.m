//
//  SmartAppTest
//
//  Created by Chirag Leuva on 3/19/13.
//  Copyright (c) 2013 AppMaggot. All rights reserved.
//
#import "APPhotoLibrary.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@implementation APPhotoLibrary
@synthesize delegate;

static APPhotoLibrary *object;

+(APPhotoLibrary *)sharedInstance{
    if(!object){
        object = [[APPhotoLibrary alloc]init];
    }
    return  object;
}

-(id)init;
{
    self = [super init];
    if(self) {
    }
    return self;
}

#pragma mark -openAction Sheet method

-(void)openPhotoFromCameraAndLibrary:(UIViewController *)controller{
    mediaTypeArray=@[(NSString *) kUTTypeImage];
    self.controller=controller;
    [self showActionSheet];
}
-(void)openVideoFromCameraAndLibrary:(UIViewController *)controller{
    player =[[MPMoviePlayerController alloc] init];
    mediaTypeArray=@[(NSString *) kUTTypeMovie];
    self.controller=controller;
    [self setNotifier];
    [self showActionSheet];
}
-(void)openPhotoAndVideoFromCameraAndLibrary:(UIViewController *)controller{
    player =[[MPMoviePlayerController alloc] init];
    mediaTypeArray=@[(NSString *) kUTTypeImage, (NSString *) kUTTypeMovie];
    self.controller=controller;
    [self setNotifier];
    [self showActionSheet];
}

#pragma mark -Support Method

-(void)setNotifier{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleThumbnailImageRequestFinishNotification:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                               object:player];
}
-(void)showActionSheet{
    cameraString=@"Take New";
    libraryString=@"Choose Existing";
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *sheet= [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:libraryString, nil];
        [sheet showInView:self.controller.view];
    }else{
        [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                      destructiveButtonTitle:nil
                           otherButtonTitles:cameraString,libraryString, nil]
         showInView:self.controller.view];
    }
}

#pragma mark -actionSheet delegate method

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.videoMaximumDuration = 12;
    
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:cameraString]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes=mediaTypeArray;
        [self.controller presentViewController:imagePicker animated:YES completion:nil];
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:libraryString])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary & UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.mediaTypes=mediaTypeArray;
        [self.controller presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark -imagePicker delegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [player.view setHidden:YES];
    NSString *mediaType = info [UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        [delegate apActionSheetGetImage:info [UIImagePickerControllerEditedImage]];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:imagePickerURL options:nil];
        CMTime duration = sourceAsset.duration;
        float seconds = CMTimeGetSeconds(duration);
        
        if ( seconds <13) {
            NSURL *originalUrl ;
            NSURL *fileUrl = [NSURL fileURLWithPath:[imagePickerURL path]];
            NSString *videoName = [self getVideoName];
            originalUrl = (NSURL*)[self videoConvertToMPEGFormat:[fileUrl absoluteString] withMediaName:videoName];
            [delegate apActionSheetGetVideo:fileUrl];
            [player setContentURL:fileUrl];
            [player requestThumbnailImagesAtTimes:@[[NSNumber numberWithFloat:0.1]]
                                       timeOption:MPMovieTimeOptionNearestKeyFrame];
        }
        else
        {
          //  showAletViewWithMessage(@"You cannot upload a video more than 12 secs");
        }
    }
    
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -Notification For Thumbnail image

-(void)handleThumbnailImageRequestFinishNotification:(NSNotification*)notifiation
{
    NSDictionary *userinfo = [notifiation userInfo];
    NSError* value = [userinfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    
    if (value!=nil){
        NSLog(@"Error: %@", [value debugDescription]);
    }
    else{
        [delegate apActionSheetGetVideoThumbImage:[userinfo valueForKey:MPMoviePlayerThumbnailImageKey]];
    }
    [player stop];
}

- (NSString *)getVideoName
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d", (int)time];
}

- (NSString *)videoConvertToMPEGFormat:(NSString *)oiginalPath withMediaName:(NSString*)mediaName {
    
    NSLog(@"_videoPath=%@",[NSURL URLWithString:oiginalPath]);
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:oiginalPath] options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSString *outputURLPath;
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        outputURLPath = [documentsDirectory stringByAppendingPathComponent:@"Videos"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:outputURLPath])
            [[NSFileManager defaultManager] createDirectoryAtPath :outputURLPath withIntermediateDirectories:YES attributes:nil error:nil];
        outputURLPath = [outputURLPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",mediaName]];
        
        exportSession.outputURL = [NSURL fileURLWithPath:outputURLPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Export canceled");
                    
                    break;
                    
                case AVAssetExportSessionStatusCompleted:
                    
                    NSLog(@"Export Completed");
                    
                    break;
                    
                default:
                    
                    break;
            }
            
        }];
        
    }
    return outputURLPath;
}


@end
