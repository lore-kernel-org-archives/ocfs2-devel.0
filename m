Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0732744C4E4
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035556; cv=none; b=rvHrm8GW9J9/xfL9gbgiyJ7moIldp43XL2RBwtIJqVVGzz1C11UTqd03e31nHMSWodoEmiDA8VcsHXuS3UQLNMydx3yYXvI8Nf1VyqGiAszLYZp9vPLdGBjX65iDfaD/g5dzghOGiE4+oVU05igR8QPCSEkO6MXlnqwV/XgB++A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035556; c=relaxed/simple;
	bh=5Z1GSiO2bc0sbRA3/0yuB6INnEL0uS+pxP2xPMYMvWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7Z0SvrJNV9Y0z5EE+XWI1OXIC6lWGzC1hkwCwMMDQmZ2VbFd4BgyQbTjkfPSgErWC8swc9mradHRI0u1zYrlDQ/ljk8/m/+37lVibJ6hdEwh59n2e1VLEnaPqx9o+EaeFtnFCC68EAgXYzsNdBj4udCkKZAmS/04WwofQpGSog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ls4w5axF; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ls4w5axF"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5bf959b820cso1630882e0c.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035554; x=1786640354; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ft6ziQssPBfawpI3vOIh0QGxtSEYHeudqaZ7dvpKRmU=;
        b=Ls4w5axFxevzpyOKUIuKow7vRD+SCOwxPG67r0vkRpURfIqYW1Svufrd+wY3Izw2fh
         cFVNDdShz5oSoBWhUSPi6p9XLwVpkaY9qrud5Mt1f9KKOVLJAlDr28tKsMAAfShwUdMm
         EibNVLu4cMG86bfM66H95CiFMPdewcR/tAjARQJQ+b+eqXVJOFUdwTgD890hgXXpNkkW
         QLCL9PY8AGlP+QBog1gervFpEqbuLtSJy9TRoPkDJ6Rdcq33T+zyRAGPwbX7bNzWyOZI
         py4mY4Bp2RsS27ht6b0guZMs17W38a32UC5ZD3/F6q7TqO3+7MwSffQjRlL9Psi8pqm3
         xESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035554; x=1786640354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ft6ziQssPBfawpI3vOIh0QGxtSEYHeudqaZ7dvpKRmU=;
        b=etwSpnpQ0G7jyVpQturVd4/KuOn5Dw0FMXbsI0uM/AR6z+Ji6X7x9BZQqXV9UBinik
         g9bdlae3AyEe0HSPaYXgAijJJ3haaCtYvAisynCJVsHxGkYVZZ1LBblgp3bRy3SaZp/3
         8pQmKy+Rlmoxo6noaO95r2s6JoLE7yf4lS016txvfX8z9n4rgnbbrpod6C2lv24Kp7H2
         up/y4i2S3BKbhYM+uKboA16FJUicpV/cY0Hp3eCWXjo6sFY3u4fpACjgXYRNTPJJYeQC
         kljH96qg/n4GjLMHgnTY5IaUFBYmXMmqz+GVVtzF/58AaHHdKkJu5vSj+OAZ+sHpRl0o
         ocQw==
X-Forwarded-Encrypted: i=1; AHgh+RoeRcHoZ7i+g+rHUzyKwIH6oZ3rQteaNmmgVftR0MSfvTL5dNM9k9qtct9XqoZHdRDg7bxph+Z9EfMvXg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxxp6neAIVpDUPibW/4azrChnZmM7icGAou/Q14WLfZAAWDP3fI
	7sZqoSgY6osQolKgMqAbSrK8d1NsM7dlzk54O1W/wu7txKfHOI32knZf
X-Gm-Gg: AR+sD12Z3QH9Xlt64ONh+muFT7VeSlL0xeWYaDv4Nze/U3SVHd9Sb3he1VoGz/Oy1Xd
	z/jftrgm2CECfM6XFG/Zlt3KfLDpTJPpYz2n0oXYFtPWZURUqyYt+nm9/ViGqXcioem7OCtY4Oi
	GoOZrX02ce4qUbHnwnET9K72quVXkb7L+h2RbXp1YmaWVbBcgYKQGMFpmbsv74zLsyyUztMYQnN
	5uQpOpnlf5pDmFhR9s5WpBZojQtCFBRyH+4jqhs2lvYs58td/Fbhq8X995xENWw10me3d6Xy4KV
	clL7tV5ly7w3ErlsJ++6XOjmGfhK/IYunJ3oJIS8+r/6Ku239Md1lU5IosPXaP2B4VnYWl8Qfz9
	8VdXrTc3mnzFOFBIkGIbWnQbbP4MyNUMRN7fhHARZ9zpgKEgOvdJU4GkguJgA8cESNMryWD6yGN
	j8tNSVBDOxdH7PPMeS2OklGvmmR0OHTlER6TRtF3a2g3fFSfguWuiCwRw/QQyjWxordU7AXijv2
	/dx8l4=
X-Received: by 2002:a05:6122:1c85:b0:5bd:8c84:59aa with SMTP id 71dfb90a1353d-5c3d9162e78mr2479549e0c.8.1786035553890;
        Thu, 06 Aug 2026 09:59:13 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:13 -0700 (PDT)
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
	Zhang Yi <yi.zhang@huaweicloud.com>,
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
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 05/21] buffer: clear BH_Write_EIO when a buffer is forgotten
Date: Thu,  6 Aug 2026 12:58:28 -0400
Message-ID: <ebe0b4f179ccdac7a9400fe2611623ce218c8d87.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BH_Write_EIO records that the last write of this buffer failed.  It is
cleared when the buffer is written again, but a filesystem freeing a
metadata block never writes it again.  It calls bforget() and hands the
block back to the allocator, so the flag outlives the block it refers to.

That does not matter much today, because the write error is also recorded
by clearing BH_Uptodate and the buffer is discarded soon after.  It starts
to matter in the rest of this series, which stops clearing BH_Uptodate on
write error and makes BH_Write_EIO the way a failed metadata write is
reported.

bforget() is where a filesystem says it no longer cares about this
buffer's contents, so clear the error there alongside the dirty flag.

Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2851830995d8..381690479520 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1091,6 +1091,7 @@ EXPORT_SYMBOL(__brelse);
 void __bforget(struct buffer_head *bh)
 {
 	clear_buffer_dirty(bh);
+	clear_buffer_write_io_error(bh);
 	remove_assoc_queue(bh);
 	__brelse(bh);
 }
-- 
2.43.0

