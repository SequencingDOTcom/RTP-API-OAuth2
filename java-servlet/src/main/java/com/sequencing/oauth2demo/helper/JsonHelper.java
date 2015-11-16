package com.sequencing.oauth2demo.helper;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class JsonHelper {
    
    public static String getField(String json, String fieldName) {
        JsonObject o = new JsonParser().parse(json).getAsJsonObject();
        return o.get(fieldName).getAsString();
    }
    
    public static JsonArray toJsonArray(String json) {
        return new JsonParser().parse(json).getAsJsonArray();
    }
}
