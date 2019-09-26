package com.cj.database;

import java.sql.*;
import java.math.*;
import java.io.*;

import com.cj.common.*;
import com.cj.util.*;

/*���� ����Ÿ���̽� ���� Ŭ����*/
public class CITDatabase
{
	//public static final String DEFAULT_DATA_SOURCE = "jdbc/OracleDS";
	
	private static final String JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver";
	//private static final String JDBC_PROTOCOL = "jdbc:oracle:thin:";
	//private static final String DATABASE_HOST = "222.106.77.121";
	//private static final String DATABASE_PORT = "1521";
	//private static final String DATABASE_SID = "DONGRIM";
	//private static final String DATABASE_USER = "app";
	//private static final String DATABASE_PASSWORD = "app";
	
	public static final String DATA_SOURCE_KEY = "datasource_name";
	public static final String DATABASE_INFO_KEY = "database_user";

	public CITDatabase()
	{
	}

	public static void main(String[] args) throws Exception
	{
		/*
		CITData lrData = null;
		CITData argData = new CITData();
		String strSql = "";
		
		strSql = "Select * ";
        strSql += "From  PTZ_USER ";
    	
		lrData = CITDatabase.selectQuery(strSql, new CITData(), CITConnectionManager.getConnection("hsm001"));
		System.out.println(CITXml.CITData2XML(lrData));
		
		strSql = "{? = call PFZ_NUM_FM(?,?)}";
		
		argData.addColumn("RETURN", CITData.VARCHAR2, true);
		argData.addColumn("AV_DATA", CITData.VARCHAR2, false);
		argData.addColumn("AV_FM", CITData.VARCHAR2, false);
		argData.addRow();
		argData.setValue("AV_DATA", "123456789");
		argData.setValue("AV_FM", "xxx-xx-xxx-x");
		
		executeProcedure(strSql, argData);
		
		System.out.println(CITXml.CITData2XML(lrData));
		*/
	}
	
	public static String getDataSourceName() throws Exception
	{
		String lsDataSourceName = CITCommon.getProperty(DATA_SOURCE_KEY);
		if (CITCommon.isNull(lsDataSourceName)) throw new Exception ("CITDatabase getDataSourceName Error : DataSource���� ��(Null)�Դϴ�.");
		return lsDataSourceName;
	}
	
	public static String [] getDatabaseInfo() throws Exception
	{
		// Database Info : User*Password*URL �� ����
		String lsDatabaseInfo = CITCommon.getProperty(DATABASE_INFO_KEY);
		String [] lsInfo = null;
		
		if (CITCommon.isNull(lsDatabaseInfo)) throw new Exception ("CITDatabase getDatabaseInfo Error : Database Info�� ��(Null)�Դϴ�.");
		
		lsInfo = lsDatabaseInfo.replace('*', '!').split("!");
		
		if (lsInfo == null || lsInfo.length != 3) throw new Exception ("CITDatabase getDatabaseInfo Error : Database Info�� ������ �ùٸ��� �ʽ��ϴ�.");
		
		return lsInfo;
	}
	
	/*JDBC Dirver*/
	public static String getDriver() throws Exception
	{
		//return getDriver(DEFAULT_DATA_SOURCE);
		return JDBC_DRIVER;
	}
	
	public static String getDriver(String asDataSource) throws Exception
	{
		//return CITCommon.getProperty(asDataSource + ".driver");
		return JDBC_DRIVER;
	}
	
	/*JDBC URL*/
	public static String getURL() throws Exception
	{
		//return getURL(DEFAULT_DATA_SOURCE);
		return getDatabaseInfo()[2];
	}
	
	public static String getURL(String asDataSource) throws Exception
	{
		//return CITCommon.getProperty(asDataSource + ".url");
		//return JDBC_PROTOCOL + "@" + DATABASE_HOST + ":" + DATABASE_PORT + ":" + DATABASE_SID;
		return getDatabaseInfo()[2];
	}
	
	/*Database Connect User*/
	public static String getUser() throws Exception
	{
		//return getUser(DEFAULT_DATA_SOURCE);
		return getDatabaseInfo()[0];
	}
	
	public static String getUser(String asDataSource) throws Exception
	{
		//return CITCommon.getProperty(asDataSource + ".user");
		//return DATABASE_USER;
		return getDatabaseInfo()[0];
	}
	
	/*Database Connect Password*/
	public static String getPassword() throws Exception
	{
		//return getPassword(DEFAULT_DATA_SOURCE);
		return getDatabaseInfo()[1];
	}
	
	public static String getPassword(String asDataSource) throws Exception
	{
		//return CITCommon.getProperty(asDataSource + ".password");
		//return DATABASE_PASSWORD;
		return getDatabaseInfo()[1];
	}

	public static long getAutoTableSeq(String asTableName) throws SQLException
	{
		Connection conn = null;
		CallableStatement callstat = null;
		long lngPNo = Long.MIN_VALUE;
		
		if (asTableName == null || asTableName .trim() == "") throw new SQLException ("CITDatabase getAutoTableSeq Error : ���̺���� ��(null)�Դϴ�");
		
		try
		{
			conn = CITConnectionManager.getConnection();
			
			if (!conn.getAutoCommit()) conn.setAutoCommit(true);
			
			callstat = conn.prepareCall("{call PPZ_INSERT_SEQ(?,?)}");
			
			callstat.setString(1, asTableName);
        	callstat.registerOutParameter(2, Types.DECIMAL);
        	callstat.execute();
        	
        	lngPNo = callstat.getLong(2);
		}
		catch (Exception ex)
		{
			throw new SQLException (ex.getMessage());
		}
		finally
		{
			if (callstat != null) callstat.close();
			CITConnectionManager.freeConnection(conn);
		}
		
		return lngPNo;
	}
	
	public static void executeProcedure(String asQuery, CITData aData) throws Exception
	{
		Connection conn = null;
		CITData lrData = null;
		
		try
		{
			conn = CITConnectionManager.getConnection(true);
			executeProcedure(asQuery, aData, conn);
		}
		catch (Exception ex)
		{
			throw new SQLException (ex.getMessage());
		}
		finally
		{
			CITConnectionManager.freeConnection(conn);
		}
	}
	
	public static void executeProcedure(String asQuery, CITData aData, Connection aConnection) throws Exception
	{
		CallableStatement callstat = null;
		
		if (asQuery == null || asQuery .trim() == "") throw new SQLException ("CITDatabase executeProcedure Error : ������ ��(null)�Դϴ�");
		
		try
		{
			callstat = aConnection.prepareCall(asQuery);
			
			setArgument(callstat, aData);
        	callstat.execute();
        	
        	for (int i = 0; i < aData.getColsCount(); i++)
			{
				if (!aData.isOutParameter(i)) continue;
				
				aData.setValue(i, callstat.getObject(i + 1));
			}
		}
		catch (Exception ex)
		{
			throw new Exception ("CITDatabase executeProcedure Error : " + ex.getMessage());
		}
		
		if (callstat != null) callstat.close();
	}
	
	public static CITData selectQuery(String asQuery) throws Exception
	{
		Connection conn = null;
		CITData lrData = null;
		
		try
		{
			conn = CITConnectionManager.getConnection(true);
			lrData = selectQuery(asQuery, conn);
		}
		catch (Exception ex)
		{
			throw new SQLException (ex.getMessage());
		}
		finally
		{
			CITConnectionManager.freeConnection(conn);
		}
		
		return lrData;
	}
	
	public static CITData selectQuery(String asQuery, Connection aConnection) throws Exception
	{
		Statement sm = null;
		ResultSet rs = null;
		CITData lrData = null;
		
		if (asQuery == null || asQuery.trim() == "") throw new Exception ("CITDatabase selectQuery Error : ������ ��(null)�Դϴ�");
		
		try
		{
			sm = aConnection.createStatement();
			rs = sm.executeQuery(asQuery);
		}
		catch (Exception ex)
		{
			throw new Exception ("CITDatabase selectQuery Error : " + ex.getMessage() + "\r\n���� : " + asQuery);
		}

		lrData = createDataObject(rs);
		
		if (rs != null) rs.close();
		if (sm != null) sm.close();
		
		return lrData;
	}
	
	public static CITData selectQuery(String asQuery, CITData aData) throws Exception
	{
		Connection conn = null;
		CITData lrData = null;
		
		try
		{
			conn = CITConnectionManager.getConnection(true);
			lrData = selectQuery(asQuery, aData, conn);
		}
		catch (Exception ex)
		{
			throw new SQLException (ex.getMessage());
		}
		finally
		{
			CITConnectionManager.freeConnection(conn);
		}
		
		return lrData;
	}
	
	public static CITData selectQuery(String asQuery, CITData aData, Connection aConnection) throws Exception
	{
		PreparedStatement ppsm = null;
		ResultSet rs = null;
		CITData lrData = null;
		
		if (asQuery == null || asQuery.trim() == "") throw new Exception ("CITDatabase selectQuery Error : ������ ��(null)�Դϴ�");
		
		try
		{
			ppsm = aConnection.prepareStatement(asQuery);			
			setArgument(ppsm, aData);
			rs = ppsm.executeQuery();
		}
		catch (Exception ex)
		{
			throw new Exception ("CITDatabase selectQuery Error : " + ex.getMessage() + "\r\n���� : " + asQuery);
		}

		lrData = createDataObject(rs);
		
		if (rs != null) rs.close();
		if (ppsm != null) ppsm.close();
		
		return lrData;
	}
	
	public static CITData createDataObject(ResultSet aRs) throws Exception
	{
		if (aRs == null) throw new Exception ("CITDatabase createDataObject Error : ResultSet��(��) ��(null)�Դϴ�");
		
		CITData lrData = new CITData();
		
		lrData.setColumnInfo(aRs.getMetaData());
		
		while (aRs.next())
		{
			lrData.addRow();
			
			for (int i = 0; i < lrData.getColsCount(); i++)
			{
				lrData.setValue(lrData.getColumnName(i), aRs.getObject(lrData.getColumnName(i)));
			}
		}
		
		return lrData;
	}
	
	public static void setArgument(PreparedStatement aPreStatement, CITData aData) throws Exception
	{
		String lsColumnName = null;
		
		try
		{
			if (aData == null) return;
			
			for (int i = 0; i < aData.getColsCount(); i++)
			{
				lsColumnName = aData.getColumnName(i);
				
				if (aData.isOutParameter(i))
				{
					if (aPreStatement instanceof CallableStatement) ((CallableStatement)aPreStatement).registerOutParameter(i + 1, aData.getColumnType(i));
					continue;
				}
				
				if (!aData.isOutParameter(i) && (aData.getValue(0, i) == null || aData.toString(0, i).trim().equals("")))
				{
					aPreStatement.setNull(i + 1, aData.getColumnType(i));
					continue;
				}
				
				if (aData.getColumnType(i) == Types.VARCHAR)            // Types.VARCHAR(12) = Oracle Varchar2
				{
					aPreStatement.setString(i + 1, aData.toString(0, i));
				}
				else if (aData.getColumnType(i) == Types.NUMERIC)       // Types.NUMERIC(2) = Oracle Number
				{
					BigDecimal dec = aData.getValue(0, i) instanceof BigDecimal ? (BigDecimal)aData.getValue(0, i) : new BigDecimal(aData.toString(0, i));
					//aPreStatement.setDouble(i+1,dec.doubleValue());
					//CITDebug.PrintMessages("before dec.toString()");
					//CITDebug.PrintMessages(dec.toString());
					aPreStatement.setBigDecimal(i + 1, dec);
					
				}
				else if (aData.getColumnType(i) == Types.DATE)          // Types.DATE(91) = Oracle DATE(��¥)
				{
					java.sql.Date date;
					
					if (aData.getValue(0, i) instanceof java.sql.Date)
					{
						date = (java.sql.Date)aData.getValue(0, i);
					}
					else if (aData.getValue(0, i) instanceof java.util.Date)
					{
						date = java.sql.Date.valueOf(CITDate.toString((java.util.Date)aData.getValue(0, i), "yyyy-MM-dd"));
					}
					else
					{
						date = java.sql.Date.valueOf(CITDate.toString(CITDate.getDate(aData.toString(0, i)), "yyyy-MM-dd"));
					}
					
					aPreStatement.setDate(i + 1, date);
				}
				else if (aData.getColumnType(i) == Types.TIMESTAMP)          // Types.TIMESTAMP(93) = Oracle DATE(��¥�ð�)
				{
					java.sql.Timestamp date = null;
					
					if (aData.getValue(0, i) instanceof java.sql.Date)
					{
						date = new Timestamp(((java.sql.Date)aData.getValue(0, i)).getTime());
					}
					else if (aData.getValue(0, i) instanceof java.util.Date)
					{
						date = new Timestamp(((java.util.Date)aData.getValue(0, i)).getTime());
					}
					else
					{
						date = new Timestamp(CITDate.getDate(aData.toString(0, i)).getTime());
					}
					
					aPreStatement.setTimestamp(i + 1, date);
				}
				else if (aData.getColumnType(i) == Types.LONGVARCHAR)   // Types.LONGVARCHAR(-1) = Oracle Long
				{
					//aPreStatement.setCharacterStream(i + 1, (Reader)aData.getValue(0, i), Integer.MAX_VALUE);
					aPreStatement.setString(i + 1, aData.toString(0, i));
				}
				else if (aData.getColumnType(i) == Types.LONGVARBINARY) // Types.LONGVARBINARY(-4) = Oracle Long Raw
				{
					aPreStatement.setBinaryStream(i + 1, (InputStream)aData.getValue(0, i), Integer.MAX_VALUE);
				}
				else
				{
					aPreStatement.setNull(i + 1, aData.getColumnType(i));
				}
			}
		}
		catch (Exception ex)
		{
			throw new Exception ("���� ��������([�÷���:" + lsColumnName + "]-" + ex.getMessage() + ")");
		}
	}
	
	public static int updateQuery(String asQuery) throws Exception
	{
		Connection conn = null;
		int intRow = 0;
		
		try
		{
			conn = CITConnectionManager.getConnection(true);
			intRow = updateQuery(asQuery, conn);
		}
		catch (Exception ex)
		{
			throw new SQLException (ex.getMessage());
		}
		finally
		{
			CITConnectionManager.freeConnection(conn);
		}
		
		return intRow;
	}
	
	public static int updateQuery(String asQuery, Connection aConnection) throws Exception
	{
		Statement sm = null;
		int intRow = 0;
		
		if (asQuery == null || asQuery.trim() == "") throw new SQLException ("CITDatabase updateQuery Error : ������ ��(null) �Դϴ�");
		
		try
		{
			sm = aConnection.createStatement();
			intRow = sm.executeUpdate(asQuery);
		}
		catch (Exception ex)
		{
			throw new Exception ("CITDatabase updateQuery Error : " + ex.getMessage() + "\r\n���� : " + asQuery);
		}
		
		if (sm != null) sm.close();
		
		return intRow;
	}
	
	public static int updateQuery(String asQuery, CITData aData) throws Exception
	{
		Connection conn = null;
		int intRow = 0;
		
		try
		{
			conn = CITConnectionManager.getConnection(true);
			intRow = updateQuery(asQuery, aData, conn);
		}
		catch (Exception ex)
		{
			throw new SQLException (ex.getMessage());
		}
		finally
		{
			CITConnectionManager.freeConnection(conn);
		}
		
		return intRow;
	}
	
	public static int updateQuery(String asQuery, CITData aData, Connection aConnection) throws Exception
	{
		PreparedStatement ppsm = null;
		int intRow = 0;
		
		if (asQuery == null || asQuery.trim() == "") throw new SQLException ("CITDatabase updateQuery Error : ������ ��(null) �Դϴ�");
		
		try
		{
			ppsm = aConnection.prepareStatement(asQuery);			
			setArgument(ppsm, aData);
			intRow = ppsm.executeUpdate();
		}
		catch (Exception ex)
		{
			throw new Exception ("CITDatabase updateQuery Error : " + ex.getMessage() + "\r\n���� : " + asQuery);
		}
		
		if (ppsm != null) ppsm.close();
		
		return intRow;
	}
}

