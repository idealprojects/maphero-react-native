#import "MLRNLogging.h"

@import MapHero;

@interface MLRNLogging()
@property (nonatomic) BOOL hasListeners;
@end

@implementation MLRNLogging

+ (id)allocWithZone:(NSZone *)zone {
    static MLRNLogging *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

-(id)init {
    if ( self = [super init] ) {
        self.loggingConfiguration = [MHLoggingConfiguration sharedConfiguration];
        [self.loggingConfiguration  setLoggingLevel:MHLoggingLevelWarning];
        __weak typeof(self) weakSelf = self;
        self.loggingConfiguration.handler = ^(MHLoggingLevel loggingLevel, NSString *filePath, NSUInteger line, NSString *message) {
            [weakSelf sendLogWithLevel:loggingLevel filePath: filePath line: line message: message];
        };
    }
    return self;
}

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"LogEvent"];
}

- (void)startObserving
{
    [super startObserving];
    self.hasListeners = true;
}

- (void)stopObserving
{
    [super stopObserving];
    self.hasListeners = false;
}

- (void)sendLogWithLevel:(MHLoggingLevel)loggingLevel filePath:(NSString*)filePath line:(NSUInteger)line message:(NSString*)message
{
    if (!self.hasListeners) return;

    NSString* level = @"n/a";
    switch (loggingLevel) {
    case MHLoggingLevelInfo:
        level = @"info";
        break;
    case MHLoggingLevelError:
        level = @"error";
        break;
#if MLN_LOGGING_ENABLE_DEBUG
    case MHLoggingLevelDebug:
        level = @"debug";
        break;
#endif
    case MHLoggingLevelWarning:
        level = @"warning";
        break;
    case MHLoggingLevelNone:
        level = @"none";
        break;
    case MHLoggingLevelFault:
        level = @"fault";
        break;
    case MHLoggingLevelVerbose:
        level = @"verbose";
        break;
    }

    NSString* type = nil;
    if ([message hasPrefix:@"Failed to load glyph range"]) {
        type = @"missing_font";
    }

    NSMutableDictionary* body = [@{
        @"level": level,
        @"message": message,
        @"filePath": filePath,
        @"line": @(line)
    } mutableCopy];

    if (type != nil) {
        body[@"type"] = type;
    }
    [self sendEventWithName:@"LogEvent" body:body];
}

RCT_EXPORT_METHOD(setLogLevel: (nonnull NSString*)logLevel)
{
    MHLoggingLevel mlnLogLevel = MHLoggingLevelNone;
    if ([logLevel isEqualToString:@"none"]) {
        mlnLogLevel = MHLoggingLevelNone;
    } else if ([logLevel isEqualToString:@"debug"]) {
        mlnLogLevel = MHLoggingLevelInfo;
    } else if ([logLevel isEqualToString:@"fault"]) {
        mlnLogLevel = MHLoggingLevelFault;
    } else if ([logLevel isEqualToString:@"error"]) {
        mlnLogLevel = MHLoggingLevelError;
    } else if ([logLevel isEqualToString:@"warning"]) {
        mlnLogLevel = MHLoggingLevelWarning;
    } else if ([logLevel isEqualToString:@"info"]) {
        mlnLogLevel = MHLoggingLevelInfo;
    } else if ([logLevel isEqualToString:@"debug"]) {
#if MLN_LOGGING_ENABLE_DEBUG
        mlnLogLevel = MHLoggingLevelDebug;
#else
        mlnLogLevel = MHLoggingLevelVerbose;
#endif
    } else if ([logLevel isEqualToString:@"verbose"]) {
        mlnLogLevel = MHLoggingLevelVerbose;
    }
    self.loggingConfiguration.loggingLevel = mlnLogLevel;
}

@end
