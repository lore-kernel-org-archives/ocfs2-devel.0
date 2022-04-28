Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D3EC4332F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 22:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=E+oszXkJLKi3S25aLXFgLdaP8sLon17e2d0mSXTOG0c=;
 b=VWWFy105aq/V7jU8NE/2wABqsdkJGq0Bo5AXSgTWiQyLlkt+4erIXgECBxsKQ/FRFbqa66HDAeOC
   hq13wQd/9wsjUUSAPJtA40x8118KZ5wQzWMzXKf2LR+pS7F7ANo41DLsLdl5mFP9KHcnREt94jEw
   wZ3/4TZoeY8SXsFHORRnjvt+zDS40AuNIWVFvCQBOgpQrac48jTVoPdLB48va7zFicAayRKIxT2u
   0A6w537ZDQSFEfXtzWUKtMQkIiPCxC6XVbZzQbaEAQGsLXv+wt+3ShsDhm7G8w9EsM1Yc72TXspS
   peJmKrP0NLrPk9zjdwP/P84FFoLBVSiY9iFy9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=E+oszXkJLKi3S25aLXFgLdaP8sLon17e2d0mSXTOG0c=;
 b=MehrI1DSdUJKc7+ghGb5enKCB43fUgF/3iB6IyKqNqXADGOjFXoNasUwIVY78JuNq4N4a7rPrAWr
   iYhHevtaqHAs8/Ajje/+3Abm7WvKHYXQN611SrbMbn2lrPlSo7wpNcufHmu+/j8B0z/hM+Ut8nRv
   Zlr/KpqTo/NLRVRvRLkSlr3b2kuBLCga4TJWjfsBLh9+n25KYuZZRBshFsh0bzUEJ7JLWZKvkf9U
   U1/oSbyAQ/D5xLrG5CUnsa0Cw0nzI4sEHkTdRnHekq1nSJswpOuyJwW6g0B1c44tAdQU7Ta2VZlw
   Cc3wfu3sBmStE9KAn2c7wWwP/G3Px1ZRkp5JMA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB20036XL4M9V50@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 22:00:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1651183206; bh=17Qo0HVWD58O2EV0XI9m51w6B+GNIfy3U3iqnPsCRTE=;
 h=Date:To:From:Subject:From;
 b=IlVUq0zY+nRaYmitoIeWiT06MUl894ISOF9eM75RBWlQqzfYpORAJx/ixMrUVD9uX
 JGogGnXDOwVQ0h90VyNT+X5V6oaKJ3CyZnlpO23mUQDPJ98TCbp6XkD4ZWyIIyDw/b
 rOtfdhG9QLDN0nRrm87bHW9tmbFm/kGXbgJFgGAI=
Date: Thu, 28 Apr 2022 15:00:05 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220428220006.06473C385AD@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10331
 signatures=591664
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=178
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 priorityscore=90 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280128
Subject: [Ocfs2-devel] + ocfs2-change-return-type-of-ocfs2_resmap_init.patch
	added to -mm tree
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: ZjVk2kjpOWZUjuMk69Itnf5m3YsfdLG_
X-Proofpoint-ORIG-GUID: ZjVk2kjpOWZUjuMk69Itnf5m3YsfdLG_
Reporting-Meta:
 AAHpHgIcadmojoXXd+vNBaNjaVWoC4RjO5BBpdVAzo6jOYHtfmD3T8kYMGf/aw6l
 UfDCnHsZXDfA3rFIt654saGO9PWp8ohfjfTqFW8yptdGBU119RtD3cMz/ScHH/l4
 r8wO+30l1Gig4NK2N3P1Dk7Fm8Oa+wrW/Uslk+7aXTRDAsvM7Duh/UP1IN869oVR
 ReBflLpxUx5AKEnHCmd1nSe4GugHhlqX2+gvt18ObQ/Yo68unquM20/cO8C0OYT2
 b2ujU+WW0E2Fe4vi2+D7SlbCoxbdhszNHpx3HMc7A4IMGAjPLJ5pww2I8LQDxJ1n
 VeZN4CQtTh4ceNxv/U0tWl0/hlYo3R0Cf0ZfczDITn/PTn9fs3NtabCXpG96cinR
 69zqc+wpfmjvKLUL0a4iruUcMGc7uenkE7i9QlmKgiQnzH/pSMTekZrZdjc++Ri8
 um/c0POWF/SbRNpZlbhZkfGh8oWo9Yc4pMl6MePhZTkY08jIPp0F6XA1d731sakE
 zq1YVq9rxGQ8xyDhwU5hF2VEHrF9zlGHBbXnztz5Trw=


The patch titled
     Subject: ocfs2: change return type of ocfs2_resmap_init
has been added to the -mm tree.  Its filename is
     ocfs2-change-return-type-of-ocfs2_resmap_init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-change-return-type-of-ocfs2_resmap_init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-change-return-type-of-ocfs2_resmap_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: change return type of ocfs2_resmap_init

Since ocfs2_resmap_init() always return 0, change it to void.

Link: https://lkml.kernel.org/r/20220424130952.2436-3-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/reservations.c |    4 +---
 fs/ocfs2/reservations.h |    9 ++-------
 fs/ocfs2/super.c        |    6 +-----
 3 files changed, 4 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/reservations.c~ocfs2-change-return-type-of-ocfs2_resmap_init
+++ a/fs/ocfs2/reservations.c
@@ -198,7 +198,7 @@ void ocfs2_resv_set_type(struct ocfs2_al
 	resv->r_flags |= flags;
 }
 
-int ocfs2_resmap_init(struct ocfs2_super *osb,
+void ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap)
 {
 	memset(resmap, 0, sizeof(*resmap));
@@ -207,8 +207,6 @@ int ocfs2_resmap_init(struct ocfs2_super
 	resmap->m_reservations = RB_ROOT;
 	/* m_bitmap_len is initialized to zero by the above memset. */
 	INIT_LIST_HEAD(&resmap->m_lru);
-
-	return 0;
 }
 
 static void ocfs2_resv_mark_lru(struct ocfs2_reservation_map *resmap,
--- a/fs/ocfs2/reservations.h~ocfs2-change-return-type-of-ocfs2_resmap_init
+++ a/fs/ocfs2/reservations.h
@@ -73,15 +73,10 @@ void ocfs2_resv_discard(struct ocfs2_res
 
 /**
  * ocfs2_resmap_init() - Initialize fields of a reservations bitmap
+ * @osb: struct ocfs2_super to be saved in resmap
  * @resmap: struct ocfs2_reservation_map to initialize
- * @obj: unused for now
- * @ops: unused for now
- * @max_bitmap_bytes: Maximum size of the bitmap (typically blocksize)
- *
- * Only possible return value other than '0' is -ENOMEM for failure to
- * allocation mirror bitmap.
  */
-int ocfs2_resmap_init(struct ocfs2_super *osb,
+void ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap);
 
 /**
--- a/fs/ocfs2/super.c~ocfs2-change-return-type-of-ocfs2_resmap_init
+++ a/fs/ocfs2/super.c
@@ -2110,11 +2110,7 @@ static int ocfs2_initialize_super(struct
 
 	init_waitqueue_head(&osb->osb_mount_event);
 
-	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_resmap_init(osb, &osb->osb_la_resmap);
 
 	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
 	if (!osb->vol_label) {
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
ocfs2-change-return-type-of-ocfs2_resmap_init.patch
ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
