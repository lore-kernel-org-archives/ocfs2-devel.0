From: David Teigland <teigland@redhat.com>
Date: Wed, 8 Apr 2009 16:33:17 -0500
Subject: [Ocfs2-devel] ocfs2_controld.cman
Message-ID: <20090408213317.GC11662@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If I start ocfs2_controld.cman in parallel on a few nodes, only one of them
starts up, the others exit with one of these errors:

call_section_read at 370: Reading from section "daemon_protocol" on checkpoint "ocfs2:controld" (try 1)
call_section_read at 387: Checkpoint "ocfs2:controld" does not have a section named "daemon_protocol"

call_section_read at 370: Reading from section "daemon_protocol" on checkpoint "ocfs2:controld" (try 1)
call_section_read at 397: Unable to read section "daemon_protocol" from checkpoint "ocfs2:controld": Object does not exist

It does work ok if I remove those two checks.

Another thing I noticed while looking in the code is that it assumes a single
node will become the first member of a cpg on its own when a bunch of nodes
join at once: daemon_joined(daemon_group.cg_member_count == 1);

This isn't a correct assumption.  It's possible that two or more nodes joining
at once will become initial members together.  (I realize that it's a very
convenient assumption to make after using it in previous pre-cpg programs, and
it may take a fair amount of work to do without.)

Dave
