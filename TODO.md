# TODO

### API

Add authentication methods

  * email, password

### Staffomatic.rb

----------

specifics:

* change `login` aka `username` to `email`
* remove `subdomain`

    export STAFFOMATIC_TEST_EMAIL='admin@demo.de'
    export STAFFOMATIC_TEST_PASSWORD="welcome"
    export STAFFOMATIC_TEST_TOKEN='e8e5a42a6219839580d1952bd8c39538aeaf5796466c2d5652c022a57c9abf92'
    export STAFFOMATIC_TEST_CLIENT_ID=""
    export STAFFOMATIC_TEST_CLIENT_SECRET=""
    export STAFFOMATIC_API_ENDPOINT="http://demo.staffomatic-api.dev/api/v3/"

    export STAFFOMATIC_EMAIL='admin@demo.de'
    export STAFFOMATIC_PASSWORD="welcome"
    export STAFFOMATIC_TEST_TOKEN='e8e5a42a6219839580d1952bd8c39538aeaf5796466c2d5652c022a57c9abf92'
    export STAFFOMATIC_TEST_CLIENT_ID=""
    export STAFFOMATIC_TEST_CLIENT_SECRET=""
    export STAFFOMATIC_API_ENDPOINT="http://demo.staffomatic-api.dev/api/v3/"

----------

* push `OAuth access tokens` as default auth method.

* Change `Staffomatic.configure` from

  ```ruby
  Staffomatic.configure do |c|
    c.login = 'defunkt'
    c.password = 'c0d3b4ssssss!'
  end
  ```

to:

  ```ruby
  Staffomatic.configure do |c|
    c.email = 'admin@demo.de'
    c.password = 'c0d3b4ssssss!'
    c.account = 'demo.staffomatic.com'
  end
  ```

Helpers:

      stack = Faraday::RackBuilder.new do |builder|
        builder.response :logger
        builder.use Staffomatic::Response::RaiseError
        builder.adapter Faraday.default_adapter
      end

      Staffomatic.middleware = stack

      client = Staffomatic::Client.new(:access_token => ENV.fetch('STAFFOMATIC_TEST_TOKEN'))
      client.token_authenticated?
      client.all_users



* Remove `Two-Factor Authentication`

* Do not allow creating `create_authorization` from `Two-Factor Authentication`

      client.create_authorization(:scopes => ["user"], :note => "Name of token",
                                  :headers => { "X-Staffomatic-OTP" => "<your 2FA token>" })

* Do not allow creating `create_authorization` from `Two-Factor Authentication`

      client.create_authorization(:scopes => ["user"], :note => "Name of token")

* what is `web_endpoint`? removeit!

* `Hypermedia in Staffomatic` nice feature. what todo woth it?

* `:oauth_token` is now `:access_token` ?

* Faraday Http Cache
