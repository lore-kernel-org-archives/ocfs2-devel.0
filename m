Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C06232470E
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 02:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789526882; cv=none; b=lOr2q+7eOLom2ccxY1tfP/8htY7EAdFJ9dWAOV8wKkQMyb9C49K55jdEcu1nYVsw9ngAJMzSc2Y/KsTAyj4YuwFISBkNea3JiFFubs0XwSASP3Sv3d1+Kkms1mtjRYrBVGK+UgGeGqorWAzYZ83/3yAWLqV1bO/drRNrYqdXLhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789526882; c=relaxed/simple;
	bh=GjcB06nBmtpwflUV9qPhMmIq1NhsakSUFvyN3W5mIX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f3elJv2ZAVW1SBpl+pnf/8nmHVQspy15AFi2Gb2o7JBv53XusYYwxnIu4SVTFheITNyyKrYWUv4bD79Ulxz0CiD4QWNObc+F5scfduE0+jyv7tBYhkRw1CzR8m2xgE8r48HOifSjcJVVno7NTj59vdUOILVk9xJ72LZEjcfz8BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YrGSgdlh; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YrGSgdlh"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912df756so2906815e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 19:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789526879; x=1790131679; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hONIRSTCDTtc4FkplgeXuq38/iUH3dSfh9L1Vqs25vE=;
        b=YrGSgdlhtlEdl22rTS2+XqUCYOW3iztPSlgU31xYqlm+558LmJF0pB2+ET9e77MiFt
         AocyGmA1FqTw8V0LfCdixYfWylBoqSw+7vPSyxKuc0/bzQxG54/7vPvKVRbjddxiZ/VO
         w76NOOuTFi1HeXgQZbEcwFtkbOSrEBsL5wS4wNqloguz9NfqtbVGPMk26u0qCecZ6q2t
         olTywWehJFEefF6OHcL6rFXtgU0yh5MjCLMRdYprN83MeQPQNJ55dOV3LF8jl1HMyLO+
         ILeZnsz+zeKzNtPnvkH7kLnU4dKX5Z3Z+RCYzMZ3zAxqAzBP0tEEqxX0OC6+wiF0xrOy
         YCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789526879; x=1790131679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hONIRSTCDTtc4FkplgeXuq38/iUH3dSfh9L1Vqs25vE=;
        b=X/n1ksjmo01qGwuS8Za+lWckY1vGEgjwEVtPT1T2PhC5Dp0x+3ujzJ3OophEXr9Mq0
         F773NVCkkQnPRLplLzWzwpC1iaFGKMsuWgb4Hr6qNsEtJEXPsgKqD9gbIAxk3Gnu/+i2
         3zV4oLxge0ApqtnZnGOvBnlPVkKpnm2jkrBpMW2V2DFAgSTvWNqZqL4JnNBic2y8peJd
         dW3LrCPqqdE3QgfGpNuTnLgRelCUabHue1LLaDEWSL3tb8rvSP1V3P3IX2iS5eZyms17
         vr0WrZNE0csz0kiHN3vzrAnGr78Oc/0xSs745fIutRlt0GgNq+zp/pmHkR4DkYoj2Lau
         xrZg==
X-Gm-Message-State: AFuF++kTsSI2RDObqVxHw6e+q1A6ZTdSoGadDZvYAOz4P4TDLKTD2Hty
	UTuxwE5YM5tIikrdOf71uQeL4e35LHlReNHTbysF3AYWWmfWWabIkDihLdvwgEN5QNENlbrz7KV
	HaL3zDABelA==
X-Gm-Gg: AYBFou26TQY0E6PmRcObp04WWxXwGjBNWp5QCMER2aS/m2KrVKbZi0VwSgamxmqFwgq
	Jwh8Xmeh9gjMdud9vpT4JxKPcpqTzDfzH4AEpnrvJ7bJLrVDHDKmmLsy9ONanL+7aC19+9smA5x
	EkIj3h3Zb0OrNQvex0HLojwPoMIhAlMFeO05lCtgJOLqa5+XcEZ+fkxvKM0E5HAS+CWN/GsZgcM
	LarbHuVsCeaNCEfPIBrXoTgaX4QxO4lr5IxfotwOkBWst958D9Yarcsro09bafCQlPT5njh68a6
	3+YH3biADqG+MZfNeWJn8GkgalsZwFTK1FB2sh4jZyoHtx/FSXUWj27rRmVaLp1kg2lCnYIALg/
	N6RKJEY9yP7YBKatRlXGlKDK7I8y+3Td2SiGAWKj0ZonVPhAGFP7dogDKzeKdZ9i8lasHIDfJw6
	NjP5MzVKgwcSR1SFr7e+5vET8v8i2CSNWlmTrfDrq+u/cdt3N3GkKdxiJOUgn8Q6CqXOz35HmNb
	ruAypU+
X-Received: by 2002:a05:600c:4505:b0:49c:fc6e:8cae with SMTP id 5b1f17b1804b1-49eb73475efmr6195865e9.18.1789526879347;
        Tue, 15 Sep 2026 19:47:59 -0700 (PDT)
Received: from localhost.localdomain ([2605:52c0:2:27d1:8ca3:89ff:fe18:2252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5a9fd38sm3254191eec.13.2026.09.15.19.47.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 15 Sep 2026 19:47:58 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2] ocfs2: update xattr count before moving bucket entries
Date: Wed, 16 Sep 2026 10:47:50 +0800
Message-ID: <20260916024750.9450-1-glass.su@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 2f26f58df041 ("ocfs2: annotate flexible array members
with __counted_by_le()"), the xh_entries array is annotated with
__counted_by_le(xh_count), so FORTIFY uses xh_count to determine its
bounds. When inserting an entry into a bucket, ocfs2_xa_bucket_add_entry()
shifts existing entries before incrementing xh_count.
The destination therefore extends one entry past the bounds described
by the old count.

With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
ocfs2-test: single_run-WIP.sh -t reflink triggers the following failure
while adding an extended attribute:

[  150.156484] memmove: detected buffer overflow: 352 byte write of buffer size 336
[  150.156487] WARNING: lib/string_helpers.c:1036 at __fortify_report+0x3d/0x50, CPU#15: reflink_test/2336
[  150.160496] RIP: 0010:__fortify_report+0x40/0x50
[  150.164031] Call Trace:
[  150.164141]  <TASK>
[  150.164232]  __fortify_panic+0x9/0xb
[  150.164383]  ocfs2_xa_bucket_add_entry.cold+0x17/0x28 [ocfs2]
[  150.164661]  ocfs2_xa_set+0x8fb/0xf40 [ocfs2]

Increment xh_count before memmove() so the destination bounds include
the new entry. Keep the local count unchanged to calculate the insertion
position and move length from the original number of entries. The caller
has already checked that there is enough space for the new entry.

Signed-off-by: Su Yue <glass.su@suse.com>
---
Changelog:
v2:
   Remove fixes tag, mention the commit id in message.
---
 fs/ocfs2/xattr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 35bcbb0ff607b..49d82ea5a1271 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2076,12 +2076,17 @@ static void ocfs2_xa_bucket_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
 		}
 	}
 
+	/*
+	 * Increment xh_count before memmove() so __counted_by_le(xh_count)
+	 * includes the new entry in the destination bounds.
+	 */
+	le16_add_cpu(&xh->xh_count, 1);
+
 	if (low != count)
 		memmove(&xh->xh_entries[low + 1],
 			&xh->xh_entries[low],
 			((count - low) * sizeof(struct ocfs2_xattr_entry)));
 
-	le16_add_cpu(&xh->xh_count, 1);
 	loc->xl_entry = &xh->xh_entries[low];
 	memset(loc->xl_entry, 0, sizeof(struct ocfs2_xattr_entry));
 }
-- 
2.55.0

