//Br轉\n
app.filter('cleanBr', function () {
    return function (str) {
        if (str != "" && str != null) {
            str = str.replace(/\<br \/>/g, "\n");
            return str;
        } else {
            return str;
        }
    };
});
//\n轉Br
app.filter('toSpace', function () {
    return function (str) {
        if (str != "" && str != null) {
            str = str.replace(/\n/g, "<br />");
            return str;
        } else {
            return str;
        }
    };
});

app.filter('addggs', function () {
    return function (str) {
        if (isNaN(str)) {
            return NaN;
        }
        var glue = (typeof glue == 'string') ? glue : ',';
        var digits = str.toString().split('.'); // 先分左邊跟小數點

        var integerDigits = digits[0].split(""); // 獎整數的部分切割成陣列
        var threeDigits = []; // 用來存放3個位數的陣列

        // 當數字足夠，從後面取出三個位數，轉成字串塞回 threeDigits
        while (integerDigits.length > 3) {
            threeDigits.unshift(integerDigits.splice(integerDigits.length - 3, 3).join(""));
        }

        threeDigits.unshift(integerDigits.join(""));
        digits[0] = threeDigits.join(glue);

        return digits.join(".");
    };
});

app.filter('zeroBig', function ($sce) {
    return function (num) {
        if (!num) {
            return "";
        }
        var str = num;
        if (num.toString().indexOf('-') != -1) {
            str = '<div style="color:red">' + num.substr(1) + '</div>';
        }
        return $sce.trustAsHtml(str);
    };
});

app.filter('changeInt', function () {
    return function (str) {
        if (isNaN(str)) {
            return NaN;
        }
        if (str < 0) {
            return -(str);
        } else {
            return str;
        }       
    };
});