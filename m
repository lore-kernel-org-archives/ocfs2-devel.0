From: piaojun <piaojun@huawei.com>
Date: Tue, 17 Mar 2020 21:29:44 +0800
Subject: [Ocfs2-devel] [PATCH v5] ocfs2: roll back the reference count
 modification of the parent directory if an error occurs
In-Reply-To: <a44f6666-bbc4-405e-0e6c-0f4e922eeef6@huawei.com>
References: <a44f6666-bbc4-405e-0e6c-0f4e922eeef6@huawei.com>
Message-ID: <d88d70e8-66fc-2077-cc9f-9a0545196d8f@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/3/17 20:28, wangjian wrote:
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
Reviewed-by: Jun Piao <piaojun@huawei.com>
