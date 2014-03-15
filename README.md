
Tab Searching for Chrome
------

### Usage for users

![](https://developers.google.com/chrome/web-store/images/branding/ChromeWebStore_BadgeWBorder_v2_206x58.png)

![](http://img4.picbed.org/uploads/2014/03/tab-searching.png)

Keywords are searched in both urls and titles.

You may need to add launching shortcut by following this guide:

http://googlesystem.blogspot.com/2012/08/create-keyboard-shortcuts-for-chrome.html

Icon of Tab Searching is:

![](http://img4.picbed.org/uploads/2014/03/tab-searching.png)

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