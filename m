From: Joseph Qi <jiangqi903@gmail.com>
Date: Fri, 28 Dec 2018 16:39:15 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: flush truncate log when main
 bitmap run out of space
In-Reply-To: <fdb16638-3d83-c065-2e49-996fb6310643@huawei.com>
References: <fdb16638-3d83-c065-2e49-996fb6310643@huawei.com>
Message-ID: <72d8a6ca-59e7-8f8f-8d45-cc70de558a32@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 18/12/28 16:29, Jia Guo wrote:
> Truncate log problem has been described in
> commit 50308d813bf2 ("ocfs2: Try to free truncate log when meeting
> ENOSPC in write.") and
> commit 2070ad1aebff ("ocfs2: retry on ENOSPC if sufficient space in
> truncate log"), but the following situations cannot be solved:
> 
> case 1:
> Main bitmap has been updated, but the transaction of the deleted blocks has
> not been committed completely. In this case, function
> ocfs2_reserve_cluster_bitmap_bits() returns success while function
> __ocfs2_claim_clusters return ENOSPC because we cannot reuse the deleted
> blocks before the transaction committed(test by function
> ocfs2_test_bg_bit_allocatable()). One can reproduce this by following
> steps:
> a, prepare a file which size is 50G, and volume still have 30G free space
> b, open the file with O_TRUNC flag
> c, sleep 5 seconds
> d, fallocate a 50G file, fallocate will fail.
> 
> case 2:
> Main bitmap doesn't have enough free bits, so does truncate log. But main
> bitmap plus truncate log has enough free bits. We are not gonging to try
> flush truncate log in this case, which is not reasonable.
> 
> So force commit the transaction when flushing the truncate log for case 1.
> For case 2, the value of osb->truncated_clusters doesn't seem to make
> sense, do the flush whenever we run out of space seems to be more
> reasonable.
> 
> Signed-off-by: Jia Guo <guojia12@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Reviewed-by: Gang He <ghe@suse.com>

Acked-by: Joseph Qi <jiangqi903@gmail.com>
