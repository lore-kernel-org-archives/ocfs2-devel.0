From: alex chen <alex.chen@huawei.com>
Date: Thu, 25 Sep 2014 20:38:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix deadlock due to wrong locking
 order
In-Reply-To: <5423B893.30504@oracle.com>
References: <1410313732-27840-1-git-send-email-junxiao.bi@oracle.com>
	<542291D1.7070204@huawei.com> <5423B893.30504@oracle.com>
Message-ID: <54240CAA.6090301@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 2014/9/25 14:39, Junxiao Bi wrote:
> Yes, this should be fixed. How about the following fix?
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index c534cb0..682732f 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -833,14 +833,17 @@ static int ocfs2_write_zero_page(struct inode
> *inode, u64 abs_from,
>         di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
>         di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
>         di->i_mtime_nsec = di->i_ctime_nsec;
> -       ocfs2_journal_dirty(handle, di_bh);
> -       ocfs2_update_inode_fsync_trans(handle, inode, 1);
> +       if (handle) {
> +               ocfs2_journal_dirty(handle, di_bh);
> +               ocfs2_update_inode_fsync_trans(handle, inode, 1);
> +       }
> 
>  out_unlock:
>         unlock_page(page);
>         page_cache_release(page);
>  out_commit_trans:
> -       ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
> +       if (handle)
> +               ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
>  out:
>         return ret;
>  }
> 
> 
> Thanks,
> Junxiao.

OK, thanks.
	--Alex
