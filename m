From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 12 Jun 2014 16:01:23 -0700
Subject: [Ocfs2-devel] [patch 8/8] ocfs2: manually do the iput once
	ocfs2_add_entry	failed in ocfs2_symlink and ocfs2_mknod
In-Reply-To: <20140609200408.046B25A4A39@corp2gmr1-2.hot.corp.google.com>
References: <20140609200408.046B25A4A39@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20140612230123.GC5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 09, 2014 at 01:04:07PM -0700, Andrew Morton wrote:
> From: jiangyiwen <jiangyiwen@huawei.com>
> Subject: ocfs2: manually do the iput once ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod
> 
> When the call to ocfs2_add_entry() failed in ocfs2_symlink() and
> ocfs2_mknod(), iput() will not be called during dput(dentry) because no
> d_instantiate(), and this will lead to umount hung.
> 
> Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Any time we're cutting and pasting code, we have to ask ourselves whether we
should be making that code into it's own function.

Please do that with this patch. I would recommend a descriptive name so we
know what the purpose of the function is:

static void ocfs2_cleanup_add_entry_failure(struct ocfs2_super *osb, struct ocfs2_dentry_lock *dl)
{
	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
	ocfs2_lock_res_free(&dl->dl_lockres);
	BUG_ON(dl->dl_count != 1);
	spin_lock(&dentry_attach_lock);
	dentry->d_fsdata = NULL;
	spin_unlock(&dentry_attach_lock);
	kfree(dl);
	iput(inode);
}

Also, can't you replace 4 of those lines with a call to
ocfs2_drop_dentry_lock()?

Thanks,
	--Mark

--
Mark Fasheh
