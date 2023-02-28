Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D995FC64EC7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Feb 2023 04:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u/eyxijvNEcWxWojWZu/YuM/dC4PnZIF+2AqSJvwwyE=;
 b=S8Kx3L+gGjzIoDA2BkIRkIY3IjEy71ruvaaGo9fiDle/WzV89s5PiAwt8X4/W58tyLce4fS1kQRS
   U2jEbwxjl/fjndR/F70rk34bJYBmZrAIIT5wcZVhZaP2CRY3dPdBXUhLgPqnFSB4AvPMrXH68TeJ
   kvX3cP0i7h0z097o6HTjFRM8+jVohDUNo7gWn0xQjBw0KX5S3w5oul+kFjJZ7HP8xnbjbUoqBXLg
   tjtjQ2uQGj4HAuxIzWId2qRVZeeOWWuJV7sj1BP08Xpo5lBA/xpUBH+oyp4AzXiehAFrFfOdUCwf
   n2NIU9ieo2zhCtEgp9uF7sTXcRxBdxBUU9MEoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u/eyxijvNEcWxWojWZu/YuM/dC4PnZIF+2AqSJvwwyE=;
 b=FVEd1Q42JXsSkkKKmEI600w3qXOq+h1t3C12kOYeOxLU99D6SgtaVe4WCj5ktTgxqC5klVanJA0o
   DhyptwupfS4pdUFx1ksOv8Ji1AZnSHNZLv25yy9ugHrAeYYw53HRPyU88vwmQny19W5ZbCe3ij6j
   /UTt/VANTmhicBGMm0/zJYJ5OLDQ0LQvOV8+iKyhrPD7/mjQRBZUasYBOZXbG826VA9junyKmsib
   XRnDZDTt4OfXVulIgjxCwoZAkDFk0zQ56lMMO0is4zIqQ3Ome6GhF2fucuOIA/42cxTEPDv6epnp
   5O/BpJbLtri9GKPsDQiWsliolMw8np/73j6UnQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQR00OLZXOBPS70@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Feb 2023 04:55:23 +0000 (GMT)
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 28 Feb 2023 12:54:59 +0800
Message-id: <20230228045459.13524-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-version: 1.0
X-Source-IP: 115.124.30.99
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10634
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 clxscore=-80 phishscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280035 domainage_hfrom=8720
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
 io-uring@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] io_uring: fix fget leak when fs don't support
	nowait buffered read
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
 TI=SMTPD_---0Vchb1Cz_1677560099;
X-ServerName: out30-99.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: IwXedvgBphFSCPlVcWzZgi0quEOOO0Lj
X-Proofpoint-ORIG-GUID: IwXedvgBphFSCPlVcWzZgi0quEOOO0Lj
Reporting-Meta:
 AAETag+MxRRIQKHtK4SbRqt9/L285dlmuJ0INT5BMixwMnUAqbubufFcSt8FaW/4
 IPdzEt37Ver5ph2CbXZVHy6/aB9abrbACZ2n5uwe5nTsTnnpLcsIPgZe7XjL2E8r
 tN5i5EoHTudrnH84CGOHWBEDeS/omt4Vr/dZKce61pq7mQB23T19JTEryVeyZDCG
 kJ2IZi4yrfOTY9/ru5Uk4qjSOpYE8RklY65rJmPR9hSa9y/NkcUGuuwDXi9HnMLO
 fLWVK2DHM/gCkBGUT1YR9CMX97NOyH9HplKzM454lQUD/H6JvWYa7Dx1FazcDEbQ
 oHQz/MAUebzIsH3qXG3ars1mO0C+bYdbpupe8ZgnBr3TqdRugo9Tx9Z/8gWYuacy
 /wvWNV9wsuftZlm1/hkbsR3KMN1bZMXjOTS4fULq1SL0wTqSYfwL/aYMYqqiNuo8
 oInywajdaUX7FspfjJeDNq+nhfmgm+PVBO7KUjrgndx9ZCJPlwWaXx4zUWUNDeBa
 yOnRmSj5SzD98ZLccYWh2ViLHRAtbfZeTS507R2BlCs=

Heming reported a BUG when using io_uring doing link-cp on ocfs2. [1]

Do the following steps can reproduce this BUG:
mount -t ocfs2 /dev/vdc /mnt/ocfs2
cp testfile /mnt/ocfs2/
./link-cp /mnt/ocfs2/testfile /mnt/ocfs2/testfile.1
umount /mnt/ocfs2

Then umount will fail, and it outputs:
umount: /mnt/ocfs2: target is busy.

While tracing umount, it blames mnt_get_count() not return as expected.
Do a deep investigation for fget()/fput() on related code flow, I've
finally found that fget() leaks since ocfs2 doesn't support nowait
buffered read.

io_issue_sqe
|-io_assign_file  // do fget() first
  |-io_read
  |-io_iter_do_read
    |-ocfs2_file_read_iter  // return -EOPNOTSUPP
  |-kiocb_done
    |-io_rw_done
      |-__io_complete_rw_common  // set REQ_F_REISSUE
    |-io_resubmit_prep
      |-io_req_prep_async  // override req->file, leak happens

This was introduced by commit a196c78b5443 in v5.18. Fix it by don't
re-assign req->file if it has already been assigned.

[1] https://lore.kernel.org/ocfs2-devel/ab580a75-91c8-d68a-3455-40361be1bfa8@linux.alibaba.com/T/#t

Fixes: a196c78b5443 ("io_uring: assign non-fixed early for async work")
Cc: <stable@vger.kernel.org>
Reported-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1df68da89f99..7ad3b8af2a4b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1777,7 +1777,7 @@ int io_req_prep_async(struct io_kiocb *req)
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 
 	/* assign early for deferred execution for non-fixed file */
-	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
+	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE) && !req->file)
 		req->file = io_file_get_normal(req, req->cqe.fd);
 	if (!cdef->prep_async)
 		return 0;
-- 
2.24.4


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
