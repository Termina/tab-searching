
Tab Searching for Chrome
------

### Usage for users

![](https://developers.google.com/chrome/web-store/images/branding/ChromeWebStore_BadgeWBorder_v2_206x58.png)

[Install "Tab Searching" via Chrome Webstore](https://chrome.google.com/webstore/detail/search-tab-crx/mghfpkfegmeanpcabcmiipiknkegjnkd)

And some configs to start with:

![](http://img5.tuchuang.org/uploads/2013/12/open-key.png)
![](http://img5.tuchuang.org/uploads/2013/12/shortcuts.png)
![](http://img5.tuchuang.org/uploads/2013/12/badge.png)
![](http://img4.tuchuang.org/uploads/2013/12/search.png)

Keywords are for both urls and titles.

### Usage for a developer

* `git clone` this repo and run `bower install`
* clone Ractive and use `0.3.8` branch
* run `node-dev dev.coffee` to compile CoffeeScript
* Load the code in develop mode of Chrome.  
* Got to bottom of [chrome://extensions/](chrome://extensions/) and set keyboard shortcuts.
* Press your shortcuts

`Command+Period` is suggested for `mac`, `Alt+Perriod` for default..

While searching, press Enter, Esc, Left, Up, Down for different actions.

### Techniques

* http://ractivejs.org/
* http://requirejs.org
* http://cirru.org

### Icon

https://www.iconfinder.com/icons/103703/search_icon#size=128

### License

MIT