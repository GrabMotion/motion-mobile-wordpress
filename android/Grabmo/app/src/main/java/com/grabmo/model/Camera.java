package com.grabmo.model;

import android.widget.ImageView;


public class Camera {
    int cameranumber;
    String cameraname;
    boolean recognizing;
    int idmat;
    ImageView thumbnail;

    int matrows;
    int matcols;
    int matheight;
    int matwidth;

    public Camera(int cameranumber, String cameraname, boolean recognizing
            , int idmat, int matrows, int matcols
            , int matheight, int matwidth) {
        this.cameranumber = cameranumber;
        this.cameraname = cameraname;
        this.recognizing = recognizing;
        this.idmat = idmat;
        this.matrows = matrows;
        this.matcols = matcols;
        this.matheight = matheight;
        this.matwidth = matwidth;
    }

    public int getCameranumber() {
        return cameranumber;
    }

    public void setCameranumber(int cameranumber) {
        this.cameranumber = cameranumber;
    }

    public String getCameraname() {
        return cameraname;
    }

    public void setCameraname(String cameraname) {
        this.cameraname = cameraname;
    }

    public boolean isRecognizing() {
        return recognizing;
    }

    public void setRecognizing(boolean recognizing) {
        this.recognizing = recognizing;
    }

    public int getIdmat() {
        return idmat;
    }

    public void setIdmat(int idmat) {
        this.idmat = idmat;
    }

    public ImageView getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(ImageView thumbnail) {
        this.thumbnail = thumbnail;
    }

    public int getMatrows() {
        return matrows;
    }

    public void setMatrows(int matrows) {
        this.matrows = matrows;
    }

    public int getMatcols() {
        return matcols;
    }

    public void setMatcols(int matcols) {
        this.matcols = matcols;
    }

    public int getMatheight() {
        return matheight;
    }

    public void setMatheight(int matheight) {
        this.matheight = matheight;
    }

    public int getMatwidth() {
        return matwidth;
    }

    public void setMatwidth(int matwidth) {
        this.matwidth = matwidth;
    }
}