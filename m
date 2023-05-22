Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB4CC7EE2F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GRCud5S+bzuOx9U1ZuzXkaoYh/7t1n0du7fRNTkR07o=;
 b=gpsgsP3CmKWx/cuGTA5Rimd8lALWxkmFsc96M5DTOiBdDfbOsk8BjTLavW2j+K7EsvMb4a8OjMVi
   k1ywZZyGYuELo5KokcT6AhJLiFd/rEiWCDNDCb5XpYTRnRNO36+Efh6isUAFO4hjFcDZcXkwczPu
   s806YXX9Ugr7JHK2Z1lu8vKRLReaQ5O4/0bNVQcIc63q9Sguco26gTrfq4XEh9Gb9VHR4HUIOlEA
   9vm7cvakJGnj5ynWlyJmGDcD7YOHN4vBXgII0IO82p6a2hYCHPEc1QPmjN/WPGc8nuBInbfrbZEt
   GicmLSJyPIHGHOYboX5vsa8Xh+B/aq0qmogqKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GRCud5S+bzuOx9U1ZuzXkaoYh/7t1n0du7fRNTkR07o=;
 b=WV9yWbuZ27LOgg6jITOrwbnVpIWxp2L24SxkDvPFqGucHu9lFCahi46QD6/5k+HHPxMQNIeclAyz
   qfuaVQCj8XumNJ8kIxaavhPI01RVZUOM6dPZIy+p4Ox0DotJirOQ4I5Axu0rjWBj95HaKZa+T7pH
   PuP9CGw1X2I1vSCaimvidAUNT7KubGfDZbM88FDKBok8Indp9YSPXfLgcUISfUvs6WNNjo557yuk
   7Ql4rc/Ujjs4uKVrsOoWP8hkDvc4AW3Q1YV92q1oDfmr97eVS3OactHm+9D1qB5NF8hFgTQCSR4y
   VLz+W+Jt2P/s/8hygI4+QG8+iNRWF7cs1kB04w==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV2001QJJ244XD0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 16:27:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1684751103;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=UWemZErlloMTCdVWorQ4/wn7rdudTuYoPoEblvyctGQ=;
 b=QQTjL4QDyHtniL9u0v5PF8UzTIRq7/2LV3NUcAlGu/utAasoDij+m+nFVURh1xBnqorVd8
 ysZmNiYmRm9FS1NmCKPmtC3YG6qH2l+dNyEepXb+jjVvN93Sb/G9X2TvM0Kz87glOyh3iy
 HYwTSyTpxMk2fpUNei4hWJ7dVdxif5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1684751103;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=UWemZErlloMTCdVWorQ4/wn7rdudTuYoPoEblvyctGQ=;
 b=wKRzbRx5iZD1HrstnU5oYyYMA/Ubp7dh32DxMCfkugTTSs1Zldo3NqmRwC7Vs/W4c6Flok
 P4Dku6mur3JKrECw==
Date: Mon, 22 May 2023 11:24:34 +0100
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <ZGtC4rS4hoASgag5@suse.de>
MIME-version: 1.0
Content-disposition: inline
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 priorityscore=30 malwarescore=0 adultscore=0 mlxlogscore=842 clxscore=66
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220088
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix use-after-free when unmounting
 read-only filesystem
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
From: =?iso-8859-1?Q?Lu=EDs?= Henriques via Ocfs2-devel
 <ocfs2-devel@oss.oracle.com>
Reply-to: =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Content-type: text/plain; charset="iso-8859-1"
Content-transfer-encoding: quoted-printable
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:195.135.220.0/27
 ip6:2001:67c:2178:6::/120 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: yGJc1c5-_jx4z9e2wPg6ENq-57m9PlsQ
X-Proofpoint-GUID: yGJc1c5-_jx4z9e2wPg6ENq-57m9PlsQ
X-Mailman-Approved-At: Mon, 22 May 2023 16:27:38 +0000
Reporting-Meta:
 AAFq1fnXOjLCU1bFjse/PMCHyhOnR7g3r3ICr5KCiExwUNiSmg9I/Nuj7BwQ/VFa
 zTki9nElL9qUlhDvjZUGrvoLTMVHYyiNtDlTKRESmN4zGQU7xrLB8HEJwcJfaxF6
 846mlRLVwjRnFKBxJTCSUZCYv7x+eQCTZ6CoHwNcUnJIpCNFmhAC1JbKiyM+WQVv
 Mqv0hE7ajIhwJoqBbdFa9bm2QiWUuZVS1aahDCg4yeNwR3LtOZrEdIhQt62GTDaP
 jMq9c5UhSiLE/rzyXvmqwF+ybx0YC/4MeNk/y4UTx1wkVbajP1VwtOK8MZX4bPBC
 v5VXKSNEno5InvZmIemq6iKY/TeJBNZ1h5/ds2Ossd2d1PXhT1fMOASg1Z7Y/skh
 Wfohxlg3pL+0PTyCpOIA/QIy/SkGTOJFFkqtVJY3wR2XqSgITNcqeXW/U4n0Xb5e
 8M5QOgTxjlGv8aDYN9JkBuwvraCEw5T32j7xDOoX0WniIfS/TtI6LelcZkguJuBg
 E0xlQpaQu7lqdbcbRwzNhvtX8glRaU3ogj8uh5aKJ+Y=

It's trivial to trigger a use-after-free bug in the ocfs2 quotas code using
fstest generic/452.  After mounting a filesystem as read-only, quotas are
suspended and ocfs2_mem_dqinfo is freed through ->ocfs2_local_free_info(). =
 When
unmounting the filesystem, an UAF access to the oinfo will eventually cause=
 a
crash.

Cc: <stable@vger.kernel.org>
Signed-off-by: Lu=EDs Henriques <lhenriques@suse.de>
---
 fs/ocfs2/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0b0e6a132101..988d1c076861 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -952,8 +952,10 @@ static void ocfs2_disable_quotas(struct ocfs2_super *o=
sb)
 	for (type =3D 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!sb_has_quota_loaded(sb, type))
 			continue;
-		oinfo =3D sb_dqinfo(sb, type)->dqi_priv;
-		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+		if (!sb_has_quota_suspended(sb, type)) {
+			oinfo =3D sb_dqinfo(sb, type)->dqi_priv;
+			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+		}
 		inode =3D igrab(sb->s_dquot.files[type]);
 		/* Turn off quotas. This will remove all dquot structures from
 		 * memory and so they will be automatically synced to global

Cheers,
--
Lu=EDs

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
