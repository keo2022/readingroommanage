<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="time.TimeDAO" %>
<%@ page import="time.Time" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name="viewport" content="width=device-width" , inital-scale="1">
<!--link 태그를 이용해서, stylesheet를 참조선언 해주고, 링크로 css폴더안에 있는 bootstrap.css를 사용해 준다고 명시해준다. jSP내의 디자인 담당-->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
		font-size:15pt;
	}

</style>
</head>
<body>
<%
	String seat = null;
	seat = request.getParameter("seat");

	String userID = null;
	if(session.getAttribute("userID")!=null){
		userID = (String) session.getAttribute("userID");
	}
	TimeDAO timeDAO = new TimeDAO();
	String result = timeDAO.whoseat(seat);
	String getlimit = timeDAO.getlimit(userID);
%>
<br>
<span style=" display: flex;
			  justify-content: center;
			  align-items: center;
			  font-size:25pt;"><%=seat %></span><br>
	<%
	//본인 자리
	if(result.equals(userID)){
	%>
	<div style="  display: flex;
				  justify-content: center;
				  align-items: center;">
	<a href="endAction.jsp" type="button">종료</a> &nbsp;
	<a href="extendAction.jsp" type="button">연장</a>	
	</div><br>
	<div style="margin-left:15%; font-size:13pt;"><%=getlimit %> 까지 사용 가능</div>
	<%}
	//다른사람이 사용중일 때
	else if(result.equals("2")){
	%>
	<div style="  display: flex;
				  justify-content: center;
				  align-items: center;">
	<a href="startAction.jsp?seat=<%=seat %>" type="button">시작</a>
	</div>
	<%
	}
	else{
	%>
	<div style="  display: flex;
				  justify-content: center;
				  align-items: center;">
	사용중
	</div>
	<%} %>

</body>
</html>