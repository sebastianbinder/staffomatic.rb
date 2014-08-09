Staffomatic.rb
=======================

https://github.com/staffomatic/staffomatic.rb

A Ruby API wrapper for STAFFOMATIC. Super Simple Employee Scheduling. https://staffomatic.com

## Installation

Staffomatic is packaged as a Ruby gem. We recommend you install it with Bundler by adding the following line to your Gemfile:

    gem 'staffomatic', '~> 0.0.1'

## Usage

### Requirements

All API usage happens through Staffomatic applications, please get in contact with me to create one.

### Getting Started

1. Create an Staffomatic-App (Please contact us, we will send you the credentials)

2. Supply two parameters to the Session class before you instantiate it:

        Staffomatic::Session.setup(api_key: ENV['STAFFOMATIC_API_KEY'], secret: ENV['STAFFOMATIC_SHARED_SECRET'])

3.  In order to access an account's data, apps need an access token from that specific account. This is a two-stage process.
    Before interacting with a shop for the first time an app should redirect the user to the following URL:

        GET https://ACCOUNT_SUBDOMAIN.staffomatic.com/api/v3/oauth/authorize

    * with the following parameters:

    * client_id – Required – The API key for your app

    * redirect_uri – Optional – The URL that the merchant will be sent to once authentication is complete.
      Defaults to the URL specified in the application settings and must be the
      host as that URL.

    First instantiate your session object:

        session = Staffomatic::Session.new("ACCOUNT_SUBDOMAIN.staffomatic.com")

    Then call:

        permission_url = session.create_permission_url([], "https://my_redirect_uri.com")

4.  Once authorized, the account redirects the owner to the return URL of your application with a parameter
    named 'code'. This is a temporary token that the app can exchange for a permanent access token. Make the following call:

        POST https://ACCOUNT_SUBDOMAIN.staffomatic.com/api/v3/admin/oauth/access_token

    with the following parameters:

    * client_id – Required – The API key for your app

    * client_secret – Required – The shared secret for your app

    * code – Required – The token you received in step 3

    and you'll get your permanent access token back in the response.

    There is a method to make the request and get the token for you.
    Pass all the params received from the previous call and the method will verify the params,
    extract the temp code and then request your token:

        token = session.request_token(params)

    This method will save the token to the session object and return it.
    For future sessions simply pass the token in when creating the session object:

        session = Staffomatic::Session.new("ACCOUNT_SUBDOMAIN.staffomatic.com", token)

5. The session must be activated before use:

        Staffomatic::Base.activate_session(session)

6. Now you're ready to make authorized API requests to your shop!


        account = Staffomatic::Account.current

        # Get a specific location
        location = Staffomatic::Location.find(179761209)

        # Create a new location
        location = Staffomatic::Location.new
        location.name = "BarBarossa"
        location.save

        # Update a location
        location.name = "BarJederVernunft"
        location.save


## Contributing to staffomatic-client-ruby

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 EASYPEP UG. See LICENSE.txt for
further details.
