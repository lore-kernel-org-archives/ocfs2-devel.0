From: Dave Kleikamp <dave.kleikamp@oracle.com>
Date: Tue, 11 Jun 2019 08:41:06 -0500
Subject: [Ocfs2-devel] [Jfs-discussion] [PATCH 1/4] vfs: create a
 generic checking function for FS_IOC_SETFLAGS
In-Reply-To: <156022834076.3227089.14763553158562888103.stgit@magnolia>
References: <156022833285.3227089.11990489625041926920.stgit@magnolia>
	<156022834076.3227089.14763553158562888103.stgit@magnolia>
Message-ID: <fb974a33-2192-30ab-9f31-885c3796360b@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>, matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk
Cc: linux-xfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

On 6/10/19 11:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a generic checking function for the incoming FS_IOC_SETFLAGS flag
> values so that we can standardize the implementations that follow ext4's
> flag values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

 -- clip --

> diff --git a/fs/jfs/ioctl.c b/fs/jfs/ioctl.c
> index ba34dae8bd9f..c8446d2cd0c7 100644
> --- a/fs/jfs/ioctl.c
> +++ b/fs/jfs/ioctl.c
> @@ -98,6 +98,12 @@ long jfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		/* Lock against other parallel changes of flags */
>  		inode_lock(inode);
>  
> +		oldflags = jfs_map_ext2(jfs_inode->mode2 & JFS_FL_USER_VISIBLE,
> +					0);
> +		err = vfs_ioc_setflags_check(inode, oldflags, flags);
> +		if (err)
> +			goto setflags_out;

inode_unlock(inode) is not called on the error path.

> +
>  		oldflags = jfs_inode->mode2;
>  
>  		/*

This patch leaves jfs's open-coded version of the same check.

Thanks,
Shaggy
