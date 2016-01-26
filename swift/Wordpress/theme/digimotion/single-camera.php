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

			<?php get_template_part( 'content', 'camera' ); ?>

            <div class="entry-content">

            <?php
                
                $terminalid     = get_post_meta($post->ID, "post_parent", true);
                $locationid     = get_post_meta($terminalid, "post_parent", true);
                $clientid       = get_post_meta($locationid, "post_parent", true);
                
                echo "<H2><b>CAMERA </b><br><br> " . get_the_title( $post->ID ) . "</H2>" .
                "Terminal " .
                "<a href='" . get_post_permalink($terminalid) . "'target='_blank'>" . get_the_title( $terminalid ) . "</a>" .
                ", location " .
                "<a href='" . get_post_permalink($locationid) . "'target='_blank'>" . get_the_title( $locationid ) . "</a>" .
                ", client " .
                "<a href='" . get_post_permalink($clientid) . "'target='_blank'>" . get_the_title( $clientid ) . "</a>." .
                "<br><br>";
            ?>


            <?php $camname          = get_post_meta($post->ID, "camera_name", true); ?>
            <?php $camnumber        = get_post_meta($post->ID, "camera_number", true); ?>
            <?php $camcreated       = get_post_meta($post->ID, "camera_keepalive_time", true); ?>
            <?php $camerakeepalive  = get_post_meta($post->ID, "camera_created", true); ?>
            <?php $time         = get_the_date() . ' ' . get_the_time('', $post->ID); ?>

            <?php echo '<b>NAME </b>            : ' . $camname . '<br>' ?>
            <?php echo '<b>NUMBER </b>          : ' . $camnumber . '<br>' ?>
            <?php echo '<b>CREATED </b>         : ' . $camcreated . '<br><br>' ?>
            <?php echo '<b>KEEP ALIVE TIME </b> : ' . $time . '<br>' ?>
            <?php echo '<b>POST TIME </b>       : ' . $time . '<br><br>' ?>

            <?php
            
                // Show childs
                global $post;
                
                $args = array(
                              'post_type'    => 'recognition',
                              'meta_key'     => 'post_parent',
                              'meta_value'   => $post->ID,
                              'meta_compare' => '=',
                              );
                $the_query = new WP_Query( $args );
                
                // The Loop
                if ( $the_query->have_posts() )
                {
                    echo '<H2><b>RECOGNITION JOBS</b></H2>';
                    echo '<ul>';
                    while ( $the_query->have_posts() ) {
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