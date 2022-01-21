Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2915CC433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Jan 2022 07:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ParqYSB6N6jfaWF5DB27t75YCmXWgBkE+b8K8JNl1zo=;
 b=xUX3rPKdQX5Jciwrmhvg28xkHXunBPfebCp1/dDLKLh1z4wXTUxIhCT7yetY1I5UVMcQhz15olxN
   iKl77qdHCqY1JhLnbCSBKvsdPjYuRyorzjrrRP8MSWF4RpISoOJalq2cWRq72RLs4nMLRGaha51a
   uuUrNcYGLfx8v9ZWodQuEdGZPYbOsQi2kowwJ7WYYkbtM/uA21Mejg48s9VfyBJ4ZdIxgJhbjT+A
   QmHP4mw2INA/ZrDecPrTJn6VzaeKrQPjqqHbZH7PKb/LitjAneVhaGTuplrD8ot9oLHB1FM8TvYo
   BNnxy3fwETgxUoblMBHKQ1piwaJAdBPmXBOSmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ParqYSB6N6jfaWF5DB27t75YCmXWgBkE+b8K8JNl1zo=;
 b=GUugb7GN34gLxwetoXYFFpIMUU5Lgd0IWWM+eTYuSubTdWrI1fidDm0RrnohHJG+YlOB0dJGdo3Y
   V47zKtKLMu1ST9Z3QBGwk8xaZmzcad8unhGer2cxVhR5Y3YOI5FKVzxBD9T5IHE+BXU9jwZ9XKW9
   9QhYeT6v/f2Sm/JRNWBJ7mkzaYZ3p5VxNQjguTAcMkVaoPVQ4KW4pXcI3SoM1Staszr+txScQF3U
   bNToa7U2Ve/7gJkg+W5M6YOGUKqgZ3Yjrsae9/LwvbC1EvVjMyxBkYJ/LBsxsZH1XN4TdiH9fNjZ
   aP+K+tauL5Eh+C5LVpUQ+wMKQBzj7I3WLvf3Sw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R6100MEATCNVK60@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Jan 2022 07:12:23 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
To: akpm@linux-foundation.org, tytso@mit.edu, adilger.kernel@dilger.ca
Date: Fri, 21 Jan 2022 15:12:04 +0800
Message-id: <20220121071205.100648-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-reply-to: <20220121071205.100648-1-joseph.qi@linux.alibaba.com>
References: <20220121071205.100648-1-joseph.qi@linux.alibaba.com>
MIME-version: 1.0
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 clxscore=264
 priorityscore=153 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210046 domainage_hfrom=8317
Cc: linux-ext4@vger.kernel.org, gautham.ananthakrishna@oracle.com,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/2] jbd2: export
	jbd2_journal_[grab|put]_journal_head
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0V2QTsQP_1642749126;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: qmdkCoez5bZ00tGADbh84qWNwcjOVtFC
X-Proofpoint-GUID: qmdkCoez5bZ00tGADbh84qWNwcjOVtFC
Reporting-Meta:
 AAH3HFYnee06EUg+uP6bHbDi0VP4f90L/fzS9LdI6qXLYC1uo507RHeVpXzUDHT6
 1qgkwtztb1nTnpQDT2GYnrm0MOMREw+AtpwoYGfcbIxjaEo7r3DSwvgE1TlqaCr0
 S/dLCMmoU7a9lg0pXTXjzZKJ+qAtiiFKzaUOMtBH8wp9yW5+WeEcgtjVR6QXO7b0
 cNNcPsS0d0zrnQ1D/LG/xkHphx/WBhIAPl3P+frkd2LVNYHvmPvvLhKTFzQaregU
 1i7DUEj9auBmSvGDD6q82rON6A4uOBXQ8xhzFKQgM8j20yu2DL+Fu9ttiwcoG37F
 s2zAwjCHA5kzsDpsz30dPG9NQRc6DqBmrDftt1wcg6h3YtRulbJAln7425WsrLwr
 nc/vHCX0JsR18tp1Q7fS0wjoCg9ImUbMtlfhuzZROix6fTDnLoMQthRvMMeY94Y0
 zBGu8nHojBdzY8gKDX89cs6YVHmVhcCwuAviz3NFArZi2vuFoOuRAs+OGKD0j7Vu
 jYzlhKpnAOIJNLWqz5ew/iNWHEIZS029gbzxVFWaCzE=

This exports symbols jbd2_journal_[grab|put]_journal_head, which will be
used outside modules, e.g. ocfs2.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/jbd2/journal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0b86a4365b66..e9f0c72f6664 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2972,6 +2972,7 @@ struct journal_head *jbd2_journal_grab_journal_head(struct buffer_head *bh)
 	jbd_unlock_bh_journal_head(bh);
 	return jh;
 }
+EXPORT_SYMBOL(jbd2_journal_grab_journal_head);
 
 static void __journal_remove_journal_head(struct buffer_head *bh)
 {
@@ -3024,6 +3025,7 @@ void jbd2_journal_put_journal_head(struct journal_head *jh)
 		jbd_unlock_bh_journal_head(bh);
 	}
 }
+EXPORT_SYMBOL(jbd2_journal_put_journal_head);
 
 /*
  * Initialize jbd inode head
-- 
2.19.1.6.gb485710b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
