
class UserCtrl

    constructor: (@$log, @UserService, @$routeParams) ->
        @$log.debug "constructing UserController"
        @users = []
        @getAllUsers()

    getAllUsers: () ->
        @$log.debug "getAllUsers()"

        @UserService.listUsers()
        .then(
            (data) =>
                @$log.debug "Promise returned #{data.length} Users"
                angular.forEach(data, (userValueArray) =>
                  @format(userValueArray, @users)
                )
                @$log.debug "foreach returned  ... " + @users
#                @users = data
                @$log.debug @users
            ,
            (error) =>
                @$log.error "Unable to get Users: #{error}"
            )

    format : (userValueArray, users) ->
        user = {}
        user.id = userValueArray[0]
        user.firstname = userValueArray[1]
        user.lastname = userValueArray[2]
        user.mobileNo = userValueArray[3]
        user.age = userValueArray[4]
        users.push(user)

    deleteUser: () ->
      @$log.debug "deleteUser()"

      @UserService.deleteUser(@$routeParams.firstname)
      .then(
        (data) =>
          @$log.debug "Promise returned #{data.length} Users"
#          @users = data
      ,
      (error) =>
        @$log.error "Unable to get Users: #{error}"
      )


controllersModule.controller('UserCtrl', UserCtrl)