Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC52DF4A
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Aug 2023 11:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/Zn3NpNJWq/hZ5prwh3EWG/jr2VOTrVu8Gph2i+fSUQ=; b=1hOyzHBDzvjoL9S9paVvMSG/Ev
	86tUyqf5KZEiWSRo8pRl7Qzrf9SVzlA6JoV3gOzYsKNh8QFyAoG7vVUqGGbDG5b/D9IJOvN4wtryF
	OmwL71CG+z8jKK65wWU6RHq5k6lQ1ZOMxyoDiTRlnHl3JP/poDNyeJp+0s3UxHnG7HKXgGwker+qY
	CTe+ZQLc8WRFoLmGkpk+5/Y5tEk90PxlZNQWRLfsLuVx1KlS1q/6bIDCWx85dMi3S4g/S+/Y7mT3U
	jqn9PMlWI1dj+mK97db0zfvhLZEPFSz1Ipf+ZClZ5m9Ss/fN4s8EdfFhIwHjiSwMkPHLsEuNpmpkM
	OkdQPMpA==;
Received: from [82.33.212.90] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qSyNn-00H58p-3C;
	Mon, 07 Aug 2023 11:26:44 +0000
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
Subject: [PATCH 2/4] ext4: don't use bdev->bd_super in __ext4_journal_get_write_access
Date: Mon,  7 Aug 2023 12:26:23 +0100
Message-Id: <20230807112625.652089-3-hch@lst.de>
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

__ext4_journal_get_write_access already has a super_block available,
and there is no need to go from that to the bdev to go back to the
owning super_block.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/ext4_jbd2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 77f318ec8abb78..b38d59581411c0 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -234,8 +234,7 @@ int __ext4_journal_get_write_access(const char *where, unsigned int line,
 
 	might_sleep();
 
-	if (bh->b_bdev->bd_super)
-		ext4_check_bdev_write_error(bh->b_bdev->bd_super);
+	ext4_check_bdev_write_error(sb);
 
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_get_write_access(handle, bh);
-- 
2.39.2

