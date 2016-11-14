<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="Company_login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="icon" href="./image/favicon.ico" type="image/x-icon" />
    <link rel="bookmark" href="./image/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="./images/favicon.ico" type="image/x-icon" />
    <title>輪船財會月報系統</title>
    <link href="Lib/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="Lib/css/login.css" rel="stylesheet" />
    <script src="Lib/other/jquery.min.js"></script>
    <script src="Lib/bootstrap-3.3.7-dist/js/bootstrap.js"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12">
                    <div id="title">輪船財會月報系統</div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="loginBorder">
                        <asp:TextBox ID="userId" runat="server" CssClass="form-control" placeholder="帳號"></asp:TextBox>
                        <asp:TextBox ID="userPw" runat="server" CssClass="form-control" placeholder="密碼" TextMode="Password"></asp:TextBox>
                        <asp:Button ID="ButtonLogin" runat="server" Text="登入" CssClass="btn btn-info form-control" OnClick="ButtonLogin_Click" />
                    </div>
                    <div class="text-center">
                        <h3>
                            <asp:Label ID="message" runat="server" Text="帳號或密碼錯誤" CssClass="label label-warning" Visible="False"></asp:Label></h3>
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
            <div id="footer">
                <h4>高雄市政府交通局 <span class="glyphicon glyphicon-copyright-mark" aria-hidden="true"></span>copyright 2016</h4>
            </div>
        </div>
    </form>
</body>
</html>
