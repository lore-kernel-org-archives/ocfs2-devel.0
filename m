Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBE51B86E2
	for <ocfs2-devel@lists.linux.dev>; Thu, 18 Jul 2024 02:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721269133; cv=none; b=kHeVGM8HeU8Wjuj03vVcaG6U+CKrnLOqO/Z4cbqI8yF+5oMmtHZsIFsp7s2pEIqxFSKLDBav9orEFPXaqNNXGBvcFBrSG6sz4YWW2a41izXm3HCXdjS8rverm2+KhtMEECXCdqY+auWERBiE1VN7PB/vdd6kk/r+AOhTzsQue3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721269133; c=relaxed/simple;
	bh=Pe8RDf5KpNhKgfR4NOGPiLU7U9n9YY7R7NwxrjWyWsI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u+4mPkcKovkpSF7tbDEiDmHtx5E+0d7ujrhe6HMaAm6B+0CZVrM2ppZl/m9UTFPug3vI2zXRiqEK0TqvQnDL+o26d8+ez8HQkm+vLQmn2HdPwHf8GI/0CWBLMCIoL+U2S1trDLPlLgmzGktDEDL/Akzc8DT3RZk9liGsNoNysDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C79peuDh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C79peuDh"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4266ea6a412so2112485e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 17 Jul 2024 19:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721269128; x=1721873928; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o1/368pn/P7/V8ee6l4LzdKxPJYnev8uC2a8udRSFmc=;
        b=C79peuDh294KHAQy3GHr1bh/zjttZb9sZWe6Oy1Mak5PrQrW/qffyQ7d9Ji/7JPWzd
         kl4hk1ZRZX3vkpz0n10e0IyQR0ELhT8WmaZ/8CvTjzapgDNzlBPh5lCeTECY5+cQvPMF
         yBn+yei/ah5l8XhcoSjN3Og/zU2Z1Q6myu+YzaqK5Jd6zQ1aMhgIn1Q1CIsnUKcNFtmk
         YYWKBbYu2FP+HLUFa3Rnh59GKGfzDck3CozKibR2ktIK2OC73pwgL8WvF45FUaiIhq6D
         1oadn/TRdY3OeCTqZTumsfXSu9o76Li8Qxh7JDU2uSJAymJd1Azs3OhJyEDCmx4OeUxP
         L4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721269128; x=1721873928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o1/368pn/P7/V8ee6l4LzdKxPJYnev8uC2a8udRSFmc=;
        b=nXxH82nGGYKRf6VrMImxUnxGWOm/SiUbErbg6GDNHA5yG+O0B/xNlLyecWreHvxk1Z
         UWSCtlA11M3xYEdHb6Q/UxFgMHbyBLxRpc+ybkzuy0ypUwVgeb/jRxuHkAV4xhDFwqbB
         Rftwg5ss4OpnkjnQh1FwWRGX+T7Jf/pIS+CY5vWQDJMywOVFERNWZCuEHapHu5ZpgQ+b
         EeprgNf2YsHXbPUZEO6Qc3uUmt7++su3IpPKdRlr5IUo3M9cAp87QRPEwcl66DNhGoOp
         ZQ1te/uCA1lgloR2r+lwS350z9z6GN5EdLxP5Q9g0CTIPm9biVTWw9uyjFoIVR2mJfnV
         vwLg==
X-Forwarded-Encrypted: i=1; AJvYcCXz47iYul0SWJ3M230de1gvbqFi68iToAvc2tVLXBR8Be6QTT0a+IGzzsYSFcvRPLeutn/l68vS5AvmQrfTgUwyIGUCTnGRbywTVNk=
X-Gm-Message-State: AOJu0YwGX5dPB1ziE/HYs3bKqNdMlqhcicUKeqESqlpci30FpBWdcNHh
	0C6DRwPM3ren4qTOFCAFASb8Q3UDqYiHuTWsPK4WGOgeToPH0Azl4itM8xoKTflSksYW3A918r9
	K5VOWlQ==
X-Google-Smtp-Source: AGHT+IGwYYRa19gRjIfY8Mxfxh6CndEYa6yjXlaNpkv+tBAdQPcwM4yHGCUICme4kBxZ0EOsCPixZQ==
X-Received: by 2002:a5d:6091:0:b0:367:8a2e:b550 with SMTP id ffacd0b85a97d-36831791e90mr2013214f8f.60.1721269128608;
        Wed, 17 Jul 2024 19:18:48 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fc0bbc32d9sm81485535ad.111.2024.07.17.19.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 19:18:47 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	glass.su@suse.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2] ocfs2: fix the la space leak when unmounting an ocfs2 volume
Date: Thu, 18 Jul 2024 10:18:42 +0800
Message-Id: <20240718021842.7595-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This bug has existed since the initial OCFS2 code. The code logic
in ocfs2_sync_local_to_main() is wrong, as it ignores the last
contiguous free bits, which causes an OCFS2 volume to lose the
LA window size space on each umount command.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
---
v1 -> v2: adjust 'if' condition to make the code logic more concise
---
 fs/ocfs2/localalloc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 5df34561c551..8ac42ea81a17 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 		start = bit_off + 1;
 	}
 
+	/* clear the contiguous bits until the end boundary */
+	if (count) {
+		blkno = la_start_blk +
+			ocfs2_clusters_to_blocks(osb->sb,
+					start - count);
+
+		trace_ocfs2_sync_local_to_main_free(
+				count, start - count,
+				(unsigned long long)la_start_blk,
+				(unsigned long long)blkno);
+
+		status = ocfs2_release_clusters(handle,
+				main_bm_inode,
+				main_bm_bh, blkno,
+				count);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
 bail:
 	if (status)
 		mlog_errno(status);
-- 
2.35.3

