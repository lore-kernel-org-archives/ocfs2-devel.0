From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 17 Mar 2020 12:29:31 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: roll back the reference count
 modification of the parent directory if an error occurs
In-Reply-To: <a47da8dd-dc3d-41d7-fdd6-53dc6ea0335f@huawei.com>
References: <a47da8dd-dc3d-41d7-fdd6-53dc6ea0335f@huawei.com>
Message-ID: <83013742-432c-7d06-eb10-908f214d257a@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/3/17 10:26, wangjian wrote:
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
> ?ocfs2/namei.c | 8 ++++++++
> ?1 file changed, 8 insertions(+)
> 
> diff --git a/ocfs2/namei.c b/ocfs2/namei.c
> index 8ea51cf..f34ce0b 100644
> --- a/ocfs2/namei.c
> +++ b/ocfs2/namei.c
> @@ -247,6 +247,7 @@ static int ocfs2_mknod(struct inode *dir,
> ???? sigset_t oldset;
> ???? int did_block_signals = 0;
> ???? struct ocfs2_dentry_lock *dl = NULL;
> +??? int link_inc = 0;
> ?
> ???? trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
> ?????????????? (unsigned long long)OCFS2_I(dir)->ip_blkno,
> @@ -399,6 +400,7 @@ static int ocfs2_mknod(struct inode *dir,
> ???????? ocfs2_add_links_count(dirfe, 1);
> ???????? ocfs2_journal_dirty(handle, parent_fe_bh);
> ???????? inc_nlink(dir);
> +??????? link_inc = 1;
> ???? }
> ?
> ???? status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
> @@ -444,6 +446,12 @@ static int ocfs2_mknod(struct inode *dir,
> ???? d_instantiate(dentry, inode);
> ???? status = 0;
> ?leave:
> +??? if (status < 0 && S_ISDIR(mode) && link_inc != 0) {
> +??????? ocfs2_add_links_count(dirfe, -1);
> +??????? ocfs2_journal_dirty(handle, parent_fe_bh);
> +??????? drop_nlink(dir);
> +??? }
> +

link_inc implies S_ISDIR(mode), so (status < 0 && link_inc) is
enough.
And it seems that no need to dirty parent_fe_bh again.

Thanks,
Joseph

> ???? if (status < 0 && did_quota_inode)
> ???????? dquot_free_inode(inode);
> ???? if (handle)
