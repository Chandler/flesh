
# you can only access the settings page if you're authenticated
App.UserEditRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: ->
    @modelFor('user');
)

App.UsersCreateRoute = Ember.Route.extend
  model: ->
    # the model for this route is a new empty Ember.Object
    Em.Object.create {}

App.GameRoute = Ember.Route.extend
  setupController: (controller, model) ->
    #this has to come first
    controller.set('content', model)

    events = @store.find('event')
    controller.set('events', events)
    
    data = [
      {  "letter":"A", "frequency":0.01492 },
      {  "letter":"B", "frequency":0.08167 },
      {  "letter":"C", "frequency":0.02780 },
      {  "letter":"D", "frequency":0.04253 },
      {  "letter":"E", "frequency":0.12702 },
      {  "letter":"F", "frequency":0.02288 },
      {  "letter":"G", "frequency":0.02022 },
      {  "letter":"H", "frequency":0.06094 },
      {  "letter":"I", "frequency":0.06973 },
      {  "letter":"J", "frequency":0.00153 },
      {  "letter":"K", "frequency":0.00747 }
    ]

    controller.set('chart_data', data)    
    controller.set('chart_data2', [1,2,3])    
    
