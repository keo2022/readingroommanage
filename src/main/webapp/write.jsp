<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name="viewport" content="width=device-width" , inital-scale="1">
<!--link 태그를 이용해서, stylesheet를 참조선언 해주고, 링크로 css폴더안에 있는 bootstrap.css를 사용해 준다고 명시해준다. jSP내의 디자인 담당-->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>독서실 관리</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID")!=null){
			userID = (String) session.getAttribute("userID");
		}
	%>
	<!-- 네비게이션 구현 네비게이션이라는 것은 하나의 웹사이트의 전반적인 구성을 보여주는 역할 -->
	<nav class="navbar navbar-default">
		<!-- header부분을 먼저 구현해 주는데 홈페이지의 로고같은것을 담는 영역이라고 할 수 있다. -->
		<div class="navbar-header">
			<!-- <1>웹사이트 외형 상의 제일 좌측 버튼을 생성해준다. data-target= 타겟명을 지정해주고-->
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-exmaple="false">
		<!-- 이건 모바일 화면으로 볼때, 요약된 메뉴 목록에 줄을 그려주는부분 그림에서 설명 *1* 별건없고 단지 꾸며주는 용도-->
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<!-- 여긴 웹페이지의 로고 글자를 지정해준다. 클릭 시 main.jsp로 이동하게 해주는게 국룰 -->
			<a class="navbar-brand" href="main.jsp">독서실 관리</a>
		</div>
		<!-- 여기서 <1>에만든 버튼 내부의 데이터 타겟과 div id가 일치해야한다. -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<!-- div 내부에 ul은 하나의 어떠한 리스트를 보여줄때 사용 -->
			<ul class="nav navbar-nav">
				<!-- 리스트 내부에 li로 원소를 구현 메인으로 이동하게만들고-->
				<li><a href="main.jsp">메인</a></li>
				<!-- 게시판으로 이동하게 만든다. -->
				<li class="active"><a href="bbs.jsp">게시판</a></li>
						<!-- 10-28 프로토타입 위해 추가 -->
				<li><a href="seat.jsp">좌석 확인</a></li>
				
			</ul>
			<%
				if(userID == null){
			%>
				<!-- 원소를 하나 구현해 준다. 네비게이션 우측 슬라이드메뉴 구현  -->
				<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<!-- 안에 a태그를 하나 삽입한다. href="#"은 링크없음을 표시한다. -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기
						<!-- 이건 하나의 아이콘 같은것 a태그 내부 삽입-->
						<span class="caret"></span></a>
					<!--접속하기 아래에 드랍다운메뉴 생성  -->
					<ul class="dropdown-menu">
						<!-- li class="active" 현재 선택된 홈페이지를 표시해 주게만든다. -->
						<li><a href="login.jsp">로그인</a></li>
						<!-- active는 한 개만 선언 -->
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>		
			<% 
				} else {
			%>
			<!-- 원소를 하나 구현해 준다. 네비게이션 우측 슬라이드메뉴 구현  -->
				<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<!-- 안에 a태그를 하나 삽입한다. href="#"은 링크없음을 표시한다. -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리
						<!-- 이건 하나의 아이콘 같은것 a태그 내부 삽입-->
						<span class="caret"></span></a>
					<!--접속하기 아래에 드랍다운메뉴 생성  -->
					<ul class="dropdown-menu">
						<!-- li class="active" 현재 선택된 홈페이지를 표시해 주게만든다. -->
						<li><a href="logoutAction.jsp">프로필</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>	
			<%
				}
			%>	
		</div>
		<!-- 네비게이션 바 구성 끝 -->
	</nav>
	<div class="container">
		 <div class="row">
		 	<form method="post" action="writeAction.jsp" enctype="multipart/form-data">
		 	<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
		 		<thead>
		 			<tr>
		 				<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th>
		 			</tr>
		 		</thead>
		 		<tbody>
					<!-- 글 제목과 글 작성이 각각 한줄로 들어갈 수 있도록 tr로 각각 묶어준다. -->
					<tr>
					<!-- 글 제목을 작성할 수있는 input을 삽입 해준다. -->
						<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50"></td>
					</tr>
					<tr>
					<!-- 장문의 글을 작성 할 수있는 textarea태그를 이용해서 Content를 입력하도록 삽입한다. -->
						<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"></textarea></td>
					</tr>
					<tr>
						<td><input type="file" name="file"></td>
					</tr>
				</tbody>
			</table>
				<!-- 사용자에게 보여지는 글쓰기 버튼을 구현 -->	
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기"/>
			</form>
			<!--  <form action="fileUpload.jsp" name="fileForm" method="post" enctype="multipart/form-data">
				파일명 : <input type="file" name="uploadFile"><br>
				<input type="submit" value="파일 업로드">
			</form>-->
		</div>
	<!-- 글쓰기 화면 구현 끝 -->	
	</div>

	
	<!--이 파일의 애니메이션을 담당할 자바스크립트 참조선언 jquery를 특정 홈페이지에서 호출 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!--js폴더 안에있는 bootstrap.js를 사용선언  -->
	<script src="js/bootstrap.js"></script>
</body>
</html>