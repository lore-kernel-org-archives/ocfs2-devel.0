From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Oct 18 18:50:43 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051018232752.GO11488@ca-server1.us.oracle.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
Message-ID: <20051018235050.GE25876@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 18, 2005 at 04:27:52PM -0700, Joel Becker wrote:
> > Membership events (nodes up, down) would be provided to OCFS2
> > post-fencing.
> 
> 	I believe (Mark, correct me if I'm wrong) that OCFS2 merely
> requires the standard "DLM must find out first" protocol.  That is, the
> DLM must be able to lock out all locking changes before the filesystem
> tries to recover anything.  I believe GFS and even VMS CFS rely on this
> property.
No, it's the other way around - the file system requires notification before
the DLM so that it can mark itself as requiring recovery *before* the DLM
has a chance to start giving away locks that were previously protecting
resources in use by the other node.
You're correct of course that GFS and other cluster file systems require the
same behavior.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
