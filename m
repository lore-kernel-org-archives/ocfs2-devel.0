Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A734F7CDC
	for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 12:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893404; cv=none; b=Y9eAqWv4SZT3aqJKNLxR873dIPizrLv4z6BHVtQnIX38d7MZX9t1PFGG2wspLdr0r/DyGhDa03I8IYHlctq+CAyLrHy9MhtjlWmsHNMMdySYnijXTeWupgjodThMFYuGavgCWNPPgPrfoK1h7iya8Ij+oaNV/boKR8cm+W+Mbs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893404; c=relaxed/simple;
	bh=2jQ3Lk03uLc8efN+1fTLINlpRYG6OcgG03EJwmsiuKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FTqoy8RsHORu6TIiw8mjvEHqKy+4R+98D6ezjdaBegDJXVfqQh/4PkCvX8mYil6Mw7hdV/LtO+yxC70EYfSSDHwxsbTkV9cWzuf0rkbwr3aK9to4MB9S961QD+VvUZ8R3i3hiMdFA5Dyfq64ws4GiqVIDnH2lBKCGKFNzm2YeLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eK34HCuj; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eK34HCuj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791893398; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9fJyPw2Ywx4KQqkE4/ifeeXTrWoCYe99XbknPriAskE=;
	b=eK34HCujVpPqLfhmBB91Bn77sHo7Maaaxo+G2pLzTXAaM+8YSrAJibJ/z/wHamDHTr054PVDmhqFwxYZ1VHKIvbD95SGOIk/21dJb4WwVxXwqHpRSK1gsjXFb/GZlZfdSXgFsXeIJ4uG/AsUfU47oyo6OMiC4b69o6CQQB2tIl8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XClj6au_1791893396;
Received: from 30.221.145.80(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XClj6au_1791893396 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 20:09:57 +0800
Message-ID: <f8f5ef83-6f71-43c7-8adf-c1d3adb15e8e@linux.alibaba.com>
Date: Tue, 13 Oct 2026 20:09:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: unlink socket containers before releasing their
 nodes
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 kees@kernel.org, kuba@kernel.org, akpm@linux-foundation.org,
 sunil.mushran@oracle.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0065-v4-f45e5cef38dd587b2cfd@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0065-v4-f45e5cef38dd587b2cfd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/12/26 9:30 AM, Cen Zhang wrote:
> A socket container's node must remain alive while the container is on
> sock_containers. The debugfs formatter reads sc_node under
> o2net_debug_lock without taking a node reference, but sc_kref_release()
> drops the node reference and clears sc_node before taking that lock to
> unlink the container.
> 
> With CONFIG_DEBUG_FS enabled, removing a disconnected remote node while
> a synchronous sender releases its last socket-container reference can
> expose the freed node to a debugfs reader. The following order is possible:
> 
> 1. o2net_send_message_vec() holds a reference acquired under nn_lock.
>    o2net_disconnect_node() detaches the connection and flushes o2net_wq,
>    draining the socket callbacks and workers. The synchronous sender's
>    reference survives because its caller runs outside that workqueue.
> 2. The sender's final sc_put() enters sc_kref_release() and calls
>    o2nm_undepend_item(). Configfs rmdir can now pass the dependency check,
>    call o2nm_node_group_drop_item(), and drop its node item references.
>    Its disconnect flush does not wait for the sender's release.
> 3. The sender calls o2nm_node_put(), freeing the node while the container
>    is still listed and sc_node has not yet been cleared.
> 4. Before the sender clears sc_node or unlinks the container, a debugfs
>    reader selects it in sc_seq_show() under o2net_debug_lock and formats
>    sc_node->nd_name, reading the freed allocation.
> 

Better to change the patch title to "ocfs2/cluster: xxx"

Please describe the race in a sequence diagram.

> Move o2net_debug_del_sc() before o2nm_node_put(). Unlinking under the
> existing debug lock waits for an active formatter to finish and prevents
> later readers from selecting the container. The retained node reference
> therefore covers every debugfs node access, including the node number
> read by the stats formatter. The lock is released before the node put.
> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in string+0x42b/0x470
>     Read of size 1 at addr ffff88810f56fc90 by task python3/506
> 
>     CPU: 0 UID: 0 PID: 506 Comm: python3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      kasan_report+0xe0/0x110
>      string+0x42b/0x470
>      vsnprintf+0x330/0x1110
>      seq_printf+0x1a8/0x260
>      sc_seq_show+0x604/0x9f0
>      seq_read_iter+0x480/0x1110
>      seq_read+0x362/0x5a0
>      full_proxy_read+0x11f/0x180
>      vfs_read+0x1a0/0xc20
>      ksys_read+0x111/0x200
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> (User register dump omitted.)
> 
>      </TASK>
> 
>     Allocated by task 497:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_kmalloc+0xaa/0xb0
>      __kmalloc_cache_noprof+0x28d/0x610
>      o2nm_node_group_make_item+0xea/0x1a0
>      configfs_mkdir+0x762/0xca0
>      vfs_mkdir+0x399/0x7e0
>      filename_mkdirat+0x129/0x450
>      __x64_sys_mkdir+0x70/0xa0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
>     Freed by task 505:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      kfree+0x308/0x580
>      config_item_cleanup+0x14b/0x230
>      config_item_put+0x79/0x90
>      sc_put+0x454/0x6e0
>      o2net_send_message_vec+0x63d/0x1560
>      o2net_send_message+0xa6/0xe0
>      validation_send_write+0x17f/0x1d0
>      full_proxy_write+0x11f/0x180
>      vfs_write+0x25a/0x1010
>      ksys_write+0x111/0x200
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
>     The buggy address belongs to the object at ffff88810f56fc00
>      which belongs to the cache kmalloc-512 of size 512
>     The buggy address is located 144 bytes inside of
>      freed 512-byte region [ffff88810f56fc00, ffff88810f56fe00)
> 
> (Page and shadow-memory dumps omitted.)
> 
> Fixes: 2309e9e040fe ("ocfs2/net: Add debug interface to o2net")
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> Assisted-by: LLM
> 
> ---
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 8b3830b601ba..213ee7392712 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -399,11 +399,13 @@ static void sc_kref_release(struct kref *kref)
>  	}
>  
>  	o2nm_undepend_item(&sc->sc_node->nd_item);
> -	o2nm_node_put(sc->sc_node);
> -	sc->sc_node = NULL;
>  
> +	/* Keep the node alive until debugfs readers finish. */
>  	o2net_debug_del_sc(sc);
>  
> +	o2nm_node_put(sc->sc_node);
> +	sc->sc_node = NULL;
> +
>  	if (sc->sc_page)
>  		__free_page(sc->sc_page);
>  	kfree(sc);

It seems 'sc->sc_sock' also has the same risk.
So a smaller fix may be:

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 8b3830b601ba..0eaf2c4a6989 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -393,6 +393,9 @@ static void sc_kref_release(struct kref *kref)
 
 	sclog(sc, "releasing\n");
 
+	/* Unlink before freeing anything the debugfs readers dereference. */
+	o2net_debug_del_sc(sc);
+
 	if (sc->sc_sock) {
 		sock_release(sc->sc_sock);
 		sc->sc_sock = NULL;
@@ -402,8 +405,6 @@ static void sc_kref_release(struct kref *kref)
 	o2nm_node_put(sc->sc_node);
 	sc->sc_node = NULL;
 
-	o2net_debug_del_sc(sc);
-
 	if (sc->sc_page)
 		__free_page(sc->sc_page);
 	kfree(sc);

Thanks,
Joseph
