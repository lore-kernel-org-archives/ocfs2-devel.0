Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A93279DAD
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 01:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510231; cv=none; b=lPj04cHjTZC8wnYq3N+9Z5IDOI2EhrgMiVYFqtzOJUokqGnnNH6h62ljus086MVIURArLLx3NAYv98/7vxXI8ZqtLEZ0DMJC/x4FueeSiwcKfune6bTAO0fCrZoDD3nYVhI4OD27OLJz7en4WRlw7gN93PG0TErvLBJCHo6Glis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510231; c=relaxed/simple;
	bh=SYUMbJA3H1wELoN9ZbRQDQAXdKvi6eJiveMWaHIWSBY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HIoxpHbwcHCU2J8RFe3Mt1nz/ovIv0Dw0d9X3uTTxGAPW8yny4ecjSZS1mH+bCtuOxK+25Ni2QYnxbpBWqcq1Ii8oTQSIBj5tkg5PvaaE3c3HaBZJ5PnFXS1qWV1WkEBZD4gb5NOo3IiFAhQYRAKYtdM5hJQI7K4h/xPkzvepdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DTF8xDjX; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DTF8xDjX"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-885cd98d226so652435b3a.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 08 Oct 2026 18:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791510230; x=1792115030; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rZnm1wY9gecrxp3h2osjOoN/UxlPNzvZVG2xZrbNWqA=;
        b=DTF8xDjX35QgSPWfoUes1Hw8HnhtZgmmJvDaj4WRBAxkp6kwyhbAs68/YbgXRJhoLX
         ZME3VvCPQxQ3TfHbbEMn4PEL6RbQ9SoWte5zyjV4n2AmPyx0p6YXcQiZHGbSLt72MwhU
         WqXJd8SQqDY7RLE1NNB+ZMbU2S7RBacT29K+RWSZysTCXkJeHPQVSnb++jTZ8JePcq5J
         ujvkjC3ory773NBLuxnNdxzljkOTgCABqU0wEyCKC7LIoplVoqxO+fRsuA944W16zgkU
         jJm//4AVAsmNycfI0THUjcCq7/F2zkNOAYLbELrBZi8AblbkIhEk+KrVPJgCDRr/VFTi
         wujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791510230; x=1792115030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rZnm1wY9gecrxp3h2osjOoN/UxlPNzvZVG2xZrbNWqA=;
        b=aEC5cz203F8L4Fhm5oq01KLGq5wzWdscyK7sGQ0lddjBAPzkknl5Gx+gf3319U24pt
         jixOs+7DNFcNmg9E9iOhIyRZ9LC5+yHR6cVwp5srqtpg4iWQ+z9K1jcmtquM0B9DdeBc
         f7HtLgKH9PEitjqoJbfHJ5SEzgrwEQh6l5lQ8WbqQMWPiocA+t6ViZU3qJY4AI7/c77N
         Z+kwhN2kXAq6OpcC4Czg+t42Jz/LelfOFy326BSQhCtIu6xXu/nFyq271/SQw4FR3j+Z
         9ZOhfm7GlbAXKGDpZh6UcoiVhCMUwmKjk5Oy0mflzSzda85o8YQ4+itMmRfHYEQWQ6Lm
         +Dow==
X-Gm-Message-State: AFuF++nmaERWzCVyG6lnjyTH23VkvC7A/1kgjJI9XQoz0FIklZohljV9
	H+HMOUpEpWgi3bT+yESyRi9MtvqsOVcFj6f+Pbfz2MmeQUCQD0xvSjwO
X-Gm-Gg: AYBFou2JAbWR6U22r2aCPsC2oqoLBZs69FBhU4Lfu1/2KHiZO5OjDEn+v+qHAtGb31R
	L+yE2Gna8I1Ey39k6RinxJRvB6zK90aH9vn+a0brTSrbbTjaU+mBv5J7SzQtxjw4ExyAVcMxsvP
	eM/ELoCBJRCw0mfGnoQcRQ2YMUSPU6f1Hf2UQxEJeRldSv+RjKvLiZEMjRFVZ2Gsut9nyzRn/fL
	x1IxOvqWYcNWc6LbAU4yTV0IvFh4Wwpq+KVE3iXi5EpLDnYoD44vxA3qRmfxg8nua5oqWo/NEAj
	TdRVU4OjtaIz1R0s1E5CGsWGeAC6Ex8e7uthRJKhRLbbxD6NwbzjPrVN6t9Q+tJNtWfaRDGAFZJ
	oyho3NBod5/RibayIfRX7LMUwX8NznVeaOzJRJWsQorBscRWWCxUHvY+i4e6S5p2kYXfjtLSFUu
	RfGKDgOCqWAcKbgGkivaZUJErQPLCp7+JXB3I71XXRFi+czOCxTdfJ23HH5tKOJB3/uw==
X-Received: by 2002:a05:6a00:4008:b0:882:be9:b76c with SMTP id d2e1a72fcca58-896898e8282mr624156b3a.3.1791510229591;
        Thu, 08 Oct 2026 18:43:49 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896b68ef6c6sm285648b3a.4.2026.10.08.18.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 18:43:49 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	kees@kernel.org,
	zzzccc427@gmail.com,
	kuba@kernel.org,
	akpm@linux-foundation.org,
	kurt.hackel@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: [PATCH] ocfs2: Initialize status waiters before publishing them
Date: Fri,  9 Oct 2026 09:43:43 +0800
Message-Id: <pm-ocfs2-objects-candidate-0066-v1-437a0422801b292a2879@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

o2net_prep_nsw() publishes its stack waiter in nn_status_idr and
nn_status_list under nn_lock, then initializes the wait queue and
completion status after releasing the lock. A concurrent disconnect
can find that waiter through o2net_complete_nodes_nsw() and call
wake_up() before the wait queue has a valid lock and list head. The
sender can also overwrite a completion status with its initial value.

Initialize the wait queue and status before publishing the waiter.
nn_lock then orders publication against completion, and no reader can
observe a partially initialized object. Leave the IDR allocation and
its failure handling unchanged.

A controlled case-modified test kernel used a synthetic connection to
enter the real send path and overlap publication with disconnect. The
candidate completion and wake-up code were unchanged. Its Oops includes:

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:__wake_up_common+0xa0/0x1f0
  Call Trace:
   <TASK>
   __wake_up+0x36/0x60
   o2net_complete_nsw_locked+0x222/0x370
   o2net_set_nn_state+0x917/0xea0
   o2net_disconnect_node+0xd0/0x190
   o2net_validate_control_write+0x454/0x500
   full_proxy_write+0x11f/0x180
   vfs_write+0x25a/0x1010
   ksys_write+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in:

Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/cluster/tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 474fe1414cee8609d7976b983332c6e120f06fb5..8b3830b601ba6e5fe964bec970581b8e4ddbb5dd 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -301,6 +301,11 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 {
 	int ret;
 
+	/* Initialize all completion-visible state before publishing the waiter. */
+	init_waitqueue_head(&nsw->ns_wq);
+	nsw->ns_sys_status = O2NET_ERR_NONE;
+	nsw->ns_status = 0;
+
 	spin_lock(&nn->nn_lock);
 	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
 	if (ret >= 0) {
@@ -311,9 +316,6 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 	if (ret < 0)
 		return ret;
 
-	init_waitqueue_head(&nsw->ns_wq);
-	nsw->ns_sys_status = O2NET_ERR_NONE;
-	nsw->ns_status = 0;
 	return 0;
 }
 
