From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 9 Apr 2009 11:44:15 -0700
Subject: [Ocfs2-devel] ocfs2_controld.cman
In-Reply-To: <20090409161136.GA21456@redhat.com>
References: <20090408213317.GC11662@redhat.com>
	<20090408222237.GC8561@mail.oracle.com>
	<26ef5e70904090438s630b2f11nd0bc1e0b72262748@mail.gmail.com>
	<20090409161136.GA21456@redhat.com>
Message-ID: <20090409184415.GA30127@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 09, 2009 at 11:11:37AM -0500, David Teigland wrote:
> On Thu, Apr 09, 2009 at 01:38:10PM +0200, Andrew Beekhof wrote:
> > On Thu, Apr 9, 2009 at 00:22, Joel Becker <Joel.Becker@oracle.com> wrote:
> > >
> > > ? ? ? ?Well, this is going to be fun. ?I have to figure out which
> > > daemon is the "first", and now it's just racy. ?I could swear that
> > > someone told me cpg would guarantee i see the joins in order, not at the
> > > same time.
> > 
> > "In order" does not necessarily imply "one node at a time".
> > 
> > I don't consider it unreasonable for two nodes starting (effectively)
> > simultaneously to appear in the first membership.
> > I believe Heartbeat had the same property.
> 
> Right, confchg order is guaranteed, but doesn't imply one node per confchg.

	I have no problem with more than one join at the same time, but
somehow I had the idea that the first joiner would be alone.  Consider
me corrected.

> > Why not just take a lock when you want to create the daemon_protocol
> > section (and allow the second guy to fail gracefully)?
> > Perhaps cpg even has something like this built in...
> 
> You probably want to use cpg messages to order things.  So, for example,
> everyone sends a message proposing that it create the section, and the node
> whose message arrives first does it.  If you're coordinating things with
> messages like this anyway, it's not much more work to include protocol
> information in the message and eliminate checkpoints.

	Ugh ugh ugh.  This code is already a complex world of states
that are hard to keep in your head.  It only gets worse the more things
in flight.  Checkpoints give us a nice way to look up data about other
nodes without this hassle - they only give us a little pain in this
setup phase.

Joel

-- 

"I am working for the time when unqualified blacks, browns, and
 women join the unqualified men in running our overnment."
	- Sissy Farenthold

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
