Ember.Application.initializer
  name: "authentication"
  initialize: (container, application) ->
    # customize the session so that it allows access to the logged in user object
    Ember.SimpleAuth.Session.reopen user: (->
      userId = @get("user_id")
  
      if not Ember.isEmpty(userId)
        container.lookup("store:main").find("user", userId).then \
        (user) ->
          #force a reload from the server so that we can get the authenticated
          #user object into memory, w/ email and human code ect
          user.reload()

    ).property("userId")

    # register the custom authenticator so the session can find it
    container.register "app:authenticators:custom", App.CustomAuthenticator
    
    Ember.SimpleAuth.setup container, application, {
      authorizer: App.CustomAuthorizer
    }

App = Ember.Application.create
  rootElement: "#app"
  LOG_TRANSITIONS: true

# Customize login requests and response handling
# sign in looks like: 
# { 
#   user: {
#     email: 'email'
#     password: 'password'
#   }
# }
# response looks like: 
# {
#   access_token: '234qerq4w5'
#   user_id: '3'
# }
App.CustomAuthenticator = Ember.SimpleAuth.Authenticators.OAuth2.extend(
  refreshAccessTokens: false, #don't do this because we are not actually using Oauth2
  authenticate: (credentials) ->
    new Ember.RSVP.Promise((resolve, reject) ->
      Ember.$.ajax(
        url: "/api/user/login"
        type: "POST"
        data:
          user:
            email: credentials.identification
            password: credentials.password
          
      ).then ((response) ->
        Ember.run ->
          # resolve (including the account id) as the AJAX request was successful; all properties this promise resolves
          # with will be available through the session
          resolve
            access_token: response.user.authentication_token
            user_id: response.user.id
            active_game_id: response.user.active_game_id
      ), (xhr, status, error) ->
        Ember.run ->
          reject xhr.responseText
    )
)

# Implement HTTP Basic Auth 
# Because ember-simple-auth really only
# comes with Oauth2 out of the box.
App.CustomAuthorizer = Ember.SimpleAuth.Authorizers.Base.extend(authorize: (jqXHR, requestOptions) ->
  id = @get("session.user_id")
  authentication_token = @get("session.access_token")
  if id? and authentication_token?
    basic_auth_unencoded =  id + ":" + authentication_token
    jqXHR.setRequestHeader("Authorization", "Basic " + window.btoa basic_auth_unencoded)
)

App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin)

# Use Fixtures data instead of the API
#App.ApplicationAdapter = DS.FixtureAdapter

# Make all models request data through /api/
App.ApplicationAdapter = DS.RESTAdapter.extend
  namespace: 'api'

App.RawTransform = DS.Transform.extend(
  deserialize: (value) ->
    moment(value).zone(7).format('MMM Do ha')

  serialize: (deserialized) ->
    null
)

# API returns _id and _ids, this converts
# those to the default ember json format
# player => player_id, players -> player_ids
App.ApplicationSerializer = DS.RESTSerializer.extend
  keyForRelationship: (key, relationship) ->
    if relationship == "hasMany"
      key.replace(/s*$/, '') + "_ids"
    else if relationship == "belongsTo"
      key + "_id"
    else 
      key

App.Router = Ember.Router.extend
  enableLogging: true
  location: 'history'

App.Router.map ->
  @route 'discovery'
  @route 'login'
  @resource 'users', ->
    @resource 'user', path: "/:user_id", ->
      @route 'edit'
    @route 'create'
  @resource 'games', ->
    @resource 'game', path: "/:game_id"
  @route 'pwreset'


# Add the form-control class to all text fields for styling
Ember.TextField.reopen
  classNames: ['form-control']

