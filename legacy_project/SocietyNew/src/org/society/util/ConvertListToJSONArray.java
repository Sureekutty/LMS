package org.society.util;

import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ConvertListToJSONArray {
	
	public static JSONObject convertCollection(Collection<Object> anyCollection,String objectName) throws JSONException {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put(objectName, new JSONArray(anyCollection));
		return jsonObject;
	}
	
	// for batch operations

}
