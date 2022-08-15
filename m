Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A2E1C00140
	for <ocfs2-devel@archiver.kernel.org>; Mon, 15 Aug 2022 08:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EZxeGhzk88vpUq8GiS98mUJHvKVE7FQGz7bJwetKRNk=;
 b=Esyj+wDW9cGOy6R+mHjmdamMY8dLy+4kjwXCEsUFRVMJnJnKDHeFM0a5NtKKoNQMETvibGS98jAF
   hrhCvQF5vrhsoX/+s1Vy9NKVAM54z2DDtk/NTFa7lJgIQuFU2WdU37CGD60GM1hlsYCh+FtXOMX2
   hEL9hdAv2LVFf3XfEnPlVFP7CpKkWDiol/q1NqxWBc1v2gRqEk9E1/SFlwA90b4A6h9o+T40W2Vh
   Mk4drE3L+KThds05aSDi+vfHL3Z3a9q11Tb8ewYO7N4uQq8UtybE4tXmI3cCWfc7Pt8xXechoGqh
   zV9UyiAxQEqJHGoj4TlivJjPl4x8Sx7EBQ384g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EZxeGhzk88vpUq8GiS98mUJHvKVE7FQGz7bJwetKRNk=;
 b=cgeEp8cU/Q9NNcO1zXkDVJ6bzw7WOjCp10g+/xSYtJ4Yc83WAm1U0zVOQKHfiHvK1pzDdoiByHbS
   yHC1Pdcw64MWAWIFOQzForP734H7PKEzox5OxpENtwGPLs1nk1CKO6YyP5MbN8Eo/zJIs+n6hxye
   qSW/rdDQXU5jjt9BrNsv4ktwpW0tjlnezpiCbJnhAt/AkQspMPqZyw9j/+381OWbRS5NUMNdqErZ
   cowS5Sd3zlFnow6tmGhahHHcZnOdvT3TUvkDeROrPYbHqLSWW+o0HhJWscNMQ4qGPXy0GPL4hJB/
   G35RMeTwXamj8ovBq5IrId43A39bIXUZsHJlCQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGN004ZFFL7ZHB0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 15 Aug 2022 08:58:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4qTgsI5wllK0dhHikjxANT5igE4pMCKZpt4LyPoth625Sf2wyVogwXxaum2cHGgXvzLLvzcwJmxlNJ9226BAPI8nkHFl8XDdC7NVs8xqaEdII2DsO4vMKVNc70XqpxmBSyzvo6z3l5HuPkHhTDVMcGnYc2VT8q10uVC/GcAb57MVMvzskbxfxgbyruMmT1HD5Zp0JLTzLOIZAdZD150vV6fFWc4tMbwN8mTWMnDJudie5jmxkhY+12pJzBkf3wm2YNkVyJ4dtNgIeWehCt+V/ZjICvlbrGAgoNXCikNC72ANnyfna0al2Gmiiik+MuvnlueX04ew3gn+Wy8gW7TFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84jW2YyJyHwDwfp6OG2LH6PIJvexTJEcx6rpu7Kd6ZQ=;
 b=DDct21QafFpL3BKtLh3L1IrXlor1AxcRMPH7eBjr6OM76zv0ep1BGBUzvhb2g8Ox+CLTTTuzUOlPRJ+rIEzawS0uP81bTuyf4KJqpuxyFBP9OoBeMPX27vuUZYC0Q/CLRuyzwTpWxb10YQ10Nf3IF/1lNkZIQH5u0c2D+CovQOtHB7Tdjstvp74e53H4/WqBsOnFI/mN/Dpqs7YBwqpwDJWM9ImOyRBTZEdwZJM7rLV0NJ35nbQHHxqlVpLFeFj1bAqKdYDrOCY91uTwzq3OobWGaGEFOym5uz0uTENqchJJjpl/6QciXTkU51u1dnLzyLq1ijxxKZYtmumFESZRBA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84jW2YyJyHwDwfp6OG2LH6PIJvexTJEcx6rpu7Kd6ZQ=;
 b=cu/nVJbuBue94tIz1cHvoOa1RDVRCYled4/o0zLo7GJXCWcJgU8yHT2t+U+9OZu9W92PAN4g55CeC8Mab7FJmYzeJHzweheNWg7ZSs8QvNfQl/7nsctIeTUFLHA0Nm0W/3uk/Qb08m/Quo79TNt7ouzLa9qKsNCqYpT2mucsUbRDq7D4FV+WEAgUPFZc+biN54NCTyiP7uf5fkX43EFN5cQOM+iP2f6jLmiqse3TzObAL1gszZ/yU1axxhpo4h/PPXfmOcJXpAwlDKIbdTalbbF+hQnT7LCETLvNnvx36qEQBgMVC5JKnYaF0lATSWtVdRrckNToHwL+ItYKuqUKVw==
To: joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com
Date: Mon, 15 Aug 2022 16:57:54 +0800
Message-id: <20220815085754.20417-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM6PR04MB4662.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(376002)(346002)(39860400002)(366004)(396003)(136003)(6486002)(316002)(6512007)(6666004)(26005)(38100700002)(8676002)(66476007)(66556008)(66946007)(4326008)(6506007)(478600001)(83380400001)(41300700001)(36756003)(1076003)(2906002)(186003)(2616005)(5660300002)(44832011)(8936002)(86362001); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 08:58:03.9859 (UTC)
X-Source-IP: 40.107.15.70
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10439
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 clxscore=213 malwarescore=0 suspectscore=0
 priorityscore=126 bulkscore=0 impostorscore=0 spamscore=0 mlxlogscore=852
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208150031
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Fix freeing uninitialized resource	on
 ocfs2_dlm_shutdown
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
X-ClientProxiedBy: SG3P274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::27)
 To AM6PR04MB4662.eurprd04.prod.outlook.com (2603:10a6:20b:1b::21)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48da9bf9-3147-48f7-2800-08da7e9c4365
X-MS-TrafficTypeDiagnostic: AS8PR04MB8739:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 irzYCAtUINGQ/jnIJJtBPZ8klnkd0TsPqL2H7nb+HnXN0ZfQEiY32SpXVLzwmk6/1LZuR8pGjN+bzpnR3JK5fAi/hFLl2xwJfhEDDYZ/IK//dcRsN+QC+LtFKbxemsCkdEm71g/6/Zm+lcDcRZOrcqCUBCG6iNW2mDYwxq9abz0+AqNkXfTjEniwbm4/2JkIE42/D/eitOAKo/ND/erChA+TRCotmRmIS3EX8P+WQ+MaR0nWcOC0LqkdlH8U4vFj5CGiymUXRi4aBWXi7yi9pvSxa+AP7Njc4u8YJ+d2cwM/6FKFHFc0tLrfY/+xsPSgGbgZlX7Rt8xs18affRKweNX4I2Cn2uyLlF/fnocg1S520Y30gMTW7LdbBBi/2v7zX+dTmLZsWrMcT2m0V41E4XrOI2xg3rCCp1Ys5cip1Mc9yDqu5yyFc+PxrWDaX0bezHiY+z6mxsrzQrA5YNsau7Lzl31neQFJgGRnRuV5tIYBNF+lJESoPq8/k4Z7nq4rWnuosbM0MNCR5QUfWiItdqQIimOfnDLQChGH5twnVYd2142DfLf7NHFIiSNCqIpc4bS7miyd3nmWwD3gGy90d6uC2+2LxIR9BQvR+gUmIM/zisR6GOIBkiZ/IrWiQ0l/2U60glNlmKPHc3HGNVx6+skPo4PxY1Ug6qoHIkQ6Whq1HoncNyMKICSBrdeNXVwiIKeoB+1xYbPxvFnt9FVypN8rgg88FNVr7IEf2CHvfzs=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?M7iCR8iGwQS4tUTGFDXNEo/5GDDVRLnupEV3+lvpAetsB+4LST0wPuOhHyY6?=
 =?us-ascii?Q?bLpx1L+PAU/F981LrSBMGSmY/n/sTMicmhnkKj5sdXEUgXEBfwW3KrJzUcAm?=
 =?us-ascii?Q?VxfhytY4vASi97FLde3LMptABeB3fzijDc5Lrs9kSck02Mi8RwETdU2upLIb?=
 =?us-ascii?Q?p1M5SmUnivxx/wUV4SnUuiQNxmOwTdxlDJPA7GF+1rgDNDmIqiIwQmmH2vGo?=
 =?us-ascii?Q?YSjEcLRL2u2xbOFPRKPhxR/xWRYB/WDV64HvMkEVJK4ztw3JF1K5yxwnGD3X?=
 =?us-ascii?Q?lVdZm0gRgE+RLeb3PTz0R5hRFD4JfSdQ8R9vbz1ar6os9/cwW3eTs2add4o7?=
 =?us-ascii?Q?tvota0Zh2nlXR4TFhiJ74Lz/txBs3+GmTHU9oaPIL3x6XASk6ecRMT+L2zMD?=
 =?us-ascii?Q?oM1x8D1madGuH+LSt25EDsIKu0Br3kcNvh1mh91bqfRbldBw6j80zLKQP38v?=
 =?us-ascii?Q?XKpwNXjTZ5R6MVKchFZK4WEeVT/rSLcYFrfYBAyQ+YsZ1oC1lwzmQlBCW4yh?=
 =?us-ascii?Q?vKMD/o+HOyURvAr8wYeUmN8ZMr/guGHXoLD5Es7RpIlUICk9ctu2XLT8mzC1?=
 =?us-ascii?Q?gBLMh6UJDMnvkhZGVmLgYVBiY+GFNMEyPrgeIwfd+H9RwIzolox/j5T8Q4gm?=
 =?us-ascii?Q?poGpKb+fRTQW6NykJMtzJpzs0cTIPAZqZcCxpl89qHPcXjQ21fl6CDNNdU5l?=
 =?us-ascii?Q?LtRBQh8ITnllBjlRGXVF7ENxwUAPetCnOs3u5p0eYHvVldN8/5PvTplAOSld?=
 =?us-ascii?Q?wK/ZlYy4iFXA+Fcv9P2JEYqIoCpXxmacXLQ3DPGzwJkhCXkkegSTl7YbDBEj?=
 =?us-ascii?Q?nOtsryjwu2hqlECfVnyIZQDvQJuNIzwyLnK3Bxv5gZ0nmETyi7hH/s0D7y8q?=
 =?us-ascii?Q?WIVHBJptznO42gS8Xuc+QJ0ZC2+SeSlMEikxt8qkLGKCeI6X+jiGzCjEqOql?=
 =?us-ascii?Q?rSJ04C+0INpmw+HcTLVkva8IhKXKBJNXEmjuOndaexFkiRIHVNWzZLqJXHBJ?=
 =?us-ascii?Q?DQSkKriCZDrdEVcJV6UaNiWmpKBFV14wyarUb/RVje7V4x0oMZ50UgtepsWz?=
 =?us-ascii?Q?HI23SPRs0H97adDXASq3jqhfS0J/GCBAkhvxHb5VonF9XEVQDZTNyTaC8X8s?=
 =?us-ascii?Q?F/ZVGY2J/7j1MCOUtq6u4R6Vb0fWsOpJ6iJ7pQBmymF4mUNPDMrwGyKA7QTW?=
 =?us-ascii?Q?UdUhRoS9W5nFBSBRhuiIt4ZoBlSMnE+USX2KJIDXNUhABSTJJ7j3z9KfXISm?=
 =?us-ascii?Q?O6+YgFfj28BKbAmUAcMCUftdXnwR/BqP826qDk27A/IeUWq/1UQEn8vGXiXv?=
 =?us-ascii?Q?DE1t6XNtQAiav4LRPmYxZD1WMji/IEEkyoYQ8o5NipeaZ6p6FuGd0S8maEGS?=
 =?us-ascii?Q?9yC4tfkgNXN5TV4ElyVlczAKMsQoCUsBA3rH60xP/0d06thQWFsj5HVakeoR?=
 =?us-ascii?Q?GAnNJ6sQHIP+2v1ejPTh/rp+q6ZTsND2IJ242xHIlAy1L20GRXP1+ajznmsb?=
 =?us-ascii?Q?ItBgahZTfMETKJ+C90sbLz39Rh1Fa+XhV6hk0OOT64N+5DS7d1WyDlko8D3c?=
 =?us-ascii?Q?l1ntC08u5Cl21IX+JKsdLsRlWxNdUL6RcRpMwTr3?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 48da9bf9-3147-48f7-2800-08da7e9c4365
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4662.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 5PrWCCxocLRgUT4sxxIJAWUvBwGzxs6Vg+r2ehsImpLOfakNd1Pz+sMmWU+Ro6qO3Sqvk5iINdpu4aw8YHvfow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8739
X-ServerName: mail-eopbgr150070.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: i10AQ73axQ2fpYyx4FNa1cjnCEMEPzJg
X-Proofpoint-ORIG-GUID: i10AQ73axQ2fpYyx4FNa1cjnCEMEPzJg
Reporting-Meta:
 AAFtMKqTc1RDSjUE5smzogspemfBplQiudonJINNiN4xNTwrXmG+QrX81Xvo4+c+
 omVukpZmlVuD+iR+CSiQ9S1oBY2jEkH+NNAdq4QaGhCrpZeF7VvCeAgoMnIG8fD8
 4K4g27dKuvczxEQT+zoQbxaqxbBfridadDMJ82JpfYEydQ6wjvYJteZisY5qlaxR
 SDG2CEV5Ue9amCynB76VIVOlrnccmkoSsSOqZtVNmsG762RLb5MT/8ZEI9bAekqo
 bkPYuXoBlXw5E1J8V6F62WtBPXoUOiC8SI0XvHae7dHpmyOfNKfZIpduGftopoL1
 bpFAUPfKULONz1ot96M0H5pRseAXKwDHTlujcL5ya3GKQdMw335r3iuMB0POOZpm
 QQeiol1svcIcVtjoHX93uQyx79aKPONpYWUjOnHYkIX0tYECStid+/1M2AYBtVmS
 WWVq2PIzu17sFkxp22Lk2Jm9O+FyPtnIWn9aITn8QhQq0DcSjqBl3z/eSvNMA3Ra
 +yvaKQPQXWJmC4czNNS5GRdahaxnUqXIzNZrIysZUAueCQ==

After commit 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job
before return error"), any procedure after ocfs2_dlm_init() fails will
trigger crash when calling ocfs2_dlm_shutdown().

ie: On local mount mode, no dlm resource is initialized. If
ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling
will call ocfs2_dlm_shutdown(), then does dlm resource cleanup
job, which will trigger kernel crash.

This solution should bypass uninitialized resources in
ocfs2_dlm_shutdown().

Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before return error")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v1 -> v2:
 - by review comments:
   - revise commit log
   - remove improperly checking osb->cconn in ocfs2_dismount_volume()

draft -> v1:
 - separate to a single patch
 - by review comment:
   - do free lockres in shutdown path
   - put 'Fixes' string in one line
 - revise misspelled & grammar mistake in commit log
---
 fs/ocfs2/dlmglue.c | 8 +++++---
 fs/ocfs2/super.c   | 3 +--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 801e60bab955..c28bc983a7b1 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3403,10 +3403,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
-	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
-	osb->cconn = NULL;
+	if (osb->cconn) {
+		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
+		osb->cconn = NULL;
 
-	ocfs2_dlm_shutdown_debug(osb);
+		ocfs2_dlm_shutdown_debug(osb);
+	}
 }
 
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 438be028935d..bc18c27e9683 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1914,8 +1914,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);
-- 
2.37.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
