[![Build Status](https://travis-ci.com/veetaw/quake.svg?branch=master)](https://travis-ci.com/veetaw/quake)
# quake
> WIP, see [projects](https://github.com/veetaw/quake/projects)

![](.github/readme/base_design.png)

### what's quake?
Quake is going to be a cross platform (iOS, Android) mobile application that will show you the last earthquakes happened around the world, or near you, with a focus on beautiful design and functionality.

### why?
All earthquake feed reader applications are poorly designed and some of them can drain battery because of asking an external server every n seconds for new events to send notifications, quake will not do that. A server will send a notification to every user who subscribed to feeds in a particular area.

### goals
- [ ] Completely cross platform
- [ ] Stable
- [ ] Functional
- [ ] Simple to use

### development
- [ ] Business logic
    - [x] Earthquake Model
    - [x] API Wrapper
    - [x] DB Helper
    - [x] Check if it's first time opening app on startup
    - [ ] Check connection
    - [x] Localization
    - [x] All Earthquakes BLOC
    - [ ] Nearby Earthquakes BLOC
    - [ ] Search earthquake
    - [ ] Map Provider for detail page and map page
- [ ] Permissions
    - [x] Internet
    - [ ] Location
- [ ] UI
    - [ ] AppBar
    - [ ] BottomAppBar
    - [ ] earthquake card model
    - [ ] basic listview
    - [ ] Page Switching
    - [ ] Detail Page
    - [ ] Map Page
    - [ ] Settings
    - [x] Themes
- [ ] Notifications
    - [ ] Backend
    - [ ] OneSignal
    - [ ] Firebase Auth
- [ ] Android only features
    - [ ] Widget
- [ ] Testing
    - [x] Unit tests
        - [x] Earthquake Model
        - [x] API Wrapper
        - [ ] Database helper
        - [ ] Earthquake Bloc
    - [ ] Widget tests
        - [ ] Theme switch
    - [ ] Integration tests
