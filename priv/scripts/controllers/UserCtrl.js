// Generated by CoffeeScript 1.8.0
(function() {
  var UserCtrl;

  UserCtrl = (function() {
    function UserCtrl($log, UserService, $routeParams) {
      this.$log = $log;
      this.UserService = UserService;
      this.$routeParams = $routeParams;
      this.$log.debug("constructing UserController");
      this.users = [];
      this.getAllUsers();
    }

    UserCtrl.prototype.getAllUsers = function() {
      this.$log.debug("getAllUsers()");
      return this.UserService.listUsers().then((function(_this) {
        return function(data) {
          _this.$log.debug("Promise returned " + data.length + " Users");
          angular.forEach(data, function(userValueArray) {
            return _this.format(userValueArray, _this.users);
          });
          _this.$log.debug("foreach returned  ... " + _this.users);
          return _this.$log.debug(_this.users);
        };
      })(this), (function(_this) {
        return function(error) {
          return _this.$log.error("Unable to get Users: " + error);
        };
      })(this));
    };

    UserCtrl.prototype.format = function(userValueArray, users) {
      var user;
      user = {};
      user.id = userValueArray[0];
      user.firstname = userValueArray[1];
      user.lastname = userValueArray[2];
      user.mobileNo = userValueArray[3];
      user.age = userValueArray[4];
      return users.push(user);
    };

    UserCtrl.prototype.deleteUser = function() {
      this.$log.debug("deleteUser()");
      return this.UserService.deleteUser(this.$routeParams.firstname).then((function(_this) {
        return function(data) {
          return _this.$log.debug("Promise returned " + data.length + " Users");
        };
      })(this), (function(_this) {
        return function(error) {
          return _this.$log.error("Unable to get Users: " + error);
        };
      })(this));
    };

    return UserCtrl;

  })();

  controllersModule.controller('UserCtrl', UserCtrl);

}).call(this);