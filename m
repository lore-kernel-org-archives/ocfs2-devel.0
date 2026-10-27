Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793075515;
	b=E9pt/L1fMdgWAN0dDMalbJOhhFznkiPaTlU847xG7GqbUY/B8DfG7LjNI4Pji+W0mdGE
	 pMt0PYWMUPO59nUD97n9bvU5tE4C8Zv+DVvX1rbqg/KFUBTD2tN69UQneeGspRmoS3tH7
	 QUc7DyfVNHK75TXmyUPkl/kRghi8mA7bOwRd8Y5ExJ3uxoXu2LnM3yr4VP0oVMJA2+PZt
	 opXE/KFzjPqu6T6B3Qe6xy4MA8XyTtPAXQWI5HwT6kmeo8JvWwV/1b+IvqJil5KNm3qzA
	 l76N+MSksOhF2PWWC9xehBuI+9SsD8XzNVsJAXrszGrH3PeMHhtJLTEKMPMtYOTG49A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793075515;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9XcXpTHmLfHB2Be+0WH2R/6aY5PlfN5yRc5K8VlYOZ4=;
	b=oZntIdcRCfamz9cKAwNiAkl2W4H2F/h8zIpn4vAz9TAnpVLB5LviFeNgjgSoQ2Xi1DX1
	 v3pNO5i88qAQXS/WaNKC9vy0TTclbTVi/WEQMITS/mA5QXslEk/y9WFdAtLewRuzLvvqB
	 H1UrzBwRu+FdvIu/cYnKA3+IcemDnDuySdp+cOpLWSH+9SWIzEM5zfctkCyvN2517KElo
	 V9Cb149HMiu5Y3XrrjRUMqo7lqC60Z/WjgIv0G8SY2LTBG7eGvWY7G+J1BvTNSwc2MPi9
	 yQsxAu7OqFmikNF6OgVYRVA8oi8O8vh6ExanMivdYueZW0/3NZ2Al/EFglUFfUWqzLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SldWfTqt;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122ED606A31B
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Oct 2026 04:31:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 122ED606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SldWfTqt
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a4c72951b8so1238532b3a.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 21:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793075513; x=1793680313; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9XcXpTHmLfHB2Be+0WH2R/6aY5PlfN5yRc5K8VlYOZ4=;
        b=SldWfTqtexSpVQ31Gir7rLhJ6ptsmuyJY//fxVdop4+ujlgLEL9jgZi3JpYbKPGDH/
         hZ+kYrqvrLNLr5M/ubIKLLUR/t7LXdR6o0ky6XZTsipx4DcopUY9z6jbsZeDMFRNU0Bi
         1HzQhqm4LBVs2Vc8PEFqWRU+fBQqDvSo7DyDYmKkbP153dAjoCdDDJuSTfA+4yN/BCoG
         +dDQHQFLWRlnl+vPvc4riyClzHz0TGbi1zn3vzzsH8tJbu7vYrvdmsSW9xUoUGTLNdwu
         BNVTKAVf9/amEtE17HvFct/EeZgIZIYiYpXM9brAJCPS8D43Fo6b8gcAavS6/ETkKzfd
         lGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793075513; x=1793680313;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9XcXpTHmLfHB2Be+0WH2R/6aY5PlfN5yRc5K8VlYOZ4=;
        b=L1ArlJY76KxrBvQhf6UmUa7orDNDya/0GhlN2OFKlHMHOPjePvzEMYWGjWuoVjbdr1
         vs7el5UXFTaOCSQp1SyGv/feDp2YycvadkAX8nFoVvqux3y/s6Fs0sPAslyFyYSwzrz/
         YaZtuicQAMLxYYD5FpIakA5MiVs87tD/vbyPCEc1ih8ij9cVHEgeopKDk1XpSaF8hxo7
         iv9NyHDPWmHGcrSHQ9dY+MMKSgKu0SYl35uqWI04aTWMJxsWGuKVjj9NP4C7qc/iLccm
         rZ8Zrl/mPKQKCv4J4UFoqMAe0i/WBP8YH4uDjdc0Qu/Rr8F5KgpmlQP0PESZpvfVcFoN
         vrWw==
X-Forwarded-Encrypted: i=1; AKwUvBx0APNuZt4zYzhZx6VyYtZ0ccXXZa0loSb1L+zhDYVRif/ayCA6hZEstVzJlZnm0qfD4foZB7yw722SMA==@lists.linux.dev
X-Gm-Message-State: AFq9FYLBY5LrUI51GmbvktRkeaPfrD+963HgxH4reizFHbZi6G88gE75
	G9bEUixFR4FDKBx2SNeYTAL3snxh5unmJZpXqNSUDraiq964n7gHGgy5
X-Gm-Gg: AYBFou3uJQFlcoLkX4L9fW3mrJimyNUkYd85izExIhgerqaTDqcncDFujDjGJoYdX0I
	lmWULLlwKXf/B2ThTIsAZhjCkE4ct/vzRh0EHslrycetsbbkJzKUlXexmdVRxZjRsDqt42Jc6eX
	TH41Tn2TMZN4ZtOLjBU7PTsFKlXu49oIrS6Lm5BIX9UNMthgzgxIKGwf/tqNswB9AREYmr068st
	+j+BcfrrE5wvcglDjPl6Y/3hk8wtNIB/dD9xC/xjZ7Gtp+Ng+u2H12SHiFLmEbSBPV2vWI9QYSg
	CwAX37JNacdHcj1zlSlpc/WiJXl6m6gCZOHsdE2ogLffJX8UhWTkfjDCPAxUujdhwLB3KA4/YbK
	MKakpJ9ZqiU2fICiRNucbyO4CN2xp7vOQ+glBtWGBIQ6fjtnV1Hb+8sUzmAeTzVMxdUnCJ3ZfXA
	9jz+M58xXJAsqLnXbpJ3eHHpQdzf1J38ND8qpUJrw1EOuumESkSxGsFRuyHhoYky4VNvG6qhK+7
	vx5ZCDUACyzLFt4kmAB3T2sjTKSTGo0uD5qCQaP5r9fFHzcT4auY3Wa/GYjVm8Mm7odHpZK
X-Received: by 2002:a05:6a00:2d91:b0:89e:f8e9:205e with SMTP id d2e1a72fcca58-8a369072e1bmr6269839b3a.40.1793075513176;
        Mon, 26 Oct 2026 21:31:53 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d85e22sm1887537b3a.8.2026.10.26.21.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 21:31:52 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: keep locking_state within the cluster connection lifetime
Date: Tue, 27 Oct 2026 12:31:44 +0800
Message-Id: <pm-ocfs2-objects-candidate-0011-v7-61e3ef8b1ad44ac2e817@gmail.com>
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

The locking_state reader calls ocfs2_dlm_lvb() through the selected
cluster stack. Its debug-object reference keeps the tracking list alive,
but does not keep that stack selected without a cluster connection.

DLM initialization publishes the file before establishing its connection,
and DLM shutdown drops the connection while the file still exists. Both
the mount error unwind in ocfs2_mount_volume() and ocfs2_dismount_volume()
remove the debugfs subtree only after ocfs2_dlm_shutdown() has returned.
Whenever the disconnect releases the last stack reference, which is the
case for a failed mount and for any unmount without a pending hangup, a
concurrent reader dereferences a NULL active_stack:

  Mount error unwind                  Debugfs reader
  ------------------                  --------------
  ocfs2_mount_volume(): out_dlm
    ocfs2_dlm_shutdown()
      disconnect last cluster
        clear active_stack
                                      read locking_state
                                        ocfs2_dlm_seq_show()
                                          ocfs2_dlm_lvb()
                                            dereference active_stack
  fill_super(): out_debugfs
    remove debugfs subtree

Publish the debug files only after the connection and the mount lock
resources are initialized, so a failed DLM initialization has no debug
reference to drop. Remove them again in the common DLM shutdown helper
before the connection is dropped: debugfs removal waits for readers that
are inside the file operations, and the parent directory is still present
at that point in every caller. This covers the mount error unwind, the
ocfs2_fill_super() failures after a successful mount that dismount with
mnt_err set, and unmounts whose disconnect releases the stack directly.

Only the relevant frames of the report are kept:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
RIP: 0010:ocfs2_dlm_lvb+0x38/0xf0
Call Trace:
 <TASK>
 ocfs2_dlm_seq_show+0x36a/0xb70
 seq_read_iter+0x480/0x1110
 seq_read+0x362/0x5a0
 full_proxy_read+0x11f/0x180
 vfs_read+0x1a0/0xc20
 ksys_read+0x111/0x200
 </TASK>

Fixes: 286eaa95c5c5 ("ocfs2: Break out stackglue into modules.")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
Changes in v2:
- Remove locking_state and locking_filter in ocfs2_dlm_shutdown() before the
  disconnect instead of only in the ocfs2_mount_volume() error unwind; the
  old placement missed ocfs2_fill_super() dismounting after a late failure
  and unmounts without a pending hangup, as the Sashiko review of v1 pointed
  out.
- Drop the super.c hunk; the patch now only touches dlmglue.c.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0011-v6-14cf2458f4fc90780f76@gmail.com

 fs/ocfs2/dlmglue.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 88d946466083..412ab0808c59 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3356,6 +3356,14 @@ static void ocfs2_dlm_shutdown_debug(struct ocfs2_super *osb)
 {
 	struct ocfs2_dlm_debug *dlm_debug = osb->osb_dlm_debug;
 
+	/*
+	 * Drain the readers before the cluster stack goes away: the
+	 * locking_state reader resolves ocfs2_dlm_lvb() through the
+	 * stack. Every caller removes the parent directory later.
+	 */
+	debugfs_lookup_and_remove("locking_state", osb->osb_debug_root);
+	debugfs_lookup_and_remove("locking_filter", osb->osb_debug_root);
+
 	if (dlm_debug)
 		ocfs2_put_dlm_debug(dlm_debug);
 }
@@ -3370,8 +3378,6 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		goto local;
 	}
 
-	ocfs2_dlm_init_debug(osb);
-
 	/* launch downconvert thread */
 	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc-%s",
 			osb->uuid_str);
@@ -3411,9 +3417,10 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
 
 	osb->cconn = conn;
+	if (conn)
+		ocfs2_dlm_init_debug(osb);
 bail:
 	if (status < 0) {
-		ocfs2_dlm_shutdown_debug(osb);
 		if (osb->dc_task)
 			kthread_stop(osb->dc_task);
 	}
@@ -3443,10 +3450,11 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
 	if (osb->cconn) {
+		/* The disconnect below may release the selected stack. */
+		ocfs2_dlm_shutdown_debug(osb);
+
 		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 		osb->cconn = NULL;
-
-		ocfs2_dlm_shutdown_debug(osb);
 	}
 }
 
