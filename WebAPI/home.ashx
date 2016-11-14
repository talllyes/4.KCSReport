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
    public List<string> number = new List<string>();
    DataClassesDataContext DB = new DataClassesDataContext();
    public void ProcessRequest(HttpContext context)
    {
        string type = context.Items["parameter"].ToString();
        if (type.Equals("home"))
        {
            var result = from a in DB.News
                         orderby a.InsertDate descending
                         select a;
            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
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