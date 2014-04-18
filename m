From: jiangyiwen <jiangyiwen@huawei.com>
Date: Fri, 18 Apr 2014 16:02:04 +0800
Subject: [Ocfs2-devel] [patch 6/8] ocfs2: manually do the iput once
 ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod
In-Reply-To: <20140401194544.GJ4488@wotan.suse.de>
References: <20140319211005.3A1EB5A41DB@corp2gmr1-2.hot.corp.google.com>
	<20140401194544.GJ4488@wotan.suse.de>
Message-ID: <5350DBFC.7040106@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/4/2 3:45, Mark Fasheh wrote:
> On Wed, Mar 19, 2014 at 02:10:04PM -0700, Andrew Morton wrote:
>> From: jiangyiwen <jiangyiwen@huawei.com>
>> Subject: ocfs2: manually do the iput once ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod
>>
>> When the call to ocfs2_add_entry() failed in ocfs2_symlink() and
>> ocfs2_mknod(), iput() will not be called during dput(dentry) because no
>> d_instantiate(), and this will lead to umount hung.
> 
> This is probably the heaviest way to do this. If you're getting a hang on
> mount, there's something wrong with the cleanup code in fs/ocfs2/dcache.c.
> See the following comment just above ocfs2_add_entry()
> 
> 	/*
> 	 * Do this before adding the entry to the directory. We add
> 	 * also set d_op after success so that ->d_iput() will cleanup
> 	 * the dentry lock even if ocfs2_add_entry() fails below.
> 	 */
> 	status = ocfs2_dentry_attach_lock(dentry, inode,
> 					  OCFS2_I(dir)->ip_blkno);
> 	if (status) {
> 		mlog_errno(status);
> 		goto leave;
> 	}
> 
> 	status = ocfs2_add_entry(handle, dentry, inode,
> 				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
> 				 &lookup);
> 	if (status < 0) {
> 		mlog_errno(status);
> 		goto leave;
> 	}
Mark:
    I am sorry I reply you too late. The above comment was added in your patch
"ocfs2: Add directory entry later in ocfs2_symlink() and ocfs2_mknod()".
But there has two problems:

    1. I think this comment has little effect, d_iput() will not be called during
dput(dentry) because no d_instantiate(). So, I will manually do the iput. I think your
suggestions very good, I will form a function to include the large block of code.

    2. Why do this handle only in ocfs2_mknod and ocfs2_symlink, not in ocfs2_link
and ocfs2_mv_orphaned_inode_to_new?

Thanks,
	--jiangyiwen
> 
> So if you hung during unmount on a dentry lock, I think we need to
> investigate that path of recovery first. If there's something that it simply
> can't handle, then the large block of code you copied into namei.c needs to
> go into it's own function (or be a function broken out of the dentry lock
> cleanup code).
> 
> Thanks,
> 	--Mark
> 
> --
> Mark Fasheh
> 
> 
