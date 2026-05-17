Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E088235E951
	for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 11:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779016237; cv=none; b=ejxqmAWG/1XC14GxIz+yAgfZa5JHGkr6IgL60Og7k7eVKu5UplYYpJIxbNbRoJ83RM0A9JbryyFeM81LVV/xmoLQwV+HXOJPFxQZBNNsE8A5/SnG/qqJrLKIq73XjtIh596CwQCFQAXX/t+VllL7YNhQz3cqvm42Ah+aQPyrFxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779016237; c=relaxed/simple;
	bh=n+C1rVyGdlKurjuMZfviPdnXsf7j/DTvcv2LKJqNXf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDnQvZAJ00CX/bxgJLM77oz4V+6UpnhjkhxVRJ80z2qu4BuNfl5xny/tnH9LXltnaLrwnhfYku57iWEcMXWayLwpBD9a7kSJxWeNOVv7agww/qVrAmfjlttAYzOJoqzGheBaFuVWwL2qJ960Szm8fEkm0a5tjWzJUl55DhM67YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sSlE5dVW; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sSlE5dVW"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-514ae601e01so16257681cf.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 04:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779016235; x=1779621035; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N7Mwcd+TqqhYeRK2C3/0bLC/BLmg36DmKBF7VQkSkpQ=;
        b=sSlE5dVWEbM8GoNnWNuF4Am8hhiuZQ8Cbt62q6PRTYJpEGBN2NVFYVguKfMq28IVqZ
         isCNpSY9j9F3rHuilZD59VnpXiegw8i3BodYS1UlEsaQ4mJs5ODilkRg7QztmF+o5N/W
         ixKy065BcEtebhGqkUrvzTxNZEKiJ1nIlOWP+DGHfHfE+w4bUtA/2dovkeuQqI1EurOk
         173WBkEgMfHYEBkkjWoHWDqIFFMR06cXP3kIHY0WEjKDlTHV28KmiF+hMBmmBD3uFFpy
         m8rz8lDpUTEV5Sg1+eyV2YvZVNMlUZ9lrYTKfPqNFZOUJ6ukrB1dps2uGO0fQrRW2Ukn
         zCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779016235; x=1779621035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N7Mwcd+TqqhYeRK2C3/0bLC/BLmg36DmKBF7VQkSkpQ=;
        b=bo0UczGZvzsVa7Ywz4bB3u6vA3BWzzBUNm/oyiX2unQ1Y/P0DFGRg0KkAh+Tj1TD8n
         sEUfO9UjlqbIMmm0trvdk435bKFg/YgXoFp1jvLTkhxAjyrFIqN4kCu0S/AMwkEwhlWD
         v1tv24NZTX4JHevlge4Q+uwe/UOHUD4iYCtoz9axObXnGvvKhztaxautpQVvuauN+6ch
         44+8sfixVTN42YDf83GQV3W828yhN0CJMjctfrUMVy4RGyjAspQfVVnQpbeiVjcPDglT
         g72U0967kypBq0AiqqX61hrC6gxCyt3Kiaykyv/MMkKWask2C/fI09n4rMgoTvKRuAsk
         1blA==
X-Forwarded-Encrypted: i=1; AFNElJ+LY3dQ5z2POa8DpGjBPESqOCsJQaaplegNSE6sA6+rDGN2McsT7QQusMey7dFnIUmbuBnNF1zknIG86A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxubLSs9Watf2nX4FLBU7ec6J+//qZWOwdz9CAmcskpbakfDZv1
	W9aHZUNLMBPik5awxtaPjXLv4G4nzoDyehafqkedDEhy3BdX5trgwZP6
X-Gm-Gg: Acq92OE5s9MCZtyH/jgRFm8EDsSU9UFFW0v9BydIheAUbhccFStRnYC+/ph6czwXdRL
	o+VK3+tPNPtOMqNC4KAVgfT0437z1Ie0KI6oxYRtoq0VpGSvTax7qrrpEtToct+HIIVZNFmDWKX
	+5FZJUrG/iQlE5x7mi/T0tGA5YsVwdNkzYwogE93yeZvivoV+xxrbC86MUMH8UHM+5746s0nkrO
	5d6U9luAWI2g0UAPlZz7JZTAITyyD7zVG3LXCg99WEgeVWQMVaqnSqcKGxdRkI7q287YWUNute6
	bD8AK5gvF8YYj+ZXEONMLWflw8lJWh3AwWBMi6o/31lLZhPbdoK66eKom7q6AJY+bMPiI+ctyhe
	YFBooP1J2A0VyO8rFgwQp4v0vz0rmOnH6/lnwBX3uicVg0M9wh6GfJ1krPidSl7J/7nnsPHV/yk
	ErlJkv62KNf7mMcrlgWy1oM3tE5GooGl0VmzDel732jgw5623iCAGKnZ7YIqD6OBCucTZdP/vqB
	ACx2Nse8xZE5GcgBIIZwvq+lMySTDm+FWglnxXY+h8=
X-Received: by 2002:a05:622a:6201:b0:50f:ade2:2d3 with SMTP id d75a77b69052e-5165a1ec441mr152988931cf.42.1779016234888;
        Sun, 17 May 2026 04:10:34 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456df09csm100306651cf.13.2026.05.17.04.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 04:10:34 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ZhengYuan Huang <gality369@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ocfs2: reject dinodes whose i_rdev disagrees with the file type
Date: Sun, 17 May 2026 07:10:13 -0400
Message-ID: <20260517111015.3187935-3-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517111015.3187935-1-michael.bommarito@gmail.com>
References: <20260517111015.3187935-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

id1.dev1.i_rdev is the device-number arm of the ocfs2_dinode id1
union and is only meaningful for character and block device
inodes.  For any other user-visible file type the on-disk value
must be zero.

ocfs2_populate_inode() currently runs

    inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));

unconditionally, before the S_IFMT switch decides whether the
inode is a special file.  As a result, an i_rdev value present on
a non-device inode is silently published into the in-core inode.
A subsequent forced re-read or in-core mode mutation (cluster
peer with raw write access to the shared LUN, on-disk corruption,
or a separately forged dinode) can then expose the attacker-
controlled device number to init_special_inode() without ever
showing an unusual i_mode at validation time.

System inodes (OCFS2_SYSTEM_FL) legitimately use the bitmap1 and
journal1 arms of the same union: allocator inodes encode i_used
/ i_total in the bitmap1 arm and the journal encodes ij_flags /
ij_recovery_generation in the journal1 arm.  Those byte
sequences are not an i_rdev and a non-zero pattern there is the
on-disk norm, not an integrity violation.  Restrict the cross-
check to non-system inodes; that is the full surface where
i_rdev semantics apply and is also the full surface an
unprivileged consumer of the volume can see.

Following the i_mode canonicalisation in patch 1, S_ISCHR /
S_ISBLK covers the whole device-inode space; this check operates
correctly on its own, but the canonicalised i_mode makes the
predicate exhaustive.

Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/ocfs2/inode.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fb592bf3e5f31..305e22cc9b1d9 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1533,6 +1533,44 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	/*
+	 * id1.dev1.i_rdev is the device-number arm of the id1 union and
+	 * is only meaningful for character and block device inodes.  For
+	 * any other regular user-visible file type the on-disk value
+	 * must be zero.  ocfs2_populate_inode() currently runs
+	 *
+	 *     inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
+	 *
+	 * unconditionally, before the S_IFMT switch decides whether the
+	 * inode is a special file.  As a result, an i_rdev value present
+	 * on a non-device inode is silently published into the in-core
+	 * inode; a subsequent forced re-read or in-core mode mutation
+	 * (cluster peer with raw write access to the shared LUN,
+	 * on-disk corruption, or a separately forged dinode) can then
+	 * expose the attacker-controlled device number to
+	 * init_special_inode() without ever showing an unusual i_mode
+	 * at validation time.
+	 *
+	 * System inodes (OCFS2_SYSTEM_FL) legitimately use the bitmap1
+	 * and journal1 arms of the same union (allocator i_used /
+	 * i_total counters and the journal ij_flags /
+	 * ij_recovery_generation pair); those bytes are not an i_rdev
+	 * and must not be checked here.  Restrict the cross-check to
+	 * non-system inodes, which is the full attacker-controllable
+	 * surface.
+	 */
+	if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL) &&
+	    !S_ISCHR(le16_to_cpu(di->i_mode)) &&
+	    !S_ISBLK(le16_to_cpu(di->i_mode)) &&
+	    di->id1.dev1.i_rdev != 0) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_mode),
+				 (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
-- 
2.53.0

