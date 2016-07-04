package com.grabmo.model;

/**
 * Created by jose on 7/1/16.
 */
public class NotificationList
{

   /*
	{
		instance_id: "46921",
		terminal_name: "",
		camera_name: "FaceCam VGA",
		instance_elapsed_time: 1,
		instance_media_url: "http://grabmotion.co/wp-content/uploads/2016/06/1900010_72.jpg",
		day_label: "JunSun26",
		recognition_name: "BASIC",
		locaton_city: "Ituzaingo"
	}
    */

	private int instance_id;
	private String terminal_name;
	private String camera_name;
	private int instance_elapsed_time;
	private String instance_media_url;
	private String day_label;
	private String recognition_name;
	private String locaton_city;

	public NotificationList(int instance_id, String camera_name, String terminal_name, String day_label, String instance_media_url, int instance_elapsed_time, String recognition_name, String locaton_city) {
		this.instance_id = instance_id;
		this.camera_name = camera_name;
		this.terminal_name = terminal_name;
		this.day_label = day_label;
		this.instance_media_url = instance_media_url;
		this.instance_elapsed_time = instance_elapsed_time;
		this.recognition_name = recognition_name;
		this.locaton_city = locaton_city;
	}

	public int getInstance_id() {
		return instance_id;
	}

	public String getTerminal_name() {
		return terminal_name;
	}

	public String getCamera_name() {
		return camera_name;
	}

	public int getInstance_elapsed_time() {
		return instance_elapsed_time;
	}

	public String getInstance_media_url() {
		return instance_media_url;
	}

	public String getDay_label() {
		return day_label;
	}

	public String getRecognition_name() {
		return recognition_name;
	}

	public String getLocaton_city() {
		return locaton_city;
	}

	public void setTerminal_name(String terminal_name) {
		this.terminal_name = terminal_name;
	}

	public void setInstance_id(int instance_id) {
		this.instance_id = instance_id;
	}

	public void setCamera_name(String camera_name) {
		this.camera_name = camera_name;
	}

	public void setInstance_elapsed_time(int instance_elapsed_time) {
		this.instance_elapsed_time = instance_elapsed_time;
	}

	public void setInstance_media_url(String instance_media_url) {
		this.instance_media_url = instance_media_url;
	}

	public void setDay_label(String day_label) {
		this.day_label = day_label;
	}

	public void setLocaton_city(String locaton_city) {
		this.locaton_city = locaton_city;
	}

	public void setRecognition_name(String recognition_name) {
		this.recognition_name = recognition_name;
	}
}
