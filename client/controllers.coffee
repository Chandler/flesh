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

App.GameController = Ember.ObjectController.extend
  errors: ''
  code: ''

  clearErrors: ->
    @set 'errors', null

  registerTag: ->
    if @code != ''
      @clearErrors()
      currentPlayer = @get('session.user')
      $.post("/api/tag/" + @code + "?player_id=" + currentPlayer.get('id'))
      .done (xhr, status, error) =>
        @set 'errors', "success!" 
      .fail (xhr, status, error) =>
        contentType = xhr.getResponseHeader('content-type')
        if (contentType == "application.json")
          @set 'errors', JSON.parse(xhr.responseText)
        else
          @set 'errors', JSON.stringify(xhr.responseText) 
    else
        @set 'errors', "human code empty"


  
