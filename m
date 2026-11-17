Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794927522;
	b=CqjQ3lnvnhRciUaWzwBPmylZgHm1PuTMkNYdrH1oMwtvsr2tqmdafxk20hxTQQn8LcuJ
	 GMqMJD74s3gCxJP6FmWw/YoEMgEhIWMm84A4HFHpYQ5UxRWfdztvocXooCz9eyKRZeJUW
	 j0UTNdoOvrjUBtSZSbfikSOCyrKKI4YUTZRxRwQ4ZKigc1DG1Spfr/wOFoY0MSBOjm8sN
	 QB4RHbNFIK9GCUslIfjq1IjebtakWmx1WsOOSCwDxaNNqwlHM7S66eYsfXzQxwbs7spg8
	 ovcalpp0bwQkqLb3YPB3SvTXOZviMc16NFDU0Zo8PtDuq8lybp9UPb+goThlUgYs/lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927522;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=j8h+fbCcAHktdAk9o4fEVE0qSmIF6dWv8V2qc2pMyUY=;
	b=LOxl31JCuG8NPhpMkdkZ01I95ucq97dMOkJeekdKLEqgFMAjQnGXx65Ng6B6Izw9C07X
	 oacDnu9GQv1S5l+DLztZqjqV1zNSpN5so1SYkUjYuA8bLe70lacFkUP+3jtwGedKqsCwm
	 WNbR8X8PLwCmONCc1dvTps77IsqQt+zTQCbKNa/q/Pj64svHBjaa4mHg9UH5X/bxx3Qnv
	 saM2g4VDGvToJPqTkbev7gt84BGsvlx0NZdFAnQ1Q2+RM/TyI8kcaJmIUlKLg6hhI07LM
	 jLI8jUCY+Cb2hvxYe2AjCJg+zXBF+8Cej8M/aETaDWdEcZt3vEE5IlNBBp/gz/9pFqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tkAjMR1D;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D50606A32C
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 14:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95D50606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tkAjMR1D
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-49a92144733so1976069f8f.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 06:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794927520; x=1795532320; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=j8h+fbCcAHktdAk9o4fEVE0qSmIF6dWv8V2qc2pMyUY=;
        b=tkAjMR1DDB+bF5iZbPURo1gZ/ZZOSZnPSsKnSuqf1svVl3uxILP/pKPJ1DD2ol/8v2
         77J+f1U4rnEYETpYX15/UBfTkOxgog7Wip+5UJifim13oiZHrn/vDuhyaE6nrHLOKg3D
         lVRkhVIsfANTdyN0RsDAohnK9Xwvw9F/t4YusfqykJ0+tA8uDYqjr+BL5SxArG9Rvyll
         gOPsdFe0EIsYpN+hrV+oC6qiUZUzKEucCL2L0DBDEepjk/rRbMLh/G5tjKcCd4dRYUlm
         HFX3fnKT/RLMhmYeqoALjP9v7rP8D/mczRyWeJnxuGkBpRcFPU7/yf8TadPqvIlPlEFC
         iaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794927520; x=1795532320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j8h+fbCcAHktdAk9o4fEVE0qSmIF6dWv8V2qc2pMyUY=;
        b=GCqVfoULF2VMeA1S4yChkq0+ggd0hTWfb9z3IvES3ujKKlC6gNEr8OaPBtqQum/25i
         AAPChehZh7oxdvZg8e0p3negzqkbes91KnIvLiH1lpE9BkjAjcMFumYHF9/JqWHDGFga
         UQHD9ZDKxkzmTXnztb2J3TElsMuAuZpwCegD/NICoZDjZ/UNmI/hwmIFgSraTfcaiBTI
         znMz40kKzJrWqemnoskLF0WR9wPrjJQqIoTQsWXFh7rCQg0DDiWGf+32cSydb5HOpxyV
         bR3JwI6+QDiL8PZt+sYAak/OxE3BtrGCLKrTa08Qnz2Pxo/QatnMDsirRQpRNa9Srg8/
         CHDA==
X-Forwarded-Encrypted: i=1; AL+hErGu879aLPSVrgKsSUMj7988I953BD9Lv0zolDPBZGC+6GvHbPTU46nZ8nGF2ip290ESm9VX1uvl3oToFw==@lists.linux.dev
X-Gm-Message-State: APuU4Z8p5jG89qkHh3l8YRJS0LwcmFXyki7d7qA/WlGuJrJBnHKElLGM
	a1n67HwWXku78a/9eu52mQD1RjRJjEWDVgSvwJTpesRvGtL4iD6cxNEO
X-Gm-Gg: AZFdTZfbr7obAjOu5iKkkD5Xn4Cl1kznu5AIQxghw+P0r8bnVfHcU9XdCMXG/67qZ56
	52e+0aM0nhQkeMdjFMhGMdac9NUXYok520Wu2W4iG02KcRI7sAckGaKvhf0zKXc3FCtW/p+hPk7
	sMsVVuL8hZc8OBH/jBbEYe/I7B2Ib0t9vZXcWhrDzm2rbwsth4kZLB7TrI/oB6JhK+4kURB5AJ+
	3Gz+r3+Zv+6i09yFYew30prWdrseN7oRApAtTI+Fr6E5Bi8YJzWVlarH0OryZqUY+do+ecRc8WO
	hkz6xb/trTaDfax75GyE7/yejvXvSM9eorx7SPFPBXi/ltFfgbKC+loUrJnvDZ9y6arEFq9CX+8
	QKfTtbl/X6QLcwBAacsxjVuxuZdDshGZ3026uHNV75Bf42QDfbuzUyC1f0dIH8RrvmF7U+iHMJQ
	LvN7a9rw1FitIwMFQwtr4/adukns4cDhN6ZRNscVyCj8wfBjHvfoESy07y21K5eQ8e/UKa2E695
	1YfYsWFzosXWr2xFytP5aZ+0EXyR7rH86tK5l/AHSRNARahYXCBGPrEDnFderMur9WXiwxU8CVe
	IoWJN+85+7QDvsi0p8R/ZUmGjDBmkKT9hg567KN/iuVK1oRxJrDKATsRLnqCO07DGSBEt2pv4sc
	pywsoaIdKZNfllJQ7nqwqY714HsUAtRIFR6aUV1ktFg==
X-Received: by 2002:a05:6000:310a:b0:48d:ef7a:e59f with SMTP id ffacd0b85a97d-49c712ac8d6mr31599361f8f.17.1794927519691;
        Tue, 17 Nov 2026 06:58:39 -0800 (PST)
Received: from localhost.localdomain (cl-hedp4-wifi-nat.herts.ac.uk. [147.197.250.34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c604ee47dsm28996090f8f.38.2026.11.17.06.58.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 06:58:39 -0800 (PST)
From: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
Subject: [PATCH] ocfs2: fix local_alloc_bh leak in ocfs2_shutdown_local_alloc()
Date: Tue, 17 Nov 2026 14:58:30 +0000
Message-ID: <20261117145830.59864-1-zhiyuanzhang912@gmail.com>
X-Mailer: git-send-email 2.50.1
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

From: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>

ocfs2_shutdown_local_alloc() owns the buffer_head reference stored in
osb->local_alloc_bh, but only its success path drops it: after clearing
and journalling the local alloc inode it calls brelse() and clears the
pointer.  Every error exit after the local allocator has been enabled
returns with the reference still held:

  - failure to look up the local alloc or global bitmap system inode
  - ocfs2_inode_lock() failure on the global bitmap
  - ocfs2_start_trans() failure, e.g. on an aborted journal
  - kmemdup() of the local alloc dinode returning NULL
  - ocfs2_journal_access_di() failure

Nothing else releases it, so the buffer_head and its page stay pinned
after the unmount.

Drop the reference at the common out: label and clear the pointer
there.  The success path has already set osb->local_alloc_bh to NULL
before it reaches out:, so nothing is released twice.  The reservation
path is not affected: it takes its own reference with get_bh() and
drops it in ocfs2_free_ac_resource().  Also mark the local allocator
unused when the buffer is dropped, so that a NULL local_alloc_bh is
never left behind with the allocator still marked as in use.

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: Claude:claude-fable-5-2
Signed-off-by: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
---

Notes:
    Testing: QEMU (x86_64), local mount on a loop device, kernel built with
    KASAN, PROVE_LOCKING, DEBUG_ATOMIC_SLEEP, DEBUG_VM and DEBUG_LIST.  A
    test-only pr_info() printed the pfn and b_count of local_alloc_bh on
    entry and exit of ocfs2_shutdown_local_alloc(), and the page was looked
    up in /proc/kpageflags after umount, losetup -d and drop_caches.
    
    All six error exits were exercised, twice per boot, two boots per
    kernel.  The ocfs2_start_trans() failure is the real one: the loop
    device is shrunk under the mounted filesystem so that jbd2 aborts the
    journal.  The other five were forced with a test-only knob.
    
     - Unpatched, 24 of 24: the function returns with b_count still 1, and
       the page is still allocated at the end of the run.
     - Patched, 24 of 24: the reference is dropped and the page is free.
     - A clean unmount frees the page on both kernels (8 of 8).
     - No KASAN, lockdep or other warnings on either kernel.
    
    The leak is one page per failed shutdown.  kmemleak does not report it,
    and neither Buffers in /proc/meminfo nor the buffer_head slab count
    shows it.
    
    AI assistants were used to find the leak, to write the patch and the
    changelog, and to run the tests above.

 fs/ocfs2/localalloc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 82d290cf4432..d8d81cef92fc 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -462,6 +462,17 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	iput(main_bm_inode);
 
 out:
+	/*
+	 * The success path has already dropped the reference and cleared
+	 * the pointer, so this is a no-op there.  Every error exit after
+	 * the local allocator was enabled used to leak local_alloc_bh.
+	 */
+	if (osb->local_alloc_bh) {
+		brelse(osb->local_alloc_bh);
+		osb->local_alloc_bh = NULL;
+		osb->local_alloc_state = OCFS2_LA_UNUSED;
+	}
+
 	iput(local_alloc_inode);
 
 	kfree(alloc_copy);

base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
-- 
2.50.1 (Apple Git-155)

