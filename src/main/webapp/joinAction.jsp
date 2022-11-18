<%@page import="user.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 앞서 만들었던 User.DAO의 객체를 사용하기위해 선언 -->
<%@ page import="user.UserDAO" %>
<!-- 자바스크립트 문장을 작성 하기위해 사용하는 내부라이브러리? -->
<%@ page import="java.io.PrintWriter" %>
<!-- 건너오는 모든 데이터를 UTF-8로 받기위해 가져오는것 -->
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 한명의 회원 정보를 담는 전에만든 javaBeans를 사용한다는 것, scope로 현재 페이지에서만 사용을 선언-->
<jsp:useBean id="user" class="user.User" scope="page" /> 
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
<jsp:setProperty name="user" property="lockerNum" />
<jsp:setProperty name="user" property="userAvailable" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP Web Site</title>
</head>
<body>
	<%
		String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID != null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('회원등록이 완료되었습니다.')");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	}
	//입력 안된 부분이 있을 시 회원가입 시에 사용자가 입력을 안한 모든 경우의 수를 입력해서 조건을 걸어주고,
	if (user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null
		|| user.getUserGender() == null || user.getUserEmail() == null || user.getLockerNum() == '0' || user.getUserAvailable() == null) {
		//PrintWriter를 이용해서
		PrintWriter script = response.getWriter();
		script.println("<script>");
		//팝업을 띄워주고,
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		//다시 돌려보낸다.
		script.println("history.back()");
		script.println("</script>");
	//입력이 다 되었다면?
	} else {
		//UserDAO에서 만들었던 함수를 사용하기 위해서 인스턴스 생성
		UserDAO userDAO = new UserDAO();
		//userDAO에 있는 join함수 내의 각각의 변수들을 다입력 받아서 만들어진 user인스턴스가 join함수를 실행하도록 명령으로 넣어준것이다.
		int result = userDAO.join(user);
		//이 경우는 이미 해당아이디가 존재하는 경우밖에 없다. PRIMARY KEY로 userID를 줬기때문에,
		if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 존재하는 아이디입니다.');");
			script.println("history.back()");
			script.println("</script>");
		//정상적인 실행이 되었을때.
		} else {
			//session.setAttribute("userID", user.getUserID());
			PrintWriter script = response.getWriter();
			script.println("<script>");
			//메인페이지로 이동.
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
	}
	%>
</body>
</html>