app.config(function ($routeProvider, $locationProvider) {
    $routeProvider
     .when('/home', {
         templateUrl: 'shipp/home',
         controller: 'home as home'
     })
     .when('/report1', {
         templateUrl: 'shipp/report1',
         controller: 'report1 as report1'
     })
     .when('/report2', {
         templateUrl: 'shipp/report2',
         controller: 'report2 as report2'
     })
     .when('/keyin/:type', {
         templateUrl: 'shipp/keyin',
         controller: 'keyin as keyin'
     })
     .when('/keyin2/:type', {
         templateUrl: 'shipp/keyin2',
         controller: 'keyin2 as keyin2'
     })
     .when('/keyin3/:type', {
         templateUrl: 'shipp/keyin3',
         controller: 'keyin3 as keyin3'
     })
     .when('/subjectConfig/:type', {
         templateUrl: 'shipp/subjectConfig',
         controller: 'subjectConfig as subjectConfig'
     })
    .otherwise({
        redirectTo: '/home'
    });
});
