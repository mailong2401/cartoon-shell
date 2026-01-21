var wpa_field_name, wpa_unique_id, wpa_add_test, wpa_hidden_field;

jQuery(document).ready(function(){	
	wpa_field_name 	= wpa_field_info.wpa_field_name;
	wpa_unique_id 	= wpa_field_info.wpa_field_value;
	wpa_add_test 	= wpa_field_info.wpa_add_test;

	wpa_hidden_field 			= "<div id='altEmail_container' class='altEmail_container'><label for='alt_s'>Alternative:</label><input type='text' id='alt_s' name='alt_s' ></div><span class='wpa_hidden_field' style='display:none;height:0;width:0;'><label>WPA <input type='text' name='"+wpa_field_name+"' value='"+wpa_unique_id+"' /></label></span>";

	wpa_add_honeypot_field();

	if (typeof wpae_add_honeypot_field == 'function') { // IF EXTENDED version exists.
	  wpae_add_honeypot_field(); 
	}
	
	if (wpa_add_test == 'yes'){
		wpa_add_test_block();
	}
});

function wpa_act_as_spam(){
	actiontype = jQuery('span.wpa-button').data('actiontype');
	if (actiontype == 'remove'){
		wpa_remove_honeypot_field();
		jQuery('span.wpa-button').data('actiontype','add');
		jQuery('span.wpa-button').html('Acting as Spam Bot');
	} else {
		wpa_add_honeypot_field();
		jQuery('span.wpa-button').data('actiontype','remove');
		jQuery('span.wpa-button').html('Act as Spam Bot');
	}
}

function wpa_add_honeypot_field(){
	
	// Combined form selectors
	var allFormSelectors = [
	    // Main forms
	    'form.wpcf7-form, .wpcf7 form',        // CONTACT FORM 7
	    'form.wpforms-form',                   // WPForms
	    '.gform_wrapper form',                 // Gravity Forms
	    '.frm_forms form',                     // Formidable Forms
	    '.caldera-grid form',                  // Caldera Forms
	    '.wp-block-toolset-cred-form form',    // Toolset Forms
	    'form.cred-user-form',                 // Toolset Forms
	    'form.cred-form',                      // Toolset Forms
	    'form.et_pb_contact_form',             // Divi Form
	    'form.fb_form',                        // Divi Form Builder - Divi Engine
	    'form.elementor-form',                 // Elementor
	    'form.form-contribution',              // WooCommerce Reviews Pro
	    'form.cart',                           // WooCommerce Cart
	    'form#learn-press-checkout-form',      // LearnPress Checkout Form

	    'form.wpa_form',						   // Generic Class
	    '.wpa_form form',					   // Generic Class	

	    '.um-form form',						// Ulimate Membership Form

	    // Login forms
	    'form.spectra-pro-login-form',         // SPECTRA LOGIN FORM
	    'form#loginform',                      // Default Login Form
	    'form#edd_login_form',                 // EDD LOGIN FORM
	    'form.uwp-login-form',                 // USER WP LOGIN FORM
	    '.et_pb_login_form form',			   // For Elementor login form
	    'form.eael-login-form',				   // essential-addons login form
	    'form.user-registration-form-login',   // User Registration & Membership for WordPress

	    'form#lostpasswordform',			   // Lost Password Form
	    'form.lost_reset_password',            // Tutor Password Form
	    'form.ur_lost_reset_password',    	   // User Registration & Membership for WordPress	    

	    
	    //Registration Forms
	    'form.register',            		   // User Registration & Membership for WordPress

	    // Comment forms
	    'form#commentform',                    // WP Comment with ID
	    'form.ast-commentform',                // Astra Comment Form with class
	    'form#fl-comment-form',                // Beaver Builder Theme Form with ID
	    'form.comment-form',                   // WP Comment with class
	    '.review-form form',                   // LearnPress Review
	    'form#edd-reviews-form',               // EDD Reviews with ID
	    'form.wpr-comment-form',				

	    // BBPress forms
	    '.bbp-topic-form form',                // BBPress Topic Form
	    '.bbp-reply-form form'                 // BBPress Reply Form
	];

	// Append hidden field to all forms in the combined selector list
	jQuery(allFormSelectors.join(', ')).append(wpa_hidden_field);
	
	// FOR FLUENT FORMS
	jQuery('form.frm-fluent-form').append(wpa_hidden_field); // FOR Fluent Forms
	jQuery('.ff_conv_app').append(wpa_hidden_field); // FOR Fluent Convertional Forms

	if (typeof fluent_forms_global_var_1 !== 'undefined') { // QUICK HACK FOR FLUENT FORMS CONVERSIONAL
    	fluent_forms_global_var_1.extra_inputs[wpa_field_name] = wpa_unique_id;
    	fluent_forms_global_var_1.extra_inputs['alt_s'] = '';
	}
	// EOF FLUENT FORMS 

	jQuery('input.wpa_initiator').each(function() {
	    var $form = jQuery(this).closest('form'); // Get the parent form of input.wpa_initiator
	    
	    // Check if wpa_hidden_field exists in the form, if not, insert it after input.wpa_initiator
	    if ($form.find('.wpa_hidden_field').length === 0) {
	        jQuery(wpa_hidden_field).insertAfter(this);
	    }
	});
	
}

function wpa_add_test_block(){
	checkingTest = '<div class="wpa-test-msg"><strong>WP Armour ( Only visible to site administrators. Not visible to other users. )</strong><br />This form has a honeypot trap enabled. If you want to act as spam bot for testing purposes, please click the button below.<br/><span class="wpa-button" onclick="wpa_act_as_spam()" data-actiontype="remove">Act as Spam Bot</span></div>';
	jQuery('.wpa-test-msg').remove(); // Clear First
	jQuery('span.wpa_hidden_field').after(checkingTest);
}

function wpa_remove_honeypot_field(){
	jQuery('.wpa_hidden_field').remove();
	jQuery('#altEmail_container, .altEmail_container').remove();

	if (typeof fluent_forms_global_var_1 !== 'undefined') { 
    	delete fluent_forms_global_var_1.extra_inputs[wpa_field_name];
    	delete fluent_forms_global_var_1.extra_inputs['alt_s'];
	}
}