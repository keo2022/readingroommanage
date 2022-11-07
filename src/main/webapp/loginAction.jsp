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
<!-- 로그인 페이지에서 넘겨준 user정보를 받아서 한명의 사용자에 데이터에 값을 넣어주는 것 -->
<jsp:setProperty name = "user" property = "userID" />
<!-- 이렇게 하면 loginAction.jsp 안에 넘어온 데이터들이 그대로 담기게 된것이다! -->
<jsp:setProperty name = "user" property = "userPassword" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP Web Site</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if (userID != null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
				
		//이제 넘어온 userID와 PW를 꺼내서 사용해보자. UserDAO인스턴스 생성
		UserDAO userDAO = new UserDAO();
		//UserDAO 에서 만들었던 public int login(userID,userPW)를 넣어주는 것을 변수 result에 담는다.
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		//login함수에서 return값이 1이라면
		if (result == 1){
			session.setAttribute("userID", user.getUserID());
			//하나의 스크립트 문장을 넣어줄 수있도록 한다.
			PrintWriter script = response.getWriter();
			//println으로 접근해서 스크립트 문장을 유동적으로 실행 할 수 있게한다.
			script.println("<script>");
			//메인 페이지로 넘겨주는 선언을 해주고,
			script.println("location.href = 'main.jsp'");
			//스크립트 태그를 닫아준다.
			script.println("</script>");
		}
		//비밀번호가 틀릴때
		else if(result == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			//웹페이지에 팝업을 띄워준다.
			script.println("alert('비밀번호가 틀립니다.');");
			//이 전 페이지로 사용자를 다시 돌려보내는 함수이다.
			script.println("history.back()");
			script.println("</script>");
		}
		//아이디가 없을때
		else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.');");
			script.println("history.back()");
			script.println("</script>");
		}
		//db연결 잘안됬을때
		else if(result == -2){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.');");
			script.println("history.back()");
			script.println("</script>");
		}
		%>
</body>
</html>