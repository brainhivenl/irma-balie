package mrtdunpack;

import com.google.gson.annotations.JsonAdapter;

public class IDExcerpt {
    @JsonAdapter(HexAdapter.class)
    public byte[] challenge;
    @JsonAdapter(HexAdapter.class)
    public byte[] response;

    @JsonAdapter(HexAdapter.class)
    public byte[] com;
    @JsonAdapter(HexAdapter.class)
    public byte[] dg1;
    @JsonAdapter(HexAdapter.class)
    public byte[] dg2;
    @JsonAdapter(HexAdapter.class)
    public byte[] dg15;
    @JsonAdapter(HexAdapter.class)
    public byte[] sod;
}
