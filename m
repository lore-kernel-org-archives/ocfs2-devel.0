Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E435261B71
	for <ocfs2-devel@lists.linux.dev>; Sun, 20 Sep 2026 14:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789913239; cv=none; b=PTnSINzBSeItiCjL8PyQRmn2RhADNWeXlT3kNU5xSzPJkOm0xtWsWRcDczYblcuhiy4VZFaOLM2AXxPi4100i553cpNTbnoqu4LyQpNh8l4WLWixoqrY4X8ITKB987aBc+D85afZpyrx+TQJxz2iDtg1kCRFXbtdqG2K/nJ4ec0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789913239; c=relaxed/simple;
	bh=N9zgMZUmRtGjeQkwy9uC7pOTrkEICynCHJ4xdsK23WU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tSKen6KQIMJI+GiaQSoAlB6E0+F5Kpmh6pMIeqC+Ffb8MV8Kzp+ElNBNxpEAHRl20yrEHuC0ObovAv+ygBVfI6Q46f/WELHx2scs3b2j90OuoOeXEaDk5+MWmK68pJ2NvNmcmRBDj5YBgnDvjYedmSG68XALbOHbctiP80X7sBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vju2CGPr; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vju2CGPr"
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d747ee1f9bso18602205ad.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 20 Sep 2026 07:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789913237; x=1790518037; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LGAc0ce7w1GSttHp685etQ7+sb7oh3MesfpogRplBgc=;
        b=Vju2CGPrPt6c+QVmuQKhNjtPRP/66I3OGMhoMpCQsj1tIge2fzyeJG2LixMdLSR+Gp
         d2AmkQGGM/jbv3CmogXFZtRy2Y+cC8Ib88Sn654QfWaD89ieNvM8MnFZfcMOv1QUNt2V
         dK38De4IKaqB2fdohuOjEOw2PTncZbrXW1m4VYMm6VjPAwGWs/AYdn9bJQj0ZDPrgAQh
         xDptEu6cINUCJ0V4p9+4GGPyTnlyDpvA/zXkevihyq3oNVJ8oKvLQkwFnQAAfDVPByNJ
         uPGaxJ5CkYJ41oRgxDtugJjGH5WY49ryHGSohazk9IaqNFJKTFx6OSBbOvPxdP3pqzku
         Jhsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789913237; x=1790518037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LGAc0ce7w1GSttHp685etQ7+sb7oh3MesfpogRplBgc=;
        b=DoKyLHVkpHyOxvbigPYbA31q/CClZKp5u4PmPiaMkYZJYxOJ2L4rIFHYHIRaD9mOAf
         gAFxT1UA+SFkiC5Gqze3SFUK7TdLckbhqhb8xXAM++XF9OZJlZ9sa+FBa+MO2+NlB7bJ
         HWZYe8B1Byjt9VB8Ag5OpvMADV6EFxS26xmR5G1dgqMqnHTDv09Pu9mio37dj+aV6H9z
         SdwBXErBfHATVdicnofylQY/Bl7JCFiomovwk6jDPK1rtgLGOyDqlyi742BsYyrXmswL
         3ilpEtAH3rG7MvosEOrZwHqdJbiTc6l5FZsFparhSXLnQAv+rrt70zoV8ye6cPLf38L8
         7+oA==
X-Forwarded-Encrypted: i=1; AKwUvBx/Lt/1Q3mY+AnekZVnmx8sJ2jExqQncirbR7p4Hdr7ROg9m1rYXchkcDrgsfPVAOl3VzzY1MpcOSOk5A==@lists.linux.dev
X-Gm-Message-State: AFuF++mbER90mVgz+G9x0ZDY2csVxe+qnM0lQHP7c8iTV3J6PcZv4Tq2
	T0Hq4Vh721Z0kNqiRgqvvGNhwq2dzhGGzlnZhag78TacMqNgKrblV6sa
X-Gm-Gg: AYBFou1+5KmsogIt/BAPq624ak/k4Z9KsyIGkujtWx6DE0rPFH2K9oNdCtyNjcEwA6N
	04bkh1K9nPyuJk1zlA+DD/5gh5Ib3/oO/meSWGupm8yMctmhpyVUt5XDyGC1d+MCGyxJ1BYQ4kF
	cQpexkGFdo06kfx4rJF2yvMf5kmUdipigX7qwWvg7xo6n8qWmWC/xpKQ86K7cTlI0K+s8bDxH59
	K5qBk7MgzwpInFJtCUkMhg4v9VVGX3xR3qv69sPKp22BCyl1vLXDMeiMv2CgNqmAlqh6MfysoQK
	V878xRzS7TzTWuu1/d+K1eTRFp8DY4fMTUYSTqajfGM6ek6IeVmBs/uYXntSI9vOP3r1FJxjYk+
	AQuJCWhp88sN13hI/usoBfse75MGe/2fcyyZiMTje5CguT1aIQnw1Fs0wd/cjLhh5TXKBN0KqWL
	0XZ+WnOzsz6UzBnKl9C0aDVUxcj4tnadBLktrb5MLEVd35w+/DvczWcOmVhSqhIa5TAuMsKQhLV
	IvcFuriIdY1ExM=
X-Received: by 2002:a17:902:e747:b0:2d8:d4cc:be63 with SMTP id d9443c01a7336-2ddb1bb4722mr116046595ad.16.1789913237123;
        Sun, 20 Sep 2026 07:07:17 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d4a:e90:2022:c2a9:de8:d005])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc178701csm20516355ad.13.2026.09.20.07.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 07:07:16 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: validate chunk and block counts of the local quota file
Date: Sun, 20 Sep 2026 21:07:10 +0700
Message-ID: <20260920140710.43938-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_local_read_info() trusts dqi_chunks and dqi_blocks from the local
quota file header.  If dqi_blocks is too small,
ocfs2_extend_local_quota_file() computes a bogus chunk length, extends the
file, and maps logical block dqi_blocks, which is already in the inode's
metadata cache (the header or a chunk header read at mount).  sb_getblk()
returns that cached buffer and ocfs2_set_new_buffer_uptodate() hits
BUG_ON(ocfs2_buffer_cached()):

  kernel BUG at fs/ocfs2/uptodate.c:509!
  ocfs2_extend_local_quota_file+0x45c/0x1100
  ocfs2_create_local_dquot+0x8ac/0xb50
  ocfs2_acquire_dquot+0x614/0xae0
  ocfs2_get_init_inode+0xe9/0x1b0
  ocfs2_mkdir+0x174/0x430

ocfs2_local_quota_add_chunk() has the same exposure.

Reject a header whose counts don't fit the chunk layout or exceed i_size.

Reproduced with a crafted image (dqi_blocks = 1, chunk 0 dqc_free = 0);
syzbot has no reproducer for this report.

Reported-by: syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=03aaa576f1daa1c1f2f0
Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
 fs/ocfs2/quota_local.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f55810c59b1b..1c9afe38e40e 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -245,6 +245,25 @@ static void ocfs2_release_local_quota_bitmaps(struct list_head *head)
 	}
 }
 
+/* Check that the on-disk chunk and block counts match the file layout */
+static int ocfs2_check_local_quota_info(struct inode *inode,
+					unsigned int chunks,
+					unsigned int blocks)
+{
+	u64 chunk_len = ol_chunk_blocks(inode->i_sb) + 1;
+	u64 min_blocks = chunks ? 1 + chunk_len * (chunks - 1) + 1 : 1;
+	u64 max_blocks = 1 + chunk_len * chunks;
+
+	if (blocks >= min_blocks && blocks <= max_blocks &&
+	    blocks <= i_size_read(inode) >> inode->i_sb->s_blocksize_bits)
+		return 0;
+
+	return ocfs2_error(inode->i_sb,
+			   "Quota file %llu has bad info: %u chunks, %u blocks\n",
+			   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			   chunks, blocks);
+}
+
 /* Load quota bitmaps into memory */
 static int ocfs2_load_local_quota_bitmaps(struct inode *inode,
 			struct ocfs2_local_disk_dqinfo *ldinfo,
@@ -733,6 +752,11 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
 	oinfo->dqi_libh = bh;
 
+	status = ocfs2_check_local_quota_info(lqinode, oinfo->dqi_chunks,
+					      oinfo->dqi_blocks);
+	if (status < 0)
+		goto out_err;
+
 	/* We crashed when using local quota file? */
 	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
 		rec = OCFS2_SB(sb)->quota_rec;
-- 
2.43.0

