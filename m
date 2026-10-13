Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE5351C066
	for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791905698; cv=none; b=NXdybxnVn00HhbADw81E10FN7bM78xfkpvSlKzFoyu6puDnYaxB4Zg+hhfcz2pWkjt1jyUy6YlNaHiHEvKrfW6Sp4RDeFQpN33rhJDTYekGD+bxfXm16hGasuWiNlqfpar2inGlHlJRKd8dqH9pk7u2HheCG9ftuYHZp0K2zZTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791905698; c=relaxed/simple;
	bh=lVJOC/FYp4c3uHv3i2liXpqxhGRtj5Kn8cF1QeipUhw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=MY/iUMhR+duzWjN3sry8ZKxiBzEGhfglAIeZvzqWmPOJWE5W28gFOOBWqHQ0Qk9Vygm+Y6jcrLtsyYmPaus+PKxGH1ERTZlwUXRK1Qb/axosw63363TiZH3dGLyDeKNnDlq6J+pForcSZ+7CXRLick6+HAXCkj8T+VNJXQPzWSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NWPOW4iZ; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NWPOW4iZ"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so1601688a91.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 08:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791905696; x=1792510496; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wg4geerFJfiuJ5MOuNFrljlttZsaUb/x67J00uVa2b0=;
        b=NWPOW4iZpGGMlBVn7oIikfmIk35DS3qSAIImTmt+RzXafueLUGIWQiMTqdB5+507Oc
         B1dNxZ7IwrY8GsZFiB+qUVunP19niVJrQJ0jmvifpqXE+h1E6l/KFk9P/WL1roa1dS0L
         wWFYdFFVBQQfRP9PDFYtiquqV7aq4DJ7QxUvXgFSyuGzZM2Z7Uk/1BHhVvoHKWSB7Jpu
         O2JO7ZUtQ9xee2JVPDjMseurbT65ViCb/PNwC44/d5xm/EqcM3bFKsyk01olkiWxm69r
         t7Ss30gZUPXkzJKLS/ssKuE9PszD/97s+OgJVwkzHXgVUJeIyDhuH+AjaF2AVxZH/vcq
         GD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791905696; x=1792510496;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wg4geerFJfiuJ5MOuNFrljlttZsaUb/x67J00uVa2b0=;
        b=g6XxLLnJ651NoKV6ymuLRW35i6ZDzfkqbB4xnwhVIsuvnNW/CfTDYqn9x2EzV58P32
         IRfJPbFzKuX4m7ODbIHvg0VVQNkZcrcAiyLE92cFbNWbNXfZhuxRq/pBe9QP2QmAmR+e
         1zbaJsATIYZ2r6UjnNjM/iVTVfjkV3IXRqJM9wvyrkTWyu/YiQkY5vZ8iZjvyLGkeMJi
         ghzfKcoRz9IfZtZFBUh7xqRVMHGgDbjqkyiDNv0YRCP8guBHUG/302RKCc6MmVtz2Qxv
         XYKPHCnKhIcbWb+BtX0SbEVhWBmmRhIDZfs6XY7vAbeEGwn7ux+SX2J0JgZO0iQoI3eH
         6b3A==
X-Gm-Message-State: AFq9FYJPc+0fLwkJJ56J7xfX9y75c4pQnXCQw+2nJd+UL+Kv61Disq3O
	YvG4+u9oInsfrzUXOp5C7QJuWeo8mS07WVlt19WdigIyzdlfqNEo0+d7
X-Gm-Gg: AYBFou0UkCm4DVGXYJqDYH30TUEDAYtXjt8VHA4lWrhzOfshp7WBDtnwCuhXbQGIFLM
	DuRwicdiK5M4iLpbzPDc6L67y93U4nGOkVat0vC3D8E9TwqAE+ZwWr7zOsoq3QmHnPUkkq+Sruz
	/Mmr0+YUWA1kX0DxJZlBIhXgs3/aWryZKE550bxGqupUJPJzzb9kZpVxzf0izndM3FsfeC7j4W+
	/qPtaiVfpBTpMNqaDr7DtLHz3zxvBucyyry4SCgXSQZgkdk0x+1pNuheF+1G/0ytTbYb1LOs3Ny
	evNEknzjrXMV150cSYkwzFNONjqEpLl0i+SNw9xNv/rkV8WFA0BJWgbqOcRksTsqMXpQIlDcvf+
	AYIfnK7AkFRuTLbWtCkFWNqMLxVRJOhzZJAnA7Da/92iB0tjI8FE9o0YIs6Nw5EbcPah8FOt7k+
	ToAxSUyNTAv+ILxlj/5maNxrFknTdnLxiBehhW7/7jH50hbzgekTy7gsttLK0jDKyzqg==
X-Received: by 2002:a17:90b:5343:b0:39e:4c81:6c5f with SMTP id 98e67ed59e1d1-3ab3a953758mr9791442a91.26.1791905695917;
        Tue, 13 Oct 2026 08:34:55 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f24af99sm88312a91.8.2026.10.13.08.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 08:34:55 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	kees@kernel.org,
	zzzccc427@gmail.com,
	akpm@linux-foundation.org,
	kuba@kernel.org,
	sunil.mushran@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: [PATCH v2] ocfs2/cluster: unlink socket containers before releasing resources
Date: Tue, 13 Oct 2026 23:34:46 +0800
Message-Id: <pm-ocfs2-objects-candidate-0065-v6-3090153fd7cacb810214@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A socket container's node and socket must remain alive while the
container is on sock_containers. The debugfs formatter reads sc_node
and sc_sock under o2net_debug_lock without taking their references, but
sc_kref_release() releases both before taking that lock to unlink the
container.

With CONFIG_DEBUG_FS enabled, a synchronous sender can retain its last
socket-container reference after o2net_disconnect_node() has detached
the connection and flushed o2net_wq. The caller runs outside that
workqueue. After the sender removes its configfs dependency, node
removal can proceed without waiting for the sender's final sc_put():

  Sender (final sc_put)    Configfs rmdir        Debugfs reader
  --------------------    --------------        --------------
  o2nm_undepend_item()
                          Drop node item refs
  o2nm_node_put()
    [node can be freed]
                                               sc_seq_show()
                                                 Lock debug lock
                                                 Read sc_node->nd_name
                                                 Unlock debug lock
  sc_node = NULL
  o2net_debug_del_sc()

The earlier socket release has a similar window. The container is
still selectable while its socket has been released and sc_sock has
not yet been cleared:

  Sender (final sc_put)                       Debugfs reader
  --------------------                       --------------
  sock_release(sc->sc_sock)
    [socket can be freed]
                                             sc_seq_show()
                                               Lock debug lock
                                               Read sc_sock->sk fields
                                               Unlock debug lock
  sc_sock = NULL
  ...
  o2net_debug_del_sc()

Move o2net_debug_del_sc() before releasing either resource. Unlinking
under the existing debug lock waits for an active formatter to finish
and prevents later readers from selecting the container. This covers
both socket fields and node fields, including nd_num in the stats
formatter. Release the debug lock before the existing resource cleanup.

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM

---
Changes in v2:
- Move o2net_debug_del_sc() before socket and node cleanup, as Joseph
  suggested.
- Use the ocfs2/cluster title prefix and describe the races with sequence
  diagrams.
- Add Cc: stable@vger.kernel.org.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0065-v4-f45e5cef38dd587b2cfd@gmail.com

 fs/ocfs2/cluster/tcp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 8b3830b601ba6e5fe964bec970581b8e4ddbb5dd..0eaf2c4a6989ecad00f7a88a66a782b334647f21 100644
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
