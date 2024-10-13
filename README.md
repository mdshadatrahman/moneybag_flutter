# [Moneybag](https://moneybag.com.bd)

Payment Gateway (PGW)

Our vision is to revolutionize the way people transact and make payments by providing a secure, seamless and accessible platform for all.

## Features

- **Flexibility** : Moneybag accepts, verifies, and processes a variety of transactions. Payments may be made via: Credit/Debit Cards. .
- **Secure API** : Moneybag connects merchants via a secure payment pages, forms or payment APIs. Moneybag also has the ability to. . .

## Getting started

You need to make sure setup for [`webview_flutter`](https://pub.dev/packages/webview_flutter)

Also don't forget to add

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <application
        android:usesCleartextTraffic="true"
    ...>
>
```

For iOS, ensure your Info.plist allows arbitrary loads:

```plist
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

## Usage

longer examples to the `/example` folder.

```dart
const merchantId = String.fromEnvironment("merchant_id");// the your secret keys 
const authKey = String.fromEnvironment("auth_key");

const info = MoneybagInfo(
    isDev: true, // use false for production
    email: "test@gmail.com",
    phoneNo: "017xxxxxxxx",
    orderId: "MER2024xxxx1813", //
    merchantID: merchantId, // "YOUR_MERCHANT_ID",
    authKey: authKey, // "YOUR_AUTH_KEY",
    currencyCode: "050",
    orderAmount: 1.0,
    description: "Order Description",
    returnURL: "https://your_return_url",
);

Navigator.of(context).push(MoneybagPage.route(moneybagInfo: info));

```

## Additional information

Find more on [website](https://moneybag.com.bd)
