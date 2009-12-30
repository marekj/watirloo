require 'Win32API'

module Watirloo

  module ScreenCapture

    KEYEVENTF_KEYUP = 0x2
    VK_CONTROL      = 0x11
    VK_MENU         = 0x12
    VK_SHIFT        = 0x10
    VK_SNAPSHOT     = 0x2C

    # send key events Ctrl+PrintScreen using win32 to activate greenshot screencatpure program
    # http://sourceforge.net/projects/greenshot/
    # greenshot must be configured beforehand and running (best to just run it at win startup)
    #   output: save automatically to a location of your choice (best with png, smallest files)
    #   filepattern: recommended greenshot_%YYYY%-%MM%-%DD%_%hh%-%mm%-%ss%
    #   turn off open in editor option
    # For reference see Watir::ScreenCapture.screen_capture method in watir gem
    # by default it takes a screenshot of the desktop Ctrl+PrintScreen
    # any other arg snaps the last region Shift+PrintScreen (call with :region arg)
    def screenshot what=:desktop
      # WIN32API.new(dllname, func, import, export = "0")
      keybd_event = Win32API.new("user32", "keybd_event", ['I','I','L','L'], 'V')
      #keybd_event(bVk, bScan, dwFlags, dwExtraInfo)
      #Simulate a keyboard event
      if what == :desktop
        # Ctrl + PrintScreen keybd event
        keybd_event.Call(VK_CONTROL, 1, 0, 0)
        keybd_event.Call(VK_SNAPSHOT, 1, 0, 0)
        keybd_event.Call(VK_SNAPSHOT, 1, KEYEVENTF_KEYUP, 0)
        keybd_event.Call(VK_CONTROL, 1, KEYEVENTF_KEYUP, 0)
      else
        # Shift + PrintScreen keybd event
        keybd_event.Call(VK_SHIFT, 1, 0, 0)
        keybd_event.Call(VK_SNAPSHOT, 1, 0, 0)
        keybd_event.Call(VK_SNAPSHOT, 1, KEYEVENTF_KEYUP, 0)
        keybd_event.Call(VK_SHIFT, 1, KEYEVENTF_KEYUP, 0)
      end
      sleep 1 #give time to save
    end
  end
end

if $0 == __FILE__
  # sample usage
  include Watirloo::ScreenCapture
  screenshot #takes full screen
  screenshot :region # last set region. you must set region with PrintScreen first in greenshot
end