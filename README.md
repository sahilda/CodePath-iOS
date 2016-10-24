# Project 2 - Yelp Redux

Yelp Redux is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height.
   - [x] Custom cells should have the proper Auto Layout constraints.
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states.
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [ ] Search results page
   - [ ] Infinite scroll for restaurant results.
   - [x] Implement map view of restaurant results.
- [x] Filter page
   - [x] Implement a custom switch instead of the default UISwitch.
   - [x] Distance filter should expand as in the real Yelp app
   - [x] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [x] Implement the restaurant detail page.

The following **additional** features are implemented:
- [x] Filter selections are saved and pre-populated between search and filter view

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. In the "tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)" function, I'd like to trigger the cell.button action - how can I do that?
2. How to better and simple animation for objects (like the button being selected)

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

* The filtersViewController is quite messy and contains lots of custom code for each specific filter. It's not clean, though it seems to work :).
* Making the switch from a Switch to a Button was more difficult than necessary - all of the functions were tied to each element's specific 'select' method. This could've been abstracted in the cell class.
* Settings, down-arrow, the switch, back button, map, and checkmarks icon were found with [icons8](https://icons8.com).
* Yelp Icon was found with [Soft Icons](http://www.softicons.com/social-media-icons/ios-8-style-social-media-icons-by-design-bolts/yelp-icon).

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