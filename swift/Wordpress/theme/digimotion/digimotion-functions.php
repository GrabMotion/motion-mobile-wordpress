<?php
    
    function get_posts_children($parent_id)
    {
        $children = array();
        
        // grab the posts children
        $posts = get_posts( array( 'client' => -1, 'post_status' => 'publish', 'post_type' => 'location', 'post_parent' => $parent_id, 'suppress_filters' => false ));
        
        // now grab the grand children
        foreach( $posts as $child )
        {
            // recursion!! hurrah
            $gchildren = get_posts_children($child->ID);
            // merge the grand children into the children array
            if( !empty($gchildren) ) {
                $children = array_merge($children, $gchildren);
            }
        }
        // merge in the direct descendants we found earlier
        $children = array_merge($children,$posts);
        return $children;
    }
?>


