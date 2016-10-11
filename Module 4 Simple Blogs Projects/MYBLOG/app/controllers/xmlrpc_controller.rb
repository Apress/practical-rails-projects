class XmlrpcController < ApplicationController
  web_service_dispatching_mode :layered
  web_service(:metaWeblog) { MetaWeblogService.new() }
  web_service(:blogger)     { BloggerService.new }
end
