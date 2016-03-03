<?php
/**
 * @package GrabMotion_Computer_Vision
 * @version 1.0
 */
    
/*
Plugin Name: GrabMotion Computer Vision
Author: Jose Vigil
Version: 1.1
Text Domain: grabmotion-computer-vision
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
    add_action('rest_api_init', 'client_add_client_first_name');
    add_action('rest_api_init', 'client_add_client_last_name');
    add_action('rest_api_init', 'client_add_client_user_name');
    //add_action('rest_api_init', 'client_add_client_authdata');
    add_action('rest_api_init', 'client_add_client_email');
    //add_action('rest_api_init', 'client_add_client_thumbnail_url');
    //add_action('rest_api_init', 'client_add_client_thumbnail_id');
    add_action('rest_api_init', 'client_add_client_location');


    //add_action('rest_api_init', 'client_post_parent');
    
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
    /*function client_post_parent()
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
    }*/

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
    
    //Client AuthData
    /*function client_add_client_authdata()
    {
        register_rest_field('client',
                            'client_authdata',
                            array(
                                  'get_callback'    => 'get_client_authdata',
                                  'update_callback' => 'update_client_authdata',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_client_authdata($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_client_authdata( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }*/

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
    /*function client_add_client_thumbnail_url()
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
    }*/

    //Client Thumbnail Id
    /*function client_add_client_thumbnail_id()
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
    }*/

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
    
    //Add Client Fields
    add_action('rest_api_init', 'location_add_city');
    add_action('rest_api_init', 'location_add_country');
    add_action('rest_api_init', 'location_add_latitude');
    add_action('rest_api_init', 'location_add_longitude');
    add_action('rest_api_init', 'location_add_post_parent');
    
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
    
    //Location Latitude
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
    
    /// TERMINAL
    
    //Add Raspberrypi Taxonomy and Terminal Custom Type
    add_action( 'init', 'digimotion_terminal_init' );
    
    //Add Terminal Fields
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
    
    //Add Recognition Fields
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
    
    // DAY
    
    //Add DAY Custom Type
    add_action( 'init', 'digimotion_day_init' );
    
    //Add Day Fields
    add_action('rest_api_init', 'day_add_post_parent');
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
    
    //Add Instance Fields
    add_action('rest_api_init', 'instance_add_post_parent');
    add_action('rest_api_init', 'instance_add_number');
    add_action('rest_api_init', 'instance_add_begintime');
    add_action('rest_api_init', 'instance_add_endtime');
    add_action('rest_api_init', 'instance_add_code');
    
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
                            'instance_media_url',
                            array(
                                  'get_callback'    => 'get_instance_media_url',
                                  'update_callback' => 'update_instance_media_url',
                                  'schema'          => null,
                                  )
                            );
    }
    function get_instance_media_url($object, $field_name, $request) {
        return get_post_meta($object[ 'id' ], $field_name);
    }
    function update_instance_media_url( $value, $object, $field_name ) {
        if ( ! $value || ! is_string( $value ) ) {
            return;
        }
        return update_post_meta( $object->ID, $field_name, strip_tags( $value ) );
    }
    

    ///////////
    // DEBUG //
    //////////
    
    
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
                    $new_role     = $userdata['new_role'];

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

                      $user_id = wp_insert_user( $userdata );

                      //On success
                      if ( ! is_wp_error( $user_id ) ) 
                      {
                          //$user_created = get_user_by('id', $user_id);
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

                        $client_created = get_post( $client_post_id );

                        echo json_encode( $client_created );

                        wp_logout();
                          
                    } else {
                      
                        $error = 'Cannot insert Client.';
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

                  if ( ! is_wp_error( $attachment_post_id ) ) 
                  {

                     $attach_id_post = get_post( $attach_id );

                    echo json_encode( $attach_id_post );

                    wp_logout();

                  } else {
                      
                      $error = 'Cannot insert Client.';
                      $message['error'] = $error;
                      echo json_encode($message);
 
                  } 
              
                  exit();

                }   
            }   
        }
    }
     
    add_action('after_setup_theme', array($ios_login = new iOSWPLogin,'check_ios_login'));

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

?>


    
   
    
