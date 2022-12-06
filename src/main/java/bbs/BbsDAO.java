package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	//Database 접근 객체로 사용할 conn을 선언해주고,
	private Connection conn;
	private ResultSet rs;

	//UserDAO를 생성자로 만들어 주고, 자동적으로 데이터베이스 연결이 이뤄지게 해주는 코드를 짠다.
	public BbsDAO() {
	//예외 처리를 하기 위해서 try&catch 문을 쓴다.
	try {
		//dbURL안에 localhost라는 것은 본인 컴퓨터에 접속을 의미하고 3306포트에 연결된 BBSdb에 접속할 수 있게 해준다.
		//강의랑 디비 버전을 다르게해서 뒤에 뭘더붙임 ㅇㅇ;
		String dbURL =  "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
		//db에 접속하는 ID를 담는 부분
		String dbID = "root";
		//db에 접속하는 PW를 담는 부분
		String dbPassword = "0000";
		//mysql에 접속할 수 있는 driver를 찾을수 있게 해주는 코드 driver라는건 mysql에 접속할 수 있도록 매개체 역할을 해주는 라이브러리이다.
		//강의버전보다 한참 높은 버전의 디비를 써서 드라이버 주소가 좀다름
		Class.forName("com.mysql.cj.jdbc.Driver");
		//getConnection함수 내부에 dbURL에 root root 로 접속할 수 있게 해주는 데이터를 넣어 접속이 완료되면 conn객체안에 접속된 정보가 담기게 된다.
		conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
	
	} catch (Exception e) {
		//오류의 내용을 내부 콘솔에 띄우기 위한 함수이다.
		e.printStackTrace();
	}
}
	//게시판 글쓰기를 위해서는 총 3개의 함수가 필요하다.(ex. 현재의 시간을 가져오는 함수
			public String getDate() {
				//이건 mysql에서 현재의 시간을 가져오는 하나의 문장
				String SQL = "SELECT NOW()";
				try {
					//각각 함수끼리 데이터 접근에 있어서 마찰방지용으로 내부 pstmt선언 (현재 연결된 객체를 이용해서 SQL문장을 실행 준비단계로 만들어준다.)
					PreparedStatement pstmt = conn.prepareStatement(SQL);
					//rs내부에 실제로 실행했을때 나오는 결과를 가져온다
					rs = pstmt.executeQuery();
					//결과가 있는경우는 다음과 같이 getString 1을 해서 현재의 그 날짜를 반환할 수 있게 해준다.
					if(rs.next()) {
						return rs.getString(1);
					}
				} catch (Exception e) {
					//오류 발생 내용을 콘솔에 띄움
					e.printStackTrace();
				}
				//데이터베이스 오류인데 웬만해선 디비오류가 날 이유가없기때문에 빈문장으로 넣어준다.
				return ""; 
			}
			//bbsID 게시글 번호 가져오는 함수
				public int getNext() { 
					//들어가는 SQL문장은 bbsID를 가져오는데 게시글 번호같은 경우는 1번부터 하나씩 늘어나야 하기때문에
					//마지막에 쓰인 글을 가져와서 그 글번호에다가 1을 더한 값이 그 다음번호가 되기때문에 내림차순으로 들고와서 +1해 주는 방식을 사용한다.
					//String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
					String SQL = "select NUM from (select @rownum:=@rownum+1 as NUM from bbs, (select @rownum:=0) as R where bbsAvailable = 1 order by bbsDate desc) as A order by NUM desc";
					try {
						//나머진 그대로 가고 리턴값만 수정
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						rs = pstmt.executeQuery();
						if(rs.next()) {
							//나온 결과물에 1을 더해서 다음 게시글을 불러온다.
							return rs.getInt(1) + 1;
						}
						//현재 쓰이는 게시글이 하나도 없는 경우에는 결과가 안나오기 때문에 1을 리턴해준다.
						return 1;
					} catch (Exception e) {
						e.printStackTrace();
					}
					//데이터베이스 오류가 발생했을때 -1이 반환하면서 프로그래머에게 오류를 알려준다.
					return -1; 
				}
				
				public int getNewNext() {
					String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
					try {
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						rs = pstmt.executeQuery();
						
						if(rs.next()) {
							return rs.getInt(1)+1;
						}
						return 1;
					} catch (Exception e) {
						e.printStackTrace();
					}
					return -1;
				}
				
				//실제로 글을 작성하는 write함수 작성 Title,ID,Content를 외부에서 받아서 함수를 실행 시킨다.
				public int write(String bbsTitle, String userID, String bbsContent) { 
					//BBS 테이블에 들어갈 인자 6개를 ?로 선언 해준다.
					String SQL = "INSERT INTO BBS VALUES(?, ?, ?, ?, ?, ?)";
					try {
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						pstmt.setInt(1, getNext());
						pstmt.setString(2, bbsTitle);
						pstmt.setString(3, userID);
						pstmt.setString(4, getDate());
						pstmt.setString(5, bbsContent);
						//이 인자는 bbsAvailable이기 때문에 처음에 글이 작성되었을때는 글이 보여지는 형태가
						//되어야하고 삭제가 안된상태니까 1을 넣어준다.
						pstmt.setInt(6,1);
						//INSERT같은 경우에는 성공했을때 0이상의 값을 반환하기 때문에 return을 이렇게 작성해준다.
						return pstmt.executeUpdate();
					} catch (Exception e) {
						e.printStackTrace();
					}
					//데이터베이스 오류
					return -1; 
				//이렇게 만들어 줌으로서 성공적으로 글이 들어갔는지 확인이 가능하다.
				}
				//글 목록 가져오는 부분 getList 로 특정한 리스트에 담아 반환해주는 ArrayList<Bbs>함수 생성
				public ArrayList<Bbs> getList(int pageNumber) {
					//bbsID가 특정한 숫자보다 작을때를 범위로 잡아주고, Available이 1인 것만 or 내림차순으로 10개까지만 가져오도록 해주는 SQL문장을 넣어준다.
					String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
					//Bbs라는 클래스에서 나오는 인스턴스를 보관할 수 있는 list를 하나만들어서 new ArrayList<Bbs>();를 담아준다.
					ArrayList<Bbs> list = new ArrayList<Bbs>();
					try { 
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						//Next같은 경우는 그다음에 작성될 글의 번호를 얘기한다. 현재 만약 게시글이 5개 일때 Next는 6이 나올텐데
						//결과적으로 6이라는 값이 담기게 하기위한 함수. setInt(쿼리문 ?에 들어갈 값.)
						pstmt.setInt(1, getNext() - (pageNumber-1)*10);
						//값6   pageN는 1 그럼 결국 0이 되고, 6을 반환한다. 쿼리문 내에서는 6보다 작은 값을 가져오게 되면, 현재 db내에 있는
						//글의 내용을 전부 반환하게 된다.
						rs = pstmt.executeQuery();
						//결과가 나올때마다,
						while(rs.next()) {
							//bbs인스턴스를 만들어서
							Bbs bbs = new Bbs();
							//만든 bbs인스턴스안에 rs에서 실행한 쿼리문의 데이터를 다 담아서
							bbs.setBbsID(rs.getInt(1));
							bbs.setBbsTitle(rs.getString(2));
							bbs.setUserID(rs.getString(3));
							bbs.setBbsDate(rs.getString(4));
							bbs.setBbsContent(rs.getString(5));
							//BBS에 담긴 모든 속성을 다빼오기 때문에 각각 다 데이터를 담아서.
							bbs.setBbsAvailable(rs.getInt(6));
							//해당 리스트를 만든 bbs인스턴스에 담아서 반환 한다.
							list.add(bbs);
						}
					}catch(Exception e) {
						e.printStackTrace();
					}
					//10개 뽑아온 게시글 리스트를 출력한다.
					return list;
				}
				
				//페이징 처리 함수. 게시글이 10단위로 끊길때 10이면 다음페이지가 없어야 할때
				//이런 고유의 상황을 처리해 주기위해 만드는 함수
				public boolean nextPage(int pageNumber) {
					String SQL ="SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
					
					try {
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						pstmt.setInt(1, getNext() - (pageNumber -1) * 10);
						rs = pstmt.executeQuery();
						//결과가 하나라도 존재한다면,
						if (rs.next()) {
							//다음으로 넘어갈 수있다는 True를 리턴해주고,
							return true;
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					//그게 아닐경우 false를 리턴 
					return false; 		
				}
				
				//글 내용을 볼수있는 함수 구현 (int bbsID)값으로 선언을 해서 특정한 ID에 해당하는 게시글을 그대로 가져오도록하자.
				public Bbs getBbs(int bbsID){
					//bbsID가 특정한 숫자일때 어떠한 행위를 실행할 수 있는 쿼리를 작성
					String SQL ="SELECT * FROM BBS WHERE bbsID = ?";
					try {
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						pstmt.setInt(1, bbsID);
						rs = pstmt.executeQuery();
						//결과가 나왔을때 실행되어
						if (rs.next()) {
							//bbs인스턴스 내에 결과 값으로 나온 데이터를 다 집어 넣고
							Bbs bbs = new Bbs();
							bbs.setBbsID(rs.getInt(1));
							bbs.setBbsTitle(rs.getString(2));
							bbs.setUserID(rs.getString(3));
							bbs.setBbsDate(rs.getString(4));
							bbs.setBbsContent(rs.getString(5));
							bbs.setBbsAvailable(rs.getInt(6));
							//그 결과를 getBbs함수를 불러온 대상에게 반환 해 준다
							return bbs;
							
							}
					} catch (Exception e) {
						e.printStackTrace();
					}
					//해당 글이 존재하지 않으면 null반환 
					return null;
				}
				// 특정한 번호의 매개변수로 들어온 제목과 번호로 바꿔주는 함수를 만든다.
				public int update(int bbsID, String bbsTitle, String bbsContent) {
					//Table 내부에서 WHERE bbs ID 특정한 내부의 ID값에 대한 Title과 Content를 바꿔주겠다는 쿼리를 작성
					String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
					try {
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						pstmt.setString(1, bbsTitle);
						pstmt.setString(2, bbsContent);
						pstmt.setInt(3, bbsID);
						//성공적 실행이 되면 0이상의 값이 반환되기때문에 바로실행
						return pstmt.executeUpdate();
					} catch (Exception e) {
						e.printStackTrace();
					}
					return -1; // 데이터베이스 오류
				}
				//delete함수를 사용하는 jsp에서 bbsID값을 받아와서,
				public int delete(int bbsID) {
					//db내부에 bbsAvailable을 0으로 바꿈으로써 사용자 입장에서는 삭제가 되었다고 볼 수있다.
					//하지만 db내부에는 삭제된 글도 남아있다.
					String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
					try {
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						//bbsID값에 글을 Avaliable값을 0으로 바꿔주면서 글을 삭제시키고
						pstmt.setInt(1, bbsID);
						//결과가 무사히 성공을 했다면 0이상의 값이 반환을 하기에
						return pstmt.executeUpdate();
					}catch(Exception e) {
						e.printStackTrace();
					}
					//나머지는 디비오류
					return -1;
				}
				
				public int getSearchedNext(String searchWord) {
					//String SQL = "select bbsID from bbs where bbsAvailable = 1 and bbsTitle like '%" + searchWord + "%' order by bbsDate desc";
					String SQL = "select NUM from (select *, @rownum:=@rownum+1 as NUM from bbs, (select @rownum:=0) as R where bbsAvailable = 1 order by bbsDate desc) as A where bbsTitle LIKE ? ORDER BY NUM DESC";
					try {
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						pstmt.setString(1, "%" + searchWord + "%");
						rs = pstmt.executeQuery();
						if(rs.next()) {
							return rs.getInt(1)+1;
						}
						return 1;
					} catch (Exception e) {
						e.printStackTrace();
					}
					return -1;
				}
				
				public ArrayList<Bbs> getSearchedList(int pageNumber, String searchWord){
					
					int no2=0;
					
					if(getNext()>pageNumber*10) {
						no2 = pageNumber*10;
					} else {
					  no2 = getNext();
					}
					
					int no1=(pageNumber -1)*10+1;
					
					/*String SQL = "select * from (select *, @rownum:=@rownum+1 as NUM from bbs, (select @rownum:=0) as R where bbsAvailable = 1 order by bbsDate desc) as A where bbsTitle like '%"
							+ searchWord
							+ "%' and NUM between"
							+ no1
							+ " and "
							+ no2;*/
					
					String SQL = "select * from (select *, @rownum:=@rownum+1 as NUM from bbs, (select @rownum:=0) as R where bbsAvailable = 1 order by bbsDate desc) as A where bbsTitle like ? and NUM between ? and ?";
							
					ArrayList<Bbs> list = new ArrayList<Bbs>();
					try { 
						PreparedStatement pstmt = conn.prepareStatement(SQL);
						pstmt.setString(1, "%" + searchWord + "%");
						pstmt.setInt(2, no1);
						pstmt.setInt(3, no2);
						rs = pstmt.executeQuery();
						while(rs.next()) {
							Bbs bbs = new Bbs();
							bbs.setBbsID(rs.getInt(1));
							bbs.setBbsTitle(rs.getString(2));
							bbs.setUserID(rs.getString(3));
							bbs.setBbsDate(rs.getString(4));
							bbs.setBbsContent(rs.getString(5));
							bbs.setBbsAvailable(rs.getInt(6));
							list.add(bbs);
						}
					}catch(Exception e) {
						e.printStackTrace();
					}
					return list;
				}
				
				public boolean searchedNextPage(int pageNumber,String searchWord) {
					
					try {
						if(getSearchedNext(searchWord)>(pageNumber)*10) {
							return true;
						} else {
							return false;
						}
					}catch(Exception e) {
						e.printStackTrace();
					}
					return false;
				}
	 }
