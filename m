From: Andrew Morton <akpm@osdl.org>
Date: Tue Dec  5 20:58:36 2006
Subject: [Ocfs2-devel] Re: Relative atime (was Re: What's in ocfs2.git)
In-Reply-To: <20061205003619.GC8482@goober>
References: <20061203203149.GC19617@ca-server1.us.oracle.com>
	<1165229693.3752.629.camel@quoit.chygwyn.com>
	<20061205001007.GF19617@ca-server1.us.oracle.com>
	<20061205003619.GC8482@goober>
Message-ID: <20061205205802.92b91ce1.akpm@osdl.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Valerie Henson <val_henson@linux.intel.com>
Cc: mark.fasheh@oracle.com, steve@chygwyn.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk

> On Mon, 4 Dec 2006 16:36:20 -0800 Valerie Henson <val_henson@linux.intel.com> wrote:
> Add "relatime" (relative atime) support.  Relative atime only updates
> the atime if the previous atime is older than the mtime or ctime.
> Like noatime, but useful for applications like mutt that need to know
> when a file has been read since it was last modified.

That seems like a good idea.

I found touch_atime() to be rather putrid, so I hacked it around a bit.  The
end result:

void touch_atime(struct vfsmount *mnt, struct dentry *dentry)
{
	struct inode *inode = dentry->d_inode;
	struct timespec now;

	if (IS_RDONLY(inode))
		return;
	if (inode->i_flags & S_NOATIME)
		return;
	if (inode->i_sb->s_flags & MS_NOATIME)
		return;
	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
		return;

	/*
	 * We may have a NULL vfsmount when coming from NFSD
	 */
	if (mnt) {
		if (mnt->mnt_flags & MNT_NOATIME)
			return;
		if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
			return;

		if (mnt->mnt_flags & MNT_RELATIME) {
			/*
			 * With relative atime, only update atime if the
			 * previous atime is earlier than either the ctime or
			 * mtime.
			 */
			if (timespec_compare(&inode->i_mtime,
						&inode->i_atime) < 0 &&
			    timespec_compare(&inode->i_ctime,
						&inode->i_atime) < 0)
				return;
		}
	}

	now = current_fs_time(inode->i_sb);
	if (timespec_equal(&inode->i_atime, &now))
		return;

	inode->i_atime = now;
	mark_inode_dirty_sync(inode);
}

Does it still look right?

Note the reordering to avoid the current_fs_time() call if poss.


That's the easy part.   How are we going to get mount(8) patched?
