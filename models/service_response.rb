
class ServiceResponse

  attr_accessor :url
  attr_accessor :service_type
  attr_accessor :subtype
  attr_accessor :source  
  attr_accessor :text
  attr_accessor :note

  def initialize
    @url = ""
    @service_type = ""
    @subtype = ""
    @source = ""
    @text = ""
    @note = ""
  end

  def to_json
    ActiveSupport::JSON.encode(self)
  end
end