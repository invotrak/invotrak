require 'rubygems'
require 'fakeweb'

require File.dirname(__FILE__) + '/../invotrak'

FakeWeb.allow_net_connect = false 

# -------------------
# clients
# -------------------
FakeWeb.register_uri :any, /invotrak.com\/api\/2.0.0\/clients\/list/, :body => <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<clients type="array">
  <client>
    <address>123 Fake St
Woburn, MA 01801</address>
    <allow-client-account-line-items type="boolean">false</allow-client-account-line-items>
    <allow-client-account-projects type="boolean">true</allow-client-account-projects>
    <allow-client-account-timesheets type="boolean">false</allow-client-account-timesheets>
    <basecamp-password nil="true"></basecamp-password>
    <basecamp-site nil="true"></basecamp-site>
    <basecamp-username nil="true"></basecamp-username>
    <comments></comments>
    <company-id type="integer">1</company-id>
    <company-name nil="true"></company-name>
    <contact-email>test@example.com</contact-email>
    <contact-name>Test User</contact-name>
    <contact-phone>123-456-7890</contact-phone>
    <created-at type="datetime">2008-11-05T17:21:02-05:00</created-at>
    <default-rate type="decimal">0.0</default-rate>
    <display-status type="boolean">false</display-status>
    <id type="integer">1</id>
    <name>Test Client</name>
    <updated-at type="datetime">2009-03-16T14:03:28-04:00</updated-at>
  </client>
</clients>
EOF

FakeWeb.register_uri :any, /invotrak.com\/api\/2.0.0\/client\//, :body => <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<client>
  <address>123 Fake St
Woburn, MA 01801</address>
  <allow-client-account-line-items type="boolean">false</allow-client-account-line-items>
  <allow-client-account-projects type="boolean">true</allow-client-account-projects>
  <allow-client-account-timesheets type="boolean">false</allow-client-account-timesheets>
  <basecamp-password nil="true"></basecamp-password>
  <basecamp-site nil="true"></basecamp-site>
  <basecamp-username nil="true"></basecamp-username>
  <comments></comments>
  <company-id type="integer">1</company-id>
  <company-name nil="true"></company-name>
  <contact-email>test@example.com</contact-email>
  <contact-name>Test User</contact-name>
  <contact-phone>123-456-7890</contact-phone>
  <created-at type="datetime">2008-11-05T17:21:02-05:00</created-at>
  <default-rate type="decimal">0.0</default-rate>
  <display-status type="boolean">false</display-status>
  <id type="integer">1</id>
  <name>Test Client</name>
  <updated-at type="datetime">2009-03-16T14:03:28-04:00</updated-at>
</client>
EOF

FakeWeb.register_uri :any, /invotrak.com\/api\/2.0.0\/create\/client/, :body => <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<return message="Client succesfully created." result="success"/>
EOF

# -------------------
# projects
# -------------------
FakeWeb.register_uri :any, /invotrak.com\/api\/2.0.0\/projects\/list/, :body => <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<projects type="array">
  <project>
    <client-id type="integer">1</client-id>
    <created-at type="datetime">2009-05-13T18:33:26-04:00</created-at>
    <description></description>
    <id type="integer">1</id>
    <name>Test Project</name>
    <status-id type="integer">1</status-id>
    <updated-at type="datetime">2009-05-13T18:33:26-04:00</updated-at>
  </project>
</projects>
EOF

# -------------------
# invoices
# -------------------
FakeWeb.register_uri :any, /invotrak.com\/api\/2.0.0\/invoices\/(outstanding|paid)\/2009-09-01\/2009-11-01/, :body => <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<invoices type="array">
  <invoice>
    <amount type="decimal">100.0</amount>
    <client-id type="integer">1</client-id>
    <comments></comments>
    <company-id type="integer">1</company-id>
    <created-at type="datetime">2009-09-23T14:14:42-04:00</created-at>
    <id type="integer">1</id>
    <invoice-id>001-A</invoice-id>
    <issued type="date">2009-10-31</issued>
    <payment-received type="date" nil="true"></payment-received>
    <payment-total type="decimal">0.0</payment-total>
    <term type="integer">30</term>
    <updated-at type="datetime">2009-11-04T10:33:17-05:00</updated-at>
  </invoice>
</invoices>
EOF

FakeWeb.register_uri :any, /invotrak.com\/api\/2.0.0\/create\/invoice/, :body => <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<return message="Invoice succesfully created." result="success"/>
EOF
