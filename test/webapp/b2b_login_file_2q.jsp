<%@ page session="true" import="com.gauce.*,com.gauce.io.*,com.gauce.common.*,com.gauce.log.*,com.gauce.db.*,java.sql.*,javax.sql.*,javax.naming.*" contentType="text/html; charset=euc-kr"%>
<%
	}
	catch(Exception e){
    // 트랜잭션을 취소합니다.
	   //if ( conn != null ) {
		   //try{
		      conn.rollback();
			  out.println(e.toString());
			// 원래의 값으로 변경합니다.
			  conn.setAutoCommit(true);
		   //}catch(SQLException ex) {}
		//}
   } 
   finally 
   {  
		if(rs!=null){
		   try{
			  rs.close();
		   }catch(SQLException ex){}
		}
		
		if ( stmt != null ){
		   try{
		      stmt.close();
		   }catch(SQLException ex) {}
		}
	
		if ( conn != null ) {
		   try{
		      conn.close();
		   }catch(SQLException ex) {}
		}
   // finally
	} 

%>