Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC74C001B0
	for <ocfs2-devel@archiver.kernel.org>; Wed, 28 Jun 2023 00:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VTNZK6X8nrtXGNGPVt7lNuTYMU7t9fP4gZashOFCvCU=;
 b=AYRUkJNgwyC3p3RJXKuYiVMg3jNm44j2P+e0KwKpqjA+dwXhD2NF3CBPJACsOibIr3oyqQJnK7cl
   ii6BNTHfRcmDTmVkMam34nNH5xhlbeXkJRHzJXaeUrHLeTc5Kbo6AymG0e1QM+lZqH9PMpxlCKcb
   O7ktt/7VTiLHlUHRQQcZEfOnBLeyX2mpZpJ2hEAwrRf2rFftks7E8GkfVTJhq6R9T8DIIUKYW2eL
   0mLfmiMs9E7u8l9Get2ElemUw/QQLJgDQW3jh5/OcHMlFzOJtXKe2C1KTd1kbdXVwY/Un6D0EEq6
   1Z4evSP9UrjUf6GptJSZrYzbgJ/ra0OMP8y9Fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VTNZK6X8nrtXGNGPVt7lNuTYMU7t9fP4gZashOFCvCU=;
 b=oDyK0/Big6PCSxNwgd7ji2TMk6ZOK0HG4GpQR97hQKpzkIVg/0eHixcydaQTyvqzVuasjla6xi73
   k8fOHEOeONR7yRox2n7WLb5Ob6Bv8Y4ndvgv//GzMo01TsvB+qXlZ/l5/Mzbokv3WylTGXcKPs6K
   LfPgE7584DqiJIz6hr0dMCm1ohdV8He79DR2B1XiriXDbnSrR/9HmXKBI/uuzRescWp4oNuk3ko2
   qddIUWFr400U3CRc0HqjS1Woqn596cKetpuzwme/gmfuBycsf3R1rw1n8RH0SddIC2fVROFjE0+O
   qpv01DLC1tYqHDsp1nOhD/mGkJcbhfERRZWdZg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWX00AASUANT380@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 28 Jun 2023 00:49:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20221208;
 t=1687847325; x=1690439325;
 h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to; bh=/No3uMDFRGop5NHj4Uit0dWC5kLwd6BWdmA86KFwVss=;
 b=oZ1dTy9QsTF25Vj6cN7VtiP6Zq/WmSPT0V+70JONVbv9m/5XkMZ6mjXPLJA8Z3sZyl
 U7VuKuAHoRDK6l3HNc6IEsi4azUzhglWwBfl9L7jcOMSJPeA//swS0DMK/ziwA+PO6Iu
 bWkHtAK4Vy+oxKBoqpv0h63cpA5OoPksTD1/012Wu/vrG0TVWk19xnpG27RUfzfykqvH
 ZXEa15Q6WNouQEltEV/Fvy408J6FbcpN4xtbE9MYjU9jw/2lSlpfy5R4AcJrijc+y5/J
 80er1QgK8sLvIe5PGtaqGTVORTk2avpGTDK6qqFV7Xc5/qMrw1Gqh+uvpyV+mPp+AC7W QBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1687847325; x=1690439325;
 h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=/No3uMDFRGop5NHj4Uit0dWC5kLwd6BWdmA86KFwVss=;
 b=ROKjPECjJacdhHFvO8oJ/TStET7ewUxxEaih2UtgsJquZYCrJt1p7mLc9Vk5MnJVf1
 N7YJ2e0dJbEEqVpkf/0uyTaSlr14xur+V40Mjn+iKyD/Bbs6NdlfpzP8Vv4Tzujs9IRB
 JQCFdUXTewROaqLHxaOBc3tsgHwInmOrguhdOkCJ3jgGGVh5pz47JHAFj0kjPZzZBSa4
 V8yKzSefWQIpWZLaWQQ4f5AOF506S8xFftzHH3n8ExykIhwrFdAtE6bWOINMEghr0Cx3
 X3cpbEUZGUubT8z4amIAgjGdm8GH5v1AHedPRgfgRjCjenjMz9NcyuPiZTUOJ0n5b5L9 oaAA==
X-Gm-Message-State: AC+VfDxNc3kI/UgYfGy1k4F0Sqp+o8FpLyvEvgU4L6mxFfBrWYgs7nx7
 v888fuF5EHFYcY4OoOVfKhzlZOXah/dbzA==
X-Received: by 2002:a17:902:c946:b0:1b6:7148:f65d with SMTP id
 i6-20020a170902c94600b001b67148f65dmr5128992pla.17.1687847325572; Mon,
 26 Jun 2023 23:28:45 -0700 (PDT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Tue, 27 Jun 2023 06:28:31 +0000
Message-id: <20230627062831.16553-1-dg573847474@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Source-IP: 209.85.214.177
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10753
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=165
 mlxscore=0 unknownsenderscore=20 priorityscore=359 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=677 impostorscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306270060 domainage_hfrom=10180
Cc: Chengfeng Ye <dg573847474@gmail.com>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
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
 ACHHUZ7g637XMAtoJbXRB6S87o2VxjpHWmvVxxMrfQpBcMcRmEaLubMMSIpP32XzwyKQFk84A7x5VQ==
X-ServerName: mail-pl1-f177.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: RPnDecgzUr02wXRckrTo4jBYlE4Sv6ZG
X-Proofpoint-ORIG-GUID: RPnDecgzUr02wXRckrTo4jBYlE4Sv6ZG
X-Mailman-Approved-At: Wed, 28 Jun 2023 00:49:34 +0000
Reporting-Meta:
 AAGKiHd01GWe4sxmU0qQpRfGLRKxa9M1/shxGiK0Yyk1wK0wEK9JtZ3IjOxpWgxX
 MfuO91YgVfwS5d3yCI73hOf+3ataKs8/Y/1E7hKY5N9nuBl5MenwMDWIjIYaKuZW
 FwRz/IC6FmdEq+eQgDGKkbhqxZPBGOKcbdzRdO/h2v5d7MIwA3YG/6aM5NA4Bm4V
 kqSMywqwgyJnJUqjJtd+JssogA8MU3HyhpJtS6r1e7qmbHOm9eWu8KqmFt5jvmXe
 ax991tnYaAMb8nxYV3P5xLM26+YLZYhlFEAWNS/+rYKPwJ1wz//BmlrKyRJJm22/
 o/2Nv99XD5z4+3PD/zn99WpXkM3hmGmnSdAwqVawmd9rgO19fxU3UNCi+geYkpH1
 MU9CVB97merKsMAsw34QBi181TdKKk/4gh69/d/IKhlEJLX9KslZgd3BVgIqR5sO
 UEI1jMvIOf/pnDbcXl/fcodo9oZe9PuQT53eyVsqav5DqMrm5BFc6Uv0mFJDHm2a
 Q2y2Hec7u6hMXo46HOZ1wtVG+404hCcqTY4gAWjhC5fG

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
