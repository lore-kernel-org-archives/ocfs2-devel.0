From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 29 Dec 2015 16:34:56 -0800
Subject: [Ocfs2-devel] [PATCH] add OCFS2_LOCK_IGNORE_BLOCKED arg_flags
 to ocfs2_cluster_lock() to prevent hang
In-Reply-To: <1450828550-23168-1-git-send-email-tariq.x.saeed@oracle.com>
References: <1450828550-23168-1-git-send-email-tariq.x.saeed@oracle.com>
Message-ID: <20151230003456.GR11072@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 22, 2015 at 03:55:50PM -0800, Tariq Saeed wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Orabug: 21793017
> 
> commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
> introduced this issue.  ocfs2_setattr called by chmod command
> holds cluster wide inode lock (Orabug 21685187) when calling
> posix_acl_chmod. This latter function in turn calls ocfs2_iop_get_acl
> and ocfs2_iop_set_acl.  These two are also called directly from vfs layer
> for getfacl/setfacl commands and therefore acquire the cluster wide inode
> lock. If a remote conversion request comes after the first inode lock
> in ocfs2_setattr, OCFS2_LOCK_BLOCKED will be set in l_flags. This will
> cause the second call to inode lock from the  ocfs2_iop_get|set_acl()
> to block indefinetly.  The new flag OCFS2_LOCK_IGNORE_BLOCKED will be
> used to prevent this blocking.


NACK - as I explained earlier on this list we need to refactor the code to
avoid double locking the same resource. It is not acceptable to introduce
recursive locks into the code.
	--Mark

--
Mark Fasheh
