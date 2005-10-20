From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Oct 20 10:03:36 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051020102358.GB11726@marowsky-bree.de>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
	<20051020102358.GB11726@marowsky-bree.de>
Message-ID: <20051020150341.GC11488@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 20, 2005 at 12:23:58PM +0200, Lars Marowsky-Bree wrote:
> On 2005-10-19T17:34:32, Jeff Mahoney <jeffm@suse.com> wrote:
> > In order to do this, I think that at mount time, we should call out to
> > user space to tell it to start caring about this node for a particular
> > heart beat group. When the file system is umounted, we call out again
> > and tell it to stop caring.
> 
> What might just be about possible is that "mount" is patched to know
> that it has to go through some special steps to "mount" an OCFS2 fs;
> namely, not do it itself directly, but tell the CRM "Hey, user wants
> this mounted, see what you can do".

	I'm not sure if you guys realize this, but mount is already
heavily involved in the cluster.  Mount.ocfs2 is a separate program, and
in the O2CB world it handles starting the heartbeat for a particular
device in the "local heartbeat" mode (by "local heartbeat", we mean our
default mode of "must be heartbeating on the device that is the mounted
filesystem").  So, there is never a kernel callout to ask the cluster
manager to care.  We don't like kernel callouts :-)  It's all done in
user from mount.ocfs2.  Having mount.ocfs2 know how to talk to CRM would
be entirely analogous.

Joel

-- 

"In the long run...we'll all be dead."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
