package mrtdunpack;

import org.apache.commons.io.FileUtils;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;

public class JP2Convert {
    static byte[] convert(InputStream inputStream) throws IOException, InterruptedException {
        File faceJP2File = File.createTempFile("out", ".jp2");
        OutputStream faceJP2Out = new FileOutputStream(faceJP2File);
        inputStream.transferTo(faceJP2Out);

        Path outFile = Files.createTempFile("out", ".png");

        try {
            ProcessBuilder convertProcessBuilder = new ProcessBuilder();
            convertProcessBuilder.command("opj_decompress", "-i", faceJP2File.getAbsolutePath(), "-OutFor", "PNG", "-o", outFile.toAbsolutePath().toString());
            Process convertProcess = convertProcessBuilder.start();
            convertProcess.waitFor();

            return FileUtils.readFileToByteArray(outFile.toFile());
        } finally {
            try {
                //noinspection ResultOfMethodCallIgnored
                faceJP2File.delete();
            } catch (Throwable _t) { /* Do nothing */ }
            try {
                //noinspection ResultOfMethodCallIgnored
                outFile.toFile().delete();
            } catch (Throwable _t) { /* Do nothing */ }
        }
    }
}
