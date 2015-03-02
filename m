From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 2 Mar 2015 20:42:36 +0800
Subject: [Ocfs2-devel] Read only issue,
 any other ideas aout it will be appreciated, Thanks a lot.
In-Reply-To: <71604351584F6A4EBAE558C676F37CA4696AC5F8@H3CMLB14-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA4696AC5F8@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <54F45ABC.6040002@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Zhonghua,
We have encountered the same problem as you described before.
However, for some reason, we did not record detailed information,
such as what operations the testers did and the data in disk.
So we are interested in your case. Can you described the testcase
in detail, and attach the image of read-only filesystem generated
by the tool o2image?
Thanks very much.

 -- Xuejiufei

On 2015/2/13 16:39, Guozhonghua wrote:
> Hi All,
> 
>  
> 
> As we test with OCFS2, sometime the file system become read only. The log is bellows.
> 
> We had review the code and try to find the reason, but did not find any ways to avoid this issue.
> 
> All the nodes in the cluster reach the read only file system finally.
> 
>  
> 
> Feb 12 15:38:30 node01 kernel: [173109.179478] OCFS2: ERROR (device dm-1): ocfs2_commit_truncate: Inode 8918280 has empty extent block at 8918280
> 
> Feb 12 15:38:30 node01 kernel: [173109.179478]
> 
> Feb 12 15:38:30 node01 kernel: [173109.179493] File system is now read-only due to the potential of on-disk corruption. Please run fsck.ocfs2 once the file system is unmounted.
> 
> Feb 12 15:38:30 node01 kernel: [173109.232387] (libvirtd,7367,11):ocfs2_truncate_for_delete:574 ERROR: status = -30
> 
> Feb 12 15:38:30 node01 kernel: [173109.232401] (libvirtd,7367,11):ocfs2_wipe_inode:743 ERROR: status = -30
> 
> Feb 12 15:38:30 node01 kernel: [173109.232408] (libvirtd,7367,11):ocfs2_delete_inode:1022 ERROR: status = -30
> 
>  
> 
>  
> 
> We had use the command of ?fsck.ocfs ?fpy? to repair the file system.
> 
> The repair procedures log is as below, there are some error about the inode data:
> 
> fsck.ocfs2 1.6.3
> 
> Checking OCFS2 filesystem in /dev/dm-1:
> 
>   Label:              o20140820105531
> 
>   UUID:               F1AAAC6C765D480F9052946392C6527A
> 
>   Number of blocks:   2621440000
> 
>   Block size:         4096
> 
>   Number of clusters: 10240000
> 
>   Cluster size:       1048576
> 
>   Number of slots:    32
> 
>  
> 
> /dev/dm-1 was run with -f, check forced.
> 
> Pass 0a: Checking cluster allocation chains
> 
> [CHAIN_BITS] Chain 60 in allocator inode 519 has 36784 bits marked free out of 64512 total bits but the block groups in the chain have 36762 free out of 64512 total.  Fix this by updating the chain record? y
> 
> [CHAIN_GROUP_BITS] Allocator inode 519 has 2071620 bits marked used out of 10240000 total bits but the chains have 2071642 used out of 10240000 total.  Fix this by updating the inode counts? y
> 
> Pass 0b: Checking inode allocation chains
> 
> Pass 0c: Checking extent block allocation chains
> 
> ^[Pass 1: Checking inodes and blocks.
> 
> [INODE_SPARSE_CLUSTERS] Inode 8918280 has 4294967286 clusters but its blocks fit in 0 clusters. Correct the number of clusters? y
> 
> Pass 2: Checking directory entries.
> 
> Pass 3: Checking directory connectivity.
> 
> Pass 4a: checking for orphaned inodes
> 
> [INODE_ORPHANED] Inode 8918280 was found in the orphan directory. Delete its contents and unlink it? y
> 
> Pass 4b: Checking inodes link counts.
> 
> [INODE_NOT_CONNECTED] Inode 8918281 isn't referenced by any directory entries.  Move it to lost+found? y
> 
> [INODE_NOT_CONNECTED] Inode 8918282 isn't referenced by any directory entries.  Move it to lost+found? y
> 
> All passes succeeded.
> 
>  
> 
> We are using Linux kernel with version 3.13.
> 
> Is there any way to fix it? Or any other patches?
> 
>  
> 
> Thanks a lot.
> 
>  
> 
>  
> 
>  
> 
>  
> 
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
