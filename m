From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 10 Feb 2014 13:43:44 -0800
Subject: [Ocfs2-devel] [patch 11/11] ocfs2: update inode size after
	zeroing the hole
In-Reply-To: <20140124204712.15E4031C2C7@corp2gmr1-1.hot.corp.google.com>
References: <20140124204712.15E4031C2C7@corp2gmr1-1.hot.corp.google.com>
Message-ID: <20140210214344.GV24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 24, 2014 at 12:47:11PM -0800, akpm at linux-foundation.org wrote:
> From: Junxiao Bi <junxiao.bi@oracle.com>
> Subject: ocfs2: update inode size after zeroing the hole
> 
> fs-writeback will release the dirty pages without page lock whose offset
> are over inode size, the release happens at block_write_full_page_endio().
>  If not update, dirty pages in file holes may be released before flushed
> to the disk, then file holes will contain some non-zero data, this will
> cause sparse file md5sum error.
> 
> To reproduce the bug, find a big sparse file with many holes, like vm
> image file, its actual size should be bigger than available mem size to
> make writeback work more frequently, tar it with -S option, then keep
> untar it and check its md5sum again and again until you get a wrong
> md5sum.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Younger Liu <younger.liu@huawei.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This patch looks good - thanks Junxiao.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
