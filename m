Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBCD18AE2
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735880543; cv=none; b=U4vt0gcfvW4EKnCm18S0QtUqBD7eZQgwukPbQKcrwn8sFz2Ubr5rTTAxAeIYUZD6yrwe7eLqw2GugUSOJB3DEMHDXLND4paYd/IKgBsox48fSGIM1Bc68F3Y1CToVTQYGtKU1fRomdqi21jNr59zpP9bZ0HeS3Pd91T6pz3aUdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735880543; c=relaxed/simple;
	bh=HF6CLTSBia3PN8p7gsra1zbLOkYyiHLUcVSbx56CRyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s4s9O4Vik4n8y1Vji1j8Iv6BGDVyti39Oi7CijqMlUHNrX/kb2ky6KkTaBSLDN8E0q2dBebdLhInOqe950efIT5evMYdz7cVmS34NDzaxyuVq1ogh7QEx+ieK6gZ/vLf3JYpQkWr6BTtnJ6z1CtLFBmqbj8e3XA/USzAAepERnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BH/rqPOc; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BH/rqPOc"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee8e8e29f6so13513659a91.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 21:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735880541; x=1736485341; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NPw/+eEI6q85PypD7ZdL/BIEur4VeNZSSSnVlY4IS0E=;
        b=BH/rqPOctGdWF4t3LwZGOjH/mXAilDNOy5qcQWHcatbWTDtCoNwg7OxSU/SF7Ubltr
         80pto05vQVVNZaXS0ROfh/y1ui9l2xTTZrRkUBkE/ATkbDbv5KbV/Rl4q/yVYiwkLej2
         XmR3brZelVmGIFzANMJWGjs14wKzZxdEFKTwXT4wFarpnmaJ7uoYvwZJEBC6Jlnujlr1
         Pw8UURRe1c89zaSlI5Ak/tNxoL3ajVY7senhpjzmc29/Zjb3Nly/TlTJYLj/3T25tkNQ
         EITLo8QkX84yQkdC+C0CjjMynM6sJffMKM+cHDgzt0tYD3Jvq9NnCIbhuW2LVfEOzIKJ
         HvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735880541; x=1736485341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NPw/+eEI6q85PypD7ZdL/BIEur4VeNZSSSnVlY4IS0E=;
        b=aYsPTSnyen97NOIvvyYJTC02nQrLLx8PG+2Ui4pZGLuXQkA5HfcIFhQ0E7lCjEtsHa
         QGwkDxS4MGoQJquIexGeN3yyvrU2Yi0fWvNnL7RGFiZR6AhkFdf5h7g/eNtyxxCy8LyJ
         4HB7+YDkdxosT4pn9veB3wUwec+QKTBomGJgKzmqo6q04oLnQH+VezttxZoEPiWDK/F6
         JkR5Kid8Xiv3snjHsJBBNIPapRj7KEI5EKNQ8a9CDQeyh9NptTjMV2F6FXUkp9TcUEUE
         0Rsen4Z7ADgLlWjhHaXRr20Zg90e4qEoEHysCy5sygx4Vq7B1KZ9YHbFQAocjIuNtUdV
         Y6Cw==
X-Gm-Message-State: AOJu0YwNElOl6kR9RofA7mArTId+n2f6Wz4a2nOy8s+wcFyyQntCFdQa
	O11QWRmzyyQqPEOyz6excr3/Z2T44DcymHTDAmyK3utybCmyYy2A50Tam/AIoB278g==
X-Gm-Gg: ASbGncu+k6tO8Mq3JjF46VUMRAyzskU+hhfDcs+QryjoJTVU+UI/85cBqgAABEwTXY/
	5nIjRXuvol8NRoywICGhbwErGAJogFpWlLiQo1A/RqXtqVRUK58GPP4daapqMoPwESYuga56NzQ
	brPpgCis8POnSPBPeJEC/k1KqUPvIVY6FfeLzPFeKnY0OrWMqCY3aLYdvgzoDF7qUyEIpfliait
	mSnnU2UBkZM+s0Tkoq3ElNq/Ae/vndelqfOpcjdyxyD+g2ulnBetUoMmODC+vHZHP9nJwEl5Mz+
	zG4fEjOTN10TcA==
X-Google-Smtp-Source: AGHT+IGiBHNrkMxtHahD7hNIBYQQDxfc1DKlAX+GSV47D5RVl9t/85aSTayHhW9+yDD8LsvEST8V2A==
X-Received: by 2002:a17:90b:544b:b0:2ee:c9d8:d01a with SMTP id 98e67ed59e1d1-2f452e1e54fmr68353071a91.11.1735880540592;
        Thu, 02 Jan 2025 21:02:20 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc96e919sm237478025ad.69.2025.01.02.21.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 21:02:20 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH v3 2/2] ocfs2: Correct l_next_free_rec in online check
Date: Fri,  3 Jan 2025 13:02:02 +0800
Message-Id: <20250103050202.825893-2-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250103050202.825893-1-sunjunchao2870@gmail.com>
References: <20250103050202.825893-1-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct the value of l_next_free_rec to l_count during the online
check, as done in the check_el() function in ocfs2_tools.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2cc5c99fe941..1c396c547d9d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -200,6 +200,20 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	return inode;
 }
 
+static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
+{
+	/* inodes flagged with other stuff in id2 */
+	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
+			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+		return 0;
+	/* i_flags doesn't indicate when id2 is a fast symlink */
+	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+		return 0;
+	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	return 1;
+}
 
 /*
  * here's how inodes get read from disk:
@@ -1547,6 +1561,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     le32_to_cpu(di->i_fs_generation));
 	}
 
+	if (ocfs2_dinode_has_extents(di) &&
+	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
+		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
+		changed = 1;
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
+	}
+
 	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
 		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
 		mark_buffer_dirty(bh);
-- 
2.39.5

