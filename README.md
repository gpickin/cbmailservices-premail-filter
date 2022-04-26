# CBMailServices PreMail Filter

This is a tool that fires on the PreMail interception point, allowing you to filter emails being sent from your application using CBMailServices.

This supports multiple enviromnents, so you can turn on the filter for just one environment, or multiple environments, and you can choose to override the global settings, with settings for just one environment, whether that is allowed email addresses, or required email addresses.

More information on CBMailServices - https://coldbox-mailservices.ortusbooks.com/

## Supported ENV Keys

Configuration of this module is controlled by Environment Variables. Below is a list of the current environment variables available and their functionality.

### Which Environments should this PreMail Filter fire for?

A comma separated list of environments to activate the filter for. Example = 'development,staging'

`CBMAILSERVICES_PREMAIL_ENVIRONMENTS` - Default '' - none

### Who is allowed to recieve emails

List of emails that are allowed to recieve emails. This filters TO, CC, and BCC emails.

`CBMAILSERVICES_PREMAIL_ALLOWED_EMAIL_LIST` - Default '' `CBMAILSERVICES_PREMAIL_ALLOWED_EMAIL_LIST_${ENVIRONMENT}` - Environment Specific - Defaults to Global Setting

### Emails that must be sent to

List of emails that should be added to every outgoing email. This allows you to ensure all of these emails receive every email sent from your system. This is great for testing or development environments.

`CBMAILSERVICES_PREMAIL_REQUIRED_EMAIL_LIST` - Default '' `CBMAILSERVICES_PREMAIL_REQUIRED_EMAIL_LIST_${ENVIRONMENT}` - Environment Specific - Defaults to Global Setting

### If there are no recipients, who should the email be sent to, by default.

Default email to use if there are no remaining TO email addresses exist after the allowed list is filtered, and any required emails are added.

`CBMAILSERVICES_PREMAIL_DEFAULT_EMAIL_LIST` - Default '' `CBMAILSERVICES_PREMAIL_DEFAULT_EMAIL_LIST_${ENVIRONMENT}` - Environment Specific - Defaults to Global Setting

### Enable the Subject prefex for all emails sent

This injects a prefix into the subject line for every email sent. If you do not set it, it will default to '${ENVIRONMENT}:'

`CBMAILSERVICES_PREMAIL_SUBJECT_ENABLE_PREFIX` - Boolean (default true)
`CBMAILSERVICES_PREMAIL_SUBJECT_ENABLE_PREFIX_${ENVIRONMENT}` - Environment Specific - Defaults to Global Setting

### AppName - For Default Subject Prefix

The App Name to be used in the Default Subject Prefix -

`CBMAILSERVICES_PREMAIL_APPNAME` - Appname - Default ''
`CBMAILSERVICES_PREMAIL_APPNAME_${ENVIRONMENT}` - Environment Specific - Defaults to Global Setting

### Subject Prefix - Overrides the default

Text to use for the Prefix for every email that is sent through this filter.

`CBMAILSERVICES_PREMAIL_SUBJECT_PREFIX_TEXT` - Default `${APPNAME} ${ENVIRONMENT}: `
`CBMAILSERVICES_PREMAIL_SUBJECT_PREFIX_TEXT_${ENVIRONMENT}` - Environment Specific - Defaults to Global Setting
