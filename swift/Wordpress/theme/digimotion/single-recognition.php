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

			<?php get_template_part( 'content', 'recognition' ); ?>

            <div class="entry-content">

            <?php
                
                $cameraid       = get_post_meta($post->ID, "post_parent", true);
                $terminalid     = get_post_meta($cameraid, "post_parent", true);
                $locationid     = get_post_meta($terminalid, "post_parent", true);
                $clientid       = get_post_meta($locationid, "post_parent", true);
                
                echo "<H2><b>RECOGNITION JOB </b> " . get_the_title( $post->ID ) . "</H2>" .
                "Camera " .
                "<a href='" . get_post_permalink($cameraid) . "'target='_blank'>" . get_the_title( $cameraid ) . "</a>" .
                ", terminal " .
                "<a href='" . get_post_permalink($terminalid) . "'target='_blank'>" . get_the_title( $terminalid ) . "</a>" .
                ", location " .
                "<a href='" . get_post_permalink($locationid) . "'target='_blank'>" . get_the_title( $locationid ) . "</a>" .
                ", client " .
                "<a href='" . get_post_permalink($clientid) . "'target='_blank'>" . get_the_title( $clientid ) . "</a>." .
                "<br><br>";
                
            ?>


            <?php $name         = get_post_meta($post->ID, "recognition_name", true); ?>
            <?php $codename     = get_post_meta($post->ID, "recognition_codename", true); ?>

            <?php $region       = get_post_meta($post->ID, "recognition_region", true); ?>
            <?php $delay        = get_post_meta($post->ID, "recognition_delay", true); ?>
            <?php $runstartup   = get_post_meta($post->ID, "recognition_runatstartup", true); ?>
            <?php $hascron      = get_post_meta($post->ID, "recognition_hascron", true); ?>
            <?php $interval      = get_post_meta($post->ID, "recognition_interval", true); ?>
            <?php $screen       = get_post_meta($post->ID, "recognition_screen", true); ?>

            <?php
                $running      = get_post_meta($post->ID, "recognition_running", true);
                if ($running=="0")
                {
                    $running = "YES";
                } else
                {
                    $running = "NO";
                }
                ?>

            <?php $media_url       = get_post_meta($post->ID, "recognition_media_url", true); ?>

            <?php $created      = get_post_meta($post->ID, "recognition_keepalive_time", true); ?>
            <?php $keepalive    = get_post_meta($post->ID, "recognition_created", true); ?>
            <?php $time         = get_the_date() . ' ' . get_the_time('', $post->ID); ?>


            <?php echo '<b> NAME </b>                   : ' . $name . '<br>' ?>
            <?php echo '<b> CODE NAME </b>              : ' . $codename . '<br><br>' ?>

            <?php echo '<b> REGION </b>                 : ' . $region . '<br>' ?>
            <?php echo '<b> DELAY </b>                  : ' . $delay . '<br>' ?>
            <?php echo '<b> RUN STARTUP </b>            : ' . $runstartup . '<br>' ?>
            <?php echo '<b> HAS CRON </b>               : ' . $hascron . '<br>' ?>
            <?php echo '<b> INTERVAL </b>               : ' . $interval . '<br>' ?>
            <?php echo '<b> SCREEN </b>                 : ' . $screen . '<br><br>' ?>

            <?php echo '<b> RUNNING </b>                : ' . $running . '<br>' ?>
            <?php echo '<b> MEDIA </b>                  : '
                . "<a href='" . $media_url . "' target='_blank'>" .   $media_url . "</a>"
                . '<br><br>' ?>

            <?php echo '<b> POST CREATED </b>           : ' . $created . '<br>' ?>
            <?php echo '<b> KEEP ALIVE </b>             : ' . $keepalive . '<br>' ?>
            <?php echo '<b> POST TIME </b>              : ' . $time . '<br><br>' ?>

            <?php
            
                // Show childs
                global $post;
                
                $args = array(
                              'post_type'    => 'day',
                              'meta_key'     => 'post_parent',
                              'meta_value'   => $post->ID,
                              'meta_compare' => '=',
                              );
                $the_query = new WP_Query( $args );
                
                // The Loop
                if ( $the_query->have_posts() )
                {
                    echo '<H2><b>DAYS</b></H2>';
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