<?php
/**
 * @package grabmo_computer_vision
 * @version 1.0
 */
    
/*
Plugin Name: grabmo computer vision
Author: Jose Vigil
Version: 1.2
Text Domain: grabmo-computer-vision
*/
    
    register_activation_hook( __FILE__, 'flush_rewrite' );	
	
    function flush_rewrite()
    {
        flush_rewrite_rules();
        define( 'WP_DEBUG', true );
    }
    
    // CLIENT
    
    //Add Client Custom Type
    add_action( 'init', 'digimotion_client_init' );
    
    //Add Client Fields
    add_action('rest_api_init', 'client_post_parent');
    add_action('rest_api_init', 'client_add_post_children');
    add_action('rest_api_init', 'client_add_client_first_name');
    add_action('rest_api_init', 'client_add_client_last_name');
    add_action('rest_api_init', 'client_add_client_user_name');    
    add_action('rest_api_init', 'client_add_client_email');
    add_action('rest_api_init', 'client_add_client_thumbnail_url');
    add_action('rest_api_init', 'client_add_client_thumbnail_id');
    add_action('rest_api_init', 'client_add_client_location');

    function digimotion_client_init()
    {
        
        $labels = array(
                        'name'               => 'Clients',
                        'singular_name'      => 'Client',
                        'menu_name'          => 'Clients',
                        'name_admin_bar'     => 'Client',
                        'add_new'            => 'Add New',
                        'add_new_item'       => 'Add New Client',
                        'new_item'           => 'New Client',
                        'edit_item'          => 'Edit Client',
                        'view_item'          => 'View Client',
                        'all_items'          => 'All Clients',
                        'search_items'       => 'Search Clients',
                        'parent_item_colon'  => 'Parent Client',
                        'not_found'          => 'No Clients Found',
                        'not_found_in_trash' => 'No Clients Found in Trash'
                        );
        
        $rewrite = array(
                         'slug'                => true,
                         'with_front'          => true,
                         'pages'               => true,
                         'feeds'               => true,
                         );
        
        $args = array(
                      'labels'              => $labels,
                      'public'              => true,
                      'exclude_from_search' => false,
                      'publicly_queryable'  => true,
                      'show_ui'             => true,
                      'show_in_nav_menus'   => true,
                      'show_in_menu'        => true,
                      'show_in_rest'        => true,
                      'add_to_rest'         => true,
                      'show_in_admin_bar'   => true,
                      'menu_position'       => 5,
                      'menu_icon'           => 'dashicons-universal-access-alt',
                      'capability_type'     => 'post',
                      'hierarchical'        => false,
                      'has_archive'         => true,
                      'supports'            => array( 'title', 'editor', 'excerpt', 'author', 'thumbnail', 'custom-fields' ),
                      'rewrite'             => array( 'slug' => 'client' , 'with_front' => true ),
                      'query_var'           => true,
                      );
        
        register_post_type( 'client', $args );
        
    }
    
    //Client Post Parent
    function client_post_parent()
    {
        register_rest_field('client',
                            'post_parent',
                            array(
                                  'get_callback'    => 'get_client_post_parent',
                                  'update_callback' => 'update_client_post_parent',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_client_post_parent($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_post_parent( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Client Post Children
    function client_add_post_children()
    {
        register_rest_field('client',
                            'post_children',
                            array(
                                  'get_callback'    => 'get_client_post_children',
                                  'update_callback' => 'update_client_post_children',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_client_post_children($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_post_children( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Client First Name
    function client_add_client_first_name()
    {
        register_rest_field('client',
                           'client_first_name',
                           array(
                                 'get_callback'    => 'get_client_first_name',
                                 'update_callback' => 'update_client_first_name',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_client_first_name($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_first_name( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Client Last Name
    function client_add_client_last_name()
    {
        register_rest_field('client',
                           'client_last_name',
                           array(
                                 'get_callback'    => 'get_client_last_name',
                                 'update_callback' => 'update_client_last_name',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_client_last_name($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_last_name( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Client User Name
    function client_add_client_user_name()
    {
        register_rest_field('client',
                           'client_user_name',
                           array(
                                 'get_callback'    => 'get_client_user_name',
                                 'update_callback' => 'update_client_user_name',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_client_user_name($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_user_name( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }   

    //Client Email
    function client_add_client_email()
    {
        register_rest_field('client',
                            'client_email',
                            array(
                                  'get_callback'    => 'get_client_email',
                                  'update_callback' => 'update_client_email',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_client_email($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_email( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }


    //Client Thumbnail URL
    function client_add_client_thumbnail_url()
    {
        register_rest_field('client',
                            'client_thumbnail_url',
                            array(
                                  'get_callback'    => 'get_client_thumbnail_url',
                                  'update_callback' => 'update_client_thumbnail_url',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_client_thumbnail_url($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_thumbnail_url( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Client Thumbnail Id
    function client_add_client_thumbnail_id()
    {
        register_rest_field('client',
                            'client_thumbnail_id',
                            array(
                                  'get_callback'    => 'get_client_thumbnail_id',
                                  'update_callback' => 'update_client_thumbnail_id',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_client_thumbnail_id($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_thumbnail_id( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Client Location
    function client_add_client_location()
    {
        register_rest_field('client',
                            'client_location',
                            array(
                                  'get_callback'    => 'get_client_location',
                                  'update_callback' => 'update_client_location',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_client_location($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_location( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    // LOCATION
    
    //Add Client Custom Type
    add_action( 'init', 'digimotion_location_init' );

    //Location Parent
    add_action('rest_api_init', 'location_add_post_parent');
    add_action('rest_api_init', 'location_add_post_children');       
    add_action('rest_api_init', 'location_add_as');
    add_action('rest_api_init', 'location_add_city');
    add_action('rest_api_init', 'location_add_country');
    add_action('rest_api_init', 'location_add_country_code');
    add_action('rest_api_init', 'location_add_isp');
    add_action('rest_api_init', 'location_add_latitude');
    add_action('rest_api_init', 'location_add_longitude');
    add_action('rest_api_init', 'location_add_region');
    add_action('rest_api_init', 'location_add_region_name');
    add_action('rest_api_init', 'location_add_time_zone');
    add_action('rest_api_init', 'location_add_zip');


    function digimotion_location_init()
    {
        
        $labels = array(
                        'name'               => 'Locations',
                        'singular_name'      => 'Location',
                        'menu_name'          => 'Locations',
                        'name_admin_bar'     => 'Location',
                        'add_new'            => 'Add New',
                        'add_new_item'       => 'Add New Location',
                        'new_item'           => 'New Location',
                        'edit_item'          => 'Edit Location',
                        'view_item'          => 'View Location',
                        'all_items'          => 'All Locations',
                        'search_items'       => 'Search Locations',
                        'parent_item_colon'  => 'Parent Location',
                        'not_found'          => 'No Locations Found',
                        'not_found_in_trash' => 'No Locations Found in Trash'
                        );
        
        $rewrite = array(
                         'slug'                => '/',
                         'with_front'          => true,
                         'pages'               => true,
                         'feeds'               => true,
                         );
        
        $args = array(
                      'labels'              => $labels,
                      'public'              => true,
                      'exclude_from_search' => false,
                      'publicly_queryable'  => true,
                      'show_ui'             => true,
                      'show_in_nav_menus'   => true,
                      'show_in_menu'        => true,
                      'show_in_rest'        => true,
                      'add_to_rest'         => true,
                      'show_in_admin_bar'   => true,
                      'menu_position'       => 5,
                      'menu_icon'           => 'dashicons-location',
                      'capability_type'     => 'post',
                      'hierarchical'        => false,
                      'has_archive'         => true,
                      'supports'            => array( 'title', 'editor', 'excerpt', 'author', 'thumbnail', 'custom-fields' ),
                      'rewrite'             => array( 'slug' => 'location', 'with_front' => true ),
                      'query_var'           => true,
                      );
        
        register_post_type( 'location', $args );

    }
    
    //Location Post Parent
    function location_add_post_parent()
    {
        register_rest_field('location',
                            'post_parent',
                            array(
                                  'get_callback'    => 'get_location_post_parent',
                                  'update_callback' => 'update_location_post_parent',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_location_post_parent($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_location_post_parent( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Location Post Children
    function location_add_post_children()
    {
        register_rest_field('location',
                            'post_children',
                            array(
                                  'get_callback'    => 'get_location_post_children',
                                  'update_callback' => 'update_location_post_children',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_location_post_children($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_location_post_children( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Location As
    function location_add_as()
    {
        register_rest_field('location',
                           'locaton_as',
                           array(
                                 'get_callback'    => 'get_locaton_as',
                                 'update_callback' => 'update_locaton_as',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_as($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_as( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Location City
    function location_add_city()
    {
        register_rest_field('location',
                           'locaton_city',
                           array(
                                 'get_callback'    => 'get_locaton_city',
                                 'update_callback' => 'update_locaton_city',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_city($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_city( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Location Country
    function location_add_country()
    {
        register_rest_field('location',
                           'locaton_country',
                           array(
                                 'get_callback'    => 'get_locaton_country',
                                 'update_callback' => 'update_locaton_country',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_country($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_country( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Location Country Code
    function location_add_country_code()
    {
        register_rest_field('location',
                           'locaton_country_code',
                           array(
                                 'get_callback'    => 'get_locaton_country_code',
                                 'update_callback' => 'update_locaton_country_code',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_country_code($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_country_code( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Location ISP
    function location_add_isp()
    {
        register_rest_field('location',
                           'locaton_isp',
                           array(
                                 'get_callback'    => 'get_locaton_isp',
                                 'update_callback' => 'update_locaton_isp',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_isp($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_isp( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    
    //Location Latitude
    function location_add_latitude()
    {
        register_rest_field('location',
                           'locaton_latitude',
                           array(
                                 'get_callback'    => 'get_locaton_latitude',
                                 'update_callback' => 'update_locaton_latitude',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_latitude($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_latitude( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Location Longitude
    function location_add_longitude()
    {
        register_rest_field('location',
                           'locaton_longitude',
                           array(
                                 'get_callback'    => 'get_locaton_longitude',
                                 'update_callback' => 'update_locaton_longitude',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_longitude($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_longitude( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Location Region
    function location_add_region()
    {
        register_rest_field('location',
                           'locaton_region',
                           array(
                                 'get_callback'    => 'get_locaton_region',
                                 'update_callback' => 'update_locaton_region',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_region($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_region( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Location Region Name
    function location_add_region_name()
    {
        register_rest_field('location',
                           'locaton_region_name',
                           array(
                                 'get_callback'    => 'get_locaton_region_name',
                                 'update_callback' => 'update_locaton_region_name',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_region_name($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_region_name( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Location Time Zone
    function location_add_time_zone()
    {
        register_rest_field('location',
                           'locaton_region_time_zone',
                           array(
                                 'get_callback'    => 'get_locaton_time_zone',
                                 'update_callback' => 'update_locaton_time_zone',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_time_zone($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_time_zone( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Location Zip
    function location_add_zip()
    {
        register_rest_field('location',
                           'locaton_zip',
                           array(
                                 'get_callback'    => 'get_locaton_zip',
                                 'update_callback' => 'update_locaton_zip',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_locaton_zip($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_locaton_zip( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    /// TERMINAL
    
    //Add Raspberrypi Taxonomy and Terminal Custom Type
    add_action( 'init', 'digimotion_terminal_init' );
    add_action('rest_api_init', 'terminal_add_name'); 
    add_action('rest_api_init', 'terminal_add_post_children');    
    add_action('rest_api_init', 'terminal_add_post_parent');
    add_action('rest_api_init', 'terminal_add_ipnumber');
    add_action('rest_api_init', 'terminal_add_public_ipnumber');
    add_action('rest_api_init', 'terminal_add_macaddress');
    add_action('rest_api_init', 'terminal_add_hostname');
    add_action('rest_api_init', 'terminal_add_network_provider');
    add_action('rest_api_init', 'terminal_add_uptime');
    add_action('rest_api_init', 'terminal_add_starttime');
    add_action('rest_api_init', 'terminal_add_model');
    add_action('rest_api_init', 'terminal_add_hardware');
    add_action('rest_api_init', 'terminal_add_serial');
    add_action('rest_api_init', 'terminal_add_revision');
    add_action('rest_api_init', 'terminal_add_disk_total');
    add_action('rest_api_init', 'terminal_add_disk_used');
    add_action('rest_api_init', 'terminal_add_disk_avaiable');
    add_action('rest_api_init', 'terminal_add_disk_percentage_used');
    add_action('rest_api_init', 'terminal_add_temprerature');
    add_action('rest_api_init', 'terminal_add_keepalive_time');

    function digimotion_terminal_init()
    {
        
        $labels = array(
                        'name'               => 'Terminals',
                        'singular_name'      => 'Terminal',
                        'menu_name'          => 'Terminals',
                        'name_admin_bar'     => 'Terminal',
                        'add_new'            => 'Add New',
                        'add_new_item'       => 'Add New Terminal',
                        'new_item'           => 'New Terminal',
                        'edit_item'          => 'Edit Terminal',
                        'view_item'          => 'View Terminal',
                        'all_items'          => 'All Terminals',
                        'search_items'       => 'Search Terminals',
                        'parent_item_colon'  => 'Parent Terminal',
                        'not_found'          => 'No Terminals Found',
                        'not_found_in_trash' => 'No Terminals Found in Trash'
                        );
        
        $args = array(
                      'labels'              => $labels,
                      'public'              => true,
                      'exclude_from_search' => false,
                      'publicly_queryable'  => true,
                      'show_ui'             => true,
                      'show_in_nav_menus'   => true,
                      'show_in_menu'        => true,
                      'show_in_rest'        => true,
                      'add_to_rest'         => true,
                      'show_in_admin_bar'   => true,
                      'menu_position'       => 5,
                      'menu_icon'           => 'dashicons-desktop',
                      'capability_type'     => 'post',
                      'hierarchical'        => false,
                      'has_archive'         => true,
                      'supports'            => array( 'title', 'editor', 'excerpt', 'author', 'thumbnail', 'custom-fields' ),
                      'rewrite'             => array( 'slug' => 'terminal', 'with_front' => true ),
                      'query_var'           => true,
                      );
        
        register_post_type( 'terminal', $args );
        
    }
    
    //Terminal Post Parent
    function terminal_add_post_parent()
    {
        register_rest_field('terminal',
                            'post_parent',
                            array(
                                  'get_callback'    => 'get_terminal_post_parent',
                                  'update_callback' => 'update_terminal_post_parent',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_terminal_post_parent($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_terminal_post_parent( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Terminal Name
    function terminal_add_name()
    {
        register_rest_field('terminal',
                            'name',
                            array(
                                  'get_callback'    => 'get_terminal_name',
                                  'update_callback' => 'update_terminal_name',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_terminal_name($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_terminal_name( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Post Children
    function terminal_add_post_children()
    {
        register_rest_field('terminal',
                            'post_children',
                            array(
                                  'get_callback'    => 'get_terminal_post_children',
                                  'update_callback' => 'update_terminal_post_children',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_terminal_post_children($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_terminal_post_children( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Ip Number
    function terminal_add_ipnumber()
    {
        register_rest_field('terminal',
                            'terminal_ipnumber',
                            array(
                                  'get_callback'    => 'get_ipnumber',
                                  'update_callback' => 'update_ipnumber',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_ipnumber($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_ipnumber( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Public Ip Number
    function terminal_add_public_ipnumber()
    {
        register_rest_field('terminal',
                            'terminal_public_ipnumber',
                            array(
                                  'get_callback'    => 'get_publicipnumber',
                                  'update_callback' => 'update_publicipnumber',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_publicipnumber($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_publicipnumber( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Mac Address
    function terminal_add_macaddress()
    {
        register_rest_field('terminal',
                            'terminal_macaddress',
                            array(
                                  'get_callback'    => 'get_macaddress',
                                  'update_callback' => 'update_macaddress',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_macaddress($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_macaddress( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Host Name
    function terminal_add_hostname()
    {
        register_rest_field('terminal',
                            'terminal_hostname',
                            array(
                                  'get_callback'    => 'get_hostname',
                                  'update_callback' => 'update_hostname',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_hostname($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_hostname( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Network Provider
    function terminal_add_network_provider()
    {
        register_rest_field('terminal',
                            'terminal_network_provider',
                            array(
                                  'get_callback'    => 'get_network_provider',
                                  'update_callback' => 'update_network_provider',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_network_provider($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_network_provider( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Temrinal Uptime
    function terminal_add_uptime()
    {
        register_rest_field('terminal',
                            'terminal_uptime',
                            array(
                                  'get_callback'    => 'get_uptime',
                                  'update_callback' => 'update_uptime',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_uptime($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_uptime( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Start Time
    function terminal_add_starttime()
    {
        register_rest_field('terminal',
                            'terminal_starttime',
                            array(
                                  'get_callback'    => 'get_starttime',
                                  'update_callback' => 'update_starttime',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_starttime($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_starttime( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Model
    function terminal_add_model()
    {
        register_rest_field('terminal',
                            'terminal_model',
                            array(
                                  'get_callback'    => 'get_model',
                                  'update_callback' => 'update_model',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_model($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_model( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Temrinal Hardware
    function terminal_add_hardware()
    {
        register_rest_field('terminal',
                            'terminal_hardware',
                            array(
                                  'get_callback'    => 'get_hardware',
                                  'update_callback' => 'update_hardware',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_hardware($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_hardware( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Serial
    function terminal_add_serial()
    {
        register_rest_field('terminal',
                            'terminal_serial',
                            array(
                                  'get_callback'    => 'get_serial',
                                  'update_callback' => 'update_serial',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_serial($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_serial( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Revision
    function terminal_add_revision()
    {
        register_rest_field('terminal',
                            'terminal_revision',
                            array(
                                  'get_callback'    => 'get_revision',
                                  'update_callback' => 'update_revision',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_revision($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_revision( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    
    //Terminal Disk Total
    function terminal_add_disk_total()
    {
        register_rest_field('terminal',
                            'terminal_disk_total',
                            array(
                                  'get_callback'    => 'get_disk_total',
                                  'update_callback' => 'update_disk_total',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_disk_total($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_disk_total( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Disk Used
    function terminal_add_disk_used()
    {
        register_rest_field('terminal',
                            'terminal_disk_used',
                            array(
                                  'get_callback'    => 'get_disk_used',
                                  'update_callback' => 'update_disk_used',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_disk_used($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_disk_used( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Disk Available
    function terminal_add_disk_avaiable()
    {
        register_rest_field('terminal',
                            'terminal_disk_available',
                            array(
                                  'get_callback'    => 'get_disk_avaiable',
                                  'update_callback' => 'update_disk_avaiable',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_disk_avaiable($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_disk_avaiable( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Termianl Disk Percentage Use
    function terminal_add_disk_percentage_used()
    {
        register_rest_field('terminal',
                            'terminal_disk_percentage_used',
                            array(
                                  'get_callback'    => 'get_disk_percentage_used',
                                  'update_callback' => 'update_disk_percentage_used',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_disk_percentage_used($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_disk_percentage_used( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Termianl Temperature
    function terminal_add_temprerature()
    {
        register_rest_field('terminal',
                            'terminal_temperature',
                            array(
                                  'get_callback'    => 'get_temprerature',
                                  'update_callback' => 'update_temprerature',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_temprerature($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_temprerature( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Terminal Keep Alive Time
    function terminal_add_keepalive_time()
    {
        register_rest_field('terminal',
                            'terminal_keepalive_time',
                            array(
                                  'get_callback'    => 'get_terminal_keepalive_time',
                                  'update_callback' => 'update_terminal_keepalive_time',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_terminal_keepalive_time($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_terminal_keepalive_time( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    // CAMERA
    
    //Add Camera Custom Type
    add_action( 'init', 'digimotion_camera_init' );
    
    //Add Camera Fields
    add_action('rest_api_init', 'camera_add_post_parent');
    add_action('rest_api_init', 'camera_add_post_children');
    add_action('rest_api_init', 'camera_add_name');
    add_action('rest_api_init', 'camera_add_number');
    add_action('rest_api_init', 'camera_add_created');
    add_action('rest_api_init', 'camera_add_keepalive_time');

    function digimotion_camera_init()
    {
        
        $labels = array(
                        'name'               => 'Cameras',
                        'singular_name'      => 'Camera',
                        'menu_name'          => 'Cameras',
                        'name_admin_bar'     => 'Camera',
                        'add_new'            => 'Add New',
                        'add_new_item'       => 'Add New Camera',
                        'new_item'           => 'New Camera',
                        'edit_item'          => 'Edit Camera',
                        'view_item'          => 'View Camera',
                        'all_items'          => 'All Cameras',
                        'search_items'       => 'Search Cameras',
                        'parent_item_colon'  => 'Parent Camera',
                        'not_found'          => 'No Cameras Found',
                        'not_found_in_trash' => 'No Cameras Found in Trash'
                        );
        
        $args = array(
                      'labels'              => $labels,
                      'public'              => true,
                      'exclude_from_search' => false,
                      'publicly_queryable'  => true,
                      'show_ui'             => true,
                      'show_in_nav_menus'   => true,
                      'show_in_menu'        => true,
                      'show_in_rest'        => true,
                      'add_to_rest'         => true,
                      'show_in_admin_bar'   => true,
                      'menu_position'       => 5,
                      'menu_icon'           => 'dashicons-camera',
                      'capability_type'     => 'post',
                      'hierarchical'        => false,
                      'has_archive'         => true,
                      'supports'            => array( 'title', 'editor', 'excerpt', 'author', 'thumbnail', 'custom-fields' ),
                      'rewrite'             => array( 'slug' => 'camera', 'with_front' => true ),
                      
                      'query_var'           => true,
                      );
        
        register_post_type( 'camera', $args );
        
    }
    
    //Camera Post Parent
    function camera_add_post_parent()
    {
        register_rest_field('camera',
                            'post_parent',
                            array(
                                  'get_callback'    => 'get_camera_post_parent',
                                  'update_callback' => 'update_camera_post_parent',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_camera_post_parent($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_camera_post_parent( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Camera Post Children
    function camera_add_post_children()
    {
        register_rest_field('camera',
                            'post_children',
                            array(
                                  'get_callback'    => 'get_camera_post_children',
                                  'update_callback' => 'update_camera_post_children',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_camera_post_children($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_camera_post_children( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Camera Name
    function camera_add_name()
    {
        register_rest_field('camera',
                           'camera_name',
                           array(
                                 'get_callback'    => 'get_camera_name',
                                 'update_callback' => 'update_camera_name',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_camera_name($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_camera_name( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Camera Number
    function camera_add_number()
    {
        register_rest_field('camera',
                           'camera_number',
                           array(
                                 'get_callback'    => 'get_camera_number',
                                 'update_callback' => 'update_camera_number',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_camera_number($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_camera_number( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Camera Created
    function camera_add_created()
    {
        register_rest_field('camera',
                            'camera_created',
                            array(
                                  'get_callback'    => 'get_camera_created',
                                  'update_callback' => 'update_camera_created',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_camera_created($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_camera_created( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Camera Keep Alive Time
    function camera_add_keepalive_time()
    {
        register_rest_field('camera',
                            'camera_keepalive_time',
                            array(
                                  'get_callback'    => 'get_camera_keepalive_time',
                                  'update_callback' => 'update_camera_keepalive_time',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_camera_keepalive_time($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_camera_keepalive_time( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    
    // RECOGNITION
    
    //Add Recognition Custom Type
    add_action( 'init', 'digimotion_recognition_init' );
    add_action('rest_api_init', 'recognition_add_post_children');    
    add_action('rest_api_init', 'recognition_add_post_parent');
    add_action('rest_api_init', 'recognition_add_name');
    add_action('rest_api_init', 'recognition_add_codename');
    add_action('rest_api_init', 'recognition_add_region');
    add_action('rest_api_init', 'recognition_add_delay');
    add_action('rest_api_init', 'recognition_add_runatstartup');
    add_action('rest_api_init', 'recognition_add_hascron');
    add_action('rest_api_init', 'recognition_add_interval');
    add_action('rest_api_init', 'recognition_add_screen');
    add_action('rest_api_init', 'recognition_add_running');
    add_action('rest_api_init', 'recognition_add_created');
    add_action('rest_api_init', 'recognition_add_media_url');
    add_action('rest_api_init', 'recognition_add_keepalive_time');
    add_action('rest_api_init', 'recognition_add_recognition_thumbnail_id');
    
    function digimotion_recognition_init()
    {
        
        $labels = array(
                        'name'               => 'Recognitions',
                        'singular_name'      => 'Recognition',
                        'menu_name'          => 'Recognitions',
                        'name_admin_bar'     => 'Recognition',
                        'add_new'            => 'Add New',
                        'add_new_item'       => 'Add New Recognition',
                        'new_item'           => 'New Recognition',
                        'edit_item'          => 'Edit Recognition',
                        'view_item'          => 'View Recognition',
                        'all_items'          => 'All Recognitions',
                        'search_items'       => 'Search Recognitions',
                        'parent_item_colon'  => 'Parent Recognition',
                        'not_found'          => 'No Recognitions Found',
                        'not_found_in_trash' => 'No Recognitions Found in Trash'
                        );
        
        $args = array(
                      'labels'              => $labels,
                      'public'              => true,
                      'exclude_from_search' => false,
                      'publicly_queryable'  => true,
                      'show_ui'             => true,
                      'show_in_nav_menus'   => true,
                      'show_in_menu'        => true,
                      'show_in_rest'        => true,
                      'add_to_rest'         => true,
                      'show_in_admin_bar'   => true,
                      'menu_position'       => 5,
                      'menu_icon'           => 'dashicons-marker',
                      'capability_type'     => 'post',
                      'hierarchical'        => false,
                      'has_archive'         => true,
                      'supports'            => array( 'title', 'editor', 'excerpt', 'author', 'thumbnail', 'custom-fields' ),
                      'rewrite'             => array( 'slug' => 'recognition', 'with_front' => true ),
                      'query_var'           => true,
                      );
        
        register_post_type( 'recognition', $args );
        
    }
    
    //Recognition Post Parent
    function recognition_add_post_parent()
    {
        register_rest_field('recognition',
                            'post_parent',
                            array(
                                  'get_callback'    => 'get_recognition_post_parent',
                                  'update_callback' => 'update_recognition_post_parent',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_recognition_post_parent($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_post_parent( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Recognition Post Children
    function recognition_add_post_children()
    {
        register_rest_field('recognition',
                            'post_children',
                            array(
                                  'get_callback'    => 'get_recognition_post_children',
                                  'update_callback' => 'update_recognition_post_children',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_recognition_post_children($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_post_children( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
   
    //Recognition Name
    function recognition_add_name()
    {
        register_rest_field('recognition',
                           'recognition_name',
                           array(
                                 'get_callback'    => 'get_recognition_name',
                                 'update_callback' => 'update_recognition_name',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_recognition_name($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_name( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Codename
    function recognition_add_codename()
    {
        register_rest_field('recognition',
                           'recognition_codename',
                           array(
                                 'get_callback'    => 'get_recognition_codename',
                                 'update_callback' => 'update_recognition_codename',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_recognition_codename($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_codename( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Region
    function recognition_add_region()
    {
        register_rest_field('recognition',
                           'recognition_region',
                           array(
                                 'get_callback'    => 'get_recognition_region',
                                 'update_callback' => 'update_recognition_region',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_recognition_region($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_region( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recogntition Delay
    function recognition_add_delay()
    {
        register_rest_field('recognition',
                           'recognition_delay',
                           array(
                                 'get_callback'    => 'get_recognition_delay',
                                 'update_callback' => 'update_recognition_delay',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_recognition_delay($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_delay( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Runatstartup
    function recognition_add_runatstartup()
    {
        register_rest_field('recognition',
                           'recognition_runatstartup',
                           array(
                                 'get_callback'    => 'get_recognition_runatstartup',
                                 'update_callback' => 'update_recognition_runatstartup',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_recognition_runatstartup($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_runatstartup( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Cron
    function recognition_add_hascron()
    {
        register_rest_field('recognition',
                           'recognition_hascron',
                           array(
                                 'get_callback'    => 'get_recognition_hascron',
                                 'update_callback' => 'update_recognition_hascron',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_recognition_hascron($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_hascron( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Iterval
    function recognition_add_interval()
    {
        register_rest_field('recognition',
                            'recognition_interval',
                            array(
                                  'get_callback'    => 'get_recognition_interval',
                                  'update_callback' => 'update_recognition_interval',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_recognition_interval($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_interval( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Screen Size
    function recognition_add_screen()
    {
        register_rest_field('recognition',
                           'recognition_screen',
                           array(
                                 'get_callback'    => 'get_recognition_screen',
                                 'update_callback' => 'update_recognition_screen',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_recognition_screen($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_screen( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Running
    function recognition_add_running()
    {
        register_rest_field('recognition',
                           'recognition_running',
                           array(
                                 'get_callback'    => 'get_recognition_running',
                                 'update_callback' => 'update_recognition_running',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_recognition_running($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_running( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Created
    function recognition_add_created()
    {
        register_rest_field('recognition',
                            'recognition_created',
                            array(
                                  'get_callback'    => 'get_recognition_created',
                                  'update_callback' => 'update_recognition_created',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_recognition_created($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_created( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Media URL
    function recognition_add_media_url()
    {
        register_rest_field('recognition',
                            'recognition_media_url',
                            array(
                                  'get_callback'    => 'get_recognition_media_url',
                                  'update_callback' => 'update_recognition_media_url',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_recognition_media_url($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_media_url( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Recognition Keep Alive Time
    function recognition_add_keepalive_time()
    {
        register_rest_field('recognition',
                            'recognition_keepalive_time',
                            array(
                                  'get_callback'    => 'get_recognition_keepalive_time',
                                  'update_callback' => 'update_recognition_keepalive_time',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_recognition_keepalive_time($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_keepalive_time( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Recognition Recognition Thumbnail Id
    function recognition_add_recognition_thumbnail_id()
    {
        register_rest_field('recognition',
                            'recognition_thumbnail_id',
                            array(
                                  'get_callback'    => 'get_recognition_thumbnail_id',
                                  'update_callback' => 'update_recognition_thumbnail_id',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_recognition_thumbnail_id($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_recognition_thumbnail_id( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }   
    
    // DAY
    
    //Add DAY Custom Type
    add_action( 'init', 'digimotion_day_init' );
    
    //Add Day Fields
    add_action('rest_api_init', 'day_add_post_parent');
    add_action('rest_api_init', 'day_add_post_children');
    add_action('rest_api_init', 'day_add_label');
    add_action('rest_api_init', 'day_add_xml');
    add_action('rest_api_init', 'day_add_created');
    add_action('rest_api_init', 'day_add_keepalive_time');

    function digimotion_day_init()
    {
        
        $labels = array(
                        'name'               => 'Days',
                        'singular_name'      => 'Day',
                        'menu_name'          => 'Days',
                        'name_admin_bar'     => 'Day',
                        'add_new'            => 'Add New',
                        'add_new_item'       => 'Add New day',
                        'new_item'           => 'New day',
                        'edit_item'          => 'Edit day',
                        'view_item'          => 'View day',
                        'all_items'          => 'All day',
                        'search_items'       => 'Search days',
                        'parent_item_colon'  => 'Parent instance',
                        'not_found'          => 'No days Found',
                        'not_found_in_trash' => 'No days Found in Trash'
                        );
        
        $args = array(
                      'labels'              => $labels,
                      'public'              => true,
                      'exclude_from_search' => false,
                      'publicly_queryable'  => true,
                      'show_ui'             => true,
                      'show_in_nav_menus'   => true,
                      'show_in_menu'        => true,
                      'show_in_rest'        => true,
                      'add_to_rest'         => true,
                      'show_in_admin_bar'   => true,
                      'menu_position'       => 5,
                      'menu_icon'           => 'dashicons-calendar-alt',
                      'capability_type'     => 'post',
                      'hierarchical'        => false,
                      'has_archive'         => true,
                      'supports'            => array( 'title', 'editor', 'excerpt', 'author', 'thumbnail', 'custom-fields' ),
                      'rewrite'             => array( 'slug' => 'day', 'with_front' => true ),
                      'query_var'           => true,
                      );
        
        register_post_type( 'day', $args );
        
    }
    
    //Day Post Parent
    function day_add_post_parent()
    {
        register_rest_field('day',
                            'post_parent',
                            array(
                                  'get_callback'    => 'get_day_post_parent',
                                  'update_callback' => 'update_day_post_parent',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_day_post_parent($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_day_post_parent( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Day Post Children
    function day_add_post_children()
    {
        register_rest_field('day',
                            'post_children',
                            array(
                                  'get_callback'    => 'get_day_post_children',
                                  'update_callback' => 'update_day_post_children',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_day_post_children($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_day_post_children( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Day label
    function day_add_label()
    {
        register_rest_field('day',
                           'day_label',
                           array(
                                 'get_callback'    => 'get_day_label',
                                 'update_callback' => 'update_day_label',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_day_label($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_day_label( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Day xml
    function day_add_xml()
    {
        register_rest_field('day',
                           'day_xml',
                           array(
                                 'get_callback'    => 'get_day_xml',
                                 'update_callback' => 'update_day_xml',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_day_xml($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_day_xml( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Day Created
    function day_add_created()
    {
        register_rest_field('day',
                            'day_created',
                            array(
                                  'get_callback'    => 'get_day_created',
                                  'update_callback' => 'update_day_created',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_day_created($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_day_created( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Day Keep Alive Time
    function day_add_keepalive_time()
    {
        register_rest_field('day',
                            'day_keepalive_time',
                            array(
                                  'get_callback'    => 'get_day_keepalive_time',
                                  'update_callback' => 'update_day_keepalive_time',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_day_keepalive_time($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_day_keepalive_time( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    // INSTANCE
    
    //Add INSTANCE Custom Type
    add_action( 'init', 'digimotion_instance_init' );
    add_action('rest_api_init', 'instance_add_post_children');    
    add_action('rest_api_init', 'instance_add_post_parent');
    add_action('rest_api_init', 'instance_add_number');
    add_action('rest_api_init', 'instance_add_begintime');
    add_action('rest_api_init', 'instance_add_endtime');
    add_action('rest_api_init', 'instance_add_code');   
    add_action('rest_api_init', 'instance_add_media_url');
    add_action('rest_api_init', 'instance_add_parse_pfuser');
    add_action('rest_api_init', 'instance_add_parse_applicationid');
    add_action('rest_api_init', 'instance_add_parse_rest_api_key');    
    
    function digimotion_instance_init()
    {
        
        $labels = array(
            'name'               => 'Instances',
            'singular_name'      => 'Instance',
            'menu_name'          => 'Instances',
            'name_admin_bar'     => 'XxmlML',
            'add_new'            => 'Add New',
            'add_new_item'       => 'Add New instance',
            'new_item'           => 'New instance',
            'edit_item'          => 'Edit instance',
            'view_item'          => 'View ',
            'all_items'          => 'All instance',
            'search_items'       => 'Search instances',
            'parent_item_colon'  => 'Parent instance',
            'not_found'          => 'No instances Found',
            'not_found_in_trash' => 'No instances Found in Trash'
        );
        
        $args = array(
            'labels'              => $labels,
            'public'              => true,
            'exclude_from_search' => false,
            'publicly_queryable'  => true,
            'show_ui'             => true,
            'show_in_nav_menus'   => true,
            'show_in_menu'        => true,
            'show_in_rest'        => true,
            'add_to_rest'         => true,
            'show_in_admin_bar'   => true,
            'menu_position'       => 5,
            'menu_icon'           => 'dashicons-editor-justify',
            'capability_type'     => 'page',
            'hierarchical'        => false,
            'has_archive'         => true,
            'supports'            => array( 'title', 'editor', 'excerpt', 'author', 'thumbnail', 'custom-fields' ),
            'rewrite'             => array( 'slug' => 'instance', 'with_front' => true ),
            'query_var'           => true,
        );
        
        register_post_type( 'instance', $args );
        
    }
    
    //Instance Post Parent
    function instance_add_post_parent()
    {
        register_rest_field('instance',
            'post_parent',
            array(
                  'get_callback'    => 'get_instance_post_parent',
                  'update_callback' => 'update_instance_post_parent',
                  'schema'          => null,
                  )
        );
    }
    function get_instance_post_parent($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_post_parent( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Instance Post Children
    function instance_add_post_children()
    {
        register_rest_field('instance',
                            'post_children',
                            array(
                                  'get_callback'    => 'get_instance_post_children',
                                  'update_callback' => 'update_instance_post_children',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_instance_post_children($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_post_children( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Instance Number
    function instance_add_number()
    {
        register_rest_field('instance',
           'instance_number',
           array(
                 'get_callback'    => 'get_instance_number',
                 'update_callback' => 'update_instance_number',
                 'schema'          => null,
                 )
        );
    }
    function get_instance_number($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_number( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Instance Begin Time
    function instance_add_begintime()
    {
        register_rest_field('instance',
                           'instance_begintime',
                           array(
                                 'get_callback'    => 'get_instance_begintime',
                                 'update_callback' => 'update_instance_begintime',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_instance_begintime($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_begintime( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    
    //Instance End Time
    function instance_add_endtime()
    {
        register_rest_field('instance',
                           'instance_endtime',
                           array(
                                 'get_callback'    => 'get_instance_endtime',
                                 'update_callback' => 'update_instance_endtime',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_instance_endtime($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_endtime( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
   
    //Instance Code
    function instance_add_code()
    {
        register_rest_field('instance',
                           'instance_code',
                           array(
                                 'get_callback'    => 'get_instance_code',
                                 'update_callback' => 'update_instance_code',
                                 'schema'          => null,
                                 )
                           );
    }
    function get_instance_code($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_code( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Instance Media URL
    function instance_add_media_url()
    {
        register_rest_field('instance',
                            'instance_media_id',
                            array(
                                  'get_callback'    => 'get_instance_media_id',
                                  'update_callback' => 'update_instance_media_id',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_instance_media_id($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_media_id( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }   

    //Instance Parse UserId
    function instance_add_parse_pfuser()
    {
        register_rest_field('instance',
                            'instance_pfuser',
                            array(
                                  'get_callback'    => 'get_instance_pfuser',
                                  'update_callback' => 'update_instance_pfuser',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_instance_pfuser($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_pfuser( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    //Instance Parse Application Id
    function instance_add_parse_applicationid()
    {
        register_rest_field('instance',
                            'instance_pfappid',
                            array(
                                  'get_callback'    => 'get_instance_pfappid',
                                  'update_callback' => 'update_instance_pfappid',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_instance_pfappid($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_pfappid( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    
    //Instance Parse Rest Api Key
    function instance_add_parse_rest_api_key()
    {
        register_rest_field('instance',
                            'instance_pfrestapikey',
                            array(
                                  'get_callback'    => 'get_instance_pfrestapikey',
                                  'update_callback' => 'update_instance_pfrestapikey',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_instance_pfrestapikey($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_pfrestapikey( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }

    ///////////////////////
    // APPEND CHILDRENS  //
    ///////////////////////         
    
   
    add_action( 'added_post_meta', 'append_children_meta', 10, 4 );

    function append_children_meta( $meta_id, $post_id, $meta_key, $meta_value )
    {        
        
        $post = get_post($post_id);   

        $type = get_post_type($post_id);

        /*$parent = get_post_meta($post_id, 'post_parent', true);
        if (!is_float($parent)) 
        {
          $p = floatval($parent);
          update_post_meta($post_id, 'post_parent', $p); 
        }*/

        if ($type != "client")
        {        

          if ($meta_key == "post_parent")
          {
              $parentId = $meta_value;                
              
              $childata = get_post_meta($parentId, 'post_children', true);

              $count = count($childata);
        
              $array = Array();

              if ( $count > 0 ) 
              {

                foreach ( $childata as $child ) 
                {                     
                    array_push($array, $child);
                }

                array_push($array, $post_id);
                
                update_post_meta($parentId, 'post_children', $array);  

              } else 
              {      
                update_post_meta($parentId, 'post_children', $post_id);  
              }            
          }       

        }              
    }

    ///////////
    // DEBUG //
    ///////////
    
    
    if (!function_exists('write_log'))
    {
        function write_log ( $log )  {
            if ( true === WP_DEBUG ) {
                if ( is_array( $log ) || is_object( $log ) ) {
                    error_log( print_r( $log, true ) );
                } else {
                    error_log( $log );
                }
            }
        }
    }    
    
    ////////////////
    // WRITE FILE //
    ////////////////    


    function write_log_file($log)
    {
      $fildirectory = "wp-content/logs";

      if (!file_exists($fildirectory)) 
      {
        mkdir($fildirectory, 0777, true);
      }     

      $timelog = "\r\n".date('H:i:s').' :: '.$log;

      file_put_contents($fildirectory."/logfile.txt", $timelog, FILE_APPEND);       
    }   

    /////////////
    // FirePHP //
    /////////////

    require_once( 'FirePHPCore/FirePHP.class.php' );
    ob_start();
    $firephp = FirePHP::getInstance( true );

    function logit( $var, $title='From FirePHP:' )
    {
        global $firephp;
        $firephp->log( $var, $title );
    }

    ///////////////////
    ///// ERROR   /////
    ///////////////////

    function response_no_parameter_given($param)
    {
      $message['error'] = "No parameter given: ".$param;
      $response = new WP_REST_Response( $message );            
      $response->set_status( 400 ); 
      return $response;
    }
    
    ///////////////////////////////////
    //  LOGIN - CREATE USER - CLIENT //
    ///////////////////////////////////

    interface iOSWPLoginInterface
    {
        public function check_ios_login();
        public function get_ios_login($creds);
        public function is_the_user_logged_in();
        public function create_wp_user($userdata);
        public function create_wp_client($clientdata);
        public function upload_wp_image($imagedata);
    }
     
    class iOSWPLogin implements iOSWPLoginInterface
    {
        public function check_ios_login()
        {
            $check_login = !empty($_POST['check_login']) ?  (int)$_POST['check_login'] : false;
         
            switch($check_login)
            {
                case 1:
                    $this->is_the_user_logged_in();
                    //wp_logout();
                break;
                
                case 2:
                    $this->get_ios_login($_POST);
                break;

                case 3:
                    $this->create_wp_user($_POST);
                break;

                case 4:
                    $this->create_wp_client($_POST);
                break;
                
                case 5:
                    $this->upload_wp_image($_POST);
                break;              

                case 6:
                    
                    $response = array();
                    
                    if ( is_user_logged_in() ) {
                        wp_logout();
                        $response['logged_out'] = 1;
                    } else {
                        $response['logged_out'] = 0;
                    }
                    
                    echo json_encode($response);
                    
                break;
            }
        }
        
        public function is_the_user_logged_in()
        {
            if ( is_user_logged_in() ) { 
            
                $user_id = get_current_user_id();
                $user_data = get_userdata( $user_id );
                echo json_encode($user_data);
                
            } else {
                echo json_encode( array('logged_in'=> 0) );
            }
            
            exit();
        }
        
        public function get_ios_login($creds)
        {   
            $message = array();
            
            if( !empty($creds['ios_userlogin']) && !empty($creds['ios_userpassword']) )
            {
                
                // Add wp_signon $_POST parameter after $_POST request has been made
                // to avoid conflicts with login form and plugins
                 
                $creds['user_login'] = $creds['ios_userlogin'];
                $creds['user_password'] = $creds['ios_userpassword'];
                
                //$creds['remember'] = true;
                
                //wp_signon sanitizes login input
                $user = wp_signon( $creds, false );
                
                if ( is_wp_error($user) ){
                    
                    //Return error messages
                    if(isset($user->errors['invalid_username'])){
                        $message['error'] = 1;
                    } elseif(isset($user->errors['incorrect_password'])){
                        $message['error'] = 2;
                    }
                    
                    echo json_encode($message);
                    exit(); 
                    
                } else 
                {
                    echo json_encode($user);
                    exit(); 
                }   
            }   
        }

        public function create_wp_user($userdata)
        {   
            $message = array();
            
            if( !empty($userdata['ios_userlogin']) && !empty($userdata['ios_userpassword']) )
            {
                 
                $userdata['user_login'] = $userdata['ios_userlogin'];
                $userdata['user_password'] = $userdata['ios_userpassword'];
                             
                //wp_signon sanitizes login input
                $admin_user = wp_signon( $userdata, false );
                
                if ( is_wp_error($admin_user) ){
                    
                    //Return error messages
                    if(isset($admin_user->errors['invalid_username']))
                    {
                        $message['error'] = 1;

                    } elseif(isset($admin_user->errors['incorrect_password']))
                    {
                        $message['error'] = 2;
                    }
                    
                    echo json_encode($message);
                    exit(); 
                    
                } else {
                    
                    $new_user_name = $userdata['new_username'];
                    $new_password  = $userdata['new_password'];
                    $new_email     = $userdata['new_email'];

                    $new_first_name     = $userdata['new_first_name'];
                    $new_last_name      = $userdata['new_last_name'];
                    $new_role           = $userdata['new_role'];

                    $user_id = username_exists( $userdata['new_username'] );

                    if ( !$user_id and email_exists($new_email) == false ) 
                    {
                      
                      $userdata = array(
                        'user_login'  =>  $new_user_name,
                        'user_pass'   =>  $new_password,
                        'user_email'  =>  $new_email,
                        'first_name'  =>  $new_first_name,
                        'last_name'   =>  $new_last_name,
                        'display_name'=>  $new_first_name." ".$new_last_name,
                        'role'        =>  $new_role
                      );

                      //write_log('VER LOG ACA');
                      //write_log('**********************');   
                      
                      $user_id = wp_insert_user( $userdata );
                      
                      //write_log($userdata);   
                      //write_log('**********************');   

                      write_log('ID:');
                      write_log('user_id: '.$user_id);                 

                      //On success
                      if ( ! is_wp_error( $user_id ) ) 
                      {
                          //$user_created = get_user_by('id', $user_id);

                          write_log('user_id_encoded: '.json_encode($user_id));  

                          echo json_encode($user_id);
                  
                      } else {

                        $error = 'Error creating user.';
                        $message['error'] = $error;
                        echo json_encode($message);
                     
                      }

                      wp_logout();

                      exit(); 

                    } else {
                      
                        $error = 'User already exists.  Password inherited.';
                        $message['error'] = $error;
                        echo json_encode($message);
                        exit(); 
                    }
                }   
            }   
        }

        public function create_wp_client($clientdata)
        {   
            $message = array();
            
            if( !empty($clientdata['wp_userlogin']) && !empty($clientdata['wp_userpassword']) )
            {
                 
                $clientdata['user_login'] = $clientdata['wp_userlogin'];
                $clientdata['user_password'] = $clientdata['wp_userpassword'];             
                //wp_signon sanitizes login input
                $user_client = wp_signon( $clientdata, false );
                
                if ( is_wp_error($user_client) )
                {
                    
                    //Return error messages
                    if(isset($user_client->errors['invalid_username']))
                    {
                        $message['error'] = 1;

                    } elseif (isset($user_client->errors['incorrect_password']))
                    {
                        $message['error'] = 2;
                    }                   

                    echo json_encode($message);
                    exit(); 
                    
                } else {
                    
                    $post_author        = $clientdata['post_author'];
                    $client_first_name  = $clientdata['client_first_name'];
                    $client_last_name   = $clientdata['client_last_name'];
                    $client_user_name   = $clientdata['client_user_name'];
                    $client_email       = $clientdata['client_email'];
                    $client_location    = $clientdata['client_location'];
                    $client_parent      = $clientdata['client_post_parent'];      
                    $client_post = array(
                          'post_title' => $client_first_name." ".$client_last_name,
                          'post_status' => 'publish',
                          'post_type' => 'client',
                          'post_author' => $post_author
                    );
                    $client_post_id = wp_insert_post( $client_post );

                    if ( ! is_wp_error( $client_post_id ) ) 
                    {

                        add_post_meta($client_post_id, "client_first_name", $client_first_name);
                        
                        add_post_meta( $client_post_id, 'client_last_name', $client_last_name );

                        add_post_meta( $client_post_id, 'client_user_name', $client_user_name );

                        add_post_meta( $client_post_id, 'client_email', $client_email );

                        add_post_meta( $client_post_id, 'client_location', $client_location );

                        add_post_meta( $client_post_id, 'post_parent', $client_parent );                                   

                        $client_created = get_post( $client_post_id );
                        
                        echo json_encode($client_created);

                        wp_logout();
                          
                    } else {
                      
                        $error = 'Cannot insert Client.';
                        writelog(" error:".$error);
                        $message['error'] = $error;                        
                        echo json_encode($message);
                        exit(); 

                    }


                    exit();

                }   
            }   
        }

        public function upload_wp_image($imagedata)
        {   
            $message = array();
            
            if( !empty($imagedata['media_userlogin']) && !empty($imagedata['media_userpassword']) )
            {
                 
                $imagedata['user_login'] = $imagedata['media_userlogin'];
                $imagedata['user_password'] = $imagedata['media_userpassword'];
                
                //wp_signon sanitizes login input
                $user_image = wp_signon( $imagedata, false );
                
                if ( is_wp_error($user_image) )
                {
                    
                    //Return error messages
                    if(isset($user_image->errors['invalid_username']))
                    {
                        $message['error'] = 1;

                    } elseif (isset($user_image->errors['incorrect_password']))
                    {
                        $message['error'] = 2;
                    }
                    
                    echo json_encode($message);
                    exit(); 
                    
                } else {
                    
                    $postId = $imagedata['postId'];
                    $image = $imagedata['image'];
                    $author = $imagedata['post_author'];

                    $directory = "/".date('Y')."/".date('m')."/";
                    $wp_upload_dir = wp_upload_dir();
                    $data = base64_decode($image);
                    $filename = "IMG_".time().".png";

                    $fildirectory = "wp-content/uploads".$directory;

                    if (!file_exists($fildirectory)) 
                    {
                      mkdir($fildirectory, 0777, true);
                    }

                    $fileurl = $fildirectory.$filename;

                    //$myfile = fopen($fildirectory."/newfile.txt", "w") or die("Unable to open file!");
                    //fwrite($myfile, $fileurl);
                    //fclose($myfile);
                  
                    $filetype = wp_check_filetype( basename( $fileurl), null );

                    file_put_contents($fileurl, $data);

                    $attachment = array(
                        'guid' => $wp_upload_dir['url'] . '/' . basename( $fileurl ),
                        'post_mime_type' => $filetype['type'],
                        'post_title' => preg_replace('/\.[^.]+$/', '', basename($fileurl)),
                        'post_content' => '',
                        'post_author' => $author,
                        'post_status' => 'inherit'
                    );
                    
                    
                    $attach_id = wp_insert_attachment( $attachment, $fileurl ,$postId);
                    require_once('wp-admin/includes/image.php' );

                    // Generate the metadata for the attachment, and update the database record.
                    $attach_data = wp_generate_attachment_metadata( $attach_id, $fileurl );
                    wp_update_attachment_metadata( $attach_id, $attach_data );

                    $attachment_post_id = set_post_thumbnail( $postId, $attach_id );

                     update_post_meta($postId, "client_thumbnail_id", $attach_id);

                     $feat_image_url = wp_get_attachment_url( $attach_id );

                     update_post_meta($postId, "client_thumbnail_url", $feat_image_url);

                    if ( ! is_wp_error( $attachment_post_id ) ) 
                    {

                       $attach_id_post = get_post( $attach_id );

                      echo json_encode( $attach_id_post );

                      wp_logout();

                    } else 
                    {
                        $error = 'Cannot insert Client.';
                        $message['error'] = $error;
                        echo json_encode($message);
                    } 
                
                    exit();

                }   
            }   
        }
    }
     
    //add_action('after_setup_theme', array($ios_login = new iOSWPLogin,'check_ios_login'));

    ///////////////////////////
    // BASIC AUTHENTICATION  //
    ///////////////////////////
    
    function json_basic_auth_handler( $user ) {
      
       global $wp_json_basic_auth_error;
      $wp_json_basic_auth_error = null;
      // Don't authenticate twice
      if ( ! empty( $user ) ) {
        return $user;
      }
      // Check that we're trying to authenticate
      if ( !isset( $_SERVER['PHP_AUTH_USER'] ) ) {
        return $user;
      }

      if ( isset( $_SERVER['PHP_AUTH_USER'] ) ) {
        $username = (string) $_SERVER['PHP_AUTH_USER'];
      }

      if ( isset( $_SERVER['PHP_AUTH_PW'] ) ) {
        $password = (string) $_SERVER['PHP_AUTH_PW'];
      }
        
      // In multi-site, wp_authenticate_spam_check filter is run on authentication. This filter calls
      // * get_currentuserinfo which in turn calls the determine_current_user filter. This leads to infinite
      // * recursion and a stack overflow unless the current function is removed from the determine_current_user
      // * filter during authentication.
       

      remove_filter( 'determine_current_user', 'json_basic_auth_handler', 20 );
      $user = wp_authenticate( $username, $password );
      add_filter( 'determine_current_user', 'json_basic_auth_handler', 20 );
      if ( is_wp_error( $user ) ) {
        $wp_json_basic_auth_error = $user;
        return null;
      }
      $wp_json_basic_auth_error = true;
      return $user->ID;
    }
    add_filter( 'determine_current_user', 'json_basic_auth_handler', 20 );
    
    function json_basic_auth_error( $error ) {

      // Passthrough other errors
      if ( ! empty( $error ) ) {
        return $error;
      }
      global $wp_json_basic_auth_error;
      return $wp_json_basic_auth_error;
    }
    add_filter( 'json_authentication_errors', 'json_basic_auth_error' );	


    ////////////////////
    // NOTIFICATIONS  //
    ////////////////////       
   

    add_action( 'init', 'create_notification_table' );

    function create_notification_table()
    {
        global $wpdb;
        $table_name = $wpdb->prefix.'gm_notification';
        if($wpdb->get_var("SHOW TABLES LIKE '".$table_name."'") != $table_name) 
        {

             $charset_collate = $wpdb->get_charset_collate();         
             $sql = "CREATE TABLE $table_name (
                  id mediumint(9) NOT NULL AUTO_INCREMENT,
                  post_id int, 
                  pfuser text,
                  pfappid text, 
                  pfrestapikey text,                  
                  post_type text,
                  post_parent int, 
                  count_updates int NOT NULL DEFAULT 0,  
                  hasresponse boolean,
                  response text,               
                  UNIQUE KEY id (id)
             ) $charset_collate;";
             require_once( ABSPATH . 'wp-admin/includes/upgrade.php' );
             dbDelta( $sql );
        }   
    }
    
   
    add_action( 'added_post_meta', 'instance_meta', 10, 4 );
    //add_action( 'save_post', 'instance_meta', 10, 3 );  

    function instance_meta( $meta_id, $post_id, $meta_key, $meta_value )
    {                 

        $post = get_post($post_id);   

        $slug = 'instance';             

        //do_action( 'add_debug_info', $log, "nada" );
        //logit($log);           
        
        if ($slug != $post->post_type) 
        {
            return;
        }        

        $table_field = ""; 
        $nometa = false;

        if ($meta_key  == "instance_pfuser") 
          $nometa=true;

        if ($meta_key == "instance_pfappid") 
          $nometa=true;          

        if ($meta_key == "instance_pfrestapikey")
          $nometa=true;  

        if ($meta_key == "post_parent")
            $nometa=true;

          
        if ($nometa)
        {  
          
          if ($meta_key == "instance_pfuser")
            $table_field = "pfuser";

          if ($meta_key == "instance_pfappid")
            $table_field = "pfappid";

          if ($meta_key == "instance_pfrestapikey")
            $table_field = "pfrestapikey";

          if ($meta_key == "post_parent")
            $table_field = "post_parent";                   

          $log = "post_id: ".$post_id." meta_key: ".$meta_key." meta_value: ".$meta_value." table_field: ".$table_field; 

          $count_query = "SELECT * FROM wp_gm_notification WHERE post_id=".$post_id;  

          global $wpdb;
          $wpdb->get_results($count_query);          
          $count = $wpdb->num_rows;                  

          if ($count > 0)
          {
                        
            $count_updates_query = "SELECT count_updates FROM wp_gm_notification WHERE post_id=".$post_id.";";

            $upcate_count = $wpdb->get_var($wpdb->prepare($count_updates_query));
            
            $wpdb->query($wpdb->prepare ("UPDATE wp_gm_notification SET ".$table_field."='".$meta_value."',count_updates = count_updates + 1  WHERE post_id=".$post_id.""));      

            if ($upcate_count==2)
            {
                send_push_notification_on_post($post_id);
            }

          } else 
          {
            $qarrayadd = array (              
                'post_id'     => $post_id,
                $table_field  => $meta_value,              
                'post_type'   => $post->post_type,
            );            
            $wpdb->insert ('wp_gm_notification', $qarrayadd);
          }

        }
        
    }  
    

    function send_push_notification_on_post( $post_id ) 
    { 

      $query_push = "SELECT pfuser, pfappid, pfrestapikey, post_parent FROM wp_gm_notification WHERE post_id=".$post_id.";";

      global $wpdb;
      $resutls = $wpdb->get_results($query_push);          
      $count = $wpdb->num_rows;     

      if ($count>0)
      {     

          foreach ( $resutls as $resutl ) 
          {
            
            $pfuser       = $resutl->pfuser; 
            $pfappid      = $resutl->pfappid; 
            $pfrestapikey = $resutl->pfrestapikey;
            $postparent   = $resutl->post_parent;             

            $log = "pfuser: ".$pfuser." pfappid: ".$pfappid." pfrestapikey: ".$pfrestapikey." postparent: ".$postparent;

            write_log_file($log); 

            $dayid = get_post_meta($post_id, "post_parent", true);
            $recognitionid  = get_post_meta($dayid, "post_parent", true);
            $cameraid       = get_post_meta($recognitionid, "post_parent", true);           

            $endinstance  = $post_id;
            $endrec       = $recognitionid;           
            $endcamera    = $cameraid;

            $camera_name       = get_post_meta($cameraid, "camera_name", true);

            write_log_file($endinstance); 
            write_log_file($endrec); 
            write_log_file($endcamera);

            $url = 'https://api.parse.com/1/push';            
            $data = array (                                   
                'channel' => "user_".$pfuser,
                'data'    => array (
                    'title'       => 'Movement on '.$camera_name,
                    'postId'   => $post_id,
                ),
            );

            $_data = json_encode($data);          

            $_headers = array (
                'X-Parse-Application-Id:'.$pfappid,
                'X-Parse-REST-API-Key:'.$pfrestapikey,
                'Content-Type:application/json'         
            );

            write_log_file("data: ".$_data); 
            write_log_file("headers: ".$_headers); 

            $curl = curl_init($url);            
            curl_setopt($curl, CURLOPT_POSTFIELDS, $_data);
            curl_setopt($curl, CURLOPT_HTTPHEADER, $_headers);
            curl_setopt($curl, CURLOPT_VERBOSE, 1);
            curl_setopt($curl, CURLOPT_POST, true);
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER ,false);
            curl_setopt($curl, CURLOPT_SSL_VERIFYHOST  ,false);
            //curl_setopt($curl, CURLOPT_RETURNTRANSFER  ,false);

            $response = curl_exec($curl);

            write_log_file("response: ".$response);

            if ($reponse)
            {
              $wpdb->query($wpdb->prepare("UPDATE gm_notification SET hasresponse=true, response='".$response."'' WHERE post_id=".$post_id.""));
            }
        }
      }     
   }

   ///////////////////
   ///  ENDPOINTS  ///
   ///////////////////    


    //// CHECK OBJECTS RASPBERRY

    add_action( 'rest_api_init', 'wpc_register_wp_api_rasp_endpoints' );

    function wpc_register_wp_api_rasp_endpoints() 
    {

      // CHECK CUSTOM POST EXIST 

      register_rest_route('gm/v1', 'coordinates/(?P<parent>[0-9]+)/(?P<latitude>[0-9\-\.]+)/(?P<longitude>[0-9\-\.]+)/(?P<distance>[0-9]+)', array('methods' => 'GET', 'callback' => 'wpc_check_exist_coordinates_callback'));   

      register_rest_route('gm/v1', 'terminals/(?P<parent>[0-9]+)/(?P<serial>[a-z\0-9]+)', array('methods' => 'GET', 'callback' => 'wpc_check_exist_terminal_callback'));         

       register_rest_route('gm/v1', 'cameras/(?P<parent>[0-9]+)/(?P<name>[a-z\0-9\_]+)', array('methods' => 'GET', 'callback' => 'wpc_check_exist_camera_callback')); 

       register_rest_route('gm/v1', 'recognitions/(?P<parent>[0-9]+)/(?P<name>[a-z\0-9\_]+)', array('methods' => 'GET', 'callback' => 'wpc_check_exist_recognition_callback')); 

       register_rest_route('gm/v1', 'days/(?P<parent>[0-9]+)/(?P<name>[a-z\0-9]+)', array('methods' => 'GET', 'callback' => 'wpc_check_exist_day_callback')); 

    }

    // CHECK LOCATION EXIST ON DISTANCE //  

    function wpc_check_exist_coordinates_callback( $request_data ) 
    {
        $parameters = $request_data->get_params();     

        if ( !isset( $parameters['parent'] ) || empty($parameters['parent']) )
          return array( 'error' => 'no_parameter_given' );

        if ( !isset( $parameters['latitude'] ) || empty($parameters['latitude']) )
          return array( 'error' => 'no_parameter_given' );

        if ( !isset( $parameters['longitude'] ) || empty($parameters['longitude']) )
          return array( 'error' => 'no_parameter_given' );

        if ( !isset( $parameters['distance'] ) || empty($parameters['distance']) )
          return array( 'error' => 'no_parameter_given' );

        $post_parent    = $parameters['parent'];   
        $latitudeFrom   = $parameters['latitude'];   
        $longitudeFrom  = $parameters['longitude']; 
        $dist           = $parameters['distance'];  

        $latFrom = floatval($latitudeFrom);
        $lonFrom = floatval($longitudeFrom);
        $parent  = floatval($post_parent);

        $logparams = "parent: ".$parent." latFrom: ".$latFrom." lonFrom: ".$lonFrom." dist: ".$dist;

        //write_log_file($logparams); 

        $d = floatval($dist);   

        $args = Array(
            'post_type'         => 'location',
            'posts_per_page'    => -1,
            'meta_key'          => 'post_parent',            
            'meta_query'        => array(
                 array(
                        'key'       => 'post_parent',
                        'compare'   => '=',
                        'value'     => $parent,
                        'type'      => 'numeric'
                 )
            ),
        );        
        
        $status = 8001;

        $query = new WP_Query( $args );

        if($query->have_posts())
        {
            while($query->have_posts())
            {               

                $query->the_post();

                global $post;

                //write_log_file("ID: ".$post->ID); 

                $latitudeTo  = get_post_meta($post->ID,'locaton_latitude',true);
                $longitudeTo = get_post_meta($post->ID,'locaton_longitude',true);

                $latTo = floatval($latitudeTo);
                $lonTo = floatval($longitudeTo);

                $basecords  = " latTo: ".$latTo." lonTo: ".$lonTo;

                //write_log_file($basecords); 

                $distance_between = greatCircleDistance($latFrom, $lonFrom, $latTo, $lonTo);

                //write_log_file("distance_between: ".$distance_between." d: ".$d); 

                if ( $distance_between < $d )
                {
                  $status = 8001;
                  $data = array ( true, $post->ID);
                  $response = response($data, $status);   
                  return $response;                     
                }
            }    

        } else 
        {
          write_log_file("query_no_posts"); 
        }  

        $response = response( array (false), $status);   
        return $response;   
    }

    function response ($exist, $status )
    {
        $data = array( $exist );        
        $response = new WP_REST_Response( $data );                  
        $response->set_status( $status ); 
        return $response;   
    }


    /**
     * Calculates the great-circle distance between two points, with
     * the Vincenty formula.
     * @param float $latitudeFrom Latitude of start point in [deg decimal]
     * @param float $longitudeFrom Longitude of start point in [deg decimal]
     * @param float $latitudeTo Latitude of target point in [deg decimal]
     * @param float $longitudeTo Longitude of target point in [deg decimal]
     * @param float $earthRadius Mean earth radius in [m]
     * @return float Distance between points in [m] (same as earthRadius)
     */
    function greatCircleDistance($latitudeFrom, $longitudeFrom, $latitudeTo, $longitudeTo)
    {
      
      $earthRadius = 6371000;

      // convert from degrees to radians
      $latFrom = deg2rad($latitudeFrom);
      $lonFrom = deg2rad($longitudeFrom);
      $latTo = deg2rad($latitudeTo);
      $lonTo = deg2rad($longitudeTo);

      $lonDelta = $lonTo - $lonFrom;
      $a = pow(cos($latTo) * sin($lonDelta), 2) +
        pow(cos($latFrom) * sin($latTo) - sin($latFrom) * cos($latTo) * cos($lonDelta), 2);
      $b = sin($latFrom) * sin($latTo) + cos($latFrom) * cos($latTo) * cos($lonDelta);

      $angle = atan2(sqrt($a), $b);
      return $angle * $earthRadius;

    }

    // CHECK TERMINAL EXIST ON LOCATION //   

    function wpc_check_exist_terminal_callback( $request_data ) 
    {
        $parameters = $request_data->get_params();     

        if ( !isset( $parameters['parent'] ) || empty($parameters['parent']) )
          return array( 'error' => 'no_parameter_given' );

        if ( !isset( $parameters['serial'] ) || empty($parameters['serial']) )
          return array( 'error' => 'no_parameter_given' );
       
        $post_parent         = $parameters['parent'];   
        $serial              = $parameters['serial'];   
       
        $parent  = floatval($post_parent);

        $logparams = "parent: ".$parent." description: ".$description;

        //write_log_file($logparams);          

        $args = Array(
            'post_type'         => 'terminal',
            'posts_per_page'    => -1,
            'meta_key'          => 'post_parent',            
            'meta_query'        => array(
                 array (
                        'key'       => 'post_parent',
                        'compare'   => '=',
                        'value'     => $parent,
                        'type'      => 'numeric'
                 )
            ),
        );        
        
        $status = 8001;

        $query = new WP_Query( $args );

        if($query->have_posts())
        {
            while($query->have_posts())
            {               

                $query->the_post();

                global $post;

                //write_log_file("ID: ".$post->ID); 

                $tserial = get_post_meta($post->ID,'terminal_serial',true);
                
                //write_log_file(" tserial: ".$tserial." serial: ".$serial); 

                if ($tserial==$serial)
                {         
                  $status = 8001;
                  $data = array ( true, $post->ID);
                  $response = response($data, $status);   
                  return $response;                     
                }
            }    

        } else 
        {
          write_log_file("query_no_posts"); 
        }  

        $response = response( array (false), $status);   
        return $response;   
    }

    // CHECK CAMERA EXIST ON TERMINAL //   

    function wpc_check_exist_camera_callback( $request_data ) 
    {
        $parameters = $request_data->get_params();     

        if ( !isset( $parameters['parent'] ) || empty($parameters['parent']) )
          return array( 'error' => 'no_parameter_given' );

        if ( !isset( $parameters['name'] ) || empty($parameters['name']) )
          return array( 'error' => 'no_parameter_given' );
       
        $post_parent         = $parameters['parent'];   
        $name                = modify($parameters['name']);   
       
        $parent  = floatval($post_parent);

        $logparams = "parent: ".$parent." name: ".$name;

        //write_log_file($logparams);          

        $args = Array (
            'post_type'         => 'camera',
            'posts_per_page'    => -1,
            'meta_key'          => 'post_parent',            
            'meta_query'        => array(
                 array (
                        'key'       => 'post_parent',
                        'compare'   => '=',
                        'value'     => $parent,
                        'type'      => 'numeric'
                 )
            ),
        );        
        
        $status = 8001;

        $query = new WP_Query( $args );

        if($query->have_posts())
        {
            while($query->have_posts())
            {               

                $query->the_post();

                global $post;

                //write_log_file("ID: ".$post->ID); 

                $cameraname = get_post_meta($post->ID,'camera_name',true);
                
                //write_log_file(" cameraname: ".$cameraname." name: ".$name); 

                if ($cameraname==$name)
                {         
                  $status = 8001;
                  $data = array ( true, $post->ID);
                  $response = response($data, $status);   
                  return $response;                     
                }
            }    

        } else 
        {
          write_log_file("query_no_posts"); 
        }  

        $response = response( array (false), $status);   
        return $response;   
    }

    function modify($str) 
    {
      return ucwords(str_replace("_", " ", $str));
    }

    // CHECK RECOGNITION EXIST ON CAMERA //   

    function wpc_check_exist_recognition_callback( $request_data ) 
    {
        $parameters = $request_data->get_params();     

        if ( !isset( $parameters['parent'] ) || empty($parameters['parent']) )
          return array( 'error' => 'no_parameter_given' );

        if ( !isset( $parameters['name'] ) || empty($parameters['name']) )
          return array( 'error' => 'no_parameter_given' );
       
        $post_parent         = $parameters['parent'];   
        $name                = modify($parameters['name']);   
       
        $parent  = floatval($post_parent);

        $logparams = "parent: ".$parent." name: ".$name;

        //write_log_file($logparams);          

        $args = Array (
            'post_type'         => 'recognition',
            'posts_per_page'    => -1,
            'meta_key'          => 'post_parent',            
            'meta_query'        => array(
                 array (
                        'key'       => 'post_parent',
                        'compare'   => '=',
                        'value'     => $parent,
                        'type'      => 'numeric'
                 )
            ),
        );        
        
        $status = 8001;

        $query = new WP_Query( $args );

        if($query->have_posts())
        {
            while($query->have_posts())
            {               

                $query->the_post();

                global $post;

                //write_log_file("ID: ".$post->ID); 

                $recognitionname = get_post_meta($post->ID,'recognition_name',true);

                $recognition_thumbnail_id = get_post_meta($post->ID,'recognition_thumbnail_id', true);               
                
                //write_log_file(" recognitionname: ".$recognitionname." name: ".$name); 

                if ( $recognitionname == $name )
                {         
                  $status = 8001;
                  $data = array ( true, $post->ID, $recognition_thumbnail_id);
                  $response = response($data, $status);   
                  return $response;                     
                }
            }    

        } else 
        {
          write_log_file("query_no_posts"); 
        }  

        $response = response( array (false), $status);   
        return $response;   
    }

    // CHECK DAY EXIST ON RECOGNITION //   

    function wpc_check_exist_day_callback( $request_data ) 
    {
        $parameters = $request_data->get_params();     

        if ( !isset( $parameters['parent'] ) || empty($parameters['parent']) )
          return array( 'error' => 'no_parameter_given' );

        if ( !isset( $parameters['name'] ) || empty($parameters['name']) )
          return array( 'error' => 'no_parameter_given' );
       
        $post_parent         = $parameters['parent'];   
        $name                = modify($parameters['name']);   
       
        $parent  = floatval($post_parent);

        $logparams = "parent: ".$parent." name: ".$name;

        //write_log_file($logparams);          

        $args = Array (
            'post_type'         => 'day',
            'posts_per_page'    => -1,
            'meta_key'          => 'post_parent',            
            'meta_query'        => array(
                 array (
                        'key'       => 'post_parent',
                        'compare'   => '=',
                        'value'     => $parent,
                        'type'      => 'numeric'
                 )
            ),
        );        
        
        $status = 400;

        $query = new WP_Query( $args );

        if($query->have_posts())
        {
            while($query->have_posts())
            {               

                $query->the_post();

                global $post;

                //write_log_file("ID: ".$post->ID); 

                $dayname = get_post_meta($post->ID,'day_label',true);
                
                //write_log_file(" dayname: ".$dayname." name: ".$name); 

                if ( $dayname == $name )
                {         
                  $status = 200;
                  $data = array ( true, $post->ID);
                  $response = response($data, $status);   
                  return $response;                     
                }
            }    

        } else 
        {
          write_log_file("query_no_posts"); 
        }  

        $response = response( array (false), $status);   
        return $response;   
    }


    // WEB / MOBILE APP RESPONSES // 

    add_action('rest_api_init', 'wpc_register_wp_api_endpoints');

    function wpc_register_wp_api_endpoints() 
    {

      register_rest_route('gm/v1', 'devices/(?P<client>[0-9]+)', array('methods' => 'GET', 'callback' => 'wpc_get_client_callback'));

      register_rest_route('gm/v1', 'notification/(?P<postid>[0-9]+)', array('methods' => 'GET', 'callback' => 'wpc_get_notification_callback'));

      register_rest_route('gm/v1', 'notifications/(?P<pfuser>[a-z\0-9\_\-]+)', array('methods' => 'GET', 'callback' => 'wpc_get_notifications_by_client_callback'));

      register_rest_route('gm/v1', 'client/', array('methods' => 'GET', 'callback' => 'wpc_get_grabmoclients_callback'));

      register_rest_route('gm/v1', 'client/me/(?P<user>[a-z\0-9\_]+)/(?P<password>[a-z\0-9\_\-]+)', array('methods' => 'GET', 'callback' => 'wpc_get_grabmoclient_me_callback'));

    }     

    function wpc_get_client_callback( $request_data ) 
    {
        $parameters = $request_data->get_params();     

        if ( !isset( $parameters['client'] ) || empty($parameters['client']) )
          return array( 'error' => 'no_parameter_given' );
      
        $clientinfo         = $parameters['client'];           
        $clientId           = floatval($clientinfo);

        //302 encontrado
        //303 encontrar otro
        //400 bad request
        
        write_log_file("************************"); 

        $logparams = "client: ".$clientId;
        
        write_log_file($logparams);               

        $array_response  = Array();

        $client_first_name      = get_post_meta($clientId,'client_first_name',true);
        $client_last_name       = get_post_meta($clientId,'client_last_name',true);
        $client_user_name       = get_post_meta($clientId,'client_user_name',true);
        $client_thumbnail_url   = get_post_meta($clientId,'client_thumbnail_url',true);
        $client_thumbnail_id    = get_post_meta($clientId,'client_thumbnail_id',true);
        $client_permalink       = get_post_permalink($clientId);
        $client_href            = get_bloginfo('url').'/wp-json/wp/v2/client/'.$clientId;

        //write_log_file("client_first_name: ".$client_first_name);
        //write_log_file("client_last_name: ".$client_last_name);
        //write_log_file("client_user_name: ".$client_user_name); 
        //write_log_file("client_thumbnail_url: ".$client_thumbnail_url); 
        //write_log_file("client_permalink: ".$client_permalink); 
        //write_log_file("client_href: ".$client_href); 

        $array_response = Array();
        $array_camera_terminal = Array();
       
        $array_client = Array (
            'id'                    => $clientId,            
            'first_name'            => $client_first_name,
            'last_name'             => $client_last_name,
            'client_user_name'      => $client_user_name,
            'client_thumbnail_url'  => $client_thumbnail_url,
            'client_thumbnail_id'   => $client_thumbnail_id,
            'client_permalink'      => $client_permalink,
            'client_href'           => $client_href,
        );       

        $args = Array (
            'post_type'         => 'location',
            'posts_per_page'    => -1,
            'meta_key'          => 'post_parent',            
            'meta_query'        => array (
                 array (
                        'key'       => 'post_parent',
                        'compare'   => '=',
                        'value'     => $clientId,
                        'type'      => 'numeric'
                 )
            ),
        );

        $query = new WP_Query( $args );

        if ($query->have_posts())
        {
            while ($query->have_posts())
            {               

                $query->the_post();

                global $post;

                write_log_file("ID: ".$post->ID); 

                $locaton_as               = get_post_meta($post->ID, 'locaton_as',true);
                $locaton_city             = get_post_meta($post->ID, 'locaton_city',true);
                $locaton_country          = get_post_meta($post->ID, 'locaton_country',true);
                $locaton_isp              = get_post_meta($post->ID, 'locaton_isp',true);
                $locaton_latitude         = get_post_meta($post->ID, 'locaton_latitude',true);
                $locaton_longitude        = get_post_meta($post->ID, 'locaton_longitude',true);
                $locaton_region_name      = get_post_meta($post->ID, 'locaton_region_name',true);                
                $locaton_country_code     = get_post_meta($post->ID, 'locaton_country_code',true);  
                $locaton_region_time_zone = get_post_meta($post->ID, 'locaton_region_time_zone',true);
                $location_permalink       = get_post_permalink($post->ID);
                $location_href            = get_bloginfo('url').'/wp-json/wp/v2/location/'.$post->ID;
                
                //write_log_file("locaton_as: ".              $locaton_as);
                //write_log_file("locaton_city: ".            $locaton_city);
                //write_log_file("locaton_country: ".         $locaton_country); 
                //write_log_file("locaton_isp: ".             $locaton_isp); 
                //write_log_file("locaton_latitude: ".        $locaton_latitude); 
                //write_log_file("locaton_longitude: ".       $locaton_longitude); 
                //write_log_file("locaton_region_name: ".     $locaton_region_name); 
                //write_log_file("locaton_country_code: ".    $locaton_country_code); 
                //write_log_file("locaton_region_time_zone: ".$locaton_region_time_zone);
                //write_log_file("location_permalink: ".      $location_permalink);  
                //write_log_file("location_href: ".           $location_href);  

                    
                $post_terminal_children = get_post_meta($post->ID,'post_children',true);   

                foreach ( $post_terminal_children as $terminalid ) 
                { 

                  write_log_file("terminalid: ".$terminalid);           

                  //////// TERMINAL //////
                  $terminal_name        = get_post_meta($terminalid,'terminal_name',true);
                  $terminal_hardware        = get_post_meta($terminalid,'terminal_hardware',true);               
                  $terminal_serial          = get_post_meta($terminalid,'terminal_serial',true);    
                  $terminal_uptime          = get_post_meta($terminalid,'terminal_uptime',true);         
                  $terminal_public_ipnumber = get_post_meta($terminalid,'terminal_public_ipnumber',true);  
                  $terminal_hostname        = get_post_meta($terminalid,'terminal_hostname',true);
                  $terminal_ipnumber        = get_post_meta($terminalid,'terminal_ipnumber',true);
                  $terminal_add_macaddress  = get_post_meta($terminalid,'terminal_macaddress',true);            
                  $terminal_disk_used       = get_post_meta($terminalid,'terminal_disk_used',true);  
                  $terminal_disk_available  = get_post_meta($terminalid,'terminal_disk_available',true);
                  $terminal_keepalive_time  = get_post_meta($terminalid,'terminal_keepalive_time',true); 
                  $terminal_permalink       = get_post_permalink($terminalid);   
                  $terminal_href            = get_bloginfo('url').'/wp-json/wp/v2/terminal/'.$terminalid;  

                  $array_terminal   = Array ( 
                      'locaton_id'                  =>  $post->ID,
                      'locaton_as'                  =>  $locaton_as,
                      'locaton_city'                =>  $locaton_city,
                      'locaton_country'             =>  $locaton_country,
                      'locaton_isp'                 =>  $locaton_isp,
                      'locaton_latitude'            =>  $locaton_latitude,
                      'locaton_longitude'           =>  $locaton_longitude,
                      'locaton_region_name'         =>  $locaton_region_name,
                      'locaton_country_code'        =>  $locaton_country_code,
                      'locaton_region_time_zone'    =>  $locaton_region_time_zone,
                      'location_permalink'          =>  $location_permalink,
                      'location_href'               =>  $location_href,
                      ////////////////////////////////////////////////////////////       
                      'terminal_id'                 =>  $terminalid,
                      'terminal_name'               =>  $terminal_name,
                      'terminal_hardare'            =>  $terminal_hardware,
                      'terminal_serial'             =>  $terminal_serial,
                      'terminal_uptime'             =>  $terminal_uptime,
                      'terminal_ip_number_lan'      =>  $terminal_ipnumber,
                      'terminal_public_ip_number'   =>  $terminal_public_ipnumber,
                      'terminal_hostname'           =>  $terminal_hostname,
                      'terminal_macaddress'         =>  $terminal_macaddress,
                      'terminal_disk_used'          =>  $terminal_disk_used,
                      'terminal_disk_available'     =>  $terminal_disk_available,
                      'terminal_keep_alive'         =>  $terminal_keepalive_time,
                      'terminal_permalink'          =>  $terminal_permalink,
                      'terminal_href'               =>  $terminal_href,                 
                  );

                  $array_cameras = Array();

                  $post_camera_children = get_post_meta($terminalid,'post_children',true);

                  foreach ( $post_camera_children as $cameraid ) 
                  {                     
                      write_log_file("cameraid: ".$cameraid);                    

                      $camera_name = get_post_meta($cameraid,'camera_name',true);
                      $camera_number = get_post_meta($cameraid,'camera_number',true);
                      $camera_keepalive_time = get_post_meta($cameraid,'camera_keepalive_time',true);
                      $camera_permalink       = get_post_permalink($cameraid);  
                      $camera_href            = get_bloginfo('url').'/wp-json/wp/v2/camera/'.$cameraid;

                      write_log_file("camera_name: ".$camera_name);
                      write_log_file("camera_number: ".$camera_number);
                      write_log_file("client_user_name: ".$camera_keepalive_time);
                      
                      $array_camera   = Array (       
                            'id'              =>  $cameraid,                   
                            'name'            =>  $camera_name,
                            'number'          =>  $camera_number,
                            'keep_alive'      =>  $camera_keepalive_time,
                            'camera_permalink'=>  $camera_permalink,
                            'camera_href'     =>  $camera_href,                                                  
                      );                    

                      $post_recognition_children = get_post_meta($cameraid,'post_children',true);   

                      foreach ( $post_recognition_children as $recognitionid ) 
                      { 

                        write_log_file("recognitionid: ".$recognitionid);           

                        $recognition_name           = get_post_meta($recognitionid,'recognition_name',true);
                        $recognition_region         = get_post_meta($recognitionid,'recognition_region',true);
                        $recognition_delay          = get_post_meta($recognitionid,'recognition_delay',true);
                        $recognition_runatstartup   = get_post_meta($recognitionid,'recognition_runatstartup',true);    
                        $recognition_interval       = get_post_meta($recognitionid,'recognition_interval',true);        
                        $recognition_screen         = get_post_meta($recognitionid,'recognition_screen',true);          
                        $recognition_running        = get_post_meta($recognitionid,'recognition_running',true);  
                        $recognition_media_url      = get_post_meta($recognitionid,'recognition_media_url',true);       
                        $recognition_keepalive_time = get_post_meta($recognitionid,'recognition_keepalive_time',true);
                        $recognition_permalink      = get_post_permalink($recognitionid);  
                        $recognition_href           = get_bloginfo('url').'/wp-json/wp/v2/recognition/'.$recognitionid;                  
                        $array_recognition   = Array ( 
                            'id'              =>    $recognitionid,        
                            'name'            =>    $recognition_name,
                            'region'          =>    $recognition_region,
                            'delay'           =>    $recognition_delay,
                            'runatstartup'    =>    $recognition_runatstartup,
                            'interval'        =>    $recognition_interval,
                            'screen'          =>    $recognition_screen,
                            'running'         =>    $recognition_running,
                            'media_url'       =>    $recognition_media_url,
                            'keep_alive'      =>    $recognition_keepalive_time,
                            'recognition_permalink'=>    $recognition_permalink,
                            'recognition_href'     =>    $recognition_href,                
                        );

                        $post_day_children = get_post_meta($recognitionid,'post_children',true);                      

                        foreach ( $post_day_children as $dayid ) 
                        {

                            write_log_file("dayid: ".$dayid);
                            
                            $day_label            = get_post_meta($dayid,'day_label',true);
                            $day_keepalive_time   = get_post_meta($dayid,'day_keepalive_time',true);
                            $day_permalink        = get_post_permalink($dayid);  
                            $day_href             = get_bloginfo('url').'/wp-json/wp/v2/day/'.$dayid;

                            $array_day   = Array(                          
                              'label'           =>    $day_label,
                              'keep_alive'      =>    $day_keepalive_time,
                              'day_permalink'   =>    $day_permalink,
                              'day_href'        =>    $day_href,
                            );

                            $post_instance_children = get_post_meta($dayid,'post_children',true); 

                            $array_instances_for_camera = Array();

                            foreach ( $post_instance_children as $instanceid ) 
                            {

                                write_log_file("instanceid: ".$instanceid);

                                array_push($array_instances_for_camera, $instanceid);
                            
                                $instance_number      = get_post_meta($instanceid,'instance_number',true);
                                $instance_begintime   = get_post_meta($instanceid,'instance_begintime',true);
                                $instance_endtime     = get_post_meta($instanceid,'instance_endtime',true);        
                                $instance_media_id   = get_post_meta($instanceid,'instance_media_id',true);
                                $instance_elapsed     = strval($instance_endtime) - strval($instance_begintime);
                                $instance_permalink   = get_post_permalink($instanceid);  
                                $instance_href        = get_bloginfo('url').'/wp-json/wp/v2/instance/'.$instanceid;

                                $instance_media = wp_get_attachment_image_src($instance_media_id)[0];

                                $array_instance   = Array(        
                                  'id'            =>  $instanceid,              
                                  'number'        =>  $instance_number,
                                  'elapsed_time'  =>  $instance_elapsed,            
                                  'media_url'     =>  $instance_media,
                                  'instance_permalink'  =>    $instance_permalink,
                                  'instance_href'       =>    $instance_href,   
                                );

                                $array_day['instances'][] = $array_instance;
                            }

                            ////// GET LAST IMAGE FOR CAMERA                    

                            $last_post_id_for_camera_image = max($array_instances_for_camera);                    

                            $last_instance_media_id = get_post_meta($last_post_id_for_camera_image,'instance_media_id',true);                   

                            $array_camera['last_media_url'] = wp_get_attachment_image_src($last_instance_media_id)[0];
                            
                            //////////////// 

                            $array_recognition['days'][] = $array_day; 

                        } 

                        $array_camera['recognitions'][] = $array_recognition;

                      }                

                      $array_terminal['cameras'][] = $array_camera;             
                  }                           

                  $array_client['terminals'][] = $array_terminal;               
                }
                
            }    

            $response = new WP_REST_Response( $array_client );       
            $response->set_status( 200 ); 
            return $response;  

        } else 
        {          
          $response = new WP_REST_Response( "error" );                 
          $response->set_status( 410 ); 
          return $response;
        }

    }

    function wpc_get_notifications_by_client_callback( $request_data ) 
    {
          $parameters = $request_data->get_params();     

          if ( !isset( $parameters['pfuser'] ) || empty($parameters['pfuser']) )
            return array( 'error' => 'no_parameter_given' );
        
          $pfuser = $parameters['pfuser'];                      

          $query_push = "SELECT post_id FROM wp_gm_notification WHERE pfuser='".$pfuser."';";

          global $wpdb;
          $resutls = $wpdb->get_results($query_push);          
          $count = $wpdb->num_rows;     

          if ($count>0)
          {                           

              $array_notifications = Array();
              $ids = Array();

              foreach ( $resutls as $resutl ) 
              {  
                  
                  //NOTIFICATION IDS
                  $instanceid = intval($resutl->post_id);
                  $dayid          = get_post_meta($instanceid, "post_parent", true);
                  $recognitionid  = get_post_meta($dayid, "post_parent", true);
                  $cameraid       = get_post_meta($recognitionid, "post_parent", true);
                  $terminalid     = get_post_meta($cameraid, "post_parent", true);
                  $locationid     = get_post_meta($terminalid, "post_parent", true);                
                 
                  $terminal_name        = get_post_meta($terminalid,'terminal_name',true);
                  $camera_name          = get_post_meta($cameraid,'camera_name',true);

                  $instance_begintime   = get_post_meta($instanceid,'instance_begintime',true);
                  $instance_endtime     = get_post_meta($instanceid,'instance_endtime',true);  

                  $instance_elapsed     = strval($instance_endtime) - strval($instance_begintime);

                  $instance_media_id    = get_post_meta($instanceid,'instance_media_id',true);
                  $instance_media       = wp_get_attachment_image_src($instance_media_id)[0];

                  $day_label            = get_post_meta($dayid,'day_label',true);

                  $recognition_name     = get_post_meta($recognitionid,'recognition_name',true);          
                  $locaton_city         = get_post_meta($locationid, 'locaton_city',true);

                  $array_notification   = Array 
                  (
                      'instance_id'                 =>  $instanceid,                
                      'terminal_name'               =>  $terminal_name,
                      'camera_name'                 =>  $camera_name,              
                      'instance_elapsed_time'       =>  $instance_elapsed,
                      'instance_media_url'          =>  $instance_media,              
                      'day_label'                   =>  $day_label,              
                      'recognition_name'            =>  $recognition_name,
                      'locaton_city'                =>  $locaton_city,            
                  );

                  $array_notifications['notifications'][] = $array_notification;
              }
              

              $response = new WP_REST_Response( $array_notifications );       
              $response->set_status( 200 ); 
              return $response; 

          } else
          {

                $args = array(                          
                    'error' => 'no notifications found for user '.$pfuser
                );     
                $response = new WP_REST_Response( $args );                
                $response->set_status( 410 ); 
                return $response;

          }

    }

    
    ////////////// NOTIFICATION ENDPOINT //////////////

      function wpc_get_notification_callback( $request_data ) 
      {
          $parameters = $request_data->get_params();     

          if ( !isset( $parameters['postid'] ) || empty($parameters['postid']) )
            return array( 'error' => 'no_parameter_given' );
        
          $instanceid     = $parameters['postid'];                      

          //NOTIFICATION IDS
          $dayid          = get_post_meta($instanceid, "post_parent", true);
          $recognitionid  = get_post_meta($dayid, "post_parent", true);
          $cameraid       = get_post_meta($recognitionid, "post_parent", true);
          $terminalid     = get_post_meta($cameraid, "post_parent", true);
          $locationid     = get_post_meta($terminalid, "post_parent", true);                
         
          $terminal_name        = get_post_meta($terminalid,'terminal_name',true);
          $camera_name          = get_post_meta($cameraid,'camera_name',true);

          $instance_begintime   = get_post_meta($instanceid,'instance_begintime',true);
          $instance_endtime     = get_post_meta($instanceid,'instance_endtime',true);  

          $instance_elapsed     = strval($instance_endtime) - strval($instance_begintime);

          $instance_media_id    = get_post_meta($instanceid,'instance_media_id',true);
          $instance_media       = wp_get_attachment_image_src($instance_media_id)[0];

          $day_label            = get_post_meta($dayid,'day_label',true);

          $recognition_name     = get_post_meta($recognitionid,'recognition_name',true);          
          $locaton_city         = get_post_meta($locationid, 'locaton_city',true);

          $array_notification   = Array 
          (
              'instance_id'                 =>  $instanceid,                
              'terminal_name'               =>  $terminal_name,
              'camera_name'                 =>  $camera_name,              
              'instance_elapsed_time'       =>  $instance_elapsed,
              'instance_media_url'          =>  $instance_media,              
              'day_label'                   =>  $day_label,              
              'recognition_name'            =>  $recognition_name,
              'locaton_city'                =>  $locaton_city,            
          );

          $response = new WP_REST_Response( $array_notification );       
          $response->set_status( 200 ); 
          return $response; 
      }     

      //// CLIENT ////

      function wpc_get_grabmoclient_me_callback( $request_data )
      {        

          $parameters = $request_data->get_params();     

          if ( !isset( $parameters['user'] ) || empty($parameters['user']) )
            return array( 'error' => 'no_parameter_given' );

          if ( !isset( $parameters['password'] ) || empty($parameters['password']) )
            return array( 'error' => 'no_parameter_given' );     

          if ( !empty( $parameters['user'] ) && !empty( $parameters['password'] ) )
          {       

              write_log_file("entra: ".$parameters['user']." ".$parameters['password']);

              $userdata = array();  

              $userdata['user_login'] = $parameters['user'];
              $userdata['user_password'] = $parameters['password'];

              //echo json_encode($userdata);
                           
              //write_log_file(json_encode($userdata)); 

              //wp_signon sanitizes login input
              $user = wp_signon( $userdata, false );
              
              if ( is_wp_error($user) )
              {

                  write_log_file('error loging'); 
                  
                  $message = Array();

                  //Return error messages
                  $code = 0;
                  if(isset($user->errors['invalid_username']))
                  {
                      $code=401;
                      $message['error'] = "Invalid Username";

                  } elseif(isset($user->errors['incorrect_password']))
                  {
                      $code=401;
                      $message['error'] = "Incorrect Password";
                  }
                  
                  $response_error = new WP_REST_Response( $message );           
                  $response_error->set_status( $code ); 
                  return $response_error;
                        
              } else 
              {

                  //$user_id = apply_filters( 'determine_current_user', false );

                  //echo json_encode($user);

                  wp_set_current_user( $user );

                  $current_user_id = floatval(get_current_user_id());                   

                  $args = array(
                      'author' => $current_user_id,
                      'post_type' => 'client',
                  );       

                  write_log_file("current_user_id: ".$current_user_id);

                  $query = new WP_Query( $args );

                  if ($query->have_posts())
                  {
                      
                      while ($query->have_posts())
                      {               

                          $query->the_post();

                          global $post;

                          $client_array = get_client_info($post);

                          $response = new WP_REST_Response( $client_array );       
                          $response->set_status( 200 ); 
                          return $response;

                      }

                  } else 
                  {       
                    $args = array(                          
                        'error' => 'client not found'
                    );     
                    $response = new WP_REST_Response( $args );                
                    $response->set_status( 410 ); 
                    return $response;
                  }
                }

            } 
            else 
            {        
              $args = array(                  
                'error' => 'no params given'                
              );     
              $response = new WP_REST_Response( $args );                              
              $response->set_status( 410 ); 
              return $response;
           }         
     }

     function get_client_info($post)
     {

        $client_author      = $post->post_author; 
        $client_date        = $post->post_date_gmt;
        $client_author_url  = get_bloginfo('url').'/wp-json/wp/v2/users/'.$post->ID;
        $client_permalink   = get_post_permalink($post->ID);
        $client_children    = get_post_meta($post->ID, "post_children", true);
        $count = count($client_children); 
        $arraychilds = Array();
        if ( $count > 0 ) 
        {
          foreach ( $client_children as $child ) 
          {                     
              array_push($arraychilds, $child);
          }
        }
        $client_first_name  = get_post_meta($post->ID, "client_first_name", true);
        $client_last_name   = get_post_meta($post->ID, "client_last_name", true);
        $client_user_name   = get_post_meta($post->ID, "client_user_name", true);
        $client_email       = get_post_meta($post->ID, "client_email", true);
        $client_thumbnail_url   = get_post_meta($post->ID, "client_thumbnail_url", true);
        $client_thumbnail_id    = get_post_meta($post->ID, "client_thumbnail_id", true);
        $client_location    = get_post_meta($post->ID, "client_location", true); 
        $client_href        = get_bloginfo('url').'/wp-json/wp/v2/client/'.$post->ID;      

        $array_client  = Array (
              'id'              =>  $post->ID,     
              'author'          =>  $client_author,
              'date'            =>  $client_date,
              'author_url'      =>  $client_author_url,
              'permalink'       =>  $client_permalink, 
              'clidren'         =>  $arraychilds,
              'first_name'      =>  $client_first_name,
              'last_name'       =>  $client_last_name,
              'user_name'       =>  $client_user_name,
              'email'           =>  $client_email,
              'thumbnail_url'   =>  $client_thumbnail_url,
              'thumbnail_id'    =>  $client_thumbnail_id,
              'location'        =>  $client_location,
              'href'            =>  $client_href,
            ); 

        return $array_client;

     }    

     function wpc_get_grabmoclients_callback()
     {        

          $args = array('post_type' => 'client');       

          $query = new WP_Query( $args );

          $array_clients = Array();

          if ($query->have_posts())
          {
              
              while ($query->have_posts())
              {               

                  $query->the_post();

                  global $post;

                  $client_array = get_client_info($post);

                  $array_clients['clients'][] = $client_array;

              }

              $response = new WP_REST_Response( $array_clients );       
              $response->set_status( 200 ); 
              return $response;

          } else 
          {          
            $response = new WP_REST_Response( "error, not found" );                 
            $response->set_status( 410 ); 
            return $response;
          }
     }


     ///////////////////////
     ///  USER ENDPOINT  ///
     ///////////////////////

    add_action('rest_api_init', 'gm_register_user_api_endpoints');

    function gm_register_user_api_endpoints() 
    {

        register_rest_route( 'gm/v1', 'users', array('methods' => 'POST', 'callback' => 'create_grabmo_user'));

        register_rest_route( 'gm/v1', 'users', array('methods' => 'GET', 'callback' => 'get_grabmo_user'));

        register_rest_route( 'gm/v1', 'users/(?P<userid>[0-9]+)', array('methods' => 'GET', 'callback' => 'get_grabmo_user_by_id'));

    }   

    function create_grabmo_user( $request )
    {          

        write_log_file("llega");

        $bodyparams = $request->get_body();

        $body = Array();

        if (is_object(json_decode($bodyparams))) 
        { 
           $body = $bodyparams;
           $body = json_decode( $body, true );
        } else 
        {
          parse_str($bodyparams, $body);  
        }       

        //echo print_r($request);
        //echo print_r("-----------------------");
        //echo print_r($body);
        
        if ( ! empty ( $body ) ) 
        {                                 

            $response_array = array();                     

            //echo 'admin_user: '.$body['admin_user']." admin_password:".$body['admin_password'];

            if ( !empty( $body['admin_user'] ) && !empty( $body['admin_password'] ) )
            {       

                write_log_file("entra: ".$body['admin_user']." ".$body['admin_password']);

                $userdata = array();  

                $userdata['user_login'] = $body['admin_user'];
                $userdata['user_password'] = $body['admin_password'];
                             
                write_log_file(json_encode($userdata)); 

                //wp_signon sanitizes login input
                $admin_user = wp_signon( $userdata, false );
                
                if ( is_wp_error($admin_user) )
                {

                    write_log_file('error loging'); 
                    
                    $message = Array();

                    //Return error messages
                    $code = 0;
                    if(isset($user->errors['invalid_username']))
                    {
                        $code=401;
                        $message['error'] = "Invalid Admin Username";

                    } elseif(isset($user->errors['incorrect_password']))
                    {
                        $code=401;
                        $message['error'] = "Incorrect Admin Password";
                    }
                    
                    $response_error = new WP_REST_Response( $message );           
                    $response_error->set_status( $code ); 
                    return $response_error;
                          
                } else 
                {

                    write_log_file('logged');
                    
                    if ( !isset( $body['new_username'] ) || empty($body['new_username']) )   
                        response_no_parameter_given('new_username');
                    
                    if ( !isset( $body['new_password'] ) || empty($body['new_password']) )
                        response_no_parameter_given('new_password');

                    if ( !isset( $body['new_email'] ) || empty($body['new_email']) )
                        response_no_parameter_given('new_email');

                    $new_user_name = $body['new_username'];
                    $new_password  = $body['new_password'];
                    $new_email     = $body['new_email'];

                    if ( !isset( $body['new_first_name'] ) || empty($body['new_first_name']) )   
                        response_no_parameter_given('new_first_name');
                    
                    if ( !isset( $body['new_last_name'] ) || empty($body['new_last_name']) )
                        response_no_parameter_given('new_last_name');

                    if ( !isset( $body['role'] ) || empty($body['role']) )
                        response_no_parameter_given('new_role');

                    $new_first_name     = $body['new_first_name'];
                    $new_last_name      = $body['new_last_name'];
                    $new_role           = $body['role'];


                    $new_userdata = array (
                      'new_first_name'  =>  $new_first_name,
                      'new_last_name'   =>  $new_last_name,
                      'new_role'  =>  $new_role
                    ); 

                    //echo json_encode($new_userdata);

                    $user_id = username_exists( $userdata['new_username'] );

                    write_log_file('user_id_exist: '.$user_id); 

                    if ( !$user_id and email_exists($new_email) == false ) 
                    {
                      
                        write_log_file('entra: '.$user_id); 

                        $userdata = array (
                          'user_login'  =>  $new_user_name,
                          'user_pass'   =>  $new_password,
                          'user_email'  =>  $new_email,
                          'first_name'  =>  $new_first_name,
                          'last_name'   =>  $new_last_name,
                          'display_name'=>  $new_first_name." ".$new_last_name,
                          'role'        =>  $new_role
                        );                     

                        write_log_file(json_encode($userdata)); 
                        
                        $wp_new_user_id = wp_insert_user( $userdata );

                        write_log_file($wp_new_user_id); 

                        $response_array['wp_userid'] = $wp_new_user_id;                

                        //On success
                        if ( ! is_wp_error( $wp_new_user_id ) ) 
                        {                   

                            $post_author        = $wp_new_user_id; 

                            $client_first_name  = $new_first_name; //$clientdata['client_first_name'];
                            $client_last_name   = $new_last_name; //$clientdata['client_last_name'];
                            $client_user_name   = $new_user_name; //$clientdata['client_user_name'];
                            $client_email       = $new_email; //$clientdata['client_email'];
                            //$client_location    = $body['client_location']; //$clientdata['client_location'];
                            $client_parent      = $clientdata['client_post_parent'];  

                            $client_post = array (
                                  'post_title' => $client_first_name." ".$client_last_name,
                                  'post_status' => 'publish',
                                  'post_type' => 'client',
                                  'post_author' => $post_author
                            );

                            //echo json_encode($client_post);

                            $client_post_id = wp_insert_post( $client_post );

                            if ( ! is_wp_error( $client_post_id ) ) 
                            {

                                $response_array['wp_client_id'] = $client_post_id;
                                $response_array['wp_server_url'] = get_bloginfo('url')."/wp-json/wp/v2/";
                                $response_array['wp_type'] = "client";

                                add_post_meta($client_post_id, "client_first_name", $client_first_name);
                                
                                add_post_meta( $client_post_id, 'client_last_name', $client_last_name );

                                add_post_meta( $client_post_id, 'client_user_name', $client_user_name );

                                add_post_meta( $client_post_id, 'client_email', $client_email );

                                //add_post_meta( $client_post_id, 'client_location', $client_location );

                                add_post_meta( $client_post_id, 'post_parent', $client_parent );                     

                                $client_created = get_post( $client_post_id );
                                
                                $response_array['wp_slug'] = $client_created->post_name;

                                $response_array['wp_link'] = get_permalink($client_post_id);

                                $response_array['wp_api_link'] = $response_array['wp_server_url'].$response_array['wp_type'].'/'.$client_post_id;

                                $status = array (
                                  'wp_userid'          => $response_array['wp_userid'],
                                  'wp_client_id'       => $response_array['wp_client_id'],
                                  'wp_server_url'      => $response_array['wp_server_url'],
                                  'wp_type'            => $response_array['wp_type'],
                                  'wp_slug'            => $response_array['wp_slug'],
                                  'wp_link'            => $response_array['wp_link'],
                                  'wp_api_link'        => $response_array['wp_api_link'],                                  
                                );

                                header('Content-type: application/json');
                                echo json_encode($status);
                                
                                wp_logout();

                                exit ();
                                  
                            } else 
                            {                                
                                $error = 'Cannot insert Client.';         
                                $message['error'] = $error;
                                $response_client = new WP_REST_Response( $message ); 
                                $response_client->set_status( 401 ); 
                                return $response_client;               
                                exit(); 
                            }                            

                           
                    
                        } else 
                        {
                          $error = 'Error creating WP User.';         
                          $message['error'] = $error;
                          $response_client = new WP_REST_Response( $message ); 
                          $response_client->set_status( 401 ); 
                          return $response_client;               
                          exit();                      
                        }

                        wp_logout();

                        exit(); 

                    } else 
                    {         

                        $error = 'User already exists. Password inherited.';
                        $message['error'] = $error;
                        $response_client = new WP_REST_Response( $message ); 
                        $response_client->set_status( 401 ); 
                        return $response_client;               
                        exit();             
                       
                    }
                } 
            } 
            else 
            {                     

                $error = 'Empty parameters.';
                $message['error'] = $error;
                $response_client = new WP_REST_Response( $message ); 
                $response_client->set_status( 401 ); 
                return $response_client;               
                exit();                        
               
            }
        }   
    }

    function get_grabmo_user_by_id( WP_REST_Response $request)
    {
        $parameters = $request->get_params();     

        if ( !isset( $parameters['userid'] ) || empty($parameters['userid']) )
          return array( 'error' => 'no_parameter_given' );
      
        $useridstr    = $parameters['userid'];           
        $userid       = floatval($useridstr);

        $response_created = new WP_REST_Response( get_post($userid) ); 
        $response_created->set_status( 200 ); 
        return $response_created;


    }

    function get_grabmo_user( WP_REST_Response $request)
    {
        $parameters = $request->get_params();     

        if ( !isset( $parameters['userid'] ) || empty($parameters['userid']) )
          return array( 'error' => 'no_parameter_given' );
      
        $useridstr    = $parameters['userid'];           
        $userid       = floatval($useridstr);

        $response_created = new WP_REST_Response( get_post($userid) ); 
        $response_created->set_status( 200 ); 
        return $response_created;


    }
       
?>