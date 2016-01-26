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

			<?php get_template_part( 'content', 'client' ); ?>

            <div class="entry-content">

            <?php echo "<H2><b>CLIENT</b><br><br>" . get_the_title( $post->ID ) . "</H2><br><br>" ?>

            <?php $clientname   = get_post_meta($post->ID, "client_name", true); ?>
            <?php $decription   = get_post_meta($post->ID, "client_description", true); ?>
            <?php $authorpost   = get_the_author(); ?>
            <?php $time         = get_the_date() . ' ' . get_the_time('', $post->ID); ?>

            <?php echo '<b>CLIENT </b>      : ' . $clientname . '<br>' ?>
            <?php echo '<b>DESCRIPTION </b> : ' . $decription . '<br>' ?>
            <?php echo '<b>AUTHOR </b>      : ' . $authorpost . '<br>' ?>
            <?php echo '<b>POST TIME </b>        : ' . $time . '<br><br>' ?>


            <?php
            
                // Show childs
                global $post;
                
                $args = array(
                              'post_type'    => 'location',
                              'meta_key'     => 'post_parent',
                              'meta_value'   => $post->ID,
                              'meta_compare' => '=',
                              );
                $the_query = new WP_Query( $args );
                
                // The Loop
                if ( $the_query->have_posts() ) {
                    echo '<H2><b>LOCATIONS</b></H2>';
                    echo '<ul>';
                    
                    while ( $the_query->have_posts() ) {
                        $the_query->the_post();
                        echo "<li><a href='" . get_permalink() . "' target='_blank'>" .   get_the_title() . "</a></li>";
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