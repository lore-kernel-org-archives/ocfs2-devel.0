Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793191696;
	b=gLYY0Aw9+Xac8wM5NgDqdQNJz2oh5IOGB+ZNDzHAKn2fYLSDnpqf6KGvf8UGg6YN2Wdp
	 8hPHsohxRsbl7ATSqYyeAx6ZBEzX0U7jFOjG6eJ24FVmHKLhQUcroVvV2daJynU955wXI
	 8CBho+RTNuJ/39c7qHoAYVTOK5aosq49KOgvMDwUjlozntdu5W+66pV/FpzTjLG8AV5in
	 Ih1T30wauLRSMD341XQg4b4Hxwt85Dhzk+vj4KMDMSg2dA6tDiHc8yF4Zlk9i5llYaKFU
	 EzVNNDQ9yPDi8PUG8fSzDH1t6FSDvWNR3WRq7M9Yjy+v0TWdbB0JQjb2g9RbJxPoBJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793191696;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=/rp10C9vmYrvZ8n2ETCONDZuve+pgclYyA15cGXRQ9U=;
	b=QwKG6BQmmKAXyTppWeDL9Rlc4m1fNR3ySs+ZHe9Fn6XridXTP1sJCwCEIuKWDvo6ZpOG
	 OeOjhJTz8YCQ3eJ92pe+KH9vrEjIr5biObRGB+E4OCcUlqPzcmcLJIBpswRXyxvleTvdW
	 8f8I5J2UU2Grkt4WD+MkMn0VpzRAu+eItGWq2ln/HiJfZRl9X0wWS4hbb6MIPC69L+oKB
	 z+vyR/Ag4on3MG1nyLB3L4lWLF0Z9kvaNMZMUM4c4CeWgDIsbk+pmUSdF0bpQrANFPcBs
	 9MKcadWwKThclQJjdY8dyoOWnfQ4i+9IZAP4osLVlh8GOlKnsEUuvl4ZWJhXO0BtvKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="WdYKCS/Y";
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D19606A31C
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Oct 2026 12:48:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56D19606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WdYKCS/Y
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793191689; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/rp10C9vmYrvZ8n2ETCONDZuve+pgclYyA15cGXRQ9U=;
	b=WdYKCS/Ya5di0Vp1IpLsp1hSPylkH1rsruAmJUbQAj+MtSD1S19ir6PBi98TI737EfmVk3FBaBPsbKfRsVqZYqTDxS1uMNPnCevH8TRUP4s4QYwrqQbKdoJvxRTV3BQVhRYd5dsrw+rWmrhMP5rIKyc0oJW9udcgJzmnwNuP27M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDgpOyF_1793191687;
Received: from 30.221.129.127(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDgpOyF_1793191687 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 20:48:08 +0800
Message-ID: <a0c3eeda-f73b-483f-a129-8d45eb120337@linux.alibaba.com>
Date: Wed, 28 Oct 2026 20:48:07 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: advance locking_state through the live cursor
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0053-v5-76075d5da2df8108f813@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0053-v5-76075d5da2df8108f813@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/26/26 10:00 PM, Cen Zhang wrote:
> locking_state copies each lock resource under ocfs2_dlm_tracking_lock
> so its containing inode or quota object can be freed during the dump.
> The copied l_debug_list pointers do not have that lifetime protection.
> Yet ocfs2_dlm_seq_next() follows them to find the next record.
> 
> Remounting read-only can free a quota-info object while a debugfs read
> is between the snapshot and the next iterator callback:
> 
>   locking_state reader                Quota suspension
>   --------------------                ----------------
>   snapshot current lock resource
>     copy l_debug_list.next
>                                       remove next resource from live list
>                                       free quota-info object
>   seq_next(): follow copied link
>     read freed lock resource
> 
> Advance through the live dummy cursor instead. List removal updates its
> links under the tracking lock. Position it after the resource being
> copied before releasing the lock, and never walk the snapshot's links.
> Rebuild the cursor from the requested position in seq_start() so a
> seq_file buffer retry or seek starts at that record again.

seq_lseek() does not pass the target to ->start. It calls traverse(), which
resets the index and walks forward through ->next instead.

> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
>     Read of size 8 at addr ffff888117ea9838 by task python3/489
>     
>     CPU: 3 UID: 0 PID: 489 Comm: python3 Not tainted 7.3.0-rc4-next-20260921-pmb-bt-functional-v1+ #1 PREEMPT(lazy) 
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      ? ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __virt_addr_valid+0x20e/0x420
>      ? ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
>      kasan_report+0xe0/0x110
>      ? ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
>      ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
>      ? __pfx_ocfs2_dlm_next_res.isra.0+0x10/0x10
>      ? __pfx_do_raw_spin_lock+0x10/0x10
>      ocfs2_dlm_seq_next+0xb8/0x4c0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      seq_read_iter+0x92f/0x1110
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      seq_read+0x362/0x5a0
>      ? __pfx_seq_read+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? selinux_file_permission+0x11d/0x540
>      full_proxy_read+0x11f/0x180
>      ? __pfx_full_proxy_read+0x10/0x10
>      vfs_read+0x1a0/0xc20
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? kmem_cache_free+0x242/0x580
>      ? __pfx_vfs_read+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? putname+0x93/0xe0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? do_sys_openat2+0x12a/0x1b0
>      ? __pfx_do_sys_openat2+0x10/0x10
>      ksys_read+0x111/0x200
>      ? __pfx_ksys_read+0x10/0x10
>      ? irqentry_exit+0xbe/0x820
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? trace_hardirqs_on_prepare+0x11d/0x150
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     RIP: 0033:0x7f0266dbb687
>     Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
>     RSP: 002b:00007ffccf76fc40 EFLAGS: 00000202 ORIG_RAX: 0000000000000000
>     RAX: ffffffffffffffda RBX: 00007f0266d27780 RCX: 00007f0266dbb687
>     RDX: 0000000000000001 RSI: 00007f0266a53200 RDI: 0000000000000004
>     RBP: 00007f0266d27700 R08: 0000000000000000 R09: 0000000000000000
>     R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000001
>     R13: 00007f0266a53200 R14: 0000000000000004 R15: 00007f0266b651e0
>      </TASK>
>     
>     Allocated by task 547:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_kmalloc+0xaa/0xb0
>      __kmalloc_cache_noprof+0x28d/0x610
>      ocfs2_local_read_info+0x181/0x1580
>      dquot_load_quota_sb+0x68b/0x1000
>      dquot_load_quota_inode+0x227/0x3e0
>      ocfs2_enable_quotas+0x27c/0x520
>      ocfs2_fill_super+0x21f9/0x38f0
>      get_tree_bdev_flags+0x35d/0x5f0
>      vfs_get_tree+0x93/0x320
>      fc_mount+0x1d/0x200
>      path_mount+0x592/0x1e00
>      __x64_sys_mount+0x24b/0x2d0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     
>     Freed by task 577:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      kfree+0x308/0x580
>      ocfs2_local_free_info+0x47b/0x800
>      dquot_disable+0x5d9/0x17a0
>      ocfs2_susp_quotas.isra.0+0x22c/0x2b0
>      ocfs2_reconfigure+0x284/0xd00
>      reconfigure_super+0x3ca/0xa70
>      path_mount+0x16ae/0x1e00
>      __x64_sys_mount+0x24b/0x2d0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     
>     The buggy address belongs to the object at ffff888117ea9800
>      which belongs to the cache kmalloc-1k of size 1024
>     The buggy address is located 56 bytes inside of
>      freed 1024-byte region [ffff888117ea9800, ffff888117ea9c00)
>     
>     The buggy address belongs to the physical page:
>     page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x117ea8
>     head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>     flags: 0x200000000000040(head|node=0|zone=2)
>     page_type: f5(slab)
>     raw: 0200000000000040 ffff888100042dc0 dead000000000100 dead000000000122
>     raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
>     head: 0200000000000040 ffff888100042dc0 dead000000000100 dead000000000122
>     head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
>     head: 0200000000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
>     head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>     page dumped because: kasan: bad access detected
>     
>     Memory state around the buggy address:
>      ffff888117ea9700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>      ffff888117ea9780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>     >ffff888117ea9800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                             ^
>      ffff888117ea9880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>      ffff888117ea9900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>     ==================================================================
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> 
> ---
>  fs/ocfs2/dlmglue.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 88d946466083..5e05e98fb9cb 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3101,10 +3101,19 @@ static struct ocfs2_lock_res *ocfs2_dlm_next_res(struct ocfs2_lock_res *start,
>  static void *ocfs2_dlm_seq_start(struct seq_file *m, loff_t *pos)
>  {
>  	struct ocfs2_dlm_seq_priv *priv = m->private;
> -	struct ocfs2_lock_res *iter;
> +	struct ocfs2_lock_res *iter = NULL;
> +	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
> +	loff_t n;
>  
>  	spin_lock(&ocfs2_dlm_tracking_lock);
> -	iter = ocfs2_dlm_next_res(&priv->p_iter_res, priv);
> +	list_move(&dummy->l_debug_list,
> +		  &priv->p_dlm_debug->d_lockres_tracking);
> +	for (n = 0; n <= *pos; n++) {
> +		iter = ocfs2_dlm_next_res(dummy, priv);
> +		if (!iter)
> +			break;
> +		list_move(&dummy->l_debug_list, &iter->l_debug_list);
> +	}

seq_read_iter() calls ->start once per read and its buffer is a page, so
reading the whole file with N tracked resources re-enters this loop about
N/R times at increasing *pos, and a single late ->start holds the lock for
that many list_move() calls.

And ocfs2_dlm_tracking_lock is taken on every lock resource create and
destroy. So I'm not sure the lock hold time on it is acceptable.

Thanks,
Joseph

>  	if (iter) {
>  		/* Since lockres' have the lifetime of their container
>  		 * (which can be inodes, ocfs2_supers, etc) we want to
> @@ -3128,12 +3137,12 @@ static void ocfs2_dlm_seq_stop(struct seq_file *m, void *v)
>  static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
>  {
>  	struct ocfs2_dlm_seq_priv *priv = m->private;
> -	struct ocfs2_lock_res *iter = v;
> +	struct ocfs2_lock_res *iter;
>  	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
>  
>  	(*pos)++;
>  	spin_lock(&ocfs2_dlm_tracking_lock);
> -	iter = ocfs2_dlm_next_res(iter, priv);
> +	iter = ocfs2_dlm_next_res(dummy, priv);
>  	list_del_init(&dummy->l_debug_list);
>  	if (iter) {
>  		list_add(&dummy->l_debug_list, &iter->l_debug_list);

