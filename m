Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590664;
	b=I1ts62vyeo113viYFGv7lk7rJPymYkRYpIS3gGRD+Vu9ZmzpcnTORJtkX4j1W9JBA2Xz
	 PXXaiZHRuKLXZ5ASwVnVt+IS0LOj999UeHO/i8TA8XLWbND8RpCGh0m2pCm5xeaqDsAXy
	 O0qypE4dCcvNOoz7lGG+bMLqt2jN3gfHJ5SyQ2NK3/yQ6hXtqmKR1P6lBedB1NEidtOB2
	 0vgf3zVegtXmZAUoa6+LMxgpOS6zLMoMvMcb4JO8VBL6Req0TVjTDuzb77w1Sscq+1w6v
	 Ij5kbvRsxE1Sx8aiiO6c8A7IrcXcgOhaIkvgvouEQnkwV2c61LL1Ipo2Vf0zUAQX0fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=prwlOD64zGPIt/ynsojSR3ID95YtBNBu/QLK5mylXm8=;
	b=omijsrHf7BjEQibt5TGaRIxcxsFVvKs//Jki5cIBnJEpUZY5MXg4o/iZ2jyItMyjVqxO
	 NeKzv+NdlqI9y7+V/A5ihpaCinngBGcr3hm3ldPl9xTcJFYv73ktFIkIb9K++8S9Zqr5F
	 0lQVbnglaENy7FZOy10RYdO2MQS2iu52biuvc9WTXkQnc6l/lPGZGMujzYoxdQA8psUcu
	 RZ2BHB9SAbZDpkBdUqhPN9a6bK/kJKkz0DxdCay+m3uuy9qhGQ2TiNttWhqpvayLZwCq0
	 uTAyf1lMu7qD+HhCUNvxtj1//0FcromLbyL2aG/sYgGu71l3WitBQFAHmZsOh1YUJiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F3n19Qbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587DF606B221;
	Fri, 13 Nov 2026 17:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F3n19Qbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3381F000C4;
	Fri, 13 Nov 2026 17:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590664;
	bh=prwlOD64zGPIt/ynsojSR3ID95YtBNBu/QLK5mylXm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3n19Qbr2XKMYPO8aI9Qecsx36cv6K6bMahrHBj+4nJrFCPZdhEmH66hHvUTp3Vd1
	 LHXAxjiG66aIl5oAZoLvbrpgRczojyEyU71p5OGzNxdFfvY2Qc/VHkicK3T3pKIIEA
	 ca//vjdKxWfM7K5r/h9HnpX3tTyQJj9HnaYU8DlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 581/686] filemap: Add folio_next_pos()
Date: Fri, 13 Nov 2026 10:51:54 -0500
Message-ID: <20261113153841.481514272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 4511fd86db6f8f94f8aff01044f5c69aa38f81f4 ]

Replace the open-coded implementation in ocfs2 (which loses the top
32 bits on 32-bit architectures) with a helper in pagemap.h.

Fixes: 35edec1d52c0 (ocfs2: update truncate handling of partial clusters)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20251024170822.1427218-2-willy@infradead.org
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 329750292e9d ("xfarray: don't crash when sorting if array element crosses a folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/alloc.c        |  2 +-
 include/linux/pagemap.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index fb7d8dc2129be..d22ad99c9ebee 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6891,7 +6891,7 @@ static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
 		ocfs2_map_and_dirty_folio(inode, handle, from, to, folio, 1,
 				&phys);
 
-		start = folio_next_index(folio) << PAGE_SHIFT;
+		start = folio_next_pos(folio);
 	}
 out:
 	if (folios)
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878d..e16576e3763a1 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -941,6 +941,17 @@ static inline pgoff_t folio_next_index(const struct folio *folio)
 	return folio->index + folio_nr_pages(folio);
 }
 
+/**
+ * folio_next_pos - Get the file position of the next folio.
+ * @folio: The current folio.
+ *
+ * Return: The position of the folio which follows this folio in the file.
+ */
+static inline loff_t folio_next_pos(const struct folio *folio)
+{
+	return (loff_t)folio_next_index(folio) << PAGE_SHIFT;
+}
+
 /**
  * folio_file_page - The page for a particular index.
  * @folio: The folio which contains this index.
-- 
2.53.0



