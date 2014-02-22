App = Ember.Application.create
  rootElement: "#app"
  LOG_TRANSITIONS: true  

App.Store = DS.Store.extend
  adapter: DS.LSAdapter

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
