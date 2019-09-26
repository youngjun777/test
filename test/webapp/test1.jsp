<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script language=JavaScript>

function fn_leftPadding(str, size, paddingChar)
{
	var rst = "";
    if( str == null || str =='' || str == 'undefined' ) return "x";
	str += "";
	paddingChar += "";
	var strLen = str.length;
	if( size > strLen ) {
	    var icnt = size-strLen;
		for(var i=0; i < icnt; i++) rst += paddingChar;
		rst += str;
	}else{
		rst = str;
	}
	return rst;
}

function fn_run()
{
	var a = 6;
	var b = 12;
	alert( fn_leftPadding(b,2,"0") );	
}

</script>
</head>
<body>

<input type="button" value="test" onclick="fn_run();"></input>

</body>
</html>