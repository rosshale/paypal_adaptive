require 'helper'
require '../lib/request'

class CreateAccountTest < Test::Unit::TestCase
  def setup
    @account_request = PaypalAdaptive::Request.new("test")
  end

  def test_valid_create_account
    data_filepath =  "../test/data/valid_create_account_request.json"

    data = read_json_file(data_filepath)

    data["emailAddress"] = "joetester_#{Time.now.to_i}@example.com"

    pp_response = @account_request.create_account(data)

    assert pp_response.success?
    assert pp_response["redirectURL"]
  end

  def test_create_account_email_address_already_an_account
    data_filepath =  "../test/data/valid_create_account_request.json"

    data = read_json_file(data_filepath)

    data["emailAddress"] = "joetester@example.com"
    pp_response = @account_request.create_account(data)

    assert !pp_response.success?
    assert_equal "An account already exists for the specified email address", pp_response["error"].first["message"]
  end

end