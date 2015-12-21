package com.sequencing.oauthdemo.helper;

import android.util.Log;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import javax.net.ssl.HttpsURLConnection;

public class NewHttpHelper{
    private static final String TAG = "NewHttpHelper";

    public static Map<String, String> getBasicAuthenticationHeader(String username, String password) {
            byte[] encodedBytes = Base64.encodeBase64((username + ":" + password).getBytes());
            String encoded = new String(encodedBytes);
            Map<String, String> header = new HashMap<String, String>();
            header.put("Authorization", "Basic " + encoded);
            return header;
    }


    public static String doGet(String uri, Map<String, String> headers) {
        URL url = null;
        String response = "";

        try {
            url = new URL(uri);

            HttpURLConnection conn = (HttpURLConnection)url.openConnection();

            if (headers != null) {
                for (Map.Entry<String, String> h : headers.entrySet())
                    conn.setRequestProperty(h.getKey(), h.getValue());
            }

            int responseCode=conn.getResponseCode();

            if (responseCode == HttpsURLConnection.HTTP_OK) {
                String line;
                BufferedReader br=new BufferedReader(new InputStreamReader(conn.getInputStream()));
                while ((line=br.readLine()) != null) {
                    response+=line;
                }
            }
            else {
                Log.e(TAG, "HTTP get request error: " + responseCode);
            }
        } catch (Exception e) {
            Log.e(TAG, "HttpURLConnection error: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    public static String doPost(String uri, Map<String, String> headers, Map<String, String> params) {
        String charset = "UTF-8";
        String response = "";
        try {
            HttpsURLConnection conn = (HttpsURLConnection) new URL(uri).openConnection();
            conn.setRequestProperty("Accept-Charset", charset);
            conn.setReadTimeout(10000);
            conn.setConnectTimeout(15000);
            conn.setRequestMethod("POST");
            conn.setDoInput(true);
            conn.setDoOutput(true);

            if (headers != null) {
                for (Map.Entry<String, String> h : headers.entrySet())
                    conn.setRequestProperty(h.getKey(), h.getValue());
            }

            // writes post parameters
            OutputStream os = null;
            BufferedWriter writer = null;
            try {
                os = conn.getOutputStream();
                writer = new BufferedWriter(new OutputStreamWriter(os, charset));
                writer.write(getPostDataString(params));
                writer.flush();
            } finally {
                writer.close();
                os.close();
            }

            conn.connect();
            int responseCode = conn.getResponseCode();
            if (responseCode == HttpsURLConnection.HTTP_OK) {
                String line;
                BufferedReader br = null;
                InputStreamReader streamReader = new InputStreamReader(conn.getInputStream());
                try {
                    br = new BufferedReader(streamReader);
                    while ((line = br.readLine()) != null) {
                        response += line;
                    }
                }finally {
                    br.close();
                    streamReader.close();
                }
            } else {
                Log.e(TAG, "Response code: " + responseCode + " Message: " + conn.getResponseMessage());
            }
        } catch (Exception e) {
            Log.e(TAG, "HttpURLConnection error: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    private static String getPostDataString(Map<String, String> params) throws UnsupportedEncodingException{
        StringBuilder result = new StringBuilder();
        boolean first = true;
        for(Map.Entry<String, String> entry : params.entrySet()){
            if (first)
                first = false;
            else
                result.append("&");

            result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
            result.append("=");
            result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
        }

        return result.toString();
    }
}