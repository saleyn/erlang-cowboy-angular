
class EditUserCtrl

    constructor: (@$log, @$location,  @UserService, @$routeParams) ->
        @$log.debug "constructing EditUserController"
        @user = {}
        @findUser()

    findUser: () ->
        @$log.debug "findUser()"
        @UserService.findUser(@$routeParams.firstname)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} User"
#                @user = data
                @format(data, @user)
            ,
            (error) =>
                @$log.error "Unable to Find User: #{error}"
            )

    format : (data, user) ->
        angular.forEach(data, (userValueArray) =>
            user.id = userValueArray[0]
            user.firstname = userValueArray[1]
            user.lastname = userValueArray[2]
            user.mobileNo = userValueArray[3]
            user.age = userValueArray[4]
        )

    updateUser: () ->
        @$log.debug "updateUser()"
        @UserService.updateUser(@user)
        .then(
          (data) =>
            @$log.debug "Promise returned #{data} User"
            @user = data
            @$location.path("/users")
        ,
        (error) =>
          @$log.error "Unable to update User: #{error}"
        )

controllersModule.controller('EditUserCtrl', EditUserCtrl)