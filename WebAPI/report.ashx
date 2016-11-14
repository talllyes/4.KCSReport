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
        if (type.Equals("AllSubjectNum"))
        {
            //string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            //dynamic json = JValue.Parse(str);
            string ReportDate = "10509";
            string LastReportDate = "10508";
            var temp = from a in DB.Subject
                       join b in DB.ReportKeyIn
                       on a.SubjectID equals b.SubjectID into ps
                       from b in ps.DefaultIfEmpty()
                       where a.Layer == 0 && a.status == "1"
                       && b.ReportDate == ReportDate
                       orderby a.Num
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
                        where a.Layer == 0 && a.status == "1"
                        && b.ReportDate == ReportDate
                        orderby a.Num
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
            addSubject(temp, resultTemp2, 0, LastReportDate);


            foreach (var tt in resultTemp1)
            {
                foreach (var tt2 in resultTemp2)
                {
                    if (tt.SubjectID == tt2.SubjectID)
                    {
                        tt.LastGNum1 = tt2.GNum1;
                        tt.LastGNum2 = tt2.GNum2;
                        tt.LastGNum3 = tt2.GNum3;
                    }
                }
            }


            context.Response.ContentType = "text/plain";
            context.Response.Write(JsonConvert.SerializeObject(resultTemp1));
        }
    }

    public tempNum addSubject(dynamic temp, List<SubjectRoot> result, int LayerNum, string ReportDate)
    {
        tempNum Nums = new tempNum();
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
                        orderby a.Num
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
                tempNum inNums = new tempNum();
                inNums = addSubject(temp2, result, LayerNum + 1, ReportDate);
                Nums.tempNum1 = Nums.tempNum1 + inNums.tempNum1;
                Nums.tempNum2 = Nums.tempNum2 + inNums.tempNum2;
                Nums.tempNum3 = Nums.tempNum3 + inNums.tempNum3;
                sTemp.GNum1 = inNums.tempNum1;
                sTemp.GNum2 = inNums.tempNum2;
                sTemp.GNum3 = inNums.tempNum3;
                result.Add(sTemp);
            }
            else
            {
                sTemp.HaveCh = false;
                Nums.tempNum1 = Nums.tempNum1 + inTemp.Num1;
                Nums.tempNum2 = Nums.tempNum2 + inTemp.Num2;
                Nums.tempNum3 = Nums.tempNum3 + inTemp.Num3;
                result.Add(sTemp);
            }
        }
        return Nums;
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
    public class tempNum
    {
        public long tempNum1 = 0;
        public long tempNum2 = 0;
        public long tempNum3 = 0;
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
        public long LastGNum1;
        public long LastGNum2;
        public long LastGNum3;
    }



    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}