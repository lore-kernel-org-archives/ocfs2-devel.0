Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035A1274FDB
	for <ocfs2-devel@lists.linux.dev>; Sat,  6 Dec 2025 15:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765036118; cv=none; b=mKj4odIWWL23Lly2QPDl81lYTUlMs32u/ZOM233DLuEViKL2DW+AWcA+vAQXZLF+/ZnMx3TDYoaD1uEkZZlAJ////KR806ZiBlK8axsZqa38MsWWgXGUddgwuQ+oEs4Y8HW6JZfEY7ZHreaRzwLO3r/VV9UvUaGbSP0VdEq7ulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765036118; c=relaxed/simple;
	bh=GuParDz5eBLylVgW96qpjXBZ/qEXhOMxbh9C6uWa7ac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=prHmjPE4GHc4oilWaSRyFqsK0P9sK6Njo7Xq2WtF72fJCUwydsPN57gUZLezvqvCdVVyJkUNm0rJlCN4xeMU0LJe6uhkMFFnBrmhFmjrcEcwPGvJPBE/c3XAbB8QlQc4VFffNmKYlAAirWIWQyQF7IG3jKS06GP+4VCktHHuOQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ROegrRMb; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ROegrRMb"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7e1651ae0d5so2331466b3a.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 06 Dec 2025 07:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765036116; x=1765640916; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+eRPeM9q2EbXpge8hopYzyHkKbCy3VfPZR9AGB8+LLk=;
        b=ROegrRMbt7tAJR04w/QBpviK5CwHD6Uwq3GJCKoULAUNJ3T7aly5eCwgGgJwnl0VPw
         r1lUe1VALMSfaHVx4ItJFBtUdM1NK1LsY403e1tFqHB2TtfIKhb+S00mCD2Y4r4dU/8l
         04vyJ97VsLh9ko8MkvjG96T6waqKXHihP96RIfJr3Jzuq+Nf+ZSQoVjpKL64za0UTXwe
         iU7CZge1TVg98ZcwjddsKSIEwZXwcC4FK3O5vXPanC3e1NtXH+SRI5MvKDJgb1RaS4C0
         qbNAGfWu3ybXD1P6yXtUlMSCNJpiK3eG8U1ZjI2PlE1YlUHU2FZS+NBgickqIulBW2Mm
         FEhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765036116; x=1765640916;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+eRPeM9q2EbXpge8hopYzyHkKbCy3VfPZR9AGB8+LLk=;
        b=d/JKjBult/m9umtgpJTrGW/MI1owFsbt1OpTtHpxyt7wLFlg/2aDGVaUnIeBGwYa+1
         eUtyu8CPAKaLGIilAa14Qc4zhptK1WjoFp+NVNxK6vDMnIDZy+Rh02UO9erFA64Koiz/
         92bKkzUo4okzQOMJfsCZmZgWKjLEY0vyZI9nfIyUBwffvMg1wsNB9vUH/ylYMHShQoJZ
         8fQnY/m3C8ZOLrfhdyeb0Ur1on+iuCxGc3CAi2eWa4gRRuEofmCxxpGy7wINzauqyd/r
         2r+0xDLqxfsE+ZcGgstnX4QElYCiI4QXp6IP5U6ZGCrU8sab9DFqozHauaxrc72ysmzZ
         Tucw==
X-Gm-Message-State: AOJu0YzvgELhU8AA7DCkUSvLxiBq0Oqg1mzyNf0qZGZKIUbIDewvciB1
	9UfG6WOh+juzJ0BbrpTA7LzSYcsuDTZ4lsm4wbGn8V6zX4DcIO89M5/J
X-Gm-Gg: ASbGnctP2ny3jb4yd/4Z8BvNOKYH5GTgm/TFpoqoi5F1sspbbHaEBuJ6b/ThVc/n6hS
	OxcuvWHu7tqvsnyJHUe6zP1zahxpyHYy5NlxECe2FvofbOYZmn/r4T3rQEhSs2e3daWVitIHEol
	aHnRN+YVPe/AOmpB41Cwhq0ASXGHYO8CXCoZuoyXPdTpFTbYTntVzAzpmG62mbduU8KpAhQdfs1
	kWGlMyG1sQWsfYLPAEcfpPaiwMQOpmE/gY3y0SklPIx03GYTBvjYcvBM+tX+nWscrycBunVo6gT
	Q7w8ol3qvq0k7gKnx8+ulNSMoezNMv42YhisFMRhIrxmvK0xccAKJmiWH7Ju4ewFMZGkN334L/h
	+3dUjPwYpiud97fizKEIXyIsahB9dKvdo6kOVSdoHqyCBxFSVUSCZCafzItSlp7SbO+y4XKP/AD
	OqVBxbJ/6nvCkU1md4fRgmycf2Yw==
X-Google-Smtp-Source: AGHT+IHFctVdxlEN7Gl0atqGBbR40knvStVEAlZWL5HG/t6ahFYt4XUQze3IxeMz74Bn6QMNjDZeag==
X-Received: by 2002:a05:6a20:a11e:b0:364:31e:2cb1 with SMTP id adf61e73a8af0-36617e6c5dfmr2683085637.17.1765036116169;
        Sat, 06 Dec 2025 07:48:36 -0800 (PST)
Received: from localhost.localdomain ([114.79.178.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf6875cc8eesm7645210a12.16.2025.12.06.07.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 07:48:35 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: Fix kernel BUG in ocfs2_write_block
Date: Sat,  6 Dec 2025 21:18:19 +0530
Message-ID: <20251206154819.175479-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the filesystem is being mounted, the kernel panics while the data
regarding slot map allocation to the local node, is being written to the
disk. This occurs because the value of slot map buffer head block
number, which should have been greater than or equal to
`OCFS2_SUPER_BLOCK_BLKNO` (evaluating to 2) is less than it, indicative
of disk metadata corruption. This triggers
BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) in ocfs2_write_block(),
causing the kernel to panic.

This is fixed by introducing an if condition block in
ocfs2_update_disk_slot(), right before calling ocfs2_write_block(), which
checks if `bh->b_blocknr` is lesser than `OCFS2_SUPER_BLOCK_BLKNO`; if
yes, then ocfs2_error is called, which prints the error log, for
debugging purposes, and the return value of ocfs2_error() is returned
back to caller of ocfs2_update_disk_slot() i.e. ocfs2_find_slot(). If
the return value is zero. then error code EIO is returned.

Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/slot_map.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e544c704b583..788924fc3663 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -193,6 +193,16 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
 	else
 		ocfs2_update_disk_slot_old(si, slot_num, &bh);
 	spin_unlock(&osb->osb_lock);
+	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
+		status = ocfs2_error(osb->sb,
+				     "Invalid Slot Map Buffer Head "
+				     "Block Number : %llu, Should be >= %d",
+				     le16_to_cpu(bh->b_blocknr),
+				     le16_to_cpu((int)OCFS2_SUPER_BLOCK_BLKNO));
+		if (!status)
+			return -EIO;
+		return status;
+	}
 
 	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
 	if (status < 0)

base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
-- 
2.43.0

