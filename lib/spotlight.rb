require 'rubygems'
gem 'jnunemaker-httparty'
require 'httparty'

require File.dirname(__FILE__) + '/spotlight/data'
require File.dirname(__FILE__) + '/spotlight/country'
require File.dirname(__FILE__) + '/spotlight/location'
 
class Spotlight
  include HTTParty
  base_uri "api.hostip.info"

  attr_reader :ip
    
  def initialize(ip_address)
    # validate ip_address format
    raise unless Spotlight.valid?(ip_address)
    # we are all clear, save the ip
    @ip = ip_address
    # query hostip.info
    self.shine
    self
  end

  # generate a key from the ip_address
  def self.key(ip_address, prefix="spotlight")
    # validate ip_address format
    raise unless self.valid?(ip_address)
    # all clear, generate the key
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
  # NOTE: 'shine' might not be the best name for the method, other possibles
  # include: query, fetch, get, direct, ask, locate, target ... ???
  def shine
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