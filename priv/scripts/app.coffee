
dependencies = [
    'ngRoute',
    'ui.bootstrap',
    'myApp.filters',
    'myApp.services',
    'myApp.controllers',
    'myApp.directives',
    'myApp.common',
    'ngTable',
    'myApp.routeConfig'
]

app = angular.module('myApp', dependencies)

angular.module('myApp.routeConfig', ['ngRoute'])
    .config ($routeProvider) ->
        $routeProvider
            .when('/users', {
                templateUrl: 'views/user-list.html'
            })
            .when('/user/create', {
                templateUrl: 'views/user-creation.html'
            })
            .when('/delete/:firstname', {
                templateUrl: 'views/user-delete.html'
              })
            .when('/edit/:firstname', {
              templateUrl: 'views/user-edit.html'
            })
            .otherwise({redirectTo: '/users'})

@commonModule = angular.module('myApp.common', [])
@controllersModule = angular.module('myApp.controllers', [])
@servicesModule = angular.module('myApp.services', [])
@modelsModule = angular.module('myApp.models', [])
@directivesModule = angular.module('myApp.directives', [])
@filtersModule = angular.module('myApp.filters', [])