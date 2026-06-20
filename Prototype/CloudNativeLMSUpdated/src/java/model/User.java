package model;

public class User {

    private String id;
    private String fullname;
    private String email;
    private String password;
    private String role;
    private String username;
    private String phone;

    public User() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // Tambah ini di bahagian atas bersama pembolehubah lain (id, username, fullname, dsb)
    private String profilePicture;

    // Tambah dua kaedah (method) ini di bahagian bawah fail bersama getter/setter yang lain
    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    // Tambah Getter
    public String getPhone() {
        return phone;
    }

// Tambah Setter (Ini yang hilang!)
    public void setPhone(String phone) {
        this.phone = phone;
    }

}
