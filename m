Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E45EFC67871
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4P06jxon/ugyqI4xnrv2DSlt++jkzcDkkwksHopAB+4=;
 b=bC7zCmXa7/dez0c3PuuiBUl39OzHxIxLnR3Hzfqnwzs9X7Kb8L8jQrF9KGQ6nlY+HuKzSKfbNHdD
   M5LPOnZIR3yKaRIFzvUL6YtZGPmRB/hpJoxaUEmSE+k6LuC4I/va8I0UFv7R+mTMIqgTY9AqjxL8
   kpcVViB9MweqYYNE5GIYn5Uwuo76mSPo03xStDVsC+JGx2jAG1dkAHIS9szsrtlTdO2CGBHTHP+o
   YhhVeEM52f7wIRgRByPE9ZYrZETPmMwUJGR0c//YH9Oqn9UG6Nq37ChGPEGmYcN3sJ15/tS72gmm
   YdG1PSPAHHGW01NIGFyNwMC58ELFrGHzcQXiwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4P06jxon/ugyqI4xnrv2DSlt++jkzcDkkwksHopAB+4=;
 b=M0RB9zqxmJQ3B4fII+50ywJsDQY0dbFcNu3Fy3Bin+c4RNyG56/zBDBooLwA/gTUdhO6xixXHcPa
   9eAQHXs/0bvXD/WAWMChs+qyEQ5zfd7oo5bmu4OLiLaj4jLsz3MHrWVaOqp4/A8+eVTvdkrKZqeV
   VPUuy/hTOyGRPDr4BR9YBaYVvttupyf0GG0m2XdFaCwCPdQlIH9YFJU6qUn3U4XiDz9TlVr/qVcF
   kgNA1/S+oSWfColyc6tlFmY3xSqxAeEhqat5a/GvcEuHnPMLvpUTtHbEzx2Q34eiE0AI83rV5ED6
   5k/dJODoko+stRTGlH+0tA9J5PBeVj8TnusU2A==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600330F3V9D30@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 16:57:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=lFvtQi+fLwMAHlLvXJj+xcXbU2gUQgSohjqo1SaHtyU=; b=oCh8q89awjYtytoZeT3pHyKMkl
 VyT99nkn9BUuSEHliHPt62EP8SCxWjNrcNLmisEoaHMhYjJ8blEV2oOQjss2Be8g/xEE9Xu6T3NXp
 cX2D3XC22yjMYecCu3dMuigB7G2U+YrmmMECKpaqBwx1GZ7mj3KW96NRON6fZ4NNOhhoCXma7S6jX
 kwHVVTH7ntlpydXJw1owjb0dtlCOQp1u4Psodi/w/rAdX6DMMVmMLise2oRJNsVxC9vWRy+Myt95+
 CvWwxs1xVejbXQVUEiHnuz2WHplf41pBViKOvH7DT3UKkzeh0LnVga9cr6PVhw5F/KrNlu4CexH4y
 TUx1FMmw==;
To: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Sun,  8 Jan 2023 17:56:39 +0100
Message-id: <20230108165645.381077-2-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230108165645.381077-1-hch@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=302
 lowpriorityscore=0 phishscore=0 priorityscore=95 adultscore=0 mlxlogscore=823
 suspectscore=0 spamscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080126
Cc: jfs-discussion@lists.sourceforge.net,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-mm@kvack.org,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/7] btrfs: don't read the disk superblock for
	zoned devices in btrfs_scratch_superblocks
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
X-Proofpoint-GUID: 1dIgFSeD1fzRsmjZIk2cfoE2tDSfZD1c
X-Proofpoint-ORIG-GUID: 1dIgFSeD1fzRsmjZIk2cfoE2tDSfZD1c
Reporting-Meta:
 AAEZYbpWAwV9daWWqj8jGzveBcmP/a3pHnkfaqqXrwOE576U8NHcNSaNeDAcWC4x
 QJiTGcrKd8cVlCK5xt3IrwcI4LFGuFzXlDWXvKSjtloCfGDoAQzzaycZLyIluMS+
 QvzTfd9LV5CRBTUJ+/J06crHl+cRfuo+u7mhFSFdOfAumJENFT+9A2OWRI5KRrmN
 cOzb012q7D7yFMIAYjYQlM1WxcQtYAXMUbZ7pCamVXRWkD5fcCLQsEywMbOq/0J0
 97k8huND57fkyuHk/Tj9sI94pVU4munJP5QdGv4KLSYkPmj6jgxD1LlGlHZ0cITk
 JYXSZD4KdozyhyI6fPYqYx4nNWm/6PclRTxeVT8JNhPJZJM0Ilimkxxsb/VF3F95
 h51fPlwxxbvO7OKVYkwLoMPrf1D/8xdr6/Z18/q86Z59aQKdMsIPQTQj1CIG5J4I
 1vmT9STOU8s1LUUYezcOTTsuaA3b5OZuDkSZwayQ4/OvRMOD7FEbV6M2oIa8EQZW
 UxJwyI0c+UTWUHsY/+SF6JelBxjOLf9piaoxb3qr55DB

For zoned devices, btrfs_scratch_superblocks just resets the sb zones,
which means there is no need to even read the previous superblock.
Split the code to read, zero and write the superblock for conventional
devices into a separate helper so that it isn't called for zoned
devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/volumes.c | 51 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index aa25fa335d3ed1..1378f5ad5ed4c4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2005,42 +2005,43 @@ static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
 	return num_devices;
 }
 
+static void btrfs_scratch_superblock(struct btrfs_fs_info *fs_info,
+				     struct block_device *bdev, int copy_num)
+{
+	struct btrfs_super_block *disk_super;
+	struct page *page;
+	int ret;
+
+	disk_super = btrfs_read_dev_one_super(bdev, copy_num, false);
+	if (IS_ERR(disk_super))
+		return;
+	memset(&disk_super->magic, 0, sizeof(disk_super->magic));
+	page = virt_to_page(disk_super);
+	set_page_dirty(page);
+	lock_page(page);
+	/* write_on_page() unlocks the page */
+	ret = write_one_page(page);
+	if (ret)
+		btrfs_warn(fs_info,
+			"error clearing superblock number %d (%d)",
+			copy_num, ret);
+	btrfs_release_disk_super(disk_super);
+}
+
 void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
 			       struct block_device *bdev,
 			       const char *device_path)
 {
-	struct btrfs_super_block *disk_super;
 	int copy_num;
 
 	if (!bdev)
 		return;
 
 	for (copy_num = 0; copy_num < BTRFS_SUPER_MIRROR_MAX; copy_num++) {
-		struct page *page;
-		int ret;
-
-		disk_super = btrfs_read_dev_one_super(bdev, copy_num, false);
-		if (IS_ERR(disk_super))
-			continue;
-
-		if (bdev_is_zoned(bdev)) {
+		if (bdev_is_zoned(bdev))
 			btrfs_reset_sb_log_zones(bdev, copy_num);
-			continue;
-		}
-
-		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-
-		page = virt_to_page(disk_super);
-		set_page_dirty(page);
-		lock_page(page);
-		/* write_on_page() unlocks the page */
-		ret = write_one_page(page);
-		if (ret)
-			btrfs_warn(fs_info,
-				"error clearing superblock number %d (%d)",
-				copy_num, ret);
-		btrfs_release_disk_super(disk_super);
-
+		else
+			btrfs_scratch_superblock(fs_info, bdev, copy_num);
 	}
 
 	/* Notify udev that device has changed */
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
