package com.example.jose.grabmo_test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.charset.StandardCharsets;


public class ServiceLocator
{
    private String service;
    private int port;
    private int timeout;

    /**
     * ** CONSTRUCTOR **
     *
     * @param port
     * @param timeout
     */
    public ServiceLocator( String serv, int port, int timeout) {

        this.service = serv;
        this.port = port;
        this.timeout = timeout;


    }

    /**
     * Client locating server and sending package.
     *
     * @return InetAddress of Service
     * @throws UnknownHostException
     *             the Service could not be found.
     */
    public DatagramPacket locate() throws UnknownHostException {
        try {
            System.out.println("Client is started!");
            BufferedReader inFromStdIn = new BufferedReader( new InputStreamReader( System.in ) );
            /*
             * Create a packet to the broadcast Address 255.255.255.255
             * with the content "Ping".
             */
            String read = inFromStdIn.readLine();
            byte[] ba = read.getBytes();
            DatagramSocket socket = new DatagramSocket();
            byte adr = (byte) 255;
            byte[] address = { adr, adr, adr, adr };
            InetAddress internetAdress = InetAddress.getByAddress(address);
            DatagramPacket packet = new DatagramPacket(ba, ba.length, internetAdress, port);
            /* Send Ping request. */
            socket.send(packet);
            /* Wait for response 5000 milliseconds. */
            socket.setSoTimeout(timeout);
            socket.receive(packet);

            /*
             * Return the address.
             */
            return packet;
        } catch (final IOException e) {
            /* If there is an error throw that the host isn't found. */
            throw new UnknownHostException();
        }
    }

}