From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 8 Apr 2009 15:22:37 -0700
Subject: [Ocfs2-devel] ocfs2_controld.cman
In-Reply-To: <20090408213317.GC11662@redhat.com>
References: <20090408213317.GC11662@redhat.com>
Message-ID: <20090408222237.GC8561@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 08, 2009 at 04:33:17PM -0500, David Teigland wrote:
> If I start ocfs2_controld.cman in parallel on a few nodes, only one of them
> starts up, the others exit with one of these errors:
> 
> call_section_read at 370: Reading from section "daemon_protocol" on checkpoint "ocfs2:controld" (try 1)
> call_section_read at 387: Checkpoint "ocfs2:controld" does not have a section named "daemon_protocol"
> 
> call_section_read at 370: Reading from section "daemon_protocol" on checkpoint "ocfs2:controld" (try 1)
> call_section_read at 397: Unable to read section "daemon_protocol" from checkpoint "ocfs2:controld": Object does not exist
> 
> It does work ok if I remove those two checks.

	These checks are required - otherwise you end up with unsync'd
daemons, which is crap.
	I've changed the daemon to wait indefinitely, and that's
something lmb was testing.  See the controld-fixes branch of
ocfs2-tools.git.  That should fix these problems.

> Another thing I noticed while looking in the code is that it assumes a single
> node will become the first member of a cpg on its own when a bunch of nodes
> join at once: daemon_joined(daemon_group.cg_member_count == 1);
> 
> This isn't a correct assumption.  It's possible that two or more nodes joining
> at once will become initial members together.  (I realize that it's a very
> convenient assumption to make after using it in previous pre-cpg programs, and
> it may take a fair amount of work to do without.)

	Well, this is going to be fun.  I have to figure out which
daemon is the "first", and now it's just racy.  I could swear that
someone told me cpg would guarantee i see the joins in order, not at the
same time.

Joel

-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
