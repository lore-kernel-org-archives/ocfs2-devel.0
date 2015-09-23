From: Ryan Ding <ryan.ding@oracle.com>
Date: Wed, 23 Sep 2015 10:14:11 +0800
Subject: [Ocfs2-devel] ocfs2: do not change i_size in write_end for
	direct io
In-Reply-To: <20150921162343.GC5648@mwanda>
References: <20150921162343.GC5648@mwanda>
Message-ID: <56020AF3.5060602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

HiDan,

On 09/22/2015 12:24 AM, Dan Carpenter wrote:
> Hello Ryan Ding,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 3d598f72dc44: "ocfs2: do not change i_size in write_end for
> direct io" from Sep 17, 2015, leads to the following Smatch complaint:
>
> fs/ocfs2/aops.c:2063 ocfs2_write_end_nolock()
> 	 error: we previously assumed 'handle' could be null (see line 1994)
>
> fs/ocfs2/aops.c
>    1993	
>    1994		if (handle) {
>
> Patch adds check.
>
>    1995			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
>    1996					wc->w_di_bh, OCFS2_JOURNAL_ACCESS_WRITE);
>    1997			if (ret) {
>    1998				copied = ret;
>    1999				mlog_errno(ret);
>    2000				goto out;
>    2001			}
>    2002		}
>    2003	
>    2004		if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
>    2005			ocfs2_write_end_inline(inode, pos, len, &copied, di, wc);
>    2006			goto out_write_size;
>    2007		}
>    2008	
>    2009		if (unlikely(copied < len) && wc->w_target_page) {
>    2010			if (!PageUptodate(wc->w_target_page))
>    2011				copied = 0;
>    2012	
>    2013			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
>    2014					       start+len);
>    2015		}
>    2016		if (wc->w_target_page)
>    2017			flush_dcache_page(wc->w_target_page);
>    2018	
>    2019		for(i = 0; i < wc->w_num_pages; i++) {
>    2020			tmppage = wc->w_pages[i];
>    2021	
>    2022			/* This is the direct io target page. */
>    2023			if (tmppage == NULL)
>    2024				continue;
>    2025	
>    2026			if (tmppage == wc->w_target_page) {
>    2027				from = wc->w_target_from;
>    2028				to = wc->w_target_to;
>    2029	
>    2030				BUG_ON(from > PAGE_CACHE_SIZE ||
>    2031				       to > PAGE_CACHE_SIZE ||
>    2032				       to < from);
>    2033			} else {
>    2034				/*
>    2035				 * Pages adjacent to the target (if any) imply
>    2036				 * a hole-filling write in which case we want
>    2037				 * to flush their entire range.
>    2038				 */
>    2039				from = 0;
>    2040				to = PAGE_CACHE_SIZE;
>    2041			}
>    2042	
>    2043			if (page_has_buffers(tmppage)) {
>    2044				if (handle && ocfs2_should_order_data(inode))
>    2045					ocfs2_jbd2_file_inode(handle, inode);
>    2046				block_commit_write(tmppage, from, to);
>    2047			}
>    2048		}
>    2049	
>    2050	out_write_size:
>    2051		/* Direct io do not update i_size here. */
>    2052		if (wc->w_type != OCFS2_WRITE_DIRECT) {
>    2053			pos += copied;
>    2054			if (pos > i_size_read(inode)) {
>    2055				i_size_write(inode, pos);
>    2056				mark_inode_dirty(inode);
>    2057			}
>    2058			inode->i_blocks = ocfs2_inode_sector_count(inode);
>    2059			di->i_size = cpu_to_le64((u64)i_size_read(inode));
>    2060			inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>    2061			di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
>    2062			di->i_mtime_nsec = di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
>    2063			ocfs2_update_inode_fsync_trans(handle, inode, 1);
>                                                         ^^^^^^
> Unchecked dereference inside function call.
Previous check (wc->w_type != OCFS2_WRITE_DIRECT) will make sure 
'handle' is not NULL. Since only direct io may have a NULL handle.

Regards,
Ryan
>
>    2064		}
>    2065		if (handle)
>
> regards,
> dan carpenter
