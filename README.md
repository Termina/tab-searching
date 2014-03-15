
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

* run commands to fetch and build files

```
git clone git@github.com:jiyinyiyong/tab-searching.git
npm install
npm install -g coffee-script shelljs
coffee make.coffee build
```

* Load the code in develop mode of Chrome.  
* Got to bottom of [chrome://extensions/](chrome://extensions/) and set keyboard shortcuts.
* Press your shortcuts or click the icon

### Shortcuts

`Command+Period` is suggested for `mac`, `Alt+Perriod` for Windows and Linux.

* Enter: choose this tab
* Up: go to the tab above
* Down: go to the tab below
* Shift+Delete: remove this tab

### Techniques

* http://vuejs.org
* http://shelljs.org
* http://cirru.org

### License

MIT