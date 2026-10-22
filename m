Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660157;
	b=jbC9cYMyQrxNYXDo+u3vtSMgUU/ZAOnm1NMTTHHsto0T+y5pUNVRjcEmN8FuMxRx1dt/
	 W+DmD1N0UdGd9b2IUr3tLODqWTotJ1bwnY49ZFVWzLLCsObs32H6e027qVACX8mq65AET
	 l7APBhQKW3KGQwzquYedDXN661Fo2/Oed66XVSeNUTXcTgIy9t6gddpPXqryKDVlbc98V
	 /z3oWTjgQdVNl0eTtwppZrCcMrYsSjoUw52syqaAIkTSdkCSfv0qm+9tPSW+XbyaAsq/L
	 xK5laBUBNg12N9A84DfMxu6lxyTueueFxpaXikHXQG46W/Wj4RIF02iVp07eudNt5Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660157;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lFKRiSem7YLaN/MRPmgMwVevdlnMfUBDEjFcSaNLdvc=;
	b=iPpm1NHCDo/AuHDlKFeUhfOuIsa8nSa6iQakQOief7XLgddoTX6fteYSXM66bzgq1SZr
	 1AuJ2Q8fw9fo1gUFztgbWXYCeGS6UDP14l/SMmWi+O/UJfXGH+VmhSUJETSZBpmV0ujSV
	 5+jGsOWbWHvl0/Xl1iIXJf1Dxdxt8uNQ5j4LwS3PAk5RUzfR3OxvR8KBP11nNtUiPEc31
	 IDzRy+zDd2rd1K/8S2+TNZpeZ+D2nIHFHsWq7WrKBm+0VMbTqtEe5Nhcwcnu+a3Qm7LXr
	 VMuWt1sMPzEAq62DiWbzl9BpFUZTiB257XsxrgmsKC1QbsyksvQ9aFLVQKNoEvw30Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nxiB5iIl;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF3C606A31E
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 09:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FF3C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nxiB5iIl
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc4ca696de6so910218a12.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 02:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792660157; x=1793264957; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lFKRiSem7YLaN/MRPmgMwVevdlnMfUBDEjFcSaNLdvc=;
        b=nxiB5iIlps8je6iN+cSePqvJLRizA8mvaMyuVZYwYWadzWdB4DBbozKoCxisk/puwr
         2CEeabDuTf4b/EQGqdpF1jvAkycSciJdddlg18AU4z89sFAOaNyYjCo2DSZ1gyCQWikg
         mDm7EpbnVbUNs7IK/uTUZeuAgDrNKN3q3HsQsWnu2PqGOMrWm0g8bE9pdPg8NVigQK9U
         Tl4DscQrvEAoKB1klnCwgXvJpBy1yzzdhMblq2BvTZ81QkA2MaZQIc46o0CmYIldB2CK
         eDfZ91tlU1tl4+Zk2sNmHr7BVf5HFcN9HVZ4fQ4R86O5yopC+PrHcwP4Y80b9sJwP5kg
         UJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792660157; x=1793264957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lFKRiSem7YLaN/MRPmgMwVevdlnMfUBDEjFcSaNLdvc=;
        b=W1t8vfQYhz5LRfvg77V1wuf/U7ioIIbZLQwfA1F/ivL4HQ9b/3Skn2/IWqIbRmyV4o
         INnNv8T1JHlQ8Q4+zATkHvwmBxFL6DERVuE+0sMnIAuVstUwvFXUpKwE+bCwJTZDy+gy
         xXvcpEuOU6fwgrTVXTtnD8+7AQc481AoUpr4jjeOczhwXoC65MQOf/zWfSYPmd1yvM59
         8aX4sTYP9KvtlmDYYAj5XxegWQKJqXLWHsgjmW3rVxiwTTD5owA4v7IDe0psC9uvfVKh
         gbXTcqEj3op9hPMlT9Y6puQ7obM9WG8DimN6sy8/uEniTX6qYOFRvQPjzNmWPBhJLmc8
         B8AQ==
X-Forwarded-Encrypted: i=1; AKwUvBwojaajWaHvlwz3JR2pAvdsimz+8D2/I4iDjt8bfTSy5NGMqtqt6ZSfmz3TLjshicDItDVYm+9YtEouMw==@lists.linux.dev
X-Gm-Message-State: AFq9FYIVWrYivmLBj2wNgj7+/h0jK+VucCle++9JMWzgoUpWv2WZ3xDB
	LciRAyzdJ1UtdLUJqYUfq9VjMLnUYbFKnGmwSk/qoiWXAPGgSEzlc+Rr
X-Gm-Gg: AYBFou1ZQ+LaVbpIb0aH2twbDIb3ShtHWebWGhy+GDe6zvxvZmBUE6MIqwfJsQ0G0b8
	NfhbQjtCH2sVKxekNC0rR+i+JHv3Fl4wLeL9ODi35+Obl3JnjWWHSe6QxFwU+YS29WnuvbgJlfo
	8cLRkYox1EYZ6g7hTA2CKqWF5Kp9TBno5gEAaFHPhuiuTEMDYt3dp5x7QwWPYgxJFoqYlSiiju9
	iiBkcxGCOV/GK5jDe/NfcX0tt8i17jWt3nmhMW4tpdiGjmovz6qNyhezLKCJk9aUBHAl2IkpIvN
	lfjCqM7DM0BbvZk/VFZxpJL9FMT+Gfu+dqYqBWRzui8XGHDJaTA+OIUtjKtVAdEbKCto4BoVImF
	99ZnILNGygQpkm6QZNyOl6ORtbb5qG99H0yAo68/EunHqInhpuL/l2YoBIg6eI680c0u99yr/Y6
	QenchLwFehdfZr4T+I+etTwedIBIO4mAZ5VfOfRGQA4efhHK1rPC6GPzCucaJFfPsaWvrlZuSEs
	qvyh5hr39bJ0Q9upHIHccK+CZa29ESKmvp95u523PIukt9ngHI=
X-Received: by 2002:a17:90b:5788:b0:3ac:74b3:a8f3 with SMTP id 98e67ed59e1d1-3ad86f43374mr3719443a91.44.1792660156804;
        Thu, 22 Oct 2026 02:09:16 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48a573fsm3460469a91.10.2026.10.22.02.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:09:16 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2/dlm: drain join handlers before releasing module text
Date: Thu, 22 Oct 2026 17:09:10 +0800
Message-Id: <pm-ocfs2-objects-candidate-0076-v6-12de5f4628f57fba3be3@gmail.com>
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

The code for a registered DLM handler must remain resident until its
last invocation finishes. dlm_unregister_net_handlers() only removes
dlm_join_handlers from the o2net registry. o2net_handler_get() takes a
kref on the wrapper, but that reference does not pin ocfs2_dlm text.
o2net_process_message() calls nh_func after dropping o2net_handler_lock.

With CONFIG_OCFS2_FS_O2CB=m, ocfs2_dlm can be loaded independently of
ocfs2_stack_o2cb while nodemanager continues handling messages from a
configured, heartbeating peer. If no dependent module or module reference
prevents normal unload, the following ordering is possible:

  Receive worker                       Module unload
  --------------                       -------------
  o2net_handler_get()
    take wrapper kref
    drop handler lock
  <preempted>
                                       dlm_exit()
                                         unregister handlers
                                       release DLM module text
  call saved nh_func
    in released module text

Use o2net_unregister_and_flush_handler_list() in the shared DLM
unregister helper. It first prevents new lookups, then waits for the
ordered o2net workqueue to drain, including a concurrent destruction of
that queue. The acquired invocation therefore finishes before dlm_exit()
returns and the loader releases the callback code. The same helper
covers partial registration and dlm_init() error unwind before module
memory is released.

Skip the drain when the private join-handler list is empty. Early
dlm_init() failures can reach this helper before any handler has been
published. Partial-registration failure also reaches it a second time
after the first call has already unregistered and drained the list.
Neither case needs to take o2net_wq_mutex or drain unrelated work.
The list is changed only by serialized module init/exit paths; a
nonempty list still uses the full unregister-and-flush helper.

Oops report as below:

    Oops: int3: 0000 [#1] SMP KASAN NOPTI
    CPU: 2 UID: 0 PID: 54 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)

Hardware identification omitted.

    Workqueue: o2net o2net_rx_until_empty [ocfs2_nodemanager]
    RIP: 0010:0xffffffffc0423871
    [Instruction byte dump omitted.]

Register dump omitted.

    Call Trace:
     <TASK>
     ? o2net_rx_until_empty+0x19b1/0x3300 [ocfs2_nodemanager]
     ? __pfx_o2net_rx_until_empty+0x10/0x10 [ocfs2_nodemanager]
     ? lock_acquire+0x190/0x300
     ? process_one_work+0x935/0x1b40
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     ? kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ? ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ? ret_from_fork_asm+0x1a/0x30
     </TASK>
    Modules linked in: ocfs2_nodemanager [last unloaded: ocfs2_dlm]
    ---[ end trace 0000000000000000 ]---

Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM
---
Changes in v2:
- Skip unregister-and-flush when the private join-handler list is empty,
  covering early dlm_init failures and the second cleanup after
  partial-registration unwind.
- Retain the full unregister-and-flush helper for every nonempty list; do
  not change the generic o2net helper.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0076-v5-dd198d8a9358ad81f70e@gmail.com

 fs/ocfs2/dlm/dlmdomain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 97bb9400e24b..a7dc3da6dfc7 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -2215,7 +2215,8 @@ static LIST_HEAD(dlm_join_handlers);
 
 static void dlm_unregister_net_handlers(void)
 {
-	o2net_unregister_handler_list(&dlm_join_handlers);
+	if (!list_empty(&dlm_join_handlers))
+		o2net_unregister_and_flush_handler_list(&dlm_join_handlers);
 }
 
 static int dlm_register_net_handlers(void)
