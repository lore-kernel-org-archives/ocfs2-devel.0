Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CC82749DF
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 02:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764644112; cv=none; b=tpO1v1iHEsUhtTeKyvEipGFDXfb1TYK6ebyqcHaXSlVCj97ZHUR1HXqzGjOz0pyy4f9jiAv4inuvOFrOW5qN5pwU7drcnOAZtSUrx0PXv59o9iylJWljoFlxEA8dDr4Ell9Hz+/BHKjNk/DrBkTwDIHUzv5k4ZeMdLDfIkj3d+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764644112; c=relaxed/simple;
	bh=yH9k7/tFAuvtIW9rGhUTKwseJd0t3U5D9DGzL9whDpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/pjWL8gtVj6pzIZ4ABdNKUAoO80HIZ+9REBAi10hHZPap1zmXoE1Ytbc382joYidoPZHaOMezuebpNlIlbgEO5YBURG1EYPwoXNq/8SUyuvv1njqXsX0+DzyQT0tZ9aepfPRmxNmUb7M2sVvqzOaEJCCwfla+3BDCRNfCPYAXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PZ7mGg8P; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZ7mGg8P"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-644f90587e5so7853185a12.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 18:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764644109; x=1765248909; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hFDswTxukywhcdHMNKsrI1xSpEMfAznDaDbrbKqsNF4=;
        b=PZ7mGg8PmElmfggfIMckqGxCCKPs4HcQmTLExCLWMviKi1pkwR11AI+xHZy0vBgauV
         fswyufGtrhxgc2Kt9i2eRLy6jE4pIzxwfJnKKbmSemZyjmikqOEpUs5neOg8c7V2F72j
         S5RT17b5QqCy6il0QSFDCtk8z0Mr75xUtntsSMBZnFgR9IC4pNuSxeoO1JFMlI1ZgYTr
         8wEprhHsg2nOWIXDkUR07ZNm3NKrGbS5RhGXhNKzXjD/kOkgvQD/+0mJiWQ9qFWjDihu
         UtJtRn4nIl0D+qwvoJuexSfbHLp67+0vimyLIlq3dGEnHl3PvzXS0rK4KNXMXosLWVBz
         mdPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764644109; x=1765248909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hFDswTxukywhcdHMNKsrI1xSpEMfAznDaDbrbKqsNF4=;
        b=aPiyXfe8UvpuCPeQEdRmfDPSOwW1spEBCXthqpcMUv5fXtFVERf/2A328YL/DwAPm1
         RQfxqsJKBOUQ274Y+m53ShFoJTKZ0iX2/Vikxs55wpS4KEETq4+qTi2BBUcVvObvIKDS
         nO+/p6F5028NSLPIYRdfJpDEbIBTT4nkFZ5drJh/4X4vnXIH500aaEKsFfkdtUCluXQn
         OwTlvo+V4lGSd5Ge3Ovf0CSwJW6XJ1Kl5cTWC+aA2LHcUI+NNK430DJocHPdVs62IQd2
         qK9RDuzhlzCms6IG5ZzUAXpyldAVfcr9lT5ptZcZEkAVDFOgMAk5FVDVQpGbysO9+elS
         ixWg==
X-Gm-Message-State: AOJu0YzcxDA6houiTj2KWznV2xm6oDOu0qO1N1buI7M6HjLF7xSHCI/u
	HO9gh2YPVEhQIs6PGSxn0NBDI9Mr53xrojXB6EO7oqG7OYzX/FeMPEOb
X-Gm-Gg: ASbGncs3wW5O2fZkq3YUvCaoi+fq4JMXP7uHaEIB06/w/be7TdwcVcb7j6OwIUdIMz3
	QDuE2508UjtNeWai31zKEvnsIHnmz/LOXl/QPZKyDeIc+Z3lMltD1GcfH2anfXLx6Johe1Zg10U
	bzmjUnavA1Tv22/hnS9dhjMmiBhI4TB5DPdeBjV96rbEPwqbWpWHhwl7nr9xu1xcghiWGem7JHj
	/4YCWswcgiCahOOR1mF+8la4UohzfVbD1zr8tI3Auvj3tu2wFRMAzwJBdGMXN4nicZ/WQTBWGaQ
	UgSjOcLOreqwYRLDhMWTzLdGMVlsFr9Upr1d8l7ZJvgZpfxp8MevYjQDtOXXdmXuejyxbEROjzR
	PngwhnHvu1m2Yaunrwvp91q0IfoHS3yWEiF8G7hoao9k31dcLD+yKuJ6JWS5J4JRAYmyHEc2+ys
	ALb+trcOw8JNI=
X-Google-Smtp-Source: AGHT+IEoGtVlHjjMVDnZp2+zDl2J/ucvcCY5PTl0CGSsCQayrreQljtqSXTlX46bb8VrfV7G9pAwdQ==
X-Received: by 2002:a05:6402:3510:b0:640:464a:56ce with SMTP id 4fb4d7f45d1cf-645eb213954mr24671088a12.2.1764644108707;
        Mon, 01 Dec 2025 18:55:08 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:8eee:b306:2d20:a328])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751062261sm15753978a12.33.2025.12.01.18.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:55:07 -0800 (PST)
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
Subject: [PATCH v3 1/2] ocfs2: Add ocfs2_emergency_state helper and apply to setattr
Date: Tue,  2 Dec 2025 05:54:57 +0300
Message-ID: <8a26b007729e3f3f813f754eda6eed59431502e1.1764643790.git.eraykrdg1@gmail.com>
In-Reply-To: <cover.1764643790.git.eraykrdg1@gmail.com>
References: <cover.1764643790.git.eraykrdg1@gmail.com>
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
v2:
 - Introducing new function `ocfs2_is_readonly` to lower the cost
 - Using unlikely for status check
---
v3:
 - Fix compilation error (missing semicolon).
---
 fs/ocfs2/file.c  |  6 ++++++
 fs/ocfs2/ocfs2.h | 18 ++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 21d797ccccd0..253b4f300127 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1137,6 +1137,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 					from_kgid(&init_user_ns, attr->ia_gid) : 0);
 
 	/* ensuring we don't even attempt to truncate a symlink */
+	status = ocfs2_emergency_state(osb);
+	if (unlikely(status)) {
+		mlog_errno(status);
+		goto bail;
+	}
+
 	if (S_ISLNK(inode->i_mode))
 		attr->ia_valid &= ~ATTR_SIZE;
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6aaa94c554c1..91a861babf74 100644
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
+	if (ocfs2_is_readonly(osb)) {
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

