
#import <Foundation/Foundation.h>

@class Item;
@class ImageSource;

@protocol ImageSourceDelegate
- (void)imageSource:(ImageSource * _Nonnull)imageSource
      didUpdateItem:(Item * _Nonnull)item
      withImageData:(NSData * _Nonnull)imageData;
@end

@interface ImageSource : NSObject
@property (nonatomic) id<ImageSourceDelegate> _Nonnull delegate;
- (void)getImageForItem:(Item * _Nonnull)item;
@end
