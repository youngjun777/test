package err_test;

public class JspErrOcure extends Exception{
	
	public static JspErrOcure jspErrOcure = null;
	
	public static JspErrOcure getInstance() {
		if (jspErrOcure == null) {
			jspErrOcure = new JspErrOcure();
		}
		return jspErrOcure;
	}
	
	public static void doErrOcure() throws Exception {
		try {
			String a = "a1";
	//		throw new Exception("err test!!!!");
		}catch (Exception e){
			throw new Exception(e);
		}finally {
			System.out.println("--------finally--------");
		}
	}

}
