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

			<?php get_template_part( 'content', 'location' ); ?>

            <div class="entry-content">

            <?php
                
                $clientid   = get_post_meta($post->ID, "post_parent", true);
                echo "<H2><b>LOCATION</b> " . get_the_title( $post->ID ) . "</H2>" .
                "Client " .
                "<a href='" . get_post_permalink($clientid) . "'target='_blank'>" . get_the_title( $clientid ) . "</a>." .
                "<br><br>";

            ?>


            <?php $lat  = get_post_meta($post->ID, "locaton_latitude", true); ?>
            <?php $long = get_post_meta($post->ID, "locaton_longitude", true); ?>
            <?php $time = get_the_date() . ' ' . get_the_time('', $post->ID); ?>

            <?php echo '<b> COUNTRY </b>    : ' . get_post_meta($post->ID, "locaton_country", true) . '<br>' ?>
            <?php echo '<b> CITY </b>       : ' . get_post_meta($post->ID, "locaton_city", true) . '<br>' ?>
            <?php echo '<b> LATITUDE </b>   : ' . $lat . '<br>' ?>
            <?php echo '<b> LONGITUDE </b>  : ' . $long . '<br>' ?>
            <?php echo '<b> POST TIME </b>  : ' . $time . '<br><br>' ?>

            <?php echo "<img src='http://maps.google.com/maps/api/staticmap?center=" . $long . "," . $lat . "&zoom=8&size=400x300&sensor=false' style='width: 300px; height: 300px;' /> <br><br>"; ?>

            <?php
            
                // Show childs
                global $post;
                
                $args = array(
                              'post_type'    => 'terminal',
                              'meta_key'     => 'post_parent',
                              'meta_value'   => $post->ID,
                              'meta_compare' => '=',
                              );
                $the_query = new WP_Query( $args );
                
                // The Loop
                if ( $the_query->have_posts() )
                {
                    echo '<H2><b>TERMINALS</b></H2>';
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