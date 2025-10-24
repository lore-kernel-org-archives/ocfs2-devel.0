Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2A031D751;
	Fri, 24 Oct 2025 17:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761325709; cv=none; b=UGoV9gLbyme5ln6ACkllUVq/ZkIqqhe1FLICcJq/UOfUWjDVIQNr2HN2u887/zlWMgW+YUG4ns7VbD9H9oyUcblc66BVi6UK7PVnE17Fla59rwfw19385RbZyvW6nIi1jJdAtAhazEhp9ooKDOVNnuRgxsWagZDftFPo0YztH1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761325709; c=relaxed/simple;
	bh=zYdTJOgapAFKVjT9trEkPlkpCkQBy04KPDl3fSFOy6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIkeicmGSl9FWh1X3CYyeYJxEmi6KhqZMTN+dLUfG368a/Tk5DPfyaeBijdOwoWGtRqWU8yxUBxcmrxRA8/qYZcuh7JREVNJ/nsYQT109o2M2kQoAyvmdoWqGyYEfKVJZvMRQH6UCqYuIyyMxeh2TzAEed25NY2aaz7tW2j2fCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cMGukuXH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cMGukuXH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=UcPyyDZpz5flXt++/wS3mYYcN5qM5XbOtlxGVYwjhBs=; b=cMGukuXH2WbNVH55yV6XLYovPN
	nvFIIt9STDhMA4RF7o44KyY+V/V93RNAmpCmBxCSvq1T28/vQfF7PQAf4vFyX/r6Hdq7TiSAPe+Bh
	HS9AL+TAFKUKC95uBXTTJQ6fNcdfIV3H2WOuriRrfEMwlLgu+sZrNl5DKUL8uInDWB9xT9TZnXjko
	tlKY4g/myz+iJ1wT+Yq0mNPSWb2GDKT6G/oQPBOIRRN86iQauMXOaJf1JfVBMDISiax6mD372ZsV1
	froNlQY+Zp3JnyqFNRgMvxl8ZTh8Cd5MysYsJqWVya1QzSFNnjU9ipo2GDGYiA52lPloWJVoq9Frs
	qmjNQdFQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCLH6-00000005zKm-0S00;
	Fri, 24 Oct 2025 17:08:24 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH 01/10] filemap: Add folio_next_pos()
Date: Fri, 24 Oct 2025 18:08:09 +0100
Message-ID: <20251024170822.1427218-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024170822.1427218-1-willy@infradead.org>
References: <20251024170822.1427218-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the open-coded implementation in ocfs2 (which loses the top
32 bits on 32-bit architectures) with a helper in pagemap.h.

Fixes: 35edec1d52c0 (ocfs2: update truncate handling of partial clusters)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
---
 fs/ocfs2/alloc.c        |  2 +-
 include/linux/pagemap.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 162711cc5b20..b267ec580da9 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6892,7 +6892,7 @@ static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
 		ocfs2_map_and_dirty_folio(inode, handle, from, to, folio, 1,
 				&phys);
 
-		start = folio_next_index(folio) << PAGE_SHIFT;
+		start = folio_next_pos(folio);
 	}
 out:
 	if (folios)
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878..e16576e3763a 100644
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
2.47.2

