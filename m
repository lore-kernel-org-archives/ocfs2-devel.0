From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 7 Jul 2016 18:35:39 +0300
Subject: [Ocfs2-devel] [bug report] ocfs2: fix sparse file & data ordering
 issue in direct io
Message-ID: <20160707153539.GA19602@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Ryan Ding,

The patch c15471f79506: "ocfs2: fix sparse file & data ordering issue
in direct io" from Mar 25, 2016, leads to the following static
checker warning:

	fs/ocfs2/aops.c:2205 ocfs2_dio_get_block()
	error: potentially dereferencing uninitialized 'wc'.

fs/ocfs2/aops.c
  2196  
  2197          ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
  2198                                         OCFS2_WRITE_DIRECT, NULL,
  2199                                         (void **)&wc, di_bh, NULL);
  2200          if (ret) {
  2201                  mlog_errno(ret);
  2202                  goto unlock;
  2203          }
  2204  
  2205          desc = &wc->w_desc[0];
  2206  
  2207          p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys);
  2208          BUG_ON(p_blkno == 0);
  2209          p_blkno += iblock & (u64)(ocfs2_clusters_to_blocks(inode->i_sb, 1) - 1);

What it's complaining about is this code path:

fs/ocfs2/aops.c
  1807  
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
  1819  

We return success without setting "wc".  It says that the caller will
check the target page, but we are passing a NULL target page?  It's not
clear to me how this works.

regards,
dan carpenter
