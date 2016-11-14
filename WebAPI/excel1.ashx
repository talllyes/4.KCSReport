<%@ WebHandler Language="C#" Class="report1" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.SessionState;
using System.Drawing;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Linq;
using System.Threading.Tasks;
using NPOI;
using NPOI.HSSF.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.SS.UserModel;
using System.IO;
using NPOI.SS.Util;



public class report1 : IHttpHandler, IRequiresSessionState
{
    public List<string> number = new List<string>();
    DataClassesDataContext DB = new DataClassesDataContext();
    string d1;
    string d2;
    List<程式Subject> 所有科目;
    List<輸入的資訊> 全部輸入;
    string ReportDate;
    string LastReportDate;
    string yyy;
    string lyyy;
    string mm;
    string lmm;
    public void ProcessRequest(HttpContext context)
    {
        string type = context.Items["parameter"].ToString();

        if (type.Equals("Excel"))
        {
            //string str = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            //dynamic json = JValue.Parse(str);
            // ReportDate = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
            ReportDate = context.Request.QueryString["date"].ToString();
            string aa = Int32.Parse(ReportDate.Substring(0, 3)) + 1911 + ReportDate.Substring(3, 2) + "01";
            DateTime bb = DateTime.ParseExact(aa, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);
            LastReportDate = bb.AddMonths(-1).Year - 1911 + bb.AddMonths(-1).ToString("MM");
            Dictionary<string, dynamic> result = new Dictionary<string, dynamic>();
            d1 = ReportDate;
            d2 = LastReportDate;
            yyy = ReportDate.Substring(0, 3);
            lyyy = LastReportDate.Substring(0, 3);
            mm = Int32.Parse(ReportDate.Substring(3, 2)).ToString();
            lmm = Int32.Parse(LastReportDate.Substring(3, 2)).ToString();

            所有科目 = (from a in DB.Subject
                    select new 程式Subject
                    {
                        Num = a.Num,
                        Type = a.Type,
                        SubjectID = a.SubjectID
                    }).ToList();
            全部輸入 = (from a in DB.ReportKeyIn
                    join b in DB.Subject
                    on a.SubjectID equals b.SubjectID
                    where a.ReportDate == ReportDate || a.ReportDate == LastReportDate
                    select new 輸入的資訊
                    {
                        SubjectID = (int)a.SubjectID,
                        Num1 = a.Num1 == null ? 0 : (long)a.Num1,
                        Num2 = a.Num2 == null ? 0 : (long)a.Num2,
                        Num3 = a.Num3 == null ? 0 : (long)a.Num3,
                        ReportDate = a.ReportDate,
                        Type = b.Type,
                        Layer = b.Layer,
                        Num = b.Num,
                        status = b.status
                    }).ToList();


            //2.融資狀況
            var 借款餘額temp1 = (from a in DB.ReportKeyIn
                             join b in DB.Subject on a.SubjectID equals b.SubjectID
                             where a.ReportDate == ReportDate && b.Num == "2102" && a.Type == "1"
                             select a).FirstOrDefault();


            var 借款餘額temp2 = (from a in DB.ReportKeyIn
                             join b in DB.Subject on a.SubjectID equals b.SubjectID
                             where a.ReportDate == LastReportDate && b.Num == "2102" && a.Type == "1"
                             select a).FirstOrDefault();
            List<報表輸出> 借款餘額 = new List<報表輸出>();
            借款餘額 = setGNum(借款餘額temp1, 借款餘額temp2);


            List<報表輸出> 短期借款總額度 = new List<報表輸出>();
            短期借款總額度 = 借款餘額;

            result.Add("短期借款總額度", 短期借款總額度);
            result.Add("借款餘額", 借款餘額);

            int 長期借款總額度 = 0;
            int 已動用 = 0;
            int 已償還 = 0;
            int 借款餘額2 = 0;
            result.Add("長期借款總額度", 長期借款總額度);
            result.Add("已動用", 已動用);
            result.Add("已償還", 已償還);
            result.Add("借款餘額2", 借款餘額2);

            //3.財務狀況
            var temps = (from a in DB.Subject
                         where a.Num == "41-47" && a.Type == "2"
                         select new
                         {
                             a.SubjectID
                         }).FirstOrDefault();

            tempNum 運輸收入temp1 = new tempNum();
            tempNum 運輸收入temp2 = new tempNum();
            運輸收入temp1 = getAllNum(temps.SubjectID, ReportDate);
            運輸收入temp2 = getAllNum(temps.SubjectID, LastReportDate);


            List<報表輸出> 運輸收入 = new List<報表輸出>();
            運輸收入 = setGNum(運輸收入temp1, 運輸收入temp2);
            result.Add("運輸收入", 運輸收入);


            int 附屬及開發事業收入 = 0;
            int 平準基金挹注收入 = 0;

            result.Add("附屬及開發事業收入", 附屬及開發事業收入);
            result.Add("平準基金挹注收入", 平準基金挹注收入);


            var temp2 = (from a in DB.Subject
                         where a.Num == "49" && a.Type == "2"
                         select new
                         {
                             a.SubjectID
                         }).FirstOrDefault();

            tempNum 其他收入temp1 = new tempNum();
            tempNum 其他收入temp2 = new tempNum();
            其他收入temp1 = getAllNum(temp2.SubjectID, ReportDate);
            其他收入temp2 = getAllNum(temp2.SubjectID, LastReportDate);


            List<報表輸出> 其他收入 = new List<報表輸出>();
            其他收入 = setGNum(其他收入temp1, 其他收入temp2);
            result.Add("其他收入", 其他收入);


            List<報表輸出> 總收入 = new List<報表輸出>();
            報表輸出 總收入t1 = new 報表輸出();
            總收入t1.ReportDate = d1;
            總收入t1.GNum1 = 運輸收入[0].GNum1 + 其他收入[0].GNum1;
            總收入t1.GNum2 = 運輸收入[0].GNum2 + 其他收入[0].GNum2;
            總收入t1.GNum3 = 運輸收入[0].GNum3 + 其他收入[0].GNum3;
            報表輸出 總收入t2 = new 報表輸出();
            總收入t2.ReportDate = d2;
            總收入t2.GNum1 = 運輸收入[1].GNum1 + 其他收入[1].GNum1;
            總收入t2.GNum2 = 運輸收入[1].GNum2 + 其他收入[1].GNum2;
            總收入t2.GNum3 = 運輸收入[1].GNum3 + 其他收入[1].GNum3;
            總收入.Add(總收入t1);
            總收入.Add(總收入t2);

            result.Add("總收入", 總收入);



            var temp3 = (from a in DB.Subject
                         where a.Num == "51-57" && a.Type == "2"
                         select new
                         {
                             a.SubjectID
                         }).FirstOrDefault();

            tempNum 運輸成本temp1 = new tempNum();
            tempNum 運輸成本temp2 = new tempNum();
            運輸成本temp1 = getAllNum(temp3.SubjectID, ReportDate);
            運輸成本temp2 = getAllNum(temp3.SubjectID, LastReportDate);


            List<報表輸出> 運輸成本 = new List<報表輸出>();
            運輸成本 = setGNum(運輸成本temp1, 運輸成本temp2);
            result.Add("運輸成本", 運輸成本);

            var temp4 = (from a in DB.Subject
                         where a.Num == "58" && a.Type == "2"
                         select new
                         {
                             a.SubjectID
                         }).FirstOrDefault();

            tempNum 管理費用temp1 = new tempNum();
            tempNum 管理費用temp2 = new tempNum();
            管理費用temp1 = getAllNum(temp4.SubjectID, ReportDate);
            管理費用temp2 = getAllNum(temp4.SubjectID, LastReportDate);

            List<報表輸出> 管理費用 = new List<報表輸出>();
            管理費用 = setGNum(管理費用temp1, 管理費用temp2);
            result.Add("管理費用", 管理費用);

            int 貸款利息費用 = 0;
            result.Add("貸款利息費用", 貸款利息費用);

            var temp5 = (from a in DB.Subject
                         where a.Num == "59" && a.Type == "2"
                         select new
                         {
                             a.SubjectID
                         }).FirstOrDefault();

            tempNum 其他支出temp1 = new tempNum();
            tempNum 其他支出temp2 = new tempNum();
            其他支出temp1 = getAllNum(temp5.SubjectID, ReportDate);
            其他支出temp2 = getAllNum(temp5.SubjectID, LastReportDate);

            List<報表輸出> 其他支出 = new List<報表輸出>();
            其他支出 = setGNum(其他支出temp1, 其他支出temp2);
            result.Add("其他支出", 其他支出);


            List<報表輸出> 總支出 = new List<報表輸出>();
            報表輸出 總支出t1 = new 報表輸出();
            總支出t1.ReportDate = d1;
            總支出t1.GNum1 = 運輸成本[0].GNum1 + 管理費用[0].GNum1 + 其他支出[0].GNum1;
            總支出t1.GNum2 = 運輸成本[0].GNum2 + 管理費用[0].GNum2 + 其他支出[0].GNum2;
            總支出t1.GNum3 = 運輸成本[0].GNum3 + 管理費用[0].GNum3 + 其他支出[0].GNum3;
            報表輸出 總支出t2 = new 報表輸出();
            總支出t2.ReportDate = d2;
            總支出t2.GNum1 = 運輸成本[1].GNum1 + 管理費用[1].GNum1 + 其他支出[1].GNum1;
            總支出t2.GNum2 = 運輸成本[1].GNum2 + 管理費用[1].GNum2 + 其他支出[1].GNum2;
            總支出t2.GNum3 = 運輸成本[1].GNum3 + 管理費用[1].GNum3 + 其他支出[1].GNum3;
            總支出.Add(總支出t1);
            總支出.Add(總支出t2);

            result.Add("總支出", 總支出);



            List<報表輸出> 當月份盈餘 = new List<報表輸出>();
            報表輸出 當月份盈餘t1 = new 報表輸出();
            當月份盈餘t1.ReportDate = d1;
            當月份盈餘t1.GNum1 = 總收入[0].GNum1 - 總支出[0].GNum1;
            當月份盈餘t1.GNum2 = 總收入[0].GNum2 - 總支出[0].GNum2;
            當月份盈餘t1.GNum3 = 總收入[0].GNum3 - 總支出[0].GNum3;
            報表輸出 當月份盈餘t2 = new 報表輸出();
            當月份盈餘t2.ReportDate = d2;
            當月份盈餘t2.GNum1 = 總收入[1].GNum1 - 總支出[1].GNum1;
            當月份盈餘t2.GNum2 = 總收入[1].GNum2 - 總支出[1].GNum2;
            當月份盈餘t2.GNum3 = 總收入[1].GNum3 - 總支出[1].GNum3;
            當月份盈餘.Add(當月份盈餘t1);
            當月份盈餘.Add(當月份盈餘t2);

            result.Add("當月份盈餘", 當月份盈餘);



            //右側上方資料開始

            List<報表輸出long> 股東權益總額 = 右側資料("3", "1");
            result.Add("股東權益總額", 股東權益總額);

            List<報表輸出long> 資產總額 = 右側資料("1", "1");
            result.Add("資產總額", 資產總額);

            List<報表輸出long> 本期損益 = 右側資料("67", "2");
            result.Add("本期損益", 本期損益);

            List<報表輸出long> 保留盈餘 = 右側資料("33", "1");
            result.Add("保留盈餘", 保留盈餘);

            List<報表輸出long> 航行費用折舊 = 右側資料("54025", "4");
            result.Add("航行費用折舊", 航行費用折舊);


            List<報表輸出long> 管理費用折舊 = 右側資料("58215", "5");
            List<報表輸出long> 管理費用攤銷 = 右側資料("582159", "5");
            管理費用折舊[0].GNum2 = 管理費用折舊[0].GNum2 - 管理費用攤銷[0].GNum2;
            管理費用折舊[1].GNum2 = 管理費用折舊[1].GNum2 - 管理費用攤銷[1].GNum2;
            result.Add("管理費用折舊", 管理費用折舊);

            //右側下方資料開始
            List<報表輸出long> 會計54021 = 右側資料("54021", "4");
            List<報表輸出long> 會計54022 = 右側資料("54022", "4");
            List<報表輸出long> 會計54023 = 右側資料("54023", "4");
            List<報表輸出long> 會計54024 = 右側資料("54024", "4");
            List<報表輸出long> 會計54026 = 右側資料("54026", "4");
            List<報表輸出long> 會計54027 = 右側資料("54027", "4");
            List<報表輸出long> 會計54028 = 右側資料("54028", "4");
            List<報表輸出long> 會計54029 = 右側資料("54029", "4");

            result.Add("會計54021", 會計54021);
            result.Add("會計54022", 會計54022);
            result.Add("會計54023", 會計54023);
            result.Add("會計54024", 會計54024);
            result.Add("會計54026", 會計54026);
            result.Add("會計54027", 會計54027);
            result.Add("會計54028", 會計54028);
            result.Add("會計54029", 會計54029);


            List<報表輸出long> 航行費用合計 = new List<報表輸出long>();
            報表輸出long 航行費用合計temp1 = new 報表輸出long();
            航行費用合計temp1.ReportDate = ReportDate;
            航行費用合計temp1.GNum1 = 會計54021[0].GNum1 + 會計54022[0].GNum1 + 會計54023[0].GNum1 + 會計54024[0].GNum1 + 會計54026[0].GNum1 + 會計54027[0].GNum1 + 會計54028[0].GNum1 + 會計54029[0].GNum1;
            航行費用合計temp1.GNum2 = 會計54021[0].GNum2 + 會計54022[0].GNum2 + 會計54023[0].GNum2 + 會計54024[0].GNum2 + 會計54026[0].GNum2 + 會計54027[0].GNum2 + 會計54028[0].GNum2 + 會計54029[0].GNum2;
            航行費用合計temp1.GNum3 = 會計54021[0].GNum3 + 會計54022[0].GNum3 + 會計54023[0].GNum3 + 會計54024[0].GNum3 + 會計54026[0].GNum3 + 會計54027[0].GNum3 + 會計54028[0].GNum3 + 會計54029[0].GNum3;

            報表輸出long 航行費用合計temp2 = new 報表輸出long();
            航行費用合計temp2.ReportDate = LastReportDate;
            航行費用合計temp2.GNum1 = 會計54021[1].GNum1 + 會計54022[1].GNum1 + 會計54023[1].GNum1 + 會計54024[1].GNum1 + 會計54026[1].GNum1 + 會計54027[1].GNum1 + 會計54028[1].GNum1 + 會計54029[1].GNum1;
            航行費用合計temp2.GNum2 = 會計54021[1].GNum2 + 會計54022[1].GNum2 + 會計54023[1].GNum2 + 會計54024[1].GNum2 + 會計54026[1].GNum2 + 會計54027[1].GNum2 + 會計54028[1].GNum2 + 會計54029[1].GNum2;
            航行費用合計temp2.GNum3 = 會計54021[1].GNum3 + 會計54022[1].GNum3 + 會計54023[1].GNum3 + 會計54024[1].GNum3 + 會計54026[1].GNum3 + 會計54027[1].GNum3 + 會計54028[1].GNum3 + 會計54029[1].GNum3;

            航行費用合計.Add(航行費用合計temp1);
            航行費用合計.Add(航行費用合計temp2);
            result.Add("航行費用合計", 航行費用合計);

            double 會計54021N = Math.Round(toPar(會計54021[0].GNum2, 航行費用合計[0].GNum2), 2);
            double 會計54022N = Math.Round(toPar(會計54022[0].GNum2, 航行費用合計[0].GNum2), 2);
            double 會計54023N = Math.Round(toPar(會計54023[0].GNum2, 航行費用合計[0].GNum2), 2);
            double 會計54024N = Math.Round(toPar(會計54024[0].GNum2, 航行費用合計[0].GNum2), 2);
            double 會計54026N = Math.Round(toPar(會計54026[0].GNum2, 航行費用合計[0].GNum2), 2);
            double 會計54027N = Math.Round(toPar(會計54027[0].GNum2, 航行費用合計[0].GNum2), 2);
            double 會計54028N = Math.Round(toPar(會計54028[0].GNum2, 航行費用合計[0].GNum2), 2);
            double 會計54029N = Math.Round(toPar(會計54029[0].GNum2, 航行費用合計[0].GNum2), 2);

            double 會計54021L = Math.Round(toPar(會計54021[1].GNum2, 航行費用合計[1].GNum2), 2);
            double 會計54022L = Math.Round(toPar(會計54022[1].GNum2, 航行費用合計[1].GNum2), 2);
            double 會計54023L = Math.Round(toPar(會計54023[1].GNum2, 航行費用合計[1].GNum2), 2);
            double 會計54024L = Math.Round(toPar(會計54024[1].GNum2, 航行費用合計[1].GNum2), 2);
            double 會計54026L = Math.Round(toPar(會計54026[1].GNum2, 航行費用合計[1].GNum2), 2);
            double 會計54027L = Math.Round(toPar(會計54027[1].GNum2, 航行費用合計[1].GNum2), 2);
            double 會計54028L = Math.Round(toPar(會計54028[1].GNum2, 航行費用合計[1].GNum2), 2);
            double 會計54029L = Math.Round(toPar(會計54029[1].GNum2, 航行費用合計[1].GNum2), 2);

            result.Add("會計54021N", 會計54021N);
            result.Add("會計54022N", 會計54022N);
            result.Add("會計54023N", 會計54023N);
            result.Add("會計54024N", 會計54024N);
            result.Add("會計54026N", 會計54026N);
            result.Add("會計54027N", 會計54027N);
            result.Add("會計54028N", 會計54028N);
            result.Add("會計54029N", 會計54029N);

            result.Add("會計54021L", 會計54021L);
            result.Add("會計54022L", 會計54022L);
            result.Add("會計54023L", 會計54023L);
            result.Add("會計54024L", 會計54024L);
            result.Add("會計54026L", 會計54026L);
            result.Add("會計54027L", 會計54027L);
            result.Add("會計54028L", 會計54028L);
            result.Add("會計54029L", 會計54029L);


            List<報表輸出long> 航行費用實際數 = 右側資料("0", "4");
            result.Add("航行費用實際數", 航行費用實際數);



            //4.xxx年x月份損益

            int 運輸收入ml = 運輸收入[0].GNum2;
            int 附屬及開發事業收入ml = 0;
            int 平準基金挹注收入ml = 0;
            int 其他收入ml = 其他收入[0].GNum2;
            int 總計ml = 總收入[0].GNum2;

            result.Add("運輸收入ml", 運輸收入ml);
            result.Add("附屬及開發事業收入ml", 附屬及開發事業收入ml);
            result.Add("平準基金挹注收入ml", 平準基金挹注收入ml);
            result.Add("其他收入ml", 其他收入ml);
            result.Add("總計ml", 總計ml);



            int 運輸成本mr = 運輸成本[0].GNum2 - (int)Math.Round((double)航行費用折舊[0].GNum2 / 1000, MidpointRounding.AwayFromZero);
            int 管理費用mr = 管理費用[0].GNum2 - (int)Math.Round((double)管理費用折舊[0].GNum2 / 1000, MidpointRounding.AwayFromZero);
            int 貸款利息費用mr = 貸款利息費用;
            int 其他支出mr = 其他支出[0].GNum2;
            int 小計mr = 運輸成本mr + 管理費用mr + 貸款利息費用mr + 其他支出mr;
            int 折舊費用mr = (int)Math.Round((double)(航行費用折舊[0].GNum2 + 管理費用折舊[0].GNum2) / 1000, MidpointRounding.AwayFromZero);
            int 總計mr = 小計mr + 折舊費用mr;


            result.Add("運輸成本mr", 運輸成本mr);
            result.Add("管理費用mr", 管理費用mr);
            result.Add("貸款利息費用mr", 貸款利息費用mr);
            result.Add("其他支出mr", 其他支出mr);
            result.Add("小計mr", 小計mr);
            result.Add("折舊費用mr", 折舊費用mr);
            result.Add("總計mr", 總計mr);
            int 虧損 = 總計ml - 總計mr;
            result.Add("虧損", 虧損);


            //5.xxx年x月份主要收支
            int 運輸收入md = 運輸收入ml;
            int 附屬事業收入md = 0;
            int 開發收入md = 0;

            int 運輸成本md = 運輸成本mr;
            int 附屬事業成本md = 0;
            int 開發成本md = 0;

            int 差異1 = 運輸收入md - 運輸成本md;
            int 差異2 = 附屬事業收入md - 附屬事業成本md;
            int 差異3 = 開發收入md - 開發成本md;

            result.Add("運輸收入md", 運輸收入md);
            result.Add("附屬事業收入md", 附屬事業收入md);
            result.Add("開發收入md", 開發收入md);

            result.Add("運輸成本md", 運輸成本md);
            result.Add("附屬事業成本md", 附屬事業成本md);
            result.Add("開發成本md", 開發成本md);

            result.Add("差異1", 差異1);
            result.Add("差異2", 差異2);
            result.Add("差異3", 差異3);



            //1.自有資金比率
            double 自有資金比率 = Math.Round(toPar(股東權益總額[0].GNum1, 資產總額[0].GNum1), 2);
            double 自有資金比率2 = Math.Round(toPar(股東權益總額[0].GNum1, 資產總額[0].GNum1), 2);
            result.Add("自有資金比率", 自有資金比率);
            result.Add("自有資金比率2", 自有資金比率2);

            excel(context, result);
        }
    }

    public List<報表輸出long> 右側資料(string Num, string Type)
    {
        int 先取ID = (from a in 所有科目
                    where a.Num == Num && a.Type == Type
                    select a.SubjectID).FirstOrDefault();
        List<報表輸出long> tt = new List<報表輸出long>();
        報表輸出long t1 = new 報表輸出long();
        報表輸出long t2 = new 報表輸出long();
        tempNum temp1 = new tempNum();
        tempNum temp2 = new tempNum();
        if (先取ID != 0)
        {
            temp1 = getAllNum(先取ID, ReportDate);
            temp2 = getAllNum(先取ID, LastReportDate);

            t1.ReportDate = ReportDate;
            t1.GNum1 = temp1.Num1;
            t1.GNum2 = temp1.Num2;
            t1.GNum3 = temp1.Num3;

            t2.ReportDate = LastReportDate;
            t2.GNum1 = temp2.Num1;
            t2.GNum2 = temp2.Num2;
            t2.GNum3 = temp2.Num3;
        }
        tt.Add(t1);
        tt.Add(t2);
        return tt;
    }

    public double toPar(long num1, long num2)
    {
        double toto = ((double)num1 / (double)num2) * 100;
        return toto;
    }

    public class 程式Subject
    {
        public string Num;
        public string Type;
        public int SubjectID;
    }
    public List<報表輸出> setGNum(dynamic one, dynamic two)
    {
        List<報表輸出> tt = new List<報表輸出>();
        報表輸出 t1 = new 報表輸出();
        t1.ReportDate = d1;
        if (one != null)
        {
            if (one.Num1 != null)
            {

                t1.GNum1 = (int)Math.Round((double)one.Num1 / 1000, MidpointRounding.AwayFromZero);
            }
            if (one.Num2 != null)
            {
                t1.GNum2 = (int)Math.Round((double)one.Num2 / 1000, MidpointRounding.AwayFromZero);
            }
            if (one.Num3 != null)
            {
                t1.GNum3 = (int)Math.Round((double)one.Num3 / 1000, MidpointRounding.AwayFromZero);
            }
        }
        報表輸出 t2 = new 報表輸出();
        t2.ReportDate = d2;
        if (two != null)
        {
            if (two.Num1 != null)
            {
                t2.GNum1 = (int)Math.Round((double)two.Num1 / 1000, MidpointRounding.AwayFromZero);
            }
            if (two.Num2 != null)
            {
                t2.GNum2 = (int)Math.Round((double)two.Num2 / 1000, MidpointRounding.AwayFromZero);
            }
            if (two.Num3 != null)
            {
                t2.GNum3 = (int)Math.Round((double)two.Num3 / 1000, MidpointRounding.AwayFromZero);
            }
        }
        tt.Add(t1);
        tt.Add(t2);

        return tt;
    }




    public tempNum getAllNum(int SubjectID, string ReportDate)
    {
        tempNum num = new tempNum();


        var temp1 = from a in 全部輸入
                    where a.ReportDate == ReportDate && a.Layer == SubjectID
                    select a;

        if (temp1.Count() > 0)
        {

            foreach (var a in temp1)
            {
                tempNum numtemp = new tempNum();
                numtemp = getAllNum((int)a.SubjectID, ReportDate);
                num.Num1 = num.Num1 + numtemp.Num1;
                num.Num2 = num.Num2 + numtemp.Num2;
                num.Num3 = num.Num3 + numtemp.Num3;
            }
        }
        else
        {
            var temp2 = (from a in 全部輸入
                         where a.ReportDate == ReportDate && a.SubjectID == SubjectID
                         select new
                         {
                             Num1 = a.Num1,
                             Num2 = a.Num2,
                             Num3 = a.Num3
                         }).FirstOrDefault();
            if (temp2 != null)
            {

                num.Num1 = num.Num1 + (long)temp2.Num1;

                num.Num2 = num.Num2 + (long)temp2.Num2;

                num.Num3 = num.Num3 + (long)temp2.Num3;

            }
        }

        return num;
    }

    public class 報表輸出
    {
        public string ReportDate;
        public int GNum1;
        public int GNum2;
        public int GNum3;
    }
    public class 報表輸出long
    {
        public string ReportDate;
        public long GNum1;
        public long GNum2;
        public long GNum3;
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
        public long Num1 = 0;
        public long Num2 = 0;
        public long Num3 = 0;
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

    public void excel(HttpContext context, Dictionary<string, dynamic> result)
    {

        FileStream file = new FileStream(HttpContext.Current.Server.MapPath("~/Excel/excel1.xlsx"), FileMode.Open, FileAccess.Read); // 開啟讀取樣版檔
        XSSFWorkbook workbook = new XSSFWorkbook(file);


        XSSFSheet sheetTemp = (XSSFSheet)workbook.GetSheetAt(0);

        //2.融資狀況
        sheetTemp.GetRow(9).GetCell(2).SetCellValue(result["短期借款總額度"][0].GNum1);
        sheetTemp.GetRow(9).GetCell(3).SetCellValue(result["短期借款總額度"][1].GNum1);
        sheetTemp.GetRow(10).GetCell(2).SetCellValue(result["借款餘額"][0].GNum1);
        sheetTemp.GetRow(10).GetCell(3).SetCellValue(result["借款餘額"][1].GNum1);
        sheetTemp.GetRow(11).GetCell(2).SetCellValue(0);
        sheetTemp.GetRow(11).GetCell(3).SetCellValue(0);
        sheetTemp.GetRow(12).GetCell(2).SetCellValue(0);
        sheetTemp.GetRow(12).GetCell(3).SetCellValue(0);
        sheetTemp.GetRow(13).GetCell(2).SetCellValue(0);
        sheetTemp.GetRow(13).GetCell(3).SetCellValue(0);
        sheetTemp.GetRow(14).GetCell(2).SetCellValue(0);
        sheetTemp.GetRow(14).GetCell(3).SetCellValue(0);

        //3.財務狀況
        sheetTemp.GetRow(18).GetCell(2).SetCellValue(result["運輸收入"][0].GNum2);
        sheetTemp.GetRow(18).GetCell(3).SetCellValue(result["運輸收入"][1].GNum2);
        sheetTemp.GetRow(19).GetCell(2).SetCellValue(0);
        sheetTemp.GetRow(19).GetCell(3).SetCellValue(0);
        sheetTemp.GetRow(20).GetCell(2).SetCellValue(0);
        sheetTemp.GetRow(20).GetCell(3).SetCellValue(0);
        sheetTemp.GetRow(21).GetCell(2).SetCellValue(result["其他收入"][0].GNum2);
        sheetTemp.GetRow(21).GetCell(3).SetCellValue(result["其他收入"][1].GNum2);

        sheetTemp.GetRow(23).GetCell(2).SetCellValue(result["運輸成本"][0].GNum2);
        sheetTemp.GetRow(23).GetCell(3).SetCellValue(result["運輸成本"][1].GNum2);
        sheetTemp.GetRow(24).GetCell(2).SetCellValue(result["管理費用"][0].GNum2);
        sheetTemp.GetRow(24).GetCell(3).SetCellValue(result["管理費用"][1].GNum2);
        sheetTemp.GetRow(25).GetCell(2).SetCellValue(0);
        sheetTemp.GetRow(25).GetCell(3).SetCellValue(0);
        sheetTemp.GetRow(26).GetCell(2).SetCellValue(result["其他支出"][0].GNum2);
        sheetTemp.GetRow(26).GetCell(3).SetCellValue(result["其他支出"][1].GNum2);

        sheetTemp.GetRow(5).GetCell(12).SetCellValue(result["股東權益總額"][0].GNum1);
        sheetTemp.GetRow(5).GetCell(14).SetCellValue(result["股東權益總額"][1].GNum1);
        sheetTemp.GetRow(6).GetCell(12).SetCellValue(result["資產總額"][0].GNum1);
        sheetTemp.GetRow(6).GetCell(14).SetCellValue(result["資產總額"][1].GNum1);
        sheetTemp.GetRow(7).GetCell(12).SetCellValue(result["本期損益"][0].GNum2);
        sheetTemp.GetRow(7).GetCell(14).SetCellValue(result["本期損益"][1].GNum2);
        sheetTemp.GetRow(8).GetCell(12).SetCellValue(result["保留盈餘"][0].GNum1);
        sheetTemp.GetRow(8).GetCell(14).SetCellValue(result["保留盈餘"][1].GNum1);
        sheetTemp.GetRow(9).GetCell(12).SetCellValue(result["航行費用折舊"][0].GNum2);
        sheetTemp.GetRow(9).GetCell(14).SetCellValue(result["航行費用折舊"][1].GNum2);
        sheetTemp.GetRow(10).GetCell(12).SetCellValue(result["管理費用折舊"][0].GNum2);
        sheetTemp.GetRow(10).GetCell(14).SetCellValue(result["管理費用折舊"][1].GNum2);

        sheetTemp.GetRow(18).GetCell(12).SetCellValue(result["會計54021"][0].GNum2);
        sheetTemp.GetRow(18).GetCell(14).SetCellValue(result["會計54021"][1].GNum2);
        sheetTemp.GetRow(19).GetCell(12).SetCellValue(result["會計54022"][0].GNum2);
        sheetTemp.GetRow(19).GetCell(14).SetCellValue(result["會計54022"][1].GNum2);
        sheetTemp.GetRow(20).GetCell(12).SetCellValue(result["會計54023"][0].GNum2);
        sheetTemp.GetRow(20).GetCell(14).SetCellValue(result["會計54023"][1].GNum2);
        sheetTemp.GetRow(21).GetCell(12).SetCellValue(result["會計54024"][0].GNum2);
        sheetTemp.GetRow(21).GetCell(14).SetCellValue(result["會計54024"][1].GNum2);
        sheetTemp.GetRow(22).GetCell(12).SetCellValue(result["會計54026"][0].GNum2);
        sheetTemp.GetRow(22).GetCell(14).SetCellValue(result["會計54026"][1].GNum2);
        sheetTemp.GetRow(23).GetCell(12).SetCellValue(result["會計54027"][0].GNum2);
        sheetTemp.GetRow(23).GetCell(14).SetCellValue(result["會計54027"][1].GNum2);
        sheetTemp.GetRow(24).GetCell(12).SetCellValue(result["會計54028"][0].GNum2);
        sheetTemp.GetRow(24).GetCell(14).SetCellValue(result["會計54028"][1].GNum2);
        sheetTemp.GetRow(25).GetCell(12).SetCellValue(result["會計54029"][0].GNum2);
        sheetTemp.GetRow(25).GetCell(14).SetCellValue(result["會計54029"][1].GNum2);

        sheetTemp.GetRow(28).GetCell(12).SetCellValue(result["航行費用實際數"][0].GNum2);
        sheetTemp.GetRow(28).GetCell(14).SetCellValue(result["航行費用實際數"][1].GNum2);



        sheetTemp.GetRow(1).GetCell(1).SetCellValue(yyy + "年" + mm + "月份 財務概要");

        sheetTemp.GetRow(4).GetCell(2).SetCellValue(yyy + "年" + mm + "月");
        sheetTemp.GetRow(4).GetCell(3).SetCellValue(lyyy + "年" + lmm + "月");

        sheetTemp.GetRow(8).GetCell(2).SetCellValue(yyy + "年" + mm + "月");
        sheetTemp.GetRow(8).GetCell(3).SetCellValue(lyyy + "年" + lmm + "月");

        sheetTemp.GetRow(17).GetCell(2).SetCellValue(yyy + "年" + mm + "月");
        sheetTemp.GetRow(17).GetCell(3).SetCellValue(lyyy + "年" + lmm + "月");

        sheetTemp.GetRow(3).GetCell(5).SetCellValue("4." + yyy + "年" + mm + "月份損益");
        sheetTemp.GetRow(19).GetCell(5).SetCellValue("5." + yyy + "年" + mm + "份主要收支");

        sheetTemp.GetRow(4).GetCell(12).SetCellValue(mm + "月份月報資料");
        sheetTemp.GetRow(4).GetCell(14).SetCellValue(lmm + "月份月報資料");

        sheetTemp.GetRow(17).GetCell(12).SetCellValue(mm + "月份月報資料");
        sheetTemp.GetRow(17).GetCell(14).SetCellValue(lmm + "月份月報資料");
        workbook.SetSheetName(0, yyy + "." + mm);

        sheetTemp.ForceFormulaRecalculation = true;
        string fileLocation = context.Request.PhysicalApplicationPath;
        MemoryStream MS = new MemoryStream();   //==需要 System.IO命名空間

        string name = "輪船公司" + yyy + "年" + mm + "月份財務概要(1003版)";

        workbook.Write(MS);
        //== Excel檔名，請寫在最後面 filename的地方
        context.Response.AddHeader("Content-Disposition", "attachment; filename=" + name + ".xlsx");
        context.Response.BinaryWrite(MS.ToArray());
        //== 釋放資源
        workbook = null;
        MS.Close();
        MS.Dispose();
        context.Response.Flush();
        context.Response.End();
    }
    public class 輸入的資訊
    {
        public int SubjectID;
        public long Num1;
        public long Num2;
        public long Num3;
        public string ReportDate;
        public string Type;
        public int Layer;
        public string Num;
        public string status;
    }

}