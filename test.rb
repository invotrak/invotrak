require 'invotrak'

invotrak = Invotrak.new
invotrak.establish_connection!('445f1f5b3dea21c78fede6ab66b5603c1faa90ff')


puts invotrak.clients.inspect
# puts invotrak.projects.inspect
# puts invotrak.outstanding_invoices("2009-01-01", "2009-06-01").inspect
# puts invotrak.paid_invoices("2009-01-01", "2009-06-01").inspect
# puts invotrak.client("test").id

# puts invotrak.create_timesheet(1, "test entry", 15, "2009-11-11").inspect
