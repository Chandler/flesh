App.IndexRoute = Ember.Route.extend
  model: ->
    games: @store.find('game')

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

    $.get("/api/games/" + model.id + "/stats")
    .done (xhr, status, error) =>
      controller.set('zombie_count', xhr.zombie)
      controller.set('human_count', xhr.human)
      controller.set('starved_count', xhr.starved)

    events = @store.find('event', { resource: "game", id: model.get('id') })
    controller.set('events', events)

App.DiscoveryRoute = Ember.Route.extend
  model: ->
    games: @store.find('game')