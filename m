Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2632989B7
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409256; cv=none; b=Hmh5Qt/FiOS00d6zyfI78UiyOVyRpAgoGXYunLAmYPJiK0kLK0vzURoiDJ5ZsQ/hEHQHwx6etXz9eZSVqaN0EAqvkVZW8qDUkXBQRAltq8+lVvmv36TnaiZFFoAIjdKYeCcLBQdxruRZo3UNOYus/d5aDVVsfQoE/WH3LMeRu7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409256; c=relaxed/simple;
	bh=Ygd2xNOZ6wJl+5bd6IH5BNX7SOauXKYvij+j9ifOwTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8Q0srojhyL44hgEhrbL4Ykag2vUY3P4dqTGK35j4XPLQHd+9nZaNySlH647vgweOSiWSduaRTcFu7Evy+TOI9xYGOGTez5Cb9rDyl7lt/ElVzGm3ejAGqgU7vpSXrGL2DOgR1hLFRh8eB2IaLerDlS+ZOtLvGCq4CDzDuNyGZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iey3xi9B; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iey3xi9B"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45decc9e83dso4239095e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 02:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409253; x=1758014053; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oqrc3yRxVyX7zMtuBTJxbswEHmIj2FBD0Au1ZvwTXKg=;
        b=Iey3xi9Bor1oDjxq8h3o9czbeGxB1m1txiHItc5Gz+4xbu3KfUESOEQrvdBWutK32l
         wbmQ7OiMLfGWU9BqfZppbVr2ve83VOEQrecVzaLgiq1q0ueZgv1sztp8g+LVkhpM+rMb
         LtHmr9lDtIP+E8p0FW3gnumC3FNeHZA5jEUjCKdIBR4R416OPZ7xHud0QlHM2Dn8K4Sc
         4X3WyU3XNEvEnK52Q8Xgf4AEInkXgPTiLnRxzotRO5lMy18dSsAH82VLc3lAWbVPWYt5
         USjjKOzjWd2mFU8gZQOfD8J5QM+XmaJNKfp0LAGqdc0nVtZSKxFbXH2N7uroQO/GpcMc
         2xAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409253; x=1758014053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oqrc3yRxVyX7zMtuBTJxbswEHmIj2FBD0Au1ZvwTXKg=;
        b=GFmr+ZezzqvnawAwQEWrx35aK0N3QCs472KWRDuKl/pQSs9eKfK63Uj8gaQb3EA12H
         y3NQYH4E7TEWjMwK9QSd5pC55JW21KordO/0qoI6+XjDGO1ho4cn5EjytzaZ1yW6rog2
         VzYRyvZBB/cPufqfinitEt+Xi50C1pjzpe1VzUXMsmLOfdrUCD8oWY8xorThkedFKYRM
         msT3ERjnISEd7WibNPXk+cFbFp3bzMUscBLoykEti0SIZEbYSDeVY+nai7NFN/K7BGlY
         ytQUiepKrxAxF9JANc7uhdiEGLrzaEbHyi9DdprvoPDPWmSBi/VnlLAgUH1xZU5fKfUI
         uY1w==
X-Forwarded-Encrypted: i=1; AJvYcCWaAYz/RmEq1BI8D4Tbj6+c/G9oa/HeQ6RWDWxXfm7RMgeCHmusMmKVFb62acvV/z0vSX6ztZORWScHzg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxvH4DL4d7UhMDbpN0OJcT4pXEB+muZJQabe2vR1hDeUGzu7oF1
	QT7iI6WytgvNPalgSMsUFhyGwZd3CP45dBxn24kvS4WUfvhbL3eww+2w
X-Gm-Gg: ASbGncuOE4E8FuNE99U+ohXjJOJ2PSt1YONtwWjTaSPHhfSZnyW0e2KuPa6lVhxe0Uz
	BHxsMvclt/8dhV35jjUWqP+L2N+ZR0sY7SI+9gXrc2wu6OI702qPuHEwRX9Kx1KA0W15dN2rNQ3
	mvfD89T0Wj0IYacqnWt+nm6LnMrpBShk/aUXnpdtkiyqGGD40Hu+aT4mL0VJ43dthQvkAFIGQ2a
	nMocOtkBWLaS7XqAzf40ik84mBcdcl4j11W+aHQ04vrKSWnJvagKZgo7++qj/coSu/msE0sqisO
	U/Q6zu8OoJiVmu7PiZJcZDDz3eDZSYnJvBRFqlX4K4RZPZwXcSiwFlpXZee5lPcywl/mus7SmKj
	1j7f/IZxuL4VfMCd/VfsCJ7IzjLxef24d00JTmPKUfS9XVX8YgV8=
X-Google-Smtp-Source: AGHT+IHAbfflRnixVZpH4RBMAgPFhxkpEzJjRDnWXqCOhfzm++EGw6quNoSwW084M8/CBIXis2UE7g==
X-Received: by 2002:a05:600c:5247:b0:45d:e285:c4d7 with SMTP id 5b1f17b1804b1-45de285c731mr70343735e9.9.1757409253090;
        Tue, 09 Sep 2025 02:14:13 -0700 (PDT)
Received: from f.. (cst-prg-84-152.cust.vodafone.cz. [46.135.84.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bff6esm1810784f8f.13.2025.09.09.02.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:14:12 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2 04/10] btrfs: use the new ->i_state accessors
Date: Tue,  9 Sep 2025 11:13:38 +0200
Message-ID: <20250909091344.1299099-5-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250909091344.1299099-1-mjguzik@gmail.com>
References: <20250909091344.1299099-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/btrfs/inode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5bcd8e25fa78..1cfdba42f072 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3856,7 +3856,7 @@ static int btrfs_add_inode_to_root(struct btrfs_inode *inode, bool prealloc)
 		ASSERT(ret != -ENOMEM);
 		return ret;
 	} else if (existing) {
-		WARN_ON(!(existing->vfs_inode.i_state & (I_WILL_FREE | I_FREEING)));
+		WARN_ON(!(inode_state_read_unlocked(&existing->vfs_inode) & (I_WILL_FREE | I_FREEING)));
 	}
 
 	return 0;
@@ -5317,7 +5317,7 @@ static void evict_inode_truncate_pages(struct inode *inode)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct rb_node *node;
 
-	ASSERT(inode->i_state & I_FREEING);
+	ASSERT(inode_state_read_unlocked(inode) & I_FREEING);
 	truncate_inode_pages_final(&inode->i_data);
 
 	btrfs_drop_extent_map_range(BTRFS_I(inode), 0, (u64)-1, false);
@@ -5745,7 +5745,7 @@ struct btrfs_inode *btrfs_iget_path(u64 ino, struct btrfs_root *root,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->vfs_inode.i_state & I_NEW))
+	if (!(inode_state_read_unlocked(&inode->vfs_inode) & I_NEW))
 		return inode;
 
 	ret = btrfs_read_locked_inode(inode, path);
@@ -5769,7 +5769,7 @@ struct btrfs_inode *btrfs_iget(u64 ino, struct btrfs_root *root)
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->vfs_inode.i_state & I_NEW))
+	if (!(inode_state_read_unlocked(&inode->vfs_inode) & I_NEW))
 		return inode;
 
 	path = btrfs_alloc_path();
@@ -7435,7 +7435,7 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 	u64 page_start = folio_pos(folio);
 	u64 page_end = page_start + folio_size(folio) - 1;
 	u64 cur;
-	int inode_evicting = inode->vfs_inode.i_state & I_FREEING;
+	int inode_evicting = inode_state_read_unlocked(&inode->vfs_inode) & I_FREEING;
 
 	/*
 	 * We have folio locked so no new ordered extent can be created on this
-- 
2.43.0

