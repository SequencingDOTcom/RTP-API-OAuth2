package com.sequencing.oauthdemo.helper;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class JsonHelper {
    
    public static String getField(String json, String fieldName) {
        JsonObject o = new JsonParser().parse(json).getAsJsonObject();
        return o.get(fieldName).getAsString();
    }
    
    public static JsonArray toJsonArray(String json) {
        return new JsonParser().parse(json).getAsJsonArray();
    }

    public static String[] parseJsonArrayToStringArray(JsonArray jsonArray){
        Iterator<JsonElement> jsonArrayIterator = jsonArray.iterator();
        List<String> list = new ArrayList<String>();

        while (jsonArrayIterator.hasNext()) {
            JsonElement element = jsonArrayIterator.next();
            JsonElement name = element.getAsJsonObject().get("Name");
            JsonElement friendlyDesc1 = element.getAsJsonObject().get("FriendlyDesc1");
            JsonElement friendlyDesc2 = element.getAsJsonObject().get("FriendlyDesc2");

            list.add(name.getAsString() + ": " + friendlyDesc1.getAsString() + ", " + friendlyDesc2.getAsString());
        }

        String []resultStringArray = new String[list.size()];
        list.toArray(resultStringArray);
        return resultStringArray;
    }

}
