From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 28 Jul 2016 14:39:51 -0700
Subject: [Ocfs2-devel] [patch 2/5] ocfs2: retry on ENOSPC if sufficient
 space in truncate log
In-Reply-To: <579a73b7.YTrXbBq1bvN10SiX%akpm@linux-foundation.org>
References: <579a73b7.YTrXbBq1bvN10SiX%akpm@linux-foundation.org>
Message-ID: <20160728213951.GA5316@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 28, 2016 at 02:05:59PM -0700, Andrew Morton wrote:
> From: Eric Ren <zren@suse.com>
> Subject: ocfs2: retry on ENOSPC if sufficient space in truncate log
> 
> The testcase "mmaptruncate" in ocfs2 test suite always fails with ENOSPC
> error on small volume (say less than 10G).  This testcase repeatedly
> performs "extend" and "truncate" on a file.  Continuously, it truncates
> the file to 1/2 of the size, and then extends to 100% of the size.  The
> main bitmap will quickly run out of space because the "truncate" code
> prevent truncate log from being flushed by
> ocfs2_schedule_truncate_log_flush(osb, 1), while truncate log may have
> cached lots of clusters.
> 
> So retry to allocate after flushing truncate log when ENOSPC is returned. 
> And we cannot reuse the deleted blocks before the transaction committed. 
> Fortunately, we already have a function to do this -
> ocfs2_try_to_free_truncate_log().  Just need to remove the "static"
> modifier and put it into the right place.
> 
> The "unlock"/"lock" code isn't elegant, but there seems to be no better
> option.
> 
> [zren at suse.com: locking fix]
>   Link: http://lkml.kernel.org/r/1468031546-4797-1-git-send-email-zren at suse.com
> Link: http://lkml.kernel.org/r/1466586469-5541-1-git-send-email-zren at suse.com
> Signed-off-by: Eric Ren <zren@suse.com>
> Reviewed-by: Gang He <ghe@suse.com>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

Thanks for this Eric.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark


--
Mark Fasheh
