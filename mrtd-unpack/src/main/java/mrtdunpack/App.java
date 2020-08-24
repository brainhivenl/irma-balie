package mrtdunpack;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.bouncycastle.asn1.ASN1Encodable;
import org.bouncycastle.asn1.ASN1Integer;
import org.bouncycastle.asn1.DERSequence;
import org.jmrtd.Util;
import org.jmrtd.lds.SODFile;
import org.jmrtd.lds.icao.*;

import java.io.*;
import java.math.BigInteger;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.PublicKey;
import java.security.Signature;
import java.text.ParseException;
import java.util.Arrays;

public class App {
    public static void main(String[] args) throws ParseException, IOException {
        if (args.length != 1) {
            System.err.println("Expected a single arguments <file> or the string \"stdin\"");
            return;
        }

        String path = args[0];
        System.out.println("Opening " + path);

        Reader reader;
        if (path.equals("stdin")) {
            reader = new InputStreamReader(System.in);
        } else {
            reader = new FileReader(new File(path));
        }

        Gson gson = new GsonBuilder().disableHtmlEscaping().setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES).create();
        IDExcerpt idExcerpt = gson.fromJson(reader, IDExcerpt.class);

        COMFile comFile = new COMFile(new ByteArrayInputStream(idExcerpt.com));
        DG1File dg1File = new DG1File(new ByteArrayInputStream(idExcerpt.dg1));
        DG2File dg2File = new DG2File(new ByteArrayInputStream(idExcerpt.dg2));
        DG15File dg15File = new DG15File(new ByteArrayInputStream(idExcerpt.dg15));
        SODFile sodFile = new SODFile(new ByteArrayInputStream(idExcerpt.sod));

        MRZInfo mrzInfo = dg1File.getMRZInfo();
        boolean valid = false;
        try {
            valid = validate(idExcerpt.challenge, idExcerpt.response, dg1File, dg2File, dg15File, sodFile);
        } catch (Exception _e) {
            // Do nothing.
        }

        IDVerdict idVerdict = new IDVerdict(mrzInfo, dg2File, sodFile, valid);
        String jsonRepresentation = gson.toJson(idVerdict);
        System.out.println(jsonRepresentation);
    }

    private static boolean verifyHash(SODFile sodFile, int number, byte[] data) throws GeneralSecurityException, IOException {
        byte[] hash = sodFile.getDataGroupHashes().get(number);

        MessageDigest messageDigest = Util.getMessageDigest(sodFile.getDigestAlgorithm());
        return Arrays.equals(messageDigest.digest(data), hash);
    }

    private static boolean verifySODSignature(SODFile sodFile) throws GeneralSecurityException {
        Signature signature = Util.getSignature(sodFile.getDigestEncryptionAlgorithm());

        signature.initVerify(sodFile.getDocSigningCertificate());
        signature.update(sodFile.getEContent());
        return signature.verify(sodFile.getEncryptedDigest());
    }

    private static boolean validate(byte[] challenge, byte[] response, DG1File dg1File, DG2File dg2File, DG15File dg15File, SODFile sodFile) throws GeneralSecurityException, IOException {
        String sigAlg = "SHA256WithECDSA"; // TODO infer from certificate type
        String digAlg = Util.inferDigestAlgorithmFromSignatureAlgorithm(sigAlg);
        System.err.println("Checking AA with " + sigAlg + " / " + digAlg);

        PublicKey publicKey = dg15File.getPublicKey();
        int l = response.length / 2;
        BigInteger r = Util.os2i(response, 0, l);
        BigInteger s = Util.os2i(response, l, l);

        DERSequence sequence = new DERSequence(new ASN1Encodable[]{new ASN1Integer(r), new ASN1Integer(s)});

        Signature signature = Util.getSignature(sigAlg);
        signature.initVerify(publicKey);
        signature.update(challenge);

        if (!signature.verify(sequence.getEncoded())) {
            return false;
        }
        System.err.println("AA Challenge-Response OK!");

        if (!verifyHash(sodFile, 1, dg1File.getEncoded())) {
            return false;
        }
        System.err.println("DG1 hash OK!");

        if (!verifyHash(sodFile, 2, dg2File.getEncoded())) {
            return false;
        }
        System.err.println("DG2 hash OK!");

        if (!verifyHash(sodFile, 15, dg15File.getEncoded())) {
            return false;
        }
        System.err.println("DG15 hash OK!");

        if (!verifySODSignature(sodFile)) {
            return false;
        }
        System.err.println("SOD signature OK!");

        String principal = sodFile.getIssuerX500Principal().getName();
        System.err.println(principal);
        System.err.println(sodFile.getDocSigningCertificate().getIssuerX500Principal());

        // TODO check national cert chain.

        return true;
    }
}