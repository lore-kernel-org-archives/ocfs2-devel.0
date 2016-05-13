From: David Teigland <teigland@redhat.com>
Date: Fri, 13 May 2016 11:07:51 -0500
Subject: [Ocfs2-devel] [Cluster-devel] inconsistent dlm_new_lockspace
 LVB_LEN size from ocfs2 user-space tool and ocfs2 kernel module
In-Reply-To: <57360289020000F900036DF3@prv-mh.provo.novell.com>
References: <57360289020000F900036DF3@prv-mh.provo.novell.com>
Message-ID: <20160513160751.GB28849@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, May 13, 2016 at 02:36:25AM -0600, Gang He wrote:

> Here is a inconsistent LVB_LEN size problem when create a new lockspace
> from user-space tool (e.g. fsck.ocfs2) and kernel module (e.g.
> ocfs2/stack_user.c).
> From the userspace tool, the LVB size is DLM_USER_LVB_LEN (32 bytes,
> defined in /include/linux/dlm_device.h) From the kernel module, the LVB
> size is DLM_LVB_LEN (64 bytes).

Yes

> Why did we design like this? Look at GFS2 kernel module code, it uses 32
> bytes as LVB_LEN size, it is the same size with  DLM_USER_LVB_LEN macro
> definition. 

The lvb length was originally a constant 32 bytes, and was made variable
after the dlm user interface existed.  The variable length lvb could not
be added to the existing user interface.  (The dlm user interface is
terrible and a new version has been needed for many years, but it's not
used much, so it's not been worth the effort.)

> Now, We encountered a customer issue, the user did a fsck
> on a ocfs2 file system from one node, but aborted without release this
> lockspace (32bytes), then the user mounted this file system.  The kernel
> module would use the existing same lockspace, without creating the new
> lockspace with 64 bytes LVB_LEN.  Next, the bad result was that the user
> could not mount this file system from the other nodes no longer.

> The error messages likes,
> config mismatch: 64,0 nodeid 177127961: 32,0

> Of course, the urgent fix is easy, we can reboot all the nodes, then
> mount the file system again.  But, I want to if there were some reasons
> about this design, otherwise, I want to see if we can use the same size
> between user space and kernel module.

Sorry, I think the only way around this is to ensure that lockspaces are
created from the kernel.

Dave
