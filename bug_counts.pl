#!/usr/bin/perl

# Copyright Catalyst IT 2011
# chrisc@catalyst.net.nz

# This is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Koha; if not, write to the Free Software Foundation, Inc., 59 Temple Place,
# Suite 330, Boston, MA  02111-1307 USA
#

use LWP::Simple;
use Text::CSV;
use warnings;
use strict;
use CGI;
use File::Cache;

my $cache = new File::Cache( { namespace  => 'MyCache',
				                                 expires_in => 3600,
				                                 filemode => 0600 } );
my $query = new CGI;
my $csv = Text::CSV->new;
my $content = $cache->get('content');
if (! $content){
    my $content=get("http://bugs.koha-community.org/bugzilla3/report.cgi?bug_file_loc=&bug_file_loc_type=allwordssubstr&bug_id=&bug_id_type=anyexact&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfield=cf_patch_status&chfieldfrom=&chfieldto=&chfieldvalue=&deadlinefrom=&deadlineto=&email1=&email2=&email3=&emailassigned_to1=1&emailassigned_to2=1&emailcc2=1&emailqa_contact2=1&emailreporter2=1&emailtype1=substring&emailtype2=substring&emailtype3=substring&field0-0-0=noop&keywords=&keywords_type=allwords&longdesc=&longdesc_type=allwordssubstr&short_desc=&short_desc_type=allwordssubstr&type0-0-0=noop&value0-0-0=&x_axis_field=cf_patch_status&y_axis_field=version&z_axis_field=&width=600&height=350&action=wrap&ctype=csv&format=table");
    $cache->set('content',$content);
}

print $query->header;
#print $query->start_html;
#print $content;
my @lines = split (/\n/,$content);
pop @lines;
print "<h3>Patch statuses</h3>";
print "<h5>Updated hourly</h5>";
    print "<table cellpadding=\"2\">";
    print "<tr><th>Version</th><th>Needs Signoff</th><th>Signed Off</th><th>Pushed</th><th>Failed QA</th><th>Does not apply</th></tr>";
foreach my $line (@lines){
    my $parsed = $csv->parse($line);
    my @columns = $csv->fields();

#    if ($columns[0] eq 'rel_3_4'){
#	print "<h4>Bug Counts for 3.4</h4>";

	print "<tr><td>$columns[0]</td><td>$columns[4]</td><td>$columns[7]</td>
        <td>$columns[5]</td><td>$columns[3]</td><td>$columns[2]</td></tr>";

#    }
 
    }
   print "</table>";
