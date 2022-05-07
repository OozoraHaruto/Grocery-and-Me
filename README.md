# This application is not meant for commercial use and should not be sold.

# Grocery and Me

## How to use
1. Create your own [firebase](https://console.firebase.google.com/u/0/) project and enable the following
    - Firestore Database
    - Functions (Requires adding of payment method)
    - Messaging
1. Clone this project
1. Copy your `GoogleService-Info.plist` into the `Shared` folder
1. Clone the [Firebase function repo](https://github.com/OozoraHaruto/Grocery-and-Me-Firebase-Functions) and deploy it. Or you can `firebase init` your own one and copy the `functions/src/index.ts` file. (Fix any errors yourself)

### "Publishing"
- If you have a developer account you can use `Ad hoc` after you archive the project
- Once done you can upload it to a file sharing website hosted on `https` (req by apple)
- Then create a simple website with a link to your manifest prepended with `itms-services://?action=download-manifest&url=`

## Helping out
I created this to avoid paying subscription to an app. So I made it open source for anyone who have an apple developer account like me but does not really use it much.

If you wish to help out, do create an MR and clearly state what it does. I will take a look and hope you will not be insulted if I make some comments. I will merge it once it is all fixed or if I find it okay.

## Issues
I know there will be issues. I am not perfect. Do create an issue if you find one. I will fix it ASAP. But I do have work and life do forgive me if I take some time to fix it. Even better if you can create an MR for the fix, I will be glad to take a look.

## Shoutout
I use various API while building this and various **PAID** UI Icons. I would like to thank them as I can't list all I would like to thank them as a whole.

### Icons
- App Icon by [いらすとや](https://www.irasutoya.com)
- Other SVGs by [fontawesome](https://fontawesome.com)

### App packages
- Image Lightbox by [swiftui-image-viewer](https://github.com/Jake-Short/swiftui-image-viewer)
- SVG Renderer by [PocketSVG](https://github.com/pocketsvg/PocketSVG)
- Alerts by [SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages)
- Introspect by [SwiftUI-Introspect](https://github.com/siteline/SwiftUI-Introspect)
- Firebase by [Firebase](https://github.com/firebase/firebase-ios-sdk)

## License
I would like to say I paid for fontawesome to use the it as a personal project. I do have the license so please do not publish the app other than for personal use!