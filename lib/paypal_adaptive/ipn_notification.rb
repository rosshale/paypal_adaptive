module PaypalAdaptive
  class IpnNotification
    
    def initialize(data, env=nil)
      @@config ||= PaypalAdaptive::Config.new(env)
      @@paypal_base_url ||= @@config.paypal_base_url
      
      @data = data
      validate
    end
    
    def valid?
      @valid
    end
    
    protected
    
    def validate
      data = "cmd=_notify-validate&#{@data}"
      url = URI.parse @@paypal_base_url
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = (url.scheme == 'https')
      
      path = "#{@@paypal_base_url}/cgi-bin/webscr"
      resp, response_data = http.post(path, data)
      
      @valid = response_data == "VERIFIED"
    end
    
  end
end