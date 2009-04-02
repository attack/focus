class Spotlight
  class Location < Data
  
    def name
      begin
        return @data['Hostip']['gml:name']
      rescue
        return nil
      end
    end
    
    def coordinates
      begin
        return @data['Hostip']['ipLocation']['gml:PointProperty']['gml:Point']['gml:coordinates']
      rescue
        return nil
      end
    end
  
    def longitude
      return unless self.coordinates
      self.coordinates.split(',')[0].to_f
    end
  
    def latitude
      return unless self.coordinates
      self.coordinates.split(',')[1].to_f
    end
  
  end
end