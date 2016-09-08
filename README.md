# Pre-work - *tipsCalc*

**tipsCalc** is a tip calculator application for iOS.

Submitted by: **Sahil Agarwal**

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [ ] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] Link Buttons to extend functionality via Venmo and Foursqare/Swarm.
- [x] Custom Tip Percentage
- [ ] Light / Dark Theme Selector
- [ ] "Round Up" button

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Some challenges building this app were:
* Not sure how default values are initialized in NSLocale, so had to account for nils
* Handling blank user input for the custom tip was frustrating
* Deeplinking to another app is more complicated than say a webpage - as such defaulted to (venmo.com) and (swarmapp.com) instead of opening the user's app if installed.
* I was trying to use a picker selector for the custom tip (giving a range of 10% - 30%), but proved more difficult to implement, so instead used a field.
* App icon was created with [icons8](https://icons8.com/web-app/for/ios7/money).

## License

    Copyright 2016 Sahil Agarwal

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.