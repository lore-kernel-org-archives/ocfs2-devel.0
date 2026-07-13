Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3124535E1AE
	for <ocfs2-devel@lists.linux.dev>; Mon, 13 Jul 2026 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783976193; cv=none; b=VcHE3ErG7lBMz0XMnMM/+MYTZQMf9ZZzQPwoej6/1mPALii2ip/j1ykWAX6NOQ5AoO2SNC0qFMt5fqY5VJKpAHrhhxtClR19PwQlFSmuNnrjIiHT6d8VuunNZHhzKge7a0xzMpJTpkqqTVaHRphoZhq3kVQts4oYHBRrA9q1HGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783976193; c=relaxed/simple;
	bh=bMq0yg6e87SIljIP3KX8iDIAp9Uo8hI0a45j+UnWgKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ijMuiR6V71zKPweuieyiiqbi3WYvzH675DmpSwfYmyHtxM9z6qrbT9XdTkDgu4YQWcJZgeJBsmsB0rA2obDifwMcRja1Ez1ZguRLQTHhIcl6VUTq7a8P8Rumk77rQzkaupGkH7gQzHRemhXS3wvdpRV6Zdlwh9GCTchO853wg7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=yZuG/Cx3; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="yZuG/Cx3"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493f140ca8eso22344765e9.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 13 Jul 2026 13:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1783976188; x=1784580988; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u+xKnuTI1B6k0A1NfDaxq70Pipp+wChxPKxkTyBDJp8=;
        b=yZuG/Cx3/CO6tTwZeVQO2Um6fzB7NVY9evMHaeUadU0pKspxfxaCJgl1Gf04p63jc6
         tvaJfQVRnetyPcoyhjyNT60uFffmLKovv5k5iQRkmPXkHPSTg8sFb9XlQ6N6ZPqdd4Lm
         OQi76FybPisov8sj7o8SFLy5TEGwTOuHi5YfJglAeNxrDKOBIysfSg07x72PYm214yHF
         4pvbQUDBI7V5jjvhgbf89N4SU3qiRbLqcIfgzayAAgOeioLQoSpF6+9nBf9QAic+T3Ty
         KSB5Ud2FGuI5PAlGqZHTXTy+4lUc9EVLesOnnwqB5txN6Hj66v6jklYobHQdZL6b5fDz
         zBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783976188; x=1784580988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u+xKnuTI1B6k0A1NfDaxq70Pipp+wChxPKxkTyBDJp8=;
        b=gq2EFmniOm6NAaUOKiZVkJPDu7TD2qpTXfDFDcfXjgInCczQzNGqNk1gI21Wzr8SzZ
         VBK/MZO8EkqDfD9S9tmdrGVamh+m9wyzwobpCkwJyTGljUYN28nGOSAxPouIQo8FZvHD
         S1P1okzddGT84K+A5wChNnK6Tie1sSYtwY53ljXo8UP6GBvxGu3o9kV5VFjuygj01PVU
         f1X2s9WiY5jKszMWoAi7o0SkA/u+cvUHpSJDWPdZpL6kA+2Yd6apt3wc25ZzOUDFwfX7
         qmo3DYHx5HwPe9RetVEZH0MImIiL103B4AM/bRkRwCan/lWyVdY6789vSXK1uWe1Fyw7
         Rc8Q==
X-Gm-Message-State: AOJu0YyeWlgySVvUFzUa0w4ciiBoj+JLykywEicKdYqTmDMaGc95Ah2i
	Og9TNGM8llzzNLzFDOhTgqeRy2ATR/bXI8YRlH3Cd5Xaw6Zd/p50fYnPUaZjG6ohH7gA
X-Gm-Gg: AfdE7cnYFA5DA9/ir5Jft5YEyF3qfipM6z1RE98PBgtBAbS5n9TpZsH/qV+zC5JsR/X
	eWYl4qM/a7I9ENftReU997VuR/d/OAtsIPXPMH/WZF31K3GNOG1fiDTHErLqqcSwcMzuYV309sa
	BcxDlQLdq3RJslh5yIpDkii6cC0cm+nSgGdCHuA6rfdcIdzlneyAkUJIrUsDPrTWHbv8KgZCoU9
	SaPzEXEZ3QrJhvveoVNb48hXczrmpWyHLivoLunFMfo7ROeGirOKo0vTyWSBY325IVeC/wBrYEz
	P+U1aHB6fy/b3eLOROIZ0u2IWW+6HjWvGPCjpp5bxLSynyxY/6kvY6v+DJDXT9hf9yzyE86jJpU
	8r5c8PKWlroHXr1F7qfDKtIAWWAYsojgg3KVUELt4OanUhJTntnD+JkAzrDbuBw41JEwJwF+br4
	2FvaJoLLqJt0TL5zzm8An2tWGVazAlDCsRd1nO/sL7lImTHUd+6GoaseXZf9OSbb7FogfnqHQRr
	lH4dHhFaBybLK9mFzxihNyu6e48uq/iHvA=
X-Received: by 2002:a05:600c:4e41:b0:492:4a50:41fe with SMTP id 5b1f17b1804b1-493f881f9d6mr106303585e9.22.1783976187973;
        Mon, 13 Jul 2026 13:56:27 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.188])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950871d1bdsm21661155e9.1.2026.07.13.13.56.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Jul 2026 13:56:27 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: validate directory-index entry counts when reading metadata
Date: Mon, 13 Jul 2026 22:56:25 +0200
Message-ID: <20260713205625.92391-1-doruk@0sec.ai>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_dx_leaf() and ocfs2_validate_dx_root() check the ECC and
signature of an indexed-directory block before it reaches higher-level
callers, but neither validator bounds the ocfs2_dx_entry_list counts
against the capacity of the block that holds them.

ocfs2_dx_dir_search() then walks

	for (i = 0; i < le16_to_cpu(entry_list->de_num_used); i++)
		dx_entry = &entry_list->de_entries[i];

over de_num_used entries with no bounds check.  entry_list is either
dx_leaf->dl_list (from ocfs2_read_dx_leaf) or, for an inline root,
dx_root->dr_entries.  A crafted on-disk image can set de_num_used (and
de_count, which is the __counted_by_le() bound of de_entries) to 0xffff
and make the walk read far past the end of the 4KB metadata block, giving
a slab out-of-bounds read reachable from any path lookup, stat() or open()
on an indexed directory once the image is mounted.

Commit 775c17386a6f ("ocfs2: validate dx_root extent list fields during
block read") already bounds dr_list for the non-inline dx_root, but left
the inline dr_entries path and the dx_leaf dl_list unchecked.  Add the
same read-time validation for both entry lists: de_count must equal the
capacity of the block (ocfs2_dx_entries_per_leaf()/per_root()) and
de_num_used must not exceed de_count, rejecting corrupted metadata with
-EFSCORRUPTED before ocfs2_dx_dir_search() can walk an out-of-range entry
array.

de_count is always written as exactly the block capacity when a leaf or
inline root is formatted, so the equality check does not reject any
valid image.

Fixes: 9b7895efac90 ("ocfs2: Add a name indexed b-tree to directory inodes")
Fixes: 4ed8a6bb083b ("ocfs2: Store dir index records inline")
Cc: stable@vger.kernel.org
Found by 0sec automated security-research tooling (https://0sec.ai).
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
---
 fs/ocfs2/dir.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index baf3eca7b4e4..fcc3721cbe34 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -624,6 +624,28 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 					  le16_to_cpu(el->l_count));
 			goto bail;
 		}
+	} else {
+		struct ocfs2_dx_entry_list *dl_list = &dx_root->dr_entries;
+
+		if (le16_to_cpu(dl_list->de_count) !=
+		    ocfs2_dx_entries_per_root(sb)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid de_count %u (expected %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(dl_list->de_count),
+					  ocfs2_dx_entries_per_root(sb));
+			goto bail;
+		}
+
+		if (le16_to_cpu(dl_list->de_num_used) >
+		    le16_to_cpu(dl_list->de_count)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid de_num_used %u (de_count %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(dl_list->de_num_used),
+					  le16_to_cpu(dl_list->de_count));
+			goto bail;
+		}
 	}
 
 bail:
@@ -663,10 +685,25 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
 		return ret;
 	}
 
-	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
-		ret = ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
-				  7, dx_leaf->dl_signature);
-	}
+	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf))
+		return ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
+				   7, dx_leaf->dl_signature);
+
+	if (le16_to_cpu(dx_leaf->dl_list.de_count) !=
+	    ocfs2_dx_entries_per_leaf(sb))
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has invalid de_count %u (expected %u)\n",
+				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno),
+				   le16_to_cpu(dx_leaf->dl_list.de_count),
+				   ocfs2_dx_entries_per_leaf(sb));
+
+	if (le16_to_cpu(dx_leaf->dl_list.de_num_used) >
+	    le16_to_cpu(dx_leaf->dl_list.de_count))
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has invalid de_num_used %u (de_count %u)\n",
+				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno),
+				   le16_to_cpu(dx_leaf->dl_list.de_num_used),
+				   le16_to_cpu(dx_leaf->dl_list.de_count));
 
 	return ret;
 }
-- 
2.43.0

