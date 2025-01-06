Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ED639FCE
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736172417; cv=none; b=bVNKOLx1j3x86Jz5uiEmFVHY8K4fKFg72khruLOS5+JYzagaTpKHP8hkfWVOCvcBLajb8QKKZyMudzJXSgKLHjEW8WypsI8EgUBlTTJSOq+VXZNj8DCKznWwkZY1NdwONM6xMaunqSu1YwO0ZmkEFXA9aUuZU1Lfbv0SMsyDcwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736172417; c=relaxed/simple;
	bh=Qm5cuZKzqbvYtmtiaxY7DMbKNAQTB0KAFE5Qc7wO3qw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ByHs30D/SR34ZWNAYI4vZRLmPg8MX8ac/B6mzfBTyERtKd5JFLrgxFulIXJYTSfoHtQPm/HUNMUvt2GF7xe5ng65sisDry3vdMsJdesQ84wf5ZxVsmMv1BqMFNpEkTNndCImu+TCndxie9aXIfVcG4CV6Qs6Y2mvb+xb04mjRA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OA/1lWLw; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OA/1lWLw"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa67333f7d2so2098055366b.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 06:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736172413; x=1736777213; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=swm/YyjiU/CYWLlXUzeXBh8QdS/90KrsZinxiQWRqlo=;
        b=OA/1lWLwd0AwTwJWJ3w1/OCasTJcjt7iUE0qgbTG+2tH6LwC+B9BoSFXxJD9eYlYMn
         3vjlasJo3Lw5cG3wra1ioYIfTK1jK0snyUHSTuLILHRGKj/hUSR4DdIbq6044J7GedvP
         TrpgNdWKEjkxDzdSkv9IMGkGd/BYlcuB+6lDcDCRY8txkENlC/LTqUeLv1BA8VcGK/GP
         xrDaai9UWiVTB5SjyHQsXUaQwwI9aGGs/umCLLQsrIclFA9hTDy1sWKlvl+lClHnH2SK
         b76z+8sXA+GGIYJTk3v1nRuG8/u8paKL4s8r4/LhNe6SzoNxoVW4/ZRPWemQ3I7+z1ua
         KiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736172413; x=1736777213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=swm/YyjiU/CYWLlXUzeXBh8QdS/90KrsZinxiQWRqlo=;
        b=DrqpQaBFqxnF/TtPEcSm1EgL0dMuDcLgyeZ/zyMvttl5D3Jl2OkzdiKDWnEm126lLM
         CetdiFlph0oz0uTzye4fV2X04gDz7qMTfwFVPoLQ6H9i/gGY87sYe2j85A7nj9qCIcUW
         ETWi6/MMaexkWGC6YgUWbQ9/5y64W6PpbuyldxwAO1KGYgI7k0Ka9JAALF9gshGBzwPq
         4UCCupgTBA97lKe8qdpyMTInekDdCM3QjWk0i6q6Frub3P2SIsl2vkRHDM4VblQk6jHh
         TC7e09UQa14+2NjNSDuQtXUrkfTWuMofPlnW3XuEW1Tj5oaTKMesP/dLxbTwm0nzewsr
         XQ4g==
X-Gm-Message-State: AOJu0YySxp4R9By666SFzpp9gpSoXBhqp2CEIf73I2cSXLB68QVpidxO
	2g6PltjuH7LhtrIjbDCp35nrc7iO9F85nAQ3kU8qcQvtPkYsKYKdadc/Nt6lsqUltgF9K8bP7Og
	GdhM=
X-Gm-Gg: ASbGncu4OQFMwyOxcTirPMN3m417uoUk8aY5y1liGPSn/DHidHkcAycp9tzIJyufGc+
	OrytuQx4qrCuDoz0D3OAJyT9pwnflVwyIqRizyN5V3Z6lJo8SfhhtvT9QyWYyslwt7dcpBapefT
	61czfm7mQl79lBK1bWp8sJBc9JcKz6fINy3DXKOHBO3coQAupaojPHZ2gaJPEe2X1Xx7UqcMqu0
	02zxhLyNAQTo4IeMINSHhpQffKDWfbyGnd873GeKEeD3yF5zp6/020E
X-Google-Smtp-Source: AGHT+IHtQWi22Lm5kxLSnm3/xNEt2MF36P38u9IfSK5f6TnRt83YKHB3wxfYKunKG6vQkAHIHCzXyw==
X-Received: by 2002:a17:907:7fa9:b0:aa6:5d30:d971 with SMTP id a640c23a62f3a-aac27033750mr4834964066b.11.1736172413313;
        Mon, 06 Jan 2025 06:06:53 -0800 (PST)
Received: from MacBookPro.lan ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90b90asm31458366b3a.177.2025.01.06.06.06.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 06:06:52 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>,
	Liebes Wang <wanghaichi0403@gmail.com>,
	syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: check tl->count of truncate log inode in ocfs2_get_truncate_log_info
Date: Mon,  6 Jan 2025 22:06:47 +0800
Message-Id: <20250106140647.92276-1-glass.su@suse.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syz reported:

(syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: bug
expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
tl_count == 0
(syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: Truncate
record count on #77 invalid wanted 39, actual 2087
------------[ cut here  ]------------
kernel BUG at fs/ocfs2/alloc.c:5874!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5313 Comm: syz-executor404 Not tainted
6.12.0-rc5-syzkaller-00299-g11066801dd4b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
RSP: 0018:ffffc9000cf16f40 EFLAGS: 00010292
RAX: b4b54f1d10640800 RBX: 0000000000000027 RCX: b4b54f1d10640800
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000cf17070 R08: ffffffff8174a14c R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff110085f5f58
R13: ffffff3800000000 R14: 000000000000004d R15: ffff8880438f0008
FS:  00005555722df380(0000) GS:ffff88801fc00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000f000 CR3: 000000004010e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
ocfs2_remove_btree_range+0x1303/0x1860 fs/ocfs2/alloc.c:5789
ocfs2_remove_inode_range+0xff3/0x29f0 fs/ocfs2/file.c:1907
ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4537 [inline]
ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4684
ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2736
vfs_copy_file_range+0xc07/0x1510 fs/read_write.c:1615
__do_sys_copy_file_range fs/read_write.c:1705 [inline]
__se_sys_copy_file_range+0x3f2/0x5d0 fs/read_write.c:1668
do_syscall_x64 arch/x86/entry/common.c:52 [inline]
do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd327167af9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe6b8e22e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007fd3271b005e RCX: 00007fd327167af9
RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007fd3271de610 R08: 000000000000d8c2 R09: 0000000000000000
R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffe6b8e24b8 R14: 0000000000000001 R15: 0000000000000001
</TASK>

The fuzz image has a truncate log inode whose tl_count is bigger
than ocfs2_truncate_recs_per_inode() so it triggers the BUG in
ocfs2_truncate_log_append().

As what the check in ocfs2_truncate_log_append() does, just do same
check into  ocfs2_get_truncate_log_info when truncate log inode is
reading in so we can bail out earlier.

Reported-by: Liebes Wang <wanghaichi0403@gmail.com>
Link: https://lore.kernel.org/ocfs2-devel/CADCV8souQhdP0RdQF1U7KTWtuHDfpn+3LnTt-EEuMmB-pMRrgQ@mail.gmail.com/T/#u
Reported-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
Tested-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/alloc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 395e23920632..3d1d029d272f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6154,6 +6154,9 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 	int status;
 	struct inode *inode = NULL;
 	struct buffer_head *bh = NULL;
+	struct ocfs2_dinode *di;
+	struct ocfs2_truncate_log *tl;
+	unsigned int tl_count;
 
 	inode = ocfs2_get_system_file_inode(osb,
 					   TRUNCATE_LOG_SYSTEM_INODE,
@@ -6171,6 +6174,17 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	di = (struct ocfs2_dinode *)bh->b_data;
+	tl = &di->id2.i_dealloc;
+	tl_count = le16_to_cpu(tl->tl_count);
+	if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
+		     tl_count == 0)) {
+		status = -EFSCORRUPTED;
+		iput(inode);
+		mlog_errno(status);
+		goto bail;
+	}
+
 	*tl_inode = inode;
 	*tl_bh    = bh;
 bail:
-- 
2.47.1

