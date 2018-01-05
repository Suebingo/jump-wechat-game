@echo off
:: capture screen
adb shell screencap -p /sdcard/%1
adb pull /sdcard/%1

::process the picture with matlab



:: touch 800 ms
::adb shell input swipe 100 500 100 500 800