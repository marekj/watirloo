require File.dirname(__FILE__) + '/../lib/watirloo'

Watir::Browser.default='firefox'
Watir::Browser.new
Watirloo::Browsers.target = :firefox
