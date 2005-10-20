From: David Teigland <teigland@redhat.com>
Date: Thu Oct 20 10:25:58 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051020150341.GC11488@ca-server1.us.oracle.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
	<20051020102358.GB11726@marowsky-bree.de>
	<20051020150341.GC11488@ca-server1.us.oracle.com>
Message-ID: <20051020152606.GB16745@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 20, 2005 at 08:03:41AM -0700, Joel Becker wrote:
> heavily involved in the cluster.  Mount.ocfs2 is a separate program, and
> in the O2CB world it handles starting the heartbeat for a particular
> device in the "local heartbeat" mode (by "local heartbeat", we mean our
> default mode of "must be heartbeating on the device that is the mounted
> filesystem").  So, there is never a kernel callout to ask the cluster
> manager to care.  We don't like kernel callouts :-)  It's all done in
> user from mount.ocfs2.  Having mount.ocfs2 know how to talk to CRM would
> be entirely analogous.

For some reason we've never used a mount.gfs so it didn't even cross my
mind -- it sounds like the obvious way to go.  That description I sent of
how gfs mount interacts with the cluster bits may be changing now...

Thanks,
Dave
