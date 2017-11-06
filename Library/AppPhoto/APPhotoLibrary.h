
#import <MobileCoreServices/UTCoreTypes.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

@protocol APPhotoPickerDelegate;

@protocol APPhotoPickerDelegate <NSObject>
-(void)apActionSheetGetImage:(UIImage *)selectedPhoto;
-(void)apActionSheetGetVideo:(NSURL *)selectedVideo;
-(void)apActionSheetGetVideoThumbImage:(UIImage *)selectedVideoThumbImage;
@end

@interface APPhotoLibrary : NSObject <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MPMoviePlayerController *player;
    NSArray *mediaTypeArray;
    NSString *cameraString;
    NSString *libraryString;

}

+(APPhotoLibrary *)sharedInstance;

@property(nonatomic,weak)UIViewController *controller;
@property(nonatomic,strong)UIActionSheet *actionSheet;

@property(nonatomic,weak)id <APPhotoPickerDelegate> delegate;

-(void)openPhotoFromCameraAndLibrary:(UIViewController *)controller;
-(void)openVideoFromCameraAndLibrary:(UIViewController *)controller;
-(void)openPhotoAndVideoFromCameraAndLibrary:(UIViewController *)controller;

@end


