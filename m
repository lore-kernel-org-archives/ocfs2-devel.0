Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812C4C53210
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LRHDQHHyabiNo5WYQJIbvdIF+weHpcIRO6qf29/SB1w=;
 b=pcUuKCsFMnYqP8wKdsKorq2zTMR1viOemmvkSsA0KECzjByRLDMczprSDOxuOQD7iIX0CL0TsaxZ
   kGKf2z3qs4oTEW0PZ8QsBEgWoA3STlrjB5zvOVRLsahKx1/CxIK2y7xCMmJ/GA/e4RcbuxsZ3Hp/
   kXQ2B4Y5EVVFKY42U0Ki7jgjA6lkV6aAUmltYb176xHkVZcbjNDoRNtW4nIMGKM3Uil05SOoGMyr
   eypV3p+3h8oLb/xxdSzQokNC5Ipr8tyvjBmp2EmBgBmt2oR4bp6FYE2oCMQLXqBLBvzuGGLZsreQ
   TfIwDHK1inwlvoKLqkK7AcRHpAiOH6KdHOYh+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LRHDQHHyabiNo5WYQJIbvdIF+weHpcIRO6qf29/SB1w=;
 b=qFcVk1fM/2iDUsoVuO48/Ma6XbZGEw5gv93spjcAG4O5ew71zhrkjdWopILbrLV5y8Lioym3hWfd
   dyzBjfI0lfLRE1vm+6DRQ1jAluNFAYNQeX4PnFt0kyVvqn3990F1qhwSgifzvwq638gzGsrGD7dV
   0YYodrFBhhTj1oT3Th55VCaAEP1ZAeBxIVKnhgSnBH3lwoF4e/avUPn85V+h6WEmnKnW9v8Nb6SF
   /xkt8O6nrFVEE2SqFcU1303NqhW/h8gId0oP8kTcOh1K6ZR22i4kCN3u/kp1N3Kzvo1pp2PotKag
   gJyVSN4kA0SMxc3Bcw0SvTEHnozNoWQJfb16bg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNN007DKUAULLB0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 29 Dec 2022 16:11:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=/OSTms68IPUXcD9mOyJwWhvTFEvxpirJZnFVgrc7HRI=; b=mG3Xd47oTUQecGZV2lFfDakfTy
 v9T6b0WubaweFmczUE/fgvx9Ej4TE34uR+iCTgXqcWAZEtr4nOwjmIu7RgbAexm9fF0FQQClyljLk
 26JoH5gI1K+5QiVdrRypcrfvoceq4NJW/JTha943AxPSp195deUacqWMuM6Hw4hLbyFsR5+6RgEUA
 Fn1sHTGv69ttZMtXYF7gIJkwL61CE3QVKLKPdS29QXQgMpfIwoP5p45q41XYs+lhHGRJDhPj5r0sc
 mLVdGFgskkvDGn9spGCbLcJnva/V2khDSMNj+mzAJRxEDup9kUduZRBnmm9ZYAUWooRXugVtUAP2G
 kI54fxzg==;
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Jan Kara <jack@suse.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Thu, 29 Dec 2022 06:10:30 -1000
Message-id: <20221229161031.391878-6-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20221229161031.391878-1-hch@lst.de>
References: <20221229161031.391878-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10575
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 malwarescore=0 adultscore=0 priorityscore=0 mlxlogscore=658 clxscore=290
 phishscore=0 mlxscore=0 suspectscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290134
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, ntfs3@lists.linux.dev
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2: use filemap_fdatawrite_wbc instead	of
 generic_writepages
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
X-Proofpoint-GUID: ylolPSY89h4pZeG7YneEdmhI75KZRG3A
X-Proofpoint-ORIG-GUID: ylolPSY89h4pZeG7YneEdmhI75KZRG3A
Reporting-Meta:
 AAEM73KeuUriWhjOM4eR9M47NaGqQERRv3XC96Z3qLKWSziNQ0LxZW9496A3P7M0
 avf47oBkNO+009jH2Z3O2rC9aWNl3Tmq6Y6oKfSWMC5cDcf5GwKWSHdCJuH6aUBZ
 zgJwyzSn4ejNPDimK5LL9EHObo4RbKgTothwIQtJp2ZZu8o7vDrBhiVgUZYny4iQ
 eDui3lFY2LPnJHM1ZvjZoyic4aMcBgpA6qqMfmY7vGpBiHucEZ1ak8Ffy4i4kHJV
 df4fMQreLfPjikarIyJRQcwzre9ySsvG51GpNF9bjJRbDGasm1EjRhS5bvXXOLTr
 suT69ZvZ+Zn9SDL0YkHaQXrLAtvq26sqMZ2kbD9lbw7YgNWOVj8EKpyau9Iba2Wt
 ImVXuz0w/2pCfs3fKiJI7m9+INkonZWCMy3K1Jr+6ZHi8Y9s/E+f8+7dAv4p2mF4
 P3M2kIs2iwTH27AUFl1GskVVI/CCVPERO1IYh7O0offEUupzg8/umXrxuccuGfF8
 A0zN6QXg1ND8yWjw4S5ZwJazzl0tMUKuD7PRlUebIETE

filemap_fdatawrite_wbc is a fairly thing wrapper around do_writepages,
and the big difference there is support for cgroup writeback, which
is not supported by ocfs2, and the potential to use ->writepages instead
of ->writepage, which ocfs2 does not currently implement but eventually
should.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 59f612684c5178..25d8072ccfce46 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -852,7 +852,7 @@ static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
 		.range_end = jinode->i_dirty_end,
 	};
 
-	return generic_writepages(mapping, &wbc);
+	return filemap_fdatawrite_wbc(mapping, &wbc);
 }
 
 int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
