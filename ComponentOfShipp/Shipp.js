var app = angular.module('shippApp', ['ngRoute', 'ngSanitize', 'ui.bootstrap']);

app.controller('shipp', function ($rootScope, $scope, $http) {
    var shipp = this;
    shipp.selectMenu = "";
    shipp.overMenu = "";
    shipp.selectMenuBase = "";

    shipp.mouseover = function () {
        shipp.selectMenu = '';
    }
    shipp.mouseleave = function () {
        shipp.selectMenu = shipp.selectMenuBase;
    }

    $(document).on('click', 'a', function (event) {
        $http({
            method: 'GET',
            url: 'WebAPI/check'
        }).then(function successCallback(response) {
            if (response.data != "ok") {
                location.href = "login.aspx";
            }
        }, function errorCallback(response) {
           
        });
    });
});
