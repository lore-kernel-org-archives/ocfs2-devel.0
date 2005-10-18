From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue Oct 18 18:27:46 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051018230323.GE2813@marowsky-bree.de>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
Message-ID: <20051018232752.GO11488@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 19, 2005 at 01:03:23AM +0200, Lars Marowsky-Bree wrote:
> Good point, but I think part of Jeff's proposal is to pull-out the
> heartbeating from OCFS2 into user-space, so OCFS2 no longer would
> maintain its own heartbeat, and thus no heartbeat region.

	Duh, right.  Then the heartbeat part of the hierarchy isn't even
useful to OCFS2.  But you will need to come up with some method
(netlink, in-kernel api, whatever) for OCFS2 to register itself with
heartbeat for events.  I have to assume this API already exists, becuase
heartbeat consumers would need it.

> Membership events (nodes up, down) would be provided to OCFS2
> post-fencing.

	I believe (Mark, correct me if I'm wrong) that OCFS2 merely
requires the standard "DLM must find out first" protocol.  That is, the
DLM must be able to lock out all locking changes before the filesystem
tries to recover anything.  I believe GFS and even VMS CFS rely on this
property.

> heartbeat used to have 3 straightforward config files; the XML based
> configuration file (one of them, actually) is pretty new. "Plethora of
> XML configuration files" certainly isn't true of heartbeat 2.x, and
> never was. The XML configuration file is even automatically replicated
> across cluster nodes so the user can't get them desync'ed ;-)

	"Plethora of configuration files" is my way of saying "last time
I tried heartbeat, it wasn't _IMMEDIATELY_ obvious what I needed to edit
to get it going."  A lot of this can be handled with wrapper software.
For example, in OCFS2, ocfs2console will create cluster.conf for you and
populate it.  All you really, really need is your name:ip pairs.  So, in
the old heartbeat case, I (the sysadmin) really shouldn't have to be
editing the fencing config file if I am going to be using the default.
I shouldn't have to know about it (lord knows, I didn't back when I
tried, and it caused much consternation).
	One of the design docs on my plate for OCFS2 is the "Simple User
Experience" doc.  The idea is to design the "easy, bullet-proof init" of
a single mount.  Once written, any change that would add a step to the
document would be rejected unless deemed absolutely necessary by a
unanimous vote, or the like.  You see where I'm going?  The concern here
is not the complexity for a know-what-I'm-doing admin at a big company,
but the most basic install for the most basic system.
	Of course, if we're figuring on leaving O2CB for that person,
and having heartbeat2 as a 'more fancy' user, that's a whole 'nother
story.  Then it's your problem :-)

> Of course, this brings up a valid point; currently, OCFS2 can run "stand
> alone" w/o any supporting user-space stack. Uhm. As RAC doesn't
> interoperate with _any_ other stack, I assume this is a property which
> needs to be preserved.

	You bring up an interesting point.  It's not the lack of
userspace stack we care about.  It's the ease of the stack.  Assume that
Joe User only wants to run RAC on OCFS2, he could care less about O2CB,
heartbeat2, or CMan.  What we care about is that:

1) It is mind-numbingly transparent, easy, and obvious.
2) It is available on all of our supported platforms (provided by the
   platform or by us).

	Today, ocfs2console provides (1), O2CB provides (2).

Joel

-- 

Life's Little Instruction Book #20

	"Be forgiving of yourself and others."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
