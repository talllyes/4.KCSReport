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
        if (type.Equals("Subject3"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            string ReportDate = json.ReportDate;
            int rootSubject = json.rootSubject;
            string yyy = ReportDate.Substring(0, 3);
            string mm = ReportDate.Substring(3, 2);
            var temp = from a in DB.Subject
                       join b in DB.ReportKeyIn
                       on a.SubjectID equals b.SubjectID into ps
                       from b in ps.DefaultIfEmpty()
                       where a.SubjectID == rootSubject && a.status == "1"
                       && b.ReportDate == ReportDate
                       orderby a.SubOrder
                       select new
                       {
                           a.Code,
                           a.Layer,
                           a.Name,
                           a.Num,
                           a.status,
                           a.SubjectID,
                           a.Type,
                           b.Num1,
                           b.Num2,
                           b.Num3
                       };
            List<SubjectRoot> resultTemp1 = new List<SubjectRoot>();
            addSubject(temp, resultTemp1, 0, ReportDate);
            var temp2 = from a in DB.Subject
                        join b in (
                        from c in DB.ReportKeyIn
                        where c.ReportDate.Substring(0, 3) == yyy
                            && c.ReportDate.Substring(3, 2).CompareTo(mm) < 0
                        group c by c.SubjectID into s
                        select new
                        {
                            SubjectID = s.Key,
                            Num1 = s.Sum(p => p.Num1),
                            Num2 = s.Sum(p => p.Num2),
                            Num3 = s.Sum(p => p.Num3)
                        }
                        )
                        on a.SubjectID equals b.SubjectID into ps
                        from b in ps.DefaultIfEmpty()
                        where a.SubjectID == rootSubject && a.status == "1"
                        orderby a.SubOrder
                        select new
                        {
                            a.Code,
                            a.Layer,
                            a.Name,
                            a.Num,
                            a.status,
                            a.SubjectID,
                            a.Type,
                            b.Num1,
                            b.Num2,
                            b.Num3
                        };
            List<SubjectRoot> resultTemp2 = new List<SubjectRoot>();
            addSubject2(temp2, resultTemp2, 0, ReportDate);


            foreach (var tt in resultTemp1)
            {
                foreach (var tt2 in resultTemp2)
                {
                    if (tt.SubjectID == tt2.SubjectID)
                    {
                        tt.AllGNum1 = tt2.GNum1;
                        tt.AllGNum2 = tt2.GNum2;
                        tt.AllGNum3 = tt2.GNum3;
                    }
                }
            }
            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(resultTemp1));
        }
        else if (type.Equals("ReportList"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            string Type = json.Type;

            var temp = (from a in DB.ReportKeyIn
                        where a.Type == Type
                        select a.ReportDate.Substring(0, 3)).Distinct().OrderBy(p => p);
            Dictionary<string, dynamic> result = new Dictionary<string, dynamic>();
            List<string> tlist = new List<string>();
            foreach (var tt in temp)
            {
                tlist.Add(tt);
            }

            result.Add("yyy", tlist);

            var temp2 = (from a in DB.ReportKeyIn
                         where a.Type == Type
                         select a.ReportDate).Distinct().OrderBy(p => p);
            List<mmTemp> mlist = new List<mmTemp>();
            foreach (var tt in temp2)
            {
                mmTemp te = new mmTemp();
                te.yyy = tt.Substring(0, 3);
                te.mm = tt.Substring(3, 2);
                mlist.Add(te);
            }

            result.Add("mm", mlist);

            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject3"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "3" && a.Layer == 0
                       orderby a.Num
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();


            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject4"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "4" && a.Layer == 0
                       orderby a.Num
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();


            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject5"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "5" && a.Layer == 0
                       orderby a.Num
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();


            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject6"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "6" && a.Layer == 0
                       orderby a.Num
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();


            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("Subject7"))
        {

            var temp = from a in DB.Subject
                       where a.Type == "7" && a.Layer == 0
                       orderby a.Num
                       select a;
            List<SubjectRoot> result = new List<SubjectRoot>();


            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("AddNewReport"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            string ReportDate = json.ReportDate;
            string Type = json.Type;

            if (ReportDate.Length == 5)
            {

                try
                {
                    int yyy = Int32.Parse(ReportDate.Substring(0, 3));
                    int mm = Int32.Parse(ReportDate.Substring(3, 2));
                    if (yyy > 0 && mm > 0 && mm < 13)
                    {
                        var check = (from a in DB.ReportKeyIn
                                     where a.ReportDate == ReportDate && a.Type == Type
                                     select a).FirstOrDefault();

                        if (check == null)
                        {
                            var insertBefore = from a in DB.Subject
                                               where a.Type == Type && a.status == "1"
                                               select a;

                            foreach (var ii in insertBefore)
                            {
                                ReportKeyIn insert = new ReportKeyIn()
                                {
                                    ReportDate = ReportDate,
                                    Num1 = 0,
                                    Num2 = 0,
                                    Num3 = 0,
                                    SubjectID = ii.SubjectID,
                                    Type = ii.Type
                                };
                                DB.ReportKeyIn.InsertOnSubmit(insert);
                            }
                            string reportType = "";
                            if (Type.Equals("3"))
                            {
                                reportType = "收入明細表";
                            }
                            else if (Type.Equals("4"))
                            {
                                reportType = "航行費用明細表";
                            }
                            else if (Type.Equals("5"))
                            {
                                reportType = "管理費用明細表";
                            }
                            else if (Type.Equals("6"))
                            {
                                reportType = "利息費用明細表";
                            }
                            else if (Type.Equals("7"))
                            {
                                reportType = "雜項費用明細表";
                            }
                            News insert2 = new News()
                            {
                                NewsType = "報表新增",
                                NewsContent = yyy + "年" + mm + "月-" + reportType,
                                InsertDate = DateTime.Now
                            };
                            DB.News.InsertOnSubmit(insert2);
                            DB.SubmitChanges();
                            context.Response.ContentType = "text/plain";
                            context.Response.Write("ok");
                        }
                        else
                        {
                            context.Response.ContentType = "text/plain";
                            context.Response.Write("已存在的報表年月！");
                        }
                    }
                    else
                    {
                        context.Response.ContentType = "text/plain";
                        context.Response.Write("不正確的年月！");
                    }
                }
                catch
                {
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("異常的輸入值！");
                }

            }
            else
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("年月格式不正確！");
            }
        }
        else if (type.Equals("UpdateSubject"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            int SubjectID = json.SubjectID;
            string ReportDate = json.ReportDate;
            var update = (from a in DB.ReportKeyIn
                          where a.SubjectID == SubjectID && a.ReportDate == ReportDate
                          select a).FirstOrDefault();
            update.Num1 = json.GNum1;
            update.Num2 = json.GNum2;
            update.Num3 = json.GNum3;
            DB.SubmitChanges();
        }
        else if (type.Equals("AddSubject"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            int SubjectID = json.SubjectID;
            string ReportDate = json.ReportDate;
            string Type = json.Type;
            ReportKeyIn insert = new ReportKeyIn()
            {
                Num1 = 0,
                Num2 = 0,
                Num3 = 0,
                ReportDate = ReportDate,
                SubjectID = SubjectID,
                Type = Type
            };
            DB.ReportKeyIn.InsertOnSubmit(insert);
            DB.SubmitChanges();
        }
        else if (type.Equals("DeleteSubject"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            int SubjectID = json.SubjectID;
            string ReportDate = json.ReportDate;
            var delete = (from a in DB.ReportKeyIn
                          where a.SubjectID == SubjectID && a.ReportDate == ReportDate
                          select a).FirstOrDefault();

            DB.ReportKeyIn.DeleteOnSubmit(delete);
            DB.SubmitChanges();
        }
        else if (type.Equals("getSubjectAll"))
        {
            string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            dynamic json = JValue.Parse(str);
            string ReportDate = json.yyy + json.mm;
            string Type = json.Type;

            var insertBefore = from a in DB.Subject
                               where a.Type == Type && a.status == "1"
                               && a.Layer == 0
                               select a;
            List<SubjectAllRoot> result = new List<SubjectAllRoot>();
            getSubjectAll(insertBefore, result, 0);

            var search = (from a in DB.ReportKeyIn
                          where a.Type == Type && a.ReportDate == ReportDate
                          select a).ToList();
            foreach (var temp in result)
            {
                foreach (var temp2 in search)
                {
                    if (temp.SubjectID == temp2.SubjectID)
                    {
                        temp.Status = "1";
                    }
                }
            }
            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
    }

    public void addSubject(dynamic temp, List<SubjectRoot> result, int LayerNum, string ReportDate)
    {
        foreach (var inTemp in temp)
        {
            SubjectRoot sTemp = new SubjectRoot();
            sTemp.SubjectID = inTemp.SubjectID;
            sTemp.Num = inTemp.Num;
            sTemp.Code = inTemp.Code;
            sTemp.Name = inTemp.Name;
            sTemp.Layer = inTemp.Layer;
            sTemp.Type = inTemp.Type;
            sTemp.LayerNum = LayerNum;
            if (inTemp.Num1 != null)
            {
                sTemp.GNum1 = inTemp.Num1;
            }
            if (inTemp.Num2 != null)
            {
                sTemp.GNum2 = inTemp.Num2;
            }
            if (inTemp.Num3 != null)
            {
                sTemp.GNum3 = inTemp.Num3;
            }

            sTemp.HaveCh = true;

            int SubjectID = inTemp.SubjectID;

            var temp2 = from a in DB.Subject
                        join b in DB.ReportKeyIn
                        on a.SubjectID equals b.SubjectID into ps
                        from b in ps.DefaultIfEmpty()
                        where a.Layer == SubjectID && a.status == "1"
                        && b.ReportDate == ReportDate
                        orderby a.SubOrder
                        select new
                        {
                            a.Code,
                            a.Layer,
                            a.Name,
                            a.Num,
                            a.status,
                            a.SubjectID,
                            a.Type,
                            b.Num1,
                            b.Num2,
                            b.Num3
                        };

            if (temp2.Count() > 0)
            {
                result.Add(sTemp);
                addSubject(temp2, result, LayerNum + 1, ReportDate);
            }
            else
            {
                sTemp.HaveCh = false;
                result.Add(sTemp);
            }
        }
    }


    public void addSubject2(dynamic temp, List<SubjectRoot> result, int LayerNum, string ReportDate)
    {
        string yyy = ReportDate.Substring(0, 3);
        string mm = ReportDate.Substring(3, 2);
        foreach (var inTemp in temp)
        {
            SubjectRoot sTemp = new SubjectRoot();
            sTemp.SubjectID = inTemp.SubjectID;
            sTemp.Num = inTemp.Num;
            sTemp.Code = inTemp.Code;
            sTemp.Name = inTemp.Name;
            sTemp.Layer = inTemp.Layer;
            sTemp.Type = inTemp.Type;
            sTemp.LayerNum = LayerNum;
            if (inTemp.Num1 != null)
            {
                sTemp.GNum1 = inTemp.Num1;
            }
            if (inTemp.Num2 != null)
            {
                sTemp.GNum2 = inTemp.Num2;
            }
            if (inTemp.Num3 != null)
            {
                sTemp.GNum3 = inTemp.Num3;
            }
            sTemp.HaveCh = true;

            int SubjectID = inTemp.SubjectID;
            var temp2 = from a in DB.Subject
                        join b in (
                        from c in DB.ReportKeyIn
                        where c.ReportDate.Substring(0, 3) == yyy
                            && c.ReportDate.Substring(3, 2).CompareTo(mm) < 0
                        group c by c.SubjectID into s
                        select new
                        {
                            SubjectID = s.Key,
                            Num1 = s.Sum(p => p.Num1),
                            Num2 = s.Sum(p => p.Num2),
                            Num3 = s.Sum(p => p.Num3)
                        }
                        )
                        on a.SubjectID equals b.SubjectID into ps
                        from b in ps.DefaultIfEmpty()
                        where a.Layer == SubjectID
                        orderby a.SubOrder
                        select new
                        {
                            a.Code,
                            a.Layer,
                            a.Name,
                            a.Num,
                            a.status,
                            a.SubjectID,
                            a.Type,
                            b.Num1,
                            b.Num2,
                            b.Num3
                        };

            if (temp2.Count() > 0)
            {
                result.Add(sTemp);
                addSubject2(temp2, result, LayerNum + 1, ReportDate);
            }
            else
            {
                sTemp.HaveCh = false;
                result.Add(sTemp);
            }
        }
    }



    public void getSubjectAll(dynamic temp, List<SubjectAllRoot> result, int LayerNum)
    {
        foreach (var inTemp in temp)
        {
            SubjectAllRoot sTemp = new SubjectAllRoot();
            sTemp.SubjectID = inTemp.SubjectID;
            sTemp.Num = inTemp.Num;
            sTemp.Code = inTemp.Code;
            sTemp.Name = inTemp.Name;
            sTemp.Layer = inTemp.Layer;
            sTemp.Type = inTemp.Type;
            sTemp.LayerNum = LayerNum;
            result.Add(sTemp);
            int SubjectID = inTemp.SubjectID;
            var temp2 = from a in DB.Subject
                        where a.Layer == SubjectID
                        orderby a.SubOrder
                        select a;
            if (temp2.Count() > 0)
            {
                getSubjectAll(temp2, result, LayerNum + 1);
            }
        }
    }

    public class SubjectAllRoot
    {
        public int SubjectID;
        public string Num;
        public string Code;
        public string Name;
        public int Layer;
        public string Type;
        public int LayerNum;
        public string Status;
        public SubjectAllRoot()
        {
            Status = "0";
        }
    }

    public class mmTemp
    {
        public string yyy;
        public string mm;
    }



    public class SubjectRoot
    {
        public int SubjectID;
        public string Num;
        public string Code;
        public string Name;
        public int Layer;
        public string Type;
        public int LayerNum;
        public bool HaveCh;
        public long GNum1;
        public long GNum2;
        public long GNum3;
        public long AllGNum1;
        public long AllGNum2;
        public long AllGNum3;
    }



    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}