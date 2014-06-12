From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 12 Jun 2014 15:33:04 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: call ocfs2_journal_access_di()
 before ocfs2_journal_dirty() in ocfs2_write_end_nolock()
In-Reply-To: <5395AE8D.4090505@huawei.com>
References: <5395AE8D.4090505@huawei.com>
Message-ID: <20140612153304.41f6060c7f76d597b430306b@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 9 Jun 2014 20:54:37 +0800 yangwenfang <vicky.yangwenfang@huawei.com> wrote:

> @@ -2040,8 +2030,16 @@ out_write_size:
>  	di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
>  	di->i_mtime_nsec = di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
>  	ocfs2_update_inode_fsync_trans(handle, inode, 1);
> -	ocfs2_journal_dirty(handle, wc->w_di_bh);
> +	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		copied = ret;
> +		mlog_errno(ret);	
> +		goto out;
> +	}	
> 
> +	ocfs2_journal_dirty(handle, wc->w_di_bh);
> +out:
>  	ocfs2_commit_trans(osb, handle);
> 
>  	ocfs2_run_deallocs(osb, &wc->w_dealloc);

fs/ocfs2/aops.c: In function 'ocfs2_write_end_nolock':
fs/ocfs2/aops.c:2033: error: 'ret' undeclared (first use in this function)
fs/ocfs2/aops.c:2033: error: (Each undeclared identifier is reported only once
fs/ocfs2/aops.c:2033: error: for each function it appears in.)
