Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660136;
	b=fzCz+V1tn703lrKrdQYGAWVo4XYKTA+6sOVFVbQ0sC1pgwndtE3L2tG1hayG+O8iMhrz
	 dr9HWA0zo/30T6NrU4HRrxNFH7/pOKP7MHw93oj6zAY5XPdtMfC/zNWzEQ5s8QVrIFXWj
	 XqRTz9ldVoiLLf6xKnDqjYfyPrGXBPpMssFGabgFrwum9tJMAhsOlFK4al+Zf87Qj2PBA
	 2eXP118SPjQQGo78nu07wN/3hAkrxiOCJ3QoeOFZIGoqwEVVAVW4G+qAI0X3llYz8uLAb
	 9VAlmEwHsXP5uWHoWMAWg8cfJQLOvNO5Q0R/DoQugtZi3aYJCBnDEQUOklw66Uut+9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660136;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=djon3MaXCvkq7QGoVgGYTZVR9paDezDGky2Radk1/Ys=;
	b=USjXdDNEXX2Qo5wcuxleKcxQtN4xbnl70m/8KbYxF+c8xAfzNDiLka9tZL4S84vL7Bjs
	 xloIfDiiTKycqbB4lv3kJbNPozMQFjRm8tWg4yNW1Xi16RYO9vvGb3hAcii2uzCUpSU6X
	 NivklSbKRSG+9lg3bdMueTu1CosNueXfgt5c91IQV5JbOx7g9vPjPdnHmvxi6ifO06EHx
	 ONRM4eWCOKWse2jseS6ryPk/NslM0rZ7Nhwbmvgsot+R6UWA7oRNEAl+pLWUgu6Xy3DZY
	 YvPA6guXHvGvLYsS4GWhmek/yVC+9jE2jRWMUtL0cNP1BJKjumWWAr0GgnpUfInMPKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cVA7Blon;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C59606A332
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 09:08:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49C59606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cVA7Blon
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so440018a91.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 02:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792660136; x=1793264936; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=djon3MaXCvkq7QGoVgGYTZVR9paDezDGky2Radk1/Ys=;
        b=cVA7BlonQoyX7o0ilRL7aVyLsgCeMcHdGKlg2qh2VfJiSM3U6wbwnZTfgewiLgkrjY
         Z8xUXJwFIxHEh/sWL6pIl+Hz+SocU/RkDI7jkNw00dSi40c+RHmoZsknXPg9sKm4sp6U
         +9ohKE6i/jIgyzrNcJhMIiMp4GYaa+MimftvqSEAXcGDlwWrxu0gXR5QCGzZMMFawolc
         zSbp5LWet4ypiIQPxTsF8U8mTkt6G2NpNUK7n0XqexMe4AaZ29pOIY0ly388gRWhM3Ba
         xX+c4Fw0/YzwRPUa7WJzkRqA+tyqaFw2NeB650zsFPrG1ftqPgM2/NiQIT2oopPDsiCS
         GUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792660136; x=1793264936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=djon3MaXCvkq7QGoVgGYTZVR9paDezDGky2Radk1/Ys=;
        b=aw9uKFEAGgUJBoHLTTVAejetGDxlrjZcjEWxsoIOWZXKsrVfe9IFMNaMx85pBAueEg
         7O3NqxXTwgDpTldYFrl4BLJMoOGHK7osl2NVqbITPAdTV1LC/D7c4NxA1vBYRZjFJNUE
         iWUTHqTzmdlKB5lr4ZHegtGIA2fNbLLDwFqw6LMgGXD7vpmo29UXtTdHJEhgjwivDdj6
         fjyGTlqslOmXbXx+M475qSQota2WKspV64LQHozP2t/b+07+zCXeP+JRiQIpo6V7h2z0
         Q5S2TGYMQvRg0lkznaxCEyu9xcZZ6xTYERZYpsbMiLbH9PAhmCLcajmWtgzoD+A9WYNL
         j9mA==
X-Forwarded-Encrypted: i=1; AKwUvBzxjUC+Tq24hN+saQm6d+r1tvBLsA29fP504E1Cyg2NpYhKXIT5UGLd1Bd1QYSbZok/rVrBGAaPQcZnNw==@lists.linux.dev
X-Gm-Message-State: AFq9FYJ/LGLaDUsDqpG+M9LxKsMaKS8Dve6nVF7yEBZMGxBl6KxlnhTX
	j+X5jeIv4Yn2A+3R3UZS7FIxqKtEeileX5x91rpFFjFbLeRoWPfUHp+E
X-Gm-Gg: AYBFou3iW9DBqESBXFtvV8hYpj0g+443Fo1oi4vjObNiY5H20YI/S7gt7VBp7DB79Lh
	2VCB6p0fZQZsOLx3Bt4SYT6eBw71HdrquKp6K+t/1PEBoL+t8sSjABR4nOG0bFHmZ/vG/BO+668
	Lz5bAdGdGxM3Q/xve9Do3yIaz/+nl7pP0Cmd3oh9s3+TkOx7xTne4NnDyLhncDA4pqt14ADkZ+R
	e4ElQqpkVI5JB4UGA1ydjVWB46b4fK5lp5w3+s3HMNXK0EE0hQ5xLBaSNNDZYbZzKJA5tK8/zsl
	RbANXCtfyTYSz63xRKabloN5XBiT5rOLznwRw2OFcJfyjMm/O3Z37t0h/sVeqZD7KCoeYunECBY
	92XFG+HTFa8IfI7dfZRJHZcSoq1hNNZKSexUHxFuFThIqpMubmTa466bkg8eusWyW34n+gGsPBQ
	3eA6aLuk0S3+gGDrCH33V0pYGxT4y3pTqrzVzj83WSCUqrH9rwBQzmoqErEhXkNy6CA+tUHeFfx
	i8a8ZC1ozhNaY6KKZF7d9rNplmO9ilZ4rSlqAyds7HU/wNSN34=
X-Received: by 2002:a17:90b:5868:b0:3ab:330d:6e47 with SMTP id 98e67ed59e1d1-3ada6c6bb67mr998870a91.10.1792660135625;
        Thu, 22 Oct 2026 02:08:55 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada490c096sm3325111a91.7.2026.10.22.02.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:08:55 -0700 (PDT)
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
Subject: [PATCH v4 2/2] ocfs2: snapshot the dentry name while tracing file release
Date: Thu, 22 Oct 2026 17:08:42 +0800
Message-Id: <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-2@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-0@gmail.com>
References: <pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-0@gmail.com>
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

ocfs2_file_release() passes the live dentry name and length to a trace
event while holding oi->ip_lock. This lock protects the open count and
delays RCU reclamation of external names, but it does not serialize name
changes during rename. The dentry can switch between inline and external
names, and a separately loaded length can describe a different name.

The ocfs2__file_ops event sizes and copies its __string separately.
A concurrently rewritten inline name need not remain consistent between
those operations. External names can also be selected at this call site;
the existing spinlock critical section protects their allocation lifetime,
while a snapshot additionally pairs a stable name with its length.

Take a name snapshot before acquiring oi->ip_lock and release it after
dropping the lock. Keep the trace call and open-count argument inside
the original critical section. Cache the event-enabled check so the
snapshot stays paired even if tracing is toggled meanwhile.

Fixes: 468eedde23d6 ("ocfs2: Remove mlog(0) from fs/ocfs2/file.c")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/file.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c6e7606ff9e1..b3a37b9d259a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -141,18 +141,26 @@ leave:
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
