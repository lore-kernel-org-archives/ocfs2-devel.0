From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 25 Feb 2014 11:01:34 -0800
Subject: [Ocfs2-devel] [PATCH 4/6] ocfs2: Implement delayed dropping
	of	last dquot reference
In-Reply-To: <1392975904-16944-5-git-send-email-jack@suse.cz>
References: <1392975904-16944-1-git-send-email-jack@suse.cz>
	<1392975904-16944-5-git-send-email-jack@suse.cz>
Message-ID: <20140225190134.GI5716@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 21, 2014 at 10:45:02AM +0100, Jan Kara wrote:
> We cannot drop last dquot reference from downconvert thread as that
> creates the following deadlock:
> 
> NODE 1                                  NODE2
> holds dentry lock for 'foo'
> holds inode lock for GLOBAL_BITMAP_SYSTEM_INODE
>                                         dquot_initialize(bar)
>                                           ocfs2_dquot_acquire()
>                                             ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
>                                             ...
> downconvert thread (triggered from another
> node or a different process from NODE2)
>   ocfs2_dentry_post_unlock()
>     ...
>     iput(foo)
>       ocfs2_evict_inode(foo)
>         ocfs2_clear_inode(foo)
>           dquot_drop(inode)
>             ...
> 	    ocfs2_dquot_release()
>               ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
>                - blocks
>                                             finds we need more space in
>                                             quota file
>                                             ...
>                                             ocfs2_extend_no_holes()
>                                               ocfs2_inode_lock(GLOBAL_BITMAP_SYSTEM_INODE)
>                                                 - deadlocks waiting for
>                                                   downconvert thread
> 
> We solve the problem by postponing dropping of the last dquot reference
> to a workqueue if it happens from the downconvert thread.
> 
> Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, I especially like the usuage of llist.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
