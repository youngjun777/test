<%@ page session="true" import="com.gauce.*,com.gauce.io.*,com.gauce.common.*,com.gauce.log.*,com.gauce.db.*,java.sql.*,javax.sql.*,javax.naming.*" contentType="text/html; charset=euc-kr"%>
<%  InitialContext ic = null;
	DataSource ds = null;
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String query = null;
	
	try {
		ic = new InitialContext();
	  	ds = (DataSource)ic.lookup("jdbc/OracleDS");
     	conn = ds.getConnection();
     	stmt = conn.createStatement();
     	
     	query = " Select a.work_dt,	" +
		"		  				a.seq, 	" +
		"						a.title,	" +
		"						a.summary,	" +
		"						a.bigo	" +
		"			 	From z_open_title a	" +
		"				Order by a.work_dt desc,	" +
		"							a.seq desc	"; 
												
		rs = stmt.executeQuery(query);
%>