Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA5E1A5B9E
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Mar 2026 08:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773303670; cv=none; b=uj1g0ye7XIJd1ClZObmN5KddEago3KV0W2+xGGHFf+GMR8xGHdgAkyeaSwpmA0KVfKZdMJlj8MP/OMJheF37f5ffzBhsKGNcX8Uah7PdzZ+Rh9zm+af5VZ5Lkjra5p2d2cgO+1ECZM5wUwWDaMvwoMEau49DtZ/BwB2yMAcKnNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773303670; c=relaxed/simple;
	bh=favSTnFJkLkEsXywenhA9nQU3MJrkbrkiDAPsfYzma0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=AOya49BMwgRzE/xbTCkahvAbom8LnKCKBKkhZ3jxj8f8KNIzP5+MIiU3/DDIQj+RGNHvdA/EPftLK9OnwCJhjuPJ6RP1gxPDK67w4fcmhtIyxqPXfu2X5mrtgNbu/9iSBfcxql5EyXyGoz8QL/IaeHlR+RKqDSofVsW3Ibbs5CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=p+ewUK/0; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="p+ewUK/0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773303659; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=oqR5tVGxqSOb6M7BlsDFuBSpTLxvQFTKuucGdyCOApQ=;
	b=p+ewUK/0q0WTVm289G7kMG6a4IdyR0GeGyWL2vA3UW3BSj69fdw7i14rV8Xr8jzLxGrTFp9DIFKFsSUSicuDpBsSuzhe/577oFv4aTAXcZaV//iVh1EpESHPJEzRWjB4A6jUrPOcSVMxmZ/rEndzrstrYZpyiRoPe9etZJvaKI8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X-no84s_1773303657;
Received: from 30.221.129.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-no84s_1773303657 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Mar 2026 16:20:58 +0800
Message-ID: <9dd35ba3-9b81-477a-8af3-21b1cc8c351c@linux.alibaba.com>
Date: Thu, 12 Mar 2026 16:20:57 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: possible deadlock in ocfs2_wipe_inode
To: Jianzhou Zhao <luckd0g@163.com>
References: <3d199d9e.68fb.19cdbe142b2.Coremail.luckd0g@163.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Heming Zhao <heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <3d199d9e.68fb.19cdbe142b2.Coremail.luckd0g@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/11/26 3:51 PM, Jianzhou Zhao wrote:
> 
> 
> Subject: [BUG] ocfs2: WARNING: possible circular locking dependency in ocfs2_evict_inode
> 
> Dear Maintainers,
> 
> We are writing to report a possible circular locking dependency vulnerability in the `ocfs2` subsystem, detected by the Lockdep validation mechanism as well as our custom fuzzing tool, RacePilot. The bug involves an ABBA deadlock concerning the system inode allocations, `fs_reclaim`, and `osb->nfs_sync_rwlock`. We observed this on the Linux kernel version 6.18.0-08691-g2061f18ad76e-dirty.
> 
> Call Trace & Context
> ==================================================================
> WARNING: possible circular locking dependency detected
> kswapd1/95 is trying to acquire lock:
> ffff8880005889c0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
> ffff8880005889c0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode+0x2df/0x1380 fs/ocfs2/inode.c:852
> 
> but task is already holding lock:
> ffff8880533acbd0 (&osb->nfs_sync_rwlock){.+.+}-{4:4}, at: ocfs2_nfs_sync_lock+0xe9/0x2f0 fs/ocfs2/dlmglue.c:2875
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #3 (&osb->nfs_sync_rwlock){.+.+}-{4:4}:
>        down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
>        ocfs2_nfs_sync_lock+0xe9/0x2f0 fs/ocfs2/dlmglue.c:2875
>        ocfs2_delete_inode fs/ocfs2/inode.c:1106 [inline]
>        ocfs2_evict_inode+0x2c7/0x1430 fs/ocfs2/inode.c:1297
>        evict+0x3b3/0xaa0 fs/inode.c:850
>        ...
>        balance_pgdat+0xb75/0x1a20 mm/vmscan.c:7270
>        kswapd+0x576/0xac0 mm/vmscan.c:7537
> 
> -> #2 (fs_reclaim){+.+.}-{0:0}:
>        __fs_reclaim_acquire mm/page_alloc.c:4264 [inline]
>        fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:4278
>        ...
>        slab_alloc_node mm/slub.c:5234 [inline]
>        kmalloc_noprof include/linux/slab.h:957 [inline]
>        ocfs2_reserve_new_metadata_blocks+0xed/0xb50 fs/ocfs2/suballoc.c:968
>        ocfs2_mknod+0xa65/0x24e0 fs/ocfs2/namei.c:350
>        ocfs2_create+0x180/0x430 fs/ocfs2/namei.c:676
>        ...
>        do_sys_open fs/open.c:1436 [inline]
>        __x64_sys_openat+0x13f/0x1f0 fs/open.c:1447
> 
> -> #1 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
>        down_write+0x91/0x200 kernel/locking/rwsem.c:1590
>        inode_lock include/linux/fs.h:1027 [inline]
>        ocfs2_remove_inode+0x15e/0x8e0 fs/ocfs2/inode.c:731
>        ocfs2_wipe_inode+0x652/0x1380 fs/ocfs2/inode.c:894
>        ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
>        ocfs2_evict_inode+0x69e/0x1430 fs/ocfs2/inode.c:1297
>        ...
> 
> -> #0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
>        lock_acquire+0x17b/0x330 kernel/locking/lockdep.c:5825
>        down_write+0x91/0x200 kernel/locking/rwsem.c:1590
>        inode_lock include/linux/fs.h:1027 [inline]
>        ocfs2_wipe_inode+0x2df/0x1380 fs/ocfs2/inode.c:852
>        ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
>        ocfs2_evict_inode+0x69e/0x1430 fs/ocfs2/inode.c:1297
>        ...
>        kswapd+0x576/0xac0 mm/vmscan.c:7537
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] --> fs_reclaim --> &osb->nfs_sync_rwlock
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   rlock(&osb->nfs_sync_rwlock);
>                                lock(fs_reclaim);
>                                lock(&osb->nfs_sync_rwlock);
>   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> 
>  *** DEADLOCK ***
> ==================================================================
> 
> Execution Flow & Code Context
> The `kswapd` thread processes eviction logic for unused inodes in the dcache queue holding the `fs_reclaim` lock contexts. When a unlinked inode enters `ocfs2_evict_inode()`, it calls into `ocfs2_delete_inode()`. The deletion pathway attempts to securely clear traces of the inode globally by locking internal structure mutexes including the `nfs_sync_rwlock` and `ORPHAN_DIR_SYSTEM_INODE` lock:
> ```c
> // fs/ocfs2/inode.c
> static void ocfs2_delete_inode(struct inode *inode)
> {
> 	...
> 	status = ocfs2_nfs_sync_lock(OCFS2_SB(inode->i_sb), 0); // <-- Takes nfs_sync_rwlock
> 	...
> 	status = ocfs2_wipe_inode(inode, di_bh);
> 	...
> }
> 
> static int ocfs2_wipe_inode(struct inode *inode, struct buffer_head *di_bh)
> {
> 	...
> 		inode_lock(orphan_dir_inode); // <-- Takes ocfs2_sysfile_lock_key[ORPHAN_DIR]
> 		status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
> 	...
> }
> ```
> Concurrently, another thread could invoke file creation (`ocfs2_create` ... `ocfs2_reserve_new_metadata_blocks`), requiring memory. In this path, if it pauses allocation, it calls `kmalloc` invoking `fs_reclaim_acquire`, making `&ocfs2_sysfile_lock_key` -> `fs_reclaim` dependent loops since some metadata modifications naturally grasp system file cluster locks to protect alloc structures.
> 
> Root Cause Analysis
> A circular locking deadlock exists because `ocfs2_evict_inode` is triggered directly under memory `fs_reclaim` shrinker pathways (e.g., from `kswapd`). When `kswapd` frees the dentry structures, `evict` is processed synchronously in the reclaim context, which in OCFS2 takes complex subsystem locks spanning DLM locks like `nfs_sync_rwlock` and various `sysfile_lock_key` variants intended to orchestrate global orphan cleanups. If any other arbitrary thread operating on creation pathways sleeps acquiring physical block pages (`fs_reclaim` needed), the paths will intertwine resulting in lock cycles.
> Unfortunately, we were unable to generate a reproducer for this bug.
> 
> Potential Impact
> This circular dependency can stall the `kswapd` daemon globally halting memory management tasks, leading to system OOM (Out of Memory) panics and filesystem lock-ups. This constitutes a persistent local Denial of Service (DoS) capability triggered arbitrarily under low-free memory workloads with orphaned inodes.
> 
> Proposed Fix
> To mitigate the deadlock, `ocfs2_evict_inode` must defer the heavy `ocfs2_delete_inode` operations to a worker queue outside the memory reclaim context if the current process is a memory reclaimer (such as `kswapd` signaled by `current->flags & PF_MEMALLOC`).
> 
> ```diff
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1292,8 +1292,16 @@ void ocfs2_evict_inode(struct inode *inode)
>  	write_inode_now(inode, 1);
>  
>  	if (!inode->i_nlink ||
>  	    (OCFS2_I(inode)->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)) {
> -		ocfs2_delete_inode(inode);
> +		if (current->flags & PF_MEMALLOC) {
> +			/*
> +			 * Defer deleting orphan inodes if doing memory reclaim
> +			 * to avoid lockdep circular dependencies.
> +			 */
> +			ocfs2_queue_orphan_scan(OCFS2_SB(inode->i_sb));
> +		} else {
> +			ocfs2_delete_inode(inode);
> +		}
>  	} else {
>  		truncate_inode_pages_final(&inode->i_data);
>  	}
> ```
> 
> We would be highly honored if this could be of any help.
> 

Take a look at this report, I think it could *theoreticallly* happen.

    CPU0				CPU1
fs_reclaim			    ocfs2_reserve_suballoc_bits
  ocfs2_evict_inode		      inode_lock(INODE_ALLOC)
    down_read(nfs_sync_rwlock)        ocfs2_block_group_alloc
    ocfs2_wipe_inode                    ocfs2_reserve_clusters_with_limit
      inode_lock(ORPHAN_DIR)              kzalloc_obj
      ocfs2_remove_inode
        inode_lock(INODE_ALLOC)

Your proposed fix looks incorrect and it could be much complicated.
Maybe use memalloc_nofs_[save|restore] when allocate.

Thanks,
Joseph
