# TODO

### API

Add authentication methods

  * email, password

### Staffomatic.rb

----------

specifics:

* change `login` aka `username` to `email`
* remove `subdomain`


    export STAFFOMATIC_TEST_EMAIL='kalle@easypep.de'
    export STAFFOMATIC_TEST_PASSWORD="welcome"
    export STAFFOMATIC_TEST_TOKEN=""
    export STAFFOMATIC_TEST_CLIENT_ID=""
    export STAFFOMATIC_TEST_CLIENT_SECRET=""
    export STAFFOMATIC_API_ENDPOINT="http://demo.staffomatic.com/api/v3/"

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
    c.email = 'kalle@easypep.de'
    c.password = 'c0d3b4ssssss!'
    c.account = 'demo.staffomatic.com'
  end
  ```

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
