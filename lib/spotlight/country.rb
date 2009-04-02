class Spotlight
  class Country < Data

    def name
      begin
        return @data['Hostip']['countryName']
      rescue
        return nil
      end
    end

    def code
      begin
        return @data['Hostip']['countryAbbrev']
      rescue
        return nil
      end
    end

  end
end