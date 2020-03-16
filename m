From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 16 Mar 2020 12:46:55 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: the parent directory reference
 count should be increased only after the ocfs2_add_entry function is
 successfully called
In-Reply-To: <27b32a04-d3f5-4a14-ec0e-11816c42c9a2@huawei.com>
References: <27b32a04-d3f5-4a14-ec0e-11816c42c9a2@huawei.com>
Message-ID: <c12a7ca0-ced4-74f2-54d0-4b841d6b773a@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/3/16 00:59, wangjian wrote:
> Under some conditions, the directory cannot be deleted.
> The specific scenarios are as follows: (for example,
> /mnt/ocfs2 is the mount point)
> 
> 1. Create the /mnt/ocfs2/p_dir directory. At this time,
> the i_nlink corresponding to the inode of
> the /mnt/ocfs2/p_dir directory is equal to 2.
> 
> 2. During the process of creating the
> /mnt/ocfs2/p_dir/s_dir directory, if the call to the inc_nlink
> function in ocfs2_mknod succeeds, the functions such as
> ocfs2_init_acl, ocfs2_init_security_set, and ocfs2_dentry_attach_lock fail.
> At this time, the i_nlink corresponding to the inode of the
> /mnt/ocfs2/p_dir directory is equal to 3, but /mnt/ocfs2/p_dir/s_dir
> is not added to the /mnt/ocfs2/p_dir directory entry.
> 
> 3. Delete the /mnt/ocfs2/p_dir directory (rm -rf /mnt/ocfs2/p_dir).
> At this time, it is found that the i_nlink corresponding to
> the inode corresponding to the /mnt/ocfs2/p_dir directory is equal to 3.
> Therefore, the /mnt/ocfs2/p_dir directory cannot be deleted.
> 
> Signed-off-by: Jian wang <wangjian161@huawei.com>
> ---
> ?ocfs2/namei.c | 24 +++++++++++++-----------
> ?1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/ocfs2/namei.c b/ocfs2/namei.c
> index 8ea51cf..19543b4 100644
> --- a/ocfs2/namei.c
> +++ b/ocfs2/namei.c
> @@ -388,17 +388,6 @@ static int ocfs2_mknod(struct inode *dir,
> ???????????? mlog_errno(status);
> ???????????? goto leave;
> ???????? }
> -
> -??????? status = ocfs2_journal_access_di(handle, INODE_CACHE(dir),
> -???????????????????????? parent_fe_bh,
> -???????????????????????? OCFS2_JOURNAL_ACCESS_WRITE);
> -??????? if (status < 0) {
> -??????????? mlog_errno(status);
> -??????????? goto leave;
> -??????? }

We can't simply move it down since we should get journal access before
modification.

Thanks,
Joseph 

> -??????? ocfs2_add_links_count(dirfe, 1);
> -??????? ocfs2_journal_dirty(handle, parent_fe_bh);
> -??????? inc_nlink(dir);
> ???? }
> ?
> ???? status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
> @@ -440,6 +429,19 @@ static int ocfs2_mknod(struct inode *dir,
> ???????? goto leave;
> ???? }
> ?
> +??? if (S_ISDIR(mode)) {
> +??????? status = ocfs2_journal_access_di(handle, INODE_CACHE(dir),
> +???????????????????????? parent_fe_bh,
> +???????????????????????? OCFS2_JOURNAL_ACCESS_WRITE);
> +??????? if (status < 0) {
> +??????????? mlog_errno(status);
> +??????????? goto leave;
> +??????? }
> +??????? ocfs2_add_links_count(dirfe, 1);
> +??????? ocfs2_journal_dirty(handle, parent_fe_bh);
> +??????? inc_nlink(dir);
> +??? }
> +
> ???? insert_inode_hash(inode);
> ???? d_instantiate(dentry, inode);
> ???? status = 0;
