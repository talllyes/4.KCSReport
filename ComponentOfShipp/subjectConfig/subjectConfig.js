app.controller('subjectConfig', function ($rootScope, $scope, $http, $routeParams) {
    $scope.shipp.selectMenu = "subjectConfig";
    $scope.shipp.selectMenuBase = "subjectConfig";
    var subjectConfig = this;

    subjectConfig.data = [];
    subjectConfig.addSelectSubject = [];
    subjectConfig.insertSubmit = {};
    subjectConfig.updateNum = 0;
    subjectConfig.saveMessage = "";
    subjectConfig.typeText = "";
    subjectConfig.btnFlag = false;


    if ($routeParams.type == 'Subject1') {
        subjectConfig.typeText = '資產負債表';
    } else if ($routeParams.type == 'Subject2') {
        subjectConfig.typeText = '損益表';

    } else if ($routeParams.type == 'Subject3') {
        subjectConfig.typeText = '收入明細表';

    } else if ($routeParams.type == 'Subject4') {
        subjectConfig.typeText = '航行費用明細表';

    } else if ($routeParams.type == 'Subject5') {
        subjectConfig.typeText = '管理費用明細表';

    } else if ($routeParams.type == 'Subject6') {
        subjectConfig.typeText = '利息費用明細表';

    } else if ($routeParams.type == 'Subject7') {
        subjectConfig.typeText = '雜項費用明細表';
    }







    function getSubject() {
        $http({
            method: 'GET',
            url: 'WebAPI/SubjectConfig/' + $routeParams.type
        }).then(function successCallback(response) {
            $(".loadering").css("display", "none");
            $(".loaderOK").css("display", "");
            $(".loaderOK").css("opacity", "0");
            $(".loaderOK").animate({ opacity: "1" }, 500);

            subjectConfig.data = response.data;
            subjectConfig.btnFlag = false;
        }, function errorCallback(response) {
            alert("取得科目失敗，請聯絡資訊室！");
        });
    }
    getSubject();


    subjectConfig.save = function (item) {
        $http({
            method: 'POST',
            url: 'WebAPI/SubjectConfig/UpdateSubject',
            data: item
        }).then(function successCallback(response) {
            subjectConfig.updateNum = subjectConfig.updateNum - 1;
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            subjectConfig.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }, function errorCallback(response) {
            alert("儲存失敗，請聯絡資訊室！");
        });
    }

    subjectConfig.saveCheck = function () {
        if (subjectConfig.updateNum == 0) {
            var today = new Date();
            var hour = today.getHours();
            var minute = today.getMinutes();
            var second = today.getSeconds();
            subjectConfig.saveMessage = "儲存成功(" + hour + ":" + minute + ":" + second + ")";
            $("#saveSMessage").css("opacity", "1");
            $("#saveSMessage").stop();
            $("#saveSMessage").animate({ opacity: "0" }, 2500);
        }
    }



    subjectConfig.add = function () {
        $('.kai-model-bg').css("display", "none");
        subjectConfig.model = "";
        subjectConfig.insertSubmit.Layer = subjectConfig.addSelectSubject.SubjectID;
        subjectConfig.insertSubmit.Type = subjectConfig.addSelectSubject.Type;
        $http({
            method: 'POST',
            url: 'WebAPI/SubjectConfig/AddSubject',
            data: subjectConfig.insertSubmit
        }).then(function successCallback(response) {
            getSubject();
        }, function errorCallback(response) {
        });
    }

    subjectConfig.delete = function (item) {
        $('.kai-model-bg').css("display", "none");
        subjectConfig.model = "";
        if (confirm("是否確定刪除「" + item.Name + "」？")) {
            $http({
                method: 'POST',
                url: 'WebAPI/SubjectConfig/DeleteSubject',
                data: item
            }).then(function successCallback(response) {
                if (response.data == "ok") {
                    getSubject();
                } else {
                    alert(response.data);
                }
            }, function errorCallback(response) {
            });
        }
    }
    subjectConfig.up = function (item) {
        subjectConfig.btnFlag = true;
        $('.kai-model-bg').css("display", "none");
        subjectConfig.model = "";
        $http({
            method: 'POST',
            url: 'WebAPI/SubjectConfig/UpSubject',
            data: item
        }).then(function successCallback(response) {
            if (response.data == "ok") {
                getSubject();
            } else {
                alert(response.data);
                subjectConfig.btnFlag = false;
            }
        }, function errorCallback(response) {
        });
    }
    subjectConfig.down = function (item) {
        subjectConfig.btnFlag = true;
        $('.kai-model-bg').css("display", "none");
        subjectConfig.model = "";
        $http({
            method: 'POST',
            url: 'WebAPI/SubjectConfig/DownSubject',
            data: item
        }).then(function successCallback(response) {
            if (response.data == "ok") {
                getSubject();
            } else {
                alert(response.data);
                subjectConfig.btnFlag = false;
            }
        }, function errorCallback(response) {
        });
    }
    subjectConfig.detailShow = function (item) {
        $("#kai-model").css("top", window.document.body.scrollTop + 150);
        $('.kai-model-bg').css("display", "");
        subjectConfig.model = "kai-in";
        subjectConfig.addSelectSubject = item;
        subjectConfig.insertSubmit = {};
    }
    subjectConfig.detailHide = function () {
        $('.kai-model-bg').css("display", "none");
        subjectConfig.model = "";
    }

    $("#kai-model").css("left", ($("#nowbody").width() / 2) - 265);
});
$(window).resize(function () {
    $("#kai-model").css("left", ($("#nowbody").width() / 2) - 265);
});

$(window).scroll(function () {
    $("#kai-model").css("top", window.document.body.scrollTop + 150);
});