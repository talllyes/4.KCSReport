app.controller('keyin3', function ($rootScope, $scope, $http, $routeParams) {
    $scope.shipp.selectMenu = "keyin";
    $scope.shipp.selectMenuBase = "keyin";
    var keyin3 = this;

    keyin3.data = [];
    keyin3.addSelectSubject = [];
    keyin3.insertSubmit = {};
    keyin3.updateNum = 0;
    keyin3.saveMessage = "";
    keyin3.typeText = "";
    keyin3.subjectAlldata = [];
    keyin3.reportList = [];
    keyin3.mmList = [];
    keyin3.select = {
        "yyy": "",
        "mm": "",
        "Type": ""
    };
    keyin3.rootSubject = 0;
    keyin3.subjectbtnFlag = false;
    keyin3.edit = false;
    if ($routeParams.type == 'Subject3') {
        keyin3.typeText = '收入明細表';
        keyin3.type = '3';
        keyin3.select.Type = "3";
        keyin3.rootSubject = 30;
    } else if ($routeParams.type == 'Subject4') {
        keyin3.typeText = '航行費用明細表';
        keyin3.type = '4';
        keyin3.select.Type = "4";
        keyin3.rootSubject = 31;
    } else if ($routeParams.type == 'Subject5') {
        keyin3.typeText = '管理費用明細表';
        keyin3.type = '5';
        keyin3.select.Type = "5";
        keyin3.rootSubject = 32;
    } else if ($routeParams.type == 'Subject6') {
        keyin3.typeText = '利息費用明細表';
        keyin3.type = '6';
        keyin3.select.Type = "6";
        keyin3.rootSubject = 33;
    } else if ($routeParams.type == 'Subject7') {
        keyin3.typeText = '雜項費用明細表';
        keyin3.type = '7';
        keyin3.select.Type = "7";
        keyin3.rootSubject = 34;
    }

    function getReportList() {
        $http({
            method: 'POST',
            url: 'WebAPI/keyin3/ReportList',
            data: keyin3.select
        }).then(function successCallback(response) {
            keyin3.reportList = response.data;
            var yyy = "0";
            angular.forEach(keyin3.reportList.yyy, function (value, key) {
                if (value > yyy) {
                    yyy = value;
                }
            });
            var mm = "0";
            angular.forEach(keyin3.reportList.mm, function (value, key) {
                if (value.yyy == yyy) {
                    if (value.mm > mm) {
                        mm = value.mm;
                    }
                }
            });
            keyin3.select.yyy = yyy;
            keyin3.select.mm = mm;
            keyin3.yyychange();
        }, function errorCallback(response) {
            alert("取得科目失敗，請聯絡資訊室！");
        });
    }
    getReportList();

    $scope.$watch('keyin3.select.mm', function () {
        if (keyin3.select.yyy != "") {
            getSubject();
        }
    });

    keyin3.getMMList = function () {
        var out = [];
        angular.forEach(keyin3.reportList.mm, function (value, key) {
            if (value.yyy == keyin3.select.yyy) {
                out.push(value.mm);
            }
        });
        return out;
    }

    keyin3.yyychange = function () {
        keyin3.mmList = keyin3.getMMList();
        keyin3.select.mm = keyin3.mmList[keyin3.mmList.length - 1];
    }

    var first = true;
    function getSubject() {
        var temp = {};
        temp.ReportDate = keyin3.select.yyy + keyin3.select.mm;
        temp.rootSubject = keyin3.rootSubject;
        if (!first) {
            $(".loaderIN").css("display", "");
            $(".loaderOK").css("display", "none");
            $(".loaderIN").height($(".loaderOK").height());
        }
        $http({
            method: 'POST',
            url: 'WebAPI/keyin3/Subject3',
            data: temp
        }).then(function successCallback(response) {
            keyin3.data = response.data;
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

    keyin3.getNum = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum1;
                }
            });
        } else {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum1;
                }
            });
            item.GNum1 = nn;
        }
        return nn;
    }
    keyin3.getNum2 = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum2;
                }
            });
        } else {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum2;
                }
            });
            item.GNum2 = nn;
        }
        return nn;
    }
    keyin3.getNum3 = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum3;
                }
            });
        } else {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum3;
                }
            });
            item.GNum3 = nn;
        }
        return nn;
    }

    keyin3.getAllNum2 = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.AllGNum2;
                }
            });
        } else {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.AllGNum2;
                }
            });
            item.AllGNum2 = nn;
        }
        return nn;
    }

    keyin3.getAllNum3 = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.AllGNum3;
                }
            });
        } else {
            angular.forEach(keyin3.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.AllGNum3;
                }
            });
            item.AllGNum3 = nn;
        }
        return nn;
    }





    keyin3.getNumAll = function () {
        var nn = 0;
        angular.forEach(keyin3.data, function (value, key) {
            if (!value.HaveCh) {
                nn = nn + value.GNum1;
            }
        });
        return nn;
    }

    keyin3.getNumAll2 = function () {
        var nn = 0;
        angular.forEach(keyin3.data, function (value, key) {
            if (!value.HaveCh2) {
                nn = nn + value.GNum21;
            }
        });
        return nn;
    }



    keyin3.addSubject = function (item) {
        var temp = {};
        temp.ReportDate = keyin3.select.yyy + keyin3.select.mm;
        temp.SubjectID = item.SubjectID;
        temp.Type = keyin3.select.Type;
        keyin3.subjectbtnFlag = true;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin3/AddSubject',
            data: temp
        }).then(function successCallback(response) {
            getSubjectAll();
            getSubject();
        }, function errorCallback(response) {
            alert("刪除失敗，請聯絡資訊室！");
            keyin3.subjectbtnFlag = false;
        });
    }
    keyin3.deleteSubject = function (item) {
        if (confirm("是否刪除「" + item.Name + "」，請注意刪除後已鍵入數值會清空。")) {
            keyin3.subjectbtnFlag = true;
            var temp = {};
            temp.ReportDate = keyin3.select.yyy + keyin3.select.mm;
            temp.SubjectID = item.SubjectID;
            temp.Type = keyin3.select.Type;
            $http({
                method: 'POST',
                url: 'WebAPI/keyin3/DeleteSubject',
                data: temp
            }).then(function successCallback(response) {
                getSubjectAll();
                getSubject();
            }, function errorCallback(response) {
                alert("刪除失敗，請聯絡資訊室！");
                keyin3.subjectbtnFlag = false;
            });
        }
    }


    keyin3.fakeSave = function (item) {
        keyin3.edit = false;
        var today = new Date();
        var hour = today.getHours();
        var minute = today.getMinutes();
        var second = today.getSeconds();
        keyin3.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
        $("#saveSMessage").css("opacity", "1");
        $("#saveSMessage").stop();
        $("#saveSMessage").animate({ opacity: "0" }, 2500);
    }






    keyin3.save = function (item) {
        var temp = {};
        temp.SubjectID = item.SubjectID;
        temp.ReportDate = keyin3.select.yyy + keyin3.select.mm;
        temp.GNum1 = item.GNum1;
        temp.GNum2 = item.GNum2;
        temp.GNum3 = item.GNum3;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin3/UpdateSubject',
            data: temp
        }).then(function successCallback(response) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            keyin3.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }, function errorCallback(response) {
            alert("儲存失敗，請聯絡資訊室！");
        });
    }

    keyin3.save2 = function (item) {
        var temp = {};
        temp.SubjectID = item.SubjectID2;
        temp.ReportDate = keyin3.select.yyy + keyin3.select.mm;
        temp.GNum1 = item.GNum21;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin3/UpdateSubject',
            data: temp
        }).then(function successCallback(response) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            keyin3.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }, function errorCallback(response) {
            alert("儲存失敗，請聯絡資訊室！");
        });
    }



    keyin3.saveCheck = function () {
        if (keyin3.updateNum == 0) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            keyin3.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }
    }



    keyin3.add = function () {
        keyin3.insertSubmit.Type = keyin3.type;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin3/AddNewReport',
            data: keyin3.insertSubmit
        }).then(function successCallback(response) {
            if (response.data == "ok") {
                $('.kai-model-bg').css("display", "none");
                keyin3.model = "";
                getReportList();
            } else {
                alert(response.data);
            }
        }, function errorCallback(response) {
        });
    }

    keyin3.delete = function (item) {
        $('.kai-model-bg').css("display", "none");
        keyin3.model = "";
        if (confirm("是否確定刪除「" + item.Name + "」？")) {
            $http({
                method: 'POST',
                url: 'WebAPI/keyin3/DeleteSubject',
                data: item
            }).then(function successCallback(response) {
                getSubject();
            }, function errorCallback(response) {
            });
        }
    }


    keyin3.detailShow = function () {
        $("#addRepport").css("top", window.document.body.scrollTop + 150);
        $('.kai-model-bg').css("display", "");
        keyin3.model = "kai-in";
        keyin3.insertSubmit = {
            ReportDate: "",
            Type: ""
        };
    }
    keyin3.detailHide = function () {
        $('.kai-model-bg').css("display", "none");
        keyin3.model2 = "";
        keyin3.model = "";
    }
    keyin3.model2 = "";


    keyin3.configDetailShow = function () {
        $("#configShow").css("top", window.document.body.scrollTop + 150);
        $('.kai-model-bg').css("display", "");
        keyin3.model2 = "kai-in";
        getSubjectAll();
    }
    function getSubjectAll() {
        $http({
            method: 'POST',
            url: 'WebAPI/keyin3/getSubjectAll',
            data: keyin3.select
        }).then(function successCallback(response) {
            keyin3.subjectAlldata = response.data;
            keyin3.subjectbtnFlag = false;
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