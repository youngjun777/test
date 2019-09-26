package err_test;

public class JspErrOcure2{
	
	public static JspErrOcure2 jspErrOcure = null;
	
	public static JspErrOcure2 getInstance() {
		if (jspErrOcure == null) {
			jspErrOcure = new JspErrOcure2();
		}
		return jspErrOcure;
	}

}
