From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 21 Apr 2015 14:03:13 +0800
Subject: [Ocfs2-devel] read only issue caused by jbd2_journal_restart()
Message-ID: <5535E821.5090609@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
I found that function jbd2_journal_restart() is called some places in
ocfs2 without keeping things consistently before. However, 
jbd2_journal_restart() may commit the handle's transaction and restart
another one. If the first transaction is committed successfully
while another not, it may cause filesystem inconsistency or read only.

Here's two examples below:
1. append a extent to a file:
ocfs2_insert_extent
  -> call ocfs2_grow_tree() if there's no free rec
     -> ocfs2_add_branch add a new branch to extent tree
  -> ocfs2_do_insert_extent
     -> ocfs2_rotate_tree_right
       -> ocfs2_extend_rotate_transaction
          -> jbd2_journal_restart if jbd2_journal_extend fail
     -> ocfs2_insert_path
        -> ocfs2_extend_trans
          -> jbd2_journal_restart if jbd2_journal_extend fail
        -> ocfs2_insert_at_leaf
     -> ocfs2_et_update_clusters
If the buffers dirtied in ocfs2_add_branch() is committed
while ocfs2_insert_at_leaf() and ocfs2_et_update_clusters() not,
an empty rec[0] is left in rightmost path which will cause
read-only filesystem when call ocfs2_commit_truncate() 
with the error message: "Inode %lu has an empty extent record".

2. call ioctl(OCFS2_IOC_UNRESVSP64) to unreserve an extent inside the file
ocfs2_change_file_space
  -> ocfs2_remove_inode_range
    -> ocfs2_remove_btree_range
      -> ocfs2_remove_extent
        -> ocfs2_truncate_rec to truncate the entire extent rec
          -> ocfs2_cleanup_merge make rec[0] empty
          -> ocfs2_rotate_tree_left
            -> __ocfs2_rotate_tree_left
              -> ocfs2_extend_rotate_transaction
                -> ocfs2_extend_trans
                  -> jbd2_journal_restart if jbd2_journal_extend fail
  -> ocfs2_et_update_clusters

If the buffers dirtied in ocfs2_truncate_rec() is committed
while ocfs2_et_update_clusters not, the clusters on extent tree and
i_clusters in ocfs2_dinode is inconsistency. So after remount, the
clusters read from ocfs2_inode is not correct, and it also cause
read-only problem when call ocfs2_commit_truncate() with the error
message: "Inode %llu has empty extent block at %llu".
There are two more functions that have the same problem as above:
ocfs2_update_edge_lengths
ocfs2_remove_rightmost_path

I have no ideas how to fix these problem altogether. So I want to
fix each problem with different way:
1) "empty extent record" is not a serious problem, so I want
to remove the empty extent record when call ocfs2_commit_truncate();
2) The inconsistency between the total clusters on extent tree and
i_clusters in ocfs2_dinode is not acceptable. I want to extend enough
credit for ocfs2_update_edge_lengths and ocfs2_remove_rightmost_path
before to avoid this problem. But the problem in function
__ocfs2_rotate_tree_left() can not be fixed by this way.

Does anyone have an idea to resolve these issues in a better way?
Thanks very much.
