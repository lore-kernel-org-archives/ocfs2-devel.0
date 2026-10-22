Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662499;
	b=EkJ2uYbd0k4fx3e5UnFhJs2G+u85SRLKkekkijRCxud/WWCm+nUByrFJOIKK/asX+xgL
	 apuRZjxT58RnYbt0pm49XKfeP3PtZUDMzyN93IY6uyTlnf7EIXk/IK7BC2L2NPGg0f/HR
	 S1TTXrYvPuXeefIeEqGXGSc0FcBBFXba2L9ZHFn3j669fV6rvQd8DTcdkBOZ6Qsxx9ISq
	 VkjfXdkTcIJ17lXtWUKMMTFbZC4nkSs0Wnju9QVbjDNH5BmK/eFTrfayvlQraBOrg7I5Z
	 Zbn+QEws9usJaaz1vCH4pvPS9zCgFycEsjYtUjt6MqVGvT2rOE0uLuR05Neaos3y3qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662499;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oN8PfD05VLTwYnGCsKQJvPE9xhzFQ5FE7iidQLuHzxo=;
	b=pOXLDZph4c12tcjQ62sqVX9ftjblst5McV1+0BeoeUVq7qM5K5/64gLonpEt7PAXN4a/
	 xJeXenUzWG0RuOpZGN0EHVgBkEJplUR3bv44dbOEAodOAPsKc2qi/U3N4b6WvXCP1Ddvc
	 I14kPzMOe1Rvx9cz+21oKD+EDLf1++PAXHtGRLTWZ0ebfFBizDqIzDdcfKw7IHhWS+YRV
	 aqWu+SvsTmv+bIC56l2RQZzn2ePV8dCleO6XXrdaRPpjsnqwzKoXSKWaCiuvuj8ogrS4E
	 vSbrnXd4RurpjR9eUy4YIogx/yf9WKXuIQhzQu0+mbL+TJPOt2Hkd3Nl/rAAyGBTFJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GNta1YOz;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8BC606A31D
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 09:48:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA8BC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GNta1YOz
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ac451e128cso1095183a91.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 02:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792662498; x=1793267298; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oN8PfD05VLTwYnGCsKQJvPE9xhzFQ5FE7iidQLuHzxo=;
        b=GNta1YOz60QRbPluyYraDrSd7Y75EDYExNfcRYwSj6zIlpDQrN8VIxo4hlRdizPsvq
         9UdEzKb2nsdj/+1aQeKiwrhBZkupgArSQeAmqw5VC4dylyokpt9A1VDHdJHpRQNV3VBI
         oSnpbq6Z88lYjjiI/tcLYr87621fq9ayq0tlQUEAiGA9j/6NFXBbJkXqw8Fh7dArUtDb
         nl9m5UXjMz/uCoLHuhrLNN6NTdX3XrFfSiM8y+Aauu54j1tFvuI7kLc/xu+PKnZIG747
         ZWd5xEzckh1Xh1ErPIhTWWFQpTtlKMdfDQ4XgyA4UQe4lsaj/PnfeQ/TpHOUyNp/BfCU
         iORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792662498; x=1793267298;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oN8PfD05VLTwYnGCsKQJvPE9xhzFQ5FE7iidQLuHzxo=;
        b=Z6roF7V1QsHT9APK5QRczCeIQ3Wl5CZO2fkKc6VxTf9HrXGKkpP3h2Om6qqNijHBgG
         MZgukWKp+5tmetwJBG2/Ahzg7UCtg6X8RjGFN3U9XAqkCqkxNkgT0r/Un5/u4J8ouOhP
         c+GhWi8RHdBk4wZJTAcjbJ0HMQ73042yYs9u21of5DCe71eVB8AT6jMmMaImIe9dWGH3
         KrjQB4vR7CQofXtatx6t0XHcpGZ1ulkGi0FsHmrf/Aws8jU/AK2HL2Jf5zVf5N2HEGr3
         PVIkJ+c5+zSrBNwPuwRGBUORMkDqNrepN6W/l2Ui3mwjOSlmlVTyOpeCE/loifaMzlw2
         eK7g==
X-Forwarded-Encrypted: i=1; AKwUvBzqtq+fwJix1JrVfJNmrwlEMs8zY+M6s/gxFA6TkrUAonQKbCbiUEdMTDbkGEtEUVFPzpYd1USewT5zTg==@lists.linux.dev
X-Gm-Message-State: AFq9FYJnUgPhNc+NzH+WMCe3uuTOto7ndCR3ZY7uDyArjsToPHDAN0x4
	D/saRCrzCM2G78Wz+FTgkDnQstBGEXtwDzhWTJ0cRyDD4yblNEpJlY1w
X-Gm-Gg: AYBFou3TCHRzUcmGJe91B8XSzf2rKTFMoBMrf7EJMj7bg/iZqNsd0dPsqPM9tQS/KzP
	ARvHR2blQYHTMqR3Og1tQ1NXWwFYb9dLt1Zx2VWDDaLZ4VB6YB3Sm0r4eQoLEupM3mycA1EdJ4h
	KQyyVy4pne1v3uLnhXilaAPmtdmlCCPw+eMRXk7XEhBVeW40B8mF2wZ6hLgnxSoNM3b8GEr5xJx
	OjBI7tOpF7kwX7shoboTSzUh48CF+OYi7CiUzIjV35bP9MAgEP8lUaXbCUnK0C836/KEDEBZUNk
	YyK6iJHdp2ETTsFuuYw3GU6VjPhBHysKfTfrVNM5sE7ui00IbE0XlHLh1FGgl1dXJgC1iNyokUV
	ScDQpBLqDoZg6FzXoIFJdi39a+rXEwy375seWVWwx0GV4PWGrQtDHi+rpXM1cKVz78LldbWzn5x
	PkYXF6Pzd5Va7YEYYdGMZBHXNYxTjy3vE//ps0DDKmemk3bXzg32o/rbdaWTQu3P+bWg/uPwo4g
	BcRGqZLjUNbx6rzd67et706Yum0oC+XMT4FGG98aw6l3YX8svU2pYNF6PB9/Bj2F0CX/Ozk
X-Received: by 2002:a17:90b:4c52:b0:3ac:403d:6239 with SMTP id 98e67ed59e1d1-3ad86ef4b3amr3428235a91.43.1792662498181;
        Thu, 22 Oct 2026 02:48:18 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4954979sm3480681a91.17.2026.10.22.02.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:48:17 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate move extents against a stable EOF
Date: Thu, 22 Oct 2026 17:48:12 +0800
Message-Id: <pm-ocfs2-move-extents-isize-rrw-v3-b2a7508c41108cc2d00b@gmail.com>
X-Mailer: git-send-email 2.34.1
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

ocfs2_ioctl_move_extents() checks and clamps the requested range using
several unlocked i_size_read() calls. It takes the inode and cluster
locks later in ocfs2_move_extents(), without rechecking the range.

A concurrent truncate can move EOF below me_start after the first check,
or shrink it between the range comparison and subtraction. The latter
can underflow me_len. A truncate after the initial clamp can also leave
the range extending beyond EOF when extent movement starts. In addition,
the me_start + me_len comparison can wrap for a large userspace length.

Use a helper that reads EOF once, checks me_start first and clamps me_len
with a subtraction-based bound. Normalize the defragmentation threshold
using the same snapshot. Keep the early ioctl validation, then repeat it
after taking the local inode lock, rw lock and cluster inode lock, once
the inode size is stable and refreshed. This rejects a start beyond the
current EOF and bounds the range before selecting or moving extents.

Fixes: 53069d4e7695 ("Ocfs2/move_extents: move/defrag extents within a certain range.")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/move_extents.c | 49 +++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index ad1678ee7cc4..ab08c273ca52 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -907,6 +907,30 @@ out:
 	return ret;
 }
 
+static int ocfs2_validate_and_adjust_move_range(struct inode *inode,
+						struct ocfs2_move_extents *range)
+{
+	u64 i_size = i_size_read(inode);
+
+	if (range->me_start > i_size)
+		return -EINVAL;
+
+	if (range->me_len > i_size - range->me_start)
+		range->me_len = i_size - range->me_start;
+
+	/*
+	 * The default threshold for defragmentation is 1 MiB, which
+	 * matches the maximum OCFS2 cluster size.
+	 */
+	if (!range->me_threshold)
+		range->me_threshold = 1024 * 1024;
+
+	if (range->me_threshold > i_size)
+		range->me_threshold = i_size;
+
+	return 0;
+}
+
 static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 {
 	int status;
@@ -936,6 +960,12 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 		goto out_rw_unlock;
 	}
 
+	status = ocfs2_validate_and_adjust_move_range(inode, context->range);
+	if (status) {
+		mlog_errno(status);
+		goto out_inode_unlock;
+	}
+
 	/*
 	 * remember ip_xattr_sem also needs to be held if necessary
 	 */
@@ -1028,27 +1058,12 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 		goto out_free;
 	}
 
-	if (range.me_start > i_size_read(inode)) {
-		status = -EINVAL;
+	status = ocfs2_validate_and_adjust_move_range(inode, &range);
+	if (status)
 		goto out_free;
-	}
-
-	if (range.me_start + range.me_len > i_size_read(inode))
-			range.me_len = i_size_read(inode) - range.me_start;
 
 	context->range = &range;
 
-	/*
-	 * ok, the default threshold for the defragmentation
-	 * is 1M, since our maximum clustersize was 1M also.
-	 * any thought?
-	 */
-	if (!range.me_threshold)
-		range.me_threshold = 1024 * 1024;
-
-	if (range.me_threshold > i_size_read(inode))
-		range.me_threshold = i_size_read(inode);
-
 	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
 			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
 		status = -EINVAL;
