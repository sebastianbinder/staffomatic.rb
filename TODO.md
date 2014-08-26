# TODO

### API

### Staffomatic.rb

#### General

**scopes e.g.:**

`````ruby
def all_applications(options = {})
  paginate "applications", options
end

def location_applications(location_id, options = {})
  paginate "locations/#{location_id}/applications", options
end

def shift_applications(shift_id, options = {})
  paginate "shifts/#{shift_id}/applications", options
end
`````

**common filters e.g.:**

| Param           | Type      | Restriction                    | Ressource                       |
| --------------- | --------- | ------------------------------ | ------------------------------- |
| state           | [String]  | new or approved or declined    | Shift, Absences, Applications,  |
| location_ids    | [Array]   | array with location_ids        | Shift, Absences, Applications,  |
| user_ids        | [Array]   | array with user_ids            | Shift, Absences, Applications,  |
| department_ids  | [Array]   | array with department_ids      | Shift, Absences, Applications,  |
| from and until  | [Time]    | timestamps                     | Shift, Absences, Applications,  |
| since           | [Time]    | timestamp                      | Shift, Absences, Applications,  |
| search          | [String]  | search parameter               | Shift, Absences, Applications,  |


**attatchable, commentable**

* absences
* news_items
* user


#### User

* scopes
* create
* invite
* update

----------


wheneevr STAFFOMATIC_API_ENDPOINT is set.

    export STAFFOMATIC_TEST_EMAIL='admin@demo.de'
    export STAFFOMATIC_TEST_PASSWORD="welcome"
    export STAFFOMATIC_TEST_TOKEN='14f84dd0584049668e499da4323a61c7d08dd9351862e1895c9d96bbdd686235'
    export STAFFOMATIC_ACCOUNT="demo.staffomatic-api.dev"
    export STAFFOMATIC_TEST_CLIENT_ID=""
    export STAFFOMATIC_TEST_CLIENT_SECRET=""
    export STAFFOMATIC_TEST_SCHEME="http"

some tests need to work:

    export STAFFOMATIC_SCHEME="http"

----------

* Remove `Two-Factor Authentication`

* Do not allow creating `create_authorization` from `Two-Factor Authentication`

      client.create_authorization(:scopes => ["user"], :note => "Name of token",
                                  :headers => { "X-Staffomatic-OTP" => "<your 2FA token>" })

* Do not allow creating `create_authorization` from `Two-Factor Authentication`

      client.create_authorization(:scopes => ["user"], :note => "Name of token")

* `Hypermedia in Staffomatic` nice feature. what todo woth it?

* `:oauth_token` is now `:access_token` ?

* Faraday Http Cache
