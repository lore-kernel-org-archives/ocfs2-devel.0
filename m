Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF3E3314C4
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Jun 2026 21:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781213716; cv=none; b=F4SyXE+hDqoQ3j1+I71snN0DJz3WMswyzhpyi6kkNiRlJEbk2Uy5+tNyaEEv7/HSe6c8BFSXFPNdvgxQJ51qRo3O4lF7xwv1nL6Mi7LtxDTlmJZ7OdNKtKlPpixng/dMju2N6RGbTI3NDU8l5UL+/dSlLgU321/VJjslZXjNdw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781213716; c=relaxed/simple;
	bh=hCyXATFj3Ov2wP2Dil8MM6YMgb5iJIzEMzEDy0jTzog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lBJ7xXzpH86jN4yT0xgdCxszw1ogieFBfq6+i9DTUIzjJ+WCC1kVgf8ym+oga0QIKndHrk2hE0UPIFE891gPfOm2DPDRBCbqtov0busekF97NYl3PlYglVT3FnY0mvV31IeLOglRY5A8pHAHFDm2UUF6qdlHHm2cvBSQM28b/GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com; spf=pass smtp.mailfrom=openai.com; dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b=YQJ5AtDV; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b="YQJ5AtDV"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9158643e538so32294085a.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Jun 2026 14:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1781213714; x=1781818514; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FyL7MLnyi7BSEFK2/5LnuQPeRqNUYzr49gk95R0WT30=;
        b=YQJ5AtDV+ywwTnMYe/0RHoouSsJ7i+rr7j/34O2Nnk4k6RDWbC+eZSN93KTaz/mVq3
         /Sn8pm7akfyf60h0NquZEWhoojEPXx3PdEIVcyI0busIiEWc/3KOeGAfmhAZKBLQppCQ
         qFknzo+KxrHiMDteYLaoG6+tGZcLD/cHOOqLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781213714; x=1781818514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyL7MLnyi7BSEFK2/5LnuQPeRqNUYzr49gk95R0WT30=;
        b=XJXIZWOf5DbEjBQEAQdUUFFW+RcXXbuAlTh/b6O/YjQiN9xAFlXnjKnnFTJ+u0G0sk
         bVVzTRNbfi1vkM0/orrGojZdU0kFMHBMyuQdLEeakTZ/Rv1VJcYrm8veNseFBXu0Xxga
         9pXYQv2kL/RtEzwqjL4rW8p1P2sLI8XNCRSg+jZ4aK7y/f6oyLs2CY0D/tmEvZ2gVhtJ
         Pdew36n+30utd2tpPP0oIGxqqQF/RGdjNHWYpp3E5iqc4oLB/NAKIx+6jUErzJvyeWBk
         sTdwrg2qy+lyExFhgcEv/3k+RoPDW5tHINk1OMhXQ7ku6M/Dt+xfs5ICh8NuFK1jmmUr
         BboA==
X-Gm-Message-State: AOJu0YyOXW+GVbalwmipkLlWlk+D2FpMnkECR57kSaTGDwiL2HMKs3pt
	KREoMsuPDT0LE1jSBCdYL+0lhNa9DCsKj6xjNHwp/g0+srNEV4tee5KD5UHZLzkY9IOTpULI5Jg
	HD4gMFYc=
X-Gm-Gg: Acq92OHjrxUA4QFN83F8aSiFq+2LPXLAzDErFHCFivo6SHfnvg9CLgH+51/1pmVVHiX
	RfIubiNFKmhkP6RsDpZNZ2kAL4GXvRw/2ZZqqlNhqY9XvabZPmw8t/dJYzxJAstI0ZeSZXg6XeG
	dtCOnYX0+QTIHSB0UjuPA0f6fQkMjuKj9UgdVbrBD+GMdCE5OdPz27D8aKjmdjQEYg2KDiKJDcl
	tmgWjWwsBtxkUjbEmBShKKcQOPYaV+uv4QX0pdhrc6DIJp9kSzAmCoXxG45vvuw51a+/YYl6X6J
	nryMYn3WFFNi8mAChMAgmQHKEf0hNs/bNYtDFR7pRUJSi1nQM9+zpZDUO1YBbtD8IlZ+gdVUhMS
	LqxtRmXUsIxvB27TUn3a9ZZEheGQi0XLSB/lCQNU0aeYR/wQat4i5c12bCNSyH+Yr14T77PccS1
	r+VmjCEka84QmIFVowDxuLHMBv0eipZrBuE0O9d4vBs15m520sEXTsB5D2S+RgSS0ilrNdg0/kX
	H0Jh8QXnLL4QcWX80/vtwMI98tmoJFYFVc=
X-Received: by 2002:a05:620a:8017:b0:915:89d4:df0f with SMTP id af79cd13be357-9160ac96084mr730469185a.2.1781213714230;
        Thu, 11 Jun 2026 14:35:14 -0700 (PDT)
Received: from com-75606.node.ndb.openai.org ([209.249.37.146])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9161a061028sm27194985a.42.2026.06.11.14.35.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Jun 2026 14:35:13 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	outbounddisclosures@openai.com,
	Kyle Zeng <kylebot@openai.com>,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: avoid moving extents to occupied clusters
Date: Thu, 11 Jun 2026 14:35:10 -0700
Message-ID: <20260611213510.16956-1-kylebot@openai.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For non-auto OCFS2_IOC_MOVE_EXT operations, userspace supplies a
physical me_goal.  ocfs2_move_extent() initializes new_phys_cpos from
that goal and expects ocfs2_probe_alloc_group() to replace it with a
free run in the target block group.

The probe currently leaves *phys_cpos unchanged if the scan reaches the
end of the group without finding a free run.  An occupied goal at the
last bit can therefore survive the probe and be passed to
__ocfs2_move_extent(), which copies file data into a cluster still owned
by another inode before the bitmap is updated.

When the probe does find a free run, it also subtracts move_len from the
ending bit.  The start of an N-bit run ending at i is i - N + 1, so the
current calculation can report the bit immediately before the free run.

Clear *phys_cpos before scanning and use the correct free-run start.
Callers already treat a zero result as -ENOSPC, so failed probes no
longer continue with an occupied caller-controlled goal.

Fixes: e6b5859cccfa ("Ocfs2/move_extents: helper to probe a proper region to move in an alloc group.")
Fixes: 236b9254f8d1 ("ocfs2: fix non-auto defrag path not working issue")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 fs/ocfs2/move_extents.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index c53de4439d93..ad1678ee7cc4 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -534,6 +534,8 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
 	u32 base_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
 						 le64_to_cpu(gd->bg_blkno));
 
+	*phys_cpos = 0;
+
 	for (i = base_bit; i < le16_to_cpu(gd->bg_bits); i++) {
 
 		used = ocfs2_test_bit(i, (unsigned long *)gd->bg_bitmap);
@@ -555,7 +557,7 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
-			i -= move_len;
+			i = i - move_len + 1;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
-- 
2.51.0

