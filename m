Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 065AFEB64DA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 11:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DwTBGPWDax42SKxIn2lQeLr3PjbeeDc7NqQ73Ny8sFU=;
 b=ZxxYNFf+oSbmEQaUAf4Lrrq6hk2fvelpGy5+k1tK0FoIsF/JZcGiwKtKZMy3FXXK1OQqe9j8MBy2
   mknXarzB0yPFYE1V5CnV+99YAhocyvdVS4WmarAPx/4q2M7z/JYekZL4cv+EPu0BLqmsz2exlu9r
   lee07w1Yo00LoHtT1KwDNijB9/c/7PO+zdjf4St4Ynkw4fDX38y4hRp+Gzaa7YRebP+xqyW6FG/n
   YQm7M3bO61Kwjzn4IPxSCYZCaZy1Hl0obOipprt5LUqVf6pdjTk3tGG8ZVe1Lnxf083c104bAxc4
   cFA7etZeSQG8LprAaJQiMW8ZzS98BVr4qOxiig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DwTBGPWDax42SKxIn2lQeLr3PjbeeDc7NqQ73Ny8sFU=;
 b=rDaZAXcS232NbmyWJMGRUz2Ba8XApZwFW3vfJC0RLTBjn5Ii1eDzwmn8hoUU5cISJJIN4sStlT+x
   YVF9Y5Wc7peaFGh7J4E6Y6jgjhrs/0Nx/ed7onYdgpYtT7Yta74cLz3XlLBktFpW9sdW+GuqlsD5
   ThnBp1H9OTInVRzlHCK4HhRloQL9Amr02IezqL2e1IhEwvJCKxl2lTwxFB6PNWU7rFn/urorFrD6
   dKTCW3tR7Szi09bHTax4ZVN2OIXSW7dU+eQVid2HRdpVURO5PxSBicI3JYbKqj5M0zU4P2PHquFY
   tX0G6HZRIAAxuwLIVdXJwE7napTQQGYYUnOREQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU00BYYYEWB970@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 11:25:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npCFGIi05fPd4oXLNKRruwiVsirweOz6kMV0nFj1/esBz9WFH7PRoyCC7Gl/pXV9EVbM+bLEM0JdPyLhln+ZWULxfb6+JOhwCJnuQvqNjC1O4Up0PO2dT4yZyfxZBwKO5XfHbUO0F7uxIAjnHTpm1JfPhBCtchpFoMclGhJ7rhhZTVXbkRcuXx6F/nJTpw5LcHKjN8DhSzOQwOvLMQlpsEW4OyxuUiOAjaWwriyXghRzktrTH94AxLYdphxE/lYUmawFMJ2welXeDWQnGOX/JmpRBkvA02nzKFLrwZ6qQFzd2DG4UWOelr1QTr4B88dxyZBTMMatDA8q8gS5W1OXDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPwoJ/7Morq6C88VqMybsML7InCy4hqaG5/bEWxjhFY=;
 b=hdpfnktBBKQuBQuaEhbY2hV5jvJALt7TqISJgrUlQxNTiqJnC32dN2xAcM5MXvgf4Q7wRuRVBiLQHc4Cgo8L3InuMGegBdr20Vha9/7WZVjUvtMqzrMOy+ElBRBypxdsEjv+ZpT0lZRbKG6AklSS152VS1B7pX4vbZW66mjg5lI0ZbOnjQj0NFT9AqGkG4SPyrycfXc+q5CvFCOuocEypESJUhppXmLWA6LYIEvYTlnp0EA4aLGWBgF/lRVJjlIjSRHaTCq3s6PHkNF+x8QEFEO6oAq2aU3kS2gmb9V9KxjWV3WGuWjqNen3ovgYAxspCOlKrdSrjD92Lt1m7Q8PiA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPwoJ/7Morq6C88VqMybsML7InCy4hqaG5/bEWxjhFY=;
 b=jDPam3ks9tyk5PW8gzmG6XUdQA9XUU2ttokqvUqYHlWd7+ffJMOKlc7wZGPLj2tGa0+L5hgtyhij+65UyoyuZTAzdK40jGV0SCgiMf2tsZkchoINdjH+qO97ZQrte1Zg/6YLRK9NGzZY7tAbxmQ6rbDCmQC2Qk+wEhmF89OLn4+rBnBVYdtE+TvIlChjYBFUub3StMbSz1ULfCB6r9IigZz3M3yBHQ+updyDd3a0CZYF3O3OvQNFtQTqE5BjUjKiwBlCLVF5cjLK7ZYRQ255je5zU1CaG1qTC2WjpZsFolZ8vOehBpkKXBweZBiBiHmJfZXZZOZHxzdtceIX3xcnXA==
To: joseph.qi@linux.alibaba.com
Date: Mon, 26 Jun 2023 19:24:53 +0800
Message-id: <20230626112453.22571-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199021)(6512007)(44832011)(66556008)(66476007)(316002)(6916009)(66946007)(4326008)(478600001)(8936002)(36756003)(8676002)(5660300002)(1076003)(2906002)(966005)(86362001)(41300700001)(6486002)(186003)(6506007)(26005)(38100700002)(6666004)(83380400001)(2616005);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 11:25:02.7815 (UTC)
X-Source-IP: 40.107.13.82
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 priorityscore=126 clxscore=179 impostorscore=0 malwarescore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260102 domainage_hfrom=9771
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: add error handling path when jbd2
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
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DUZPR04MB9872:EE_
X-MS-Office365-Filtering-Correlation-Id: 761eea91-e641-4b63-c466-08db7637fbe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 mvLk5vCnbYN9IlL8B42AwloMlvvq6I+SpPoCeM28EdXYFEFOdlTUulWI2xk++tvWazwHs76ZWcg0KhrlOAzl6JMVLCzEw9MLoaUfGV3KaV4N/EPV0KaQqQKv5M2OLmb61M4SIcYmczUltNS9hrY0DnuVqLr8fePkfVlZ/jffPjvreErX1ToxY5PUZSSmmcst8Htv2iT0aers97xzbVf2wuQrP8UZmn+32ETTvs5V7j7MDqYU+Rq9JtSigp8ioO1ANFC3l/GEw8/o6xHowttZA4YxR4fFHlxz6K7dZ14CARTuy/9xdcaKD9GI2eQc7xeOV57HKnPXGmzWK0ousZRYcEOL1YuITjw18kSSCY2MNYuuLbJQAe7/wGXns8I/7YnOOs3wUZoTTFVtxBvVynoXVyQToBPS0TTrhiJhZjvhTaTfTUetpPx4bp1hBxVhjNsQWzgd+DZq//WrTCLWCon5oyHekNL8jkQswl0XTwxR/7vwiV4YHHOuM4rOUb/Gl2LO4j5xtRijBUH1JgTmYXOFYDUoe05JuLy/U1Cpnoh5u6M=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?p9tuSx8JGc935hiIlg7bw6r3lWGKKs0BciBB4n1GTenUyjbtcC9H0rq3T8LO?=
 =?us-ascii?Q?oJWkAuB3uThAZB5fF6Kc5frE9/wFfLh/8TY+sXUSj4NnaHN76gZxaNw7Hkzn?=
 =?us-ascii?Q?cDLSUaycrAH9YsszUuhfWL5u0G2hO8D0rwo2LxhrdRApUDS5/vyH9i/D0yCl?=
 =?us-ascii?Q?VLku23SNWA6bv6In3J9xlBgcVrrMtZY3kj/x7LKm1WeZmsF0qn6fNHDg1gLg?=
 =?us-ascii?Q?3PTJUz/khUwygauoSXwcS4THZgdL9nLEhtN9yJPWSuN+KbwwxZaKMBA4P9vW?=
 =?us-ascii?Q?4qcFomYX/SleLR5Nrq6lxACd1Es9C8KQXaZT8BzU7xc/RGLAs8vk54KiI9ku?=
 =?us-ascii?Q?UzsCFi665X83fi1dzphrz8Z/gHQMD39yio1yNrGwasX9ei9FS+E/7x2WwJFc?=
 =?us-ascii?Q?Md148eWH+4pLoeXxGtXUZiC6/W/e7k6SoBQAMsJOz4VzWgHEsygXk5ZSC3P7?=
 =?us-ascii?Q?MFQM3FN0hV0dvXprw0dR/EqOjvyS+MqZO2ksRcUHu9vTH2nHq53OTS71LAIC?=
 =?us-ascii?Q?UCRUB9DQA4s5n7NB6WKbavWD6AICNn8Dsdvkks33wb9nH+3UUQ3JTp2kqFoj?=
 =?us-ascii?Q?qWPB4uHZaPBggQ9wOX8Idu2odU/9EVXiQX520yTMeTuvPi1E2ZJE4LvLtwdq?=
 =?us-ascii?Q?aLMJGmkPFR7pFcDZ+26uIybDTW0sgtu8Fb+4euNQiNtNstmUILGbibzHkaxd?=
 =?us-ascii?Q?n3HZ/XANMoEMSCA/iaDSVrouPPxyd3W/bH0OOSoDTFf6IA162yI8AA8etpDl?=
 =?us-ascii?Q?7fDqFUrr2DN0cn1Bp8zdJbGnIqLcTqlj3WfT8TPdXgarTGQEYRoPXACNdKLM?=
 =?us-ascii?Q?JbnA38CV+YCpAmxYJTxn9zKZeCrUFNn+NgfOO27Kyo3kUtu6Q34ZinukEML7?=
 =?us-ascii?Q?sryKlSGg35iql9nhQGJwuECj315o888/wPOfU6/NqL1+mvLt+Z0Ob3iTIAkB?=
 =?us-ascii?Q?y/fIv36lGSgJzXpKbZHAr9WKQgQuvj2L3N9PIEK3XYXcjdrxezMy6/RnFSqi?=
 =?us-ascii?Q?HUbSh7iacnCGm4P3JBPFk80XitJssfi9vqaxZ2op5LPYiY2YqLIQ3/sQX3vV?=
 =?us-ascii?Q?D6egs9ANdouXCJpZW37AihRaxyR8rW5ir1g6wty7OHqG2GQFrYEfkMkKb7N0?=
 =?us-ascii?Q?R+sg1Wu5dqLrTNhjxz510U8UT4/hnyVkox3pfmM7yhO/P9am2eytPip2eA+T?=
 =?us-ascii?Q?42EFCn0pno4loLpMKviHBr6VNw/SW0Bs+Ej7PKeNCJ52PdZd8greE5JwbGh0?=
 =?us-ascii?Q?r+MXzWaczFVKY8yi14sM71Iu/JpwJxUmjG8QhsBrgBF7gG95VtgPBqAydaYn?=
 =?us-ascii?Q?VQ6SQ/J4Cnz/5vtS6vS+gsbPRdlVFLq2c5Ugj5+OgPY+kQMIjTCpEBWHu51E?=
 =?us-ascii?Q?xPq22CoMhQLFMsgdOmxUYj+tpmZpc4ybrSDzbUAAwMb1no+64KezYonZGGEK?=
 =?us-ascii?Q?rxXxKfpskxwsWniX01dxfnma11+V2YuAJq8JugadsIHAZzV4EwA5LXYIQ2me?=
 =?us-ascii?Q?ccCXb6//v4/wQ3bAbYb+40KW7IjXOOxA7BgZ7jDHREHLnIVry0BTX6oDQWlf?=
 =?us-ascii?Q?2XUBrSSXZ9eof/5sm41TYzKlHVwD1r57G2hQMjeM?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 761eea91-e641-4b63-c466-08db7637fbe7
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 xI+pA3TcqxoQ/phKNBFrFUuO8ABpLHTEhU1tZWoOB5thMP8yoYk919OyXQpZcrzZUm3PQoBesAUkLJrHYRePjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9872
X-ServerName: mail-he1eur01on2082.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 2kfFqco1_oodgSUDxtKd5jh9cWk33r7M
X-Proofpoint-ORIG-GUID: 2kfFqco1_oodgSUDxtKd5jh9cWk33r7M
Reporting-Meta:
 AAGnWegt7SSmjzlfoVpuxkQUf6BB/D2uqut/JP3958diyR6ObLy79pSDNeno8Xgx
 kNH3V78mQP3LTGJkwLr6+oGff+ED4uO4AuCMoqrABFRXmnMKJGDJwkgz7u8UCJjk
 5SI7ARXCdqebL1cz6ZMZ+EP2DvbT2Jjz9xKzDrK7SyDD5gJd/tFf8F6oxnICRPz2
 9Ewv3O+vbQE7cf7fLYw+6BoCxdX0EcZ5hGHRhVQXxZML1fWZVCci/jg4oipCGMI5
 4zwpEnFcJxFUEVYIPO749IyEBdoBuekzRmE9NoocJ6jZ41D6oQD1gzZ8l+HYVZzY
 Ge4LhpoyRKY5b/hqKvQqrbmFg0uDhhONKjSWQGAyHVDgDoeng1OKfX6gPcewq9JV
 As2wwST22YlHr6MH+jFUokyWDnOyvrdZMkGVGc72xQCPkvXzUkvRaME3P4xvwnW/
 vxAjDRaIkJlnbq8Wyi7zEbVqSvM8uirPmNONrD9c4opF9XFeJMAo6IgvYAB9DJH4
 obND/sJumLbDmHjbpgr99aZOcTVZqwfmyFXmuvrofUrz

fstest generic cases 347 361 628 629 trigger a same issue:
When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
journal. This issue causes umount failure (hanging).

This commit gives ocfs2 ability to handle jbd2 ABORT case. After
patching, umount successfully and leave journal dirty status.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v2:
   (this v2 only for patch [2/2], see below URL)
   add description in commit log.
   don't reset ->j_num_trans and leave journal dirty status on disk.

v1: https://oss.oracle.com/pipermail/ocfs2-devel/2023-April/000896.html
---
 fs/ocfs2/alloc.c      | 10 ++++++----
 fs/ocfs2/journal.c    | 17 +++++++++++++++--
 fs/ocfs2/journal.h    |  5 +++--
 fs/ocfs2/localalloc.c |  3 +++
 4 files changed, 27 insertions(+), 8 deletions(-)

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
index 25d8072ccfce..30de277461b3 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -314,6 +314,11 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
 	if (status < 0) {
 		up_write(&journal->j_trans_barrier);
 		mlog_errno(status);
+		if (is_journal_aborted(journal->j_journal)) {
+			ocfs2_error(osb->sb, "jbd2 status: ABORT.\n");
+			wake_up(&journal->j_checkpointed);
+			status = -EROFS;
+		}
 		goto finally;
 	}
 
@@ -1010,6 +1015,8 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 	if (!journal)
 		goto done;
 
+	status = is_journal_aborted(journal->j_journal);
+
 	inode = journal->j_inode;
 
 	if (journal->j_state != OCFS2_JOURNAL_LOADED)
@@ -1038,9 +1045,10 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		osb->commit_task = NULL;
 	}
 
-	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
+	BUG_ON(!is_journal_aborted(journal->j_journal) &&
+			atomic_read(&(osb->journal->j_num_trans)) != 0);
 
-	if (ocfs2_mount_local(osb)) {
+	if (!status && ocfs2_mount_local(osb)) {
 		jbd2_journal_lock_updates(journal->j_journal);
 		status = jbd2_journal_flush(journal->j_journal, 0);
 		jbd2_journal_unlock_updates(journal->j_journal);
@@ -2352,6 +2360,11 @@ static int ocfs2_commit_thread(void *arg)
 			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
 				mlog(ML_ERROR, "status = %d, journal is "
 						"already aborted.\n", status);
+
+			if (status == -EROFS) {
+				osb->commit_task = NULL;
+				return status;
+			}
 			/*
 			 * After ocfs2_commit_cache() fails, j_num_trans has a
 			 * non-zero value.  Sleep here to avoid a busy-wait
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 41c382f68529..080726ffa24d 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -192,7 +192,7 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_mount_local(osb))
+	if (ocfs2_mount_local(osb) || sb_rdonly(inode->i_sb))
 		return;
 
 	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
@@ -205,7 +205,8 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
 		ocfs2_start_checkpoint(osb);
 
 		wait_event(osb->journal->j_checkpointed,
-			   ocfs2_ci_fully_checkpointed(INODE_CACHE(inode)));
+			   ocfs2_ci_fully_checkpointed(INODE_CACHE(inode)) ||
+			   sb_rdonly(inode->i_sb));
 	}
 }
 
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
2.41.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
