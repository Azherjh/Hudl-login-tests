# Hudl Automation Test Framework (Login)

This repository provides an automated testing framework for Hudl's login functionality. The framework is built using **Selenium**, **RSpec** and **HTTParty** to perform both UI and API tests.

## Table of Contents
1. [Project Structure](#project-structure)
2. [Prerequisites](#prerequisites)
3. [Setup and Installation](#setup-and-installation)
4. [Running Tests](#running-tests)
5. [Test Cases](#test-cases)

## Project Structure

```
.
├── Gemfile                # Dependencies for the project
├── .rspec                 # RSpec configuration file
├── .env                   # Environment variables for sensitive data
├── spec/
│   ├── spec_helper.rb              # Common RSpec configuration
│   ├── failing_login_spec.rb       # Failing login UI tests
│   ├── successful_login_spec.rb    # Successful login UI tests
│   ├── login_cross_browser_test.rb # Cross-browser tests
│   ├── login_performance_tests.rb  # Performance tests
│   ├── login_security_tests.rb     # Security tests
│   ├── api/
│       ├── login_api_tests.rb  # API login tests
├── page_objects/
│   ├── login_page.rb      # Page Object Model for login page
└── README.md              # Documentation for the project
```

## Prerequisites

1. **Ruby**: Ensure Ruby is installed on your machine. I recommend using `rbenv` to manage Ruby versions.
2. **Bundler**: Install bundler using `gem install bundler`.
3. **Google Chrome**: Chrome should be installed as the default browser for Selenium tests.
4. **ChromeDriver**: Download the version of ChromeDriver compatible with your Chrome browser.
5. **Firefox & Geckodriver**: Install Firefox and Geckodriver for the cross browser test.
6. **Edge & msedgedriver**: Install MS Edge and msedgedriver for the cross browser test.

## Setup and Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Create a `.env` file for environment variables:
   ```env
   HUDL_EMAIL=your-email@example.com
   HUDL_PASSWORD=your-password
   ```

4. include the `chromedriver` location in your PATH environment variable

## Running Tests

Run all tests:
```bash
rspec
```

Run specific test files:
```bash
rspec spec/failing_login_spec.rb
```

## Test Cases

### UI Tests
- **Successful Login Tests**
  - Valid email and password
  - (NOTE: I did not create a login test for google, facebook or apple as i didn't want to use my credentials. Also, this test would require accessing a 3rd party service which is out of the exercise jurisdiction. If I had more time, i would create a simple mock of each 3rd party service and use that to test the behaviour of our service against possible outcomes received to make sure our service behaves correctly as expected.)

- **Failing Login Tests**
  - Invalid email and password combinations
  - Edge cases (special characters, without domain, whitespace)
  - Boundary cases for email and password fields

### API Tests
- **Login API Tests**
    NOTE: Cannot run the API tests as there are restrictions on accessing the API. 405 error. The endpoint might not be intended for direct API access via HTTP methods like POST.
  - Valid login credentials
  - Invalid email/password combinations
  - Missing email or password fields
  - Rate limiting (too many attempts)

---

Any Issues or questions, please do not hesitate to let me know or get in touch. azherjh@gmail.com

