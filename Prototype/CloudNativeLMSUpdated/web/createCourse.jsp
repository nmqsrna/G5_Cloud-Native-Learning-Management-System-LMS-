<form action="CreateCourseServlet" method="post">

    <div class="form-group">

        <label>Course Title</label>

        <input type="text"
               name="title"
               class="form-control">

    </div>

    <div class="form-group">

        <label>Description</label>

        <textarea name="description"
                  class="form-control"></textarea>

    </div>

    <button class="btn btn-primary">
        Create Course
    </button>

</form>