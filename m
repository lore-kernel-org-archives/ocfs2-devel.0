Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABF07C4332F
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b/Mu/tNkTvj83TzTpjVfeJwQdLdU1evL2qba9H6BTTg=;
 b=ff6b1t+w8LtyT5SDwMxrarCSNbnwWnH0aXKJhAX/2SjH+koVX++M30XhCHl/xP4eQ/jRldORtNWa
   QfV5F3SiuJbQEw/dO7NLa3MUMDs4H7E8hCkpuqxyzymjHhGt/E8L8J0zKA4XNSACmToLNx1fjbkd
   MOkVMy2ydPUanu3BVzE+QQhIijgnLVVv3z2Dzrwn/MB9rKd84UMxxLxcrtVWBzD1DSQJxy4EKuib
   6LG24GZLAGWEgaeMnesSfeeo0aVZ67g15d1NlB90OuYUbMu++QGfRR/siiR+9gyzImzDvAdQ0fY3
   WyMouDS6Uzl/gd8wabwgaAO+avS17QtqVOAQfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b/Mu/tNkTvj83TzTpjVfeJwQdLdU1evL2qba9H6BTTg=;
 b=qGFqI+JdzBVdCtUnqfb/FV9E7VTJYp11j+5E/IMwu18Td5ibR7YF4ezOjqnwIpb61h2Nqrr1194W
   G2iAbXwmgO7RNnG2ygjXKNUEYFZYep6q478KudLAYGdsRaIatbijqq4HAl1sjWA1XSMREUXMisJR
   IRnRhpShG/o/j/mwluPgcjeDGtsm6b6GyUOKdw9gbfAodP1gI6Kl8hNjRlEV4f4hqcfX4Us+poD1
   wiiDtccOzamTGX5/liX7Bq0ZWpAtEYlOKRtvIaoIFl2aV5U9gel4jTxK/www9UYoxxZwcUni615J
   ZoLZAFybHzGcflFMY5Nth78iuieiFMCxD2z6Ag==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA2007ZW2U62L70@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:51:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=OTIsP1OizukmDhxFkiULvJk6rKtH8rZ66Toc2zFZ06c=; b=UPj32NEZSs0CZXU66K8zWiAfa1
 xZi9mNnXgP+xDQL0eZfIz641yrgwphIK2vKHJq+DoAtDvElmNRgDbJUWiJ8LyL9xqUM2UWFY7Qyui
 tvbHWEmImnVRF7P5yMfrv6iT3Cq0iPs429cZILRmpjqQ1A5wLRB6v5agc1vr3+sykUaLRIBEx/Esx
 +L2whSVV5Udt9aHJm3N6VtcagVQ4jfmDqHnMwZyb9ChnAcwzA/ZypVRwhIc2odkVgg/54WmJlHYVp
 s6rib0l0pjoJtsNxoS/ADbx9+kWTDEWWDVpseZqy/qnwy7fqLCYKD3ouvwlL9wYpZg4OadMvweV7k
 BfVKIhsg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:19 +0200
Message-id: <20220409045043.23593-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 spamscore=0 clxscore=253 priorityscore=90 mlxlogscore=903
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090027
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 03/27] target: fix discard alignment on	partitions
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
X-ServerName: localhost
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: SuQy5SWNTzA1jR648UAGHqoVprmgOpNN
X-Proofpoint-GUID: SuQy5SWNTzA1jR648UAGHqoVprmgOpNN
Reporting-Meta:
 AAEDfTdSz7uUc3yhbhpi8Ql6/SZ+3/L4srFd+Xm4mxfrsQB/DB/A+TBF5SyJIID3
 +21gqJZx8XS/zlOZvf2nDzu7Y3oqJPdHm+IltPIictysienD/wjfa5zwdBgkfMJj
 R+FTEjByl6uAa4HNny/PkHd88EAm68NX4/5kHN3AqHcgKL6u777sRl9vT3MXlHOC
 GVryBeUwmrWN5s8P2/YyhlxavHE9pGoab6f5S74O1IGcPLR+3uQHwpmTuy0axTL3
 kCa/kUjwrJHS8Oyc/fjjp3420GP0CDBciNfnr8c6YSVF9pKcFd0fy58h1EJCKlvt
 buH7L2I20c2KwtSBAvPT+C2aGrQfsmBV0yC0nluFRWqJK3td87JwvLPv372GyZME
 PwPlNfnLoTYj2FNMwClffQ4/+T1opWeudWg2dqVrWkpaat9/LyEx4a0CJl0Qf1iU
 MSShGqJeS5XRvcZUTJx9EHqlTWeFMqy2NykM9AHu9mk5Z1TMLgx6RIyRiXsFh6cI
 Ug5FOBl79zDkYfjsrrj50PlirCVWm7FvkQXmwt5D3x5Z

Use the proper bdev_discard_alignment helper that accounts for partition
offsets.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/target/target_core_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 3a1ec705cd80b..16e775bcf4a7c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -849,8 +849,8 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 	 */
 	attrib->max_unmap_block_desc_count = 1;
 	attrib->unmap_granularity = q->limits.discard_granularity / block_size;
-	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
-								block_size;
+	attrib->unmap_granularity_alignment =
+		bdev_discard_alignment(bdev) / block_size;
 	return true;
 }
 EXPORT_SYMBOL(target_configure_unmap_from_queue);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
