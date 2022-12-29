Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52108C4332F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H2Fj5xVYqE5l3sIBmwgC5+WhRhpyrCiHvk1nIyPWnXw=;
 b=r/yygS2DvpNnT27DWF+RU/XSyd4gbTyFkU9AHS94kBlQkZCwVJsD1daCtJIcijR98e2x9yZ88FGK
   nq/AtYFtoJPUnhY36k+MTEe2M8jBdmPVVewUSqIdjX4JDcPcEyXk9AeoaAF49kIAH2LrGsKL4MLr
   2RsWvT6vbFADL1ue3P2/o00CZvOvpcXfW2XUT9nJFGk4vqxviGJY3Rd0U3qfky+PVueMpszpBTvo
   vIuOk5GIV+K9miTfL5x4VJlazbjl/zjQMZpRQmFk6YG4+0m529JPP/gtu/o/jZrfl89QhYIkAYto
   mGp6XYExD9K0hJl3Y3jAvBidOJZ7jGgRzWEYYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H2Fj5xVYqE5l3sIBmwgC5+WhRhpyrCiHvk1nIyPWnXw=;
 b=rhim3XBDrYQH+RK91A6IgjQHl15zvy13yB57ItDTINSiB7LwI7ZSJY2iXRibC62wRyXV23ooltKg
   SAk5XAuhLsDsJxz9CGGvXiwCz5xRXWyLZx6+gCqzoq02vKDY71W4fUJJMIjEW7oy9JA5hwPpeWB2
   TrMEfGBBORWeD+cWP4mn+3roYe9T8RGRrcqvfNPCndPbgO/IEo2ByfuHXK7vELfukq/IhpvotwAH
   o11rm2sGwAWCuqtZWH7rQkIpw9isWfsFElnW1PUltsSpcct3Ukt2prJM9bEDRhS4ptAh3Go02Blp
   DGEpdIqjUZDMq5v+cIzPjyJ1JHfOmwjeOnpcqA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNN009LVUASDK80@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 29 Dec 2022 16:11:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=JERcZZTMhkivNxo9SqHrHtIaAsMqudDjGhUiCLjWNr4=; b=uEGqoJWMD+5m6rJC3ueg05BpdS
 yvzRe5kSxtpJEljm6rFhRT1KRo1MlimyyptGn9oxiqWwdzZsevEiRJQrIRs1dUZqZsBMxlA9BWQsg
 M60+EvxQ4N/NiSFx77YOHKWe18eT6imHat7MQ+wu+cwl1ZsHZTSOBC43DUrAKHZSnlSSZSqwN25fl
 2xfzM4yW8GRHjwfPnIoPzDtp0qJrNfdyY8+uGVOXTBVIWPnbEUn981Z7rFSjcIz4HWuKxyiJ9WbEn
 sknQxfWX4y/0QjsHbAy7+s80zQxbjy4SGIct67u+X9EVRQv401lmk0efcwt/0lXTE79gy1wgzifMT
 RD2bgzOQ==;
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Jan Kara <jack@suse.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Thu, 29 Dec 2022 06:10:27 -1000
Message-id: <20221229161031.391878-3-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20221229161031.391878-1-hch@lst.de>
References: <20221229161031.391878-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10575
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=670
 clxscore=284 phishscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212290134
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, ntfs3@lists.linux.dev
Subject: [Ocfs2-devel] [PATCH 2/6] ntfs3: stop using generic_writepages
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: kaRTEzunsbeKVTsZh7A2YGOxaQxfdHPM
X-Proofpoint-ORIG-GUID: kaRTEzunsbeKVTsZh7A2YGOxaQxfdHPM
Reporting-Meta:
 AAE5utTXX7uVUFD4c76gAyJnrTN2gzQJnuDb/BkpF2LbY52sIiLtbJPImYI+zKYb
 +JbX+9lRylVkNBQfj2dBLPcrmy1jcu6agUqd+wMdsLJA7jd5VEqcdqFCgplEjAiw
 YPwWF6vxXHPe8p4O6igpgnvNMROPdPm/zZtW/bu5A6ozLsOlKH058CaFK42l8s1X
 W8KkTyCSPkeC9OMvKThBhQ81LSttPcWteVFwV73JeCILX73W+GUT2zvgHZlJ4zg1
 9vrADu3pY7uNy/58ib3gjD+UZs/akOPdcMH6rEhrbk+qoXvernpQ0YWpmIEvCSZP
 T6UL5unw4GvVCin2yRb+wvtQ/A1MIsEk4DonUxiTLX6+2qiYF74gJgnNQGcIX33S
 9rbJ+3100dmxKwh9naH5e56BoF4KtaUbMyitA9bgo+2G0czU7PfFnF+KsGjPlkIo
 52ePBViiI3aARCYMB7LgDmI43JskmzS0WRVNe/Rv+feIxmg2dgKYdyrDTQsfIrE/
 JxxuqVFnPJuF/3+hTkWx6nlv4tCFq7136EFkaXrn5Iw=

Open code the resident inode handling in ntfs_writepages by directly
using write_cache_pages to prepare removing the ->writepage handler
in ntfs3.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ntfs3/inode.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 20b953871574b8..b6dad2da59501b 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -852,12 +852,29 @@ static int ntfs_writepage(struct page *page, struct writeback_control *wbc)
 	return block_write_full_page(page, ntfs_get_block, wbc);
 }
 
+static int ntfs_resident_writepage(struct page *page,
+		struct writeback_control *wbc, void *data)
+{
+	struct address_space *mapping = data;
+	struct ntfs_inode *ni = ntfs_i(mapping->host);
+	int ret;
+
+	ni_lock(ni);
+	ret = attr_data_write_resident(ni, page);
+	ni_unlock(ni);
+
+	if (ret != E_NTFS_NONRESIDENT)
+		unlock_page(page);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
 static int ntfs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
-	/* Redirect call to 'ntfs_writepage' for resident files. */
 	if (is_resident(ntfs_i(mapping->host)))
-		return generic_writepages(mapping, wbc);
+		return write_cache_pages(mapping, wbc, ntfs_resident_writepage,
+					 mapping);
 	return mpage_writepages(mapping, wbc, ntfs_get_block);
 }
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
