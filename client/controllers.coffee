App.LoginController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin,
  #set the custom authenticator
  authenticator: "app:authenticators:custom"
  
  actions:
    # display an error when authentication fails
    sessionAuthenticationFailed: (error) ->
      message = JSON.parse(error).error
      @set "errorMessage", message
      return
)

App.UsersCreateController = Ember.ObjectController.extend
  actions:
    save: ->
      # create a record and save it to the store
      newUser = @store.createRecord("user", @get("model"))
      newUser.save()

      # redirects to the user itself
      @transitionToRoute "user", newUser

App.UserEditController = Ember.ObjectController.extend
  actions:
    save: ->
      user = @get("model")
      
      # this will tell Ember-Data to save/persist the new record
      user.save()
      
      # then transition to the current user
      #@transitionToRoute "user", user
