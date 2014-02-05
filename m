From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 5 Feb 2014 15:56:18 -0800
Subject: [Ocfs2-devel] [patch 07/11] ocfs2: check existence of old
	dentry in	ocfs2_link()
In-Reply-To: <20140124204707.2470E5A4203@corp2gmr1-2.hot.corp.google.com>
References: <20140124204707.2470E5A4203@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20140205235618.GO24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 24, 2014 at 12:47:06PM -0800, akpm at linux-foundation.org wrote:
> From: Xue jiufei <xuejiufei@huawei.com>
> Subject: ocfs2: check existence of old dentry in ocfs2_link()
> 
> System call linkat first calls user_path_at(), check the existence of old
> dentry, and then calls vfs_link()->ocfs2_link() to do the actual work. 
> There may exist a race when Node A create a hard link for file while node
> B rm it.
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
> When orphan_scan work start, it calls ocfs2_queue_orphans() to do the main
> work.  It first tranverses entrys in orphan_dir, linking all inodes in
> this orphan_dir to a list look like this:
> 
> 	inodeA->inodeB->...->inodeA
> 
> When tranvering this list, it will fall into loop, calling iput() again
> and again.  And finally trigger BUG_ON(inode->i_state & I_CLEAR).
> 
> Signed-off-by: joyce <xuejiufei@huawei.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Ok, this looks fine. Good catch by the way. I would really like a comment in
the code above the 'if (old_de_ino != OCFS2_I(inode)->ip_blkno) {' line so
it could look like this:

	err = ocfs2_lookup_ino_from_name(dir, old_dentry->d_name.name,
			old_dentry->d_name.len, &old_de_ino);
	if (err) {
		err = -ENOENT;
		goto out;
	}

	/* 
	 * Check whether another node removed the source inode while we
	 * were in the vfs.
	 */

	if (old_de_ino != OCFS2_I(inode)->ip_blkno) {
		err = -ENOENT;
		goto out;
	}


With that comment added this gets my signoff:

Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Thanks,
	--Mark

--
Mark Fasheh
