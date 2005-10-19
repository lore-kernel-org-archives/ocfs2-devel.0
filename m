From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Oct 19 12:49:02 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051019132624.GI24589@marowsky-bree.de>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
Message-ID: <20051019174905.GQ11488@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 19, 2005 at 03:26:24PM +0200, Lars Marowsky-Bree wrote:
> Actually a good point. I don't think the heartbeat hierarchy is needed
> if driven by a user-space membership.

	Well, if it is information that some kernel component would
want/need, then sure it would live in configfs somewhere, but not under
OCFS2.
	Is your heartbeat loop (the actual does-the-beating code) in
kenrel or userspace?  I thought that was your only kernel component at
one point, because of scheduling issues with userspace, but please
correct me.

> OCFS2 doesn't register with us in this model; _we_ drive OCFS2 and
> provide it with the events; we manage it, so we know it's there.

	Well, there needs to be some entry point by which OCFS2 recieves
events.  We don't care how it is done, I guess, but it needs the usual
async, locking-safe, yadayada that everyone expects.

> > 	Of course, if we're figuring on leaving O2CB for that person,
> > and having heartbeat2 as a 'more fancy' user, that's a whole 'nother
> > story.  Then it's your problem :-)
> 
> That's probably the best way to approach this right now ;-)

	Put succinctly: We absolutely require the minimal mkfs; mount;
paradigm be available for our users.  We will not settle for less.
	How that is done we don't much care.  So if your system can't
provide it, O2CB will continue to do so.  We'll be happy to help
integrate with your stuff as well, as long as it doesn't compromise
O2CB.  Then, if someone is already using your manager, they can just use
it with OCFS2.  But anyone not already using your manager can just
mkfs;mount; with O2CB.

Joel

-- 

 "I'm living so far beyond my income that we may almost be said
 to be living apart."
         - e e cummings

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
