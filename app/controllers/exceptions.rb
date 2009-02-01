class Exceptions < Merb::Controller
  
  # handle NotFound exceptions (404)
  def not_found
    render :format => :html
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render :format => :html
  end

  def not_human
    render :format => :html
  end

end

class NotHuman < Merb::ControllerExceptions::NotFound
end