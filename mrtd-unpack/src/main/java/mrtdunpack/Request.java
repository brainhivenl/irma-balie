package mrtdunpack;

import com.google.gson.annotations.JsonAdapter;

public class Request {
    @JsonAdapter(HexAdapter.class)
    public byte[] challenge;

    public IDExcerpt document;
}
