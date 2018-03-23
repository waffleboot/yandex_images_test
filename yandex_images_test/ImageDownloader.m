
#import "ImageDownloader.h"
#import "yandex_images_test-Swift.h"

static NSTimeInterval kLongRunningTaskTimeout = 300;

@interface ImageSource ()
@property (atomic, weak) Item *activeItem;
@property (nonatomic) NSDate *activeItemStartTime;
@property (nonatomic) NSCondition *lock;
@property (nonatomic) NSURLSessionDataTask *task;
@property (nonatomic) NSMutableSet<Token *> *tokens;
@property (nonatomic) NSOperationQueue *queue;
@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURL *url;
@end

@implementation ImageSource

- (instancetype)init {
    if (self = [super init]) {
        self.tokens = [NSMutableSet set];
        
        self.lock = [[NSCondition alloc] init];
        
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
        self.url = [NSURL URLWithString:@"https://placeimg.com/200/200/any"];
        
    }
    return self;
}

- (void)getImageForItem:(Item *)item {
    if (![self.tokens containsObject:item.token]) {
        [self.tokens addObject:item.token];
        [self enqueueItem:item];
    }
}

- (void)enqueueItem:(Item *)item {
    Token *token = item.token;
    __weak Item *weakItem = item;
    [self.queue addOperationWithBlock:^{
        Item *strongItem = weakItem;
        if (strongItem) {
            [self downloadImageForItem:strongItem];
        } else {
            [self.tokens removeObject:token];
        }
    }];
}

- (BOOL)tryHttpLock {
    [self.lock lock];
    while (self.activeItem) {
        if (![self.lock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:kLongRunningTaskTimeout]]) {
            [self.lock unlock];
            return NO;
        }
    }
    return YES;
}

- (Item*)unlockHttpLock {
    [self.lock lock];
    Item *item = self.activeItem;
    self.activeItem = nil;
    [self.lock signal]; // for waitUntilDone
    [self.lock unlock];
    return item;
}

- (void)downloadImageForItem:(Item *)item {
    if (![self tryHttpLock]) {
        [self enqueueItem:item];
        [self restartLongRunningTask];
        return;
    }
    [self runHttpRequestForItem:item];
    [self.lock unlock];
}

- (void)runHttpRequestForItem:(Item *)item {
    self.activeItem = item;
    self.activeItemStartTime = [NSDate date];
    Token *token = item.token;
    __weak Item *weakItem = item;
    self.task = [self.session dataTaskWithURL:self.url
                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                [self unlockHttpLock];
                                [self.tokens removeObject:token];
                                Item *strongItem = weakItem;
                                if (!error && strongItem) {
                                    [self updateItem:strongItem withImage:data];
                                }
                            }];
    [self.task resume];
}

- (void)restartLongRunningTask {
    [self.task cancel];
    Item *item = [self unlockHttpLock];
    if (item) {
        [self enqueueItem:item];
    }
}

- (void)updateItem:(Item *)item withImage:(NSData *)data {
    [self.delegate imageSource:self didUpdateItem:item withImageData:data];
}

@end
