using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Company_login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session.Clear();
        }
    }
    protected void ButtonLogin_Click(object sender, EventArgs e)
    {
        message.Visible = false;
        if (userId.Text.Length == 0 || userPw.Text.Length == 0)
        {
            message.Visible = true;
            return;
        }   
        if (userId.Text == "kcs2016" && userPw.Text== "kcs2016&tbkc2016")
        {
            Session["UserID"] = "kcs2016";
            Response.Redirect("./shipp"); 
        }
        else
        {
            message.Visible = true;
        }
    }
}