package mrtdscanner;

import com.fazecast.jSerialComm.SerialPort;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;

public class OCR {
    private static byte[] CMD_DEACTIVATE_CONTINUOUS = {0x43, 0x00, 0x01, 0x00};
    private static byte[] CMD_ACTIVATE_DETECTION = {0x50, 0x00, 0x01, 0x00};
    private static byte[] CMD_INQUIRE = {0x49, 0x00, 0x00};

    private static byte[] RESP_DEACTIVATE_CONTINUOUS = {0x43, 0x00, 0x01};
    private static byte[] RESP_ACTIVATE_DETECTION = {0x00, 0x50, 0x00};

    private static byte[] RESP_OCR_HEADER = {0x49, 0x00};
    private static byte[] RESP_OCR_EMPTY = {0x49, 0x00, 0x03, 0x0d, 0x0d, 0x0d};

    private static void sendCommand(SerialPort sp, byte[] cmd) {
        sp.writeBytes(cmd, cmd.length);
    }

    private static void assertCommand(SerialPort sp, byte[] cmd, byte[] assertion) throws OCRException, InterruptedException {
        sp.writeBytes(cmd, cmd.length);
        Thread.sleep(100);

        byte[] readBuffer = new byte[assertion.length];
        int numRead = sp.readBytes(readBuffer, readBuffer.length);

        if (numRead == -1) {
            throw new OCRException(String.format("Response empty, expected: %s", Arrays.toString(assertion)));
        }

        readBuffer = Arrays.copyOf(readBuffer, numRead);
        if (!Arrays.equals(readBuffer, assertion)) {
            throw new OCRException(String.format("Response numread false %d %s != %s", numRead, Arrays.toString(readBuffer), Arrays.toString(assertion)));
        }
    }

    private static boolean startsWith(byte[] src, byte[] prefix) {
        if (src.length < prefix.length) {
            return false;
        }

        for(int i = 0; i < prefix.length; ++i) {
            if (src[i] != prefix[i]) {
                return false;
            }
        }

        return true;
    }

    public static byte[] read(String path) throws OCRException, InterruptedException {
        byte[] result = null;
        if (!Files.isReadable(Path.of(path))) {
            throw new OCRException("OCR serial interface is not readable");
        }

        SerialPort sp = SerialPort.getCommPort(path);

        sp.setBaudRate(115200);
        sp.openPort();
        try {
            sp.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING, 500, 0);

            assertCommand(sp, CMD_DEACTIVATE_CONTINUOUS, RESP_DEACTIVATE_CONTINUOUS);
            assertCommand(sp, CMD_ACTIVATE_DETECTION, RESP_ACTIVATE_DETECTION);

            for (int i = 0; i < 10; ++i) {
                sendCommand(sp, CMD_INQUIRE);
                byte[] readBuffer = new byte[256];
                int numRead = sp.readBytes(readBuffer, readBuffer.length);

                if (!startsWith(readBuffer, RESP_OCR_HEADER)) {
                    Thread.sleep(10);
                    continue;
                }

                if (startsWith(readBuffer, RESP_OCR_EMPTY)) {
                    continue;
                }

                int contentLen = numRead - 3;
                if (contentLen != readBuffer[2]) {
                    System.err.println("Warning: OCR packet len not correct");
                    continue;
                }

                result = Arrays.copyOfRange(readBuffer, 3, numRead);
                break;
            }

            System.out.println(Arrays.toString(result));
        } finally {
            sp.closePort();
        }

        return result;
    }
}
