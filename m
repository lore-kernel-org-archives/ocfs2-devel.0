Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795425579;
	b=ZcONwifpWlKYwIkeZmXlhMD8kNIlfv07yzZaeM4hhRJdpLWrstmD6x78saHgRFBljH9j
	 fbheFV/XL0RIhdZQPzxc8/5zf6Xy0XkmoYkZ+RI0bna/eKyp3ILYEnTr6tBRBnOvcof0v
	 COPXYQioyRU6PbKyZersDT1Q+vVjkdACCAhvsLpRh678ojqisy9bvdnEmEFVpn5yJUrD/
	 WqLp6l0vEBikcCAPPQiaoz/Df66UOOwkym/C1eC8qBa3fEtmljrkdiZs/yaCVNmuj2Pgd
	 RMaypdin9b0EI4af6ySj4iJNJ8NS55nDyt/9MKtkOPgrYM9WZcSlvXOS+kzNx97Yuaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795425579;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=w4eBVmv0cgiAo+f4muzjsPkDg46ilkFNyKsWRMKGZus=;
	b=WiiXFBXRGjhxO/3kgwzH0IGIUTOVg0Z0LRNetnR/JtGt19pw3vUO6QIsv7Dz1v362Y0g
	 qqunP0hrWJeBpIflJp3Tbhu2GPZxEkGPCWZdX96i28Syvjkm/MjtY2Qb2w8DzNcUBzITw
	 PE5NK24tFRiaEVrSL9ExEms6CGJbmOGZmucBuabZkFGtG5N3GbjfZm5/SONx84seNlw5W
	 Xv9eJBoXiP2ioLVw9NSY45oNECqqruyltVymE0dtzQTDSzC2E9/WMJTDzXTUgrqqW8BED
	 Dx+a7qIjZR6G3amBLqiktkqzM27mupQav2ZwCGOXJ6QZh7zlrr7/v7DSMr0mqlPASng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dMgU0be6;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EA5606A31E
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 09:19:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49EA5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dMgU0be6
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cd6acc50b8dso1472388a12.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 01:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795425578; x=1796030378; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w4eBVmv0cgiAo+f4muzjsPkDg46ilkFNyKsWRMKGZus=;
        b=dMgU0be6EQ7Gm17xZRgLFwwU4HIOidNwPjTZo/4fdcv8VG5+Nd51EUEZRm//mWmpXN
         8ryW1BErT2PBWAmJgHT1hocbwfHxuU0+IUUHbboTqAyNMeXCZaIyKGzqx2fjmNLjc1kM
         jRUsbzj/xsyQc3RcMEggtdTe1YHhYhev2hTLxhW4ybW2YhQGaedSTG1Phmi51MYhk4kf
         H6nJSxnsPHIU44SCISctDCycaKhIL/VRkd+w50QWLO/dKWHt0EwZRaYJGf+3UPA6+WRt
         HkTqHphXhByvtqeHjHyTXzy0npMShc4v4e1xdyV5GIxslbNEF9aVcaSw776gieZXIS6N
         CfKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795425578; x=1796030378;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w4eBVmv0cgiAo+f4muzjsPkDg46ilkFNyKsWRMKGZus=;
        b=BARnzdttmSurdUov/Er3zLhg8kaXXvq7CXUzHHQypDbxmDvLzcVh558d5M4y0/cLi1
         kF3KqJu9DLNR1Zn2EktIyvtd6W29Od8K2l+IWxpAy6/2PN1ii/T1Y/5unOFvjJlj69yI
         nNIWr3tOAVTlljIWmhD38xpGhA4B/BYLyVegdLv8uv/l77mYn570QkudHl3BeNWQLxOF
         y2/tdZiqy4TCYMNQPIZHkkGAioqAcZW36AmCR2QkQaROMXEEYUtthDVWcI44lyueeH5q
         OptmEoyAM2eas6OjT6BbJvuLB4hMfgxIz8ZjTx7FrXZBibB/hsA537iRd3fuX70ueFxG
         NeTA==
X-Forwarded-Encrypted: i=1; AL+hErGzxtbqTb+lxhCMHba0IuBUqtsq66jdIzjAukkkOK+hGdP6hKWlhjijS6IbKFRnCZJnDxjPynTiYIS7Zg==@lists.linux.dev
X-Gm-Message-State: APuU4Z81IaBSqMlF81mQClupqtGpDNrljqBChs4R29bgunZMlWXHV2UB
	zQxrHk/t8BSt0XaKQFydBipJuQs7+HhFQITx21dcflRbNeNP6p+AEGUZ
X-Gm-Gg: AZFdTZfpKUtK8xnItkj99wLqoCebAGiFsfMoZTgas/ztZFuZm46+/u5LkfplCiIcOL5
	5w+CP6sbNjN8ngplq42eAq7k40ADbgGdbhk3NCU/n9coh+6beB+QeMadEQ9Kz6SkiGRwmVKIqBm
	23w3O2NEOJVyJ2eKXdL2Q/g2gV8n8rsRyoQRhjE+OWI+5AtyXvgQ1/oZpbR9qgVHqrIACfe8Oqv
	OyCZbUJsWt/T5jOUvUv9Q4ObBOtw0R6dM1WXy4XhBuhGxTONn3+q44DiN5KTyBE/9LtNRpPuyNW
	8iQ65krbvjmwI3JBb+BZ8Lj+2WnRbn3pVdTfYUS6my/6VMgPAr3GB/dS7ssR+emwAz+Rfkh9ld3
	ucDlpDy211TTqS9JOV64qlqf45bSUo+IKQEQMbEoEv5Gxx8zym6tJa0LfMkk+0HrgK5htQ+T1Uu
	6Rx200OQrH1Xo0WjNLXl2t2oL0ihicnnWFdtkpH3j2wOEmxsW8tra2h64kZdWA6Ey2bx4GVOkSn
	AEHo8b8RABW/3Q25xI/ZCAaS+0M9PefDwrJ+p1seOiif459vy9QMi6rpG/783+ZrpCFG8xndUbX
	37HRxkiuPU+ampVo+Sd9bJnoTP0DJA==
X-Received: by 2002:a17:90b:1f91:b0:3b4:1cb1:e7ae with SMTP id 98e67ed59e1d1-3b41cb1e88bmr11170233a91.45.1795425578378;
        Mon, 23 Nov 2026 01:19:38 -0800 (PST)
Received: from thangnn-ASUS.. ([2a09:bac5:d452:16c8::245:e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d97356sm19617738a91.13.2026.11.23.01.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 01:19:38 -0800 (PST)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: don't destroy the jbd2 journal under journal_shutdown_sem
Date: Mon, 23 Nov 2026 16:19:33 +0700
Message-ID: <20261123091933.42057-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
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

ocfs2_journal_shutdown() holds journal_shutdown_sem for write across
jbd2_journal_destroy(), which frees the journal's shrinker and takes
shrinker_mutex. ocfs2_clear_inode() takes the same rwsem for read and
can run from reclaim via super_cache_scan(). Lockdep reports the cycle:

  journal_shutdown_sem -> shrinker_mutex -> fs_reclaim
    -> journal_shutdown_sem

The write side only has to keep the journal alive while
ocfs2_clear_inode() calls jbd2_journal_release_jbd_inode(). The journal
has been flushed by then, so inodes cleaned up afterwards have nothing to
release. Detach j_journal under the rwsem and destroy it outside, and
make ocfs2_clear_inode() skip the release once j_journal is gone. The
lock now only covers pointer updates and the final kfree().

Reported-by: syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=38fdbb551940270021f1
Fixes: f277230d002d ("ocfs2: serialize inode journal access with shutdown")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
Tested in QEMU (x86_64, syzbot config) with the syzbot C reproducer:
without this patch lockdep reports the circular dependency on the first
run; with it, 9 runs (3 boots x 3) are clean, debug_locks stays 1 and
journal_shutdown_sem no longer has shrinker_mutex or fs_reclaim among
its forward dependencies in /proc/lockdep.

 fs/ocfs2/inode.c   |  7 ++++---
 fs/ocfs2/journal.c | 17 ++++++++++-------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index e225a96d37535..8a26964472521 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1320,11 +1320,12 @@ static void ocfs2_clear_inode(struct inode *inode)
 	/*
 	 * ip_jinode is used to track txns against this inode. The journal is
 	 * flushed before it is shut down, so an inode cleaned up after that
-	 * has nothing left to release. Hold the shutdown lock so a journal
-	 * found here stays allocated until the release has finished.
+	 * has nothing left to release; shutdown detaches j_journal first.
+	 * Hold the shutdown lock so a journal found here stays allocated
+	 * until the release has finished.
 	 */
 	down_read(&osb->journal_shutdown_sem);
-	if (osb->journal)
+	if (osb->journal && osb->journal->j_journal)
 		jbd2_journal_release_jbd_inode(osb->journal->j_journal,
 					       &oi->ip_jinode);
 	up_read(&osb->journal_shutdown_sem);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9c4a48887c9a3..2529138918bc1 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1064,6 +1064,7 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 {
 	struct ocfs2_journal *journal = NULL;
+	journal_t *j_journal;
 	int status = 0;
 	struct inode *inode = NULL;
 	int num_running_trans = 0;
@@ -1076,10 +1077,8 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 
 	inode = journal->j_inode;
 
-	if (journal->j_state != OCFS2_JOURNAL_LOADED) {
-		down_write(&osb->journal_shutdown_sem);
+	if (journal->j_state != OCFS2_JOURNAL_LOADED)
 		goto free;
-	}
 
 	/* need to inc inode use count - jbd2_journal_destroy will iput. */
 	if (!igrab(inode))
@@ -1116,13 +1115,17 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 	}
 
 	/*
-	 * Exclude the final JBD2 inode cleanup in ocfs2_clear_inode() while
-	 * the journal is destroyed and freed.
+	 * The journal is flushed, so ocfs2_clear_inode() has nothing left to
+	 * release. Detach it under the lock but destroy it outside: freeing
+	 * its shrinker must not nest in a lock that reclaim takes.
 	 */
 	down_write(&osb->journal_shutdown_sem);
+	j_journal = journal->j_journal;
+	journal->j_journal = NULL;
+	up_write(&osb->journal_shutdown_sem);
 
 	/* Shutdown the kernel journal system */
-	if (!jbd2_journal_destroy(journal->j_journal) && !status) {
+	if (!jbd2_journal_destroy(j_journal) && !status) {
 		/*
 		 * Do not toggle if flush was unsuccessful otherwise
 		 * will leave dirty metadata in a "clean" journal
@@ -1131,7 +1134,6 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		if (status < 0)
 			mlog_errno(status);
 	}
-	journal->j_journal = NULL;
 
 	OCFS2_I(inode)->ip_open_count--;
 
@@ -1144,6 +1146,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
 free:
+	down_write(&osb->journal_shutdown_sem);
 	/* Serialize the removal with ocfs2_ci_fully_checkpointed(). */
 	spin_lock(&trans_inc_lock);
 	osb->journal = NULL;
-- 
2.43.0

