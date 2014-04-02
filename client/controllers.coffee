App.LoginController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin,
  error: ''
  #set the custom authenticator
  authenticator: "app:authenticators:custom"
  
  actions:
    # display an error when authentication fails
    sessionAuthenticationFailed: (error) ->
      message = JSON.parse(error).error
      @set "error", message
)

App.UsersCreateController = Ember.ObjectController.extend
  error: ''
  success: ''
  
  actions:
    save: ->
      user = @get('model')
      user.save().then \
      #success
      () => 
        @transitionToRoute "login"
      ,
      #failure
      (xhr) => 
        #LOL
        contentType = xhr.getResponseHeader('content-type')
        if (contentType.indexOf("application/json") != -1)
          errorText = xhr.responseJSON.error
          if (errorText.indexOf("Bad Request") != -1)
            message = "Something went wrong, did you fill in all the fields?"
          else
            message = errorText
          @set 'error', errorText
        else
          @set 'error', "Something went wrong, did you fill in all the fields?" #JSON.stringify(xhr.responseText) 

App.UserEditController = Ember.ObjectController.extend
  error: ''
  success: ''

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
      (xhr) =>
        contentType = xhr.getResponseHeader('content-type')
        if (contentType.indexOf("application/json") != -1) #sigh, javascript
          @set 'error', xhr.responseJSON.error
        else
          @set 'error', "Something went wrong"

      
      # then transition to the current user
      #@transitionToRoute "user", user

App.PwresetController = Ember.ObjectController.extend
  error: ''
  success: ''
  email: ''

  clearAlerts: ->
    @set 'success', null
    @set 'error', null

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
        if (contentType.indexOf("application/json") != -1) #sigh, javascript
          @set 'error', xhr.responseJSON.error
        else
          @set 'error', JSON.stringify(xhr.responseText) 
    else
        @set 'error', "You didn't enter an email address"

App.GameController = Ember.ObjectController.extend
  error: ''
  success: ''
  code: ''
  gameStarted: false

  loggedInPlayer: (->
    user_id = @get('session.user_id')
    @get('players')
    .filterBy('user.id', user_id)[0]
  ).property('players.@each.user.id')

  clearAlerts: ->
    @set 'success', null
    @set 'error', null

  joinGame: ->    
    player = @store.createRecord('player')
    @get('session.user').then \
    (user) => 
      player.set('user', user)
      player.set('game', @get('model'))
      player.save().then \
      #success
      (player) => 
        @get('model.players').addObject(player);
        #@get('model').reload()
        @set 'success', 'You joined the game! Visit your profile to retrieve your human code.'
      ,
      #failure
      (xhr) => 
        contentType = xhr.getResponseHeader('content-type')
        if (contentType.indexOf("application/json") != -1)
          @set 'error', xhr.responseJSON.error
        else
          @set 'error', "Something went wrong, did you fill in all the fields?" #JSON.stringify(xhr.responseText) 

  registerTag: ->
    if @code != ''
      @clearAlerts()
      $.ajax(
        url: "/api/tags"
        type: "POST"
        data:
          tag:
            human_code: @code
      )
      .done (xhr, status, error) =>
        @set 'success', "success!" 
      .fail (xhr, status, error) =>
        contentType = xhr.getResponseHeader('content-type')
        if (contentType.indexOf("application/json") != -1)
          @set 'error', xhr.responseJSON.error
        else
          @set 'error', JSON.stringify(xhr.responseText) 
    else
        @set 'error', "human code empty"


