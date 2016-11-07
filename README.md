# Project 4 - Tweet Beat

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is completed:

- [ ] Hamburger menu
   - [ ] Dragging anywhere in the view should reveal the menu.
   - [ ] The menu should include links to your profile, the home timeline, and the mentions view.
   - [ ] The menu can look similar to the example or feel free to take liberty with the UI.
- [ ] Profile page
   - [ ] Contains the user header view
   - [ ] Contains a section with the users basic stats: # tweets, # following, # followers
- [ ] Home Timeline
   - [ ] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [ ] Profile Page
   - [ ] Implement the paging view for the user description.
   - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account

The following **additional** features are implemented:

- [x] Added hyperlinks to the the tweet links for urls

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

  1.
  2.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

# Project 3 - Tweet Beat

Tweet Beat is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: 13.5 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

- [x] Tweets page has retweet, reply, and like functionality too.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to use make the text more with the tweet body more interactive - hyperlinks and #hashtags
2. How to add a segue from a button within the cell (is it even possible via storyboard?).

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/41SBj5p.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.
* Homescreen background image was found [here](http://www.araspot.com/wp-content/uploads/2015/09/san-francisco-california-wallpaper-photos-gallery-9aph750cpi.jpg).
* Twitter assets were found [here](https://brand.twitter.com/en.html) and [here](https://webcache.googleusercontent.com/search?q=cache:0V23ETjL0xIJ:https://dev.twitter.com/overview/general/image-resources+&cd=2&hl=en&ct=clnk&gl=us).
* Compose icone was found here [here](https://www.iconfinder.com/icons/897241/article_blog_blogging_compose_resolutions_sign_write_icon#size=128).

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
