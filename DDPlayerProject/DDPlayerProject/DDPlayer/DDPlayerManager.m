//
//  DDPlayerManager.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerManager.h"

@implementation DDPlayerManager

+ (UIImage *)thumbnailImageWithAsset:(AVAsset*)asset currentTime:(CMTime)currentTime {
    
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"isReadable %d",[(AVURLAsset*)asset isReadable]);
    NSLog(@"isExport %d",[(AVURLAsset*)asset isExportable]);
    NSLog(@"isPlayable %d",[(AVURLAsset*)asset isPlayable]);
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    CMTime expectedTime = currentTime;
    CGImageRef cgImage = NULL;
    
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    
    if (!cgImage) {
        imageGenerator.requestedTimeToleranceBefore = kCMTimePositiveInfinity;
        imageGenerator.requestedTimeToleranceAfter = kCMTimePositiveInfinity;
        cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    }
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

+ (AVAssetExportSession*)captureVideoWithAsset:(AVAsset *)asset startTime:(CMTime)startTime duration:(NSTimeInterval)duration progress:(void (^)(CGFloat))progress success:(void (^)(NSString * _Nonnull))success failure:(void (^)(void))failure{
    
    if (asset.isExportable == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure();
        });
        return nil;
    }
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    CMTime videoDuration = CMTimeMakeWithSeconds(duration, asset.duration.timescale);
    CMTimeRange videoTimeRange = CMTimeRangeMake(startTime, videoDuration);
    
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionVideoTrack insertTimeRange:videoTimeRange ofTrack:([asset tracksWithMediaType:AVMediaTypeVideo].count>0) ? [asset tracksWithMediaType:AVMediaTypeVideo].firstObject : nil atTime:kCMTimeZero error:nil];
    [compositionVoiceTrack insertTimeRange:videoTimeRange ofTrack:([asset tracksWithMediaType:AVMediaTypeAudio].count>0)?[asset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];
    
    NSString *presetName = AVAssetExportPresetPassthrough;
    
    if ([[AVAssetExportSession exportPresetsCompatibleWithAsset:mixComposition] containsObject: AVAssetExportPreset1920x1080]) {
        presetName = AVAssetExportPreset1920x1080;
    }
    
    AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:presetName];
    
    NSString *outPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"capture.mp4"];
    NSURL *outPutURL = [NSURL fileURLWithPath:outPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPath error:nil];
    }
    
    assetExportSession.outputFileType = AVFileTypeMPEG4;
    assetExportSession.outputURL = outPutURL;
    
    assetExportSession.shouldOptimizeForNetworkUse = YES;
    
    if (assetExportSession == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure();
        });
        return nil;
    }else {
        [assetExportSession exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (assetExportSession.status == AVAssetExportSessionStatusCompleted) {
                    NSLog(@"%@",outPath);
                    success(outPath);
                }else if (assetExportSession.status == AVAssetExportSessionStatusCancelled) {
                    failure();
//                    [self uploadCaptureVideoCancel];
                }else {
                    failure();
//                    [self uploadCaptureVideoFail];
                }
            });
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            while (assetExportSession.status == AVAssetExportSessionStatusWaiting || assetExportSession.status == AVAssetExportSessionStatusExporting) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    progress(assetExportSession.progress);
                });
            }
        });
        
        return assetExportSession;
    }
}

@end
