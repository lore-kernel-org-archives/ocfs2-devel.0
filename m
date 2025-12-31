Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F51F72634
	for <ocfs2-devel@lists.linux.dev>; Wed, 31 Dec 2025 11:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767182291; cv=none; b=dfJbo7bGvu0ooc+QWN8n32NcqZ3KQaUaLUvw3VH5Oa32FvhcIBeIZg/BUz1I9kopxqgX5SQ3cuj+baYb3GcF0ZqeoTCoQ4UTaOeXoFUtGSBILd8frdjduw7VSZ2FnsEoNDr1L19mtfJNQBTcUKaOtvxKnpwC//GoxoCsLi1fXik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767182291; c=relaxed/simple;
	bh=k88tlWBQYYOEPRPsr7HVftPakb/hjG28OzQPctybQLM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Le650ERyu8SDYzDjm4uynLeI1xbADEwO+oGyV8aOXcvQ69abj5gPCqyinxRQi+EwZA8R/8dI7v35wB84pqUyi9jQvf2X6hYyqFSF9niuQTb8HUt/wiBxh50HRRiIq57vMUxku+/FiK/2hfGwRLdY4kase2WqrUQFT/bfMpKBNgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PPMF1iy3; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PPMF1iy3"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0a33d0585so99606625ad.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 31 Dec 2025 03:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767182289; x=1767787089; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wz/+EK600urPKAZwKCkmBYjLyy6YfjogOlH1FKpFrF8=;
        b=PPMF1iy3GK7eDoqvM5ugG95XJvXDdrjVhbw9IgiyFxuy/hiMCNBCsuBUnmAxMykXa+
         9mYX8BIgJfv+wQVZpmbwM80QO1sDwCcRqYmsxq5J4HH+DdeVmEzO7msqiWs1KhzUF1GW
         3RJ7a0ArZLtksRPWXX7iCAng/RhRcMREbIGjnsSes7PYcUm562Z1kQ4KkaAvCh8K3L8I
         twyOSW3BTTKoNwWcPWZfhu5pDJrGzwx/+IXIs1uZJlRgq1vVW2ENhB9CrfShPuc4RFMU
         JRGSP719+Yu6otnFv+sFIGwY6he0IiQbeEoJa7VpB4GMelsA2B/4loajgd2b7TbxJyHl
         GnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767182289; x=1767787089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wz/+EK600urPKAZwKCkmBYjLyy6YfjogOlH1FKpFrF8=;
        b=nRgUz2n/hkZL9TCJ0yhgAPplaxS6Zye0haKVOcytWj4T+qbpZCLNiV6lSx4yXi52Oc
         cO/gttu0g/j9anppbA5TO44ZsKmQq0Z76VfN0Ro4vnZfIHO5vEMjrz86CLJYNbxG1agG
         hnQALWQfQTXE1Cd/QRJ5AvCNc+2SvGETpS8o3KB94MNilmqqbCO0v5M+SuhuEQbXPK3m
         Y/ewgtj5dHsqFyTIvrDMVVOVevweytUY+aGozIw4C9lDifJbnLGqYnfMjlqkun6MUbua
         ABHu/xk28oMjDCJa/+XR7EnZLQ7wUQrAuYagAmJxDukU40V7/LwEISZWBu3xfPZeJ/8C
         Sp8w==
X-Gm-Message-State: AOJu0Yx/CCCzKkVaU6UpD6lETdij4WijUFy9JegeQI9CRxGOxizhnzYz
	I8uIWxX5V4i2kCDpN4tIVyhesCAMGPkIQID6hD2rkTykW6fWRBje+C3k4ZOhFw==
X-Gm-Gg: AY/fxX7yJE8iMdZrtPGo3xrZ1yuenS6BKECulLKrPTsfIOYmXCcM7ZLMZV7+Wy+uWuC
	KPjkcuAuFDfp4EsvIEucED64qL61DaKooZVcqNoEPjUKjuYRXj9QbGOAcy++MJRjx683U8ha+ai
	T9jvXCE3QWF3Wf6WBIhm1R3MvW47P8d1/aGG0+vblvvpzIQl27j2arIIXIeSyluN1hh/VMBUa4z
	aRGXYHEWVGhO9Kv4JdUA677sQPqZCqUELsZDYZxrTCQ8U3rgrvWJqiMyN62ecECYp1vKze3fLI/
	bHJz4r9gQVYw7fl1MmL/m4Q7HoHGGDFklHl6J9FCGK/TW5I0sD7e+jTTrhbV7xxymdJBWZT0S5n
	FGf3lyseeKyiwc75t0ukcXS7Swh7IP/ShDas9oMDb7GqJlDD8ORC43NrT/+YUW2SOwoEQjzvWaf
	Sirzu4RvM/CS8++ZyrqoVVGogBD/7/jUjR2aLbrNIzhUyS+HCcSQCspLclKyrSvd1S21WV/tCTP
	8TixQ==
X-Google-Smtp-Source: AGHT+IGziUsfUmQRaqOCxW6sieLIMR86pWG/brH0bc1pTwoC64rtPjrWcOpkzW3UzSVYaAAA4nYAog==
X-Received: by 2002:a17:903:2ac5:b0:2a1:3ee7:cc7a with SMTP id d9443c01a7336-2a2f2223616mr342395905ad.17.1767182288787;
        Wed, 31 Dec 2025 03:58:08 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:8329:515d:5002:11e7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c66834sm319109045ad.9.2025.12.31.03.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 03:58:08 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+7960178e777909060224@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add check for free bits before allocation in ocfs2_move_extent()
Date: Wed, 31 Dec 2025 17:28:01 +0530
Message-ID: <20251231115801.293726-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check to verify the group descriptor has enough free bits before
attempting allocation in ocfs2_move_extent(). This prevents a kernel
BUG_ON crash in ocfs2_block_group_set_bits() when the move_extents ioctl
is called on a crafted or corrupted filesystem.

The existing validation in ocfs2_validate_gd_self() only checks static
metadata consistency (bg_free_bits_count <= bg_bits) when the descriptor
is first read from disk. However, during move_extents operations,
multiple allocations can exhaust the free bits count below the requested
allocation size, triggering BUG_ON(le16_to_cpu(bg->bg_free_bits_count)
num_bits).

The debug trace shows the issue clearly:
  - Block group 32 validated with bg_free_bits_count=427
  - Repeated allocations decreased count: 427 -> 171 -> 43 -> ... -> 1
  - Final request for 2 bits with only 1 available triggers BUG_ON

By adding an early check in ocfs2_move_extent() before calling
ocfs2_block_group_set_bits(), we return -ENOSPC gracefully instead of
crashing the kernel.

Reported-by: syzbot+7960178e777909060224@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7960178e777909060224
Tested-by: syzbot+7960178e777909060224@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ocfs2/move_extents.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 99637e34d9da..2548a8908a1b 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -690,6 +690,11 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 		goto out_commit;
 	}
 
+	if (le16_to_cpu(gd->bg_free_bits_count) < len) {
+		ret = -ENOSPC;
+		goto out_commit;
+	}
+
 	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
 					 goal_bit, len, 0, 0);
 	if (ret) {
-- 
2.43.0

