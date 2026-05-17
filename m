Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3613F361662
	for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779016240; cv=none; b=u09cOc64o6+IkApL7gmnxtEl+iOpFumhCBbV6YP+MqYL11WalvO3RXuocj0YXdQ9Z83K4799ieb6/CJHOkqQTbL8zwD+iJngpIQ7j28MeQmHKrOVgY95NPpAajhn87JcOrBwROUR2lW6WIQ2tvoux83fjmaUs81OIZTJeckPnlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779016240; c=relaxed/simple;
	bh=+BSdzo13XZQuvp/wIYzH8e9IUezizz0p0fekzWmT8+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj4ksko2Ga5PfhmVtDMgx2x2hUT+knTVDBN5KZTVElYYUmnjtSnyEk/iI/e+3wwDkPj+a9CT4vg6E1nP5+5SbKZazbkXN9a+kSvGUJAKpcbTJ6+KVwUPdBhrWf2yZ39sqo4KLRidj6Qqooh+OWOmiy68/v7lvIUs02ONwmvFjlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OyT7KhO2; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OyT7KhO2"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-514ae601df2so5838201cf.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 04:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779016236; x=1779621036; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lADOBMRjpA9lHPB2reV9gREFqcmYd+mh1OlNIA4DhzU=;
        b=OyT7KhO2XlB1XdvZTfrCK4M3aLfLcg6OnnAWVG3+R4C57vJhKLl+P8s2lgAbrP/DWn
         ocMBED4Y6QE+Mv/3T2exJFdMtMMk8SgV6lkh+haq5uADO4ll5E2DVQT+4429lo91sydU
         uqfzY+OAleEDavCdvFRUPXqDIx3mcYJhEUHx6uSp/G0qdn8eLFiD+XCcBbHmhsI+tlzZ
         CzISi7Hc6N1fMEuivi9XQx011mzFbnThgO0EYZ15qI0Tr2QefgsOkyv20V8UAUd0F5je
         MhBacLSuhR7fIFCPeel2w/NNJAZOObVylE423v0SwDRS1r0BiBcwBflTKCezwZL8sbCD
         RITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779016236; x=1779621036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lADOBMRjpA9lHPB2reV9gREFqcmYd+mh1OlNIA4DhzU=;
        b=pyFHmRBipOYzOY6mfYPBGCzcnSc2oMH4pZVBwToWxxaxv/HQBVAoAfncokyg7uNyte
         fGk6LObp8tp/D3AfMirwLtgnekVd3+bGkpDVeCFu91vZjvSiM+acan64liaoIMLhq32c
         OY+MaHU/SrE7u1AAP3I3gbK45AdjDc7qGhJo+d7hkzUk8/i5a7FiTD/LoptXOaiS5a9h
         J+tDojy9FwA1Szuhf2iCahcDuQfh4WIPUK/POJSl+xfMmKwfYJUeAkjUtMlfUFVegRyy
         l7Ubjjur8TSUbxYCQjwjnOLSRw4B2PlmV9e3ezX5Fjjkvs3ywpJeU5OwLflH1I0mR76K
         1kwQ==
X-Forwarded-Encrypted: i=1; AFNElJ+NpBlEeAvEv6O6SysTu+pod36hra2/qC+SqMRCIczUS/ZdPu+7jvPl+mZpSfba6H7yn0uf19Ol+SPvHg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwvYNsKGr6KeqJCTddLDY18hoPfOXIKRm2LfReEgfSKL+lrs2lp
	CNI0XeR7vp+wO+YH/SVrEeZlMsKaRlRVT3T225wUvXZ1hi672dbJPisD
X-Gm-Gg: Acq92OFPZFSOJZGPtY1hdMTBI+kyi/OB6Dii0WfgP9WvvnrrLHYVVFPfaLTeJ+4gaav
	04lXBxuSTwXmVub0uxmfRBJuOrc23khwhNbooAI7PmgVpc7uNlQUWNGHbokfk1pfLIe3gYXLq5C
	8XdVMYTRW8NP2UEjn9jDSKjGs5XD646kmBnfISld7tWYfVvgSwfKRflM2U4TFGaSUlOfHwQUcNc
	lXTj6nuQyGFCl6EMXYbyXlpWNbrEs+JPpwm6wBpAZp68MMsuUUfoAud8GgFMxr+6hhWvs9zFaf4
	Sw5KTRFQ8/gaPuQukvTyZ+GALow3FVGeqNLNGQF1J6sclycPTXemFCaVEC2yslwKCOzJhZ7TiFx
	11pMIXh+Q2aJNMQGL+81MBNKy+YhyX7Mf0E1N2XcRJ/b6INFj3tMXmGq/gByIFmnmGVFfIm9I/l
	fW4kNn8RKwTS3bMUlHx3o0h6DwUV+XWrLQNYfewOjusDvgAZU7t/sg+D2NajqEsSLqZ01nhjw97
	Lb4J2S+JV1cWgni26R34y2WcODV6cumMP0fyrK4lgI7Z98P+ZF1FA==
X-Received: by 2002:ac8:57ca:0:b0:50d:89bc:f450 with SMTP id d75a77b69052e-5165a001072mr179709841cf.11.1779016236025;
        Sun, 17 May 2026 04:10:36 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456df09csm100306651cf.13.2026.05.17.04.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 04:10:35 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ZhengYuan Huang <gality369@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ocfs2: reject regular files with non-zero i_size and zero i_clusters
Date: Sun, 17 May 2026 07:10:14 -0400
Message-ID: <20260517111015.3187935-4-michael.bommarito@gmail.com>
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

On a volume mounted WITHOUT OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC, a
regular file with non-zero i_size, zero i_clusters, and no
OCFS2_INLINE_DATA_FL flag is structurally malformed: the extent
map declares no allocated clusters yet the size header claims
the file has content.  ocfs2_populate_inode() copies i_size into
the in-core inode and dispatches to ocfs2_aops; subsequent reads
or truncates then operate on an inconsistent extent state.

This is the shape an attacker who keeps the rest of the extent
list intact (to satisfy the inline-data, refcount, chain-list,
and per-field validators already in this function) would produce
when forging only the inode header to publish a synthetic file
size on a victim node.  It is also the shape on-disk corruption
of the i_clusters field produces.  Reject early in the
validator.

The check is restricted to non-sparse volumes
(ocfs2_sparse_alloc() returns false).  On non-sparse mounts the
allocator path always grows clusters before i_size:
ocfs2_extend_file() takes the !sparse branch into
ocfs2_extend_no_holes(), which calls ocfs2_extend_allocation()
to journal new clusters first, and only then
ocfs2_simple_size_update() journals the larger i_size.  The
truncate path likewise lowers i_size in ocfs2_orphan_for_truncate()
and then frees clusters in ocfs2_commit_truncate(), which uses
ocfs2_clusters_for_bytes(new_i_size) as its new_highest_cpos:
when new_i_size > 0 the floor is at least one cluster, so the
on-disk dinode never legitimately exposes a non-inline regular
file with i_size > 0 and i_clusters == 0 on a non-sparse volume.

On sparse-alloc volumes the same shape is legitimate: an
ocfs2_extend_file() call goes through ocfs2_zero_extend() +
ocfs2_simple_size_update(), which grows i_size on its own
without changing i_clusters; a freshly truncate -s 1M of a
sparse regular file is therefore on-disk
(i_size = 1048576, i_clusters = 0).  The check therefore opts
out via ocfs2_sparse_alloc(OCFS2_SB(sb)).

System inodes (OCFS2_SYSTEM_FL) carry their own size and
cluster invariants validated by the allocator, journal, quota,
and truncate-log subsystems; skip them here.  The inline-data
fast path is filtered separately by its own dedicated branch
below: its well-formed case is exactly i_clusters == 0 with
i_size <= id_count.  Symlinks legitimately keep i_clusters ==
0 with non-zero i_size (fast symlinks), so this check is
restricted to S_IFREG.

Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/ocfs2/inode.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 305e22cc9b1d9..c63d2ced6b338 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1571,6 +1571,47 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	/*
+	 * On a non-sparse volume, a regular file with non-zero i_size
+	 * and zero i_clusters that is not marked as inline data is
+	 * structurally malformed: the extent map declares no allocated
+	 * clusters yet the size header claims the file has content.
+	 * ocfs2_populate_inode() would still publish i_size to VFS and
+	 * leave the extent state inconsistent for any later read or
+	 * truncate.  This is the shape an attacker who keeps the rest
+	 * of the extent list intact (to satisfy the inline-data,
+	 * refcount, chain-list, and per-field validators above) would
+	 * produce when forging only the inode header to publish a
+	 * synthetic file size on a victim node.  It is also the shape
+	 * on-disk corruption of the i_clusters field produces.
+	 *
+	 * The check opts out on sparse-alloc volumes, where the
+	 * extend path (ocfs2_extend_file -> ocfs2_zero_extend ->
+	 * ocfs2_simple_size_update) legitimately grows i_size without
+	 * allocating clusters.  On non-sparse volumes the equivalent
+	 * path (ocfs2_extend_no_holes) journals clusters first and
+	 * i_size second, and truncate-down floors i_clusters at
+	 * ocfs2_clusters_for_bytes(new_i_size) which is >= 1 whenever
+	 * new_i_size > 0, so the rejected shape never appears on disk.
+	 *
+	 * Skip system inodes (OCFS2_SYSTEM_FL) and the inline-data
+	 * fast path (handled below).  Symlinks legitimately keep
+	 * i_clusters == 0 with non-zero i_size (fast symlinks), so
+	 * restrict to S_IFREG.
+	 */
+	if (!ocfs2_sparse_alloc(OCFS2_SB(sb)) &&
+	    S_ISREG(le16_to_cpu(di->i_mode)) &&
+	    !(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL) &&
+	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
+	    le64_to_cpu(di->i_size) != 0 &&
+	    le32_to_cpu(di->i_clusters) == 0) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
+				 (unsigned long long)bh->b_blocknr,
+				 (unsigned long long)le64_to_cpu(di->i_size));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
-- 
2.53.0

