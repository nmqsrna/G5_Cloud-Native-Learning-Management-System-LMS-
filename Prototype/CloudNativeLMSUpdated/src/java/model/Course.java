package model;

public class Course {
    private int id;
    private String title;
    private String description;
    private String instructorId;
    
    // Lajur pembantu yang diperlukan untuk skrin rujukan awak
    private String instructorName; 
    private String category;
    private String level;
    private String tags;
    private String status;
    

    public Course() {}

    // GETTER & SETTER KUNCI UTAMA (Wajib ada untuk CourseDAO)
    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Getter & Setter Asal
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getInstructorId() { return instructorId; }
    public void setInstructorId(String instructorId) { this.instructorId = instructorId; }
}