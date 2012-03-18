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
      response = http.post(path, data)
      
      raise response.error! unless response.is_a?(Net::HTTPOK)
      
      @valid = response.body == "VERIFIED"
    end
    
  end
end