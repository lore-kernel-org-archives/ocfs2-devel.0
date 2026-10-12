Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C514A6FC5
	for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 01:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791768660; cv=none; b=pTv8t1djvPeO9F5A7PAXTCAQ0wWcP96BxxDofa5RKuouUAhMQKGpuCKSrzMw4k8/L5tioe5NvYTjoo8C7HD4YEuWfpvoW06snSDyA0joNHYujDc/ZAeonBnwGDJ0c7HVDdW/VeA99fpgjntzFqfwxjk1lZuNCwUvHYen61ijwfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791768660; c=relaxed/simple;
	bh=ArR97m8D16AXE//u0j5nywcxS6/CuXhTCrTp7w6X+Ro=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=gfzZokLj18jODvepEwB5/Qg0tDMEYjeqCLK5uBCpem6xV1m6enjCN8HeAAHDkxnkO0Uqc7PEF6bwRk2rkgSGRjtdRCqTGcU9ucE6ASjbk1agSmLLlVSM10dZeOYIgc6VKxaEQMndV5fRBRl8dpERSSRpluYnkjsKMgP1CuiaRKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DZWqnc1p; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZWqnc1p"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-398b3c37877so600521a91.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 11 Oct 2026 18:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791768659; x=1792373459; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B43i57rnmc2Wd8OU+i3F2zcXd+ji9FE6Nhhq13anv/A=;
        b=DZWqnc1pmI6pWdWg66IXV8l9JVunGKQmygjEFQ1M8giJLBmc2v6qqhrXDBtLGRKixp
         0XoV1i096qXKl4v91rLiPBGImNinWbPyzaWHruCmSpxQxldJgZAQsXmNGvdBFzok1La2
         gg8ruQwp+cJ6ZsRucl5Y0FgC8TKBGjQKCvCSHTGsLMdoQCAxINb1z9mKsCapQbuykmIf
         XE3QCqx/Wkc5QxZV1uZKIDnyYTbKnk6mIV1Mqii1YwcYdO7MbiGza6wGnRFZs41R3Da4
         1Itr5N8mplNJ8JIOxTwuF9tHR/DSVOk9s9jRRG4HaYCEXzSYjK/yx1hd2jcX1TMYXf0Y
         rsPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791768659; x=1792373459;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B43i57rnmc2Wd8OU+i3F2zcXd+ji9FE6Nhhq13anv/A=;
        b=oaS93gFi6wp0a1uc8Ejz7rho9fbshAhCmLqxvSokUvcR5y+i+16+jO6nNW9ss8yYwo
         8g5qTpOD1p3HLw+re3jWC4R3Gmmne0FsDLMQYCaSZKkUjSNqxN/ThVbktjCyysci/G/t
         xzy+wJv07TkEdkTI1zEX5NMStAetdzheU5s+kWh4+YsA4YN4YyKOJoFI75Ql31rKiSkm
         SAJi91i3acLkPEkESzyUv6Ba5weKWZLoFMkgj+eMVddjLCvbMJDFGKb5rfK+5PgnK49+
         CacpsJsuvr6GP2+mWoYVTXsGgdy/5/3tQYy4sz2dddDt4yaHDXiFrbg+qA9mlMAgXxy7
         Pwjg==
X-Gm-Message-State: AFq9FYImIDBnyBY0ZqXfL+ZtPSkZC9gAvrv6/OqPB6b3HahI3cP16ql3
	kBDDfjuAq/aibp37MDPmqZQI8QtVk6rem6MxJrl3JCJXh+7TMGZwpIFp
X-Gm-Gg: AYBFou0NzlwXq6UUpjJb7uJy6eu3kU7H7kDxDRMP6e8vax7h+3HXfxgE47SNmrwXUlA
	MXWk5Uf8PQKTsMmYAFrCm/vfTiR2E6ohblDptAV5iUZOu+051P8VLRrx1LjsdYhEYq7+gzyA40i
	EvRVNIAlewt/Ri8+TZS+fimB4nM7h93UKK20FFoz2H3nSeOmWEw1B3tzOYxqUu8Y9C6cC+Fa1Nr
	v4hxaXkRnHGJINQl1xpmzIrDThKy/EwCxe3IO/Muz2M93i5cCi4q60Tkd0dNHw9+/ZUiB75ezeC
	P66GntuaLDP5UvuHztk95h7clDeTACStAhyvZ/TO8thf6XhI3p/miT24pno4KbvdmXFfRQVgjhe
	mc2v6uAgFld7a7x+HsUL+djWJN/OaNsH7RN7yVmkO4Oq41CwvyZmfkvv9Ht6CovCczDGRs6vf58
	OqJ106+X0OemWza5AtWzUWFCdlxS3XJqd4XyyDR+LmhX8lLj0Xbj2+htjaemM6swGP/A==
X-Received: by 2002:a17:90b:2d06:b0:3a4:b8dd:1447 with SMTP id 98e67ed59e1d1-3ab3ac9fb08mr6003665a91.34.1791768659000;
        Sun, 11 Oct 2026 18:30:59 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36fdc75esm14391326a91.12.2026.10.11.18.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 18:30:58 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	kees@kernel.org,
	kuba@kernel.org,
	zzzccc427@gmail.com,
	akpm@linux-foundation.org,
	sunil.mushran@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: [PATCH] ocfs2: unlink socket containers before releasing their nodes
Date: Mon, 12 Oct 2026 09:30:53 +0800
Message-Id: <pm-ocfs2-objects-candidate-0065-v4-f45e5cef38dd587b2cfd@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A socket container's node must remain alive while the container is on
sock_containers. The debugfs formatter reads sc_node under
o2net_debug_lock without taking a node reference, but sc_kref_release()
drops the node reference and clears sc_node before taking that lock to
unlink the container.

With CONFIG_DEBUG_FS enabled, removing a disconnected remote node while
a synchronous sender releases its last socket-container reference can
expose the freed node to a debugfs reader. The following order is possible:

1. o2net_send_message_vec() holds a reference acquired under nn_lock.
   o2net_disconnect_node() detaches the connection and flushes o2net_wq,
   draining the socket callbacks and workers. The synchronous sender's
   reference survives because its caller runs outside that workqueue.
2. The sender's final sc_put() enters sc_kref_release() and calls
   o2nm_undepend_item(). Configfs rmdir can now pass the dependency check,
   call o2nm_node_group_drop_item(), and drop its node item references.
   Its disconnect flush does not wait for the sender's release.
3. The sender calls o2nm_node_put(), freeing the node while the container
   is still listed and sc_node has not yet been cleared.
4. Before the sender clears sc_node or unlinks the container, a debugfs
   reader selects it in sc_seq_show() under o2net_debug_lock and formats
   sc_node->nd_name, reading the freed allocation.

Move o2net_debug_del_sc() before o2nm_node_put(). Unlinking under the
existing debug lock waits for an active formatter to finish and prevents
later readers from selecting the container. The retained node reference
therefore covers every debugfs node access, including the node number
read by the stats formatter. The lock is released before the node put.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in string+0x42b/0x470
    Read of size 1 at addr ffff88810f56fc90 by task python3/506

    CPU: 0 UID: 0 PID: 506 Comm: python3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     kasan_report+0xe0/0x110
     string+0x42b/0x470
     vsnprintf+0x330/0x1110
     seq_printf+0x1a8/0x260
     sc_seq_show+0x604/0x9f0
     seq_read_iter+0x480/0x1110
     seq_read+0x362/0x5a0
     full_proxy_read+0x11f/0x180
     vfs_read+0x1a0/0xc20
     ksys_read+0x111/0x200
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

(User register dump omitted.)

     </TASK>

    Allocated by task 497:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     o2nm_node_group_make_item+0xea/0x1a0
     configfs_mkdir+0x762/0xca0
     vfs_mkdir+0x399/0x7e0
     filename_mkdirat+0x129/0x450
     __x64_sys_mkdir+0x70/0xa0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 505:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     config_item_cleanup+0x14b/0x230
     config_item_put+0x79/0x90
     sc_put+0x454/0x6e0
     o2net_send_message_vec+0x63d/0x1560
     o2net_send_message+0xa6/0xe0
     validation_send_write+0x17f/0x1d0
     full_proxy_write+0x11f/0x180
     vfs_write+0x25a/0x1010
     ksys_write+0x111/0x200
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff88810f56fc00
     which belongs to the cache kmalloc-512 of size 512
    The buggy address is located 144 bytes inside of
     freed 512-byte region [ffff88810f56fc00, ffff88810f56fe00)

(Page and shadow-memory dumps omitted.)

Fixes: 2309e9e040fe ("ocfs2/net: Add debug interface to o2net")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM

---
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 8b3830b601ba..213ee7392712 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -399,11 +399,13 @@ static void sc_kref_release(struct kref *kref)
 	}
 
 	o2nm_undepend_item(&sc->sc_node->nd_item);
-	o2nm_node_put(sc->sc_node);
-	sc->sc_node = NULL;
 
+	/* Keep the node alive until debugfs readers finish. */
 	o2net_debug_del_sc(sc);
 
+	o2nm_node_put(sc->sc_node);
+	sc->sc_node = NULL;
+
 	if (sc->sc_page)
 		__free_page(sc->sc_page);
 	kfree(sc);
