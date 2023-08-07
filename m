Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F23DDD5
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Aug 2023 11:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ky+k0g+J5564niq+DKuVc0tR1t2yylRBRhDkAPI/eLw=; b=AbDWfoXa1Rrr6yaRZ2JfglBrWC
	74h77GUxINqS1IYkil/0bfIDp00HdT4F+eW0qd4qC9R3LM+VJWT6ZHcOqg/sa8G+cqIxB5Ci481y9
	wgowCTHq4ZgvtfAeS+qRHHotyF+JVrgJMF68lYpO65FcWVr/rUSchVJeOlyV2CEtJ03abCRkk9oFW
	b5x+qwDsaNSS6EIAnqlJHdZUDctX9Hb5ghAC08WPISbqK8qv0qdoLKrB6PUzSxDyrmmMLMfAG38Ry
	fEIHvnddFad4vKve5/58yzndhEB4WzjhqhegDMmq+eYdx6+xHDVfgdXOCgiFokaLhMld51XLKe4Tp
	9CzCPr6Q==;
Received: from [82.33.212.90] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qSyNq-00H59J-02;
	Mon, 07 Aug 2023 11:26:46 +0000
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
Subject: [PATCH 3/4] ocfs2: stop using bdev->bd_super for journal error logging
Date: Mon,  7 Aug 2023 12:26:24 +0100
Message-Id: <20230807112625.652089-4-hch@lst.de>
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

All ocfs2 journal error handling and logging is based on buffer_heads,
and the owning inode and thus super_block can be retrieved through
bh->b_assoc_map->host.  Switch to using that to remove the last users
of bdev->bd_super.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/journal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 25d8072ccfce46..c19c730c26e270 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -557,7 +557,7 @@ static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
 	     (unsigned long)bh,
 	     (unsigned long long)bh->b_blocknr);
 
-	ocfs2_error(bh->b_bdev->bd_super,
+	ocfs2_error(bh->b_assoc_map->host->i_sb,
 		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
 }
 
@@ -780,14 +780,14 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
 		mlog_errno(status);
 		if (!is_handle_aborted(handle)) {
 			journal_t *journal = handle->h_transaction->t_journal;
-			struct super_block *sb = bh->b_bdev->bd_super;
 
 			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
 					"Aborting transaction and journal.\n");
 			handle->h_err = status;
 			jbd2_journal_abort_handle(handle);
 			jbd2_journal_abort(journal, status);
-			ocfs2_abort(sb, "Journal already aborted.\n");
+			ocfs2_abort(bh->b_assoc_map->host->i_sb,
+				    "Journal already aborted.\n");
 		}
 	}
 }
-- 
2.39.2

