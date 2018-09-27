# Magento 2 Market Place
# Minimum Version 9.0

### For setup the application:

- Go to AppConfiguration.swift file:
- write your key credential:

```
var BASE_DOMAIN = "xxxxxx:xxxxxxxxxxxxxxxxxxxxxxxxx"
var HOST_NAME = BASE_DOMAIN
var API_USER_NAME  = "xxxxx"
var API_KEY = "xxxxxxx"
```

# # For setup color code in app:

I have set some default color:  (All are hexa form data)

```
var EXTRALIGHTGREY = "ECEFF1"
var LIGHTGREY = "8E8E93";
var ACCENT_COLOR = "E9ECEF";
var BUTTON_COLOR = "157DE1";
var TEXTHEADING_COLOR = "000000";
var NAVIGATION_TINTCOLOR = "5D5D5D"
var LINK_COLOR = "000000"
var GREEN_COLOR = "17582c"
var GRADIENTCOLOR = [UIColor().HexToColor(hexString: "40BDF4") , UIColor().HexToColor(hexString: "1E88E5")]
var STARGRADIENT = [UIColor().HexToColor(hexString: "93BC4B") , UIColor().HexToColor(hexString: "9ED836")]

```

# For google Map key:

- Go to AppDelegate.swift file:
- change the:
- GMSServices.provideAPIKey("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");


# For Add New Localization:

1: Select project
2: under project select "localization"
3:click on "+"
4: Add your required file.
5: Now open the add file and change the value according to your requirement:

like  home = "Home";
to
home = "Required language";

# For change value


1: select Localizable.string file
2: and change the value with respective key.

# For Push Notification.
[Set UP Push Notification check ](https://mobikul.com/use-rich-push-notification-ios-using-swift-3-4/)
# For App icon & SplashScreen 

- go to Assets.xcassets  folder and change this.

# For Placeholder 

- go to image folder and change placeholder.png image.

# For Bundle ID & App Name :

- Select Projecrt & Targets 
- Change the Display name & BundleIdentifier











