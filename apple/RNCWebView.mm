// This guard prevent the code from being compiled in the old architecture
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCCarefreesWebView.h"
#import "RNCCarefreesWebViewImpl.h"

#import <react/renderer/components/RNCCarefreesWebViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNCCarefreesWebViewSpec/EventEmitters.h>
#import <react/renderer/components/RNCCarefreesWebViewSpec/Props.h>
#import <react/renderer/components/RNCCarefreesWebViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

auto stringToOnShouldStartLoadWithRequestNavigationTypeEnum(std::string value) {
    if (value == "click") return RNCCarefreesWebViewEventEmitter::OnShouldStartLoadWithRequestNavigationType::Click;
    if (value == "formsubmit") return RNCCarefreesWebViewEventEmitter::OnShouldStartLoadWithRequestNavigationType::Formsubmit;
    if (value == "backforward") return RNCCarefreesWebViewEventEmitter::OnShouldStartLoadWithRequestNavigationType::Backforward;
    if (value == "reload") return RNCCarefreesWebViewEventEmitter::OnShouldStartLoadWithRequestNavigationType::Reload;
    if (value == "formresubmit") return RNCCarefreesWebViewEventEmitter::OnShouldStartLoadWithRequestNavigationType::Formresubmit;
    return RNCCarefreesWebViewEventEmitter::OnShouldStartLoadWithRequestNavigationType::Other;
}

auto stringToOnLoadingStartNavigationTypeEnum(std::string value) {
    if (value == "click") return RNCCarefreesWebViewEventEmitter::OnLoadingStartNavigationType::Click;
    if (value == "formsubmit") return RNCCarefreesWebViewEventEmitter::OnLoadingStartNavigationType::Formsubmit;
    if (value == "backforward") return RNCCarefreesWebViewEventEmitter::OnLoadingStartNavigationType::Backforward;
    if (value == "reload") return RNCCarefreesWebViewEventEmitter::OnLoadingStartNavigationType::Reload;
    if (value == "formresubmit") return RNCCarefreesWebViewEventEmitter::OnLoadingStartNavigationType::Formresubmit;
    return RNCCarefreesWebViewEventEmitter::OnLoadingStartNavigationType::Other;
}

auto stringToOnLoadingFinishNavigationTypeEnum(std::string value) {
    if (value == "click") return RNCCarefreesWebViewEventEmitter::OnLoadingFinishNavigationType::Click;
    if (value == "formsubmit") return RNCCarefreesWebViewEventEmitter::OnLoadingFinishNavigationType::Formsubmit;
    if (value == "backforward") return RNCCarefreesWebViewEventEmitter::OnLoadingFinishNavigationType::Backforward;
    if (value == "reload") return RNCCarefreesWebViewEventEmitter::OnLoadingFinishNavigationType::Reload;
    if (value == "formresubmit") return RNCCarefreesWebViewEventEmitter::OnLoadingFinishNavigationType::Formresubmit;
    return RNCCarefreesWebViewEventEmitter::OnLoadingFinishNavigationType::Other;
}

@interface RNCCarefreesWebView () <RCTRNCCarefreesWebViewViewProtocol>

@end

@implementation RNCCarefreesWebView {
    RNCCarefreesWebViewImpl * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<RNCCarefreesWebViewComponentDescriptor>();
}

// Reproduce the idea from here: https://github.com/facebook/react-native/blob/8bd3edec88148d0ab1f225d2119435681fbbba33/React/Fabric/Mounting/ComponentViews/InputAccessory/RCTInputAccessoryComponentView.mm#L142
- (void)prepareForRecycle {
    [super prepareForRecycle];
    [_view destroyWebView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        static const auto defaultProps = std::make_shared<const RNCCarefreesWebViewProps>();
        _props = defaultProps;
        
        _view = [[RNCCarefreesWebViewImpl alloc] init];
        
        _view.onShouldStartLoadWithRequest = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnShouldStartLoadWithRequest data = {
                    .url = std::string([[dictionary valueForKey:@"url"] UTF8String]),
                    .lockIdentifier = [[dictionary valueForKey:@"lockIdentifier"] doubleValue],
                    .title = std::string([[dictionary valueForKey:@"title"] UTF8String]),
                    .navigationType = stringToOnShouldStartLoadWithRequestNavigationTypeEnum(std::string([[dictionary valueForKey:@"navigationType"] UTF8String])),
                    .canGoBack = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .canGoForward = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .isTopFrame = [[dictionary valueForKey:@"isTopFrame"] boolValue],
                    .loading = [[dictionary valueForKey:@"loading"] boolValue],
                    .mainDocumentURL = std::string([[dictionary valueForKey:@"mainDocumentURL"] UTF8String])
                };
                webViewEventEmitter->onShouldStartLoadWithRequest(data);
            };
        };
        _view.onLoadingStart = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnLoadingStart data = {
                    .url = std::string([[dictionary valueForKey:@"url"] UTF8String]),
                    .lockIdentifier = [[dictionary valueForKey:@"lockIdentifier"] doubleValue],
                    .title = std::string([[dictionary valueForKey:@"title"] UTF8String]),
                    .navigationType = stringToOnLoadingStartNavigationTypeEnum(std::string([[dictionary valueForKey:@"navigationType"] UTF8String])),
                    .canGoBack = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .canGoForward = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .loading = [[dictionary valueForKey:@"loading"] boolValue],
                    .mainDocumentURL = std::string([[dictionary valueForKey:@"mainDocumentURL"] UTF8String], [[dictionary valueForKey:@"mainDocumentURL"] lengthOfBytesUsingEncoding:NSUTF8StringEncoding])
                };
                webViewEventEmitter->onLoadingStart(data);
            }
        };
        _view.onLoadingError = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnLoadingError data = {
                    .url = std::string([[dictionary valueForKey:@"url"] UTF8String]),
                    .lockIdentifier = [[dictionary valueForKey:@"lockIdentifier"] doubleValue],
                    .title = std::string([[dictionary valueForKey:@"title"] UTF8String]),
                    .code = [[dictionary valueForKey:@"code"] intValue],
                    .description = std::string([[dictionary valueForKey:@"description"] UTF8String]),
                    .canGoBack = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .canGoForward = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .loading = [[dictionary valueForKey:@"loading"] boolValue],
                    .domain = std::string([[dictionary valueForKey:@"domain"] UTF8String])
                };
                webViewEventEmitter->onLoadingError(data);
            }
        };
        _view.onMessage = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnMessage data = {
                    .url = std::string([[dictionary valueForKey:@"url"] UTF8String]),
                    .lockIdentifier = [[dictionary valueForKey:@"lockIdentifier"] doubleValue],
                    .title = std::string([[dictionary valueForKey:@"title"] UTF8String]),
                    .canGoBack = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .canGoForward = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .loading = [[dictionary valueForKey:@"loading"] boolValue],
                    .data = std::string([[dictionary valueForKey:@"data"] UTF8String])
                };
                webViewEventEmitter->onMessage(data);
            }
        };
        _view.onLoadingFinish = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnLoadingFinish data = {
                    .url = std::string([[dictionary valueForKey:@"url"] UTF8String]),
                    .lockIdentifier = [[dictionary valueForKey:@"lockIdentifier"] doubleValue],
                    .title = std::string([[dictionary valueForKey:@"title"] UTF8String]),
                    .navigationType = stringToOnLoadingFinishNavigationTypeEnum(std::string([[dictionary valueForKey:@"navigationType"] UTF8String], [[dictionary valueForKey:@"navigationType"] lengthOfBytesUsingEncoding:NSUTF8StringEncoding])),
                    .canGoBack = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .canGoForward = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .loading = [[dictionary valueForKey:@"loading"] boolValue],
                    .mainDocumentURL = std::string([[dictionary valueForKey:@"mainDocumentURL"] UTF8String], [[dictionary valueForKey:@"mainDocumentURL"] lengthOfBytesUsingEncoding:NSUTF8StringEncoding])
                };
                webViewEventEmitter->onLoadingFinish(data);
            }
        };
        _view.onLoadingProgress = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnLoadingProgress data = {
                    .url = std::string([[dictionary valueForKey:@"url"] UTF8String]),
                    .lockIdentifier = [[dictionary valueForKey:@"lockIdentifier"] doubleValue],
                    .title = std::string([[dictionary valueForKey:@"title"] UTF8String]),
                    .canGoBack = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .canGoForward = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .loading = [[dictionary valueForKey:@"loading"] boolValue],
                    .progress = [[dictionary valueForKey:@"progress"] doubleValue]
                };
                webViewEventEmitter->onLoadingProgress(data);
            }
        };
        _view.onContentProcessDidTerminate = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnContentProcessDidTerminate data = {
                    .url = std::string([[dictionary valueForKey:@"url"] UTF8String]),
                    .lockIdentifier = [[dictionary valueForKey:@"lockIdentifier"] doubleValue],
                    .title = std::string([[dictionary valueForKey:@"title"] UTF8String]),
                    .canGoBack = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .canGoForward = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .loading = [[dictionary valueForKey:@"loading"] boolValue]
                };
                webViewEventEmitter->onContentProcessDidTerminate(data);
            }
        };
        _view.onCustomMenuSelection = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnCustomMenuSelection data = {
                    .selectedText = std::string([[dictionary valueForKey:@"selectedText"] UTF8String]),
                    .key = std::string([[dictionary valueForKey:@"key"] UTF8String]),
                    .label = std::string([[dictionary valueForKey:@"label"] UTF8String])
                    
                };
                webViewEventEmitter->onCustomMenuSelection(data);
            }
        };
        _view.onScroll = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                NSDictionary* contentOffset = [dictionary valueForKey:@"contentOffset"];
                NSDictionary* contentInset = [dictionary valueForKey:@"contentInset"];
                NSDictionary* contentSize = [dictionary valueForKey:@"contentSize"];
                NSDictionary* layoutMeasurement = [dictionary valueForKey:@"layoutMeasurement"];
                double zoomScale = [[dictionary valueForKey:@"zoomScale"] doubleValue];

                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnScroll data = {
                    .contentOffset = {
                        .x = [[contentOffset valueForKey:@"x"] doubleValue],
                        .y = [[contentOffset valueForKey:@"y"] doubleValue]
                    },
                    .contentInset = {
                        .left = [[contentInset valueForKey:@"left"] doubleValue],
                        .right = [[contentInset valueForKey:@"right"] doubleValue],
                        .top = [[contentInset valueForKey:@"top"] doubleValue],
                        .bottom = [[contentInset valueForKey:@"bottom"] doubleValue]
                    },
                    .contentSize = {
                        .width = [[contentSize valueForKey:@"width"] doubleValue],
                        .height = [[contentSize valueForKey:@"height"] doubleValue]
                    },
                    .layoutMeasurement = {
                        .width = [[layoutMeasurement valueForKey:@"width"] doubleValue],
                        .height = [[layoutMeasurement valueForKey:@"height"] doubleValue]                    },
                    .zoomScale = zoomScale
                };
                webViewEventEmitter->onScroll(data);
            }
        };
        _view.onHttpError = [self](NSDictionary* dictionary) {
            if (_eventEmitter) {
                auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                facebook::react::RNCCarefreesWebViewEventEmitter::OnHttpError data = {
                    .url = std::string([[dictionary valueForKey:@"url"] UTF8String]),
                    .lockIdentifier = [[dictionary valueForKey:@"lockIdentifier"] doubleValue],
                    .title = std::string([[dictionary valueForKey:@"title"] UTF8String]),
                    .statusCode = [[dictionary valueForKey:@"statusCode"] intValue],
                    .description = std::string([[dictionary valueForKey:@"description"] UTF8String]),
                    .canGoBack = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .canGoForward = [[dictionary valueForKey:@"canGoBack"] boolValue],
                    .loading = [[dictionary valueForKey:@"loading"] boolValue]
                };
                webViewEventEmitter->onHttpError(data);
            }
        };
        self.contentView = _view;
    }
    return self;
}

- (void)updateEventEmitter:(EventEmitter::Shared const &)eventEmitter
{
    [super updateEventEmitter:eventEmitter];
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<RNCCarefreesWebViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<RNCCarefreesWebViewProps const>(props);

#define REMAP_WEBVIEW_PROP(name)                    \
    if (oldViewProps.name != newViewProps.name) {   \
        _view.name = newViewProps.name;             \
    }

#define REMAP_WEBVIEW_STRING_PROP(name)                             \
    if (oldViewProps.name != newViewProps.name) {                   \
        _view.name = RCTNSStringFromString(newViewProps.name);      \
    }

    REMAP_WEBVIEW_PROP(scrollEnabled)
    REMAP_WEBVIEW_STRING_PROP(injectedJavaScript)
    REMAP_WEBVIEW_STRING_PROP(injectedJavaScriptBeforeContentLoaded)
    REMAP_WEBVIEW_PROP(injectedJavaScriptForMainFrameOnly)
    REMAP_WEBVIEW_PROP(injectedJavaScriptBeforeContentLoadedForMainFrameOnly)
    REMAP_WEBVIEW_PROP(javaScriptEnabled)
    REMAP_WEBVIEW_PROP(javaScriptCanOpenWindowsAutomatically)
    REMAP_WEBVIEW_PROP(allowFileAccessFromFileURLs)
    REMAP_WEBVIEW_PROP(allowUniversalAccessFromFileURLs)
    REMAP_WEBVIEW_PROP(allowsInlineMediaPlayback)
    REMAP_WEBVIEW_PROP(allowsAirPlayForMediaPlayback)
    REMAP_WEBVIEW_PROP(mediaPlaybackRequiresUserAction)
    REMAP_WEBVIEW_PROP(automaticallyAdjustContentInsets)
    REMAP_WEBVIEW_PROP(autoManageStatusBarEnabled)
    REMAP_WEBVIEW_PROP(hideKeyboardAccessoryView)
    REMAP_WEBVIEW_PROP(allowsBackForwardNavigationGestures)
    REMAP_WEBVIEW_PROP(incognito)
    REMAP_WEBVIEW_PROP(pagingEnabled)
    REMAP_WEBVIEW_STRING_PROP(applicationNameForUserAgent)
    REMAP_WEBVIEW_PROP(cacheEnabled)
    REMAP_WEBVIEW_PROP(allowsLinkPreview)
    REMAP_WEBVIEW_STRING_PROP(allowingReadAccessToURL)
    
    REMAP_WEBVIEW_PROP(messagingEnabled)
    REMAP_WEBVIEW_PROP(enableApplePay)
    REMAP_WEBVIEW_PROP(pullToRefreshEnabled)
    REMAP_WEBVIEW_PROP(bounces)
    REMAP_WEBVIEW_PROP(useSharedProcessPool)
    REMAP_WEBVIEW_STRING_PROP(userAgent)
    REMAP_WEBVIEW_PROP(sharedCookiesEnabled)
    #if !TARGET_OS_OSX
    REMAP_WEBVIEW_PROP(decelerationRate)
    #endif // !TARGET_OS_OSX
    REMAP_WEBVIEW_PROP(directionalLockEnabled)
    REMAP_WEBVIEW_PROP(showsHorizontalScrollIndicator)
    REMAP_WEBVIEW_PROP(showsVerticalScrollIndicator)
    REMAP_WEBVIEW_PROP(keyboardDisplayRequiresUserAction)
    
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 /* __IPHONE_13_0 */
    REMAP_WEBVIEW_PROP(automaticallyAdjustContentInsets)
#endif
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 /* iOS 14 */
    REMAP_WEBVIEW_PROP(limitsNavigationsToAppBoundDomains)
#endif
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 140500 /* iOS 14.5 */
    REMAP_WEBVIEW_PROP(textInteractionEnabled)
#endif
    
    if (oldViewProps.dataDetectorTypes != newViewProps.dataDetectorTypes) {
        WKDataDetectorTypes dataDetectorTypes = WKDataDetectorTypeNone;
            if (dataDetectorTypes & RNCCarefreesWebViewDataDetectorTypes::Address) {
                dataDetectorTypes |= WKDataDetectorTypeAddress;
            } else if (dataDetectorTypes & RNCCarefreesWebViewDataDetectorTypes::Link) {
                dataDetectorTypes |= WKDataDetectorTypeLink;
            } else if (dataDetectorTypes & RNCCarefreesWebViewDataDetectorTypes::CalendarEvent) {
                dataDetectorTypes |= WKDataDetectorTypeCalendarEvent;
            } else if (dataDetectorTypes & RNCCarefreesWebViewDataDetectorTypes::TrackingNumber) {
                dataDetectorTypes |= WKDataDetectorTypeTrackingNumber;
            } else if (dataDetectorTypes & RNCCarefreesWebViewDataDetectorTypes::FlightNumber) {
                dataDetectorTypes |= WKDataDetectorTypeFlightNumber;
            } else if (dataDetectorTypes & RNCCarefreesWebViewDataDetectorTypes::LookupSuggestion) {
                dataDetectorTypes |= WKDataDetectorTypeLookupSuggestion;
            } else if (dataDetectorTypes & RNCCarefreesWebViewDataDetectorTypes::PhoneNumber) {
                dataDetectorTypes |= WKDataDetectorTypePhoneNumber;
            } else if (dataDetectorTypes & RNCCarefreesWebViewDataDetectorTypes::All) {
                dataDetectorTypes |= WKDataDetectorTypeAll;
            } else if (dataDetectorTypes & RNCCarefreesWebViewDataDetectorTypes::None) {
                dataDetectorTypes = WKDataDetectorTypeNone;
        }
        [_view setDataDetectorTypes:dataDetectorTypes];
    }
    if (oldViewProps.contentInset.top != newViewProps.contentInset.top || oldViewProps.contentInset.left != newViewProps.contentInset.left || oldViewProps.contentInset.right != newViewProps.contentInset.right || oldViewProps.contentInset.bottom != newViewProps.contentInset.bottom) {
        UIEdgeInsets edgesInsets = {
            .top = newViewProps.contentInset.top,
            .left = newViewProps.contentInset.left,
            .right = newViewProps.contentInset.right,
            .bottom = newViewProps.contentInset.bottom
        };
        [_view setContentInset: edgesInsets];
    }

    if (oldViewProps.basicAuthCredential.username != newViewProps.basicAuthCredential.username || oldViewProps.basicAuthCredential.password != newViewProps.basicAuthCredential.password) {
        [_view setBasicAuthCredential: @{
            @"username": RCTNSStringFromString(newViewProps.basicAuthCredential.username),
            @"password": RCTNSStringFromString(newViewProps.basicAuthCredential.password)
        }];
    }
    if (oldViewProps.contentInsetAdjustmentBehavior != newViewProps.contentInsetAdjustmentBehavior) {
        if (newViewProps.contentInsetAdjustmentBehavior == RNCCarefreesWebViewContentInsetAdjustmentBehavior::Never) {
            [_view setContentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentNever];
        } else if (newViewProps.contentInsetAdjustmentBehavior == RNCCarefreesWebViewContentInsetAdjustmentBehavior::Automatic) {
            [_view setContentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentAutomatic];
        } else if (newViewProps.contentInsetAdjustmentBehavior == RNCCarefreesWebViewContentInsetAdjustmentBehavior::ScrollableAxes) {
            [_view setContentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentScrollableAxes];
        } else if (newViewProps.contentInsetAdjustmentBehavior == RNCCarefreesWebViewContentInsetAdjustmentBehavior::Always) {
            [_view setContentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentAlways];
        }
    }

    if (oldViewProps.menuItems != newViewProps.menuItems) {
        NSMutableArray *newMenuItems = [NSMutableArray array];

        for (const auto &menuItem: newViewProps.menuItems) {
            [newMenuItems addObject:@{
                @"key": RCTNSStringFromString(menuItem.key),
                @"label": RCTNSStringFromString(menuItem.label),
            }];

        }
        [_view setMenuItems:newMenuItems];
    }
    if (oldViewProps.hasOnFileDownload != newViewProps.hasOnFileDownload) {
        if (newViewProps.hasOnFileDownload) {
            _view.onFileDownload = [self](NSDictionary* dictionary) {
                if (_eventEmitter) {
                    auto webViewEventEmitter = std::static_pointer_cast<RNCCarefreesWebViewEventEmitter const>(_eventEmitter);
                    facebook::react::RNCCarefreesWebViewEventEmitter::OnFileDownload data = {
                        .downloadUrl = std::string([[dictionary valueForKey:@"downloadUrl"] UTF8String])
                    };
                    webViewEventEmitter->onFileDownload(data);
                } 
            };
        } else {
            _view.onFileDownload = nil;        
        }
    }
//
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 /* iOS 13 */
    if (oldViewProps.contentMode != newViewProps.contentMode) {
        if (newViewProps.contentMode == RNCCarefreesWebViewContentMode::Recommended) {
            [_view setContentMode: WKContentModeRecommended];
        } else if (newViewProps.contentMode == RNCCarefreesWebViewContentMode::Mobile) {
            [_view setContentMode:WKContentModeMobile];
        } else if (newViewProps.contentMode == RNCCarefreesWebViewContentMode::Desktop) {
            [_view setContentMode:WKContentModeDesktop];
        }
    }
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 /* iOS 15 */
    if (oldViewProps.mediaCapturePermissionGrantType != newViewProps.mediaCapturePermissionGrantType) {
        if (newViewProps.mediaCapturePermissionGrantType == RNCCarefreesWebViewMediaCapturePermissionGrantType::Prompt) {
            [_view setMediaCapturePermissionGrantType:RNCCarefreesWebViewPermissionGrantType_Prompt];
        } else if (newViewProps.mediaCapturePermissionGrantType == RNCCarefreesWebViewMediaCapturePermissionGrantType::Grant) {
            [_view setMediaCapturePermissionGrantType:RNCCarefreesWebViewPermissionGrantType_Grant];
        } else if (newViewProps.mediaCapturePermissionGrantType == RNCCarefreesWebViewMediaCapturePermissionGrantType::Deny) {
            [_view setMediaCapturePermissionGrantType:RNCCarefreesWebViewPermissionGrantType_Deny];
        }else if (newViewProps.mediaCapturePermissionGrantType == RNCCarefreesWebViewMediaCapturePermissionGrantType::GrantIfSameHostElsePrompt) {
            [_view setMediaCapturePermissionGrantType:RNCCarefreesWebViewPermissionGrantType_GrantIfSameHost_ElsePrompt];
        }else if (newViewProps.mediaCapturePermissionGrantType == RNCCarefreesWebViewMediaCapturePermissionGrantType::GrantIfSameHostElseDeny) {
            [_view setMediaCapturePermissionGrantType:RNCCarefreesWebViewPermissionGrantType_GrantIfSameHost_ElseDeny];
        }
    }
#endif
    
    NSMutableDictionary* source = [[NSMutableDictionary alloc] init];
    if (!newViewProps.newSource.uri.empty()) {
        [source setValue:RCTNSStringFromString(newViewProps.newSource.uri) forKey:@"uri"];
    }
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    for (auto & element : newViewProps.newSource.headers) {
        [headers setValue:RCTNSStringFromString(element.value) forKey:RCTNSStringFromString(element.name)];
    }
    if (headers.count > 0) {
        [source setObject:headers forKey:@"headers"];
    }
    if (!newViewProps.newSource.baseUrl.empty()) {
        [source setValue:RCTNSStringFromString(newViewProps.newSource.baseUrl) forKey:@"baseUrl"];
    }
    if (!newViewProps.newSource.body.empty()) {
        [source setValue:RCTNSStringFromString(newViewProps.newSource.body) forKey:@"body"];
    }
    if (!newViewProps.newSource.html.empty()) {
        [source setValue:RCTNSStringFromString(newViewProps.newSource.html) forKey:@"html"];
    }
    if (!newViewProps.newSource.method.empty()) {
        [source setValue:RCTNSStringFromString(newViewProps.newSource.method) forKey:@"method"];
    }
    [_view setSource:source];
    
    [super updateProps:props oldProps:oldProps];
}

- (void)handleCommand:(nonnull const NSString *)commandName args:(nonnull const NSArray *)args {
    RCTRNCCarefreesWebViewHandleCommand(self, commandName, args);
}


Class<RCTComponentViewProtocol> RNCCarefreesWebViewCls(void)
{
    return RNCCarefreesWebView.class;
}

- (void)goBack {
    [_view goBack];
}

- (void)goForward {
    [_view goForward];
}

- (void)injectJavaScript:(nonnull NSString *)javascript {
    [_view injectJavaScript:javascript];
}

- (void)loadUrl:(nonnull NSString *)url {
    // android only
}

- (void)postMessage:(nonnull NSString *)data {
    [_view postMessage:data];
}

- (void)reload {
    [_view reload];
}

- (void)requestFocus {
    [_view requestFocus];
}

- (void)stopLoading {
    [_view stopLoading];
}

- (void)clearFormData {
    // android only
}

- (void)clearCache:(BOOL)includeDiskFiles {
    // android only
}

- (void)clearHistory {
    // android only
}

@end
#endif
