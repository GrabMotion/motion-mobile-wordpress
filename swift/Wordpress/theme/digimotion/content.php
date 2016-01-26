<?php
/**
 * @package Simone
 */
?>

<article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
    <?php
    if( $wp_query->current_post == 0 && !is_paged() && is_front_page() ) { // Custom template for the first post on the front page
        if (has_post_thumbnail()) {
            echo '<div class="front-index-thumbnail clear">';
            echo '<div class="image-shifter">';
            echo '<a href="' . get_permalink() . '" title="' . __('Read ', 'simone') . get_the_title() . '" rel="bookmark">';
            the_post_thumbnail();
            echo '</a>';
            echo '</div>';
            echo '</div>';
        }
        echo '<div class="index-box';
        if (has_post_thumbnail()) { echo ' has-thumbnail'; };
        echo '">';
    } else {
        echo '<div class="index-box">';
        if (has_post_thumbnail()) {
            echo '<div class="small-index-thumbnail clear">';
            echo '<a href="' . get_permalink() . '" title="' . __('Read ', 'simone') . get_the_title() . '" rel="bookmark">';
            echo the_post_thumbnail('index-thumb');
            echo '</a>';
            echo '</div>';
        }

    }
    ?>
	<header class="entry-header clear">
            <?php

                // Display a thumb tack in the top right hand corner if this post is sticky
                if (is_sticky()) {
                    echo '<i class="fa fa-thumb-tack sticky-post"></i>';
                }

                /* translators: used between list items, there is a space after the comma */
                $category_list = get_the_category_list( __( ', ', 'simone' ) );

                if ( simone_categorized_blog() ) {
                    echo '<div class="category-list">' . $category_list . '</div>';
                }
            ?>
    
		<?php if ( 'post' == get_post_type() ) : ?>
		<div class="entry-meta">
			<?php simone_posted_on(); ?>
                        <?php
                        if ( ! post_password_required() && ( comments_open() || '0' != get_comments_number() ) ) {
                            echo '<span class="comments-link">';
                            comments_popup_link( __( 'Leave a comment', 'simone' ), __( '1 Comment', 'simone' ), __( '% Comments', 'simone' ) );
                            echo '</span>';
                        }
                        ?>
                        <?php edit_post_link( sprintf( ' | %s', __( 'Edit', 'simone' ) ), '<span class="edit-link">', '</span>' ); ?>
		</div><!-- .entry-meta -->
		<?php endif; ?>
	</header><!-- .entry-header -->



    </div>
</article><!-- #post-## -->
