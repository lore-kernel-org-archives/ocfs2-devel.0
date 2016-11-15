From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 15 Nov 2016 13:33:30 +0300
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
	direct io
In-Reply-To: <20160309102505.GA15030@mwanda>
References: <20160309102505.GA15030@mwanda>
Message-ID: <20161115103330.GL28558@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I never got a response on this.  I was looking at it today and it still
looks buggy to me.

regards,
dan carpenter

On Wed, Mar 09, 2016 at 01:25:05PM +0300, Dan Carpenter wrote:
> Hello Ryan Ding,
> 
> The patch fbe25fb91af5: "ocfs2: fix sparse file & data ordering issue
> in direct io" from Feb 25, 2016, leads to the following static
> checker warning:
> 
> 	fs/ocfs2/aops.c:2242 ocfs2_dio_get_block()
> 	error: potentially dereferencing uninitialized 'wc'.
> 
> fs/ocfs2/aops.c
>   2235  
>   2236          ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
>   2237                                         OCFS2_WRITE_DIRECT, NULL,
>   2238                                         (void **)&wc, di_bh, NULL);
>                                                ^^^^^^^^^^^^
> 
> See commit 5cffff9e2986 ('ocfs2: Fix ocfs2_page_mkwrite()') for an
> explanation why a zero return here does not imply that "wc" has been
> initialized.
> 
>   2239          if (ret) {
>   2240                  mlog_errno(ret);
>   2241                  goto unlock;
>   2242          }
>   2243  
>   2244          desc = &wc->w_desc[0];
>   2245  
>   2246          p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys);
> 
> regards,
> dan carpenter
