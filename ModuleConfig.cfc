/**
 * The Module Config for the cbMailServices - PreMail Filter Module which listens for CBMailServices PreMailSend Interceptor Event
 */
component {

	// Module Properties
	this.title          = "cbMailServices - PreMail Filter";

	function configure() {

	}

	/**
	 *
	 *
	 * Supported ENV Keys
	 *
	 * CBMAILSERVICES_PREMAIL_ENVIRONMENTS - A comma separated list of environments to activate for
	 * Example = development,staging
	 *
	 * CBMAILSERVICES_PREMAIL_ALLOWED_EMAIL_LIST - List of emails that are allowed to recieve emails
	 * CBMAILSERVICES_PREMAIL_ALLOWED_EMAIL_LIST_${ENVIRONMENT} - Environment Specific List of emails that are allowed to recieve emails
	 *
	 * CBMAILSERVICES_PREMAIL_REQUIRED_EMAIL_LIST - List of emails that should be added to every outgoing email
	 * CBMAILSERVICES_PREMAIL_REQUIRED_EMAIL_LIST_${ENVIRONMENT} Environment Specific List of emails that should be added to every outgoing email
	 *
	 * CBMAILSERVICES_PREMAIL_DEFAULT_EMAIL_LIST - Default email to use if there are no remaining TO email addresses
	 * CBMAILSERVICES_PREMAIL_DEFAULT_EMAIL_LIST_${ENVIRONMENT} Environment Specific Default email to use if there are no remaining TO email addresses
	 *
	 * CBMAILSERVICES_PREMAIL_SUBJECT_ENABLE_PREFIX - Boolean (default true) indicating whether or not we should prefix the subject with the Environment and colon
	 * CBMAILSERVICES_PREMAIL_SUBJECT_ENABLE_PREFIX_${ENVIRONMENT} - Environment Specific Boolean indicating whether or not we should prefix the subject with the Environment and colon
	 *
	 * CBMAILSERVICES_PREMAIL_APPNAME - Appname - to be used in the default Subject Prefix
	 * CBMAILSERVICES_PREMAIL_APPNAME_${ENVIRONMENT} - Environment Specific Appname - to be used in the default Subject Prefix
	 *
	 * CBMAILSERVICES_PREMAIL_SUBJECT_PREFIX_TEXT - Text to use for the Prefix - defaults to 'EMAIL SENT FROM ${APPNAME} ${ENVIRONMENT}:'
	 * CBMAILSERVICES_PREMAIL_SUBJECT_PREFIX_TEXT_${ENVIRONMENT} - Environment Specific Text to use for the Prefix - defaults to 'EMAIL SENT FROM ${APPNAME} ${ENVIRONMENT}:'
	 *
	 */
	function preMailSend( event, data, buffer, rc, prc ) {
		var enabledEnvironments = getSystemSetting( "CBMAILSERVICES_PREMAIL_ENVIRONMENTS", "" );
		if( enabledEnvironments.listToArray().len() == 0 ){
			return;
		}
		var environment = event.getController().getSetting( "environment" );
		if( !listFindNoCase( enabledEnvironments, environment ) ){
			return;
		}

		var allowedEmailList = getSystemSetting( "CBMAILSERVICES_PREMAIL_ALLOWED_EMAIL_LIST_#UCASE(environment)#", getSystemSetting( "CBMAILSERVICES_PREMAIL_ALLOWED_EMAIL_LIST", "" ) );
		var defaultEmailList = getSystemSetting( "CBMAILSERVICES_PREMAIL_DEFAULT_EMAIL_LIST_#UCASE(environment)#", getSystemSetting( "CBMAILSERVICES_PREMAIL_DEFAULT_EMAIL_LIST", "" ) );
		var requiredEmailList = getSystemSetting( "CBMAILSERVICES_PREMAIL_REQUIRED_EMAIL_LIST_#UCASE(environment)#", getSystemSetting( "CBMAILSERVICES_PREMAIL_REQUIRED_EMAIL_LIST", "" ) );
		var enablePrefix = getSystemSetting( "CBMAILSERVICES_PREMAIL_SUBJECT_ENABLE_PREFIX_#UCASE(environment)#", getSystemSetting( "CBMAILSERVICES_PREMAIL_SUBJECT_ENABLE_PREFIX", true ) );
		var appName = getSystemSetting( "CBMAILSERVICES_PREMAIL_APPNAME_#UCASE(environment)#", getSystemSetting( "CBMAILSERVICES_PREMAIL_APPNAME", "" ) );
		var subjectPrefix = "";
		if( enablePrefix ){
			subjectPrefix = getSystemSetting( "CBMAILSERVICES_PREMAIL_SUBJECT_PREFIX_TEXT_#UCASE(environment)#", getSystemSetting( "CBMAILSERVICES_PREMAIL_SUBJECT_PREFIX_TEXT", "#APPNAME# #ENVIRONMENT#:" ) );
		}

		local.original = {};
		local.final = {
			to: [],
			cc: [],
			bcc: []
		};

		local.original.to = data.mail.getTo();
		local.original.aTo = replaceNoCase( local.original.to, ";", ",", "all" ).listToArray();
		for( local.recipient in local.original.aTo ){
			if(
				listFind(
					allowedEmailList,
					recipient
				)
			){
				local.final.to.append( recipient );
			}
		}

		local.original.cc = data.mail.getCC();
		local.original.aCC = replaceNoCase( local.original.cc, ";", ",", "all" ).listToArray();
		for( local.recipient in local.original.aCC ){
			if(
				listFind(
					allowedEmailList,
					recipient
				)
			){
				local.final.cc.append( recipient );
			}
		}

		local.original.bcc = data.mail.getBCC();
		local.original.aBCC = replaceNoCase( local.original.bcc, ";", ",", "all" ).listToArray();
		for( local.recipient in local.original.aBCC ){
			if(
				listFind(
					allowedEmailList,
					recipient
				)
			){
				local.final.bcc.append( recipient );
			}
		}

		if( requiredEmailList.len() ){
			for( local.recipient in requiredEmailList.listToArray() ){
				if(
					!arrayFind( local.final.to, recipient ) &&
					!arrayFind( local.final.cc, recipient ) &&
					!arrayFind( local.final.bcc, recipient )
				){
					local.final.to.append( recipient );
				}
			}
		}
		if( !local.final.to.len() && defaultEmailList.len() ){
			for( local.recipient in defaultEmailList.listToArray() ){
				if(
					!arrayFind( local.final.to, recipient ) &&
					!arrayFind( local.final.cc, recipient ) &&
					!arrayFind( local.final.bcc, recipient )
				){
					local.final.to.append( recipient );
				}
			}
		}

		data.mail.setTo( arrayToList( local.final.to ) );
		data.mail.setCC( arrayToList( local.final.cc ) );
		data.mail.setBCC( arrayToList( local.final.bcc ) );

		data.mail.setSubject( "#subjectPrefix##data.mail.getSubject()#" );

		return true;
	}

}