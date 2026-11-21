Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795247526;
	b=iYAdVw7aNDXcRQ/+E4AQ8bu01YitG+HUSrlS/SRYTFxQoMZTw2FI/IfInV/yMeyixuzK
	 HvkMdRToaqM5djeRtVW9k9JcvEGF2cOtFU6JNnzzrrOV2yAUzztGrxBD7raLnDQYGRPtv
	 qahmSTGnL7rDRo8fuXPGiqYAwbQJtomWqzypCCw34SIN+VTGxebTPwt7Q/n2yQALOqm+f
	 gC94S4eFMaETykx6rRdWSQSRifdU1j1Rh1jalRFYfgJyj5fHe/hw0I+1r6cHTL1yq+SXn
	 M4qWOAkbwkeVwExi/KpSQOePOtLEDqzvDy1920wplVIdPY3KzYvjGiD4O/BzJ2CBw2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795247526;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1hYw1g33ZMFOQ7DBwiFeU4k0h/WUx3Md8Zv+IeH1Fvs=;
	b=4xlUUlaDH8LMzuVnMJEa/nt2P19Ebuhnpt7Jmnas+z+5orvAkX7lxlhTvwQhYOb2rXCT
	 DTTIKyUK1BkFoUgAnXHQurpzYYXNKnJBsO9iL4R0ZAGKiXI/6f5uuVct63H2Nq+1F7M+W
	 HUp7lkwOhIT+KiRr9/pc759Iq3flJ7nmXs3MCXBMd3HnE79jM1M2rHuix+xKlgZkuQFZX
	 ovelpR3ENq4x1o8/7o1RYRJFmVhZctBSVLSXrJCO/8HeTdG2T6ef9XjvMUTBRQHeerod8
	 QxPWxXUmWfa5eRC1V0UcBPjBCgGQAfNM3+qTcUqzUCOQLTZxrDLl4g9S/9I7j6QKcKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PVRdbpU1;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0887606A320
	for <ocfs2-devel@lists.linux.dev>; Sat, 21 Nov 2026 07:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0887606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PVRdbpU1
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b09a83d12aso1278203a91.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 23:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795247525; x=1795852325; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1hYw1g33ZMFOQ7DBwiFeU4k0h/WUx3Md8Zv+IeH1Fvs=;
        b=PVRdbpU1HUb+bXHmW8fF7OcJuvg1+m/+9fCPLy2E0xos7K5O4Go38pnYWN/+KcTVgq
         f6T/S8/8C2r9VMMJEOD5bdkaThF2hJFwZIALRm4YvGe8llLmjnzSrXbk+5zjUZ79HAKZ
         7HQweNZCy/VuB3wtd5jYne/8vug3KPZgjqcbKNHbFq7KlhoAs7yKv63E39sNpqq0ox2F
         69PSoQcj7FmJrN9/6aPCNTbhuF84e7fcyg09668IHLyofKuV5humfFDGgekgPkqjgLOF
         xZxIWDN4XGqfmQbANglp/Ctb3Zlw2tlOMVf/qJTLOFzMBYaYmP+mb8KcqUMHCj6nQU9e
         pIUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795247525; x=1795852325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1hYw1g33ZMFOQ7DBwiFeU4k0h/WUx3Md8Zv+IeH1Fvs=;
        b=PO+1b0JQQVlTj3fR/+jWJl0LXeMa8o/2LSLCSrd6tCV3N70MtkNYQzzEePBEBG8gag
         dMuz8kdtgM9Qe1eV/oOFCb4lg1NG5PcEgwe+tZYda8Ll7Jkn382No979a/07LpYkJ97u
         a+jw06L+/V1VAnP1VUl7Fv9C84F9bikk5h4uvFLdLPnqYU6ObadoKIMhFOAVAk+SbCln
         cOJFwvQqYkSUXrwT9v5yrUfgI4wFmpuLd3dfuxUjyNGr27ZD6yRiHJCebp1fb6h49PpR
         1tpou3veo0EJEaGfZqoJ7JkcojJ3hjwWTkrNWQXzBc9HurpsMZ5jRZ3rIR5BguEHArHx
         oupA==
X-Forwarded-Encrypted: i=1; AL+hErHOIeECdHGWVbdJWd7bEP0Wa878q3U+hLHlkwzNnZU/IwuAGeBXz4xgdXVbWO2oYJ+b4XfOdSxw9clY+Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z8q+bLrYOO3J/GqtevwuhzKl9x2SLmSuE7Ac2E5Uec/3H5RJzjB
	m3z3UZLjFAzFxtzx8Z3jaVhsG5cIzfWjs5d+YHw6SwzF4edfiCyuu5hO
X-Gm-Gg: AZFdTZdyvkMC4TD7ZKRFtPPWbk5iWwDp5xS05f9nop0U/Lwd4C80f1dNI2pl/0lhP4d
	cjkqIqNiVt3OE5A4pNxnxRFdGhXvByOj6MRSqL43unALaSFhth9d449EQjWcyBPAIac9rd+AiJD
	SwxaC8tWiirR9NaEUk1PTgtDCO4DBBfVTah/9wELQMLHSCOD9bOmJbO1wM7rA8/pSaAUibubVrz
	4FVm2A+NAEQURYsBZ0mV2bZfhq08B0ULkcc5zXx05BtRxHmeYT7s+pw16JNBdtTwnEu2S4PsJcO
	MN8U/BdSkwvMd0S1G1Lg2HnBrfpXjKtDxOOfHgW8Sk5Ms8f4mrpvzN9WBeLXh9xW7HTALFwBhAR
	jfHfo9p80g7A5sgjkpgbZiBaa6v7ykkycgobY2fKTnWiccc+5zapyhjB53wbbTzlqOc3chyR+Lo
	k31AWmgxujblB0sth7uxO9EEeJJjdKcS+WigDxlgr4byM2mtvrEmmtznrWkebJvmsnA4OxR9qxl
	Kq0nbAVBzoZtIv+U/zfv0u/yPQ/rWn47UP7p7iKxfjU8cSlZX8Yjvyy8pB1wAC1B7YTP2ZNbwVp
	66ZCUmYNxeCj5Cl4c3oe0Gca
X-Received: by 2002:a17:90b:17cb:b0:3b0:cc6f:1046 with SMTP id 98e67ed59e1d1-3b41c9bc517mr5638283a91.67.1795247525168;
        Fri, 20 Nov 2026 23:52:05 -0800 (PST)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfec090sm2401719a12.14.2026.11.20.23.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 23:52:04 -0800 (PST)
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
Subject: [PATCH v3] ocfs2: drain fs_state readers before journal teardown
Date: Sat, 21 Nov 2026 15:51:57 +0800
Message-Id: <pm-ocfs2-objects-candidate-0003-v8-8fb510a5c52b337960c9@gmail.com>
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

The fs_state debugfs open callback builds a snapshot from mount state,
including the journal and cluster connection. The file is published
before ocfs2_mount_volume() and removed after journal and DLM shutdown,
so an open can overlap teardown on unmount or mount failure.

Publish fs_state at the successful end of ocfs2_fill_super(), after the
last fallible mount step. Remove it in ocfs2_put_super() before calling
ocfs2_dismount_volume(). Debugfs removal excludes new opens and drains
active callbacks. The release callback only frees the per-open snapshot.

KASAN reported:

    BUG: KASAN: slab-use-after-free in ocfs2_osb_debug_open+0x967/0x15e0
    Read of size 4 at addr ffff888116a56028 by task cat/502
    ...
    Freed by task 504:
     kfree+0x308/0x580
     ocfs2_journal_shutdown+0x10a/0xc20
     ocfs2_dismount_volume+0x315/0x940

Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
Changes in v3:
- Create fs_state at the successful end of ocfs2_fill_super() so failed
  mounts never publish it.
- Remove fs_state in ocfs2_put_super() before volume teardown so creation
  and removal are paired at the superblock level (Joseph Qi).

Changes in v2:
- Address the osb dereference before BUG_ON(!osb) raised by Sashiko:
  https://sashiko.dev/#/patchset/98583
- Remove fs_state after BUG_ON(!osb) in ocfs2_dismount_volume().
- Trim the KASAN report.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0003-v6-2f69dbb7417fcd537be6@gmail.com
Link to v2: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0003-v7-1522d068e5b943786c3e@gmail.com

This patch was written with assistance from Codex (OpenAI).

 fs/ocfs2/super.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0af2245ae303..2a58d3cd9690 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1072,9 +1072,6 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
 
-	debugfs_create_file("fs_state", S_IFREG|S_IRUSR, osb->osb_debug_root,
-			    osb, &ocfs2_osb_debug_fops);
-
 	if (ocfs2_meta_ecc(osb)) {
 		ocfs2_initialize_journal_triggers(sb, osb->s_journal_triggers);
 		ocfs2_blockcheck_stats_debugfs_install( &osb->osb_ecc_stats,
@@ -1158,6 +1155,10 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
 
+	/* Publish fs_state only after all fallible mount steps. */
+	debugfs_create_file("fs_state", 0400, osb->osb_debug_root,
+			    osb, &ocfs2_osb_debug_fops);
+
 	return status;
 
 out_dismount:
@@ -1555,8 +1556,13 @@ static void __exit ocfs2_exit(void)
 
 static void ocfs2_put_super(struct super_block *sb)
 {
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+
 	trace_ocfs2_put_super(sb);
 
+	/* Drain fs_state opens before releasing their backing state. */
+	debugfs_lookup_and_remove("fs_state", osb->osb_debug_root);
+
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
 }
