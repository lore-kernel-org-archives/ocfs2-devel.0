Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA43AC4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 25 Nov 2022 09:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NbMXw20nYpgqEXg+loDc1EPXI5bKUkkLFSfdPXM8ylI=;
 b=PaAAtJk9tLRTFRWKRZNUfhrjQbYpwz1sqGABziQzUIlAAl5GDrEQX7h1FSfnxvH/zxtQ9fc0KwZW
   aCOoduvaqpbU+jPcga9rS/XBC2rC6+I6SiILdwbXjvI8BoCiiCE5XWRD9yVFJde9YwT3BcP/6eLZ
   ndC+3L3ShzCn/L8bMzRGwI1hm02aADgnNG4i4fW2Hvv+RKJvAxYwsv/IBtgJLoaUB6moFZ4QW+oW
   oxYzS3WqFBeHRB7GnDOZ0++EuEq9NOMFnkHRSprn5FvRJliuBkougF3mqaX78F9FKvmHwJsKROFO
   O0FqkwwPkhRk7uoHowrEXq8MgnLnT6OgZCxizg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NbMXw20nYpgqEXg+loDc1EPXI5bKUkkLFSfdPXM8ylI=;
 b=eph0oXJtBdr+JbFFGwJqliPbwdDOdvwRUwZW+oqcJyUfVUq1wXA/hL9sh/1V5yesvgaZSMJGnwp6
   bXiHmgLk4fQk/c771+rWsKzzL0+7hWl3jvPGvSVFo02xEmb7Hl5lTkwadDYEuey2mhkLJkA+z08L
   IV5MAWZWI7d5EUDyXPsguOKGrj28Tb/357vssjt34frfip9CQJagXFJ4298YwDdPIsu5fWFoVs24
   UDkaYjEcZVbcCO8xrHoANAS4l1Mrn+OnUagrAMroqp3aU68JQAyhNQqy6Mppaw6zbShe+A8SMjbf
   kFImo3FKzE08roKzYDIICJB2OzmtjGtPo8LCgw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLW004UHC9L4I80@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 25 Nov 2022 09:12:57 +0000 (GMT)
To: <mark@fasheh.com>, <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>
Date: Fri, 25 Nov 2022 11:15:22 +0800
Message-id: <20221125031522.339-1-lihongweizz@inspur.com>
X-Mailer: git-send-email 2.17.1
MIME-version: 1.0
X-Originating-IP: [10.93.221.219]
X-Complaints-to: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Source-IP: 210.51.61.248
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10541
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 phishscore=0 mlxlogscore=519 priorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 bulkscore=0 clxscore=424 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250023
Cc: Rock Li <lihongweizz@inspur.com>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: properly clean task pointer before	o2hb
 thread exits abnormally
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
From: lihongweizz via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: lihongweizz <lihongweizz@inspur.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Abuse-Reports-To: service@corp-email.com
X-ServerName: ssh248.corpemail.net
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.corp-email.com
 include:spfb.corp-email.com ~all
X-Spam: Clean
X-Proofpoint-GUID: t-S_ba1-iBTGQy4irybOox8ABDsR4eJf
X-Proofpoint-ORIG-GUID: t-S_ba1-iBTGQy4irybOox8ABDsR4eJf
Reporting-Meta:
 AAH1DpIg+8CQWFyhjRFdBdvlxxGMZ7H8NZ1UHbDdGm89XqYBtgCkObcGNVOjWTfP
 vOzSFY5I1RZ1+mkA/Ac4WGJuNIOTAqOBhLhjgZDcGF/xc1gH4RjFC7+HHUi5vTKq
 tXbQpBJapeaC2xCFjItBWcFgbvPMAJSkZhGTXe8Jg5GNn/wXjzMqZWD+SBh6k/BU
 XcmRLQgAdS6YC8xqhq/X2GnAolSdBR1XnzrNSk8lNydKGYLWfzJli/1gW1kdoAho
 T7zZPReTb8KBVLPv1zlC5kJEkkpUQ38zp/tsCtyQMLDhFQOEGScu+3FSU9UkH3/z
 jMjKXhAonRd47MYFV7uXDAAWKHMBN9YQ92WCHnROGLRJaJNjy9nCu5ZGfnF7sED+
 zr2oivoX+AKx2en0GnJ+dGq+1WgKhp56MTUEfGGSx4WeoV52GhJcPYn41K6ZAG0l
 Nl9wPYa+wAd7BiBofHsLBtESXOKGZ+On+4K5LudtJlnHyOTSHVHFgOnVoWSwDjWK
 eWYgDIHu8VelffetRpFaQEEwDsKKvS7sQotDx+Vr0pc=
tUid: 2022112511153408350572528650079766ee080579aa08
Abuse-Reports-To: service@corp-email.com

From: Rock Li <lihongweizz@inspur.com>

in case o2hb thread exits abnormally before stop o2cb service,
heartbeat_drop_group_item will try to stop a noexit thread cause
ret->hb_task was not clear properly.

Signed-off-by: Rock Li <lihongweizz@inspur.com>
---
 fs/ocfs2/cluster/heartbeat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b13d344..9db448d 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1258,6 +1258,8 @@ static int o2hb_thread(void *data)
 	/* Unpin node */
 	o2nm_undepend_this_node();
 
+	reg->hr_task = NULL;
+
 	mlog(ML_HEARTBEAT|ML_KTHREAD, "o2hb thread exiting\n");
 
 	return 0;
-- 
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
