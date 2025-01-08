Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DD77E765
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Jan 2025 02:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736304092; cv=none; b=uKqHdKhiQVLRjJDsjjF9fVm6Yas+Jw0BXSYk/UU47e00NnfKTx3TjXzfU3m6QykvHtjSVFsiw+amI2Esy/jP4Fk5BtcZehaM+TCfw9xTCWuX+/6Kq/GEZKpn23DghorqgvtTQEwfDacQtNi5iTT2/h3jmJ9sAGtLngh/SWw5iL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736304092; c=relaxed/simple;
	bh=WjZl8g3VsKCTdJt4KE7fnKCcIF7W8hh+Lfotvfck1UQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ItApq7UmKG8vizmEA7l2pKq1wKLO1X1ce89WnCbz4E5nLRBo58cLZEAafcim+w/xOUd81uh4QbEH5LgRiIo1RXTFENA3gvKs43nzv9h7h1K6aVezcKlXf6iSY2RoPpYSnKLS28SG4noKSjZ7b/VE6cnVO2FQ2end47moani5zz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nc/CAGxJ; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nc/CAGxJ"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aae81f4fdc4so2787718066b.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Jan 2025 18:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736304087; x=1736908887; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gqIDK93kmwAYGwn2vxuLgwgiy/9qF4CkXfnsAsFJ4PQ=;
        b=Nc/CAGxJQLUlHh5hkPQGs+UGQ4giQZq+DJADzzS3dpmcnr8OfwskO+mHqFtDS+sdlR
         v0uzxLpuEMIgAf8n5KyQ1a+1RNpIJlARijpoEpUH53iIq47+vVIiXVcFWeyfRRBkaH2+
         CMurGDE/fJ5ibAfyzxteY8DYTvlV04j3m9N2JYBF8BmZ2pYGD+NMgf3dNgqt0HHBr8/h
         2AiAEUmrGbQzMJ0US+jIhGcJFu+RVr8FSSHFjdUKmsqsxLLSjjcwBnwM0d+fHde3AGLR
         S1EPaQlcireGTjgPDg3halXgeyF6hi8avtOs8HB7d53QT5pxlBM0Aqtwg9w027TfQeRJ
         MzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736304087; x=1736908887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gqIDK93kmwAYGwn2vxuLgwgiy/9qF4CkXfnsAsFJ4PQ=;
        b=La6aNVgjzDS6dsX4Mg3B2pkdnhirUeqpsBocZ3LhRAX8sYQbLIyv298OKEJoAUDuHr
         vAUigRC4NpdsUYmAtPcGbNVeMKhEwt/jE27UK7oD0fzNSR6EFlz7x9F6sDPCJ88JnOJY
         t89o31ukE3L3QRPf/wAR/EiY87VHJ2/MtHQAFZKFwCyThyz8Fa1sgMy/MXJptz2wBUWH
         KTBkuGbqVSng+3Dq3x7Ed9RPxx329UXghUms5r9udR+2pUHMfqaunaG0hmdPhp/PtiZJ
         8yqO1tyP5Z5kqAdBmIqqaqQ719CBMU/5xuNACmIK4+k7ZQUEOi96LxMacQQlrj9V3Iru
         vyFg==
X-Gm-Message-State: AOJu0YwCRegmFUctI91dkhacRwEKoflVO6DjhF67/JGJ4FE7KOBIns5X
	sIbD0j3z8kMEe08JWnPK0fMGkACVGysixSApU86TWHqkPKsitOndYAOcpjLBLMep9Z3X+CrXnNk
	MsBc=
X-Gm-Gg: ASbGncsqzCrJpejtRqTCJe9vaz4dYmgoKL/Gjh2gUQYXjJz0NqAPI0CiZ44JqxdGKw8
	3yqyeYAkyhgWaRoHGm0H40iQsPzGT6GICGgWxFRTpCzhB7ZCz9WL5iWfsv6GaKoaZ8MJyWeJWDS
	axX3+pK+SpxQeMBwBnl0JTwr7g3pskHcPO43AgzXnH6aInfuo8tFIjr9GzTGBqSK+snCR5KwUe8
	s7WcqWDTBvVm+nfENdSDOizc20ANJTGKpaG5//DOcZsTa+YEPhn6y+yAQ==
X-Google-Smtp-Source: AGHT+IFNoik6zri1qpfW/maljJlOCDlnfcMmNprPaBbeducmy6CQKWCK8d7e34XvuUJlvjaJkgW3yA==
X-Received: by 2002:a17:906:c142:b0:aab:e07c:78b7 with SMTP id a640c23a62f3a-ab2ab70a36dmr81783566b.23.1736304087229;
        Tue, 07 Jan 2025 18:41:27 -0800 (PST)
Received: from MacBookPro.lan ([195.245.241.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9716b3sm318676855ad.90.2025.01.07.18.41.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jan 2025 18:41:26 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>,
	Liebes Wang <wanghaichi0403@gmail.com>,
	syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: check tl->count of truncate log inode in ocfs2_get_truncate_log_info
Date: Wed,  8 Jan 2025 10:41:19 +0800
Message-Id: <20250108024119.60313-1-glass.su@suse.com>
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
Changelog:
v2:
    Add the missing brelse(bh). (Joseph Qi)
---
 fs/ocfs2/alloc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 395e23920632..2a6e3588897d 100644
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
@@ -6171,6 +6174,18 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	di = (struct ocfs2_dinode *)bh->b_data;
+	tl = &di->id2.i_dealloc;
+	tl_count = le16_to_cpu(tl->tl_count);
+	if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
+		     tl_count == 0)) {
+		status = -EFSCORRUPTED;
+		iput(inode);
+		brelse(bh);
+		mlog_errno(status);
+		goto bail;
+	}
+
 	*tl_inode = inode;
 	*tl_bh    = bh;
 bail:
-- 
2.47.1

