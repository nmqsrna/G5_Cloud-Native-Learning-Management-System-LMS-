package model;

public class Module {
    private int id;
    private int courseId;
    private String moduleTitle;
    private String contentType;
    private String filePath;

    public Module() {}

    public Module(int id, int courseId, String moduleTitle, String contentType, String filePath) {
        this.id = id;
        this.courseId = courseId;
        this.moduleTitle = moduleTitle;
        this.contentType = contentType;
        this.filePath = filePath;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getModuleTitle() { return moduleTitle; }
    public void setModuleTitle(String moduleTitle) { this.moduleTitle = moduleTitle; }

    public String getContentType() { return contentType; }
    public void setContentType(String contentType) { this.contentType = contentType; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
}