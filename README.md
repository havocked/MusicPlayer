# Technical Challenge

Hi, fellow Reviewer,

This document will help you build the project and walk you through into some of the specifics of the project. I hope you’ll enjoy reviewing my code.

Cheers !

## Requirements

- Xcode 9.3+ 
- iOS 11.0+ 
- Swift 4.0+

## Building the project

This project use [Cocoapods](https://cocoapods.org). Tap the following commands in the root directory 

```
$> sudo gem install cocoapods
$> pod install
```

It will generate a file **MusicPlayer.xcworkspace**. Open the project with it (not with MusicPlayer.xcodeproj)

## Project Architecture

The architecture evolves around “Stories” where, in the future, whenever the project grows, we can separate different screen logic that represent a new story (ex: Login screens, User Settings screens).

A Story is composed of a Storyboard, ViewControllers, ViewModels and Views directories. This way, it is easy to navigate between classes that are linked inside a same story.

![GitHub Logo](documentation/doc_stories.png)

When possible, MVVM is used.

## Known issues

- No possibilities to switch forward or backward between songs
- The Apple Music API has a limit when fetching the top charts (limit of 50)

⚠️ The implementation of this project is basic and doesn't handle the token refresh (for the use of Apple Music API). ⚠️ 

You will have to manually refresh it using the [Apple documentation](https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/AppleMusicWebServicesReference/SetUpWebServices.html#//apple_ref/doc/uid/TP40017625-CH2-SW1) and also [this helper](https://github.com/pelauimagineering/apple-music-token-generator) to generate the token.

When you get this token, you have to manually place it in the config files :

*MusicPlayer -> Supporting Files -> Config -> Development/Debug/Release.xcconfig*

replace the value for the key **APPLE_MUSIC_KEY**

## Cocoapods

Two frameworks are used with Cocoapods:

#### Kingfisher

Really good pod to handle loading and caching of images from urls.

#### KDEAudioPlayer

AudioPlayer is a wrapper around AVPlayer and also offers cool features.

## Testing

To test different parts of the project, I use the Xcode test framework.