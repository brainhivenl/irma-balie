package mrtdscanner;

public class Config {
    public String ocrPath;
    public String clientHost;

    public static Config readFromEnv() {
        Config config = new Config();

        config.ocrPath = System.getenv("MRTDSCANNER_OCRPATH");
        config.clientHost = System.getenv("MRTDSCANNER_CLIENTHOST");

        if (config.ocrPath == null) {
            config.ocrPath = "/dev/serial/by-id/usb-ELYCTIS_IDBOX_ONE_0000-if01";
        }

        if (config.clientHost == null) {
            config.clientHost = "http://client.balie.test.tweede.golf";
        }

        return config;
    }
}
