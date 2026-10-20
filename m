Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792467847;
	b=z19ECcb0ztwDhntyJOqNOAfopiFXbwPQcADbviYahrF9tvthTkwh3brIf+8Wx9/ashqL
	 auQGFyoIIdzmXn7JveyJuWdewkLaIELma1m5dVzNjPUC6pUPHKSJtOycStB7m4x9gSp+z
	 4GI9cYQdiqTfCfflczXHSUBgM1tLv4mOzLOhWPB2Zt7tdriXRL4oFsFpbpszaMG1zwUiP
	 qFQn0oT4nWPzagQnEjwYzBUMFConZzcWWQwpre5sdGLYgO13uYXdsEfd/QvmVbEykO+CI
	 vuJDnzPrd/N2lboM5nOYG+bt97ks3JiKe/DNgKD5PyKUmcI4ja5hIXpG3rXN1YV6uVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792467847;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w90pHw3fGNmejRxHV3IQ5d0u+flhYgOFmkRKLGlwKUY=;
	b=GoaYKkBhndfGAvhP68TxMiqFvQ0hVSZPM2OQ+TUaYj64dQHtdp9YS6VuoPlUKznv3l08
	 k4x6YAhQOxes55iYSkX3RFoc7nkwSU2gViu4t6/jGBT/RzOhVbPwuqarp4XF3VTWF9sFq
	 7iSped0djSEH9y39+Q8JswL6ceStWy9MKpCeUAnLrtWu+Ty2xU+GZKISJsG8/ftxCw4jc
	 WRLsNzCi/GL0D1VpgMUP81HRs70B64HIpja1v7GibH7tzPEVM7juk+hrQhOW3JCiqm05X
	 mSu3jy7S8pi43OhIcWHeh5bHBu2yp4YTXNz7TQnWfBqEqQ68xycpfNY64Ylxv26i04A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eAwVxVDT;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C61606A33A
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 03:44:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7C61606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eAwVxVDT
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e901e114fdso13628445ad.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 20:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792467846; x=1793072646; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w90pHw3fGNmejRxHV3IQ5d0u+flhYgOFmkRKLGlwKUY=;
        b=eAwVxVDTFpQiZaBQiPE0wGwsEFdfUyih0GhSuiRAL/hDJO7JAYLxJKQu06Fz1UgrhQ
         0l76ejtVaU4N2T0XPUpI7/UVT9HxBbjXtxW2hCzsGxrHNElTHBusVvO4wu8sBo+29flF
         Qow0zfjptLaRzMfJRNJVT5tCEFKm4D7+UWUUAgCWroP+/mlK8eFiGf3yWdjr2qFVznKc
         /JkdVlDumjJ6X2rXNu9L7Ij9ABcER/BlQpWpAAN8bR0uiYf7NgK7eXg6owjmIXRI+PTM
         fxWW4feAyXIn6FOySYCnLdrdfz0Fs2XSr9RfNVms6pE8BHi41KA0lO6wGNs9BwkyWqW+
         TenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792467846; x=1793072646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w90pHw3fGNmejRxHV3IQ5d0u+flhYgOFmkRKLGlwKUY=;
        b=hFK5rLCbIuWxWg/8jPwT1x5JG3JcG3Le1SMC2JjJkEw3l8ntsSd3iCrWkIps7Vh5Pm
         TZbHDJNSSW4zlafBrKZdMWk7snpgyeuFNfwwMRE5NifRRO7QBAVpDlZKg5w3TrHHOjph
         SrIkqMYJTJCrDgKvT+ppPqtJO/EQqfOeJMoiHsir7t0wynfd0r1DtEbj+Z1uxkhvQtOb
         1Qe3+ptuT6P1tO4KSInMN1kJk7639CfcH4xljMGJzMLB0wQrSAzR0NdbERPHATws9kqv
         HgoQ6PDsI0eV40R7iibLQV0gD/kkQ8K4Y8RPh3nhwgTmaH8ScTEbKB50Omzd6vvtbkSg
         ETMg==
X-Forwarded-Encrypted: i=1; AKwUvBxYn35nJXlHXwgJr5q2LD3jQv90FQNXzt84v/rKJ0kRIfqAWXRy0sp7CJVrEGBXx12FJlO819RyVysbfQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYI8gvo4Nji/Zun0fcxbz4MatALp5XYERg7hY3G4Y/GNluLj+Bw8
	d7Mslb0jlBqsfszwTBStrTY9++R7TWd177cjNyZoRcGty72qFS2dGdEEdDDMcYnxV+B9Ow==
X-Gm-Gg: AYBFou36rav05oK0btzxl69k7HYHxhob48E73Vqtfk/uAW8iAa2qdy9Y6dqAwJ84JLe
	QS+mXnPT8Hw8oDbqaQWq+6JGC2ts1I4Ky4cTg7h4eXazTxlKdlChBOfwSU5EXhSkyi5UpLPrMSF
	JrJXUvpo9emb1vSCI7WbB3M3jrA1I0O4KT8rEaBr9LT0+MYFj38Q7qKTwD18tiIwBBYht9RfGnw
	Hj0/xhH3cR9Q9GUU9ulJbdted0X//dpfPHn8IgQDsmVBExzfzdLkWYXmp1DQLpgwFuU0QIFShMd
	hbv+0gJfQDZrRJg1yA6VpmKZUSyi4jBYUCWbvVPoU1L4Egxk/si4fP+n+Rj+h8HUQw+0P8TvM28
	uUYCSTDaAGcgTIHPQgg4Gm5PZiHkzX5Dl6V8y1NzT5dGuLH0tw4HyKgUluKcUEbWFwLfx4PpvBW
	Qi/m9qgfLZOwR2D4pPsSKkn5aet45rPmmyPDlFuaFsJZXNY5VhlG8g72jBdP6sGVXh7A==
X-Received: by 2002:a17:902:c40a:b0:2e5:e1de:9c3c with SMTP id d9443c01a7336-2e9a6d2b9b3mr84139745ad.47.1792467846122;
        Mon, 19 Oct 2026 20:44:06 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea14caa857sm8143885ad.12.2026.10.19.20.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 20:44:05 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v3 2/2] ocfs2: snapshot the dentry name while tracing file release
Date: Tue, 20 Oct 2026 11:43:52 +0800
Message-Id: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-2@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-0@gmail.com>
References: <pm-ocfs2-objects-candidate-0088-v6-d3056754af7e660155d9-0@gmail.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_file_release() passes the live dentry name and length to a
trace event while holding oi->ip_lock. That lock protects the open
count, but it does not serialize dentry name changes during rename.
The ocfs2__file_ops event sizes and copies its __string separately,
so a concurrently rewritten inline name need not remain consistent
between those operations. The separately loaded length may also
describe a different name.

  Release trace                        Renamer
  -------------                        -------
  hold oi->ip_lock
  size the inline name
                                       rewrite the inline name
                                       under dentry->d_lock
  copy the changed name

Take a name snapshot before acquiring oi->ip_lock and release it
after dropping the lock. Keep the trace call and open-count argument
inside the original critical section. Cache the event-enabled check
so the snapshot is paired even if tracing is toggled meanwhile.
The snapshot keeps the trace name stable without extending the
inode lock over snapshot acquisition.

Fixes: 468eedde23d6 ("ocfs2: Remove mlog(0) from fs/ocfs2/file.c")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/file.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 3c4637b32c09..8da73d0707ce 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -141,18 +141,26 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 static int ocfs2_file_release(struct inode *inode, struct file *file)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct dentry *dentry = file->f_path.dentry;
+	struct name_snapshot name;
+	bool trace_enabled = trace_ocfs2_file_release_enabled();
+
+	if (trace_enabled)
+		take_dentry_name_snapshot(&name, dentry);
 
 	spin_lock(&oi->ip_lock);
 	if (!--oi->ip_open_count)
 		oi->ip_flags &= ~OCFS2_INODE_OPEN_DIRECT;
 
-	trace_ocfs2_file_release(inode, file, file->f_path.dentry,
-				 oi->ip_blkno,
-				 file->f_path.dentry->d_name.len,
-				 file->f_path.dentry->d_name.name,
-				 oi->ip_open_count);
+	if (trace_enabled)
+		trace_ocfs2_file_release(inode, file, dentry,
+					 oi->ip_blkno, name.name.len,
+					 name.name.name, oi->ip_open_count);
 	spin_unlock(&oi->ip_lock);
 
+	if (trace_enabled)
+		release_dentry_name_snapshot(&name);
+
 	ocfs2_free_file_private(inode, file);
 
 	return 0;
