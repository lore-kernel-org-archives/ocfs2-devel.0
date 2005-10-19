From: Lars Marowsky-Bree <lmb@suse.de>
Date: Wed Oct 19 08:26:24 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051018232752.GO11488@ca-server1.us.oracle.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
Message-ID: <20051019132624.GI24589@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-18T16:27:52, Joel Becker <Joel.Becker@oracle.com> wrote:

> 	Duh, right.  Then the heartbeat part of the hierarchy isn't even
> useful to OCFS2.

Actually a good point. I don't think the heartbeat hierarchy is needed
if driven by a user-space membership.

> But you will need to come up with some method (netlink, in-kernel api,
> whatever) for OCFS2 to register itself with heartbeat for events.  I
> have to assume this API already exists, becuase heartbeat consumers
> would need it.

We're thinking from opposite directions, actually. 

OCFS2 doesn't register with us in this model; _we_ drive OCFS2 and
provide it with the events; we manage it, so we know it's there.

> > Membership events (nodes up, down) would be provided to OCFS2
> > post-fencing.
> 	I believe (Mark, correct me if I'm wrong) that OCFS2 merely
> requires the standard "DLM must find out first" protocol.  That is, the
> DLM must be able to lock out all locking changes before the filesystem
> tries to recover anything.  I believe GFS and even VMS CFS rely on this
> property.

Our Cluster Resource Manager models the dependencies between the various
components, ie DLM to CFS in this case, and supplies the events in the
correct order to them.

> 	Of course, if we're figuring on leaving O2CB for that person,
> and having heartbeat2 as a 'more fancy' user, that's a whole 'nother
> story.  Then it's your problem :-)

That's probably the best way to approach this right now ;-)


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
