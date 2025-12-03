Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0F0255F3F
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Dec 2025 03:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764732888; cv=none; b=BuxgwY3XqBJ+sjvpH3u9EKu7tCpK8B60beR51ZtAuvyNq0Gb6Ee5OgLmIc9Rjt/5gPdXCiUPtjeTEgPvNmLNbxTI1qO5n02vukYH9gEOSb+gNrh587UHwKmO1QnC1gqJmvEIerNA5hhSI3pPTY9ArFvygh6MQ13t6g523nQdEHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764732888; c=relaxed/simple;
	bh=J8nwCyeg94DnVaqWCEfUw6ETwfGA7GobiAsmhz5+eaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHxoEpduZ10Sucn0FQEa80HRDDG46XVCt/nakKudNS4o+fPADWdrMBshJ67+eyBDdm0HbvCWhTmcpHwRK7phmjuRT79BhDb6PMNnflgphzjOcVzDGbvb2KbMR0SKyQ/42zVFyL9sQTpCCqtF1Y30saReSdIvWoO/cNvaVqdiuhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Thl8Mik9; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Thl8Mik9"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b73545723ebso1218757566b.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 02 Dec 2025 19:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764732885; x=1765337685; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTNIQ6359N4GdAi3JYN7MZ1EQCxAqmS9GD/eyiPSc1Q=;
        b=Thl8Mik9PqLvAD4scOwvFtO9DaPkTouo+D0P25EFSUBGZKsf1s5ezpszugQ5ksmh4j
         g5afFY7TD5v9ka6pKD3MmFieJQEUBYeDRsdLiRVE8TR7nIullvR4OAXmU3rJkaxdzX48
         v53jWzY0We7l2PSkhCfWXuylrMcgtbxjRD0cZXEWQ+Fat8sxulcfLunqD1LPRmXswbcV
         32ptfvNSfEJ6Wc1MowyqJz28pruHj7meanRuOyT/yfSpWyf3eJHkvrnyo7Fosh+5Jmtp
         /A0oyUF2mu3sMXwH2WJ/2QQzo7HNk+Rln7dkvpfWn3++Om07YI0oGb4jRyrrzUEIU5NB
         icaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764732885; x=1765337685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RTNIQ6359N4GdAi3JYN7MZ1EQCxAqmS9GD/eyiPSc1Q=;
        b=O/vdjPLHbtjFjaW2mAV0ZSuDmOAMgw/xefUlzCZAGqWOPKt2EB88K/QEAb4ynKMCJ2
         4X+X6ympqLqu+Qb225kyYAHSRPhpO4xEJR1e0DaBpCjYPRsi+eSExOSV8uWZTze+ny4f
         WcXvzI6PV5pkaiKu2trrEzdqh1FDHuppKs5KlAaOUuK+0qBlkXRymVWsZV/jtkOjWQ3C
         6C6Bkjx7gPQqA9yEKzeZdv5xdLzP3KR1St9jHMYGS+1jJHki5Jl/0dLJbtkN184iH6CO
         2K3B4dFdbaehZr4ieJfxjzvLipn4RVrE4qTGx+vpniY/uTXm7iO9HOjgs1VGrSBrBxF3
         7kNA==
X-Gm-Message-State: AOJu0YxrvnnFPlahdDE+udfCzfFMLvcW+zA9KMhnHHlwoOAjorNSSHJ8
	M43dzvHmjLn8ucpIrIghrUWEQ0ghC0sxD3kojePwTfGnkGnlOZ5zutBU
X-Gm-Gg: ASbGncsBFD/PqM3n1FnXBI+lnYPAsqIP/Nu/wJFIdk17iKU2GgmuxdSIIG3UeH6xe+a
	w7xKrwfAvgqxySWMHEnVTtAekTC0Zi1EoSq7tFUPWRGlaiBaxOOl/2IKWLA/en5ynFLyD5mKl7e
	VFJ2K0ragpWzKksH585nKmqy9b4pVWkDEDPwee1yLruI897smOhMHQguCMi40bRW8VBydmcKrUf
	LV608G3+jNM5POIFb8QQKon2pUd5UPspI6g8CXkz4np0FTc+TpyH0w0y8769Y2TSXsjmooYaTba
	SCnoktsx+3vRuawgGhmoYSLVeLAUL4iVk8jTwm9FKK0Wn8KDuDKxr0xhwdznwG0/gsnwiWPQsRD
	etBRIjYpxCvsWatvTL/tk5ohhu0jCOEOmx/dCT6ezb7NZmlYhuH0emTcWZui3hbbWJnN7kZZvKq
	zAsyz0kzgwoiU=
X-Google-Smtp-Source: AGHT+IGZpjjL2vDegZyx8kF9oRaWEizjVikkzRNu1M6cNO4h0r+ykfFRWqignrAxH3E/lo2cYWdQyg==
X-Received: by 2002:a17:906:478f:b0:b75:7b39:847a with SMTP id a640c23a62f3a-b79dc782b79mr66011466b.60.1764732884656;
        Tue, 02 Dec 2025 19:34:44 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:acf7:8de5:59bc:44c3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5a4b757sm1658570066b.66.2025.12.02.19.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 19:34:44 -0800 (PST)
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
Subject: [PATCH v4 1/2] ocfs2: Add ocfs2_emergency_state helper and apply to setattr
Date: Wed,  3 Dec 2025 06:34:25 +0300
Message-ID: <e9e975bcaaff8dbc155b70fbc1b2798a2e36e96f.1764728893.git.eraykrdg1@gmail.com>
In-Reply-To: <cover.1764728893.git.eraykrdg1@gmail.com>
References: <cover.1764728893.git.eraykrdg1@gmail.com>
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
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
---
v2:
 - Introducing new function `ocfs2_is_readonly` to lower the cost
 - Using unlikely for status check
---
v3:
 - Fix compilation error (missing semicolon).
---
v4:
 - Fix code alignment
---
 fs/ocfs2/file.c  |  6 ++++++
 fs/ocfs2/ocfs2.h | 18 ++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 21d797ccccd0..ddca292944d7 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1136,6 +1136,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 				attr->ia_valid & ATTR_GID ?
 					from_kgid(&init_user_ns, attr->ia_gid) : 0);
 
+	status = ocfs2_emergency_state(osb);
+	if (unlikely(status)) {
+		mlog_errno(status);
+		goto bail;
+	}
+
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
 		attr->ia_valid &= ~ATTR_SIZE;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6aaa94c554c1..7b50e03dfa66 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -680,6 +680,24 @@ static inline int ocfs2_is_soft_readonly(struct ocfs2_super *osb)
 	return ret;
 }
 
+static inline int ocfs2_is_readonly(struct ocfs2_super *osb)
+{
+	int ret;
+	spin_lock(&osb->osb_lock);
+	ret = osb->osb_flags & (OCFS2_OSB_SOFT_RO | OCFS2_OSB_HARD_RO);
+	spin_unlock(&osb->osb_lock);
+
+	return ret;
+}
+
+static inline int ocfs2_emergency_state(struct ocfs2_super *osb)
+{
+	if (ocfs2_is_readonly(osb))
+		return -EROFS;
+
+	return 0;
+}
+
 static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
 {
 	return (osb->s_feature_incompat &
-- 
2.43.0

