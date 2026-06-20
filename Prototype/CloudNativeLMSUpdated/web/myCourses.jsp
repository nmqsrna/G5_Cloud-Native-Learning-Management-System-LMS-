<%@page import="java.util.*"%>
<%@page import="dao.CourseDAO"%>
<%@page import="model.Course"%>
<%@page import="model.User"%>

<%
User user =
(User)session.getAttribute("user");

CourseDAO dao =
new CourseDAO();

List<Course> list =
dao.getInstructorCourses(
user.getId());
%>

<div class="course-grid">

<%
for(Course c : list){
%>

<div class="course-card">

<h3>
<%= c.getTitle() %>
</h3>

<p>
<%= c.getDescription() %>
</p>

</div>

<%
}
%>

</div>