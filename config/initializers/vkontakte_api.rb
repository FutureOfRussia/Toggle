VkontakteApi.configure do |config|
  # Authorization parameters (not needed when using an external authorization):
  config.app_id       = '5885713'
  config.app_secret   = 'jCiavFrtdDpDXOgrMq2h'
  config.redirect_uri = 'http://api.vkontakte.ru/blank.html' 
  
  # Faraday adapter to make requests with:
  config.adapter = :net_http
  
  # HTTP verb for API methods (:get or :post)
  config.http_verb = :get
  
  # Logging parameters:
  # log everything through the rails logger
  config.logger = Rails.logger
  
  # log requests' URLs
  config.log_requests = true
  
  # log response JSON after errors
  config.log_errors = true
  
  # log response JSON after successful responses
  config.log_responses = false
  config.api_version = '5.62'
end

# create a short alias VK for VkontakteApi module
# VkontakteApi.register_alias
