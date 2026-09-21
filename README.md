# StringeeWidget

[![License](https://img.shields.io/cocoapods/l/StringeeWidget.svg?style=flat)](https://cocoapods.org/pods/StringeeWidget)
[![Platform](https://img.shields.io/cocoapods/p/StringeeWidget.svg?style=flat)](https://cocoapods.org/pods/StringeeWidget)

A drop-in calling UI for the [Stringee](https://stringee.com) platform: voice and
video calls with a ready-made call screen, CallKit integration, permission
handling and localized error reporting.

## Requirements

- iOS 15.0 or later
- Xcode 15 or later

## Installation

Add the pod to your `Podfile`, pinned to a tag:

```ruby
pod 'StringeeWidget',
    :git => 'https://github.com/stringeecom/StringeeWidget-iOS.git',
    :tag => '0.3.0'
```

Then:

```bash
pod install
```

Pin a `:tag`, not a `:branch` — a branch moves under you, so a later
`pod update` can pull different code with no change on your side.

The pod brings in `Stringee 2.0.2`, which in turn pulls `WebRTC-SDK`. If your
project declares `GoogleWebRTC` directly, remove it — the two conflict.

## Quick start

```swift
import StringeeWidget

StringeeWidget.instance.delegate = self
StringeeWidget.instance.connect(token: accessToken)

let config = StringeeCallConfig()
config.from = "caller-id"
config.to = "callee-id"
config.isVideoCall = true

StringeeWidget.instance.makeCall(config: config) { status, code, message, data in
    // Fires exactly once, on every outcome.
}
```

Implement `StringeeWidgetDelegate` to receive the call screen and call events:

```swift
extension MyViewController: StringeeWidgetDelegate {

    func onDisplayCallingViewController(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

    func onCallError(_ error: StringeeWidgetError) {
        // Always called, whether or not the widget shows the error itself.
        Analytics.log("stringee", [
            "code": error.code.rawValue,
            "serverCode": error.serverCode,
            "serverMessage": error.serverMessage ?? "",
        ])
    }

    // … other delegate methods
}
```

## Error handling

Every failure is reported through `onCallError` as a `StringeeWidgetError`,
carrying a classified `code`, a `domain` (`.widget` / `.sdk` / `.server`), a
localized `message`, the untouched `serverCode` and `serverMessage` for logging,
plus `endCallCause`, `sipCode` and `isRetryable`.

The widget draws the error on the call screen by default. Turn that off when your
app presents its own UI — the callback still fires:

```swift
StringeeWidget.instance.autoShowError = false
```

Override the wording per code, or restyle the error card:

```swift
StringeeWidget.instance.errorTexts.set("Tài khoản đã hết tiền", for: .notEnoughMoney)
StringeeWidget.instance.errorAppearance.backgroundColor = .systemRed
```

## Upgrading from 0.2.x

No public API was removed or renamed, so existing code still compiles. Four
things do change:

**Minimum iOS is now 15.0**, up from 11.0.

**Two `completion` codes moved** out of the range the native SDK uses for its
own errors, where they were indistinguishable from it:

| | 0.2.x | 0.3.0 |
|---|---|---|
| Empty token | `-2` | `-1001` |
| No delegate to present the call screen | `-3` | `-1002` |

**`completion` now always fires.** It previously never ran when the user denied
microphone or camera access, or cancelled the permission alert, leaving the
caller waiting forever. If you worked around that with a timeout, remove it or
you will handle the result twice.

**Connection failures reach both `onConnectionError` and `onCallError`.**
`onConnectionError` is unchanged so existing code keeps working, but if you
implement both you will show two messages for one failure. Either move to
`onCallError` alone, or skip `error.domain == .sdk` there.

One behaviour fix worth knowing about: starting a video call no longer forces
audio to the external speaker when headphones, Bluetooth, CarPlay or a USB
device is connected.

## License

MIT. See the LICENSE file.
