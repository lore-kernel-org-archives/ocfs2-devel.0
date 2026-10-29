Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257222;
	b=llN2jLJGWDKfkdZX0J47eK74sRz5K/lONDnNWEbIarqwEfyoZxVhszZXB58AluMdKpv4
	 jD/sNRJtNbwxXNd/noAr5M6uGTUBcE15C66Vy2XHlmMaDEe/qCIS8lASNT7M6HH9agqy+
	 5fkjjfppAjLUj5K9KMEjy9Ycuvo5fIw+5i+UYBcrLFLCkH+9PBu7ZeWy3TrSnROvndFAX
	 uL2KorQdKo3Wmrj8seGoiSyGVT+SMa6t0nsPrgbN2P8pMJ11lfIiQi2ULgeJ14/l91ZFM
	 i1uDprNxtNW/mzvUBUQjZC+jkCnKNxBGBH9C5s7QhcskgtuhebEbkumG1dQoFuI0LtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=e/Ay1TAI3k4EFvZAGF53xm3VA3dt9HJe3tGSfT42bqk=;
	b=Oe0EtKjsEifVPrqzyJ+0/DX+NNtPzNdUoe6SF+znZTTARV3oUyRRaAfO46WmP5lMzzAx
	 fI6RzTMR6Bu6kRmM6Xu+m1VWpPsgOMDT4+P4lf5ip3h+8GyPr3ERXmE1pYZqx8GUavKZs
	 NiaLn4JKi2cmDS2ZA/SQSGnlCwKPIpN4/dAEO/JILZdb7X8B7GStauxP5hHcoaOA0o5j4
	 S//1jwWmEA615m5TeIOG21t0M+DqmUZwoyQhrRp3tC0+hLSxwKuweCjUN81P10uzS6gSh
	 Bqg1JbQStaYcMa0XUEnUIgtFakv2PqxC0IYyODU7h4grx+AyHv34vg/AEKFblRCbXEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VXqdIjMJ;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA32606A321
	for <ocfs2-devel@lists.linux.dev>; Thu, 29 Oct 2026 07:00:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DA32606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VXqdIjMJ
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd61a2dfd7aso648142a12.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 29 Oct 2026 00:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793257221; x=1793862021; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e/Ay1TAI3k4EFvZAGF53xm3VA3dt9HJe3tGSfT42bqk=;
        b=VXqdIjMJLz2UP8sB3ajPlCZsBxsUKZOOtL1RhCZMwYlfJQKJvw7PoFAz0k06NkGKrS
         H6DMAcxkMdRENiQSEFUxUsuNDBCj1puKNaQPD6a3E9yFmxFhfvY4M5/ZaGj0H54YWfQ7
         Ih7A0c2XUCWB5PzA0iQ0jzCyVhdjxdqqonAwje5AcJQlv94M5TanTQABaHxTV/NJe9Ju
         x0nd+h+K2u+0mYNhaw7LeCpeS9EVAIm+KXFzhfKnZDJZ29PpAP9FdYWKnHocTa6lFY3k
         694KG4PKZxajUTdLwlssNBGbcW0XTIjATSwXqskPa+GC5nfkZ0s5tWFtkMj9h276VOAU
         IhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257221; x=1793862021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e/Ay1TAI3k4EFvZAGF53xm3VA3dt9HJe3tGSfT42bqk=;
        b=VktGVo73MFVeXiLXA0AkbhAJWbYLDfA5n5PD5hNIiGYvUAop0O0gknaSYt9l9cDX+c
         UMd0NxgxGY99Ytg5vjOhnRRwGNMPc6XRq9zosQZfx8ROYnzq3jFS7aNke9DcQFzMS6uy
         68YM8hH5u8huyFId5+St6zSLR61VgKfQ4NNoYJ4vg4+UiAZiHSlM1lZmOLpIOWV3r/pk
         9VeILr5E6hkTQ9JmbKYkHIHHdyENidXMK6ENfM1lkiQRt+0PISOiBTQBpFnazK73D0hu
         L9rgQnJtAg8Q/ew35wkg4HXeSJ06qCIlifO2TE8qHA6moQR9OOPoBa4WgdSK2EwAvDf9
         SK6g==
X-Forwarded-Encrypted: i=1; AKwUvBx5MzRVd6idQjpPcCnRybtFDcnfQ748u+QlDsDfa+uRzhbnfE90KMUpzzE00zR88mFVW8eikTHEZ+a2WA==@lists.linux.dev
X-Gm-Message-State: AFq9FYJGpWNoKtWlzR3j/9mU6jZhGGZA16kW/qWVeweRmkci1kselUlD
	RHuNqdHd67ef08Y9qhhYmVqIjI17vksS89CiIFvH8xwDdPPk0ixRkQ3A
X-Gm-Gg: AYBFou03OtKc7NGEU7NhTDIYs5MqauYZI+P0jevMPEY7S6pHUnFwu/OaacpKS1T8xPk
	UW7E5l353gQHTomffWgi55c4FjRtZpyQTiiszgCDZph6U2MuZghZteqTGLSKOKIRIiPFkvy5ust
	JqP9Y0yYbagbk4wjFISJLX3qVb0sDyCb8ON6989FbHrqH5eQGo1yFqWrDM8LBR7z4qLdYuNWNue
	5GjfOH7LgPiJgtehyCoJ04J1FUvzbmR4qtCU1R46M/sHq1vFoYx/z7lxFdIFgZQ8GIaWGyVR8yx
	kIXGwe11yhMjmpMExKjCDaygQST9nAWlYT7uH0H1HCiRvfazE9les5HWP1bQglDOQ+JiYsksLkF
	eZKy+YqyYNv/UhliU5ZRyZ1SYZ6CNcl/4USPX0X0Xv/1vZj6Abaib8xl4Ip+22JN8kZo0s9zz0L
	Qq+BR7DS3zzTWoRFr3SMzXiNFxExzSOh90mlz2QKE0ZhbizenIG/3aJNDXjxBCeDxJCEfHHH6dc
	4EwfJXu8frbbzvwiQrY+W7MngYEJahNr7u9UUgbb6mz45FFGYjS2bzcmvnBKRPSUxOz64l2aIAU
	ws0ButL2qXB2iBeHH6hS8dac
X-Received: by 2002:a17:90b:1c01:b0:3aa:f4af:1e0b with SMTP id 98e67ed59e1d1-3ae57e2af4emr3516499a91.8.1793257220765;
        Thu, 29 Oct 2026 00:00:20 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e8fba61sm2765156a91.6.2026.10.29.00.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 00:00:20 -0700 (PDT)
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
Subject: [PATCH] ocfs2/dlmfs: keep the superblock alive during lock work
Date: Thu, 29 Oct 2026 15:00:13 +0800
Message-Id: <pm-ocfs2-objects-candidate-0054-v6-c3887cceae3b039e591e@gmail.com>
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

Queued dlmfs lock work holds an inode reference, but no active reference
to its superblock. The workqueue is drained on module exit rather than
on each dlmfs unmount, and an inode reference does not stop superblock
shutdown: generic_shutdown_super() reports the busy inode and goes on.

  DLM callback / worker               Unmount
  ---------------------               -------
  queue lock work; igrab(inode)
  worker delayed
                                      drop last active superblock ref
                                      kill_anon_super()
                                        report the busy inode
                                        free the superblock
  finish lock work
  iput(inode)
    access the inode's freed superblock

Flushing the workqueue from a dlmfs kill_sb would not be enough: a
blocking AST can queue new work for an inode that is still alive after
the flush and before eviction, and that work again holds only an inode
reference.

Take an active superblock reference before acquiring the queued inode
reference, with the atomic_inc_not_zero() on s_active that grab_super()
and the NFS and procfs superblock walkers use. Decline to queue if the
superblock is already shutting down; the inode is then being evicted
and user_dlm_destroy_lock() tears the lock down. The existing l_lock
and USER_LOCK_QUEUED flag serialize this with other queue attempts.
Each execution drops its inode reference before releasing the active
superblock reference, outside l_lock. If that releases the last active
reference, the unmount completes on the worker; it only waits for DLM
replies and never for this workqueue.

Only the relevant frames of the report are kept:

Oops: general protection fault, probably for non-canonical address 0xfbd59c0000000026: 0000 [#1] SMP KASAN NOPTI
KASAN: maybe wild-memory-access in range [0xdead000000000130-0xdead000000000137]
Workqueue: user_dlm user_dlm_unblock_lock
RIP: 0010:iput+0x246/0xc10
Call Trace:
 <TASK>
 user_dlm_unblock_lock+0x503/0xa50
 process_one_work+0x9a8/0x1b40
 worker_thread+0x65c/0xe40
 </TASK>

Fixes: 8df08c89c668 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/dlmfs/userdlm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
index 617c92e7b925..516e50a5728d 100644
--- a/fs/ocfs2/dlmfs/userdlm.c
+++ b/fs/ocfs2/dlmfs/userdlm.c
@@ -162,7 +162,13 @@ static void user_dlm_unblock_lock(struct work_struct *work);
 
 static void __user_dlm_queue_lockres(struct user_lock_res *lockres)
 {
+	struct inode *inode = user_dlm_inode_from_user_lockres(lockres);
+
 	if (!(lockres->l_flags & USER_LOCK_QUEUED)) {
+		/* Pin the superblock through the worker's iput(). */
+		if (!atomic_inc_not_zero(&inode->i_sb->s_active))
+			return;
+
 		user_dlm_grab_inode_ref(lockres);
 
 		INIT_WORK(&lockres->l_work, user_dlm_unblock_lock);
@@ -275,9 +281,11 @@ static struct ocfs2_locking_protocol user_dlm_lproto = {
 
 static inline void user_dlm_drop_inode_ref(struct user_lock_res *lockres)
 {
-	struct inode *inode;
-	inode = user_dlm_inode_from_user_lockres(lockres);
+	struct inode *inode = user_dlm_inode_from_user_lockres(lockres);
+	struct super_block *sb = inode->i_sb;
+
 	iput(inode);
+	deactivate_super(sb);
 }
 
 static void user_dlm_unblock_lock(struct work_struct *work)
