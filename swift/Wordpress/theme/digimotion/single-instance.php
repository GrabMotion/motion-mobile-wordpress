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

			<?php get_template_part( 'content', 'instance' ); ?>

            <div class="entry-content">

            <?php

                $dayid          = get_post_meta($post->ID, "post_parent", true);
                $recognitionid  = get_post_meta($dayid, "post_parent", true);
                $cameraid       = get_post_meta($recognitionid, "post_parent", true);
                $terminalid     = get_post_meta($cameraid, "post_parent", true);
                $locationid     = get_post_meta($terminalid, "post_parent", true);
                $clientid       = get_post_meta($locationid, "post_parent", true);
                
                echo "<H2><b>INSTANCE  </b><br><br>" . get_the_title( $post->ID ) . "</H2>" .
                "Day " .
                "<a href='" . get_post_permalink($dayid) . "'target='_blank'>" . get_the_title( $dayid ) . "</a>" .
                ", recognition " .
                "<a href='" . get_post_permalink($recognitionid) . "'target='_blank'>" . get_the_title( $recognitionid ) . "</a>" .
                ", camera " .
                "<a href='" . get_post_permalink($cameraid) . "'target='_blank'>" . get_the_title( $cameraid ) . "</a>" .
                ", terminal " .
                "<a href='" . get_post_permalink($terminalid) . "'target='_blank'>" . get_the_title( $terminalid ) . "</a>" .
                ", location " .
                "<a href='" . get_post_permalink($locationid) . "'target='_blank'>" . get_the_title( $locationid ) . "</a>" .
                ", client " .
                "<a href='" . get_post_permalink($clientid) . "'target='_blank'>" . get_the_title( $clientid ) . "</a>." .
                "<br><br>";
                
            ?>


            <?php $number       = get_post_meta($post->ID, "instance_number", true); ?>
            <?php $begin          = get_post_meta($post->ID, "instance_begintime", true); ?>
            <?php $end          = get_post_meta($post->ID, "instance_endtime", true); ?>

            <?php $code      = get_post_meta($post->ID, "instance_code", true); ?>
            <?php $media    = get_post_meta($post->ID, "instance_media_url", true); ?>


            <?php echo '<b> NUMBER </b>                 : ' . $number . '<br>' ?>
            <?php echo '<b> BEGIN TIME </b>             : ' . $begin . '<br>' ?>
            <?php echo '<b> END TIME </b>               : ' . $end . '<br><br>' ?>

            <?php echo '<b> CODE </b>                   : ' . $code . '<br>' ?>
            <?php echo '<b> MEDIA </b>                  : '
                . "<a href='" . $media . "' target='_blank'>" .   $media . "</a>"
                . '<br><br>' ?>

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