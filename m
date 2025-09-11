Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70DD24BD03
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Sep 2025 04:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757566575; cv=none; b=BsFzdEfu/OmvwXEhLtVO82m/8WXJdV91mRg9xJB0ZRj2eR0fwukxpn+yrSV8cY2ZQj+jCAm+HK2hpu0AfZ8TzmcSx5pKrrUjvwhbQF/Tty7BuovzczJUqoww0I7yqkMFAFbLBRTgG/qODsVrlw/0d6/58lIECJxrfeJl4PFZfh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757566575; c=relaxed/simple;
	bh=CP3LXTksQglwFNpnXr0hPsTeP7YFtJ0DHIn/IRdimlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1fZCz2hlj5NVIRqUmbBoVsef4vZCZTYpT4jS7prc3iv/hDTZaxhBk3+hS4iEvBHoAkocD/kb/x7XSwPDo100SPF+JR5e4daL7zOcnw77mjnZVQR3EZQ+y8Ww6TKWyyAjLTj5au5exGW+o5eoJ7Hou8z8sreiDgRtiButf81TwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VHZVzRaq; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHZVzRaq"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45df7ca2955so729975e9.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Sep 2025 21:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757566571; x=1758171371; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/znQVoqdYnguqmx5WBg8gphSRKbnjv7YqaJ0uXheApk=;
        b=VHZVzRaqKJoWq06+o4ngCXQ7NPSPSu+JBUvb2VrTZH8uLdJcbbkzaA8SaJMF6MYJY+
         nw/4/gzZS9tfGe43n572aEXn5qh5xfPhSWWViEKVPXXHlLVU0Zl998GitfNnr0WK6MNk
         TpATXQjurEZ1TO83BenszeRZrjLzo+ynsRhn+pgQUd3hrwV4s/U1lGXJ5v2mefNozP6X
         hRI0F/xOFr8yRDRfq1LLGS4tTvv00Qpk+G/HSqGiHrSboiJCBlRt8PoCxsUIFl/CYhGe
         zfhCbWMq8KK9Tr9Vql0viJnhvpX/jmd4yc/gSsqq8TrEgR8IH+W/sJV0+fwGcmZUq0Qn
         WPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757566571; x=1758171371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/znQVoqdYnguqmx5WBg8gphSRKbnjv7YqaJ0uXheApk=;
        b=mwlbnwmkF0wZF02Zq0Twk0LV0f95E2+TPPAbDagqySTTWj+qAAE++xYZqg5rvcN/24
         zDKRx1GWVc3S57S3sH9BB2WTu7gxDMsi47FmnSyrdyuBVK8SmtM+LOej3z/x69UsnyCY
         wbAB79+agTo0uInJzNICTsIo0caQuldMVwpDUPrVNzZ1RJBgaz9lMHT+Tz1KG23eEIDT
         elv5xDeBKXEWbw/cII7hLAhEgURFYelXQRWRBOrg80Ae7P8xIimr/ihq8NKDoUx5GXme
         pwBbjdQ5PuyHoyQ/F746V2eBedKyQcsq2RhjVUwzPC2EdWW9a4wf0cpxzZHo52P9mgIQ
         d8oQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQwLs1WQMbZocmTbce4jHElnytqGxPPxuCdR9boF9ClcS5DxzS/gmovGLkOwxYwcXrI9sK37v73RAIIw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyAKUZizn2R0EFYNo08MqM/fi4fv0trByPXNyCkMmNuxneJwaqQ
	GcpK3aomQZI5D4atZD84DXwPzCcYMGVb/wXU84TiVmY29jlX79a/kO/v
X-Gm-Gg: ASbGncuAteLoeIqjE8grUUx+sKKiw7wylAjUQVJSazQifB2p+lWivlToZ7d/c9xq2C3
	B/QUOuoeRvZg85RP/Jzo8JoVQGoKjR3tB0DRAPwFx9U62VdkGcV0syoy/S8K0o677VHh2EI8NPw
	3+8f7+cQbkjIBe7RWOPWfJNm9mxDeK175eX8HUoj+NdolUNiQ+phX7xVaLixEulpX5scKpnjl39
	QheLbFqnDPFtZ6xzku0j5ZVcYvtDc9nO2TLtT4AiMJ72jsKjAwFUVLPH1Wz2bVua1e//rfenDcp
	KpTA+Facw+rRqRmWvNwpW7G7ySgDx6mqemqqNDh0P+jiuTAy8YwsPsP/6tDvr3GVLfKKla90DSm
	3OEcN0vFQ2v0emiIKZpMCZQOWOvV9wvdN/bHl3ATi
X-Google-Smtp-Source: AGHT+IE+08c9X5HobyMLxXhZ3NFl5GxQuz/7iatm7LXGN82shDvsjXSG1iJZArieNMj/KCrR4Zsqig==
X-Received: by 2002:a05:600c:1f91:b0:45d:d5df:ab2d with SMTP id 5b1f17b1804b1-45dddeef92cmr155477075e9.26.1757566570508;
        Wed, 10 Sep 2025 21:56:10 -0700 (PDT)
Received: from f.. (cst-prg-67-222.cust.vodafone.cz. [46.135.67.222])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607e9e6asm889419f8f.62.2025.09.10.21.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 21:56:09 -0700 (PDT)
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
Subject: [PATCH v3 1/4] fs: expand dump_inode()
Date: Thu, 11 Sep 2025 06:55:54 +0200
Message-ID: <20250911045557.1552002-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250911045557.1552002-1-mjguzik@gmail.com>
References: <20250911045557.1552002-1-mjguzik@gmail.com>
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

