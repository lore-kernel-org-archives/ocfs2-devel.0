From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 28 Aug 2015 16:26:32 -0700
Subject: [Ocfs2-devel] [patch 07/28] ocfs2: fix a tiny case that inode
	can not removed.
In-Reply-To: <55de3999.S27PDhRmJdx2Acho%akpm@linux-foundation.org>
References: <55de3999.S27PDhRmJdx2Acho%akpm@linux-foundation.org>
Message-ID: <20150828232632.GL1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:37PM -0700, Andrew Morton wrote:
> From: jiangyiwen <jiangyiwen@huawei.com>
> Subject: ocfs2: fix a tiny case that inode can not removed.
> 
> When running dirop_fileop_racer we found a case that inode
> can not removed.
> 
> 2 nodes, say Node A and Node B, mount the same ocfs2 volume. Create
> two dirs /race/1/ and /race/2/ in the filesystem.
> 
> Node A                            Node B
> rm -r /race/2/
>                                   mv /race/1/ /race/2/
> call ocfs2_unlink(), get
> the EX mode of /race/2/
>                                   wait for B unlock /race/2/
> decrease i_nlink of /race/2/ to 0,
> and add inode of /race/2/ into
> orphan dir, unlock /race/2/
>                                   got EX mode of /race/2/. because
>                                   /race/1/ is dir, so inc i_nlink
>                                   of /race/2/ and update into disk,
>                                   unlock /race/2/
> because i_nlink of /race/2/
> is not zero, this inode will
> always remain in orphan dir
> 
> This patch fixes this case by test whether i_nlink of new dir is zero.


Good catch, thanks for this.


> diff -puN fs/ocfs2/namei.c~ocfs2-fix-a-tiny-case-that-inode-can-not-removed fs/ocfs2/namei.c
> --- a/fs/ocfs2/namei.c~ocfs2-fix-a-tiny-case-that-inode-can-not-removed
> +++ a/fs/ocfs2/namei.c
> @@ -1284,6 +1284,15 @@ static int ocfs2_rename(struct inode *ol
>  	}
>  	parents_locked = 1;
>  
> +	if (!new_dir->i_nlink) {
> +		mlog(ML_ERROR, "new dir %llu has been removed, inode %llu "
> +				"can not be moved into it.",
> +				(unsigned long long)new_dir->i_ino,
> +				(unsigned long long)old_inode->i_ino);

This is something that is rare, but not an error or otherwise outstanding
condition. Therefore printing to the kernel log is not advisable and may
confuse users. Please turn that into a debug print or remove it all
together, thanks.
	--Mark

--
Mark Fasheh
