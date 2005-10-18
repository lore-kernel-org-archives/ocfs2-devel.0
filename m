From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Oct 18 18:47:50 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051018230323.GE2813@marowsky-bree.de>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
Message-ID: <20051018234757.GD25876@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Lars,

On Wed, Oct 19, 2005 at 01:03:23AM +0200, Lars Marowsky-Bree wrote:
> > 	Have you also considered what this will or won't do to possible
> > interaction with the CMan stack?  We'd love OCFS2 to handle both stacks.
> 
> This is hard for us to judge, but given that CMan in recent mailing list
> discussions seems to be moving towards a user-space driven membership
> too, it's fairly likely useable here too.
Right, and we're only interested in the new (userspace only) CMan, so no
need to consider the kernel code.

> My goal is for the user to only add a single resource entry (a so-called
> "clone" resource type) to the configuration for each OCFS2 filesystem,
> and then he'd be done; the cluster would auto-generate everything else.
Do you mean that the user would have to add a configuration entry for every
single OCFS2 mount on their machine? Unless that's done automatically and
transparently (perhaps from mount.ocfs2), it's pretty much a non starter.
We've always wanted the users path (once the cluster stack is installed and
configured) to be as easy as a local filesystem: mkfs.ocfs2 /dev/foo; mount
/dev/foo /ocfs2.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
