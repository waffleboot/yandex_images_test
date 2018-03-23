
#import "ImageDownloader.h"
#import "yandex_images_test-Swift.h"

@implementation ImageDownloader

- (void)downloadItem:(Item *)item {
    item.image = UIImagePNGRepresentation([UIImage imageNamed:@"nature"]);    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    NSURL *url = [NSURL URLWithString:@"http://lorempixel.com/400/200/nature/"];
//    __weak Item* weakItem = item;
//    [session dataTaskWithURL:url
//           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//               if (!error) {
//                   Item* item = weakItem;
//                   if (item) {
////                       item.data = nil;
//                   }
//               }
//    }];
}

@end
