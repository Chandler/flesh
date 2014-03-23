Ember.Application.initializer
  name: "authentication"
  initialize: (container, application) ->

    # customize the session so that it allows access to the logged in user object
    Ember.SimpleAuth.Session.reopen user: (->
      userId = @get("user_id")
      container.lookup("store:main").find "user", userId  unless Ember.isEmpty(userId)
    ).property("userId")

    # register the custom authenticator so the session can find it
    container.register "app:authenticators:custom", App.CustomAuthenticator
    Ember.SimpleAuth.setup container, application

App = Ember.Application.create
  rootElement: "#app"
  LOG_TRANSITIONS: true

App.CustomAuthenticator = Ember.SimpleAuth.Authenticators.OAuth2.extend(authenticate: (credentials) ->
  new Ember.RSVP.Promise((resolve, reject) ->
    Ember.$.ajax(
      url: "/token"
      type: "POST"
      data:
        grant_type: "password"
        username: credentials.identification
        password: credentials.password
    ).then ((response) ->
      Ember.run ->
        # resolve (including the account id) as the AJAX request was successful; all properties this promise resolves
        # with will be available through the session
        resolve
          access_token: response.access_token
          user_id: response.user_id
    ), (xhr, status, error) ->
      Ember.run ->
        reject xhr.responseText
  )
)

App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin)


# App.ApplicationAdapter = DS.FixtureAdapter

App.ApplicationAdapter = DS.RESTAdapter.extend
  namespace: 'api'

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

Ember.TextField.reopen
  classNames: ['form-control']
