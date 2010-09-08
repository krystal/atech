class ActionController::TestCase
  def assert_status(required)
    assert_equal required, @response.status
  end
  
  def assert_json(&block)
    decoded_json = ActiveSupport::JSON.decode(@response.body) rescue InvalidJsonObject.new
    assert !decoded_json.is_a?(InvalidJsonObject)
    block.call(decoded_json) if block_given?
  end
  
end

class InvalidJsonObject; end
