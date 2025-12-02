Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B42D25783C
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 02:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764642509; cv=none; b=coJFckTpTrb89iqC3NEDkNDEl4cIlhmedjOlEKU3aPDu07wGaokR0DMG0u/8M25vr/m4JCFtcKbEyDPsiqbl8dGGvRM6ijhJqrAfAn45yEHF8HJ0hBHe7VJfOw/a6FGaBTe/TGObuLQtaP62ICd9vgP7wUtAo/G8DNflhd4NJYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764642509; c=relaxed/simple;
	bh=fSE083AuicyftJQKZLE7jXiaWhrf5jW0t9xQwan2HMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMfVb0Yy78x7fJJFuBWUIvIjUNPziugVD3xFkWQsxAo+7IRa+qFr/OB4lQr/sfHTCJyzILWXX0F9duqKC2QuU5yo0mvtzkwVB9owiynClEeI1ZZhmCEp7/aOaL18wkdk7l9gQob7HRUuKkNC+TI/VhW+8cdDM8E3RChtQE8X7BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F7Mt0YRa; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F7Mt0YRa"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b75c7cb722aso717765366b.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 18:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764642505; x=1765247305; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1nWhPWmuUWPcNz6n4p1oyrxoe1jA0QGnW1Yt9yXj36A=;
        b=F7Mt0YRaG48Lmt43o+RAYChBzvYT/eWtZPzAF0yalFytKjjvb1UmbyxXwhcs4Exdwn
         0qxDxKe6VQ6FGHZbNq4kWr8Is0TvQCqRMBjU6+HbFRgkYc1JWzZUpSY+MPgjWetK99Ox
         puMpdHx67cB/RuQqRunaXFTIa/33mEFYrGEgFZGQRZveqkXdWHNcJ4hsiZpO9gDmk/gA
         IqT4/4hmZu0ioW16CiBtboZHpLScbHirDct79GaDFCx7F/7YpQRpT2mIurZ1ozezEw4+
         xZQS98xIG7PtL0r+IRwZOEl/JXld3fu3+3ocWV7qS4SsN0f4l8Usd4Txyr1L5OJu/bL8
         O2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764642505; x=1765247305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1nWhPWmuUWPcNz6n4p1oyrxoe1jA0QGnW1Yt9yXj36A=;
        b=E1EYG24Sq1W2PfORb5QxTXV7smXOrEv+bLeKO3mC2KcYniG2qqVyBWlEIMEIxEdN8U
         XId0swOIlCUIHc0vpvk0uxDAGPWDTb5kaW6qOY9jPfzxAyMrL9cKBeCTX5sGjDfhxp1I
         NXnzB5T9XcE10l8Rs4pBDxsi6J5amjzQ4rwKXTSjR5IWfQfQdUShowNBWHKqVMBinP0g
         FFjRx0cw9jkmhLT5FEqUj8FZerOvDA4RtYRY2DfZlNmGZ0VxhdAjgP5BbN/Z3jTKSoy8
         zpa/rDAdutttxf/Ct6Mn8qKdC17f1pl7xx1Kc4Pk8DpeOc/jDICOWke9TucZ3c7P0Run
         AUWw==
X-Gm-Message-State: AOJu0YwlEhCCZti6VzuxWvuGZWSnRPOPrTvowGMmof8zSBsEd4obEbxK
	qFnGUbgNRYkoo6yOeDJqP0MEkjJ2dtSeoAsGG9qFEhl74SuLLtIBXck2
X-Gm-Gg: ASbGncv6UaCtcHv6ZCb0wvF9SJcZtGV6lJllU/VuzSS/PnJgz5yhHsl27KKGoBR2ezk
	RM/Rd9OVLnTPObEyY8xxL8RFEaFC22HEdaiZz0PjcRcO90tkKRHwFsriLedk5lEwKrcjaRcW4HX
	3E2bR9YfqVno1kNpnGfrbIwa0IB3XeYHlPu78IMqoW0ddCLuD9EpwRmQy9kkDQs+SntAPraAevU
	hq48U4qY0GZW5FSAknQ6KlAXXwpqC6n3lvdTrr45bdIJ4AVaaf4OfKv0xpn2Z5+YZEXN2hWYDzC
	mky+uKpjdKiRQipVbxBo5xIdpnCzOUDvk8EpAL6F0ctnyijyvqgJc71EZq/3/bs93cydx82axMp
	peMZOA5LeelGLhRh/OfryBOhjCgDDDS3nBEKDhqp7zSLoL3C+fh0kYHfhI84QYE5xCwaL4/2Wku
	4hhK/ujzo7/DY=
X-Google-Smtp-Source: AGHT+IGm3NbA4GaGWOqLIeWZsMEh9q/DGd5oWcaZUlNtcad9GF/JDBDWi4QKx39KjJUF5Ok0XPJ9JQ==
X-Received: by 2002:a17:906:fd83:b0:b73:3f7d:3ce with SMTP id a640c23a62f3a-b767184c12cmr4550333466b.46.1764642504933;
        Mon, 01 Dec 2025 18:28:24 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:8eee:b306:2d20:a328])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f59a6a5csm1398317766b.41.2025.12.01.18.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:28:24 -0800 (PST)
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
Subject: [PATCH v2 1/2] ocfs2: Add ocfs2_emergency_state helper and apply to setattr
Date: Tue,  2 Dec 2025 05:28:00 +0300
Message-ID: <db74739c734a3719d873f71b0b0d6457d7ff6ebc.1764640432.git.eraykrdg1@gmail.com>
In-Reply-To: <cover.1764640432.git.eraykrdg1@gmail.com>
References: <cover.1764640432.git.eraykrdg1@gmail.com>
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
index 6aaa94c554c1..b018c535226e 100644
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
+	return ret
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

