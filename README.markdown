Invotrak API
============

This is the API library in Ruby for the invotrak.com web service.  Invotrak is an online invoice and timesheet tracking site, and the API allows developers to access most of its features.  This Ruby API is evolving, but will eventually allow users to take advantage of everything Invotrak makes available.

Getting Started
---------------
First, make sure you have an account.  You can sign up for free.  Then, go to Settings and make sure you have an API key.  The library allows you to use basic auth instead of an API key, though, if you prefer.

To use this library in your Ruby scripts:

    require 'invotrak'

Establishing a Connection
-------------------------
Before you can make any calls to the API, you need to establish a connection.  There's two ways to do this, with an API key and via Basic AUTH.

    invotrak = Invotrak.new
    
    invotrak.establish_connection!('my_api_key')
    invotrak.establish_connection_basic!('username', 'password')

The username and password will be the same used when logging into your Invotrak account via the web interface.  The API also allows any kind of user to login: admin, employee, and client accounts.  Each has its own set of restrictions though (clients, for instance, can't actually create anything, but can still list some things, like invoices).

Using the API
-------------
Using the library is fairly straightforward.  Take a look at the examples.rb script to see how much of the it works.  There is also a suite of tests using rspec and fakeweb that give you a more in-depth look at what is going on.  You can also modify spec_helper to turn off fakeweb to test the API for real (just be sure you setup an actual account and either your API key or your login/password).

In general though, objects are retrieved either as lists or individually:

    invotrak.clients
    => returns an array of Invotrak::Record objects
    
    invotrak.client('Test')
    => returns a single Invotrak::Record object for Test Client

Creating objects is similarly simple:

    invotrak.create_timesheet(1, "test entry", 15, "2009-11-11")

In that example, a new timesheet entry for 15 minutes will be recorded for November 11th, attached to client ID 1.  In order for create_timesheet to work, you need to know the client's ID you want to associate the timesheet record with.

More Info
---------
This library is currently under heavy development, and doesn't support a whole lot.  This document will be updated as functionality is added.

It should be noted that much of the basic connection logic/architecture for this library came from the Basecamp API.  Invotrak's API does not currently support ActiveResource, and instead goes through a versioned access system.  This library handles that and can be made to work with different versions of the API if legacy support is required.