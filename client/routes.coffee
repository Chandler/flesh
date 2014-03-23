
# you can only access the settings page if you're authenticated
App.UserEditRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: ->
    @modelFor('user');
)

App.UsersCreateRoute = Ember.Route.extend
  model: ->
    # the model for this route is a new empty Ember.Object
    Em.Object.create {}
