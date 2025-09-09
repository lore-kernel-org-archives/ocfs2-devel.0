Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4012868B7
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409247; cv=none; b=rY2bSc4VuOrwoLm/lqPdQABEEWKGbVgjb3UQjGiiqz322w6dDxRKxY5bVnUCW3pdjjETqFG9awx8wNcLhpYiFeal80q3fJ0M17/MFvpD7PipM5cbdGZ6/4vjkjkckVr+NNVSHFG3SY3T9Xv4nHGMnYVF9Yv3YUgYioINJc+Y3To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409247; c=relaxed/simple;
	bh=CP3LXTksQglwFNpnXr0hPsTeP7YFtJ0DHIn/IRdimlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EM4c3w0J3F6pcDai1Z6xnWUlwTKlkC3k7boi9isBuo+or+WxI/IuYCLObjnNcGUOGJh3RXk+6FqUMVUFyk5SHjFHOVcZsbsNj69y1x0j+kJyDVqluc1pCQBoL88JrODuE5j060XYRUF6oOw0lYOshdntuREqiyDPsNjYMEm6JjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gKwr+W7e; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gKwr+W7e"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso4586695f8f.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 02:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409244; x=1758014044; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/znQVoqdYnguqmx5WBg8gphSRKbnjv7YqaJ0uXheApk=;
        b=gKwr+W7eOGZdvB3sBupn1JZ7mBnAuBmKbDHXVuCr1orRs8zLY054HiPWLWtoYzjiS9
         ZYRsVCGltUqOkXjkeWSyclCpaRz4F7xDJPe2/zjSHTk5kpvFqTZX6QsMPMfG4xfwUiQg
         1cH/v1j2OpLGABClt0uQTsk2XduH9wpI4Ms7iyjDB2eakOAx+G82O58LC2xJT7sb7H+Y
         yv2QH8Xz6TcOfw7TTlu42sWQQRV1/8GWBS2j8Q22tbBP8YZOudptAIlgF/SM9+Fl+Vf/
         /KNuI1FdaOMFD/1EBgjDIoiRCiY3ztYk3GvGCQqhIlkh9cdWuQvebztyJ8kdbZGmGGJG
         QI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409244; x=1758014044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/znQVoqdYnguqmx5WBg8gphSRKbnjv7YqaJ0uXheApk=;
        b=cOFPPEktFtQwykDuqS134wagNwJsEs+azoCB5wrR680Rc2epo/da0nqd9ZGVSCHFqg
         cWG8SYxIcWIrp+5Q19xasz+EX1vg9FOGz3pLyZDNPJzUICj30BnkFT1+gQu1Nd2lGdRZ
         xwttHDMRVkc1ERb0YiQDsUO4h6ckYdZ/E+hiZJvairVvOwyuac1F4v8rUL7N8un2Q7e6
         xYgS4BLxgTDaEO98wsDwovSu7AvmGIKSFQJZ2drDdp+4sDLYDEXatpxznOBYYFc+xKpm
         VBgqO05AMHAvjzRsIW55HexOfH0ydMi8vit9Sgzyd6AHpKUYGW4X3g7MvZbsn1vQ8p8o
         mY+w==
X-Forwarded-Encrypted: i=1; AJvYcCWCyKOVXuIGT1uA6PciLfglHMs7ngQuShD1lh/m4NCbhMMKTJiq9OdfqJAQDSB7JsZWcMUALrw1odJJAA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxEIIB7bJa5vzKRBDwNHzfYxUGueAn2WUC6YyfZ2hDkbL2qUhEo
	2yEBoES6MtCTN8h76zTEvVHlizer6CB6XNcx2oTVjKlzP6uwQpREX5Lk
X-Gm-Gg: ASbGnctJy4LQ5KlW90maXwnMOStc7osF8AF5K0u+PlRR8SGElIVWt3dap8Nu69f8byE
	3P8doRYtFRdFoDppYrs+I+f2ukziFTtlteC3wqUgB8ndDK7vfsYVVM4X9D67wo+eW/PpZEiZp2s
	L+zW+PyYoNTNiPzK8umpJjU49FtjDJvmnEfiuzK7cO1Z3RFx5Sf7U6Gu4t3phxM2L7N7pqUSvkG
	N5Vt2fpGHjAmLw2PubgIprEvD4bVpRwF2uM9kIjydRCzUIgxsuKhkOPJ8IVtYEd2lClEoVd4XXH
	AofV9wyq1pblHt+ZDMMth+jNRxQy7qDVMCnSpn5DZAUk4f1QP4FMa1IgJ5xLRGIFyrQzDKdGSow
	wfXMJtvRmtH8LoLPuXYMFkc58XXk0mD52p60RMov6
X-Google-Smtp-Source: AGHT+IGumv6hXX0Ye+Kc7ZPtdtCMonFUD7y5t+JsaAGWTiBx9lCNtXy0TEMvDq2v7tSN4bX9gzdxAg==
X-Received: by 2002:a05:6000:1445:b0:3d0:820:6822 with SMTP id ffacd0b85a97d-3e637465d1fmr8289240f8f.22.1757409243864;
        Tue, 09 Sep 2025 02:14:03 -0700 (PDT)
Received: from f.. (cst-prg-84-152.cust.vodafone.cz. [46.135.84.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bff6esm1810784f8f.13.2025.09.09.02.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:14:03 -0700 (PDT)
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
Subject: [PATCH v2 01/10] fs: expand dump_inode()
Date: Tue,  9 Sep 2025 11:13:35 +0200
Message-ID: <20250909091344.1299099-2-mjguzik@gmail.com>
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

This adds fs name and few fields from struct inode: i_mode, i_opflags,
i_flags and i_state.

All values printed raw, no attempt to pretty-print anything.

Compile tested on for i386 and runtime tested on amd64.

Sample output:
[   31.450263] VFS_WARN_ON_INODE("crap") encountered for inode ffff9b10837a3240
               fs sockfs mode 140777 opflags c flags 0 state 100

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 833de5457a06..e8c712211822 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2935,10 +2935,18 @@ EXPORT_SYMBOL(mode_strip_sgid);
  *
  * TODO: add a proper inode dumping routine, this is a stub to get debug off the
  * ground.
+ *
+ * TODO: handle getting to fs type with get_kernel_nofault()?
+ * See dump_mapping() above.
  */
 void dump_inode(struct inode *inode, const char *reason)
 {
-	pr_warn("%s encountered for inode %px", reason, inode);
+	struct super_block *sb = inode->i_sb;
+
+	pr_warn("%s encountered for inode %px\n"
+		"fs %s mode %ho opflags %hx flags %u state %x\n",
+		reason, inode, sb->s_type->name, inode->i_mode, inode->i_opflags,
+		inode->i_flags, inode->i_state);
 }
 
 EXPORT_SYMBOL(dump_inode);
-- 
2.43.0

