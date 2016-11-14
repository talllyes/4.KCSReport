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
        if (type.Equals("Subject1"))
        {
            string ReportDate = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            var temp = from a in DB.Subject
                       join b in DB.ReportKeyIn
                       on a.SubjectID equals b.SubjectID into ps
                       from b in ps.DefaultIfEmpty()
                       where a.SubjectID == 1 && a.status == "1"
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
                        join b in DB.ReportKeyIn
                        on a.SubjectID equals b.SubjectID into ps
                        from b in ps.DefaultIfEmpty()
                        where (a.SubjectID == 2 || a.SubjectID == 3) && a.status == "1"
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
            List<SubjectRoot> resultTemp2 = new List<SubjectRoot>();
            addSubject(temp2, resultTemp2, 0, ReportDate);
            List<SubjectRoot> result = new List<SubjectRoot>();

            if (resultTemp1.Count() > resultTemp2.Count())
            {
                for (int i = 0; i < resultTemp1.Count(); i++)
                {
                    SubjectRoot temps = new SubjectRoot();
                    temps.Code = resultTemp1[i].Code;
                    temps.Layer = resultTemp1[i].Layer;
                    temps.LayerNum = resultTemp1[i].LayerNum;
                    temps.Name = resultTemp1[i].Name;
                    temps.Num = resultTemp1[i].Num;
                    temps.SubjectID = resultTemp1[i].SubjectID;
                    temps.Type = resultTemp1[i].Type;
                    temps.GNum1 = resultTemp1[i].GNum1;
                    temps.GNum2 = resultTemp1[i].GNum2;
                    temps.GNum3 = resultTemp1[i].GNum3;
                    temps.HaveCh = resultTemp1[i].HaveCh;

                    if (i < resultTemp2.Count())
                    {
                        temps.Code2 = resultTemp2[i].Code;
                        temps.Layer2 = resultTemp2[i].Layer;
                        temps.LayerNum2 = resultTemp2[i].LayerNum;
                        temps.Name2 = resultTemp2[i].Name;
                        temps.Num2 = resultTemp2[i].Num;
                        temps.SubjectID2 = resultTemp2[i].SubjectID;
                        temps.Type2 = resultTemp2[i].Type;
                        temps.GNum21 = resultTemp2[i].GNum1;
                        temps.GNum22 = resultTemp2[i].GNum2;
                        temps.GNum23 = resultTemp2[i].GNum3;
                        temps.HaveCh2 = resultTemp2[i].HaveCh;
                    }


                    result.Add(temps);
                }
            }
            else
            {
                for (int i = 0; i < resultTemp2.Count(); i++)
                {
                    SubjectRoot temps = new SubjectRoot();
                    temps.Code2 = resultTemp2[i].Code;
                    temps.Layer2 = resultTemp2[i].Layer;
                    temps.LayerNum2 = resultTemp2[i].LayerNum;
                    temps.Name2 = resultTemp2[i].Name;
                    temps.Num2 = resultTemp2[i].Num;
                    temps.SubjectID2 = resultTemp2[i].SubjectID;
                    temps.Type2 = resultTemp2[i].Type;
                    temps.GNum1 = resultTemp2[i].GNum1;
                    temps.GNum2 = resultTemp2[i].GNum2;
                    temps.GNum3 = resultTemp2[i].GNum3;
                    temps.HaveCh = resultTemp2[i].HaveCh;

                    if (i < resultTemp1.Count())
                    {
                        temps.Code = resultTemp1[i].Code;
                        temps.Layer = resultTemp1[i].Layer;
                        temps.LayerNum = resultTemp1[i].LayerNum;
                        temps.Name = resultTemp1[i].Name;
                        temps.Num = resultTemp1[i].Num;
                        temps.SubjectID = resultTemp1[i].SubjectID;
                        temps.Type = resultTemp1[i].Type;
                        temps.GNum21 = resultTemp1[i].GNum1;
                        temps.GNum22 = resultTemp1[i].GNum2;
                        temps.GNum23 = resultTemp1[i].GNum3;
                        temps.HaveCh2 = resultTemp1[i].HaveCh;
                    }
                    result.Add(temps);
                }
            }


            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (type.Equals("ReportList"))
        {

            var temp = (from a in DB.ReportKeyIn
                        where a.Type == "1"
                        orderby a.ReportDate descending
                        select a.ReportDate.Substring(0, 3)).Distinct().OrderBy(p => p);
            Dictionary<string, dynamic> result = new Dictionary<string, dynamic>();
            List<string> tlist = new List<string>();
            foreach (var tt in temp)
            {
                tlist.Add(tt);
            }

            result.Add("yyy", tlist);

            var temp2 = (from a in DB.ReportKeyIn
                         where a.Type == "1"
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
                            News insert2 = new News()
                            {
                                NewsType = "報表新增",
                                NewsContent = yyy + "年" + mm + "月-資產負債表",
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
            string Type = "1";

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
            sTemp.GNum1 = inTemp.Num1;
            sTemp.GNum2 = inTemp.Num2;
            sTemp.GNum3 = inTemp.Num3;
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

        public int SubjectID2;
        public string Num2;
        public string Code2;
        public string Name2;
        public int Layer2;
        public string Type2;
        public int LayerNum2;
        public bool HaveCh2;
        public long GNum21;
        public long GNum22;
        public long GNum23;

    }



    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}