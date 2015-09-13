From: Joseph Qi <joseph.qi@huawei.com>
Date: Sun, 13 Sep 2015 18:00:01 +0800
Subject: [Ocfs2-devel] Performance issue about localalloc
In-Reply-To: <55F16831.5060702@huawei.com>
References: <55F16831.5060702@huawei.com>
Message-ID: <55F54921.80305@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
Could you please take a look at this?
And I want to change it by setting hint to res->sr_bg_blkno if it is
cluster alloc.
From my test case (block size = 4K, cluster size = 1M, localalloc
2048M), the file allocation is more contiguous than before and has much
better performance.

 	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
 				    res, &bits_left);
 	if (!status) {
-		hint = ocfs2_group_from_res(res);
+		if (ocfs2_is_cluster_bitmap(ac->ac_inode))
+			hint = res->sr_bg_blkno;
+		else
+			hint = ocfs2_group_from_res(res);
 		goto set_hint;
 	}
 	if (status < 0 && status != -ENOSPC) {

On 2015/9/10 19:23, Joseph Qi wrote:
> Hi Mark,
> I have encountered a performance issue about localalloc.
> 
> ocfs2 volume information:
> block size = 4k, cluster size = 1M, mount option with localalloc=2048
> 
> So in the above circumstance, gd size is 32256M. Suppose I want to
> create a normal file with size of 50G. Since the localalloc window is
> 2G, it will eventually allocate space like, 2Gfrom gd0, 2G from gd1,
> ..., and this will lead to poor performance because of the
> dis-contiguous file with large span.
> 
> One way to resolve this issue is changing the mount option with
> localalloc=31104, but this will make end user confused because 31G is
> "missing" even he has only used 2M.
> 
> So I wander if we can let the allocation continues with the last gd if
> it has enough space for a localalloc window. I have blamed the code
> history and found that firstly you have already designed like this but
> disabled in the commit "ocfs2: properly set and use inode group alloc
> hint". I wander why?
> 
> A simply code hack is,
> static u64 ocfs2_group_from_res(struct ocfs2_suballoc_result *res)
> {
> 	if (res->sr_blkno == 0)
> 		return 0;  // This will set the hint to 0
> 	...
> }
> 
> Am I missing something?
> 
> Thanks,
> Joseph
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
