# Project 1 - What's Playing

What's Playing is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **9** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [x] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/Blsc8wR.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

* Initially ran into trouble when adding the tab bar with this exception "Push segues can only be used when the source controller is managed by an instance of UINavigationController". After spending time researching and finding no solution, I decided to revert back to a pre-tab state and was able to succeed this time. Not sure what the error was (though suspicion is a wrong function or variable was called).
* Tab Bar Icons: film and film start icons by Hea Poh Lin from the Noun Project.
* "No Image Available" found [here](http://polyureashop.studio.crasman.fi/pub/web/img/no-image.jpg).
* App icon found created using [IconFinder](https://www.iconfinder.com/icons/172074/movies_play_icon#size=96).

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
