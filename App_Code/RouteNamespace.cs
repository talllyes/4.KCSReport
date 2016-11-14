using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Compilation;
using System.Web.Hosting;
using System.Web.Routing;

/// <summary>
/// RouteNamespace 的摘要描述
/// </summary>
/// 
namespace RouteNamespace
{
    //限制無法直接讀取網頁
    public class NotLoad : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            //用html讀都放送~/notFound.html內容
            var handler = BuildManager.CreateInstanceFromVirtualPath("~/notFound.html", typeof(IHttpHandler)) as IHttpHandler;
            context.Server.Transfer(handler, false);
        }
        public bool IsReusable
        {
            get
            {
                return true;
            }
        }
    }

    //根目錄Html的自動Route
    public class RootHtmlRoute : IRouteHandler
    {
        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            var routeData = requestContext.RouteData;
            //取出參數
            string htmlUrl = Convert.ToString(routeData.Values["htmlUrl"]);
            //檢查看看有無該Model對應的HTML?
            string htmlName = htmlUrl + ".html";
            string flag = "";
            if (File.Exists(HostingEnvironment.MapPath("~/ComponentOfShipp/" + htmlName)))
            {
                flag = "ComponentOfShipp";
            }
            else if (File.Exists(HostingEnvironment.MapPath("~/ComponentOfManage/" + htmlName)))
            {
                flag = "ComponentOfManage";
            }
            if (flag.Equals(""))
            {
                //放送~/notFound.html內容
                return BuildManager.CreateInstanceFromVirtualPath("~/notFound.html", typeof(IHttpHandler)) as IHttpHandler;
            }
            else
            {
                //導向指定的HTML
                return BuildManager.CreateInstanceFromVirtualPath("~/" + flag + "/" + htmlName, typeof(IHttpHandler)) as IHttpHandler;
            }
        }
    }

    //ComponentOfShipp/目錄Html的自動Route
    public class ComponentOfShippHtmlRoute : IRouteHandler
    {
        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            var routeData = requestContext.RouteData;
            //取出參數
            string htmlUrl = Convert.ToString(routeData.Values["htmlUrl"]);
            //檢查看看有無該Model對應的HTML?
            string htmlName = htmlUrl + ".html";
            if (!File.Exists(HostingEnvironment.MapPath("~/ComponentOfShipp/" + htmlUrl + "/" + htmlName)))
            {
                //放送~/notFound.html內容
                return BuildManager.CreateInstanceFromVirtualPath("~/notFound.html", typeof(IHttpHandler)) as IHttpHandler;
            }
            //導向指定的HTML
            return BuildManager.CreateInstanceFromVirtualPath("~/ComponentOfShipp/" + htmlUrl + "/" + htmlName, typeof(IHttpHandler)) as IHttpHandler;
        }
    }


    //ComponentOfManage/目錄Html的自動Route
    public class ComponentOfManageHtmlRoute : IRouteHandler
    {
        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            var routeData = requestContext.RouteData;
            //取出參數
            string htmlUrl = Convert.ToString(routeData.Values["htmlUrl"]);
            //檢查看看有無該Model對應的HTML?
            string htmlName = htmlUrl + ".html";
            if (!File.Exists(HostingEnvironment.MapPath("~/ComponentOfManage/" + htmlUrl + "/" + htmlName)))
            {
                //放送~/notFound.html內容
                return BuildManager.CreateInstanceFromVirtualPath("~/notFound.html", typeof(IHttpHandler)) as IHttpHandler;
            }
            //導向指定的HTML
            return BuildManager.CreateInstanceFromVirtualPath("~/ComponentOfManage/" + htmlUrl + "/" + htmlName, typeof(IHttpHandler)) as IHttpHandler;
        }
    }

    //Api目錄的ashx自動Route
    public class ApiRoute : IRouteHandler
    {
        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            var routeData = requestContext.RouteData;
            //取出參數
            string model = Convert.ToString(routeData.Values["model"]);
            string parameter = Convert.ToString(routeData.Values["parameter"]);

            HttpContext.Current.Items.Add("model", model);
            if (!string.IsNullOrEmpty(parameter))
            {
                HttpContext.Current.Items.Add("parameter", parameter);
            }
            else
            {
                HttpContext.Current.Items.Add("parameter", "");
            }

            //檢查看看有無該Model對應的ASHX?
            string ashxName = model + ".ashx";

            //找不到對應的ASHX
            if (!File.Exists(HostingEnvironment.MapPath("~/WebAPI/" + ashxName)))
            {
                //放送~/Views/other/noFound.html內容
                return BuildManager.CreateInstanceFromVirtualPath("~/notFound.html", typeof(IHttpHandler)) as IHttpHandler;
            }
            //導向指定的ASHX
            return BuildManager.CreateInstanceFromVirtualPath("~/WebAPI/" + ashxName, typeof(IHttpHandler)) as IHttpHandler;
        }
    }


    //讀取shippJs
    public class LoadShippJs : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            string filename = System.IO.Path.GetFileName(context.Request.PhysicalPath);
            string one = filename.Split('.')[0];
            if (filename.Equals("shipp.js"))
            {
                context.Response.WriteFile(context.Request.PhysicalApplicationPath + @"ComponentOfShipp\shipp.js");
            }
            else
            {
                if (File.Exists((context.Request.PhysicalApplicationPath + @"ComponentOfShipp\" + one + @"\" + filename)))
                {
                    context.Response.WriteFile(context.Request.PhysicalApplicationPath + @"ComponentOfShipp\" + one + @"\" + filename);
                }
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
    //讀取Managejs
    public class LoadManageJs : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            string filename = System.IO.Path.GetFileName(context.Request.PhysicalPath);
            string one = filename.Split('.')[0];
            if (filename.Equals("manage.js"))
            {
                context.Response.WriteFile(context.Request.PhysicalApplicationPath + @"ComponentOfManage\manage.js");
            }
            else
            {
                if (File.Exists((context.Request.PhysicalApplicationPath + @"ComponentOfManage\" + one + @"\" + filename)))
                {
                    context.Response.WriteFile(context.Request.PhysicalApplicationPath + @"ComponentOfManage\" + one + @"\" + filename);
                }
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