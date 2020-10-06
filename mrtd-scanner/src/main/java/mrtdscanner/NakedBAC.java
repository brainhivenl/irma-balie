package mrtdscanner;

import org.jmrtd.AccessKeySpec;
import org.jmrtd.Util;

import java.security.GeneralSecurityException;

public class NakedBAC implements AccessKeySpec {
    private byte[] key;

    public NakedBAC(String mrz) throws GeneralSecurityException {
        this.key = Util.computeKeySeed(mrz.substring(1, 29), "SHA-1", true);
    }

    @Override
    public String getAlgorithm() {
        return "BAC";
    }

    @Override
    public byte[] getKey() {
        return this.key;
    }
}
