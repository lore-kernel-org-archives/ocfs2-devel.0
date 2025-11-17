Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC30223DCE
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 06:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763361148; cv=none; b=ZcKqigh38McU98C7psZRIBwQWvZqxe57CkvLn6MyeDwquwC/YoujoYJBIGM8NqM/vC1kCfEl/1Fe21KJveEvwaYVcexXtQxy4WeW2iKJCF1GbBSDRmavVaY1lANxXM5MRMuqdeIpghnE+lJXGvAF8OVMJm2iAE0ccspwxuTugHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763361148; c=relaxed/simple;
	bh=gLfHt9MTF2G7kFL5iYTHvcPM+9zYfYEnJq+3GfXx1gk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fLRshjZYNTy3QYxhJLBfpEyXCP1Vo672VzUmt3fYpbkFF8T/2gTaRsCYZWbxxjf9tknboFy9dxwmDTIjEKuirmgyut/zOPFYV1Cez41NZCOpb27XIGfDsYThwtFl78+bqROH19imwNnFjoBnGJQ4L6mHTyHi+jWMNkNuyTBAQoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RXl82fPb; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RXl82fPb"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-343f35d0f99so3067724a91.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 16 Nov 2025 22:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763361146; x=1763965946; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=37pLJ1j0OVF93d9c9E2IIMaroA64staVDd9dTWSzLpc=;
        b=RXl82fPbmf7r3bodfPqMjCPOeyQKeIgpNbd9IFk0CoXdz2sLuzXjtmWoubWp7WIb+Z
         in6H9FuXiMdcMl3O9ZQ1Q6n1HfczfBMBVa4EDOTWhJgpClQlpNk2jm5dhGzHdGoazRPU
         u6U+mWPGmPZMSuXe0058B2wE7rq/snxEqTU3a5yLpHc52CSlimDPUOcAbhoa4ZyVlDU4
         axEKfv35+04a6DT9PdMPGot5cyosNwlc9ve9/lRbTCT0RAtLSo3Elm3dyL5lYAeke1J3
         zdP5ejYtoOQAPqbtNljD3Ni3BYKwU7yL6h0M+Gu9JcEVqQjRSkQTdiuobdSvifLzb2qH
         L9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763361146; x=1763965946;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=37pLJ1j0OVF93d9c9E2IIMaroA64staVDd9dTWSzLpc=;
        b=Q0tWiM7B0wjDUCAWnDvH4gGskChq8HLaRdRmQN9dpuFzJ1uV28ME0D3os2ZLwoUaWq
         cK51Y+2mzmgV+MrA9uRPup/9Ax7I5/UdTiyTSg/fZ92HCfO37Y/zf68Wfh/58U2KjbE4
         wKW2qeeQqy7hiHlSIWNLBlrSuBDmtxCuJe8mNHRPNP8Niop/ppru2r9ZlBRPEUZgryRY
         ZB1HCQy9XIeo2vcA68HjhD34yMShfKH5aig98umcU0OsSCEnMi2RnwNpQwJip098Wozz
         jlMvlSAyIgbOALX8h8hz8qtvZrpHviy4rzKE7nGisZl2IsS1zLfQ1mjpx113ryWtD+Tk
         +TEw==
X-Gm-Message-State: AOJu0Yz4PyadGJUvpsPCkL5U5jl7b58YH8HWqH2mbOxL7hDsWlEaCJ61
	fnvKEzLcsvAF4ocBPV/eK6euZzqO5cz1m85MqT+aS488z7xP7aOWCG5Q
X-Gm-Gg: ASbGncuJsTDEZOP/+Pjoew4hYMtaAVMoOPqkfTYTQ2XghhBNT1v+uiGHwtIg9Bj4XA2
	Psgh+qhXirYD+xpGXGpkbtsgUjri5GWUPgDs3rPcp3Wrv/XXUh83WC6bmTdPtFjnhSTfNeQNiE3
	gyIQqFUtk8q/V+2+FYGUhOoUzkLqH/nlh3Q0NveYeRS3WPLdYMx1BfAHzWLstk/51ufp35thzNp
	QGMnbig7s/IJD8hQVgfioyr3pPDr5sL7Ls5MQ+O+mFx7WUNNosrz3yCPpsLw3ZNxBS2hFEhHrDS
	eZ2q4UlF/VC/A/1ntNJpGpWBw0pNRQVwazo+H4n+C4BL9f/n3X/2dh27d2oDIpqmNlq1qMVgqNy
	FjOzGPLv5QlixnWPkXoeS+9+qc5U5fPdAaowbzrtnzbTwKKT6fzUoHAkPHB6SMBOjq9pKUFgfas
	dj5+Uaaft+lbN/w41hFVvCgNAc5RvsexCI4r8=
X-Google-Smtp-Source: AGHT+IFJ5QD8qeDQHCNmcW/QYYS+QcGJ2HPHLjS5uSz5iZyAI4D/H7a4G/w1XdhK0Q2dgJRthXrhmw==
X-Received: by 2002:a17:90b:2552:b0:340:2f48:b51a with SMTP id 98e67ed59e1d1-343f9ea5a78mr12690070a91.15.1763361146360;
        Sun, 16 Nov 2025 22:32:26 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:2dd9:39b3:a834:42df])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343ead105c7sm6963713a91.6.2025.11.16.22.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 22:32:25 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: validate xattr entry count in ocfs2_xattr_list_entries
Date: Mon, 17 Nov 2025 12:02:17 +0530
Message-ID: <20251117063217.5690-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add validation of xattr entry count before accessing entries to prevent
out-of-bounds array access and use-after-free bugs. A corrupted
filesystem with an invalid xh_count value can cause the loop to access
memory beyond the allocated block, potentially reaching freed memory
pages.

The validation calculates the maximum number of entries that can fit in
the available space and rejects counts that exceed this limit. This
prevents the subsequent loop from accessing invalid memory addresses.

Without this check, the code directly uses xh_count from disk in array
indexing operations like &header->xh_entries[i], which can point outside
the block when xh_count is corrupted, triggering KASAN use-after-free
detection.

Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Link: https://lore.kernel.org/all/20251111073831.2027072-1-kartikey406@gmail.com/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v2:
 - Changed return value from -EUCLEAN to -EFSCORRUPTED for consistency
   with existing xattr error handling (suggested by Heming Zhao)

 fs/ocfs2/xattr.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d70a20d29e3e..f7341e3d8a6c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -928,8 +928,23 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
 	size_t result = 0;
 	int i, type, ret;
 	const char *name;
+	u16 count;
+	size_t max_entries;
+	struct super_block *sb = inode->i_sb;
+
+	count = le16_to_cpu(header->xh_count);
+	max_entries = (sb->s_blocksize - sizeof(struct ocfs2_xattr_header)) /
+		       sizeof(struct ocfs2_xattr_entry);
 
-	for (i = 0 ; i < le16_to_cpu(header->xh_count); i++) {
+	if (count > max_entries) {
+		ocfs2_error(sb,
+			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
+			    count, max_entries,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
+
+	for (i = 0; i < count; i++) {
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
 		type = ocfs2_xattr_get_type(entry);
 		name = (const char *)header +
-- 
2.43.0

