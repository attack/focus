require 'rubygems'
gem 'jnunemaker-httparty'
require 'httparty'

require File.dirname(__FILE__) + '/focus/data'
require File.dirname(__FILE__) + '/focus/country'
require File.dirname(__FILE__) + '/focus/location'
 
class Focus
  include HTTParty
  base_uri "api.hostip.info"

  attr_reader :ip
    
  def initialize(ip_address)
    raise unless Focus.valid?(ip_address)
    @ip = ip_address
    self.locate
    self
  end

  # generate a key from the ip_address
  def self.key(ip_address, prefix="focus")
    raise unless self.valid?(ip_address)
    segments = [prefix]
    # this ip_address does not need to be encoded as it is a valid
    # ip_address and only contains key-friendly chars
    segments << ip_address
    segments.join('-')
  end

  def country
    @country ||= Country.new(@result)
  end

  def location
    @location ||= Location.new(@result)
  end
  
  protected
  
  # actually query HostIP.info with the 'IP address'
  def locate
    @result ||= self.class.get(
      "/",
      :query => {:ip => @ip},
      :format => :xml
    )['HostipLookupResultSet']['gml:featureMember']
  end
  
  # validate an ip_address
  # regular expression from http://www.ruby-forum.com/topic/62553
  def self.valid?(ip_address)
    return false unless ip_address.is_a?(String)
    regexp = Regexp.new(/(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}/)
    return false unless regexp =~ ip_address
    return true
  end
  
end