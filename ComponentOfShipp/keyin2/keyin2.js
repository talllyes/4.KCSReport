app.controller('keyin2', function ($rootScope, $scope, $http, $routeParams) {
    $scope.shipp.selectMenu = "keyin";
    $scope.shipp.selectMenuBase = "keyin";
    var keyin2 = this;
    keyin2.data = [];
    keyin2.addSelectSubject = [];
    keyin2.insertSubmit = {};
    keyin2.updateNum = 0;
    keyin2.saveMessage = "";
    keyin2.typeText = "";
    keyin2.subjectAlldata = [];
    keyin2.reportList = [];
    keyin2.mmList = [];
    keyin2.select = {
        "yyy": "",
        "mm": "",
        "Type": ""
    };
    keyin2.edit = false;
    keyin2.subjectbtnFlag = false;

    if ($routeParams.type == 'Subject2') {
        keyin2.typeText = '損益表';
        keyin2.type = '2';
        keyin2.select.Type = "2";
    }

    function getReportList() {
        $http({
            method: 'GET',
            url: 'WebAPI/keyin2/ReportList'
        }).then(function successCallback(response) {
            keyin2.reportList = response.data;
            var yyy = "0";
            angular.forEach(keyin2.reportList.yyy, function (value, key) {
                if (value > yyy) {
                    yyy = value;
                }
            });
            var mm = "0";
            angular.forEach(keyin2.reportList.mm, function (value, key) {
                if (value.yyy == yyy) {
                    if (value.mm > mm) {
                        mm = value.mm;
                    }
                }
            });
            keyin2.select.yyy = yyy;
            keyin2.select.mm = mm;
            keyin2.yyychange();
        }, function errorCallback(response) {
            alert("取得科目失敗，請聯絡資訊室！");
        });
    }
    getReportList();

    $scope.$watch('keyin2.select.mm', function () {
        if (keyin2.select.yyy != "") {
            getSubject();
        }
    });

    keyin2.getMMList = function () {
        var out = [];
        angular.forEach(keyin2.reportList.mm, function (value, key) {
            if (value.yyy == keyin2.select.yyy) {
                out.push(value.mm);
            }
        });
        return out;
    }

    keyin2.yyychange = function () {
        keyin2.mmList = keyin2.getMMList();
        keyin2.select.mm = keyin2.mmList[keyin2.mmList.length - 1];
    }

    var first = true;
    function getSubject() {
        var temp = keyin2.select.yyy + keyin2.select.mm;
        if (!first) {
            $(".loaderIN").css("display", "");
            $(".loaderOK").css("display", "none");
            $(".loaderIN").height($(".loaderOK").height());
        }
        $http({
            method: 'POST',
            url: 'WebAPI/keyin2/' + $routeParams.type,
            data: temp
        }).then(function successCallback(response) {
            keyin2.data = response.data;
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
        
    keyin2.getNum = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum1;
                }
            });
        } else {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum1;
                }
            });
            item.GNum1 = nn;
        }
        return nn;
    }
    keyin2.getNum2 = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum2;
                }
            });
        } else {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum2;
                }
            });
            item.GNum2 = nn;
        }
        return nn;
    }
    keyin2.getNum3 = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum3;
                }
            });
        } else {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.GNum3;
                }
            });
            item.GNum3 = nn;
        }
        return nn;
    }  

    keyin2.getAllNum2 = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.AllGNum2;
                }
            });
        } else {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.AllGNum2;
                }
            });
            item.AllGNum2 = nn;
        }
        return nn;
    }
    keyin2.getAllNum3 = function (item, type) {
        var nn = 0;
        if (type == "1") {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.AllGNum3;
                }
            });
        } else {
            angular.forEach(keyin2.data, function (value, key) {
                if (value.Layer == item.SubjectID) {
                    nn = nn + value.AllGNum3;
                }
            });
            item.AllGNum3 = nn;
        }
        return nn;
    }





    keyin2.getNumAll = function () {
        var nn = 0;
        angular.forEach(keyin2.data, function (value, key) {
            if (!value.HaveCh) {
                nn = nn + value.GNum1;
            }
        });
        return nn;
    }

    keyin2.getNumAll2 = function () {
        var nn = 0;
        angular.forEach(keyin2.data, function (value, key) {
            if (!value.HaveCh2) {
                nn = nn + value.GNum21;
            }
        });
        return nn;
    }



    keyin2.addSubject = function (item) {
        var temp = {};
        temp.ReportDate = keyin2.select.yyy + keyin2.select.mm;
        temp.SubjectID = item.SubjectID;
        temp.Type = keyin2.select.Type;
        keyin2.subjectbtnFlag = true;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin2/AddSubject',
            data: temp
        }).then(function successCallback(response) {
            getSubjectAll();
            getSubject();
        }, function errorCallback(response) {
            alert("刪除失敗，請聯絡資訊室！");
            keyin2.subjectbtnFlag = false;
        });
    }
    keyin2.deleteSubject = function (item) {
        if (confirm("是否刪除「" + item.Name + "」，請注意刪除後已鍵入數值會清空。")) {
            keyin2.subjectbtnFlag = true;
            var temp = {};
            temp.ReportDate = keyin2.select.yyy + keyin2.select.mm;
            temp.SubjectID = item.SubjectID;
            temp.Type = keyin2.select.Type;
            $http({
                method: 'POST',
                url: 'WebAPI/keyin2/DeleteSubject',
                data: temp
            }).then(function successCallback(response) {
                getSubjectAll();
                getSubject();
            }, function errorCallback(response) {
                alert("刪除失敗，請聯絡資訊室！");
                keyin2.subjectbtnFlag = false;
            });
        }
    }

    keyin2.fakeSave = function (item) {
        keyin2.edit = false;
        var today = new Date();
        var hour = today.getHours();
        var minute = today.getMinutes();
        var second = today.getSeconds();
        keyin2.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
        $("#saveSMessage").css("opacity", "1");
        $("#saveSMessage").stop();
        $("#saveSMessage").animate({ opacity: "0" }, 2500);
    }


    keyin2.save = function (item) {
        var temp = {};
        temp.SubjectID = item.SubjectID;
        temp.ReportDate = keyin2.select.yyy + keyin2.select.mm;
        temp.GNum1 = item.GNum1;
        temp.GNum2 = item.GNum2;
        temp.GNum3 = item.GNum3;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin2/UpdateSubject',
            data: temp
        }).then(function successCallback(response) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            keyin2.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }, function errorCallback(response) {
            alert("儲存失敗，請聯絡資訊室！");
        });
    }

    keyin2.save2 = function (item) {
        var temp = {};
        temp.SubjectID = item.SubjectID2;
        temp.ReportDate = keyin2.select.yyy + keyin2.select.mm;
        temp.GNum1 = item.GNum21;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin2/UpdateSubject',
            data: temp
        }).then(function successCallback(response) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            keyin2.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }, function errorCallback(response) {
            alert("儲存失敗，請聯絡資訊室！");
        });
    }



    keyin2.saveCheck = function () {
        if (keyin2.updateNum == 0) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            keyin2.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }
    }



    keyin2.add = function () {
        keyin2.insertSubmit.Type = keyin2.type;
        $http({
            method: 'POST',
            url: 'WebAPI/keyin2/AddNewReport',
            data: keyin2.insertSubmit
        }).then(function successCallback(response) {
            if (response.data == "ok") {
                $('.kai-model-bg').css("display", "none");
                keyin2.model = "";
                getReportList();
            } else {
                alert(response.data);
            }
        }, function errorCallback(response) {
        });
    }

    keyin2.delete = function (item) {
        $('.kai-model-bg').css("display", "none");
        keyin2.model = "";
        if (confirm("是否確定刪除「" + item.Name + "」？")) {
            $http({
                method: 'POST',
                url: 'WebAPI/keyin2/DeleteSubject',
                data: item
            }).then(function successCallback(response) {
                getSubject();
            }, function errorCallback(response) {
            });
        }
    }


    keyin2.detailShow = function () {
        $("#addRepport").css("top", window.document.body.scrollTop + 150);
        $('.kai-model-bg').css("display", "");
        keyin2.model = "kai-in";
        keyin2.insertSubmit = {
            ReportDate: "",
            Type: ""
        };
    }
    keyin2.detailHide = function () {
        $('.kai-model-bg').css("display", "none");
        keyin2.model2 = "";
        keyin2.model = "";
    }
    keyin2.model2 = "";


    keyin2.configDetailShow = function () {
        $("#configShow").css("top", window.document.body.scrollTop + 150);
        $('.kai-model-bg').css("display", "");
        keyin2.model2 = "kai-in";
        getSubjectAll();
    }
    function getSubjectAll() {
        $http({
            method: 'POST',
            url: 'WebAPI/keyin2/getSubjectAll',
            data: keyin2.select
        }).then(function successCallback(response) {
            keyin2.subjectAlldata = response.data;
            keyin2.subjectbtnFlag = false;
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