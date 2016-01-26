<?php
/**
 * The Template for displaying all single posts.
 *
 * @package Digimotion Child of Simone
 */
    
get_header(); ?>

<?php include 'digimotion-functions.php';?>

	<div id="primary" class="content-area">

        <main id="main" class="site-main" role="main">

		<?php while ( have_posts() ) : the_post(); ?>

			<?php get_template_part( 'content', 'terminal' ); ?>

            <div class="entry-content">

            <?php
                
                $locationid  = get_post_meta($post->ID, "post_parent", true);
                $clientid = get_post_meta($locationid, "post_parent", true);
                
                echo "<H2><b>TEMRINAL</b><br><br>" . get_the_title( $post->ID ) . "</H2><br>" .
                "Location " .
                "<a href='" . get_post_permalink($locationid) . "'target='_blank'>" . get_the_title( $locationid ) . "</a>" .
                ", client " .
                "<a href='" . get_post_permalink($clientid) . "'target='_blank'>" . get_the_title( $clientid ) . "</a>." .
                "<br><br>";
                
            ?>


            <?php $ipnumber     = get_post_meta($post->ID, "terminal_ipnumber", true); ?>
            <?php $publicip     = get_post_meta($post->ID, "terminal_public_ipnumber", true); ?>
            <?php $macaddress     = get_post_meta($post->ID, "terminal_macaddress", true); ?>

            <?php $hostname     = get_post_meta($post->ID, "terminal_hostname", true); ?>
            <?php $networkprovider  = get_post_meta($post->ID, "terminal_network_provider", true); ?>

            <?php $uptime       = get_post_meta($post->ID, "terminal_uptime", true); ?>
            <?php $starttime     = get_post_meta($post->ID, "terminal_starttime", true); ?>

            <?php $model        = get_post_meta($post->ID, "terminal_model", true); ?>
            <?php $hardware     = get_post_meta($post->ID, "terminal_hardware", true); ?>
            <?php $serial       = get_post_meta($post->ID, "terminal_serial", true); ?>
            <?php $revision     = get_post_meta($post->ID, "terminal_revision", true); ?>

            <?php $disktotal    = get_post_meta($post->ID, "terminal_disk_total", true); ?>
            <?php $diskused     = get_post_meta($post->ID, "terminal_disk_used", true); ?>
            <?php $diskavailable    = get_post_meta($post->ID, "terminal_disk_available", true); ?>
            <?php $diskperused  = get_post_meta($post->ID, "terminal_disk_percentage_used", true); ?>

            <?php $temperature  = get_post_meta($post->ID, "terminal_temperature", true) . "'C" ; ?>

            <?php $created       = get_post_meta($post->ID, "terminal_keepalive_time", true); ?>
            <?php $keepalive    = get_post_meta($post->ID, "terminal_created", true); ?>
            <?php $time         = get_the_date() . ' ' . get_the_time('', $post->ID); ?>

            <?php echo '<b> LOCAL IP NUMBER </b>        : ' . $ipnumber . '<br>' ?>
            <?php echo '<b> PUBLIC IP NUMBER </b>       : ' . $publicip . '<br>' ?>
            <?php echo '<b> MAC ADDRESS </b>            : ' . $macaddress . '<br><br>' ?>

            <?php echo '<b> HOST NAME </b>              : ' . $hostname . '<br>' ?>
            <?php echo '<b> NETWORK PROVIDER </b>       : ' . $networkprovider . '<br><br>' ?>

            <?php echo '<b> UP TIME </b>                : ' . $uptime . '<br>' ?>
            <?php echo '<b> START TIME </b>             : ' . $starttime . '<br><br>' ?>

            <?php echo '<b> MODEL </b>                  : ' . $model . '<br>' ?>
            <?php echo '<b> HARDWARE </b>               : ' . $hardware . '<br>' ?>
            <?php echo '<b> SERIAL </b>                 : ' . $serial . '<br>' ?>
            <?php echo '<b> REVISION </b>               : ' . $revision . '<br><br>' ?>

            <?php echo '<b> DISK TOTAL </b>             : ' . $disktotal . '<br>' ?>
            <?php echo '<b> DISK USED </b>              : ' . $diskused . '<br>' ?>
            <?php echo '<b> DISK AVAILABLE </b>         : ' . $diskavailable . '<br>' ?>
            <?php echo '<b> DISK PERCENTAGE USED </b>   : ' . $diskperused . '<br><br>' ?>

            <?php echo '<b> TEMPERATURE </b>            : ' . $temperature . '<br><br>' ?>

            <?php echo '<b> POST CREATED </b>           : ' . $created . '<br>' ?>
            <?php echo '<b> KEEP ALIVE </b>             : ' . $keepalive . '<br>' ?>
            <?php echo '<b> POST TIME </b>              : ' . $time . '<br><br>' ?>

            <?php
            
                // Show childs
                global $post;
                
                $args = array(
                              'post_type'    => 'camera',
                              'meta_key'     => 'post_parent',
                              'meta_value'   => $post->ID,
                              'meta_compare' => '=',
                              );
                $the_query = new WP_Query( $args );
                
                // The Loop
                if ( $the_query->have_posts() )
                {
                    echo '<H2><b>CAMERAS</b></H2>';
                    echo '<ul>';
                    while ( $the_query->have_posts() )
                    {
                        $the_query->the_post();
                        echo "<li><a href='" . get_permalink() . "' target='_blank'>" .   get_the_title() . "</a>";
                    }
                    echo '</ul>';
                } else {
                    // no posts found
                }
                /* Restore original Post Data */
                wp_reset_postdata();
                
            ?>

            </div><!-- .entry-content -->

			<?php /*simone_post_nav();*/ ?>

			<?php
				// If comments are open or we have at least one comment, load up the comment template
				//if ( comments_open() || '0' != get_comments_number() ) :
				//	comments_template();
				//endif;
			?>

		<?php endwhile; ?>

		</main><!-- #main -->
	</div><!-- #primary -->

<?php /*get_sidebar();*/ ?>
<?php get_footer(); ?>