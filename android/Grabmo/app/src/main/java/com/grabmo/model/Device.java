package com.grabmo.model;

import java.util.List;

public class Device {

    User user;

    boolean joined;
    boolean running;

    String ipnumber;
    String ippublic;
    String macaddress;
    String hostname;
    String city;
    String country;
    String location;
    String network_provider;
    String uptime;
    String starttime;
    int db_local;
    String model;
    String hardware;
    String serial;
    String revision;
    int disktotal;
    int diskused;
    int diskavailable;
    int disk_percentage_used;
    int temperature;
    String uuid_installation;

    List<Camera> cameras;

    boolean collapsed;

    public Device(String macaddress, String hostname, String city, String country, String location, String network_provider, String uptime, String starttime, int db_local, String model, String hardware, String serial, String revision, int disktotal, int diskused, int diskavailable, int disk_percentage_used, int temperature, List<Camera> cameras) {
        this.macaddress = macaddress;
        this.hostname = hostname;
        this.city = city;
        this.country = country;
        this.location = location;
        this.network_provider = network_provider;
        this.uptime = uptime;
        this.starttime = starttime;
        this.db_local = db_local;
        this.model = model;
        this.hardware = hardware;
        this.serial = serial;
        this.revision = revision;
        this.disktotal = disktotal;
        this.diskused = diskused;
        this.diskavailable = diskavailable;
        this.disk_percentage_used = disk_percentage_used;
        this.temperature = temperature;
        this.cameras = cameras;
    }

    public String getIpnumber() {
        return ipnumber;
    }

    public void setIpnumber(String ipnumber) {
        this.ipnumber = ipnumber;
    }

    public String getIppublic() {
        return ippublic;
    }

    public void setIppublic(String ippublic) {
        this.ippublic = ippublic;
    }

    public List<Camera> getCameras() {
        return cameras;
    }

    public void setCameras(List<Camera> cameras) {
        this.cameras = cameras;
    }

    public String getMacaddress() {
        return macaddress;
    }

    public void setMacaddress(String macaddress) {
        this.macaddress = macaddress;
    }

    public String getHostname() {
        return hostname;
    }

    public void setHostname(String hostname) {
        this.hostname = hostname;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getNetwork_provider() {
        return network_provider;
    }

    public void setNetwork_provider(String network_provider) {
        this.network_provider = network_provider;
    }

    public String getUptime() {
        return uptime;
    }

    public void setUptime(String uptime) {
        this.uptime = uptime;
    }

    public String getStarttime() {
        return starttime;
    }

    public void setStarttime(String starttime) {
        this.starttime = starttime;
    }

    public int getDb_local() {
        return db_local;
    }

    public void setDb_local(int db_local) {
        this.db_local = db_local;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getHardware() {
        return hardware;
    }

    public void setHardware(String hardware) {
        this.hardware = hardware;
    }

    public String getSerial() {
        return serial;
    }

    public void setSerial(String serial) {
        this.serial = serial;
    }

    public String getRevision() {
        return revision;
    }

    public void setRevision(String revision) {
        this.revision = revision;
    }

    public int getDisktotal() {
        return disktotal;
    }

    public void setDisktotal(int disktotal) {
        this.disktotal = disktotal;
    }

    public int getDiskused() {
        return diskused;
    }

    public void setDiskused(int diskused) {
        this.diskused = diskused;
    }

    public int getDiskavailable() {
        return diskavailable;
    }

    public void setDiskavailable(int diskavailable) {
        this.diskavailable = diskavailable;
    }

    public int getDisk_percentage_used() {
        return disk_percentage_used;
    }

    public void setDisk_percentage_used(int disk_percentage_used) {
        this.disk_percentage_used = disk_percentage_used;
    }

    public int getTemperature() {
        return temperature;
    }

    public void setTemperature(int temperature) {
        this.temperature = temperature;
    }

    public String getUuid_installation() {
        return uuid_installation;
    }

    public void setUuid_installation(String uuid_installation) {
        this.uuid_installation = uuid_installation;
    }

    public boolean isCollapsed() {
        return collapsed;
    }

    public void setCollapsed(boolean collapsed) {
        this.collapsed = collapsed;
    }

}