Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5493CC43217
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 May 2022 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WN0BvCGlJoHZOrOSIoFSIF6BKq+ck9vrwLYYTwAbnvg=;
 b=Rh0mARhsKqoczK+8F8jaQDFu3DxiyOs4NgNxYRNWMFWkVsasJd6UxGDdCLKGxt6r+UKH0wqrf7T4
   SqYFD/CmEezkOI5z5Kwik8Z3nHa9Q74phyLUFXqkjSuEg4utt4JDnh0zoZSvH6PGZCN9U57Y7kMZ
   4Qh4FA05iPLcESKo5vo44s8JoMFTNFhWyZelF58btkksSDZ0PvaK6R0Nx2IShOnlmF0v3L3r24JD
   99Bs4pfz4RNWYW7zAxREk7ebILTat9ihvJgbltKIxcGRRbWUFP7zUZCx2wSt5hZ047LqBM8GJOOR
   XLnbYgp90NfQg7HArrbmHba/2IUN2pOgaVgLzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WN0BvCGlJoHZOrOSIoFSIF6BKq+ck9vrwLYYTwAbnvg=;
 b=f199V/H8vYows1Hnyn4wH4Y9Pf6UJPLIjDilUHbu3W1HPCdMxbxhbM5tUnn/gSJ3oyWOeZ/4HFnS
   V9IjPXUIQFjyVmknbIIBNx/cvfh2aFjhp3OGlQ6pGSU9aaTPrule7g/5o/PQTDRoJg2OAgo2eyS/
   moJiePut6TJDUZmfeQAy+B36uq0TIUhcQdscT8UeosfSjcWGELcMrBPZSHDjCUgxbgjtSm/TKrQY
   kfbTlnxbCahGW6jw5jDRN1hfnY+LlxD3+t2ZgKR4itXlX2JcUeiPwUt8eNaj0+lNZo0Q/zl88MPu
   idmyNr3/oF8TmLHy4+ECJpDZM4SYd21ntN7Apw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBN005T6FXLEU30@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 May 2022 04:17:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1652156249; bh=dP2lJ1Oc0PcGwbTw586E3fKdDqtMl4sEyv/hYld23g0=;
 h=Date:To:From:Subject:From;
 b=bIdUaZ2aBG/CeKTN8MH78ellDjUQ31JKeFOTUBPZT/vhXGj2GnXUxbD6di/yvdvZg
 jSeFJslojIAqO3FS8Ofcec6PHVilP6CzkEzoYVhOS74kazHiPJKRbGBt/2qeRVKaj8
 Wg+YBJh5OnBAzFGSxhc1C2nAnmU41EjGmI+GUYbQ=
Date: Mon, 09 May 2022 21:17:28 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220510041729.20B0CC385A6@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10342
 signatures=593155
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 impostorscore=0 clxscore=193 mlxscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999
 priorityscore=266 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100018
Subject: [Ocfs2-devel] [merged mm-nonmm-stable]
	ocfs2-change-return-type-of-ocfs2_resmap_init.patch removed	from -mm tree
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: yo6QIOcxvlKI06o6hQJK44gXSDyt2ubg
X-Proofpoint-GUID: yo6QIOcxvlKI06o6hQJK44gXSDyt2ubg
Reporting-Meta:
 AAEjfAPnyEDj2KXOzSi2iIHaMYn3dNy/sYP6hPrrQzWyMlDQio9RaOktxw9Gy0ZY
 T4yp3tPnOlg6w6SG3MUCa15e02gBWT4F0gvJMZN9WXkcEDeIct4EawXJ5HDLbAej
 GU3TJPGfX7NEV0NqOnb5lrgOpql/TnHEle19X0iX+eLqjQAe9OScFlqOq/luE0i1
 JTkq0BuqUJelS4XmemT9vwuplNukFZpnF4pIbYSIxIijbn6KMfyuoLUkk+aMB8I0
 GeVsrqL7uwLlcX/lva0hIQsHmLlzFKFaQj1Ulprzv7Qm+sR7XtDcpdckN3xe1+OQ
 xKzYhtb4cgdnHbhitQjLEu3Z8O4jOT5Sh5hUikl+eVCkCjr2ql/+Gn7HDFNlDyQE
 kV96OMZ0G8GPTwUQqsinmDKZnE+bcJocJ9cTm4IeLOsWt/n7gKqq3v3TDKY/YNYq
 5RBE9REga1HKi0yHnkKrPmbM+7j9b/gqVgKO9a790vUbTnPgqX+nqFtzZx1TAfcp
 deU4dZ+LOjp0Vgg0oxSJdSd5Cmat5khRvOcVEdijxxA=


The quilt patch titled
     Subject: ocfs2: change return type of ocfs2_resmap_init
has been removed from the -mm tree.  Its filename was
     ocfs2-change-return-type-of-ocfs2_resmap_init.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
