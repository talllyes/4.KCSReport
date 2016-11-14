app.controller('keyin', function ($rootScope, $scope, $http, $routeParams) {
    $scope.shipp.selectMenu = "keyin";
    $scope.shipp.selectMenuBase = "keyin";
    var keyin = this;
    keyin.data = [];
    keyin.addSelectSubject = [];
    keyin.insertSubmit = {};
    keyin.updateNum = 0;
    keyin.saveMessage = "";
    keyin.typeText = "";
    keyin.subjectAlldata = [];
    keyin.reportList = [];
    keyin.mmList = [];
    keyin.select = {
        "yyy": "",
        "mm": "",
        "Type": ""
    };
    keyin.edit = false;
    keyin.subjectbtnFlag = false;

    if ($routeParams.type == 'Subject1') {
        keyin.typeText = '資產負債表';
        keyin.type = '1';
        keyin.select.Type = "1";
    }

    function getReportList() {
        $http({
            method: 'GET',
            url: 'WebAPI/keyin/ReportList'
        }).then(function successCallback(response) {
            keyin.reportList = response.data;
            var yyy = "0";
            angular.forEach(keyin.reportList.yyy, function (value, key) {
                if (value > yyy) {
                    yyy = value;
                }
            });
            var mm = "0";
            angular.forEach(keyin.reportList.mm, function (value, key) {
                if (value.yyy == yyy) {
                    if (value.mm > mm) {
                        mm = value.mm;
                    }
                }
            });
            keyin.select.yyy = yyy;
            keyin.select.mm = mm;
            keyin.yyychange();
        }, function errorCallback(response) {
            alert("取得科目失敗，請聯絡資訊室！");
        });
    }
    getReportList();

    $scope.$watch('keyin.select.mm', function () {
        if (keyin.select.yyy != "") {
            getSubject();
        }
    });

    keyin.getMMList = function () {
        var out = [];
        angular.forEach(keyin.reportList.mm, function (value, key) {
            if (value.yyy == keyin.select.yyy) {
                out.push(value.mm);
            }
        });
        return out;
    }

    keyin.yyychange = function () {
        keyin.mmList = keyin.getMMList();
        keyin.select.mm = keyin.mmList[keyin.mmList.length - 1];
    }
    var first = true;
    function getSubject() {
        var temp = keyin.select.yyy + keyin.select.mm;
        if (!first) {
            $(".loaderIN").css("display", "");
            $(".loaderOK").css("display", "none");
            $(".loaderIN").height($(".loaderOK").height());
        }
        $http({
            method: 'POST',
            url: 'WebAPI/keyin/' + $routeParams.type,
            data: temp
        }).then(function successCallback(response) {
            keyin.data = response.data;
            if (first) {
                $(".startLoad").css("display", "none");
                $(".startLoadOK").css("display", "");
                $(".startLoadOK").css("opacity", "0");
                $(".startLoadOK").animate({ opacity: "1" }, 500);
                first = false;
            } else {
                $(".loaderIN").css("display", "none");
                $(".loaderOK").css("display", "");
                $(".loaderOK").css("opacity", "0");
                $(".loaderOK").animate({ opacity: "1" }, 500);
            }
        }, function errorCallback(response) {
            alert("取得科目失敗，請聯絡資訊室！");
        });
    }





    keyin.getNum = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum1;
                }
            });
        } else {
            angular.forEach(keyin.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum1;
                }
            });
            item.GNum1 = nn;
        }
        return nn;
    }


    keyin.getNum2 = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin.data, function (value, key) {
                if (value.Layer2 == item.SubjectID2) {
                    nn = nn + value.GNum21;
                }
            });
        } else {
            angular.forEach(keyin.data, function (value, key) {
                if (value.Layer2 == item.SubjectID2) {
                    nn = nn + value.GNum21;
                }
            });
            item.GNum21 = nn;
        }
        return nn;
    }


    keyin.getNumAll = function () {
        var nn = 0;
        angular.forEach(keyin.data, function (value, key) {
            if (!value.HaveCh) {
                nn = nn + value.GNum1;
            }
        });
        return nn;
    }

    keyin.getNumAll2 = function () {
        var nn = 0;
        angular.forEach(keyin.data, function (value, key) {
            if (!value.HaveCh2) {
                nn = nn + value.GNum21;
            }
        });
        return nn;
    }



    keyin.addSubject = function (item) {
        var temp = {};
        temp.ReportDate = keyin.select.yyy + keyin.select.mm;
        temp.SubjectID = item.SubjectID;
        temp.Type = keyin.select.Type;
        keyin.subjectbtnFlag = true;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin/AddSubject',
            data: temp
        }).then(function successCallback(response) {
            getSubjectAll();
            getSubject();
        }, function errorCallback(response) {
            alert("刪除失敗，請聯絡資訊室！");
            keyin.subjectbtnFlag = false;
        });
    }
    keyin.deleteSubject = function (item) {
        if (confirm("是否刪除「" + item.Name + "」，請注意刪除後已鍵入數值會清空。")) {
            keyin.subjectbtnFlag = true;
            var temp = {};
            temp.ReportDate = keyin.select.yyy + keyin.select.mm;
            temp.SubjectID = item.SubjectID;
            temp.Type = keyin.select.Type;
            $http({
                method: 'POST',
                url: 'WebAPI/keyin/DeleteSubject',
                data: temp
            }).then(function successCallback(response) {
                getSubjectAll();
                getSubject();
            }, function errorCallback(response) {
                alert("刪除失敗，請聯絡資訊室！");
                keyin.subjectbtnFlag = false;
            });
        }
    }

    keyin.fakeSave = function (item) {
        keyin.edit = false;
        var today = new Date();
        var hour = today.getHours();
        var minute = today.getMinutes();
        var second = today.getSeconds();
        keyin.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
        $("#saveSMessage").css("opacity", "1");
        $("#saveSMessage").stop();
        $("#saveSMessage").animate({ opacity: "0" }, 2500);
    }

    keyin.save = function (item) {
        var temp = {};
        temp.SubjectID = item.SubjectID;
        temp.ReportDate = keyin.select.yyy + keyin.select.mm;
        temp.GNum1 = item.GNum1;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin/UpdateSubject',
            data: temp
        }).then(function successCallback(response) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            keyin.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }, function errorCallback(response) {
            alert("儲存失敗，請聯絡資訊室！");
        });
    }

    keyin.save2 = function (item) {
        var temp = {};
        temp.SubjectID = item.SubjectID2;
        temp.ReportDate = keyin.select.yyy + keyin.select.mm;
        temp.GNum1 = item.GNum21;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin/UpdateSubject',
            data: temp
        }).then(function successCallback(response) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            keyin.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }, function errorCallback(response) {
            alert("儲存失敗，請聯絡資訊室！");
        });
    }



    keyin.saveCheck = function () {
        if (keyin.updateNum == 0) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            keyin.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }
    }



    keyin.add = function () {
        keyin.insertSubmit.Type = keyin.type;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin/AddNewReport',
            data: keyin.insertSubmit
        }).then(function successCallback(response) {
            if (response.data == "ok") {
                $('.kai-model-bg').css("display", "none");
                keyin.model = "";
                getReportList();
            } else {
                alert(response.data);
            }
        }, function errorCallback(response) {
        });
    }

    keyin.delete = function (item) {
        $('.kai-model-bg').css("display", "none");
        keyin.model = "";
        if (confirm("是否確定刪除「" + item.Name + "」？")) {
            $http({
                method: 'POST',
                url: 'WebAPI/keyin/DeleteSubject',
                data: item
            }).then(function successCallback(response) {
                getSubject();
            }, function errorCallback(response) {
            });
        }
    }


    keyin.detailShow = function () {
        $("#addRepport").css("top", window.document.body.scrollTop + 150);
        $('.kai-model-bg').css("display", "");
        keyin.model = "kai-in";
        keyin.insertSubmit = {
            ReportDate: "",
            Type: ""
        };
    }
    keyin.detailHide = function () {
        $('.kai-model-bg').css("display", "none");
        keyin.model2 = "";
        keyin.model = "";
    }
    keyin.model2 = "";


    keyin.configDetailShow = function () {
        $("#configShow").css("top", window.document.body.scrollTop + 150);
        $('.kai-model-bg').css("display", "");
        keyin.model2 = "kai-in";
        getSubjectAll();
    }
    function getSubjectAll() {
        $http({
            method: 'POST',
            url: 'WebAPI/keyin/getSubjectAll',
            data: keyin.select
        }).then(function successCallback(response) {
            keyin.subjectAlldata = response.data;
            keyin.subjectbtnFlag = false;
        }, function errorCallback(response) {
        });
    }


    $(".kai-model").css("left", ($("#nowbody").width() / 2) - 265);
});
$(window).resize(function () {
    $(".kai-model").css("left", ($("#nowbody").width() / 2) - 265);
});

$(window).scroll(function () {
    $(".kai-model").css("top", window.document.body.scrollTop + 150);
});