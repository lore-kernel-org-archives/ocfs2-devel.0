From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 28 Aug 2015 16:03:08 -0700
Subject: [Ocfs2-devel] [patch 01/28] ocfs2: set filesytem read-only when
 ocfs2_delete_entry failed.
In-Reply-To: <55de3989.YMw1ECdWagoCdX9X%akpm@linux-foundation.org>
References: <55de3989.YMw1ECdWagoCdX9X%akpm@linux-foundation.org>
Message-ID: <20150828230308.GG1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:21PM -0700, Andrew Morton wrote:
> From: jiangyiwen <jiangyiwen@huawei.com>
> Subject: ocfs2: set filesytem read-only when ocfs2_delete_entry failed.
> 
> In ocfs2_rename, it will lead to an inode with two entried(old and new) if
> ocfs2_delete_entry(old) failed.  Thus, filesystem will be inconsistent.
> 
> The case is described below:
> 
> ocfs2_rename
>     -> ocfs2_start_trans
>     -> ocfs2_add_entry(new)
>     -> ocfs2_delete_entry(old)
>         -> __ocfs2_journal_access *failed* because of -ENOMEM
>     -> ocfs2_commit_trans
> 
> So filesystem should be set to read-only at the moment.
> 
> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Cc: Joseph Qi <joseph.qi@huawei.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
