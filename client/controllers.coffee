BaseMixin = Ember.Mixin.create
  errors: ''
  success: ''
  
App.LoginController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin,
  #set the custom authenticator
  authenticator: "app:authenticators:custom"
  
  actions:
    # display an error when authentication fails
    sessionAuthenticationFailed: (error) ->
      message = JSON.parse(error).error
      @set "errors", message
)

App.UsersCreateController = Ember.ObjectController.extend(BaseMixin,
  actions:
    save: ->
      user = @get('model')
      self = this
      user.save().then \
      #success
      () => 
        @transitionToRoute "login"
      ,
      #failure
      (xhr) => 
        contentType = xhr.getResponseHeader('content-type')
        if (contentType.indexOf("application/json") != -1)
          @set 'errors', JSON.parse(xhr.responseText)
        else
          @set 'errors', "Something went wrong, did you fill in all the fields?" #JSON.stringify(xhr.responseText) 
)
App.UserEditController = Ember.ObjectController.extend
  actions:
    save: ->
      user = @get("model")
      
      # this will tell Ember-Data to save/persist the new record
      user.save().then \
      #success
      () => 
        @set 'success', 'profile updated'
      ,
      #failure
      (xhr) -> 
        contentType = xhr.getResponseHeader('content-type')
        if (contentType.indexOf("application/json") != -1)
          self.set 'errors', JSON.parse(xhr.responseText)
        else
          self.set 'errors', "Something went wrong"

      
      # then transition to the current user
      #@transitionToRoute "user", user

App.PwresetController = Ember.ObjectController.extend
  errors: ''
  success: ''
  email: ''

  clearAlerts: ->
    @set 'success', null
    @set 'errors', null

  send: ->
    if @email != ''
      @clearAlerts()
      $.ajax(
        url: "/api/user/reset_password"
        type: "POST"
        data:
          user:
            email: @email
      )
      .done (xhr, status, error) =>
        @set 'success', "Your reset link was emailed to " + @email 
      .fail (xhr, status, error) =>
        contentType = xhr.getResponseHeader('content-type')
        debugger
        if (contentType.indexOf("application/json") != -1) #sigh, javascript
          @set 'errors', xhr.responseJSON.error
        else
          @set 'errors', JSON.stringify(xhr.responseText) 
    else
        @set 'errors', "You didn't enter an email address"

App.GameController = Ember.ObjectController.extend
  errors: ''
  code: ''
  gameStarted: false

  clearErrors: ->
    @set 'errors', null

  joinGame: ->    
    player = @store.createRecord('player')
    @get('session.user').then \
    (user) => 
      player.set('user', user)
      player.set('game', @get('model'))
      player.save()

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


