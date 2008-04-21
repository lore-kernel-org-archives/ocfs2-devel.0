From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 21 Apr 2008 13:27:07 -0700
Subject: [Ocfs2-devel] [RFC] [PATCH] vfs: fix vfs_rename_dir for
	FS_RENAME_DOES_D_MOVE filesystems
In-Reply-To: <Pine.LNX.4.64.0804181315250.23551@cobra.newdream.net>
References: <Pine.LNX.4.64.0804181315250.23551@cobra.newdream.net>
Message-ID: <20080421202707.GQ31299@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Apr 18, 2008 at 02:10:42PM -0700, Sage Weil wrote:
> d_move() is strangely implemented in that it swaps the position of 
> new_dentry and old_dentry in the namespace.  This is admittedly weird (see 
> comments for d_move_locked()), but normally harmless: even though 
> new_dentry swaps places with old_dentry, it is unhashed, and won't be seen 
> by a subsequent lookup.
> 
> However, vfs_rename_dir() doesn't properly account for filesystems with 
> FS_RENAME_DOES_D_MOVE.  If new_dentry has a target inode attached, it 
> unhashes the new_dentry prior to the rename() iop and rehashes it after, 
> but doesn't account for the possibility that rename() may have swapped 
> {old,new}_dentry.  For FS_RENAME_DOES_D_MOVE filesystems, it rehashes 
> new_dentry (now the old renamed-from name, which d_move() expected to go 
> away), such that a subsequent lookup will find it... and the overwritten 
> target inode.
> 
> To correct this, move vfs_rename_dir()'s call to d_move() _before_ the 
> target inode mutex is dealt with.  Since d_move() will have been called 
> for all filesystems at this point, there is no need to rehash new_dentry 
> unless the rename failed.  (If the rename succeeded, old_dentry should 
> already be rehashed in the new location.)
> 
> The only in-tree filesystems with FS_RENAME_DOES_D_MOVE are ocfs2 and nfs.  
> I haven't tested either of them... only verified correct behavior on ext3 
> and ceph.  My suspicion is that they may not hit this particular bug 
> because the incorrectly rehashed new_dentry gets rejected by 
> d_revalidate() (not so, in my case).

This looks like it should be fine for Ocfs2. I'd have to test the patch (or
see test results) to be sure though. I bet the ocfs2 deleted flag on the
re-hashed directory gets caught in ocfs2_revalidate(), which is why we
haven't seen a problem before.
	--Mark

--
Mark Fasheh
