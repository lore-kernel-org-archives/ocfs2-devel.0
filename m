From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 7 Oct 2019 15:11:21 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: move the mlog from the spinlock to
 outside
In-Reply-To: <1569813459-8601-1-git-send-email-sunny.s.zhang@oracle.com>
References: <1569813459-8601-1-git-send-email-sunny.s.zhang@oracle.com>
Message-ID: <20191007151121.c0acdfe0eda4a18e1c24e141@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 30 Sep 2019 11:17:39 +0800 Shuning Zhang <sunny.s.zhang@oracle.com> wrote:

> There is a potential task of deadlock. Because the mask
> is 0, the deadlock does not occur now. But There is a
> potential task. If someone change the mask of mlog, but
> forget to modify the order of the mlog and spin_unlock,
> There will be a potential deadlock.So I move the mlog
> from the spinlock to outsize.
> 
> ...
>
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2315,10 +2315,10 @@ static int ocfs2_inode_lock_update(struct inode *inode,
>  
>  	spin_lock(&oi->ip_lock);
>  	if (oi->ip_flags & OCFS2_INODE_DELETED) {
> +		spin_unlock(&oi->ip_lock);
>  		mlog(0, "Orphaned inode %llu was deleted while we "
>  		     "were waiting on a lock. ip_flags = 0x%x\n",
>  		     (unsigned long long)oi->ip_blkno, oi->ip_flags);
> -		spin_unlock(&oi->ip_lock);
>  		status = -ENOENT;
>  		goto bail;
>  	}

The patch is obviously OK but I don't see any deadlock.  mlog() doesn't
take any locks?
