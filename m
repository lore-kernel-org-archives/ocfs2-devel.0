Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F12BC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Jul 2022 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=x/vZcs709RwJZjgFeRQEjlxQHiwO3ONmSTnEx4E9JpU=;
 b=sOBXhQ9Bp5GjBuJTdnEfVZoqDB/ThaeF9LPSKmp5gUscvc4BF+CfWEnOGmTyJ7KOfTp19oNZ24iL
   cgXGXXJoaW7BrxHp6V4mwGNG7mB8/oNyg/JmIqbtlMpDNmxzUciToOYFsE9uvk3mvJCGBs0r4RYs
   /qP4blLYGycXcgffNOX0miIjn18DjndWMFSSF6zZBakIku5+r5EyPCRGsCWTm0wrWwtOLwt3hAMG
   Exl+vxopRF98o7rHp+GDXwKOzrnNSzCFXeRQIj7gOHteIqT22KCO/3BeVK2RU3HQ/w4SPD0EBhIF
   mly9wXnCKyludoLE7A4sFguJCw9FsNZ/PnnT+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=x/vZcs709RwJZjgFeRQEjlxQHiwO3ONmSTnEx4E9JpU=;
 b=PVldNKY+BpsQPKiYkrHcLnaikY5z5TD0DZovw30VCu02b7HasNWZEzDgo/wQgf5Ii86FtZ8rwFlU
   E+ZQ8mUzLalsnFpMgtAk1Zb3Ds1CS/LXIDgYpDowci5mA93/1Kwgkn5OYG3WaPOnTrPdHuHBdvq1
   GutcmU3Rg2/kLllC2+N2NrQOVVhBPuM0/XRcvtbV4MS7QHq+5LgqrHwSmDVOaAR4S5PXbLVzOKbq
   R4Ibd26OWPBs3EoyvKkzTRX09PiR/A44UB6I/Y2W2IMHOMk3wDUjeNTvDtlUc3ZxJTz1tbeBuHkc
   v7i48G+RchKWEeaomDsJYcPoi9xsU28MWn7l4w==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFE00FIU1VKKF70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 21 Jul 2022 20:50:08 +0000 (GMT)
To: akpm@linux-foundation.org, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 21 Jul 2022 22:49:48 +0200
Message-id:
 <4d4a6786e8ad522bfad6d2401b7f6634f8af0e5d.1658436259.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-reply-to: <cover.1658436259.git.christophe.jaillet@wanadoo.fr>
References: <cover.1658436259.git.christophe.jaillet@wanadoo.fr>
MIME-version: 1.0
X-Source-IP: 80.12.242.130
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10415
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 impostorscore=0 clxscore=92 bulkscore=0 lowpriorityscore=0 mlxlogscore=721
 suspectscore=0 priorityscore=165 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210084
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2 3/3] ocfs2: Fix a typo in a comment
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
From: Christophe JAILLET via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ME-Helo: pop-os.home
X-ME-Auth:
 YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 21 Jul 2022 22:49:55 +0200
X-ME-IP: 90.11.190.129
X-ServerName: smtp08.smtpout.orange.fr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf_gp.wanadoo.fr
 include:spf.email-control.orange-business.com include:_spf_gpf.wanadoo.fr
 include:_spf_other.wanadoo.fr ?all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: tDd31BUjDt7FP0EVBd912NASVfKkbf9x
X-Proofpoint-GUID: tDd31BUjDt7FP0EVBd912NASVfKkbf9x
Reporting-Meta:
 AAFMNvPndV+XBZ3PeA7+4q91TRIGQDQi2c8IA5R6lAiF6SK8z22STzoCX5+q1pEM
 Wa8uIKZqQDFc7twyhNcBYgfFo+eqYfipMuoTXbRiOFf5EDBEbWGFhwsuDrcnWAuk
 r1qiDtqHSbEY1z0N+TSJEZZjBQEUocEgDj6Pi0ZM8zsx3ind1PxoCCSiyx7htg6+
 Kd5DsKMm47qBuChTLqap4LBU14zM5g389QOTxDGZXyOfBuyvP0O/iVycwNJwbhV/
 SiA5pBwavK669VAHS2h2dig0hlNvdOVuEfuHHZxORkO45zIkYSz/JV6Rq7uDFBjB
 AGMgfgANG4eW5aaE2TTvfBApLmteiPisWU+iUfK2kpwCqvYt1i25QZgMbJd1EEJE
 04FlaOwInexwTMrG4Oeqm1fFLd9OvWYdoJCRBUi4sFXZ7R0O850TorqXQ50reCgm
 D9fmXeQEvQ0BT5h41qD7NFaWTxid28GDe/pa6jY4bSJDdmC+JOwNFbAIkZqTImtA
 OYxnTTAcymioaI3OmTyTKCp0aePwhCktHXIxvdrALg9i

s/heartbaet/heartbeat

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v1 -> v2
- this patch is new in the serie
---
 fs/ocfs2/heartbeat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index dd29d60af154..22da768e65b7 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -2,7 +2,7 @@
 /*
  * heartbeat.c
  *
- * Register ourselves with the heartbaet service, keep our node maps
+ * Register ourselves with the heartbeat service, keep our node maps
  * up to date, and fire off recovery when needed.
  *
  * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
