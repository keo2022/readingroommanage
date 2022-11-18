<%@page import="user.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 앞서 만들었던 Time.DAO의 객체를 사용하기위해 선언 -->
<%@ page import="time.Time" %>
<%@ page import="time.TimeDAO" %>
<!-- 자바스크립트 문장을 작성 하기위해 사용하는 내부라이브러리? -->
<%@ page import="java.io.PrintWriter" %>
<!-- 건너오는 모든 데이터를 UTF-8로 받기위해 가져오는것 -->
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP Web Site</title>
</head>
<body>
		<%
		String userID = null;
		if (session.getAttribute("userID") != null) {//유저아이디이름으로 세션이 존재하는 회원들은 
			userID = (String) session.getAttribute("userID");//유저아이디에 해당 세션값을 넣어준다.
		}
		//공부시작 같은 경우에는 로그인이 된사람만 가능해야 하기때문에 조건을 걸어준다.
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			//로그인 안된 사람들은 로그인 페이지로 이동하게 만들어주면 된다.
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
			//로그인이 된 사람들은 이쪽으로 넘어가게 해준다.
		}
				
		//TimeDAO인스턴스 생성
		TimeDAO timeDAO = new TimeDAO();
		int result = timeDAO.end(userID);
		//start함수에서 return값이 1이라면
		if (result == 1){
			PrintWriter script = response.getWriter();
			//println으로 접근해서 스크립트 문장을 유동적으로 실행 할 수 있게한다.
			script.println("<script>");
			script.println("alert('공부를 종료합니다.');");
			//데이터 제거 후 팝업창을 닫아준다.
			script.println("window.close();");
			//스크립트 태그를 닫아준다.
			script.println("</script>");
		}
		//오류 발생
		else if(result == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			//웹페이지에 팝업을 띄워준다.
			script.println("alert('잠시 후 다시 시도해주세요.');");
			//이 전 페이지로 사용자를 다시 돌려보내는 함수이다.
			script.println("history.back()");
			script.println("</script>");
		}
		//오류 발생
		else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('잠시 후 다시 시도해주세요.');");
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