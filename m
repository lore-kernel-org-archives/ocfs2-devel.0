Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8DE157A5C
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Dec 2024 03:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733283182; cv=none; b=EZbRfe5FUBhgZ9L7q3S8ljx+jdGitvNJjFhRLQj+yqAvnvqCmNWT4b0vPcH3u6jHHOlUhLyw093TFhBuzlowZUMHRjFw242733ShKet0YbKa7oCPRgG1hX3P9QxIJvhbXtjQHzvrPWH2xEn9WXegJVMOz2JfG4ERwqtllCyXiVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733283182; c=relaxed/simple;
	bh=V/GrvN8+N9+Lt1DYRfzrOPsts/7lPzckFMVjjKtG5Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SY8F5wj0NvdveSW9dqvziF0p2ZxNKeOyl1tWa59JUo6ktnueldQ2Qt9AJTWgMUrmQ7O5Z1M5kNgdf+7yciqxvExXPv4+uZBqVJ3/U+5p4JKd0AlD21TvNyLLQD95QzSMo4R4DrqN2ThsIcPut2c4nIQZGfborBOEY2hc81I+FCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NejwzWl+; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NejwzWl+"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-385e971a2a0so227937f8f.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Dec 2024 19:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733283179; x=1733887979; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mp1Qqcg1dvH5e9SyzHpweN5r/SUkOnitlXEeua4r1tk=;
        b=NejwzWl+2pPpN1BjAt4oBatEcDicubPuWGkq5yjIUBr9FDEzcNPKbtZzH+VAs2u2cr
         H29jax+TXf9eb/s6CSWS9f8w381unUlT+ouJ+qkN65OYs5GrXzYgaaCHs18GXxeLsgqg
         /xJpE/O1NpUYCPPzIxFiSMfYtdVwnp+d2NOXxtU5Xop6E34jb3c68RvMu1WTmP9uRhKc
         x0iarBgrtLU8gz48sf9P12L02qW7vl3rWaa+XA5wwf4qKUeDm4qK64NGgRQHG4ES+rnI
         Iabv4JJ7A5U/yd8NJkKW2WcL57KN01ZWyOr2KI0Gp1eHrBTrvH1ZrLoHOz44ARnKmjlK
         b/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733283179; x=1733887979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mp1Qqcg1dvH5e9SyzHpweN5r/SUkOnitlXEeua4r1tk=;
        b=dwemZocoNGOjXAavodDNMqi459/p2CtezlIdzozLMMGgdf5/lWXHJt7IR7h4VG8GHE
         kiGfv61lUcStMYO0kHMytLetEXKu0vGiuifLLg8o0+o3wrS/I1/6Ogy0wQrkHlVeMNFe
         6d72v/bwm3ygwsj8Z99IVyY++zBdIjHV5XLVmkHGAb3tyxoMLdzw796uQD9/hOmse2r+
         7EJzmbWDqv9x8LzN2s0b0O9cbP0uOX/zGc3pz/GHiVmndWVvg/BWjyZaVQSa6nCzVwtx
         Xa582RGJLNc9zkyNL+bIOax+aL0wXV7HWlYQVghhS1bsdKz4a30ok5In9NJ/GgIBnvr2
         VpUw==
X-Forwarded-Encrypted: i=1; AJvYcCUc1awKDHAAjjwiBZSl3/tMwxB3/AARZyfswPGLJNtA6oGnY/oSnT+wShaR/lmVGPS5Pa3/GPRYR/wsLw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxIxQFcgYnhxgM4mam7+wQwVelKz+hiq/JLO/0cQgqcIJJscje4
	KbVgC54NUFgzCd36d7Qo61MbOrBuMHpo62Nw8Am0bRAoeIb4IX5UnlZkOYkbhF8=
X-Gm-Gg: ASbGncsiK7W0/1PalxyLk+iF6pF6nt7zHi2oIftG1C9KjEj8ARWRuiY6T+51GiD2GIV
	Nq856+B2nJiRoR8Qp4nP5pzPr7GFaPXzoxkStJzBQ7GqqGW/gwUrk0h1HRdWFIRAAR9OLD3oWuc
	6B8U8mh9XB6cV+CiHw0eyhhrao9zRqLcT2eQvheQ14E6Fq6sMwEHAOdY6WC4cpEuzgxoAZHlZoi
	cshRhEtBRR2xM6UxRq1cT8IvHBTwBhb5/1FPuz/Y7gdYlzmq3Ujm03du0eOww==
X-Google-Smtp-Source: AGHT+IGrxSK7SMs30zEUVr384O062RDz8BWaLsZ1ohvJ+GDGEs2COmYERdYzpJ0KCyZv7A9tHSOkdA==
X-Received: by 2002:a5d:588f:0:b0:37d:54d0:1f18 with SMTP id ffacd0b85a97d-385fd3ea027mr1773079f8f.6.1733283179136;
        Tue, 03 Dec 2024 19:32:59 -0800 (PST)
Received: from localhost.localdomain ([114.254.72.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215a04dc249sm37476025ad.203.2024.12.03.19.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 19:32:58 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Cc: Heming Zhao <heming.zhao@suse.com>,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	gregkh@linuxfoundation.org
Subject: [PATCH 2/2] ocfs2: fix the la space leak when unmounting an ocfs2 volume
Date: Wed,  4 Dec 2024 11:32:40 +0800
Message-ID: <20241204033243.8273-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204033243.8273-1-heming.zhao@suse.com>
References: <20241204033243.8273-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This bug has existed since the initial OCFS2 code.  The code logic in
ocfs2_sync_local_to_main() is wrong, as it ignores the last contiguous
free bits, which causes an OCFS2 volume to lose the last free clusters of
LA window on each umount command.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Fixes: 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
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
2.43.0

