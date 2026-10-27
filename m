Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069612;
	b=HqPbM7ahUAGWscBA/roWbNKWBRiOQmcBEePUOApcr2ZGDeF5qDM+lr+z/xn7f9vC3xg5
	 9JMKDKDa1W9siH1Kx9Vu2LVf85Puiu8pS7yV4luEjWBmE6zmLhH7xMZZB0q/1Ct4iGnOO
	 jIFgHSy8TQFoXeTDqcr12rIaOlboj3WCUGQFqB+gCEKtghNq/5JynGbbN2fqzHnqiL8Ao
	 hmV0MDfCpP3nHTWYsOYCaG302w1pZXDCApLTM1HXJ+wka8lkIkKIRB+/4z/1b8zVM+5yl
	 Sx4cLkuF9NlUCYPWIB7AnQh5x0WzTP1OpVWybesHZkaCI+q1MflXRTSslhJww0ji22g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069612;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eANz6TxlfIefza3dEAFXrv5EtYoHJKoB5jG0laNfxhM=;
	b=ThBaVOtu3mGc+ck5zBzO1NdH5InywoOgOofoeDBylach+KjoFRU9elTpAr3qVsRcZC89
	 DNoAhwXQj/bIqaHFRU5MR8T0MUzcTpp/qwtJAtfl687uGSTSQDmIvEyN+mJ4N+RxbN8rA
	 PVe2Bfq1mFY2JogZRuJRQqTfhaa9ShkLDOr08yMKTn2z/4WREJrpLOnylsE/6kve1CzzQ
	 p2Wief9Ml7wq9PAWIsg71180nlifZ/Z1AB3pfswC50dXxWTp8qqj3shxYh+pVTq4AJR6s
	 7myLCSNBjkZP8Hc1SmTshXAklke2QdinRkumF60fQOAkhlrjbvHvZG74LxAdsMRp8wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="P/so+O48";
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B162606A31A
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Oct 2026 02:53:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B162606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P/so+O48
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ea0efd636dso29090465ad.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 19:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793069612; x=1793674412; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eANz6TxlfIefza3dEAFXrv5EtYoHJKoB5jG0laNfxhM=;
        b=P/so+O48+1Rdcpqk1LuDq+UeK7Ove2YW/KEpXg9k6o60Hljs6BWQldxYZCexjHHQl9
         79Iay2fRHCLuWfABb/IACfMsSiKvabOtki68TmUXij5zitoDGUyUii5JskRWeZC1D+9j
         sA2y4d5DUGkRO6FCcJFRhZCOWGTZWrAyL5vrsbxSY63BEZtvcAnpqQXEsgXLzeWFZs0C
         db9rHtYJIXm+JYvc2GDlm5oeIhedTF6Ci6nU69ak0Z+VednutZh6OG+HTL3W0O4bVlSW
         yON3oIYvY/Uzc6P2gqC5gvSvrHU83Sk+7u+JiKREx4T/dAo6h5Niu1YWBo2T1be4r4iU
         M1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069612; x=1793674412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eANz6TxlfIefza3dEAFXrv5EtYoHJKoB5jG0laNfxhM=;
        b=mnWZ8dZrFFkHthizoFLwMt0n1d0r+nmvbmFVbQg57bWfmgZqSt0JT6rKbXRCGpXQ6M
         hdMvR8ZUq4apG6rKPzYVC4qvymyfXneF1VNDFW7ouWA9MBm7pOeZl600JD+aTrFss7LR
         floHwddb3xzRuDteDhC/bzfIMnhuh73jt/x7J6alvye1/NncCkwPZUvyjRJN/BRgUH8C
         P+xrO2NMm+5GdWludrfDct8PQDCxMHdvshxMep1ikrk6dX2Qv/TbBptt/drqzW8IEcM1
         2JVPnAoULAZga/65onpxMuA66RejO6wPgt7Z6iytwH23MkRqYC9KH/U0mOOuFXMY5kx/
         ltsg==
X-Forwarded-Encrypted: i=1; AKwUvByZsm28UZaqZKIAPs9byrApBbGioqSzhqMqpWeZ/1I6KYUxMlm6yfkfiNN4hqAmQmJ/NKD/Tn5WrlICJQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYKN6g1pdtb7jkt30iHBrEpPxVvvzAE0Ailvn+75/5IgcIlj8Bb9
	DryOyWiPtqNSxvbOBQo/408pLUbd7bTlWGmM7O0s8pIkSdynHCbv3x73
X-Gm-Gg: AYBFou21/AVBM6FPALfTDW/RRpjSshig0gPPllO1umv3nlFE3ufJ+j9gKrbd9nnU/JE
	GOqZTpk16b1SExHGlQcpAde8/H8szovEbudc94inoGIKZL3W6F64lRfqJur9gQ172W/vCtmS2cj
	2fDXARUCEhZOxMdnZoG1LlSMH8VKQu+0WorFR06v2m986Dm9N92DhCRLrD5pkfWUH607eTpr67S
	TQc3z6ZOU3pV1aLJ/SGYuPBCutteZKnUuhhq2XqfnefszT+73+4seq3aT7n6RjUFbUEP9UrcSIS
	pOBKUppquh7UCg/lQ8sMC19vPqBXnBpmrtiIV8wY1/yTqPHXdcs5tQn5qvfUc98CFb2mXrsGfT+
	iVNUco5dKIDkghYmsGk/lKOFvPX6sEjRZupZU6/ibVRa6nSqweA+MBJWQvvDSxSsWO45rA77zZj
	/7yWmHZaFb3tO8vBatNRpaJ7zkZuBv0IMYnUTEuJtwnaKZomMqtET0jcsv8a/W8TTIKCOnV2XPw
	ffv9w2fhjhdnJial1D9tY8Do/KEcNL3C06sHT2bEwgOQkVAvBY=
X-Received: by 2002:a17:902:db07:b0:2e5:a355:56d8 with SMTP id d9443c01a7336-2ea9c87704dmr79704695ad.42.1793069611711;
        Mon, 26 Oct 2026 19:53:31 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6c8f24esm2216125ad.57.2026.10.26.19.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 19:53:31 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] ocfs2/cluster: cancel peer work synchronously on listener shutdown
Date: Tue, 27 Oct 2026 10:53:24 +0800
Message-Id: <pm-ocfs2-objects-candidate-0090-v6-127847d463212a41b773@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Listener shutdown must cancel delayed peer work before destroying the
o2net workqueue. destroy_workqueue() drains the work that is queued,
but delayed work whose timer has not expired is invisible to it and is
queued onto the freed workqueue when the timer fires.

o2net_stop_listening() currently only disconnects peers that can still
be found in the node table, and o2net_disconnect_node() cancels the
delayed work without waiting for a running instance. Two paths leave
armed timers behind.

Node removal disconnects a peer before taking it out of the table. A
heartbeat-up callback sees the persistent error and rearms the connect
and expiry work in between, and the listener shutdown then skips the
peer because it is no longer in the table:

  Peer removal                       Heartbeat / listener shutdown
  ------------                       -----------------------------
  disconnect peer; cancel work
                                     heartbeat-up: rearm delayed work
  remove peer from node table
                                     stop listener
                                       synchronize heartbeat callbacks
                                       skip peer absent from node table
                                       destroy o2net workqueue
                                     delayed-work timer expires
                                       queue on freed workqueue

For a peer that is still in the table, o2net_connect_expired() may be
running while o2net_disconnect_node() cancels: once the disconnect
drops nn_lock, the expiry handler requeues itself and the connect work,
and the flush does not wait for those timers either.

Cancel the connect-expiry, connect and still-up work synchronously for
every peer slot after the disconnect. Expiry can queue connect work, so
cancel it first. Heartbeat callbacks are already disabled and drained
at this point, a removed peer cannot hold a socket container because
that pins the configfs item, and connect work for a removed peer stops
once its node lookup fails, so nothing rearms after the cancellations.

KASAN report, only the relevant frames are kept:

BUG: KASAN: slab-use-after-free in __queue_work+0x1189/0x1600
Read of size 4 at addr ffff8881169069c0 by task swapper/2/0

Call Trace:
 <IRQ>
 __queue_work+0x1189/0x1600
 call_timer_fn+0x176/0x540
 </IRQ>

Allocated by task 486:
 __kmalloc_noprof+0x2de/0x780
 __alloc_workqueue+0x61/0x17a0
 alloc_workqueue_noprof+0xcc/0x130
 o2net_start_listening+0x139/0x7c0
 o2nm_node_local_store+0x4c0/0x810
 configfs_write_iter+0x2f9/0x4f0
 vfs_write+0x639/0x1010
 ksys_write+0x111/0x200

Freed by task 485:
 kfree+0x308/0x580
 rcu_core+0x6be/0x1ed0

Last potentially related work creation:
 __call_rcu_common.constprop.0+0x80/0x280
 pwq_release_workfn+0x740/0xe10

The buggy address belongs to the object at ffff888116906800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 448 bytes inside of
 freed 1024-byte region [ffff888116906800, ffff888116906c00)

Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/cluster/tcp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 8b3830b601ba..b0cafda827bc 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -2200,10 +2200,24 @@ void o2net_stop_listening(struct o2nm_node *node)
 
 	for (i = 0; i < ARRAY_SIZE(o2net_nodes); i++) {
 		struct o2nm_node *node = o2nm_get_node_by_num(i);
+		struct o2net_node *nn = o2net_nn_from_num(i);
+
 		if (node) {
 			o2net_disconnect_node(node);
 			o2nm_node_put(node);
 		}
+
+		/*
+		 * Delayed work can be rearmed after a disconnect: a heartbeat
+		 * callback requeues it for a node that was disconnected but
+		 * not yet removed, and a running expiry handler requeues
+		 * itself and the connect work. Work waiting on its timer is
+		 * invisible to the flush below, so cancel it synchronously.
+		 * Expiry can queue connect work, so cancel it first.
+		 */
+		cancel_delayed_work_sync(&nn->nn_connect_expired);
+		cancel_delayed_work_sync(&nn->nn_connect_work);
+		cancel_delayed_work_sync(&nn->nn_still_up);
 	}
 
 	/* finish all work and tear down the work queue */
