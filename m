From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 29 Jul 2016 10:45:32 -0700
Subject: [Ocfs2-devel] [patch 1/5] ocfs2: ensure that dlm lockspace is
 created by kernel module
In-Reply-To: <579B35F5020000F9000437BA@prv-mh.provo.novell.com>
References: <579a73b4.UvdhRu1jgG1MmrgX%akpm@linux-foundation.org>
	<20160728215721.GB5316@wotan.suse.de>
	<579B35F5020000F9000437BA@prv-mh.provo.novell.com>
Message-ID: <20160729174532.GF5316@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 28, 2016 at 08:54:45PM -0600, Gang He wrote:
> Hello Mark,
> 
> 
> >>> 
> > On Thu, Jul 28, 2016 at 02:05:56PM -0700, Andrew Morton wrote:
> >> From: Gang He <ghe@suse.com>
> >> Subject: ocfs2: ensure that dlm lockspace is created by kernel module
> >> 
> >> We encountered a bug from the customer, the user did a fsck.ocfs2 on the
> >> file system and exited unusually, the lockspace (with LVB size = 32) was
> >> left in the kernel space, next, the user mounted this file system, the
> >> kernel module did not create a new lockspace (LVB size = 64) via calling
> >> dlm_new_lockspace() function in mounting stage, just used the existing
> >> lockspace, created by the user space tool, this would lead the user was
> >> not able to mount this file system from the other nodes, with the error
> >> message like:
> >> 
> >> dlm: 032F5......: config mismatch: 64,0 nodeid 177127961: 32,0
> >> (mount.ocfs2,26981,46):ocfs2_dlm_init:2995 ERROR: status = -71
> >> ocfs2_mount_volume:1881 ERROR: status = -71
> >> ocfs2_fill_super:1236 ERROR: status = -71
> >> 
> >> The user found it very difficult to find the root cause, then, we brought
> >> out this patch to relieve such problem.  
> >> 
> >> First, we add one more flag in calling dlm_new_lockspace() function, to
> >> make sure the lockspace is created by kernel module itself, and this
> >> change will not affect the backward compatibility.
> >> 
> >> Second, the obvious error message is reported in the kernel log, let the
> >> user be more easy to find the root cause.
> >> 
> >> 
> >> 
> >> This patch will be used to insure the dlm lockspace is created by kernel
> >> module when mounting a ocfs2 file system.  There are two ways to create a
> >> lockspace, from user space and kernel space, but the same name lockspaces
> >> probably have different lvblen lengths/flags.
> >> 
> >> To avoid this mix using, we add one more flag DLM_LSFL_NEWEXCL, it will
> >> make sure the dlm lockspace is created by kernel module when mounting. 
> >> Secondly, if a user space program (ocfs2-tools) is running on a file
> >> system, the user tries to mount this file system in the cluster, DLM
> >> module will return a -EEXIST or -EPROTO errno, we should give the user a
> >> obvious error message, then, the user can let that user space tool exit
> >> before mounting the file system again.
> > 
> > I really like that we're printing a clear message for the user. I'm
> > concerned about a couple things though:
> > 
> > Gang - did you check that *online* userspace tools can still work on a
> > mounted cluster with this change? I ask because this isn't the first time
> > this issue has come up and if my memory hasn't faded too much we had
> > problems with userspace/kernel interactions when we tried to fix it. In
> > particular if the kernel says the lockspace is now exclusive, does that mean
> > userspace will not be allowed to join, even if it doesn't use the lvb?
> > 
> > Actually, how does this interact with dlmfs? We won't be allowed to join
> > domains from dlmfs effectively gutting the ocfs2-tools ability to query the
> > cluster. In particualr see this blurb in libocfs2/dlm.c:
> > 
> >         /*
> >          * We want to use dlmfs if we can, as it provides the full feature
> >          * set of libo2dlm.  Any dlmfs with the 'stackglue' capability will
> >          * support all cluster stacks.  An empty cluster.c_stack means
> >          * o2cb, which always supports dlmfs.
> >          *
> >          * If we're unlucky enough to have older userspace stack code,
> >          * we pass NULL to avoid dlmfs.
> >          */
> > 
> Yes, we did lots of testing, this code change will not affect the existing ocfs2-tool behavior.
> As you said, this part code is very messy, I can not fix this problem directly base on the current code/design.
> Then, the fix is only to give the user a obvious error message and prevent the user make matters worse.
> That is all we can do for this issue.

I don't doubt you tested a lot :)

Mostly I want to understand if you guys checked out the interaction of dlmfs
with ocfs2 when this patch is applied. In particular, I am fairly confident
that dlmfs would NOT be able to join the lockspace on the same node that has
the fs mounted. If you see this code in new_lockspace()
(fs/dlm/lockspace.c):

                if (flags & DLM_LSFL_NEWEXCL) {
                        error = -EEXIST;
                        break;
                }


I looked through the tools and as far as I can tell, most of them will be
fine failing to join the lockspace - it is effectively the same as
discovering it was already mounted elswhere. I just want to be sure that
we're fully aware of the ramification of this patch.

If we're all agreed that this should not be a problem then by all means have
this tag :)

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

Thanks,
	--Mark

--
Mark Fasheh
