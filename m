From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 9 Apr 2009 11:45:32 -0700
Subject: [Ocfs2-devel] ocfs2_controld.cman
In-Reply-To: <26ef5e70904090438s630b2f11nd0bc1e0b72262748@mail.gmail.com>
References: <20090408213317.GC11662@redhat.com>
	<20090408222237.GC8561@mail.oracle.com>
	<26ef5e70904090438s630b2f11nd0bc1e0b72262748@mail.gmail.com>
Message-ID: <20090409184532.GB30127@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 09, 2009 at 01:38:10PM +0200, Andrew Beekhof wrote:
> On Thu, Apr 9, 2009 at 00:22, Joel Becker <Joel.Becker@oracle.com> wrote:
> >
> > ? ? ? ?Well, this is going to be fun. ?I have to figure out which
> > daemon is the "first", and now it's just racy. ?I could swear that
> > someone told me cpg would guarantee i see the joins in order, not at the
> > same time.
> 
> "In order" does not necessarily imply "one node at a time".
> 
> I don't consider it unreasonable for two nodes starting (effectively)
> simultaneously to appear in the first membership.
> I believe Heartbeat had the same property.
> 
> Why not just take a lock when you want to create the daemon_protocol
> section (and allow the second guy to fail gracefully)?
> Perhaps cpg even has something like this built in...

	I don't want to rely on dlm in this daemon.  These control
daemons are complex enough, they are our only connection between the fs
and the stack,and we need to make them correct.

Joel

-- 

"Ninety feet between bases is perhaps as close as man has ever come
 to perfection."
	- Red Smith

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
