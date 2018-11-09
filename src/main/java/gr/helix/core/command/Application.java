package gr.helix.core.command;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication(
    scanBasePackageClasses = {
        gr.helix.core.common.repository._Marker.class,
        gr.helix.core.command._Marker.class,
        gr.helix.core.command.config._Marker.class,
        gr.helix.core.command.subcommand._Marker.class,
    }
)
@EntityScan(
    basePackageClasses = {
        gr.helix.core.common.domain._Marker.class,
    }
)
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

}