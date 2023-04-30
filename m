Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B7DDC77B60
	for <ocfs2-devel@archiver.kernel.org>; Sun, 30 Apr 2023 03:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TQcxWSWj+SzWR3fdmPR4CkEA5xWdOvd3o3xDu+YIJW8=;
 b=d4EEfeywm0k7CI4Snh7OKscgeG4+LJCAvH37VDmPYK4vKM4aklmrhzbQ8KDhFZYXS7hzBwQ4vU1K
   MuComNlVF2Iw+KMjTpvMBbD2a/vk98gPnqRuWfvQ8r3XNfh7OookkRVMMV9f+Ua+AFbBPiy3BIcm
   6hE3GFtwuAJhftW+Yw9KkVMtKqspaJ7ZWaenj8jQ7WlxtW/x5qQqSAxBg4cV5uoJsfjD3Vzb04yb
   aIyM3dJngHPUxJYgeU8yYO9vkuu3krl7vve+7kxjFgC7jAJQ2C+IgHRBaGIbCc8SZ6T5itx0yIGK
   OKWraZz7y0B73W0rVV93QtctGPufxKIuqwN+Sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TQcxWSWj+SzWR3fdmPR4CkEA5xWdOvd3o3xDu+YIJW8=;
 b=rfUyNP5JQyGf2brngEUkJkD+AKPRJI7UL2yAV0eR4R/0NGNtc+5/ssqI5BdItAxMqLRT5IjIvDvn
   dUeZvYu8BBnNPOb5MbuFWnsEXfs/5U1bLyiZf0l8Wntc0ZhCXbGClcZevToxsAEqakCdhb65J+WM
   iGBWazTBc2hhwKyjmaVc2nY0pNiEgXPfBvrSMl/IkHjptQd/DioqujDOtfn+WSowXKUVVwohG9+b
   +P0RbIA+As60GPlLLBKr/McdjwZpKh7vdviVIYbNy63kD+mwxfKxiOnHzDoOyMdfFsWxqBJ9AScp
   LFeg2jyvQPPVMYZDDXo6iVWlUPROtfMzDrjxcg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTW00GNIRN0J680@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 30 Apr 2023 03:13:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkRFSGDiElCwp82sz/2I8HFoQXTL1Ej4eo9boiuubtB5LOkcPurHfxs9S95jvuksxTdQ3LJIi7zvYCarShrgIOmg0luoDtkEmvqwkU0wWFsiXnKUrk7KzmKE/ckakBmZL7t+vqUsWYt/4R3mfrghoVF9mX9brmVq23h0K3nZSrL6cBYxqMnrKisni68UwVaOuQzyxYIV6eAbLsis66C15cxVoIuFi75seOj9+X/RXC+dbVaupUDEvOFyExTFjAjt9CBhMaSdfm4l6gWk0x1YrbrU7xw+rOLmMVwwAY+W5H/sIDyqwUm9x9MPrWVgyTfzs9d5sTr3MGmxKdHlD2XSgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zGPsTT4Cy+eu56Hde5dWXdeMU82dBMEdgMlQ+slzOk=;
 b=WqAMtG5GAiSiTLWsXhainfI2S2uT5E2sMqOr+QEkms31FnOt9F5KLkMEDyGT1nysB8L2JhieoBcDZXWpRh+vBZXgqsJ5osmSMD+fBFJ9Qb0F6wVtaiury8PoBgQTiYyF7ht1LqsiDs6bNC8yDDL01M+pRlBOqseOrHjiQituq5GERD6kvjZkykjkwNalRX3HCK1WkrVjwM5PMSqMzpO0HIXFdojki047BvoSZOWI2+/X1OsTpdnEGqp1Jk57fw4nLpkDZFD4VXBGKrZ+2j+b5OBON40RNHMpmk1rhY3m8Mpfxh7HphFlUWrVDGeeUeABwDY7w1vdNbEuNkxh1gKNQQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zGPsTT4Cy+eu56Hde5dWXdeMU82dBMEdgMlQ+slzOk=;
 b=qayfJ5lV4SXP6AablMxTSjQ2a/IAFphJ4a6K2gl5ojK8uC0GTcNUZOl9MRfFOzbwie8nrmnJiXYbWMJ9OnlVk+Nm1DONkWtipM1Uhfa3bAo5DZYuDHpyOijDFjRPf1mZRIH0vcA37X5cnVDlGzk4578j+woyiGe3n0Pglcj2fFxyQedkqGrmDWzDbIQ9026CFE6TnV5BqOZcIvKVRMsoeXFiQR+aQ17K0nOFMh3DTfTIhDQBNyI8RkQW3e6EmMsyTN6uCCItSIwJKUpE9lohM0SE/fzbU/U2JqHdwAlN83Iff+/W7C6cUcmyt8onyI2bqEI2iLY+o07yGEhhB52f8g==
To: joseph.qi@linux.alibaba.com
Date: Sun, 30 Apr 2023 11:13:02 +0800
Message-id: <20230430031302.15597-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.26.2
In-reply-to: <20230430031302.15597-1-heming.zhao@suse.com>
References: <20230430031302.15597-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39850400004)(396003)(136003)(346002)(376002)(366004)(451199021)(316002)(6512007)(6506007)(1076003)(26005)(186003)(41300700001)(2616005)(83380400001)(66476007)(478600001)(66556008)(66946007)(4326008)(6486002)(6666004)(6916009)(38100700002)(2906002)(36756003)(86362001)(5660300002)(8676002)(8936002)(44832011); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2023 03:13:27.0354 (UTC)
X-Source-IP: 40.107.20.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10695
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 clxscore=191 mlxscore=0 lowpriorityscore=0 phishscore=0 priorityscore=120
 spamscore=0 mlxlogscore=651 impostorscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304300028 domainage_hfrom=9714
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: add error handling path when jbd2
	enter ABORT status
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: TYCP286CA0024.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::14) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AS5PR04MB9755:EE_
X-MS-Office365-Filtering-Correlation-Id: 05ad3c89-f54e-4e9e-d799-08db4928dd7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 W+TY5Fmtx4FAUkcfZx3EbyR/lYSQW6tdJh0b8munF6HoWCgQz33IpGe9O8nmsj9VQaJD+ihgIisTIVfTgMJl7dAjrHPmtP+qTva8RPosbrWZqXK/wCmarr7pZ1lh522XM8RTVqTSsbGOGZg1UE97ly9P+1PFvfqGkPAaZu+yTGp1EN1dLILeWGZEAKrtpiNvK1f/LF6GbtQq2P/TCUkyEbpjNcGA+Ekx+cbMzBmPJpGKorAVo5S2fWIGoLgEZ2fxZ7u446D4VnWi7Ma/q5KI5fMlnQCR6X9/KTP59h+KfCoBmkuJxqH9DOxPV7vtRzn+2kweGXWoCoea4HFUyAv0oPhcXEhCZVlw6xCHDakgi01IRTmHy045xaSMBKlspR93et9iDLu1qBS9lU2lZnaraovi60UawXXaHx7bvxV/gCcP809VYAVca8C8CH5cS2PHB1U5+WTq79T8dS9pLgzxHvu3eXgic1eTHOCDkEwro0Jv8G40ohuh2Fkkhd7Tp3JhyVl7LdzUHpZZnspP+5c6XyWcM9LPHtl87BEAC9nsytV30J69qQ82ABKkEWZscAnV
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?lAnfJk5p6Fuput4p4ND9F0uSVrSOxB8kLo5kxbIkDVDWpkol5dYTCrTuxBLB?=
 =?us-ascii?Q?U0Xuokko9D77Iq0+S5Lm87X4sPYmH+dL90p2NJAwWbxp8ZHF93yW6CAghrKJ?=
 =?us-ascii?Q?q0EGaCCuGch5fLZmMwjTmifcni+SuPwdf6SAOewBYgBenVlAozQqYf/Lamy4?=
 =?us-ascii?Q?uRpN9/fgENKUsJwF3aYiNorAaJrMBfeO9N8yUx4DjJhTBeqOxdfkF0wqoa6H?=
 =?us-ascii?Q?MkjnVHgCI65LbYPtdMCGftguPPY3Hl/MG16DsAd/+pzqlXiPQzuk5dChSRLF?=
 =?us-ascii?Q?pPUEDOLF5TlsCfdtZZF4NzGKgL0Xlcsgo0wSZP0OMT3nOMajpWW7PqkTVASI?=
 =?us-ascii?Q?zbKX6gA2cO83RsGDzVCs3FEEitCnySuGSPLn1BAfuTVm7JuTuv1Mwgjexa2G?=
 =?us-ascii?Q?9k3aIzP2XY9dPSw8xEqF+6/Oe09gm14QNqZdl0804XB002Gpj/3+XoFexRT4?=
 =?us-ascii?Q?0XYmJ56/JsSvFJ72NhNuLPstlKArCOjRdCVb2iyKm1FPipi7DOr0VeZEqDHV?=
 =?us-ascii?Q?CD4H2dvRQD2oxMLFxH4xbbfFmF7f4eSTT7Jl1BbX8VjqxZK/mXXkTsYwyYBf?=
 =?us-ascii?Q?qQfZ0yo2zisB4dQSlQ1SSwG9aiNI9hmHcKxCz/lFm3FOSAYUdY2ZyI/v5dVq?=
 =?us-ascii?Q?+SGy+/cQ6N22nqsW15FbT3Njs3haTdm2xc3CZBf1UzP7xicaTndmtRb7k4PB?=
 =?us-ascii?Q?LX/nCThPsbSPP0lppTX+Gog1gDZ79PiGFQzy/DP6g2MNg32QZ16jeCjfgSoh?=
 =?us-ascii?Q?b1dtD2N+Lskk64Rq9E3wmZSKjLPm7I87982PhFhh4N30w8TYZPvlPr9wOfIg?=
 =?us-ascii?Q?CZ6ZNmvUNra4Ftb5QUFK5RKDoXJN6hXj5ARBdbOTmfWcA4GvNx3cZX6iW5Vz?=
 =?us-ascii?Q?YCMgTI8A9+n8SPvs+yOegpmf68Gl7peCX4PDXVw3ugCT+VPnwIsIc4fmeQCE?=
 =?us-ascii?Q?SrewMCC6N++g0u7mqVrxgLGTjxn1E9coMXQ/WH8V+wpV8GngWezwWFpN4o8y?=
 =?us-ascii?Q?8Z9ZiXKFzMT5e92k39gzHX705hdhPPIWIlU1wPkk1h392GA2+BlQd05jULiZ?=
 =?us-ascii?Q?m7aNt5qIUNZKsFQ3L++HS8JzRCT1MB7GAIM9K7SSUuuSIy4ejT1KsVjx/6Kr?=
 =?us-ascii?Q?wtyLchn/4qLL5mNP+rpBXUGVfCwAS9/UgQviGblsQU77+RLFlmSf2GFios3N?=
 =?us-ascii?Q?Gg7hhw+V0uJuaLMoGWHAJBLCIOU7IIRwbNrCc6ebsjn84hvx8/m/jXjozWlI?=
 =?us-ascii?Q?dZLh2P5icA4Vb5ZKBp8/aqbzpSx3VG52IzDvF9vib09vz2IyBEZDnSmyoD4z?=
 =?us-ascii?Q?bicnMTkK9xztdgEPZ9aVsDRmw6N524jfL96/tvR5U5ri38jiDVqRPf+PgIC2?=
 =?us-ascii?Q?/TsKgZgMgiFnHjoX/7ijhPXHzVrjxbjD5Aj7Cr7uLnikOA/Nl7BxBQ6X1qIt?=
 =?us-ascii?Q?PKt52OftkON7FmU6WV4MDajki8Ahuy8cFMwSz8SuuAtBHVQpe0DPqm5mwf+6?=
 =?us-ascii?Q?PJd3ypWhxxmFZNclU5Ru4H5rXpotXBvsR5qF2HF953hbK7igJOFsRVB3f9ED?=
 =?us-ascii?Q?cp4wnspgPQx6bkeGkazldupAls8Z5a8qhZVAzbfQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 05ad3c89-f54e-4e9e-d799-08db4928dd7d
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 vGAxFb4iehD9vzLNka5IVX42g1dPpDoiRfjd+WO/+oDeY8EkTYuoqRFHxRE8QlcwTgOY47IM9lzeSOFyUlHwqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9755
X-ServerName: mail-db8eur05on2075.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: fZdRnoIsJBHO5BeeHmmCPEpe7G6VYieg
X-Proofpoint-ORIG-GUID: fZdRnoIsJBHO5BeeHmmCPEpe7G6VYieg
Reporting-Meta:
 AAHS9xXbC14ZOgqKvuudgp1HKvm7cfag6GoZ+V5Sg/JoFEb4+OckRfU7z1PvcghY
 bxpXcZgOIbydfK71syBBZykJn6se5zwPFcuW+4eDbfgdWrcPjly8yRpAOLg9hZoY
 rjiHaTGHZ3jP3sabBOqYmfSvItXiRArIc9xngay/NufcGtgIbmi3b06Oqy4csegx
 AriNvZOZqEs+MohaNUhb35kAYj9ERY2MBt+AuqYkP0hibwxL9y4OHhHT1A7vLH/N
 hnGWgy/8h04qdI23Wy2X5HaKQcPLKJvcA9nhm76vgIzHOxYwMllH7eDiODantKZ7
 nrwT6U/Hn3NJufgbR6EWOL8K/ZkxdNAdhgULBe0h7OJXpbetADBwV6Xhu/A5O/HR
 ZdyR0Y7Xw88VwLclPyp5ox6YjuYJO50dSeZZ/Mt0PN4mG+DaNf4dS9vS0N9OITaZ
 gD6JH93dJ1HfKai6YBR9gL4odOl0XgVCXqFLt7jJgT8B9NgXlvdV894fThZ/jqoV
 qiYsTz5QaZvIRD6hwFD6bUGVGLBJW7FhLSopDA5bsoWp

fstest generic cases 347 361 628 629 trigger a same issue:
When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
journal.

This commit gives ocfs2 ability to handle jbd2 ABORT case.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/alloc.c      | 10 ++++++----
 fs/ocfs2/journal.c    |  5 +++++
 fs/ocfs2/localalloc.c |  3 +++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 51c93929a146..d90961a1c433 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6308,11 +6308,13 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
 
 	if (tl_inode) {
 		cancel_delayed_work(&osb->osb_truncate_log_wq);
-		flush_workqueue(osb->ocfs2_wq);
+		if (!is_journal_aborted(osb->journal->j_journal)) {
+			flush_workqueue(osb->ocfs2_wq);
 
-		status = ocfs2_flush_truncate_log(osb);
-		if (status < 0)
-			mlog_errno(status);
+			status = ocfs2_flush_truncate_log(osb);
+			if (status < 0)
+				mlog_errno(status);
+		}
 
 		brelse(osb->osb_tl_bh);
 		iput(osb->osb_tl_inode);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 25d8072ccfce..2798067a2f66 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -312,11 +312,16 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
 	status = jbd2_journal_flush(journal->j_journal, 0);
 	jbd2_journal_unlock_updates(journal->j_journal);
 	if (status < 0) {
+		if (is_journal_aborted(journal->j_journal)) {
+			ocfs2_error(osb->sb, "jbd2 status: ABORT.\n");
+			goto reset;
+		}
 		up_write(&journal->j_trans_barrier);
 		mlog_errno(status);
 		goto finally;
 	}
 
+reset:
 	ocfs2_inc_trans_id(journal);
 
 	flushed = atomic_read(&journal->j_num_trans);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index c4426d12a2ad..e2e3400717b0 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -378,6 +378,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	if (osb->ocfs2_wq)
 		flush_workqueue(osb->ocfs2_wq);
 
+	if (is_journal_aborted(osb->journal->j_journal))
+		goto out;
+
 	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
 		goto out;
 
-- 
2.39.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
