Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73A82116F4
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 02:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791944285; cv=none; b=CwgUA7ItI0a/GCE+vtdg4PRsxkj5ov/mPVQ4N/MWF4bTv8AJYBcapt/B7jqd9XAo+0XBa4BPnv+wfbZa1zdvWKZ+1WIuplbJZYzJKj/O472ZDc8Ix46dj2ofhFI0BLR4M4c3+B1vGLdJ2zldTU/BZaWVqU1DUBnMQrP0y8RP2UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791944285; c=relaxed/simple;
	bh=8y7kbFSPmEfWBdmvwES7r3eW+SXkBysWlXDi0fzAs9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iQmwmiznRuajIBaU1oHMGCv5L3NlLvTD07Zbtu92/bz802TaoFPXzhESzXOUzicKfUC/dClvheGuK/jORjN/fd1UNT7iVbGQfOXgQ4cxHCnbYgZ8V20LbNiwGjcOaoBz4UvG/lQ/yoS2O1pvYSIammy8gLpzzstq5YtPu+g2EaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eF/pr/5L; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eF/pr/5L"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791944279; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XuQDjmn6Lnuo5HOpYgjYT2P+oYUujNQVUriwXbnoduA=;
	b=eF/pr/5LIQ++3TUki7kDCfFTESPh7/MT1+ib7UHuN8o2e7UfSkiLNesfI1MFAWMCfX/EiV4h9BEIkG5L2lGK5BFf/z07OaMj42YL3TZTEiVhsskHSwifuTgiYcKa1NWs+iZ74heQVPp1iM6rxv8EoKCmYjjzRarmAiXwIVg71bo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XCnclMF_1791944278;
Received: from 30.221.146.92(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCnclMF_1791944278 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 10:17:58 +0800
Message-ID: <ff8d866d-f318-4722-a1ab-88db7a3fde63@linux.alibaba.com>
Date: Wed, 14 Oct 2026 10:17:57 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2/cluster: unlink socket containers before
 releasing resources
To: Cen Zhang <zzzccc427@gmail.com>, akpm@linux-foundation.org
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 kees@kernel.org, kuba@kernel.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0065-v6-3090153fd7cacb810214@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0065-v6-3090153fd7cacb810214@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/13/26 11:34 PM, Cen Zhang wrote:
> A socket container's node and socket must remain alive while the
> container is on sock_containers. The debugfs formatter reads sc_node
> and sc_sock under o2net_debug_lock without taking their references, but
> sc_kref_release() releases both before taking that lock to unlink the
> container.
> 
> With CONFIG_DEBUG_FS enabled, a synchronous sender can retain its last
> socket-container reference after o2net_disconnect_node() has detached
> the connection and flushed o2net_wq. The caller runs outside that
> workqueue. After the sender removes its configfs dependency, node
> removal can proceed without waiting for the sender's final sc_put():
> 
>   Sender (final sc_put)    Configfs rmdir        Debugfs reader
>   --------------------    --------------        --------------
>   o2nm_undepend_item()
>                           Drop node item refs
>   o2nm_node_put()
>     [node can be freed]
>                                                sc_seq_show()
>                                                  Lock debug lock
>                                                  Read sc_node->nd_name
>                                                  Unlock debug lock
>   sc_node = NULL
>   o2net_debug_del_sc()
> 
> The earlier socket release has a similar window. The container is
> still selectable while its socket has been released and sc_sock has
> not yet been cleared:
> 
>   Sender (final sc_put)                       Debugfs reader
>   --------------------                       --------------
>   sock_release(sc->sc_sock)
>     [socket can be freed]
>                                              sc_seq_show()
>                                                Lock debug lock
>                                                Read sc_sock->sk fields
>                                                Unlock debug lock
>   sc_sock = NULL
>   ...
>   o2net_debug_del_sc()
> 
> Move o2net_debug_del_sc() before releasing either resource. Unlinking
> under the existing debug lock waits for an active formatter to finish
> and prevents later readers from selecting the container. This covers
> both socket fields and node fields, including nd_num in the stats
> formatter. Release the debug lock before the existing resource cleanup.

sc_kref_release() never holds o2net_debug_lock, the lock is taken and
dropped inside the helper o2net_debug_del_sc().

So better to:

s/ Release the debug lock before the existing resource cleanup.//

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
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

The change looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Assisted-by: LLM
> 
> ---
> Changes in v2:
> - Move o2net_debug_del_sc() before socket and node cleanup, as Joseph
>   suggested.
> - Use the ocfs2/cluster title prefix and describe the races with sequence
>   diagrams.
> - Add Cc: stable@vger.kernel.org.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0065-v4-f45e5cef38dd587b2cfd@gmail.com
> 
>  fs/ocfs2/cluster/tcp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 8b3830b601ba6e5fe964bec970581b8e4ddbb5dd..0eaf2c4a6989ecad00f7a88a66a782b334647f21 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -393,6 +393,9 @@ static void sc_kref_release(struct kref *kref)
>  
>  	sclog(sc, "releasing\n");
>  
> +	/* Unlink before freeing anything the debugfs readers dereference. */
> +	o2net_debug_del_sc(sc);
> +
>  	if (sc->sc_sock) {
>  		sock_release(sc->sc_sock);
>  		sc->sc_sock = NULL;
> @@ -402,8 +405,6 @@ static void sc_kref_release(struct kref *kref)
>  	o2nm_node_put(sc->sc_node);
>  	sc->sc_node = NULL;
>  
> -	o2net_debug_del_sc(sc);
> -
>  	if (sc->sc_page)
>  		__free_page(sc->sc_page);
>  	kfree(sc);

