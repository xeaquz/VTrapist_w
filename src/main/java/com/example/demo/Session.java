package com.example.demo;

public class Session {

    public String userId;
    public String videoId;
    public int timePlayed;
    public String timeStarted;
    public String accelId;
    public String heartId;
    public String gyroId;
    public String type;
    public float samplingRate_a;

    public Session(){}
    public Session(String userId, String videoId, String timeStarted, int timePlayed, String heartId, String type, float samplingRate_a) {
        this.userId = userId;
        this.videoId = videoId;
        this.timeStarted = timeStarted;
        this.timePlayed = timePlayed;
        this.heartId = heartId;
        this.type = type;
        this.samplingRate_a = samplingRate_a;
    }

}
