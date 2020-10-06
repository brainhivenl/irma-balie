package mrtdscanner;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;

public class BalieClient {
    private String host;

    public BalieClient(String host) {
        this.host = host;
    }

    public byte[] create() throws IOException {
        URL url = new URL(this.host + "/create");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        if (connection.getResponseCode() != 200) {
            throw new IOException(String.format("Client returned code %d", connection.getResponseCode()));
        }

        byte[] challenge = connection.getInputStream().readAllBytes();
        return Base64.getDecoder().decode(challenge);
    }

    public void scanned(IDExcerpt idExcerpt) throws IOException {
        Gson gson = new GsonBuilder().disableHtmlEscaping().setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES).create();
        String jsonRepresentation = gson.toJson(idExcerpt);

        URL url = new URL(this.host + "/scanned");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setDoOutput(true);
        connection.setRequestMethod("POST");
        connection.addRequestProperty("content-type", "application/json");

        connection.getOutputStream().write(jsonRepresentation.getBytes());

        if (connection.getResponseCode() != 200) {
            throw new IOException(String.format("Client did not accept scanned with code %d", connection.getResponseCode()));
        }
    }
}
