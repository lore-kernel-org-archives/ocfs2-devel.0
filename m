From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 28 Aug 2015 16:52:00 -0700
Subject: [Ocfs2-devel] [patch 10/28] ocfs2: do not set fs read-only if
 rec[0] is empty while committing truncate
In-Reply-To: <55de39a2.TGWqnTrGdzdnwtG7%akpm@linux-foundation.org>
References: <55de39a2.TGWqnTrGdzdnwtG7%akpm@linux-foundation.org>
Message-ID: <20150828235200.GP1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:46PM -0700, Andrew Morton wrote:
> From: Xue jiufei <xuejiufei@huawei.com>
> Subject: ocfs2: do not set fs read-only if rec[0] is empty while committing truncate
> 
> While appending an extent to a file, it will call these functions:
> ocfs2_insert_extent
> 
>   -> call ocfs2_grow_tree() if there's no free rec
>      -> ocfs2_add_branch add a new branch to extent tree,
>         now rec[0] in the leaf of rightmost path is empty
>   -> ocfs2_do_insert_extent
>      -> ocfs2_rotate_tree_right
>        -> ocfs2_extend_rotate_transaction
>           -> jbd2_journal_restart if jbd2_journal_extend fail
>      -> ocfs2_insert_path
>         -> ocfs2_extend_trans
>           -> jbd2_journal_restart if jbd2_journal_extend fail
>         -> ocfs2_insert_at_leaf
>      -> ocfs2_et_update_clusters
> Function jbd2_journal_restart() may be called and it may happened that
> buffers dirtied in ocfs2_add_branch() are committed
> while buffers dirtied in ocfs2_insert_at_leaf() and
> ocfs2_et_update_clusters() are not.
> So an empty rec[0] is left in rightmost path which will cause
> read-only filesystem when call ocfs2_commit_truncate()
> with the error message: "Inode %lu has an empty extent record".
> 
> This is not a serious problem, so remove the rightmost path when call
> ocfs2_commit_truncate().
> 
> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>



--
Mark Fasheh
