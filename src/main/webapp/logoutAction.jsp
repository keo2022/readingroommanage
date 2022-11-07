<%@page import="user.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP Web Site</title>
</head>
<body>
	<%	//3.현재 logoutAction 페이지로 온 회원의 세션을 빼앗기도록 만들어서 로그아웃 시켜준다.
		session.invalidate();		
		%>
		<script>
			//그 후 main.jsp로 돌려보내 주면 끝이다.
			location.href= 'main.jsp';
		</script>
</body>
</html>