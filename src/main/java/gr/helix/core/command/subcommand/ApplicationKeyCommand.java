package gr.helix.core.command.subcommand;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

import gr.helix.core.command.SubCommand;
import gr.helix.core.common.model.ApplicationException;
import gr.helix.core.common.model.ApplicationKey;
import gr.helix.core.common.repository.IApplicationKeyRepository;

@Component("key")
public class ApplicationKeyCommand implements SubCommand {

    private static final String       CREATE_COMMAND = "create";

    private static final String       DELETE_COMMAND = "delete";

    private static final String       REVOKE_COMMAND = "revoke";

    private static final String       LIST_COMMAND   = "list";

    private static Logger             logger         = LoggerFactory.getLogger(ApplicationKeyCommand.class);

    @Autowired
    private MessageSource             messageSource;

    @Autowired
    private IApplicationKeyRepository applicationKeyRepository;

    @Override
    public void run(Map<String, List<String>> args) {
        System.out.println("Action is missing");
    }

    @Override
    public void run(String subcommandName, Map<String, List<String>> options) {
        try {
            switch (subcommandName) {
                case CREATE_COMMAND:
                    this.createKey(options);
                    break;
                case DELETE_COMMAND:
                    this.deleteKey(options);
                    break;
                case REVOKE_COMMAND:
                    this.revokeKey(options);
                    break;
                case LIST_COMMAND:
                    this.listKeys(options);
                    break;
                default:
                    System.out.println("Action is not supported\n" + this.getSummary());
                    break;
            }
        } catch(final ApplicationException ex) {
            final String message = ex.withFormattedMessage(this.messageSource, Locale.ENGLISH).getMessage();
            System.out.println(message);
        } catch(final Exception ex) {
            logger.error("The subcommand has failed: {}", ex.getMessage());
            System.out.println(ex.getMessage());
        }
    }

    @Override
    public void run(String subcommandName, String a2, Map<String, List<String>> options) {
        this.run(subcommandName, options);
    }

    @Override
    public void run(String subcommandName, String a2, String a3, Map<String, List<String>> options) {
        this.run(subcommandName, options);
    }

    @Override
    public String getSummary() {
        final List<String> lines = Arrays.asList(
            "key <action>",
            "key list",
            "key create --client=<client id>",
            "key delete --client=<client id>",
            "key revoke --client=<client id>"
        );

        return String.join("\n", lines);
    }

    @Override
    public String getDescription() {
        return "Manage application keys";
    }

    private void listKeys(Map<String, List<String>> options) {
        final List<ApplicationKey> keys = this.applicationKeyRepository.getAll();
        System.out.println(String.format("%-32s %-64s %s", "Client Id", "Application Key", "Revoked"));
        System.out.println(String.format("%-32s %-64s %s", "---------", "---------------", "-------"));
        for (final ApplicationKey key : keys) {
            System.out.println(String.format("%-32s %-64s %s", key.getClientId(), key.getKey(), Boolean.toString(key.getRevoked())));
        }
    }

    private void createKey(Map<String, List<String>> options) {
        final String clientId = this.getClientId(options);
        if (StringUtils.isBlank(clientId)) {
            System.out.println("Client id is missing");
            return;
        }

        this.applicationKeyRepository.create(clientId);
    }

    private void deleteKey(Map<String, List<String>> options) {
        final String clientId = this.getClientId(options);
        if (StringUtils.isBlank(clientId)) {
            System.out.println("Client id is missing");
            return;
        }

        this.applicationKeyRepository.delete(clientId);
    }

    private void revokeKey(Map<String, List<String>> options) {
        final String clientId = this.getClientId(options);
        if (StringUtils.isBlank(clientId)) {
            System.out.println("Client id is missing");
            return;
        }

        this.applicationKeyRepository.revoke(clientId);
    }

    private String getClientId(Map<String, List<String>> options) {
        if (!options.containsKey("client")) {
            return null;
        }
        final List<String> clients = options.get("client");
        if (clients.isEmpty()) {
            return null;
        }
        return clients.get(0);
    }

}
