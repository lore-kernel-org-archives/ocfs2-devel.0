From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 9 Apr 2009 17:11:09 -0700
Subject: [Ocfs2-devel] ocfs2_controld.cman
In-Reply-To: <20090408222237.GC8561@mail.oracle.com>
References: <20090408213317.GC11662@redhat.com>
	<20090408222237.GC8561@mail.oracle.com>
Message-ID: <20090410001109.GD9811@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 08, 2009 at 03:22:37PM -0700, Joel Becker wrote:
> On Wed, Apr 08, 2009 at 04:33:17PM -0500, David Teigland wrote:
> > If I start ocfs2_controld.cman in parallel on a few nodes, only one of them
> > starts up, the others exit with one of these errors:
> > 
> > call_section_read at 370: Reading from section "daemon_protocol" on checkpoint "ocfs2:controld" (try 1)
> > call_section_read at 387: Checkpoint "ocfs2:controld" does not have a section named "daemon_protocol"
> > 
> > call_section_read at 370: Reading from section "daemon_protocol" on checkpoint "ocfs2:controld" (try 1)
> > call_section_read at 397: Unable to read section "daemon_protocol" from checkpoint "ocfs2:controld": Object does not exist
> > 
> > It does work ok if I remove those two checks.
> 
> 	These checks are required - otherwise you end up with unsync'd
> daemons, which is crap.
> 	I've changed the daemon to wait indefinitely, and that's
> something lmb was testing.  See the controld-fixes branch of
> ocfs2-tools.git.  That should fix these problems.

	These changes are now in the master branch of ocfs2-tools.git.

Joel

-- 

"To fall in love is to create a religion that has a fallible god."
        -Jorge Luis Borges

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
