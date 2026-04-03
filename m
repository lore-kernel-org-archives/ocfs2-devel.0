Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD8C309DB5
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 06:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775197842; cv=none; b=EbWrG0l9WJlUKhgNBbh9WXzCXKAVQCYT8GFbbqd8c24Te6VDJ2IRn2v2PQ2lOAHjK8z03fSzwniL7ZkEJjZsdRsK/nCWvEkK69bhAbVrPe2mAq754i9Io/qpijlesAl5y/+/kn7h78hbvMfVu9lxIfgQ+iQ1zJfrEz4V5l9bDnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775197842; c=relaxed/simple;
	bh=I738XkaqIqPAyrdvIYFc4W8KtajTj0G8CTgJ5jdeTeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5ndrghHT93TfqkpLkwm64jdonrTTASreXMH6f5lzH4m39uPZKNcY1ClPhnf1Pgc6fmTjbLWQe6BQGES9O7vUOoD9/uPJoOM7AaIIRnWQ5QH7B6SFjVtFgWrVD4Nsz3WXUqHLJ24S1vk2OGVaK9SoBPduLnYC8JtXb52q1FYplQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JM27wI3g; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JM27wI3g"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82cd6614a90so711620b3a.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 23:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775197839; x=1775802639; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Lspt40Zh32RiqO+NgTw/2WuwWFH+RhU3yTTqojwbEg=;
        b=JM27wI3gbxCtFyKgHEOzT56yPC23bSMZoIpeSpu9P97OOxmy27J14JSgJde7rN/wDG
         iraIO0P9qWXVjpdwAhf6tNPwRObaol6/6o0o0Av9Wuh8rtdStpYSVBMhP3+LV4vyJdSx
         koaEjbxCPAaWdVaDdNSZdNpHuUiytdLkOOt//idRX6yjeBwKNpoB0sp5u7I+1x+V9O5G
         oeSXzySLfEKzVw+g2mHOXb/46RCjVo0Ae4SjOvHsQFsfFrQyX+m5eM6BtEsrujXQFSPn
         qDjB7uVXbwZU3uMwl1eMYlYaiRnN6o8ql/HuTwcJv6Tf028+wkxqjNucK9PauohU6CME
         zjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775197839; x=1775802639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+Lspt40Zh32RiqO+NgTw/2WuwWFH+RhU3yTTqojwbEg=;
        b=ejLB3Wb7omoh+SulzemwOMajThrkvrCMe1nVPQ3DO3cpCVGQ17lE4gs+uK2FkZMfka
         6CQoy5Y8vdWp0chCcT8nHz6A3Ps30EM9cRMbIs/Aqft/8Rh7Ij+vANa2pSGCwaYxJB6Q
         lRaxcjst1n54WYZJTCiXzZyKOwD13vo3QzkcJ2fXiYcHalmZwKD5OxxaXzw52lKGVsRg
         t2XQi25Eb2TZALfpbXaHSNwsjgRa+5Rh+gboz4GXQZLske3TmbxRZW4zQytLB9R4yUpp
         P3QS272QYp/PDwRMQgvQ9L8qm27m2ZQGTKc4JvlUrAdioXl7cbUS1UDeOTglOghOfVYo
         U4fA==
X-Gm-Message-State: AOJu0Yzb+JHDfBtUW/7ksZ3Gw35VBGH5qy088sn771YiRiMDLWVPt2O9
	xS9wtdQoiJWhvQ5yboaj4bQ+CrEa+yvDl5nK0vJrirlpx5yjh5Yr8afU
X-Gm-Gg: AeBDietKbFOz+EicLX8t3jHMnOcxMFopEBL2DjDLk6fe2Jghi1yw8PqQq+tOv8xIYyI
	rhL4XdQU08YiO+rvn5LMYbiGQOUpe+3tBSHbGIxQsBHOdTiJvFUG2Sgbg+nmDNLYSNKpp8OGQAl
	luN6Y54rctnQtYdxcfaywnf0yFp3EdOQdnPbVdGsSzS9HkGUN+doAx6ej69jOtkMFtNccUFUcAi
	Rc/ptagFqUoO56ny2iDdAgMglwv0pmBtTANVtfw6mNz7AAi0nfBthFqDgiPyKhphOL+wvIFVDXh
	5U/6vdN/nJyOvURXWslqistFdVx9ErUJ3eeZIlqRjwxFuP4415mSFI/vkpWmPXL1L6U5XRdHXRN
	oTviCF1bQIopAI1Uw7zznzZ6VbG9ILahmpfeJXdI+Qz4XLA0aPNgJ3Tdwlog8RIeDNVmXrDdqZe
	PlaaFhMaELDvoKvjjyGibFhGxk7/du1Iha+/jbWNeJvYT34zSX4LhpIZnT+S6KCzKiYgsYDENUt
	BOVCQLHGA==
X-Received: by 2002:a05:6a00:2d10:b0:81f:4884:4fed with SMTP id d2e1a72fcca58-82d0da44a86mr1882118b3a.7.1775197839328;
        Thu, 02 Apr 2026 23:30:39 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c41b8dsm4572258b3a.34.2026.04.02.23.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 23:30:38 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH 3/3] ocfs2: handle invalid dinode in _ocfs2_free_suballoc_bits
Date: Fri,  3 Apr 2026 14:30:16 +0800
Message-ID: <20260403063016.438287-4-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260403063016.438287-1-gality369@gmail.com>
References: <20260403063016.438287-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A crafted filesystem can feed an invalid dinode into
_ocfs2_free_suballoc_bits() and trip:

  kernel BUG at fs/ocfs2/suballoc.c:2568

[CAUSE]
The free path trusts alloc_bh returned from locked allocator reads, but
JBD-managed buffers can bypass inode validation before that buffer is
handed to _ocfs2_free_suballoc_bits().

[FIX]
Handle an invalid dinode as filesystem corruption and exit through the
existing bail path before touching any allocator accounting. This keeps
all cleanup and rollback logic intact while avoiding BUG().

Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/suballoc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index b99870aeaf88..34bdc18200f2 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2868,13 +2868,14 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	struct ocfs2_group_desc *group;
 	struct ocfs2_chain_rec *rec;
 	__le16 old_bg_contig_free_bits = 0;
 
-	/* The alloc_bh comes from ocfs2_free_dinode() or
-	 * ocfs2_free_clusters().  The callers have all locked the
-	 * allocator and gotten alloc_bh from the lock call.  This
-	 * validates the dinode buffer.  Any corruption that has happened
-	 * is a code bug. */
-	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+	/* JBD-managed buffers can bypass inode validation. */
+	if (!OCFS2_IS_VALID_DINODE(fe)) {
+		status = ocfs2_error(alloc_inode->i_sb,
+				     "Invalid dinode #%llu\n",
+				     (unsigned long long)OCFS2_I(alloc_inode)->ip_blkno);
+		goto bail;
+	}
 	BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl));
 
 	trace_ocfs2_free_suballoc_bits(
-- 
2.43.0

