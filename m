From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 7 Jan 2016 14:55:07 -0800
Subject: [Ocfs2-devel] [PATCH] revert to using ocfs2_acl_chmod to avoid
 inode cluster lock hang
In-Reply-To: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>
References: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>
Message-ID: <20160107225507.GB819@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 05, 2016 at 06:27:11PM -0800, Tariq Saeed wrote:
> Orabug: 21793017
> 
> commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
> introduced this issue.  ocfs2_setattr called by chmod command
> holds cluster wide inode lock (Orabug 21685187) when calling
> posix_acl_chmod. This latter function in turn calls ocfs2_iop_get_acl
> and ocfs2_iop_set_acl.  These two are also called directly from vfs
> layer for getfacl/setfacl commands and therefore acquire the cluster wide
> inode lock. If a remote conversion request comes after the first inode
> lock in ocfs2_setattr, OCFS2_LOCK_BLOCKED will be set in l_flags. This
> will cause the second call to inode lock from the  ocfs2_iop_get_acl()
> to block indefinetly.
> 
> To solve this, we need to use nolock version of getacl.  Since
> nolock version of posix_acl_chmod does not exist, we restore a slightly
> modified version of  ocfs2_acl_chmod, which was removed in
> commit 702e5bc68ad2 ("ocfs2: use generic posix ACL infrastructure")
> that uses nolock version of getacl.

This looks good, thanks Tariq.

One comment about your description - you actually used the correct version
of posix_acl_chmod() -- specifically __posix_acl_chmod().

It's not so much that there isn't a 'nolock' version of posix_acl_chmod().
It's more that we were using the higher level version which makes calls back
into the fs. For most filesystems this is ok, so we save a lot of code by
having the function do this. For filesystems like ocfs2 which have
additional locking or other complexity it does not work, hence we directly
call the function that does the non-vfs work (__posix_acl_chmod()) and
replicate the small checks at the top fo the vfs function.

So you could replace that last paragraph with something like this:

The deleted version of ocfs2_acl_chmod() calls __posix_acl_chmod() which
does not call back into the filesystem. Therefore, we restore
ocfs2_acl_chmod() and use that instead.


Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
