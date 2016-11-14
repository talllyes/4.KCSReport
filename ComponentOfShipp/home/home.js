app.controller('home', function ($rootScope, $scope, $http) {
    var home = this;
    home.newsData = [];
    home.myPage = new kaiSearch({                         //宣告分頁元件
        controllerScope: $scope,
        controllerName: 'home.myPage',
        maxSize: 5,
        itemsPerPage: 10,
        watch: ["searchKey"],
    });


    $http({
        method: 'GET',
        url: 'WebAPI/home/home'
    }).then(function successCallback(response) {
        home.newsData = response.data;
        home.myPage.setData(response.data);
    }, function errorCallback(response) {
    });


});