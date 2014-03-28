
# you can only access the settings page if you're authenticated
App.UserEditRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: ->
    @modelFor('user');
)

App.UsersCreateRoute = Ember.Route.extend
  model: ->
    # the model for this route is a new empty Ember.Object
    @store.createRecord('user');

App.GameRoute = Ember.Route.extend
  setupController: (controller, model) ->
    #this has to come first
    controller.set('content', model)

    # events = @store.find('event')
    # controller.set('events', events)
