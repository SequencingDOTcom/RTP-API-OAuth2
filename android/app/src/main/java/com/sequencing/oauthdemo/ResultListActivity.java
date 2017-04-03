package com.sequencing.oauthdemo;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class ResultListActivity extends AppCompatActivity {
    private ListView resultList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_result_list);

        resultList = (ListView) findViewById(R.id.resultList);

        Intent intent = getIntent();
        String []stringArrays = intent.getStringArrayExtra("stringArray");

        ArrayAdapter arrayAdapter = new ArrayAdapter(this, android.R.layout.simple_list_item_1, stringArrays);
        resultList.setAdapter(arrayAdapter);
    }
}
