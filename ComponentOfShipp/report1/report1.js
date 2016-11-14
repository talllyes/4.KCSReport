app.controller('report1', function ($rootScope, $scope, $http) {
    $scope.shipp.selectMenu = "report";
    $scope.shipp.selectMenuBase = "report";
    var report1 = this;
    report1.select = {};
    report1.baseData = [];
    report1.flag = false;

    report1.firstload = true;

    $("#mainpage").loadchange("on");

    function getReportList() {
        $http({
            method: 'GET',
            url: 'WebAPI/report1/ReportList'
        }).then(function successCallback(response) {
            report1.reportList = response.data;
            var yyy = "0";
            angular.forEach(report1.reportList.yyy, function (value, key) {
                if (value > yyy) {
                    yyy = value;
                }
            });
            var mm = "0";
            angular.forEach(report1.reportList.mm, function (value, key) {
                if (value.yyy == yyy) {
                    if (value.mm > mm) {
                        mm = value.mm;
                    }
                }
            });

            report1.select.yyy = yyy;
            report1.select.mm = mm;
            report1.yyychange();
        }, function errorCallback(response) {
            alert("取得科目失敗，請聯絡資訊室！");
        });
    }
    getReportList();

    report1.yyychange = function () {
        report1.mmList = report1.getMMList();
        report1.select.mm = report1.mmList[report1.mmList.length - 1];
    }
    report1.getMMList = function () {
        var out = [];
        angular.forEach(report1.reportList.mm, function (value, key) {
            if (value.yyy == report1.select.yyy) {
                out.push(value.mm);
            }
        });
        return out;
    }
    $scope.$watch('report1.select.mm', function () {
        if (report1.select.yyy != "") {
            getReport1();
        }
    });

    report1.excel = function () {
        var temp = report1.select.yyy + report1.select.mm;
        location.href = "WebAPI/excel1/Excel?date=" + temp;
    }


    function getReport1() {
        var temp = report1.select.yyy + report1.select.mm;
        if (temp) {
            if (!report1.firstload) {
                $("#mainpage2").loadchange("on");
            }
            $http({
                method: 'POST',
                url: 'WebAPI/report1/BaseData',
                data: temp
            }).then(function successCallback(response) {
                report1.baseData = response.data;
                report1.flag = true;
                if (report1.firstload) {
                    $("#mainpage").loadchange("off");
                    report1.firstload = false;
                } else {
                    $("#mainpage2").loadchange("off");
                }
            });

        }
    }
    report1.getGNum = function (sub) {
        if (report1.flag) {
            return eval('report1.baseData.' + sub);
        }
    }

    report1.getNOzero = function (num, type) {
        var intnn = parseInt(num);
        if (type == "1") {
            intnn = intnn - 1;
        }
        return intnn;
    }
});