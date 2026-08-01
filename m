Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BA53CAA3F
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Aug 2026 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621694; cv=none; b=p0rYr/E3yI3aReG6QlxSgp4lAC7Lb0d0QjISIH7FMkygYrd4v6KI7IzL+mI9r+kksHhy0zuCCMVzTnO41+uEb2MMwBGUFWkIX7tIJ/gLnW96oPQH2geaK5PUmVMuzGHsglXIPAbT8L3TdrVfzwwJwT607XBHvQc/2yRFcoW3FWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621694; c=relaxed/simple;
	bh=3dsw1Zg8M5wNaCMh6F9jO6eXBuRivbQ5EiuJWZtmA2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyAKJ0RWkOftR0nJvOjnuJSEgQujBjJzISwFlfgeESJ34C+RyDi8RzbQ4zfUOs/BCSfFLxJ4mLnsQ7d1ZeGdVYfT3zvl6IgvWK/bqjGbjvgCQIl/qf2NiiJOrgjplqjZMuKBbwS2KCA1OZS4HFcvKf3FIjIKGKQ8DR7PzJfDbAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fhhrr+GY; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fhhrr+GY"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81f36179dd5so30876137b3.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Aug 2026 15:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621688; x=1786226488; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/DniCfidRbKUpj3g8JSrdbI5dITb8OPbOoquygm/08o=;
        b=Fhhrr+GYaRxWn80oErUqPuK+04RG0Dbron1uBJVHIrwO8+ERP1KFwCzUE/Fs/HXvLv
         7wHTiP+zK5hRvNjEXdr9w9M0tNqMDCziv3icyKogbQ92F1gMyQVuugkjkrKDXrZlkiea
         PdAFMFRQCyPXry2SmQ+wxJ6w56oQ7gyVPzTpZmlFatFGiEmPHu8Qs2iFwo5r14o0r7gP
         H0REElj+qzQ8aOPolwWzLNuzke7Dzzi1XGJONyiLtRbZWUn24PS9i+oms3pBqckNJEa7
         PYJ63z/GirResekFUZZ1BdVls7z+iiGKsCEsiaqwyMpRD4Z69GF7q2JW/kHn6Mxbdr95
         5AGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621688; x=1786226488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/DniCfidRbKUpj3g8JSrdbI5dITb8OPbOoquygm/08o=;
        b=HDQtVnwr2e+TZpf+nKa9HHkS0CVk8PeeLgpQwhnGLuz15XJTzM14AiwxPYI50K+EOu
         sWI5BT+Pe8nVGewLUqX4Q7hbGNswoQvojqqYPy8bCzlBbuRHEwx8xE3jjgBkAXsyRCyl
         yvumYEsohhKylU+MyiSUbVuMTvhV7u1wKXSoNBJ58sjC+ZeXwfYuL1JIfn13h/tOite7
         7aFpliM4gHQexglGflcl1PMLRgJzVKqX5yA9LtXOrkejMiZsaRurqTe9mMPHIAlLAXv7
         qTMBabcvcV6YZlntYEK0m+4VndEHkcu4INQNwxbf7qNbFSfHX732mbQJopZHAOu1hK2+
         TQrw==
X-Forwarded-Encrypted: i=1; AHgh+Rpq6eFpB3u3Bqn5AxWWfo9eIajdJjXrMPSpM01iWS8n6iaqmcRSCvSgvrS9jKS8CNWyKbK+POgprbuOpw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxlOKQCp8wyhfxBvJV+oZP9DAXFH7Mv1jaVkleE/KmZu+HFMQsA
	SiL0i7vp1nkAjAxgQNyKa3WUUnWLw8pGcp5X8OScK6oT4Oi7bnAH/kHZ
X-Gm-Gg: AR+sD10CKI4b0j6wuBRFYZID426dds1VFuABFdph5vJ3JtCN9ROLldIPVKA8J7OUwXD
	dpZvbcrCv/ECcETz1lg9yB/kiynT68YfIvh9htqgVAfs1qhWS2SCu+S0JWsbMXBFpap2u7hdYd7
	tw+8Zlj3lFXdyN0ankSlpKQAv8ZCTwmtzOzfBjwS+PF0RC3dgjiNmeVSuCZW55UZnZAfcdQ2veA
	/eI5UP7pRRa+BVvFN+azdkX9dUMKePQo/ELrmoz47tkHXYvEoyh2cnGnq7pbLJqFb/XsSTEzYWV
	KsdeyPKV20r22YMnjLbTGNlBWRA6ut306mdp+AS6B4rwOAThuSUIRILn4qTMhtW+HWRzlLzUEHY
	9E87wWEuAoDTomNKu8axKf6VXo8YRLzPscXmsyXoZCmJnhaITkXTINHKEAZptsiZKWZ0+BJpFlQ
	kQ/YcXYWdXzn485i7ZQ70wt+7ccJfQJHo/T//s6ghc1zle3VS3krpbf+NYMeIVBrkMXB16lYoWa
	AC8kdM=
X-Received: by 2002:a05:690c:c15:b0:809:6b62:2f7a with SMTP id 00721157ae682-81fd4b72864mr76660857b3.21.1785621688522;
        Sat, 01 Aug 2026 15:01:28 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:28 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 13/19] ocfs2: check for a metadata write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:57 -0400
Message-ID: <bd2c982e7c91fcfdb8a326ae8166853351398aa2.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_write_block() and ocfs2_write_super_or_backup() detect a failed write
by looking at BH_Uptodate afterwards.  That relies on the write completion
handler clearing BH_Uptodate on error, which this series removes: a buffer
whose write failed still holds the data the filesystem asked to be written,
so declaring it not up to date is wrong and makes callers re-read it.

Test BH_Write_EIO instead.  Note that ocfs2_write_block()'s test is the
positive one, so the sense has to be inverted rather than the flag simply
swapped.

The comment in ocfs2_write_block()'s error arm needs updating for the same
reason.  It said the clustered uptodate information did not have to be
removed because the buffer was not marked locally uptodate; after this
series it is, so the reason no longer holds.  Not advertising the block to
the cluster is still the right thing to do - the data is in memory but not
on disk - so only the justification changes, not the behaviour.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/ocfs2/buffer_head_io.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 7bfe377af2df..733ceda79ca1 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -66,12 +66,14 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 
 	wait_on_buffer(bh);
 
-	if (buffer_uptodate(bh)) {
+	if (!buffer_write_io_error(bh)) {
 		ocfs2_set_buffer_uptodate(ci, bh);
 	} else {
-		/* We don't need to remove the clustered uptodate
-		 * information for this bh as it's not marked locally
-		 * uptodate. */
+		/*
+		 * The buffer still holds what we tried to write, but it did
+		 * not reach the disk, so don't advertise it to the cluster
+		 * as up to date.
+		 */
 		ret = -EIO;
 		mlog_errno(ret);
 	}
@@ -446,7 +448,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 
 	wait_on_buffer(bh);
 
-	if (!buffer_uptodate(bh)) {
+	if (buffer_write_io_error(bh)) {
 		ret = -EIO;
 		mlog_errno(ret);
 	}
-- 
2.43.0

