# Staffomatic

Ruby toolkit for the Staffomatic API.

## Philosophy

API wrappers [should reflect the idioms of the language in which they were
written][wrappers]. Staffomatic.rb wraps the [Staffomatic API][staffomatic-api] in a flat API
client that follows Ruby conventions and requires little knowledge of REST.
Most methods have positional arguments for required input and an options hash
for optional parameters, headers, or other options:

```ruby
# Fetch a README with Accept header for HTML format
Staffomatic.readme 'al3x/sovereign', :accept => 'application/vnd.staffomatic.html'
```

[wrappers]: http://wynnnetherland.com/journal/what-makes-a-good-api-wrapper
[staffomatic-api]: http://developer.github.com

## Quick start

Install via Rubygems

    gem install staffomatic

... or add to your Gemfile

    gem "staffomatic", "~> 3.0"

### Making requests

API methods are available as module methods (consuming module-level
configuration) or as client instance methods.

```ruby
# Provide authentication credentials
Staffomatic.configure do |c|
  c.login = 'defunkt'
  c.password = 'c0d3b4ssssss!'
end

# Fetch the current user
Staffomatic.user
```
or

```ruby
# Provide authentication credentials
client = Staffomatic::Client.new(:login => 'defunkt', :password => 'c0d3b4ssssss!')
# Fetch the current user
client.user
```

### Consuming resources

Most methods return a `Resource` object which provides dot notation and `[]`
access for fields returned in the API response.

```ruby
# Fetch a user
user = Staffomatic.user 'jbarnette'
puts user.name
# => "John Barnette"
puts user.fields
# => <Set: {:login, :id, :gravatar_id, :type, :name, :company, :blog, :location, :email, :hireable, :bio, :public_repos, :followers, :following, :created_at, :updated_at, :public_gists}>
puts user[:company]
# => "Staffomatic"
user.rels[:gists].href
# => "https://api.staffomatic.com/users/jbarnette/gists"
```

**Note:** URL fields are culled into a separate `.rels` collection for easier
[Hypermedia](#hypermedia-agent) support.

### Accessing HTTP responses

While most methods return a `Resource` object or a Boolean, sometimes you may
need access to the raw HTTP response headers. You can access the last HTTP
response with `Client#last_response`:

```ruby
user      = Staffomatic.user 'andrewpthorp'
response  = Staffomatic.last_response
etag      = response.headers[:etag]
```

## Authentication

Staffomatic supports the various [authentication methods supported by the Staffomatic
API][auth]:

### Basic Authentication

Using your Staffomatic username and password is the easiest way to get started
making authenticated requests:

```ruby
client = Staffomatic::Client.new \
  :login    => 'defunkt',
  :password => 'c0d3b4ssssss!'

user = client.user
user.login
# => "defunkt"
```
While Basic Authentication allows you to get started quickly, OAuth access
tokens are the preferred way to authenticate on behalf of users.

### OAuth access tokens

[OAuth access tokens][oauth] provide two main benefits over using your username
and password:

* **Revokable access**. Access tokens can be revoked, removing access for only
  that token without having to change your password everywhere.
* **Limited access**. Access tokens have [access scopes][] which allow for more
  granular access to API resources. For instance, you can grant a third party
  access to your gists but not your private repositories.

To use an access token with the Staffomatic client, pass your token in the
`:access_token` options parameter in lieu of your username and password:

```ruby
client = Staffomatic::Client.new(:access_token => "<your 40 char token>")

user = client.user
user.login
# => "defunkt"
```

You can [create access tokens through your Staffomatic Account Settings](https://help.staffomatic.com/articles/creating-an-access-token-for-command-line-use)
or with a basic authenticated Staffomatic client:

```ruby
client = Staffomatic::Client.new \
  :login    => 'defunkt',
  :password => 'c0d3b4ssssss!'

client.create_authorization(:scopes => ["user"], :note => "Name of token")
# => <your new oauth token>
```

### Application authentication

Staffomatic also supports application-only authentication [using OAuth application client
credentials][app-creds]. Using application credentials will result in making
anonymous API calls on behalf of an application in order to take advantage of
the higher rate limit.

```ruby
client = Staffomatic::Client.new \
  :client_id     => "<your 20 char id>",
  :client_secret => "<your 40 char secret>"

user = client.user 'defunkt'
```

[auth]: http://developer.github.com/v3/#authentication
[oauth]: http://developer.github.com/v3/oauth/
[access scopes]: http://developer.github.com/v3/oauth/#scopes
[app-creds]: http://developer.github.com/v3/#unauthenticated-rate-limited-requests

## Pagination

Many Staffomatic API resources are [paginated][]. While you may be tempted to start
adding `:page` parameters to your calls, the API returns links to the next,
previous, and last pages for you in the `Link` response header as [Hypermedia
link relations](#hypermedia-agent).

```ruby
issues = Staffomatic.issues 'rails/rails', :per_page => 100
issues.concat Staffomatic.last_response.rels[:next].get.data
```

### Auto pagination

For smallish resource lists, Staffomatic provides auto pagination. When this is
enabled, calls for paginated resources will fetch and concatenate the results
from every page into a single array:

```ruby
Staffomatic.auto_paginate = true
issues = Staffomatic.issues 'rails/rails'
issues.length

# => 702
```

**Note:** While Staffomatic auto pagination will set the page size to the maximum
`100`, and seek to not overstep your rate limit, you probably want to use a
custom pattern for traversing large lists.

[paginated]: http://developer.github.com/v3/#pagination

## Configuration and defaults

While `Staffomatic::Client` accepts a range of options when creating a new client
instance, Staffomatic's configuration API allows you to set your configuration
options at the module level. This is particularly handy if you're creating a
number of client instances based on some shared defaults.

### Configuring module defaults

Every writable attribute in {Staffomatic::Configurable} can be set one at a time:

```ruby
Staffomatic.api_endpoint = 'http://api.staffomatic.dev'
Staffomatic.web_endpoint = 'http://staffomatic.dev'
```

or in batch:

```ruby
Staffomatic.configure do |c|
  c.api_endpoint = 'http://api.staffomatic.dev'
  c.web_endpoint = 'http://staffomatic.dev'
end
```

### Using ENV variables

Default configuration values are specified in {Staffomatic::Default}. Many
attributes will look for a default value from the ENV before returning
Staffomatic's default.

```ruby
# Given $STAFFOMATIC_API_ENDPOINT is "http://api.staffomatic.dev"
Staffomatic.api_endpoint

# => "http://api.staffomatic.dev"
```

Deprecation warnings and API endpoints in development preview warnings are
printed to STDOUT by default, these can be disabled by setting the ENV
`STAFFOMATIC_SILENT=true`.

## Hypermedia agent

Starting in version 3.0, Staffomatic is [hypermedia][]-enabled. Under the hood,
{Staffomatic::Client} uses [Sawyer][], a hypermedia client built on [Faraday][].

### Hypermedia in Staffomatic

Resources returned by Staffomatic methods contain not only data but hypermedia
link relations:

```ruby
user = Staffomatic.user 'technoweenie'

# Get the repos rel, returned from the API
# as repos_url in the resource
user.rels[:repos].href
# => "https://api.staffomatic.com/users/technoweenie/repos"

repos = user.rels[:repos].get.data
repos.last.name
# => "faraday-zeromq"
```

When processing API responses, all `*_url` attributes are culled in to the link
relations collection. Any `url` attribute becomes `.rels[:self]`.

### URI templates

You might notice many link relations have variable placeholders. Staffomatic
supports [URI Templates][uri-templates] for parameterized URI expansion:

```ruby
repo = Staffomatic.repo 'pengwynn/pingwynn'
rel = repo.rels[:issues]
# => #<Sawyer::Relation: issues: get https://api.staffomatic.com/repos/pengwynn/pingwynn/issues{/number}>

# Get a page of issues
rel.get.data

# Get issue #2
rel.get(:uri => {:number => 2}).data
```

### The Full Hypermedia Experience™

If you want to use Staffomatic as a pure hypermedia API client, you can start at
the API root and follow link relations from there:

```ruby
root = Staffomatic.root
root.rels[:repository].get :uri => {:owner => "staffomatic", :repo => "staffomatic.rb" }
```

Staffomatic 3.0 aims to be hypermedia-driven, removing the internal URL
construction currently used throughout the client.

[hypermedia]: http://en.wikipedia.org/wiki/Hypermedia
[Sawyer]: https://staffomatic.com/lostisland/sawyer
[Faraday]: https://staffomatic.com/lostisland/faraday
[uri-templates]: http://tools.ietf.org/html/rfc6570

## Advanced usage

Since Staffomatic employs [Faraday][faraday] under the hood, some behavior can be
extended via middleware.

### Debugging

Often, it helps to know what Staffomatic is doing under the hood. You can add a
logger to the middleware that enables you to peek into the underlying HTTP
traffic:

```ruby
stack = Faraday::RackBuilder.new do |builder|
  builder.response :logger
  builder.use Staffomatic::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Staffomatic.middleware = stack
Staffomatic.user 'pengwynn'
```
```
I, [2013-08-22T15:54:38.583300 #88227]  INFO -- : get https://api.staffomatic.com/users/pengwynn
D, [2013-08-22T15:54:38.583401 #88227] DEBUG -- request: Accept: "application/vnd.staffomatic.beta+json"
User-Agent: "Staffomatic Ruby Gem 2.0.0.rc4"
I, [2013-08-22T15:54:38.843313 #88227]  INFO -- Status: 200
D, [2013-08-22T15:54:38.843459 #88227] DEBUG -- response: server: "Staffomatic.com"
date: "Thu, 22 Aug 2013 20:54:40 GMT"
content-type: "application/json; charset=utf-8"
transfer-encoding: "chunked"
connection: "close"
status: "200 OK"
x-ratelimit-limit: "60"
x-ratelimit-remaining: "39"
x-ratelimit-reset: "1377205443"
...
```

See the [Faraday README][faraday] for more middleware magic.

### Caching

If you want to boost performance, stretch your API rate limit, or avoid paying
the hypermedia tax, you can use [Faraday Http Cache][cache].

Add the gem to your Gemfile

    gem 'faraday-http-cache'

Next, construct your own Faraday middleware:

```ruby
stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache
  builder.use Staffomatic::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Staffomatic.middleware = stack
```

Once configured, the middleware will store responses in cache based on ETag
fingerprint and serve those back up for future `304` responses for the same
resource. See the [project README][cache] for advanced usage.


[cache]: https://staffomatic.com/plataformatec/faraday-http-cache
[faraday]: https://staffomatic.com/lostisland/faraday

## Hacking on Staffomatic.rb

If you want to hack on Staffomatic locally, we try to make [bootstrapping the
project][bootstrapping] as painless as possible. To start hacking, clone and run:

    script/bootstrap

This will install project dependencies and get you up and running. If you want
to run a Ruby console to poke on Staffomatic, you can crank one up with:

    script/console

Using the scripts in `./scripts` instead of `bundle exec rspec`, `bundle
console`, etc.  ensures your dependencies are up-to-date.

### Running and writing new tests

Staffomatic uses [VCR][] for recording and playing back API fixtures during test
runs. These cassettes (fixtures) are part of the Git project in the `spec/cassettes`
folder. If you're not recording new cassettes you can run the specs with existing
cassettes with:

    script/test

Staffomatic uses environmental variables for storing credentials used in testing.
If you are testing an API endpoint that doesn't require authentication, you
can get away without any additional configuration. For the most part, tests
use an authenticated client, using a token stored in `ENV['STAFFOMATIC_TEST_TOKEN']`.
There are several different authenticating method's used accross the api.
Here is the full list of configurable environmental variables for testing
Staffomatic:

ENV Variable | Description |
:-------------------|:-----------------|
`STAFFOMATIC_TEST_EMAIL`| Staffomatic login email (preferably one created specifically for testing against).
`STAFFOMATIC_TEST_PASSWORD`| Password for the test Staffomatic login.
`STAFFOMATIC_TEST_TOKEN` | [Personal Access Token](https://staffomatic.com/blog/1509-personal-api-tokens) for the test Staffomatic login.
`STAFFOMATIC_TEST_CLIENT_ID` | Test OAuth application client id.
`STAFFOMATIC_TEST_CLIENT_SECRET` | Test OAuth application client secret.
`STAFFOMATIC_TEST_REPOSITORY` | Test repository to perform destructive actions against, this should not be set to any repository of importance. **Automatically created by the test suite if nonexistent** Default: `api-sandbox`
`STAFFOMATIC_TEST_ORGANIZATION` | Test organization.

Since we periodically refresh our cassettes, please keep some points in mind
when writing new specs.

* **Specs should be idempotent**. The HTTP calls made during a spec should be
  able to be run over and over. This means deleting a known resource prior to
  creating it if the name has to be unique.
* **Specs should be able to be run in random order.** If a spec depends on
  another resource as a fixture, make sure that's created in the scope of the
  spec and not depend on a previous spec to create the data needed.
* **Do not depend on authenticated user info.** Instead of asserting
  actual values in resources, try to assert the existence of a key or that a
  response is an Array. We're testing the client, not the API.

[bootstrapping]: http://wynnnetherland.com/linked/2013012801/bootstrapping-consistency
[VCR]: https://staffomatic.com/vcr/vcr

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0
* Ruby 2.1.0

If something doesn't work on one of these Ruby versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, but support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be responsible for providing patches in a timely
fashion. If critical issues for a particular implementation exist at the time
of a major release, support for that Ruby version may be dropped.

[travis]: https://travis-ci.org/staffomatic/staffomatic.rb

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pvc] with two digits of precision. For example:

    spec.add_dependency 'staffomatic', '~> 3.0'

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74

## License

Copyright (c) 2013-2014 Kalle Saas

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Github License

Copyright (c) 2009-2014 Wynn Netherland, Adam Stacoviak, Erik Michaels-Ober

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
