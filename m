Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329195;
	b=cEtloIqIgkJXpAv6+vLEWlaLM1hL0ccYWpuDTFnfodIGIjufKuxjlJb1/EzL+1qF6MP/
	 UTASjhB5EE5g+bf3mfHj7s0kCOB3q6St33Jq/owHIAmk7lCOS9NfXQgqoGV8qh86r3BHz
	 +RELu3QnfDIsWdkRb8gTfDJH49m0FnaoW5KBr9fscBI28cMhMYkf02LbzkcPtxO4plpvv
	 UF5Y2OSIbDBlCcvqMZYG4PRylEuN8TK+1pyHwkDEK1mQAzVqXtNWRaMm1yNbTSuz+ya+o
	 ql5v8aVciT6LmR4+tny4a4AGgTRfDlVAyZZrygZfAskiEFHs2rVQiOuY1l+43T4q1Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=fw1ZBM1QL4ytQh9O2bPl45g+7ysM0aqe/KHHhoFbXag=;
	b=dI5+yWfmoy5jMK8eD/OpCEX1DrmEx3HfwG7QQFw5iZR+SJfA0eKStI7JBHJsEAZUkYLI
	 XKRw7kBIYndH0pzqsB6b8A6htjyDa3+A5dSRTQUPNdfLo2UyZrraYj4LsxPAwk6R3slWB
	 UmBzN48EXKxqrX38sSsuuj+hsc57FWMl9MOnd5WwSyMC418W/YS2MudLuXTDO6oKgljKc
	 Zj4K85o7og5rQWSdInWz6Ledx446nXh5rrNqp1yTBVfXn9sadczVqwRCAaSla8QDQvVKa
	 0wSMkETzIcVbcZS4SbaUGeJWTkFkFP3sH6RWSgpxniAV5UQ2vAwjrYFlFSW/08y8Jeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IctX64/4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7191A606A31C;
	Tue, 10 Nov 2026 16:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IctX64/4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517A71F008A1;
	Tue, 10 Nov 2026 16:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329195;
	bh=fw1ZBM1QL4ytQh9O2bPl45g+7ysM0aqe/KHHhoFbXag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IctX64/4OiE4yt2I6SRzaw7lvWSEmOFBoVg8zBrmSEMM3ErrMuIBEnnuQxA7f1qBo
	 olG+umpYoCGLJJO5T2CeTZhv2hJ96cjEdG6ZJK2c5HknHX3mAlFw5P24Gk+cbVqzqF
	 +kVx4DJp4/fFv0j2EhKCZZREfFPgO8COjJXIpMrkwuXu4MAhXigz1gnALrEE4cvBbi
	 tx1OgmvWVWJXr+NLbUJTYtGEfXvghj85cddQNEcVsLvErF7/o7S2IjlnNPt/oRFHLt
	 F9W8qYMIRGecii8gxeFFJxXszy91E71G+C3DCAyExTIawqkwmU7uERYmaFZ30FenlF
	 9vDP0SiYRnghQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 1/3] filemap: Add folio_next_pos()
Date: Tue, 10 Nov 2026 11:46:31 -0500
Message-ID: <20261110164625.2532323-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261107050829-failed-6.18-329750292e9d@kernel.org>
References: <20261107050829-failed-6.18-329750292e9d@kernel.org>
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

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

