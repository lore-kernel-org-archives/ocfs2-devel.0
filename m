From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 10 Feb 2014 13:47:28 -0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: Check existence of old dentry
	in ocfs2_link()
In-Reply-To: <52F5937C.5050507@huawei.com>
References: <52F5937C.5050507@huawei.com>
Message-ID: <20140210214728.GW24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Feb 08, 2014 at 10:16:28AM +0800, Xue jiufei wrote:
>   System call linkat first calls user_path_at(), check the existence
> of old dentry, and then calls vfs_link()->ocfs2_link() to do the actual
> work. There may exist a race when Node A create a hard link for file
> while node B rm it.
> 
>          Node A                          Node B
> user_path_at()
>   ->ocfs2_lookup(),
> find old dentry exist
>                                 rm file, add inode say inodeA
>                                 to orphan_dir
> 
> call ocfs2_link(),create a
> hard link for inodeA.
> 
>                                 rm the link, add inodeA to orphan_dir
>                                 again
> 
> When orphan_scan work start, it calls ocfs2_queue_orphans() to do
> the main work. It first tranverses entrys in orphan_dir, linking
> all inodes in this orphan_dir to a list look like this:
> inodeA->inodeB->...->inodeA
> When tranvering this list, it will fall into loop, calling iput() again and again.
> And finally trigger BUG_ON(inode->i_state & I_CLEAR).
> 
> Signed-off-by: joyce <xuejiufei@huawei.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This version adds the comment I wanted, thanks.

> Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
