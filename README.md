The Hackerspace Status Notifier is a small app i created to show me the current status of P-Space, the local hackerspace I happen to manage, and notify me when the status changes.

The (Hackerspace) Status Notifier checks for the contents of a specified **URL**, by default http://p-space.gr/status/ and notifies the user upon change. It uses **Growl** for notifications, and also adds an item on the status bar which always shows the current status (**Green** for **Open/On** and **Red** for **Closed/Off**).

## Usage
The program starts with an unknown status (**Yellow** icon) and checks for the value of the **URL** every 10 seconds. The contents of the **URL** should be either **0** or **1**. If it is something more complicated, the string will not be properly evaluated as an integer, and it will be considered an unsupported value, thereby not changing the current status. The same is also true when the connection to the **URL** cannot be completed.

## Disabling subsystems
The user can also disable the statusbar (menu) icon and/or the **Growl** notification if he wishes by editing the user defaults from the Terminal. For example, to disable the statusbar icon one needs to type:

`defaults write com.tzikis.Status-Notifier -boolean disableMenu true`

To disable the **Growl** notifications:

`defaults write com.tzikis.Status-Notifier -boolean disableNotifications true`

If you wish to re-enable any of the above, you just have to replace **true** with **false**.

## Replacing URL and notification strings
You can also use your own **URL**, **Title** (for the notifications), and **Description** for the **On** and **Off** notifications. For example, to use a different **URL**:

`defaults write com.tzikis.Status-Notifier URL http://p-space.gr/status/`

And to set the **Title**, **On Description**, and **Off Description** accordingly:

`defaults write com.tzikis.Status-Notifier Title "My Epic Status Notification App"`

`defaults write com.tzikis.Status-Notifier OnTitle "The awesome thing i made is On"`

`defaults write com.tzikis.Status-Notifier OffTitle "The awesome thing i made is Off"`
