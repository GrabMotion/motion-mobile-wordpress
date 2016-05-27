<div class="login-form-container">

	<?php
	
	
		require_once __DIR__ . '/vendor/autoload.php';
		
		use Parse\ParseClient;
		use Parse\ParseQuery;
		use Parse\ParseObject;
		use Parse\ParseUser;
		use Parse\ParseFile;
		
		ParseClient::initialize('xoDuSZwB8zeftGBwICUwVkTMpWCqLql0sre3X8r2', 'R1kB7O10vyZEqDFVwRWnM4E2HmDulJKa1MsBXgBg', 'dDnAppR2RBxSIZH2NBN6LdmvrNL4ciFrpshXHSoE');
    

	?>

	<?php if ( $attributes['show_title'] ) : ?>
		<h2><?php _e( 'Sign In', 'personalize-login' ); ?></h2>
	<?php endif; ?>

	<!-- Show errors if there are any -->
	<?php if ( count( $attributes['errors'] ) > 0 ) : ?>
		<?php foreach ( $attributes['errors'] as $error ) : ?>
			<p class="login-error">
				<?php echo $error; ?>
			</p>
		<?php endforeach; ?>
	<?php endif; ?>

	<!-- Show logged out message if user just logged out -->
	<?php if ( $attributes['logged_out'] ) : ?>
		<p class="login-info">
			<?php _e( 'You have signed out. Would you like to sign in again?', 'personalize-login' ); ?>
		</p>
	<?php endif; ?>

	<?php
		wp_login_form(
			array(
				'label_username' => __( 'Email', 'personalize-login' ),
				'label_log_in' => __( 'Sign In', 'personalize-login' ),
				'redirect' => $attributes['redirect'],
			)
		);
	?>

	
	
	<!--<a class="forgot-password" href="<?php echo wp_lostpassword_url(); ?>">-->
		<?php //_e( 'Forgot your password?', 'personalize-login' ); ?>
	<!--</a>-->
	
	

</div>