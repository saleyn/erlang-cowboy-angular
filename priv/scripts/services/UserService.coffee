
class UserService

    @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
    @defaultConfig = { headers: @headers }

    constructor: (@$log, @$http, @$q) ->
        @$log.debug "constructing UserService"

    listUsers: () ->
        @$log.debug "listUsers()"
        deferred = @$q.defer()

        @$http.get("/users")
        .success((data, status, headers) =>
                @$log.info("Successfully listed Users - status #{status}")
                @$log.info("Successfully listed Users - data #{data}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to list Users - status #{status}")
                deferred.reject(data);
            )
        deferred.promise

    createUser: (user) ->
        @$log.debug "createUser #{angular.toJson(user, true)}"
        @$log.debug "createUser " + user.firstname + " " + user.lastname
        deferred = @$q.defer()

        @$http.post('/users', user)
        .success((data, status, headers) =>
                @$log.info("Successfully created User - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to create user - status #{status}")
                deferred.reject(data);
            )
        deferred.promise

    updateUser: (user) ->
        @$log.debug "updateUser #{angular.toJson(user, true)}"
        @$log.debug "updateUser " + user.firstname + " " + user.lastname
        deferred = @$q.defer()

        @$http.put('/users/'+user.id, user)
        .success((data, status, headers) =>
          @$log.info("Successfully update User - status #{status}")
          deferred.resolve(data)
        )
        .error((data, status, headers) =>
          @$log.error("Failed to update user - status #{status}")
          deferred.reject(data);
        )
        deferred.promise

    findUser: (firstname) ->
      @$log.debug "findUser()"
      deferred = @$q.defer()

      @$http.get("/users/"+firstname)
      .success((data, status, headers) =>
        @$log.info("Successfully find User - status #{status}")
        @$log.info("Successfully find User - data #{data}")
        deferred.resolve(data)
      )
      .error((data, status, headers) =>
        @$log.error("Failed to find User - status #{status}")
        deferred.reject(data);
      )
      deferred.promise

    deleteUser: (firstname) ->
      @$log.debug "deleteUser()"
      deferred = @$q.defer()

      @$http.delete("/users/"+firstname)
      .success((data, status, headers) =>
        @$log.info("Successfully Delete User - status #{status}")
        @$log.info("Successfully Delete User - data #{data}")
        deferred.resolve(data)
      )
      .error((data, status, headers) =>
        @$log.error("Failed to Delete User - status #{status}")
        deferred.reject(data);
      )
      deferred.promise

servicesModule.service('UserService', UserService)