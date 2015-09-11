From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 11 Sep 2015 14:20:25 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2_direct_IO_write misses
 ocfs2_is_overwrite error code
In-Reply-To: <55ECF26C.4000100@huawei.com>
References: <55ECF26C.4000100@huawei.com>
Message-ID: <20150911142025.0d19ec04d56275e5a7c0407f@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 7 Sep 2015 10:11:56 +0800 "Norton.Zhu" <norton.zhu@huawei.com> wrote:

> If ocfs2_is_overwrite failed, ocfs2_direct_IO_write mays till return success to the caller.
> 
> ...
>
> --- a/aops.c
> +++ b/aops.c
> @@ -847,6 +847,7 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
>  		is_overwrite = ocfs2_is_overwrite(osb, inode, offset);
>  		if (is_overwrite < 0) {
>  			mlog_errno(is_overwrite);
> +			ret = is_overwrite;
>  			ocfs2_inode_unlock(inode, 1);
>  			goto clean_orphan;
>  		}

Looks OK.

We do `goto clean_orphan' and if (orphan), the code then proceeds to
overwrite the error code in `ret'.  This is odd, and probably wrong -
it's usually best to return the first-encountered error.
