package mrtdunpack;

import com.google.gson.annotations.JsonAdapter;
import net.sf.scuba.data.Gender;
import org.jmrtd.lds.SODFile;
import org.jmrtd.lds.icao.DG2File;
import org.jmrtd.lds.icao.MRZInfo;
import org.jmrtd.lds.iso19794.FaceImageInfo;

import javax.security.auth.x500.X500Principal;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class IDVerdict {
    boolean valid;

    String documentCode;
    String documentNumber;
    String firstNames;
    String lastName;
    String nationality;
    String personalNumber;
    Date dateOfBirth;
    Date dateOfExpiry;
    String gender;
    String issuer;

    @JsonAdapter(HexAdapter.class)
    byte[] faceImage;

    public IDVerdict(MRZInfo mrzInfo, DG2File dg2File, SODFile sodFile, boolean valid) throws ParseException, IOException {
        this.valid = valid;

        this.documentCode = mrzInfo.getDocumentCode();
        this.documentNumber = mrzInfo.getDocumentNumber();
        this.firstNames = String.join(" ", mrzInfo.getSecondaryIdentifierComponents());
        this.lastName = mrzInfo.getPrimaryIdentifier();
        this.nationality = mrzInfo.getNationality();
        this.personalNumber = mrzInfo.getPersonalNumber();
        this.issuer = sodFile.getIssuerX500Principal().getName(X500Principal.RFC1779);
        Gender enumGender = mrzInfo.getGender();

        this.dateOfBirth = new SimpleDateFormat("yyMMdd").parse(mrzInfo.getDateOfBirth());
        this.dateOfExpiry = new SimpleDateFormat("yyMMdd").parse(mrzInfo.getDateOfExpiry());

        this.gender = "-";
        if (enumGender == Gender.MALE) {
            this.gender = "M";
        } else if (enumGender == Gender.FEMALE) {
            this.gender = "V";
        }

        try {
            FaceImageInfo fii = dg2File.getFaceInfos().get(0).getFaceImageInfos().get(0);
            this.faceImage = JP2Convert.convert(fii.getImageInputStream());
        } catch (IndexOutOfBoundsException | InterruptedException _e) {
            // Do nothing
        }
    }
}
