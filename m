Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A43E7C38159
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/nnevV28uqXGAfRh8qUcYVWDlEUf1pu6z8ylA6A/r58=;
 b=h02MskoiB7Suk1t4GFFSgpq2VtIdQ+L3ATX92eV0ULTDynHlG3XhiPhfaq59LJX+btDE6JlQEzoW
   g6LqN/yhW8JZPzRYQISHrIhIK84I9hHF68Q85AdYDusoI40PNHz6ht31sETAynYH3j921TZAag1M
   Q2pUro847O8LUeP0qWNHPMbKtZXe2IUGS+Ld9oigXhf8uo0fDvlEUMavHMesKrUnIBR3jOlEpzJt
   55qod6roKQMYPB7oFaiRQOxf10hJ9FzvJw8OOsoedelqANM5Q+PYxIC05jnpcJSjZAA+qD7Rj7HP
   BnffWUpypOCUA9cd+FP6LIPTfim8LWJtGdHySQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/nnevV28uqXGAfRh8qUcYVWDlEUf1pu6z8ylA6A/r58=;
 b=C3RRqg/EAtx97A8sLe93IdQVBy2BtlRIDvNCp3sSWcfmD6QAKIaSt36rvqt4GGHvH/+Mi7A8HEh5
   2SQs2zIlGo4pMqcMwAVV36g+mh7tboYsr73jMUepjYP7TOIDm6AmkZOtTJmiTVzR3+t6zgf2wdbg
   pSl7rbX0c6Yv6GlHdF0gw2U+DjNHDWzyrk12HIto+WN2IShAITlxEeXLeGNTbILSS+wqVwdc/VO5
   GQPNSzNAEdv4KuBM43a7E+mTd+Aa3XIlcun3WanDQ9KjCmyjbd3mVgp2SdRBuZP3T9p+UDSmy3Mr
   VO1RIxQ1vYAg34K158pcSeBv7xbIJEBtwIlMiA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROO000NIZBSX800@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 17:31:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=tKKUPVUCc1vcjlD9WoFla6fgqGJV6pEZLd5u8wPj4kY=; b=W2RLJZtWjZmHv9sTcMQH48sXB/
 JAHhsX1mtELnQxarHrPAvgoQZ/CtP7dC4EJQcW5jwgduy+PTzAUSNbidoYL2CCsx4T1g1EAJE/+bs
 vhnZKih4QVXkR3XHuN5lyqL9REaBX/aSqtuhPh7kUikPHUQSqk50bv2C91GV+3pL4e5EPgQPuqfGM
 pePNW2rboF5ElpEixHLdm7XU5CHV01F9sUldqJXn5K7Nv9ej49ndyAZCfNKB0q8VSicGkqQb451Od
 Ze44hQEf2g3VOFwBvBXQ09WyfI81/CGsglkNf9S7mTE8p+XuujCBqktlBUATnjwIbxC5ygo51PCNK
 sJk88oBQ==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Wed, 18 Jan 2023 18:30:21 +0100
Message-id: <20230118173027.294869-2-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230118173027.294869-1-hch@lst.de>
References: <20230118173027.294869-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 spamscore=0 clxscore=228 impostorscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=961 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180148
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/7] minix: move releasing pages into unlink	and
 rename
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
X-Proofpoint-GUID: OqKAFXngYY062DGM7vDe3VIpWkUoF0hI
X-Proofpoint-ORIG-GUID: OqKAFXngYY062DGM7vDe3VIpWkUoF0hI
Reporting-Meta:
 AAE+dGnifyFQevO6hhcIWzZGak3w4ND8gWVRB/J4JbhQ8Odr0c8/u5sfVKLqY0Lc
 8FzkAp0JANTLOKo0Px3P4CGru75SXHZs/nPc1a3ut0Z+dxXCC1naRRZTwbeRwa0V
 VxEXZvEl2y8kpDFQT2TKEEEP2UdMzec5WoS8Of7vBxh300GU63ST6r0FGetuPT4+
 tDj/RGe7vnJEIvt62Exjz/WXti6QP8Z2D49yrQpUNAU6saBtXukUBrgPh8VPcVY7
 1tkFF65rTPrPD6Zr07lbZW/P0pgEATrUkqKgFwIPcF57+3dsT3SQHATD8qpRQFpb
 LJzUKy/3siBE35hWUmzS1svJMnJ7mtonhhcScDd14V8K8moU4mIvgWp+c+jYTxmy
 eounkzlKmzkdVTQAxuUC33552ySQKtFITnIBiCJsVsrWPcImOqRx/QHP7x2xbjVg
 sSJuQ2uqIujvJJot6fDDcz0K/nl0PLw7oJ2PrxxcEYzVRzDNz8Li6+gbe2m+jC5D
 ZZexni1voBdyEz7tcZq7BJ5e46fGoeuEVfiJMx0N81I=

Instead of consuming the page reference and kmap in the low-level
minix_delete_entry and minix_set_link helpers, do it in the callers
where that code can be shared with the error cleanup path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/minix/dir.c   |  2 --
 fs/minix/namei.c | 19 ++++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index dcfe5b25378b54..ec462330e749af 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -306,7 +306,6 @@ int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
 	} else {
 		unlock_page(page);
 	}
-	dir_put_page(page);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
 	return err;
@@ -430,7 +429,6 @@ void minix_set_link(struct minix_dir_entry *de, struct page *page,
 	} else {
 		unlock_page(page);
 	}
-	dir_put_page(page);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
 }
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 8afdc408ca4fd5..5fc696e032c543 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -150,23 +150,23 @@ static int minix_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 
 static int minix_unlink(struct inode * dir, struct dentry *dentry)
 {
-	int err = -ENOENT;
 	struct inode * inode = d_inode(dentry);
 	struct page * page;
 	struct minix_dir_entry * de;
+	int err;
 
 	de = minix_find_entry(dentry, &page);
 	if (!de)
-		goto end_unlink;
-
+		return -ENOENT;
 	err = minix_delete_entry(de, page);
-	if (err)
-		goto end_unlink;
+	kunmap(page);
+	put_page(page);
 
+	if (err)
+		return err;
 	inode->i_ctime = dir->i_ctime;
 	inode_dec_link_count(inode);
-end_unlink:
-	return err;
+	return 0;
 }
 
 static int minix_rmdir(struct inode * dir, struct dentry *dentry)
@@ -223,7 +223,10 @@ static int minix_rename(struct user_namespace *mnt_userns,
 		new_de = minix_find_entry(new_dentry, &new_page);
 		if (!new_de)
 			goto out_dir;
+		err = 0;
 		minix_set_link(new_de, new_page, old_inode);
+		kunmap(new_page);
+		put_page(new_page);
 		new_inode->i_ctime = current_time(new_inode);
 		if (dir_de)
 			drop_nlink(new_inode);
@@ -243,8 +246,6 @@ static int minix_rename(struct user_namespace *mnt_userns,
 		minix_set_link(dir_de, dir_page, new_dir);
 		inode_dec_link_count(old_dir);
 	}
-	return 0;
-
 out_dir:
 	if (dir_de) {
 		kunmap(dir_page);
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
