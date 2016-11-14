<%@ WebHandler Language="C#" Class="keyin" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Drawing;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Linq;
using System.Threading.Tasks;

public class keyin : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        if (context.Session["UserID"] == null)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("no");
        }
        else
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("ok");
        }
    }


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}