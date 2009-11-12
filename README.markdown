About
-----
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

The username and password will be the same thing used when logging into your Invotrak account via the web interface.

More Info
---------
This library is currently under heavy development, and doesn't support a whole lot.  This document will be updated as functionality is added.

It should be noted that much of the basic connection logic/architecture for this library came from the Basecamp API.  Invotrak's API does not currently support ActiveResource, and instead goes through a versioned access system.  This library handles that and can be made to work with different versions of the API if legacy support is required.