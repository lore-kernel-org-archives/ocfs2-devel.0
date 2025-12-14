Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A22F513
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765737311; cv=none; b=EJomRw9RWm2ePit7hEaFM87KAT0OdsNE+E+ZEepGIi92upjQsxEB7dA4D2E411p1Ty2nOklHwMTCMuVFtZDCA++PrbxVT7nzO8FZeDmx8I8g29nNe8hys/O1T846EI6ilQgvmNvQ0pX4hzRr/TOqZMOLCAwEaIeQW+Dos7TunKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765737311; c=relaxed/simple;
	bh=w0iYwCaxYamaMcbNo+knhr2NqS54F7HngT78VZy7GI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/rW/vKYJhlbBPsgRTlD7QmfhQNdy33C8ek4obj5BuRCjF5MNaKU7xwxkr7e+VcZJX3v3/Cd2OMgW6i5c2ou8mTJCuk9Rm/qG9qZ9sUkyYQB5tUr2ZqNXYjrBTirmWLj/PDYNcUz6WQic+MQ2wQmZH24WQXjpwwzsQIGaIy4tVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YIHTlBH7; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIHTlBH7"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so2116608b3a.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 10:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765737309; x=1766342109; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lu7Ewifk7NfOmZmxHE0uEUB8jAYgqBv9Gp51r7YP9eI=;
        b=YIHTlBH7w3xFYcTTW0C1bx+nig1KAvheYjIz8cLI0z2ufiOzMiTqzf8HrFF00fHvrX
         +sxrmGbMb3KLNnGw5z4vHZLPn8LilhYD+4jOPEH5ryC0hg+0iLK1YA2UCw4XB6Frb0US
         txfM36ilh7vEHLasCz6yMe3h4CySsoWvh/KUodLVfSL+jrPpfi0TKbjwanUmB+gQDArW
         jO2EfSPFfgeipcVsvHq+1z9TRuYbEZmiTjbV6BKF3LS0QgE0RyaZVIf9aqVMs0JuRvxv
         pdAa+TtzCHEu0ofzhBArqc0n/wurb35LxVm1i/0jYqW9RwOaQInqIrUCEPUumbdHa73f
         VaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765737309; x=1766342109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lu7Ewifk7NfOmZmxHE0uEUB8jAYgqBv9Gp51r7YP9eI=;
        b=rFbNjjkoVqIZmrePaOS9EssY8n9WE1vsFkBN15ozkaLrzHhT/npgJOV5kgOLIJ4TAs
         Z9uKrVPyXdAZ9yNoGDXRVleOIGpH2nPVUgkjYMZE0NLTpg8NBM+3BpTErRY97DNFBAux
         pmpew+3OJSJ5wVNe+FoWacKdSXtSJupVgTYLCwCnGxPoOJKKkMvarUgLH+jAa0UqC5nC
         46HTlFgSzOTctUtFZQgOez1oVSVkxjhSbB92Yj9Ee/F+3tzBD8SFi4KrmYRTrAzWET20
         InzogU8BIBi5Z5e3r2eOx2D6xl6xAZI2JXnLoa/4zZEoLHVJGnKSc0762aNjHx51804W
         e+GQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfmsp7449VLPzuYS4y6pgzBYTqZTwwJnLYc/i+qQh1WRsZXT4kqWavGRy+6+l/fzvXFhj3aMNs68sbpg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxO8qvFj4YqNOp61PAmEZxnFlK8aRbEBHABVdxcLPH4ERZQFix3
	oITnzEpjAl5vopQzq9Zdw1Hw/2liUkcLENMwFfuunt7ujOPs2shv+IpP
X-Gm-Gg: AY/fxX6Az+37lJh0sexh6hf3bfwBwxICYJF3WwPaHESQHmoJPBG7CkDQ7oXKGKZljqa
	bAMCBuqJMsGvwt5j/hzfvwu5wO3LFC48EJ1/9FPEou9cjrB4qpQxH9ZEx+6cH/AjbtMpzIB4wgJ
	a0EkmGpgQfl8H7VHechk/fUgRES4fwroX2YbqdNJ2tNp/fOgSSweXFUdX52BASynecMNHlt6Oig
	+ugnE/WfWyavEJJxSyb1CCAEqtCt/ytDU6r/QWoOSfWN/Y5RrDgJycDGqHj85ElgU3mkvtcnVf2
	VrdOX3BWnNZWotD+N/o6K/PAhu/X/z62vSGnHcXw1AHBHyOrLkE0me4pPhVOSKqYEOolBYcFiKe
	umUIQfYkMZgTD7nT5pchtTqfvhS9pmV6iI2umVVNtzydv+mbJ3zpJM8oifBKqrAj4WcMCPyjKgI
	X/YIgBdAJLX+D/qy+IelgvUT6WtcI=
X-Google-Smtp-Source: AGHT+IG93r9UBrG9bs6iJ2qO7F5KLkinwl/q0mLBLV+C+0tl1Xkn0c2Gzqo3UjM6uX3NndjAuDeohQ==
X-Received: by 2002:a05:6a00:4207:b0:7e8:43f5:bd3c with SMTP id d2e1a72fcca58-7f6692aae14mr7049222b3a.40.1765737308739;
        Sun, 14 Dec 2025 10:35:08 -0800 (PST)
Received: from localhost.localdomain ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5093d5csm10268806b3a.49.2025.12.14.10.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 10:35:08 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	heming.zhao@suse.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_write_block
Date: Mon, 15 Dec 2025 00:04:40 +0530
Message-ID: <20251214183443.21515-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
References: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 24172e0d79900908cf5ebf366600616d29c9b417

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/slot_map.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e544c704b583..9406ac37af6b 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -132,7 +132,8 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 	 * this is not true, the read of -1 (UINT64_MAX) will fail.
 	 */
 	ret = ocfs2_read_blocks(INODE_CACHE(si->si_inode), -1, si->si_blocks,
-				si->si_bh, OCFS2_BH_IGNORE_CACHE, NULL);
+				si->si_bh, OCFS2_BH_IGNORE_CACHE,
+				ocfs2_validate_slot_map_block);
 	if (ret == 0) {
 		spin_lock(&osb->osb_lock);
 		ocfs2_update_slot_info(si);
@@ -332,6 +333,26 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num)
 	return ocfs2_update_disk_slot(osb, osb->slot_info, slot_num);
 }
 
+static int ocfs2_validate_slot_map_block(struct super_block *sb,
+					 struct buffer_head *bh)
+{
+	int rc;
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
+		rc = ocfs2_error(sb,
+				 "Invalid Slot Map Buffer Head "
+				 "Block Number : %llu, Should be >= %d",
+				 (unsigned long long)bh->b_blocknr,
+				 OCFS2_SUPER_BLOCK_BLKNO);
+		if (!rc)
+			return -EIO;
+		return rc;
+	}
+	return 0;
+}
+
 static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 				  struct ocfs2_slot_info *si)
 {
@@ -383,7 +404,8 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 
 		bh = NULL;  /* Acquire a fresh bh */
 		status = ocfs2_read_blocks(INODE_CACHE(si->si_inode), blkno,
-					   1, &bh, OCFS2_BH_IGNORE_CACHE, NULL);
+					   1, &bh, OCFS2_BH_IGNORE_CACHE,
+					   ocfs2_validate_slot_map_block);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;

base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
-- 
2.43.0

