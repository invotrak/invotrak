require 'invotrak'

invotrak = Invotrak.new
invotrak.establish_connection!('my_api_key')

# Get a list of clients
puts invotrak.clients.inspect

# An alternate means to retrieve a client by ID or name.  The name can also be 
# only a partial part of the name (i.e. "Test" for a "Test Client").
puts invotrak.client("Test").id


# Retrieve invoices, with parameters FROM and TO.  The dates should be parseable 
# by Date.parse (i.e. 2009-01-01).  Note that the API won't return more than 100 
# invoices at a time, so be sure to keep these date ranges reasonable.
puts invotrak.outstanding_invoices("2009-01-01", "2009-06-01").inspect
puts invotrak.paid_invoices("2009-01-01", "2009-06-01").inspect


# Get a list of all projects
puts invotrak.projects.inspect


# Create a new timesheet entry.  You need to know the client ID beforehand, and 
# you need to enter the time in a period of minutes (i.e. 120 for 2 hours).
invotrak.create_timesheet(1, "test entry", 15, "2009-11-11")
