
class LoginPage
  def initialize(driver)
    @driver = driver
    @email_field = -> { @driver.find_element(:id, 'username') }
    @password_field = -> { @driver.find_element(:id, 'password') }
    @continue_button = -> { @driver.find_element(:name, 'action') }
    @error_message = -> { @driver.find_element(:class, 'ulp-input-error-message') }
  end

  def navigate_to(url)
    @driver.navigate.to url
  end

  def error_message
    begin
      @error_message.call.text
    rescue Selenium::WebDriver::Error::NoSuchElementError
      nil
    end
  end

  def error_present?
    !error_message.nil? && !error_message.empty?
  end

  def login(email, password)
    @email_field.call.send_keys(email)
    @continue_button.call.click
    if error_present?
      puts "Error encountered: #{error_message}"
    else
      @password_field.call.send_keys(password)
      @continue_button.call.click
    end
  end
end
