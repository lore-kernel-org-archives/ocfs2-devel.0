From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 16 Nov 2016 13:45:39 +0300
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
 direct io
In-Reply-To: <777b2218-d12e-ea96-7e1c-6852c14b71ec@suse.com>
References: <20160309102505.GA15030@mwanda> <20161115103330.GL28558@mwanda>
	<20161115103638.GM28558@mwanda>
	<777b2218-d12e-ea96-7e1c-6852c14b71ec@suse.com>
Message-ID: <20161116104539.GO28558@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 16, 2016 at 10:33:49AM +0800, Eric Ren wrote:
> >>>fs/ocfs2/aops.c
> >>>   2235
> >>>   2236          ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
> >>>   2237                                         OCFS2_WRITE_DIRECT, NULL,
> >>>   2238                                         (void **)&wc, di_bh, NULL);
> >>>                                                ^^^^^^^^^^^^
> How do you perform the static checker? Please tech me;-)
> 

It's Smatch things that's not public yet.  Soon.

> Regarding this warning, please try to make this line
> (https://github.com/torvalds/linux/blob/master/fs/ocfs2/aops.c#L2128)
> into:
> 
> struct ocfs2_write_ctxt *wc = NULL;
> 
> It should work, and haven't any side effect.

That silences the warning, of course, but I feel like the code is buggy.
How do we know that we don't hit that exit path?

fs/ocfs2/aops.c
  1808          /*
  1809           * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
  1810           * the target page. In this case, we exit with no error and no target
  1811           * page. This will trigger the caller, page_mkwrite(), to re-try
  1812           * the operation.
  1813           */
  1814          if (ret == -EAGAIN) {
  1815                  BUG_ON(wc->w_target_page);
  1816                  ret = 0;
  1817                  goto out_quota;
  1818          }

regards,
dan carpenter
