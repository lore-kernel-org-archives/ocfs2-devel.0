Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FEC296BA2
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409258; cv=none; b=YrTKu7pbxGGMkgjDm/fiU2TyJMlP+7U2naZ2bVMwkkPpPtfqgHb4/gXLJzMrfcaZBLrekZFNCXFvvTfCqpqw5hWPa96zAs+y9izNr2Zw8/7LLZgjwtGHBp4kcHrFfnev9fezH4ibHLLfjNefVi35skjrAXb/2+6xpPhfGsr4zhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409258; c=relaxed/simple;
	bh=BdTaArvmGkBuLGGtyHfh2TGj+o6P+9OkZp4zyvMpLBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlFFyHV7AUbIJ4pwlC8MYfcrq/t2zlQqBeZF1PUzL+wRbwSl9pe77Isb5UF2j35keMAOnm2uNiRzNH2HLiLxYjYL7P89IDca02Q8itgwEefLxe79DvF72nCYHELBEzLauNWmZuT6hy5shq/wZ7wmpnnpQZ28UKp2lEynFHjeSi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=APoXzftk; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="APoXzftk"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3c68ac7e18aso3371827f8f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 02:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409255; x=1758014055; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zAkwWZPKx/h0WObhLl7ADVXI+izd4bElBlrOtR29tis=;
        b=APoXzftkaMjVyTDNWEQiZErtd1ypUx1OhOweRIWD0d83HpyBP2EaBo8bgEllu+s0GV
         fR7QSbaV4yWRCIHCz0mBZl52cRcnxqffB6OQwSQ7kuoMMTV9K56AAXGX8/nV+pWhL/mK
         oWSwEHzRqBKHnqONQZiAXifr1txDDiLgCSQab0lkkLqKMeaiey+mYIFvv2vDevVgPcb6
         nQHYWnmqI0iGkjeFvY0HE3Ugb8t0ZWeqvN+xIz9ShMg22yQCYp1Nw9l1vfhTOUEGZjE4
         PiR3ZlXgWK1Kfw1ygavelYtdcGxuPdZNj3iCIXhSsUF5+TXKgOT6iv80f0VNJ0sXxPL+
         8iBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409255; x=1758014055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zAkwWZPKx/h0WObhLl7ADVXI+izd4bElBlrOtR29tis=;
        b=bXC6nE6BPD9WXr0GaPKzYFlvTQEB3SAqCiZomxMbuLpPfUMvYR3Qp7p8Lc4W1tBvnS
         dR40MqmfEt/fFs4Sd23HHjhRy8Ea1NDvkigUnoyhwYNV4TMiddGSfCCFW6xUrlBaJpjb
         enJX3ScG0j7UEygsao8Sizyvreme8sZ+a3rtM9ecp7wedf0xx1CFLrXy7It1h0Mo2sfH
         n/rxSc4YSN4LCb9nUPEGbxIUD5VZX9chc1p5Gr0HKSJl53gPMpW6iNA+jVHUkzdTB7v6
         D66wOjftfZzjsa9YQQmcUIw/iBHIB5+JqfzCzxdyFBqdX7q/BiH/yi+D3hzvK28rswYA
         2y+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCPJlEKTlNSbcmbgv6WiBCP177HZNIocaGLtPrEj4ENtvlHTNpt9E2IA0YH8ep2REoByvA0kd7VL9QQg==@lists.linux.dev
X-Gm-Message-State: AOJu0YytMRxLtMEVbg6B3r4POv/eDKZO2Ga0PKnht5JOiCjU/5jQ5lBy
	kIvcI8v8E6ziW/S3cTGlIXb4K6iTcnWhrKhH6IX4HuOLwY3qCK4iOol5AXBRF5Tz
X-Gm-Gg: ASbGncuHOjsQmSBR8fmOVvMYTt440JMiE2PJfOhZMmNA/7Z0TlS3Qc/DKfMiLwRpN6/
	++cr5NqZ4GEXSTJtgoD9QpkfCR3d3v0E+E3GU78tzmkQwC1mfqqTZhtwc540r97frriY/EY7UJv
	dFH+3vBg/27JEdt3YChrBamhnPt8SgS2FjrK9yncWmI0vgx68YYaLehWVgF7JLtzofMrQJUtuKs
	i6LOdpSppKFfoxHR1BcT2NVjp1W1ndrozak2n1Umsa5W/eq7LjbRS74Vf84b72LyKTuI+Afpl8j
	0BkmhLgdV1E9oIZlYG/2a5zKdpo6Jhuk+wr9sawWu/hBDWF6XfIDkzxbZilJZQshUP+4K0wB5pf
	vbsiSUqzq7JGrP+EJGILs/Qd/t5RqBFOAX44oCAWL
X-Google-Smtp-Source: AGHT+IHFR5glDC7pT0pDvmRqpKg6rH7YeMgcZQ374nE01iyhNYdctYhtZjBoNSHdXlfL7T1OlO5Mow==
X-Received: by 2002:a05:6000:248a:b0:3e4:f194:2887 with SMTP id ffacd0b85a97d-3e6462583c1mr7538835f8f.30.1757409254879;
        Tue, 09 Sep 2025 02:14:14 -0700 (PDT)
Received: from f.. (cst-prg-84-152.cust.vodafone.cz. [46.135.84.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bff6esm1810784f8f.13.2025.09.09.02.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:14:14 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2 05/10] ext4: use the new ->i_state accessors
Date: Tue,  9 Sep 2025 11:13:39 +0200
Message-ID: <20250909091344.1299099-6-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250909091344.1299099-1-mjguzik@gmail.com>
References: <20250909091344.1299099-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/ext4/inode.c  | 10 +++++-----
 fs/ext4/orphan.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ed54c4d0f2f9..55d87fa1c5af 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -425,7 +425,7 @@ void ext4_check_map_extents_env(struct inode *inode)
 	if (!S_ISREG(inode->i_mode) ||
 	    IS_NOQUOTA(inode) || IS_VERITY(inode) ||
 	    is_special_ino(inode->i_sb, inode->i_ino) ||
-	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) ||
+	    (inode_state_read_unlocked(inode) & (I_FREEING | I_WILL_FREE | I_NEW)) ||
 	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE) ||
 	    ext4_verity_in_progress(inode))
 		return;
@@ -3473,7 +3473,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	/* Any metadata buffers to write? */
 	if (!list_empty(&inode->i_mapping->i_private_list))
 		return true;
-	return inode->i_state & I_DIRTY_DATASYNC;
+	return inode_state_read_unlocked(inode) & I_DIRTY_DATASYNC;
 }
 
 static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
@@ -4581,7 +4581,7 @@ int ext4_truncate(struct inode *inode)
 	 * or it's a completely new inode. In those cases we might not
 	 * have i_rwsem locked because it's not necessary.
 	 */
-	if (!(inode->i_state & (I_NEW|I_FREEING)))
+	if (!(inode_state_read_unlocked(inode) & (I_NEW|I_FREEING)))
 		WARN_ON(!inode_is_locked(inode));
 	trace_ext4_truncate_enter(inode);
 
@@ -5239,7 +5239,7 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	inode = iget_locked(sb, ino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW)) {
+	if (!(inode_state_read_unlocked(inode) & I_NEW)) {
 		ret = check_igot_inode(inode, flags, function, line);
 		if (ret) {
 			iput(inode);
@@ -5570,7 +5570,7 @@ static void __ext4_update_other_inode_time(struct super_block *sb,
 	if (inode_is_dirtytime_only(inode)) {
 		struct ext4_inode_info	*ei = EXT4_I(inode);
 
-		inode->i_state &= ~I_DIRTY_TIME;
+		inode_state_del(inode, I_DIRTY_TIME);
 		spin_unlock(&inode->i_lock);
 
 		spin_lock(&ei->i_raw_lock);
diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 7c7f792ad6ab..70444810bd7a 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -107,7 +107,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	if (!sbi->s_journal || is_bad_inode(inode))
 		return 0;
 
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+	WARN_ON_ONCE(!(inode_state_read_unlocked(inode) & (I_NEW | I_FREEING)) &&
 		     !inode_is_locked(inode));
 	/*
 	 * Inode orphaned in orphan file or in orphan list?
@@ -236,7 +236,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+	WARN_ON_ONCE(!(inode_state_read_unlocked(inode) & (I_NEW | I_FREEING)) &&
 		     !inode_is_locked(inode));
 	if (ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE))
 		return ext4_orphan_file_del(handle, inode);
-- 
2.43.0

