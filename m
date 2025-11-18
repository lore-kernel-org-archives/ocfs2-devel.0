Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3539626ED37
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Nov 2025 00:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763425658; cv=none; b=CvfIf/+m6dI8mDGazv9oLvS0ucJDDof3tf7DMka7IcPn071wKpR37nBKxRSaykUO3BvnWQ7ODBw+ku7XbKgCvC4ai731DeJovX8NcPaph2Buyw+E66/YFdFvB0W6nAd6TuKWDSnZvc5Flytyf05nxORC+QMELEkv13ETG8G3LyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763425658; c=relaxed/simple;
	bh=r2r80AC1AABbcwjkeqa459fe8/Tc53amJFmxi/OF0a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnyUwdPjzEmx48E3c6MvC4rvMEvNXnMnW6kFYQV1ZU74oHzPpsqTsIJMAFnznnS7ZdXadJqfJXHUfTQr2lRCDa8TknHiDNSnYofj72PTsTt5aFLKuO3ifjioIONZHIkf1qDHhE35TLSaHpr2PUD9LTEJAAYIaXADk+UjJFlugvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jlTIoheR; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jlTIoheR"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b725ead5800so591347366b.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 16:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763425655; x=1764030455; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7II+12gmozjCQ2NvhjWVSTUgl840K7iM6j+Wh+0OMOE=;
        b=jlTIoheRtkH3/SuPQSKJxD+Gn5NH/X/AojBzop6+Ape/nADzOjucpdL7h6n9pYgawb
         KKseKw6PSeX1GG4zroeSLKrvMsTh59yu+1efM0drPGWV6WMUQc1gfGIQ3UK5kN50pO4+
         YA+tHoaYh1cfUm5wUhH/+JxugfxOU7Qr2RNNeUiWK4cgSjvc/+w2He62QJkEZRLBbOD3
         odapJLnAvNbEa8im0WUlwHwCe6rBgsksvTKjcPdUxmQ3bF84v+JjpJDc60oBv4cwXLSQ
         fD5YsTfSdxgKMbJMgthO+1aJpojO8F9IEGHTbbj4PeN2lY6tojT56zoPOr1YU6n6DaC8
         XhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763425656; x=1764030456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7II+12gmozjCQ2NvhjWVSTUgl840K7iM6j+Wh+0OMOE=;
        b=mIfheQzaUjtYMrATqYyi2WqneLlZdpIJhnJMVzx1eF5nu1JyVdW65NIrUBeWUed1ON
         WfwgV8x8RXz+k/cf243MFoqdqVgF6fT5LBW9rz2G8F9YsrPEvy0KwY4RGeh6x2I0iy1r
         giP3mlzjfr35/DuqNLb4bDibK/MMwZpQjkD+kkfNG6PnWaVCCO5hsHMAWp3PKktH+VrF
         8LaVmh1M5mYDT5fJFBYyDCZ2oZdobECq0KvDFGdvVzHj9iqBgpVcEaF69QxkMVEhXIQE
         I1I7l6yaAwGyHMTupsybiZl+O8QreVcsaWd6epAyfkMMYwfzYZsEYJmJJoFsj1dBjSu7
         3e4w==
X-Gm-Message-State: AOJu0YwFRuFVDgY9OV3Asho32WZcvqvhdmbak80wt82xET9swkGaGYIs
	6PvF7lYDLbeBqj+CcdeTZD/flpdrAKOanUhvu1oVVn5gD6yizGokV8Wp
X-Gm-Gg: ASbGncugutfYCR0UEiS/Fadu7CZGlGTY4w6BrBYqawvslcuBqOkSCZAKH4FRr+cS11Z
	TtBnh8x+MyXlki4DDz6TgAfi7d+cs+tQgOd8OZVg6spSMvSutEYvwFvDN8Ab+RmO/5+vNUsowlZ
	CTxCkyeSJ861k9f2wN+fRQlCzMihsizDnt36KfQH7eehEvCPVdPj0IiKljbMsFMyJmec+VhDqWx
	p090Jfv7iJuIIFVHiX3OOk4fWaZP8yzklUG55drhqNQVoHBmWJP/yMbhZA2QC8yiQWN5FNBKOP4
	c/j0bROBLF8KTJSkvkHWbfj0/FYfjvgYxB6d6okZTuqq/piIqNQQwZZcwZeqWoPPdqj2gOiUoyP
	4CdPFt9GbYhplqo0eVQvJFxTMtL1WbkwTG5YA/Nd8Q7LMsN17Jrcc+zm4ltGrj7ncYcvH6bcezs
	aMJB60jdYV/zGJ7jfNc2PSkA==
X-Google-Smtp-Source: AGHT+IH7E0M3D2XXIS9vufslhd3Lmf8FPoSeWLitFy6VWcwgaj6CSSMwhUHU579T8towY2nrsMyIQQ==
X-Received: by 2002:a17:907:25cc:b0:b70:fede:1b58 with SMTP id a640c23a62f3a-b736780a96emr1175091766b.2.1763425655501;
        Mon, 17 Nov 2025 16:27:35 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d08:f72:eb64:1d0d:5855:afe7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fda8a86sm1172606466b.52.2025.11.17.16.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 16:27:35 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: [PATCH 1/2] ocfs2: Add ocfs2_emergency_state helper and apply to setattr
Date: Tue, 18 Nov 2025 03:26:44 +0300
Message-ID: <f60d7b3669ee3bebc11895795bf1bc9c990fecea.1763337347.git.eraykrdg1@gmail.com>
In-Reply-To: <cover.1763337347.git.eraykrdg1@gmail.com>
References: <cover.1763337347.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To centralize error checking, follow the pattern of other filesystems
like ext4 (which uses `ext4_emergency_state()`), and prepare for
future enhancements, this patch introduces a new helper function:
`ocfs2_emergency_state()`.

The purpose of this helper is to provide a single, unified location
for checking all filesystem-level emergency conditions. In this
initial implementation, the function only checks for the existing
hard and soft read-only modes, returning -EROFS if either is set.

This provides a foundation where future checks (e.g., for fatal error
states returning -EIO, or shutdown states) can be easily added in
one place.

This patch also adds this new check to the beginning of
`ocfs2_setattr()`. This ensures that operations like `ftruncate`
(which triggered the original BUG) fail-fast with -EROFS when the
filesystem is already in a read-only state.

Suggested-by: Heming Zhao <heming.zhao@suse.com>
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
---
 fs/ocfs2/file.c  | 6 ++++++
 fs/ocfs2/ocfs2.h | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 21d797ccccd0..03a98985ac92 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1137,6 +1137,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 					from_kgid(&init_user_ns, attr->ia_gid) : 0);
 
 	/* ensuring we don't even attempt to truncate a symlink */
+	status = ocfs2_emergency_state(osb);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
 	if (S_ISLNK(inode->i_mode))
 		attr->ia_valid &= ~ATTR_SIZE;
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6aaa94c554c1..2ac16632dd19 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -680,6 +680,14 @@ static inline int ocfs2_is_soft_readonly(struct ocfs2_super *osb)
 	return ret;
 }
 
+static inline int ocfs2_emergency_state(struct ocfs2_super *osb)
+{
+	if (ocfs2_is_soft_readonly(osb) || ocfs2_is_hard_readonly(osb)) {
+		return -EROFS;
+	}
+	return 0;
+}
+
 static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
 {
 	return (osb->s_feature_incompat &
-- 
2.43.0

