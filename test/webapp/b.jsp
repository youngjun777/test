<%@ page session="true" import="com.gauce.*,com.gauce.io.*,com.gauce.common.*,com.gauce.log.*,com.gauce.db.*,java.sql.*,javax.sql.*,javax.naming.*" contentType="text/html; charset=euc-kr"%>
<%@ include file="b2b_login_file_1q.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> -->
<!-- *************************************************************-->
<!-- 1. 프로그램 id   : b2b_login_file.html (그리드가 하나일경우)	-->
<!-- 2. 유형(시나리오): user id check										-->
<!-- 3. 기 능 정 의   : login check      									-->
<!-- 4. 변 경 이 력   : 박두현 작성											-->
<!-- 5. 관련프로그램  :															-->
<!-- 6. 특 기 사 항   :	2006.07.05 황보은영수정							-->  
<!-- *************************************************************-->
<HTML><HEAD>
<TITLE>CJ건설 전자조달시스템</TITLE>
<META http-equiv=Content-Type content="text/html; charset=EUC-KR">
<META content="MSHTML 6.00.2716.2200" name=GENERATOR>
<META content="Pragma" CONTENT="No-Cache">
<LINK rel="stylesheet" type="text/css" href="erpw/erpw.css">
<link href="css.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="flashOpen.js"></script> 
<SCRIPT SRC="erpw/comm_function/comm_function.js"></SCRIPT> 
<SCRIPT SRC="erpw/comm_function/evcsp.js"></SCRIPT> 
<Style>
	td {font-size: 12px; color : #666666 ; font-family:"돋움,Verdana, Arial" ; text-decoration:none; line-height:16px; }
	.login {color:#ffffff;font-size:8pt;font-style:돋움;}
	.input {border:1 solid #6CB9D2; width:92px; height:19px; background-color:#4FA6C2;color:#ffffff;font-size:8pt;font-style:돋움;}
	.notice:link {font-family:돋움; text-decoration:none; font-size:9pt; color:#999999;}
	.notice:visited {font-family:돋움; text-decoration:none; font-size:9pt; color:#999999;}
	.notice:hover {font-family:돋움; text-decoration:none; font-size:9pt; color:#4E93CD;}
</Style>

<SCRIPT SRC="erpw/comm_function/comm_wid.js"></SCRIPT>
<SCRIPT language=JavaScript>
	var gs_home = '/eproq/erpw' 
	var is_user_id
	var is_ds_1_addr = 'm_business_user_login_1q.jsp?arg_user_id='
	var is_open_type = "1"
	var is_sso=0
	var gjPopup;
</SCRIPT>

<!-- ======================================================================= -->
<!--                                 Function                                -->
<!-- ======================================================================= -->
<SCRIPT language=JavaScript>
//----------------------------------------------------------------
function bt_confirm_onclick()
//----------------------------------------------------------------
{	
	  var is_user_id, is_user_pwd;
	  
    clearCookie();   
  	is_user_id  = f_check_illegal_input(tb_user_id.value);
  	is_user_pwd = f_check_illegal_input(tb_password.value);
  	
		if (is_user_id == '') {
			alert('아이디를 입력하세요!')
			return
		}
		if (is_user_pwd == '') {
			alert('비밀번호를 입력하세요!')
			return
		}  	
 	
  	ds_1.DataID= is_ds_1_addr + is_user_id + '&arg_password=' + is_user_pwd;
  	ds_1.SyncLoad = true;
  	ds_1.reset();

  	if  (ds_1.CountRow == 0){
     	login_status('1');
     	login_log("LOGIN_ERR","로그인 실패")
     	alert("아이디 혹은 비밀번호가 틀렸습니다. (귀하의 ip address가 기록되었습니다)");
     	return;
  	} 

  	if (ds_1.NameValue(1,"err_count") >= 6){
  		alert("비밀번호를 6회이상 틀려 비밀번호를 변경해야 됩니다.\n비밀번호를 변경하고 로그인 하시기 바랍니다.");
  		return;
  	}

  	if (ds_1.NameValue(1,"pwd_search_yn") == "Y"){
  		alert("비밀번호를 " + ds_1.NameValue(1,"pwd_search_dt") + " 확인했습니다.\n비밀번호 확인하면 반드시 비밀번호를 변경해야 됩니다.\n 비밀번호를 변경하고 로그인 하시기 바랍니다.");
  		return;  	
  	}

  	if (!C_isPwdCheckAlert(is_user_pwd,is_user_id,ds_1.NameValue(1,"businessman_number"))){
  		//alert("<font color=blue>현재 설정된 비밀번호가 정책에 위배됩니다</font>.\n새로운 비밀번호로 변경 후 이용하시기 바랍니다.\n\n" + PWD_MSG);
  		C_msgOk("<font color=blue>현재 사용중인 비밀번호가 정책에 위배됩니다</font>.<br>새로운 비밀번호로 변경 후 이용하시기 바랍니다.<br><br>" + PWD_MSG,"비밀번호 정책 확인");
  		return;
  	}
    is_userid = ds_1.NameValue(1,'user_code');
    is_userpassword = ds_1.NameValue(1,'password');

		login_log("LOGIN","로그인");
    f_real_ok();           
}
//---------------------------------------------------------------------
function user_rtn()               //신규등록
//---------------------------------------------------------------------
{
	var parm;
	window.showModalDialog("./b2b_user_id.html" ,parm,"dialogWidth:"+780+"px; dialogHeight:"+610+"px; status:no; help:no; scroll:no");
}
//---------------------------------------------------------------------
function chg_password()               //비밀번호변경
//---------------------------------------------------------------------
{
	var parm;
	window.showModalDialog("./b2b_chg_password.html" ,parm,"dialogWidth:"+780+"px; dialogHeight:"+760+"px; status:no; help:no; scroll:no");
}
//---------------------------------------------------------------------
function search_id()               //ID 찾기
//---------------------------------------------------------------------
{
	var parm;
	window.showModalDialog("./b2b_search_id.html" ,parm,"dialogWidth:"+515+"px; dialogHeight:"+460+"px; status:no; help:no; scroll:no");
}
//---------------------------------------------------------------------
function search_password()               //비밀번호찾기
//---------------------------------------------------------------------
{
	var parm;
	window.showModalDialog("./b2b_search_password.html" ,parm,"dialogWidth:"+615+"px; dialogHeight:"+460+"px; status:no; help:no; scroll:no");
}
//---------------------------------------------------------------------
function init_password()               //비밀번호 초기화
//---------------------------------------------------------------------
{
	var parm;
	//window.showModalDialog("./b2b_init_password.html" ,parm,"dialogWidth:"+615+"px; dialogHeight:"+460+"px; status:no; help:no; scroll:no");
	//window.showModalDialog("./b2b_chg_password_ock.html" ,parm,"dialogWidth:"+780+"px; dialogHeight:"+760+"px; status:no; help:no; scroll:no");
	window.showModalDialog("./b2b_user_id_ock.html" ,parm,"dialogWidth:"+780+"px; dialogHeight:"+610+"px; status:no; help:no; scroll:no");
}
//---------------------------------------------------------------------
function open_page()               //공지사항
//---------------------------------------------------------------------
{
	window.showModalDialog("./open_page_frame.html" ,"","dialogWidth:500px; dialogHeight:500px; resizable:no; resizable:no;");
}

//---------------------------------------------------------------------
function open_show(list_s)               //공지사항
//---------------------------------------------------------------------
{
	window.showModalDialog("./open_page_frame2.jsp?list_seq="+list_s ,"","dialogWidth:500px; dialogHeight:500px; resizable:no; resizable:no;");
}
//---------------------------------------------------------------------
function charge_rtn()               //담당자연락처
//---------------------------------------------------------------------
{
	//var parm;

   //window.showModalDialog("./b2b_charge_tel.html" ,parm,"dialogWidth:"+550+"px; dialogHeight:"+420+"px");
	
}
//---------------------------------------------------------------------
function cert_rtn()               //공인인증서
//---------------------------------------------------------------------
{
	var window_left = (screen.width-940)/2; 
	var window_top = (screen.height-800)/2; 
	var certNew = window.open("http://www.tradesign.net/certification/new/cjencRegPay.jsp",'certnew','scrollbars=yes,status=yes,resizable=yes,width=940,height=800,top=' + window_top + ',left=' + window_left + '' );
}

//http://www.tradesign.net/certification/new/cjencRegPay.jsp--> (공인증서 프로그램 교체로 인해 업체 변경)(2012.02.07)
//http://www.tradesign.net/certification/new/cjdevRegPay.html --> 변경 (7만원 할인가 링크로 변경)(2010.03.24)

//---------------------------------------------------------------------
function plan1_rtn()               //협력업체등록절차
//---------------------------------------------------------------------
{
	//alert("협력업체 등록절차를 준비하고 입니다. 조속히 공지하도록 하겠습니다.");
}
//---------------------------------------------------------------------
function plan2_rtn()               //전자조달절차
//---------------------------------------------------------------------
{
	//var parm;

    //window.showModalDialog("./cjuser.html" ,parm,"dialogWidth:"+815+"px; dialogHeight:"+610+"px");
}
//---------------------------------------------------------------------
function home_rtn()               //홈페이지가기
//---------------------------------------------------------------------
{
	var ls_wi = screen.width; 
	var ls_he = screen.height; 
	var certNew = window.open("http://www.cjdev.co.kr" );
}
//----------------------------------------------------------------
function f_real_ok()
//----------------------------------------------------------------
{
	makeCookie("@user_code@",is_userid) 
	makeCookie("@password@",is_userpassword)  
	makeCookie("@gs_home@",gs_home)

	makeCookie("@sbcr_code@",ds_1.NameValue(1,"sbcr_code"))
	makeCookie("@vender_code@",ds_1.NameValue(1,"vender_code"))
	makeCookie("@businessman_number@",ds_1.NameValue(1,"businessman_number"))
	makeCookie("@gubun@",ds_1.NameValue(1,"gubun"))
	makeCookie("@sbcr_name@",ds_1.NameValue(1,"sbcr_name"))
   ls_bb = readCookie("JSESSIONID")
   makeCookie("@JFLAG@",ls_bb)
//old             document.links[0].href='javascript:window.open("http://192.168.1.3erpw/const/c_web/picture/cantavil.wmv")'
//new             document.links[0].href="http://192.168.1.3erpw/const/c_web/picture/cantavil.wmv"
//            location.href("main.html")
   ll_height = screen.availHeight  -  40
   ll_width  = screen.availWidth // - 10
//		window.open("main.html","","height="+screen.availHeight+",width="+screen.availWidth+",left=0,top=0,scrollbars=1, resizable=0, status=1"); 
  if (is_open_type == "1")
	window.open("/eproq/erpw/const/b2b_web/00/main.html","","height="+ll_height+",width="+ll_width+",left=0,top=0,scrollbars=1, resizable=1, status=0"); 
  else 
	window.open("/eproq/erpw/const/b2b_web/00/main.html","","left=0,top=0,scrollbars=1, resizable=1, status=0")
	is_open_type = 1  
	if (is_sso != '') {
       self.opener=self;
       self.close();
	 }
   
//  self.opener=self;
//  self.close();
    
  
}
//----------------------------------------------------------------
function click_event(e)
//----------------------------------------------------------------
{
 if (e.keyCode == 113) {
    is_open_type = 2
    bt_confirm_onclick()
     
 }   
}
//----------------------------------------------------------
function inkeyDown()  
//----------------------------------------------------------
{
	if (window.event.keyCode == 13) { 
		bt_confirm_onclick()
	} 
}
//----------------------------------------------------------------
function login_status(log_status)
//----------------------------------------------------------------
{

//    login status    기록 시작.......................
      ds_ip.DataID = gs_home+'/login/login_ipaddr_login.jsp'           // ip addr 얻기.
      ds_ip.SyncLoad = true
      ds_ip.reset()                              // "ip_addr" 방에 ip주소가 있슴. 
      ds_select.DataID = gs_home+'/login/z_sysdate_mi_seq_1q.jsp'           // system date
      ds_select.SyncLoad = true
      ds_select.reset()                         
      ds_login_status.DataID = gs_home+'/login/m_login_status_1q.jsp?arg_seq_key=0'
      ds_login_status.SyncLoad=true
      ds_login_status.reset() 
      ds_login_status.AddRow()
      
      ds_login_status.NameValue(ds_login_status.RowPosition,"ip_address") = ds_ip.NameValue(1,"ip_addr")
      ds_login_status.NameValue(ds_login_status.RowPosition,"start_time") = ds_select.NameValue(1,"sysdate1")
      ds_seq.DataID = gs_home + '/login/m_unq_num_1q.jsp'
      ds_seq.SyncLoad=true;             // seq no 구하기
      ds_seq.reset()
      
      ds_login_status.NameValue(ds_login_status.RowPosition,"seq_key") = ds_seq.NameValue(1,"nextval") 
      ds_login_status.NameValue(ds_login_status.RowPosition,"log_tag") = '1'
      ds_login_status.NameValue(ds_login_status.RowPosition,"user_id") = tb_user_id.value     
      ds_login_status.NameValue(ds_login_status.RowPosition,"empno") = tb_user_id.value     
      ds_login_status.NameValue(ds_login_status.RowPosition,"name") = tb_password.value
      if  (log_status == '1') 
          ds_login_status.NameValue(ds_login_status.RowPosition,"remarks") = 'user-id/password 틀림 '
      else
          ds_login_status.NameValue(ds_login_status.RowPosition,"remarks") = 'password가 틀림(name에 기록된) '
          
      if (ds_login_status.IsUpdated) {
         tr_1.Action = gs_home + '/login/m_login_status_1tr.jsp'
         tr_1.Post()
      }
}

/*
	로그인 로그 저장
*/
function login_log(log_tag, ag_remarks)
{
	    ds_login_log.DataID = gs_home+'/login/login_log_1q.jsp?arg_seq_key=0';
      ds_login_log.SyncLoad=true;
      ds_login_log.reset() ;
      ds_login_log.AddRow();

      ds_login_log.NameValue(ds_login_log.RowPosition,"log_tag") = log_tag;
      ds_login_log.NameValue(ds_login_log.RowPosition,"businessman_number") = ds_1.NameValue(1,"businessman_number")  ;  
      ds_login_log.NameValue(ds_login_log.RowPosition,"user_code") = tb_user_id.value   ;
      ds_login_log.NameValue(ds_login_log.RowPosition,"remarks") = ag_remarks;
          
      if (ds_login_log.IsUpdated) {
         tr_2.Action = gs_home + '/login/login_log_1tr.jsp';
         tr_2.Post();
      }
}



//----------------------------------------------------------------
function window_onload()
//----------------------------------------------------------------
{
  var i
  is_sso = this.location.href
  i = is_sso.lastIndexOf("?sessionkey=")

  if (i > 0) {
     is_sso = is_sso.substr(i + 12,20)
  }   
  else   
     is_sso=''
     
//window.open("/eproq/erpw/const/b2b_web/00/POPUP.html")    
// window.open("/eproq/erpw/const/b2b_web/00/POPUP.html" "dialogWidth:"+550+"px; dialogHeight:"+420+"px");
//window.open("/eproq/erpw/const/b2b_web/00/popup.html", "로그인 안될시 조치사항", "status=yes, resizable=no, top=100, left=250, width=450, height=360");
// 2016.11.23 [기획관리팀 김영훈] 스크립트 오류 해결 _ 팝업 정상 출력]
	var result = getCookie('cname');
	if (result == 'gonggi') {
      return false;
	}
	else {
	   if(gjPopup)return;
	   gjPopup = window.open("/eproq/erpw/const/b2b_web/00/popup.html","gongji","height="+820+",width="+520+",left=250,top=100,scrollbars=0, resizable=1, status=0"); 
	   gjPopup.focus();	// 2016.11.25 [기획전략팀 김영훈] 팝업창   
	}
}
//PKI설치

function getCookie(sName) {
 var value = "";
 var aCookie = document.cookie.split("; ");
 for(var i=0; i<aCookie.length; i++)
 {
  var tCookie = aCookie[i].split("=");
  if(sName==tCookie[0]) value = unescape(tCookie[1]);
 }
 if(value=='undefined') value = "";
 return value;
} 



</SCRIPT>




<!-- ======================================================================= -->
<!--                                   Event                                 -->
<!-- ======================================================================= -->
<SCRIPT language=JavaScript for=ds_login_status event=OnLoadError()>
  alert("Error Code(ds_login_status) : " + ds_login_status.ErrorCode + "\n" + "Error Message : " + ds_login_status.ErrorMsg + "\n");
</SCRIPT>
<SCRIPT language=JavaScript for=ds_login_log event=OnLoadError()>
  alert("Error Code(ds_login_log) : " + ds_login_log.ErrorCode + "\n" + "Error Message : " + ds_login_log.ErrorMsg + "\n");
</SCRIPT>
<SCRIPT language=JavaScript for=tr_1 event=OnFail()>
  alert("Error Code(tr_1) : " + tr_1.ErrorCode + "\n" + "Error Message : " + tr_1.ErrorMsg + "\n");
</SCRIPT>
<SCRIPT language=JavaScript for=tr_2 event=OnFail()>
  alert("Error Code(tr_2) : " + tr_2.ErrorCode + "\n" + "Error Message : " + tr_2.ErrorMsg + "\n");
</SCRIPT>
<SCRIPT language=JavaScript for=ds_ip event=OnLoadError()>
  alert("Error Code(ds_ip) : " + ds_ip.ErrorCode + "\n" + "Error Message : " + ds_ip.ErrorMsg + "\n");
</SCRIPT>
<SCRIPT language=JavaScript for=ds_select event=OnLoadError()>
  alert("Error Code(ds_select) : " + ds_select.ErrorCode + "\n" + "Error Message : " + ds_select.ErrorMsg + "\n");
</SCRIPT>
<SCRIPT language=JavaScript for=ds_1 event=OnLoadError()>
  alert("Error Code(ds_1) : " + ds_1.ErrorCode + "\n" + "Error Message : " + ds_1.ErrorMsg + "\n");
</SCRIPT>
<script language=JavaScript for=ManagerEx event=OnUpdateCompleted()>
is_com_flg = true
</script>

<!-- ======================================================================= -->
<!--                                 Component                               -->
<!-- ======================================================================= -->

<comment id="__NSID__"><OBJECT id=ds_1 
    classid=clsid:3267EA0D-B5D8-11D2-A4F9-00608CEBEE49 VIEWASTEXT>
	<PARAM NAME="DataID" VALUE="">
	<PARAM NAME="CacheLoad" VALUE="0"></OBJECT></comment> <script> __ws__(__NSID__);</script>

<comment id="__NSID__"><OBJECT id=ds_ip 
    style="Z-INDEX: 101; LEFT: 300px; POSITION: absolute; parent: 20px" 
    classid=clsid:3267EA0D-B5D8-11D2-A4F9-00608CEBEE49 VIEWASTEXT>
	<PARAM NAME="DataID" VALUE=""></OBJECT></comment> <script> __ws__(__NSID__);</script>	

<comment id="__NSID__"><OBJECT id=ds_login_status 
    style="Z-INDEX: 101; LEFT: 300px; POSITION: absolute; parent: 20px" 
    classid=clsid:3267EA0D-B5D8-11D2-A4F9-00608CEBEE49 VIEWASTEXT>
	<PARAM NAME="DataID" VALUE=""></OBJECT></comment> <script> __ws__(__NSID__);</script>	
		
<comment id="__NSID__"><OBJECT id=ds_login_log 
    style="Z-INDEX: 101; LEFT: 300px; POSITION: absolute; parent: 20px" 
    classid=clsid:3267EA0D-B5D8-11D2-A4F9-00608CEBEE49 VIEWASTEXT>
	<PARAM NAME="DataID" VALUE=""></OBJECT></comment> <script> __ws__(__NSID__);</script>			

<comment id="__NSID__"><OBJECT id=ds_select 
    style="Z-INDEX: 101; LEFT: 300px; POSITION: absolute; parent: 20px" 
    classid=clsid:3267EA0D-B5D8-11D2-A4F9-00608CEBEE49 VIEWASTEXT>
	<PARAM NAME="DataID" VALUE=""></OBJECT></comment> <script> __ws__(__NSID__);</script>	
	
<comment id="__NSID__"><OBJECT id=ds_seq 
    style="Z-INDEX: 101; LEFT: 300px; POSITION: absolute; parent: 20px" 
    classid=clsid:3267EA0D-B5D8-11D2-A4F9-00608CEBEE49 VIEWASTEXT>
	<PARAM NAME="DataID" VALUE=""></OBJECT></comment> <script> __ws__(__NSID__);</script>	
	

<comment id="__NSID__"><OBJECT id=tr_1 
    style="Z-INDEX: 103; LEFT: 477px; POSITION: absolute; TOP: 2px" 
    classid=clsid:0A2233AD-E771-11D2-973D-00104B15E56F VIEWASTEXT>
	<PARAM NAME="KeyName" VALUE="toinb_dataid4">
	<PARAM NAME="KeyValue" VALUE="JSP(I:m_login_status_1tr=ds_login_status)">
	<PARAM NAME="Protocol" VALUE="1"></OBJECT></comment> <script> __ws__(__NSID__);</script>
		
<comment id="__NSID__"><OBJECT id=tr_2
    style="Z-INDEX: 103; LEFT: 477px; POSITION: absolute; TOP: 2px" 
    classid=clsid:0A2233AD-E771-11D2-973D-00104B15E56F VIEWASTEXT>
	<PARAM NAME="KeyName" VALUE="toinb_dataid4">
	<PARAM NAME="KeyValue" VALUE="JSP(I:login_log_1tr=ds_login_log)">
	<PARAM NAME="Protocol" VALUE="1"></OBJECT></comment> <script> __ws__(__NSID__);</script>		
	
</HEAD>

<!-- ======================================================================= -->
<!--                                   Body                                  -->
<!-- ======================================================================= -->
<BODY id=body_main style="margin: 0px"  onload=window_onload() oncontextmenu="return false" onkeydown="click_event(event)">

<!--<OBJECT ID="PKI" CLASSID="CLSID:5157ABA6-E138-404B-BFA9-FC42244EFB93" width=0 height=0 codebase="erpw/install/evali/EVCSP.cab#version=3,1,0,3"></OBJECT>-->
<OBJECT ID=PKI CLASSID=CLSID:5157ABA6-E138-404B-BFA9-FC42244EFB93 width=0 height=0 codebase="erpw/install/evali/EVCSP.cab#version=3,2,3,8"></OBJECT>
<!--인증서 고도화로 인한 버젼 업 인스톨 파일 설치로 변경-->


<div id=main_menu style="Z-INDEX: 100; top: 30px; left: 800px; position:absolute;"> 
<table cellpadding="0" cellspacing="0" border="0">
	<form method="get" name="nvloc">
<!--
	<tr>
		<td><img src="./erpw/image/familysite.gif"></td>
		<td> <script src="./select_double.js" type="text/javascript"></script></td>
		<td width="3"></td>
		<td><a href="#"><img border="0" class="" src="./erpw/image/btn_go.gif" alt="go" width="19" height="19"  onclick=home_rtn()></a></td> 
	</tr>
-->
	</form>
</table>
</div>

<table width="1000" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="middle" ><img src="./erpw/image/cj/logo.png" width="125" height="57" /><img src="./erpw/image/cj/home.gif" width="110" height="19"onclick=home_rtn() /></td> 
  </tr>
	
	<tr>
		<td height="244">
			<table width="1000" border="0" cellpadding="0" cellspacing="0">
			<tr> 
				<td width="732" colspan=2><script>flashObj('./erpw/image/cj/text.swf','732','244', 'menu')</script> 	</td> 
				<td width="292" height="244" valign="top" align="left" background="./erpw/image/cj/login_img.gif">
							<!-- 로그인 -->
						<table style="Z-INDEX: 100; LEFT: 820px; TOP:110px; POSITION: absolute;style="BORDER-RIGHT: 2px; BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM:0px;" borderColor=#ffffff width="165" cellpadding="0" cellspacing="0">
							<tr>
								<td colspan="4" ><img src="./erpw/image/title_login.gif"></td> 
							</tr>
							<Tr>
								<Td colspan="4" bgcolor="#2388A8" height="0"></TD>
							</TR>
							<Tr >
								<Td width="54" height="19" bgcolor="#2388A8" align="right" class="login">아이디</TD>
								<td width="5" bgcolor="#2388A8">
								</td>
								<td width="92" bgcolor="#2388A8"><input id=tb_user_id type="text" class="input" onkeypress="if(event.keyCode==13){ bt_confirm_onclick();}"></td>
								<td width="13" bgcolor="#2388A8"></td>
							</TR>
							<Tr>
								<Td colspan="4" height="6" bgcolor="#2388A8"></TD>
							</TR>
							<Tr>
								<Td width="54" height="19" bgcolor="#2388A8" align="right" class="login">비밀번호</TD>
								<td width="5" bgcolor="#2388A8"></td>
								<td width="92" bgcolor="#2388A8"><input id=tb_password type="password" class="input" onkeypress="if(event.keyCode==13){ bt_confirm_onclick();}"></td>
								<td width="13" bgcolor="#2388A8"></td>
							</TR>
							<Tr>
								<Td colspan="4" height="0" bgcolor="#2388A8"></TD>
							</TR>
							<Tr>
								<Td width="54" height="0" bgcolor="#2388A8"></TD>
								<td width="5" bgcolor="#2388A8"></td>
								<td width="92" bgcolor="#2388A8" align="right"><a href="#"><img src="./erpw/image/btn_login.gif" border="0" onclick=bt_confirm_onclick()></a></td>
								<td width="0" bgcolor="#2388A8"></td>
							</TR>
							<tr>
								<td colspan="4"><img src="./erpw/image/bot_login.gif"></td>  
							</tr>
						</table>
					<!-- 로그인 -->
					<!-- 버튼 -->
						<table style="Z-INDEX: 100; LEFT: 820px; POSITION: absolute; TOP:260px;" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td colspan="3" height="2"></td>
							</tr>
							<tr>
								<td><a href="#"><img src="./erpw/image/cj/login_id.gif" border="0" onclick=user_rtn()></a></td>
								<td width="7"></td>
								<td><a href="#"><img src="./erpw/image/cj/login_pw.gif" border="0" onclick=chg_password()></a></td>
							</tr>
								<td colspan=3 height="5"></td>
							<tr>
							</tr>
							<tr>
								<td colspan="3">
									  <font color="blue"><a onclick="search_id();" style=" cursor:hand;">아이디</a> / <a onclick="search_password();" style=" cursor:hand;">비밀번호찾기</a> <a onclick="init_password();" style="cursor:hand;"> /</a></font>
								</td>
							</tr>		
                            <tr height=10px ><td colspan="4"><A HREF="http://at2010.cj.net:8001/eproq">프로그램 재설치</A></td></tr>
						</table>

					<!-- 버튼 -->
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="3"  width="1000" bgcolor="#A6A6A6"></TD>
	</tr>
	<tr>
		<td height="20px"></td>
	</tr>



</table>

<table width="1000" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td  align="center">
			<!-- 로그인 및 컨텐츠 -->
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="130"><a href="#"><img src="./erpw/image/cj/login_bg.gif" border="0"></a></td>
						<td width="36"></td> 
						<td width="350" valign="top">
							<!-- 공지사항 -->
								<table cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td height="10px"></td>
									</tr>
									<tr>
										<td><img src="./erpw/image/title_news.gif"><img src="./erpw/image/more_news.gif" border="0" style=" cursor:hand;" onclick=open_page()></td>
									</tr>
									<tr>
										<td height="10px"></td>
									</tr>
									<tr>
										<Td>
											<table cellpadding="0" cellspacing="0" border="0" >
												<% 
												String r_title;
												int i = 0;	
												int list_seq;
																							
												while (i < 2) { 
													if (rs.next()) {
													r_title = rs.getString(3);	
													
													if (r_title.equals("")) {%>
														<tr>
															<td></td>
														</tr>
													<%}
													list_seq = rs.getInt(2);
													%>
												<tr>
													<td width="16" height="24" align="center"><img src="./erpw/image/b_1.gif"></td>
													<td width="306" align="left"><a  href='#' onclick=open_show(<%= list_seq %>) class="notice"><%= r_title %></a></td>
												</tr>
												<% 
													i++;
													}
													else {
														break;
													} 
												}
												%>
											</table>
										</TD>
									</tr>
								</table>
							<!-- 공지사항 -->
						</td>
						<td width="33"></td>
						<td width="350" valign="top">
							<!-- 가이드 -->
							<table cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td height="10px"></td>
									</tr>
									<tr>
										<td><img src="./erpw/image/title_guide.gif"><img src="./erpw/image/more_guide.gif" border="0"></td>
									</tr>
									<tr>
										<td height="21"></td>
									</tr>
									<tr>
										<Td align="center">
											<table cellpadding="0" cellspacing="0" border="0">
												<tr>
													<Td>
														<!--<a onfocus="this.blur()" href="./insert_inform.html" target="_blank"><img src="./erpw/image/btn_1.gif" border="0" onclick=plan1_rtn()></a>-->
														<a onfocus="this.blur()" href="./cjuser.html" target="_blank"><img src="./erpw/image/btn_1.gif" style=" cursor:hand;" border="0" onclick=plan1_rtn()></a>
														</TD>
													<td width="18"></td>
													<td><a onfocus="this.blur()"href="./cjuser.html" target="_blank" ><img src="./erpw/image/btn_2.gif" style=" cursor:hand;" border="0" onclick=plan2_rtn()></a></td>
												</tr>
												<tr>
													<Td colspan="3" height="14"></td>
												</tr>
												<tr>
													<Td><a onfocus="this.blur()" target="_blank"><img src="./erpw/image/btn_3.gif" style=" cursor:hand;" border="0" onclick=cert_rtn()></a></TD>
													<td width="18"></td>
													<td><a onfocus="this.blur()" href="./b2b_charge_tel.html" target="_blank"><img src="./erpw/image/btn_4.gif" border="0" onclick=charge_rtn()></a></td>
												</tr>
											</table>
										</TD>
									</tr>
								</table>
							<!-- 가이드 -->
						</td>
					</tr>
				</table>
			<!-- 로그인 및 컨텐츠 -->
		</td>
	</tr>
	<tr>
		<td height="20px" ></td>
	</tr>
	<tr>
		<td height="49" bgcolor="#F0F0F0" align="right" valign="top" >
			<!-- 카피라이트 -->
			<img src="./erpw/image/copyright_1.gif">
			<!-- 카피라이트 -->
		</td>
	</tr>
</table>
 <comment id="__NSID__">	
	<OBJECT ID="ManagerEx" CLASSID="CLSID:7A868592-7D06-44CF-ADF1-EF7517BD8F3A" codebase="./erpw/install/ManagerEx4.cab#version=4,0,3,7">		
	<param name=XMLUrl value="./erpw/install/Install.zip">
	<param name="HangRecovery"		value="True">
	<param name=SaveXML value="true">		
	</OBJECT></comment> <script> __ws__(__NSID__);</script>
</BODY></HTML>
<%@ include file="b2b_login_file_2q.jsp" %>