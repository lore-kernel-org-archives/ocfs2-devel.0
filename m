Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C69DDD6
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Aug 2023 11:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C2Ha4CsVUfelPjS394inJjcDyMnuCGSgGsAEG2TLFOs=; b=1JpZRRVnoWMAthkvQEzrv4+W4k
	xkFCTyVcxJDWwlC63fh8wIWbqCLTYf3/iHohEet5ZOt33F1KmnMKK82SrQibH0vaYyZv78MrqtBMu
	Vte7FzIZzcLSJBjsNXgQUUSxS51eeH4/Kx1uPx3G7OPGSfrWgboGGEFxsxOMvaiReSZLcJ9AdW8bY
	SIp/99YnQin5dcgBpW3gG7CKl4HnBBmc3RT2flRY8iFJm6Eh/Nb4yzrXNFQwkJqtU3fZUcgiOtoRm
	lapJ19X4mbexsR0JXMq7L4ILuSROxgiE4n7qJzF5UGCm4jsnpr1TRMfGPyzl7LAl8rNRjf3za3UrZ
	sPXh2Crg==;
Received: from [82.33.212.90] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qSyNr-00H59X-2k;
	Mon, 07 Aug 2023 11:26:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jens Axboe <axboe@kernel.dk>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH 4/4] fs, block: remove bdev->bd_super
Date: Mon,  7 Aug 2023 12:26:25 +0100
Message-Id: <20230807112625.652089-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230807112625.652089-1-hch@lst.de>
References: <20230807112625.652089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

bdev->bd_super is unused now, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/cramfs/inode.c         | 1 -
 fs/ext4/super.c           | 1 -
 fs/romfs/super.c          | 1 -
 fs/super.c                | 3 ---
 include/linux/blk_types.h | 1 -
 5 files changed, 7 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index d2eea2e4807c4f..569f88dcb2f12c 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -493,7 +493,6 @@ static void cramfs_kill_sb(struct super_block *sb)
 		put_mtd_device(sb->s_mtd);
 		sb->s_mtd = NULL;
 	} else if (IS_ENABLED(CONFIG_CRAMFS_BLOCKDEV) && sb->s_bdev) {
-		sb->s_bdev->bd_super = NULL;
 		sync_blockdev(sb->s_bdev);
 		blkdev_put(sb->s_bdev, sb);
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 063832e2d12a8e..e6384782b4d036 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5563,7 +5563,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	spin_lock_init(&sbi->s_bdev_wb_lock);
 	errseq_check_and_advance(&sb->s_bdev->bd_inode->i_mapping->wb_err,
 				 &sbi->s_bdev_wb_err);
-	sb->s_bdev->bd_super = sb;
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index b9eded546259bc..22cdb9a86a5748 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -593,7 +593,6 @@ static void romfs_kill_sb(struct super_block *sb)
 #endif
 #ifdef CONFIG_ROMFS_ON_BLOCK
 	if (sb->s_bdev) {
-		sb->s_bdev->bd_super = NULL;
 		sync_blockdev(sb->s_bdev);
 		blkdev_put(sb->s_bdev, sb);
 	}
diff --git a/fs/super.c b/fs/super.c
index efa28679e3e5b3..0023685815fda0 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1369,7 +1369,6 @@ int get_tree_bdev(struct fs_context *fc,
 			return error;
 		}
 		s->s_flags |= SB_ACTIVE;
-		s->s_bdev->bd_super = s;
 	}
 
 	BUG_ON(fc->root);
@@ -1423,7 +1422,6 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		}
 
 		s->s_flags |= SB_ACTIVE;
-		s->s_bdev->bd_super = s;
 	}
 
 	return dget(s->s_root);
@@ -1436,7 +1434,6 @@ void kill_block_super(struct super_block *sb)
 
 	generic_shutdown_super(sb);
 	if (bdev) {
-		bdev->bd_super = NULL;
 		sync_blockdev(bdev);
 		blkdev_put(bdev, sb);
 	}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 0bad62cca3d025..d5c5e59ddbd25a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -52,7 +52,6 @@ struct block_device {
 	atomic_t		bd_openers;
 	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
 	struct inode *		bd_inode;	/* will die */
-	struct super_block *	bd_super;
 	void *			bd_claiming;
 	void *			bd_holder;
 	const struct blk_holder_ops *bd_holder_ops;
-- 
2.39.2

