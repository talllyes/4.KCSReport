using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

/// <summary>
/// IdentityAuthority 的摘要描述
/// </summary>
/// 
namespace IdentityAuthority
{
    public class IdentityCheck : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {
        HttpContext allcontext;
        string url;
        public void ProcessRequest(HttpContext context)
        {
            //取得網址
            url = System.IO.Path.GetFileName(context.Request.PhysicalPath);
            allcontext = context;


            if (!url.Equals("login.aspx"))
            {
                if (context.Session["UserID"] == null)
                {
                    context.Response.Redirect("~/login.aspx");
                }
            }            
        }
        public void checkSessionUrl(string type, string index)
        {
            if (url.IndexOf(index) != -1)
            {
                //if (allcontext.Session["councilorLogin"] == null)
                //{
                //    //沒有session轉址到login
                //    if (type.Equals("1"))
                //    {
                //        allcontext.Response.Redirect("~/login");
                //    }
                //    //沒有session轉址到找不到頁面
                //    else if (type.Equals("2"))
                //    {
                //        allcontext.Response.Redirect("~/other/noFound");
                //    }
                //}
            }
        }

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }
    }
}