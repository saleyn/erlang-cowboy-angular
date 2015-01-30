
class DeleteUserCtrl

    constructor: (@$log, @$location,  @UserService, @$routeParams) ->
        @$log.debug "constructing DeleteUserController"
        @user = {}
        @deleteUser()

    deleteUser: () ->
        @$log.debug "deleteUser()"
        @UserService.deleteUser(@$routeParams.firstname)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} User"
                @user = data
            ,
            (error) =>
                @$log.error "Unable to Delete User: #{error}"
            )

controllersModule.controller('DeleteUserCtrl', DeleteUserCtrl)