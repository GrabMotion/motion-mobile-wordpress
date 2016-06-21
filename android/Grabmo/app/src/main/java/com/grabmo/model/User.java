package com.grabmo.model;

public class User {

    int clientnumber;
    int wp_userid;
    int wp_client_id;
    String wp_first_name;
    String wp_last_name;
    String location;

    public User(int clientnumber, int wp_userid, int wp_client_id, String wp_first_name, String wp_last_name, String location) {
        this.clientnumber = clientnumber;
        this.wp_userid = wp_userid;
        this.wp_client_id = wp_client_id;
        this.wp_first_name = wp_first_name;
        this.wp_last_name = wp_last_name;
        this.location = location;
    }

    public int getClientnumber() {
        return clientnumber;
    }

    public void setClientnumber(int clientnumber) {
        this.clientnumber = clientnumber;
    }

    public int getWp_userid() {
        return wp_userid;
    }

    public void setWp_userid(int wp_userid) {
        this.wp_userid = wp_userid;
    }

    public int getWp_client_id() {
        return wp_client_id;
    }

    public void setWp_client_id(int wp_client_id) {
        this.wp_client_id = wp_client_id;
    }

    public String getWp_first_name() {
        return wp_first_name;
    }

    public void setWp_first_name(String wp_first_name) {
        this.wp_first_name = wp_first_name;
    }

    public String getWp_last_name() {
        return wp_last_name;
    }

    public void setWp_last_name(String wp_last_name) {
        this.wp_last_name = wp_last_name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
