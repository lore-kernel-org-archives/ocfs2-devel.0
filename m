Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE11BC001B1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 28 Jun 2023 00:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VTNZK6X8nrtXGNGPVt7lNuTYMU7t9fP4gZashOFCvCU=;
 b=r5u5//oVsY1UlTgEehernpt0gFq1xljd9vLEX+Jc/54r2UgXFrg5wK9YazXg8AAWNYLlKOO9eh2p
   0KxO4u9wIn49JO1TZOiF+HDW5nJdFAs2qXjy9Xfcz64PEkQRI+zX4ZyRBqiEpN7/j34gYKShKnf5
   7n9QLymTOf6VnmCxcSWNoPyJlZSb2c3DlNz4C9gIWljwiysrSGgeUg8aJX51Fgt37llqljwTzb3H
   WesS4dkOAddnmG1tmepTbXYI/cEsa5gLkAB1P/pBijgXJVqqGfS3YSPCkvo4GgEOsYd4FTFrNjSX
   AX2vw+b2LrPC65dw1gF2ofqB1qUulrLSuELbdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VTNZK6X8nrtXGNGPVt7lNuTYMU7t9fP4gZashOFCvCU=;
 b=Waf1aWXB/wfjp1x+qJgcGPjkjgw+VlTsxJFjIHLOsMtB9dzikSN99/4pg+7Ff6JZjHaqoS/e96mX
   3ojR2KbR6gdutm0UlMkHX2DKQkvrpTVV5WbwkWmhZ8EAjTU7G4ZAqZpwIUOLQKa24CR6JbCd/PH2
   lOSm6Sh1aky/kJKN2cn3zBSOxb08Id0HrPVW38kHKr4BYQtGvmU7AVLD3pp516vAWrAzPomP7RTU
   +HlTCXDD6TeRHW0NsrZjJOHlMEppYklZx73H6sFUA3eqoxoaL/oIxeaB2gkIhjh455jN8gEABpps
   DkwrMpqB5PBjT6q2754u4LQX+ZvPalnABwPUfQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWX000D2UANYM50@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 28 Jun 2023 00:49:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20221208;
 t=1687847243; x=1690439243;
 h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to; bh=/No3uMDFRGop5NHj4Uit0dWC5kLwd6BWdmA86KFwVss=;
 b=gPZG04892ZDpvv2WoVXfZ73z3MgOYG66w6V/TweWRVwL+yL9yrr+9ObuMmfDQ8cavP
 yUGU0gMVwQVaMg7L7ZlT/Bs+iywg4wwW8JFBEBFHSZWWpUnKWRzXKPiOjRCdVU05HOuv
 0qWT/uV06b4BbljLkXztkHMq1nhADbPy8mCqQp+heZlX2dAIPHEKWCWHS3gGQOsUoH0c
 0SYISV39tcbiqUyZqj0JtRLdG/kOpGkAiPRppF0KafJ78o74lNr53IQ3AgNMi4c08nAi
 hW5EMNxeBD3SamEieO2i+evqHB7GbSq6bD3BnGKLQIuB8lSwBKQrz+pqXHjH9wn7eAdc a27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1687847243; x=1690439243;
 h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=/No3uMDFRGop5NHj4Uit0dWC5kLwd6BWdmA86KFwVss=;
 b=LFh6InF06LHc1BT2x1bb8ls4WntSekNfsxvpu+PzhPfm6M+SqeIlMEyKY34/3nuQAy
 v8I1ns8ehRy5ipDSuYcha6+4GUqODd3xjPipvf0ys/uj/YwS5GivMMdh7zYE1ensmSMi
 rx95WAjeTWIl6KI+ChpKFwVE59dgqXI0uo/YsmWHwDk+aaw/dzetFNql6IWgqPBK/XEG
 uWc9uzhpVDGRdvogvp9kPKlMllm/zbfi6E/qmpU/pRpkZVKTrsKHVOTyw/O6lv9B1wZ9
 Zfd18diqPzlRbeRU8lJD5sPoaoybsvj/BYbLYta277nxvkFfW/BD4845huXFkMuumZwW N7lw==
X-Gm-Message-State: AC+VfDwTxpmbzu58qvY3PBU5XdETCfr63W6KPLpWRFJevRauKFwlwy62
 5nZQuaddmz6XCsnM/znlDh0=
X-Received: by 2002:a17:903:41c5:b0:1b6:8863:8c9f with SMTP id
 u5-20020a17090341c500b001b688638c9fmr8013968ple.6.1687847243096; Mon,
 26 Jun 2023 23:27:23 -0700 (PDT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Tue, 27 Jun 2023 06:26:47 +0000
Message-id: <20230627062647.16471-1-dg573847474@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Source-IP: 209.85.210.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10753
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=677
 malwarescore=0 adultscore=0 lowpriorityscore=0 priorityscore=359 mlxscore=0
 suspectscore=0 phishscore=0 unknownsenderscore=20 bulkscore=0 impostorscore=0
 clxscore=134 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306270060 domainage_hfrom=10180
Cc: Chengfeng Ye <dg573847474@gmail.com>, ocfs2-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org--thread
Subject: [Ocfs2-devel] [PATCH] fs: ocfs: fix potential deadlock on	&qs->qs_lock
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
From: Chengfeng Ye via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Chengfeng Ye <dg573847474@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ACHHUZ7h9qusA7Moswuv1qhUjx17ttt7aWtVHBoNV69aAZfIDIScJ+8II6NVNjljxxt7FwA0qFF2qg==
X-ServerName: mail-pf1-f173.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: HpOAWrCMGb5YTkLYQJNrBOTu2DUmFSkh
X-Proofpoint-GUID: HpOAWrCMGb5YTkLYQJNrBOTu2DUmFSkh
X-Mailman-Approved-At: Wed, 28 Jun 2023 00:49:34 +0000
Reporting-Meta:
 AAFe19/1LK9Nvr6XY4O0qnKbv7JpvnP+rUcy9mFIivkijrUPPpzWiRJFhV/n5TBz
 bOap0r0tVCzrdbAO9kaC1lhbQ5L0JiTZrJEDLg6J67Nq7IPPl/2eLt1PYuFp3hva
 Jm9I9BvbDJeFEUkHGyjJPjywXSL67aopprkftL4F7+W7t7oqBHUadLFHNotQaHUn
 oF+KC/3R+TNdLW4bHZbbwUfcbP6OhQcEM5imcXXtd1UpOEXMh3i9ocNNI9oKi19M
 d/WkS2qQraYTAWU4u4zB6Kp5psx99opuZa7bWfHm+sqeCRPAeehPPSBNlaVLnJFm
 8cAb+BEqyTFV/ze4Yovwvh/pMvsACyGMtbp4kKiWs+2rr1DttIpS4s4Z0qkKTm2M
 MGm6/wW66HUTlbPHSOP+tq6MQ9ExhTwnY+uVc3C1DlkeFrZDGAEHjsv10s3zCV4y
 4LEfrWyZEoIew55dX1ymfX5zZgxOpVSH4iaDVTXAR6hJ7KX+WMdk/2NC7yole1ba
 8AsuWURRUB+z08orZIPBfIK5hheTU4sFFcMZgaRP803Z

As &qs->qs_lock is also acquired by the timer o2net_idle_timer()
which executes under softirq context, code executing under process
context should disable irq before acquiring the lock, otherwise
deadlock could happen if the process context hold the lock then
preempt by the timer.

Possible deadlock scenario:
o2quo_make_decision (workqueue)
    -> spin_lock(&qs->qs_lock);
        <timer interrupt>
        -> o2net_idle_timer
        -> o2quo_conn_err
        -> spin_lock(&qs->qs_lock); (deadlock here)

This flaw was found using an experimental static analysis tool we are
developing for irq-related deadlock.

The tentative patch fix the potential deadlock by spin_lock_irqsave().

Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
---
 fs/ocfs2/cluster/quorum.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index 189c111bc371..f14313c3e27e 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -92,8 +92,9 @@ static void o2quo_make_decision(struct work_struct *work)
 	int quorum;
 	int lowest_hb, lowest_reachable = 0, fence = 0;
 	struct o2quo_state *qs = &o2quo_state;
+	unsigned long flags;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_irqsave(&qs->qs_lock, flags);
 
 	lowest_hb = find_first_bit(qs->qs_hb_bm, O2NM_MAX_NODES);
 	if (lowest_hb != O2NM_MAX_NODES)
@@ -146,14 +147,14 @@ static void o2quo_make_decision(struct work_struct *work)
 
 out:
 	if (fence) {
-		spin_unlock(&qs->qs_lock);
+		spin_unlock_irqrestore(&qs->qs_lock, flags);
 		o2quo_fence_self();
 	} else {
 		mlog(ML_NOTICE, "not fencing this node, heartbeating: %d, "
 			"connected: %d, lowest: %d (%sreachable)\n",
 			qs->qs_heartbeating, qs->qs_connected, lowest_hb,
 			lowest_reachable ? "" : "un");
-		spin_unlock(&qs->qs_lock);
+		spin_unlock_irqrestore(&qs->qs_lock, flags);
 
 	}
 
-- 
2.17.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
