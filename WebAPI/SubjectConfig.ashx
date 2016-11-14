<%@ WebHandler Language="C#" Class="ValidateNumber" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Drawing;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Linq;
using System.Threading.Tasks;

public class ValidateNumber : IHttpHandler, IRequiresSessionState
{
    public List<string> number = new List<string>();
    DataClassesDataContext DB = new DataClassesDataContext();
    public void ProcessRequest(HttpContext context)
    {
        string type = context.Items["parameter"].ToString();


        if (type.Equals("Subject1"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "1" && a.Layer == 0
                       orderby a.SubOrder
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();
            result = addSubject(temp);

            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject2"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "2" && a.Layer == 0
                       orderby a.SubOrder
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();
            result = addSubject(temp);

            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject3"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "3" && a.Layer == 0
                       orderby a.SubOrder
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();
            result = addSubject(temp);

            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject4"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "4" && a.Layer == 0
                       orderby a.SubOrder
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();
            result = addSubject(temp);

            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject5"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "5" && a.Layer == 0
                       orderby a.SubOrder
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();
            result = addSubject(temp);

            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject6"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "6" && a.Layer == 0
                       orderby a.SubOrder
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();
            result = addSubject(temp);

            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject7"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "7" && a.Layer == 0
                       orderby a.SubOrder
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();
            result = addSubject(temp);

            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("AddSubject"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);

            int ll = json.Layer;
            int find = (int)(from a in DB.Subject
                             select a.SubOrder).Max();


            Subject insert = new Subject()
            {
                Layer = json.Layer,
                Code = json.Code,
                Name = json.Name,
                Num = json.Num,
                Type = json.Type,
                status = "1",
                SubOrder = find + 1
            };
            DB.Subject.InsertOnSubmit(insert);
            DB.SubmitChanges();
        }
        else if (type.Equals("DeleteSubject"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            int SubjectID = json.SubjectID;

            var check = (from a in DB.ReportKeyIn
                         where a.SubjectID == SubjectID
                         select a).FirstOrDefault();

            if (check == null)
            {
                var delete = (from a in DB.Subject
                              where a.SubjectID == SubjectID
                              select a).FirstOrDefault();
                DB.Subject.DeleteOnSubmit(delete);
                DB.SubmitChanges();
                context.Response.ContentType = "text/plain";
                context.Response.Write("ok");
            }
            else
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("項目在使用中無法刪除，如要刪除請先移除月報中的該項目。");
            }
        }
        else if (type.Equals("UpSubject"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            int SubjectID = json.SubjectID;
            string type1 = json.Type;
            int SubOrder = json.SubOrder;
            int Layer = (from a in DB.Subject
                         where a.SubjectID == SubjectID && a.Type == type1
                         select a.Layer).FirstOrDefault();
            var find = from a in DB.Subject
                       where a.Layer == Layer && a.Type == type1 && a.SubOrder < SubOrder
                       select a;

            if (find.Count() != 0)
            {
                int orders = 0;
                int sub = 0;
                foreach (var a in find)
                {
                    if (a.SubOrder > orders)
                    {
                        orders = (int)a.SubOrder;
                        sub = a.SubjectID;
                    }
                }
                var update2 = (from a in DB.Subject
                               where a.SubjectID == SubjectID
                               select a).FirstOrDefault();
                update2.SubOrder = orders;


                var update1 = (from a in DB.Subject
                               where a.SubjectID == sub
                               select a).FirstOrDefault();
                update1.SubOrder = SubOrder;
                DB.SubmitChanges();
                context.Response.ContentType = "text/plain";
                context.Response.Write("ok");
            }
            else
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("已經最上面了。");
            }

        }
        else if (type.Equals("DownSubject"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            int SubjectID = json.SubjectID;
            string type1 = json.Type;
            int SubOrder = json.SubOrder;
            int Layer = (from a in DB.Subject
                         where a.SubjectID == SubjectID && a.Type == type1
                         select a.Layer).FirstOrDefault();

            var find = from a in DB.Subject
                       where a.Layer == Layer && a.Type == type1 && a.SubOrder > SubOrder
                       select a;
            if (find.Count() != 0)
            {
                int orders = 10000;
                int sub = 0;
                foreach (var a in find)
                {
                    if (a.SubOrder < orders)
                    {
                        orders = (int)a.SubOrder;
                        sub = a.SubjectID;
                    }
                }
                var update2 = (from a in DB.Subject
                               where a.SubjectID == SubjectID
                               select a).FirstOrDefault();
                update2.SubOrder = orders;


                var update1 = (from a in DB.Subject
                               where a.SubjectID == sub
                               select a).FirstOrDefault();
                update1.SubOrder = SubOrder;
                DB.SubmitChanges();
                context.Response.ContentType = "text/plain";
                context.Response.Write("ok");
            }
            else
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("已經最下面了。");
            }

        }
        else if (type.Equals("UpdateSubject"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            int SubjectID = json.SubjectID;
            var update = (from a in DB.Subject
                          where a.SubjectID == SubjectID
                          select a).FirstOrDefault();
            update.Name = json.Name;
            update.Code = json.Code;
            update.Num = json.Num;
            DB.SubmitChanges();
        }
    }

    public List<SubjectRoot> addSubject(dynamic temp)
    {
        List<SubjectRoot> result = new List<SubjectRoot>();
        int subNum = 0;
        foreach (var inTemp in temp)
        {
            SubjectRoot sTemp = new SubjectRoot();
            sTemp.SubjectID = inTemp.SubjectID;
            sTemp.Num = inTemp.Num;
            sTemp.Code = inTemp.Code;
            sTemp.Name = inTemp.Name;
            sTemp.Layer = inTemp.Layer;
            sTemp.Type = inTemp.Type;
            sTemp.SubOrder = inTemp.SubOrder;
            result.Add(sTemp);
            int SubjectID = inTemp.SubjectID;
            var temp2 = from a in DB.Subject
                        where a.Layer == SubjectID
                        orderby a.SubOrder
                        select a;
            if (temp2.Count() > 0)
            {
                result[subNum].Child = addSubject(temp2);
            }
            subNum = subNum + 1;
        }
        return result;
    }


    public class SubjectRoot
    {
        public int SubjectID;
        public string Num;
        public string Code;
        public string Name;
        public int Layer;
        public string Type;
        public int SubOrder;
        public List<SubjectRoot> Child;
    }



    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}