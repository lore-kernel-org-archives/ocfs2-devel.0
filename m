Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F44FC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qR5es484pEq5hCttYNRQTelaDEfGVHBYeFO7QYehfOI=;
 b=MgrzCLAvT5/hPmR7hWyg3DZHXXHLa4VuGJR69VMIc8JME/3G9fVxdCAPMQF903vSeLlX5Xs+DPlm
   sRrSyeB445H0XGNJiKzkgkeuM9szxze/8Gs/BUhMBRX0UpAGx57wQIYfMlUrjmyX4dCxPisK1Nhi
   8aCkP+2rNjgCvWTGDlh2442v0muPy/tF1MgGF3TZ5+K1ebsescuSTzLF7R5chl2K50mNSPAtMSjg
   2CGVABR8lhsZTAYIFkdMLFxliS4T8+IYj2K2ZgMbhGRVUso1fhyBqes1fPQ/dxZR97gcozLut/MO
   NaYNmpUlLRBEEyF+kLmux3amCHFYQU+mtH/Nrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qR5es484pEq5hCttYNRQTelaDEfGVHBYeFO7QYehfOI=;
 b=I/GUNqH0+LiCW1sFDHskK/b/VGxXh4+TYe+sRxklyoAg7MNbMIKf01MCuYo1hy0uamS0Kh30cQbs
   N3h4eOiXu3mciJT9WQflVIn0OEav/hFN4mLKcV0xRoBoLpHAwEXkY740df2JLngZDpW7/A+Hv76H
   wiS7RAR86GrTs3rYX7anJUcr6MwvBmwoYn0bTMs6a8OsgGYdW+1pImb4tfyEwp/3cEbOGpA3rQ6G
   hqkJQFCKxVZvhh6/IfTeR//iqP+4kpJbww3vPxSjV/auHjzElUeRqHASzb4qjN0lb5KaVJSwdpnP
   hXAWn7BGsPJToQVsBOLdIZKL2YkhDNiCluHlNw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAA007N86BZQ570@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 13:47:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649838621;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9gi3Ipv1rJ5wE/i3sQwq4H0Tz1fg7do6AgYCt9ICc0c=;
 b=Tu3GLDFGoCn2vs53JfL+bkQ62M6thlXfPC03P8w6ILBXWMS2Kzr429Svb+4+wld/f975Zm
 gSfwPIaNCxvQTiSH6SAfnMfWnV9z0P5AwWXPu5+pOh3FnYh0qpLOPvdvJvZGWZm88DGHHj
 qzuU8zfflSKFlw2DvGGUYEGtPuvyyAY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mhh2PrVGRrt2eB4E8HFC75kPPJsEenROJP4ktne/xQdPVc7WfbeHa7W6VfwAvO5UjYaBEoj5cTCHeGJNuWRE7dDsJ++V3gHFsLaw6LWSvLXz3Alu532ELFohMMIWVkrcGkBtf6H3G574wejv3hVKWzSgeJmIRRyrsUNmWXvFB383j+rgRTqkOlhdYyINrW9+bxdl2PrecBVQQz3AA81NAuAqlwNZOq1PJPDZHJYTvI6Rr6FVdf+Jv284rU33I0oyG/qrwUX0FPBpBUB/UjD7T3oLsqH9zLjOshKnhnUxOi43FOwwdi/YiGY7zv1klUpmoVGfmaCMRmGC20D/KFg1aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzzcJ0/NDLaO0rhBHQpYvlU2BTUyO3ZNpaDK206ExyY=;
 b=HgQdCsgUEcY1Jbnj+db+WNSxLnXnT+cd5zzcghu8l+wxm2+6sZ09Kek1O1i6dy+NKERYiXPKQ8gOaItBafJf/fJjgfhXzHcd3XGFgnmnItBPz6iDCQfnCQwxMzGw/MJQXhe2f/rlwIy4osJWLjTI9E6hblwvV3iE55hZ/YVrXCbeQGl4uXidsb1qBjWvAOC23PvG+mTTtyeCfTIZbGjQHgu+eqgE8JY0ZlGYztPXpbRh6K/+b11xxFAXoroUh8gxkdHhac4mgwLMbSpFYiDbbKe03GbUcXF/FFrLtNvub3kb3JVRMDGZCOozkiLiJ0fUZ4o/lAFVTwegwOZ9pmTeUw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Wed, 13 Apr 2022 16:29:53 +0800
Message-id: <20220413082957.28774-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220413082957.28774-1-heming.zhao@suse.com>
References: <20220413082957.28774-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(6486002)(38100700002)(8936002)(36756003)(508600001)(86362001)(2616005)(26005)(6512007)(1076003)(8676002)(66556008)(66476007)(4326008)(66946007)(83380400001)(107886003)(6666004)(2906002)(186003)(6506007)(5660300002)(44832011);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 08:30:18.4785 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=202 malwarescore=0 clxscore=179 phishscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130047
Subject: [Ocfs2-devel] [PATCH v2 1/5] ocfs2: fix mounting crash if journal	is
 not alloced
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
X-MC-Unique: 34VJPQH8PdGKxIOY5l_VnA-1
X-ClientProxiedBy: TYAPR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:404:15::25) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf5dfa78-1e59-48ba-21e3-08da1d27d76f
X-MS-TrafficTypeDiagnostic: AM9PR04MB8100:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB8100FC1B68366468876216F897EC9@AM9PR04MB8100.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 CmJfBy1L5CslbKD5oYK5zCnYlGba/gVQMTkgs68rh8Xc7pFtVBrrecm/d01k1DrgNR2tBl9NvWV7yaIxcQbtGrH/we/8c7aGG9mNVpUi/d/+GT4SySW+FDAiRJROdVxKfoncvlRqrXw+mN4KEqdvRzoFXU4CJo+vQHad80SNa7/MrMtVVYttS9HDLosFzddtq2ovfZg9DX7e07/5PoHJcjhNHGu51D251yzpnPdFy8gJelYv5tjtrSmGwdv2Ld50K30fnu39ngf8a0EE42p+lW2Mc7CFQN/LD4huAteH3r45vuXWX4EI3tEJ9ly0C5yQwEGNr3OSc1HuN2ZAhmgN3IzrwlqrF2sLsl8dcz9ndH6yRvsXRVdd7RWeqk3VtQaVVcowGkunHj1+Xr7ppAkTD62G7yWg/Bhi9Iucj44NR4LYw4WAx2VsHR7RsADDwojoSwA54KSADF+y6rXhUWuNzhbORkjg+RrOkH0W7KWwTnrPwi0Bb913fu0KjBwEqf8m52aePVeLikf4eL7sOAg4FWoeYMdUZ/3181ToH3WuPLOe3QheDoONafbdeg6rcbMH/Z9rYnHYg3xVjFiezzHgWHT+JjYDPm/vUfxvyvrd2I+Km3X9gsra+tHHKC+6FCp+eOIvPGn4IxFc66L0WAhNqQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?I/e60tS48zdPPynu+UK62ZXdjAMKgGbc1JAdMsK4F5koc6QNlpEDVWi6jQXR?=
 =?us-ascii?Q?i2vovMJ5Xwo9cxsyH/7HjL6SZ3Usw0q2JvOZt7wE3XCfcshQ71tCmU84iNxF?=
 =?us-ascii?Q?RwRm3T15q+o9S4FDBQoAlu2pR5wwjg6ztwLnFBkA93AJKcVZpzU5L2FLWQ0e?=
 =?us-ascii?Q?Uz5t8cRL5tS9FO1rONCcnavcSZLBOkluQj7OpHUFM/BzR/tYEMe8sTu6Ecds?=
 =?us-ascii?Q?7wmbVlG9PJ9h8IX+h2MuzQTlLWyWJ0VDLMeOW07zq8llHuX8EzTbBKyMB1sv?=
 =?us-ascii?Q?qG9LEeFhUm/23Z2Vr8uAN/G7c0rZseAmujBofa6r9rI84yhLddEghvy6xl3M?=
 =?us-ascii?Q?9usPzlGjHjQmoxXTzqU6nhip9WVs4iUahGMnz41/rXkifIdkVT3wIMSP4AtH?=
 =?us-ascii?Q?4pWpGY/Ks5ovZ8rYJFC0GLI3+1PhJESj4hu1xY0v48U3EYvjob/hYPSCb45w?=
 =?us-ascii?Q?xkfyuKenVaHZjHgSL+giQ6iytSLTBLGM9AR5qHmV8rGhTQ41yRfUDqQKP1E4?=
 =?us-ascii?Q?VFF3soXrmG6koIDNNXoIrQOxkk8B6zR/AfcChHCk9MEnfjWiZ2JKkresx9yD?=
 =?us-ascii?Q?EL18yjACdbKqpbfjp6Y0bWHmFiinATztKz3OjiaYpVbGTNCWtuFNCgEE/wN0?=
 =?us-ascii?Q?1Bzy5IFWr2XAkyj650V0Pw9xcO0XOK22wNHY6HsuACbvJafF7pSfyFZv1b0j?=
 =?us-ascii?Q?gwvzk0Dy2jBL8pPCjIaqONzz3EGB4GptjtMIjsZlTZsYs+BSViRzFvMMs1W7?=
 =?us-ascii?Q?RAZLjWl2bajDPP9+G9oSOlfh9U6mK/z5bBkuXpjiedbkNFyL5qSrpUz56Dcx?=
 =?us-ascii?Q?fjmzsNpx6DGcpmAluDqp0MVIjllsA+vcsMzSC7UVzpnpHDBqDJtahvHwv0c5?=
 =?us-ascii?Q?Sgg1LFNHGg5c8bxHA5C+zEakbHPG5o2/W0ZJLdCk1t64jMbMZFqzGziu+5IB?=
 =?us-ascii?Q?9Kx2JXEM36ybFs83IVMOcDl+rJfXh0Oy34ON6bDLnEdWPXjdjfqtPEOJWxsm?=
 =?us-ascii?Q?6c0PWHR0WB+56xRY8N7tdEWNSoKA/MT2sau7cGvMOGh8v4ZlyY7MnVS1FfFz?=
 =?us-ascii?Q?t8hr5FtsbWX9L1r3tTki1fmMhWIHoyVD2PJ06l7DJPpafSsooH1sX0REbQ72?=
 =?us-ascii?Q?bWQWZAf8vOPfb9/Kk5cl0hIDhKbNxPTagqRZ+b027sFADf8XrDjAd9k6fvd6?=
 =?us-ascii?Q?dPU0niUnw1ODI3XgYmsyEjMTvEPllNXz8tpA6H+iwp63HAO7lRpzPOWQ1vyK?=
 =?us-ascii?Q?7AIxJ7uKJBWsUifo3sbK7hKtL/84SjSPNF2m6bOVD0P/nWCsdx9rX+DcDkPD?=
 =?us-ascii?Q?EmZFNAjnFgmNfFLK0LgMnVEEhZKRdplSjGXjiV2IX7jAEBK8yXGxVoIcOsIe?=
 =?us-ascii?Q?khi1FM1J+Lbl+V9J84vNfTSwYvdvm2E8eeNsSe34sy4dX/dtSTU4n072DBuY?=
 =?us-ascii?Q?4nokzhelKsfJp1wfZOPraA/QO1DWnPkm5YGUC3dUN4mE1RUPy/1Y8xPIDIX6?=
 =?us-ascii?Q?BnAUR88lbCI7pxsRA28i+EuwNvOU9IbyDWXeypdthva6OyU23gqFglHmsS/D?=
 =?us-ascii?Q?dQmMqcOcRybTF2RHrcJpUzB9MFX0LSWCJQJ7M1qYVZaNDc94an9Gjxv6a2fi?=
 =?us-ascii?Q?+rAnaAp3pTeCbrtEnCSeZHzdcv2rd1E8kfWwiwt97cEFnwkzAwfIhPatUbed?=
 =?us-ascii?Q?Iu4j4WbPfLvPHWythRQ85LYAvXR2f7xTBoHkjCSUkwh188Or6H6p445ihcJ6?=
 =?us-ascii?Q?UZjVmT+N1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 bf5dfa78-1e59-48ba-21e3-08da1d27d76f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 qaj6Stvi8YjLQETjH9i+AmoZTiR23jMrCMPefNvERTZ1yY/rigUcZfjgbr5yvV8C8/TI2Izd5WkLRAvMDLVgXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8100
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: TK3AZ0IoOX2wG_mfFE36QbDfPpjZ82y9
X-Proofpoint-GUID: TK3AZ0IoOX2wG_mfFE36QbDfPpjZ82y9
Reporting-Meta:
 AAEMs8xmOUj4LdOzzyjRE3od5iiOHQtlSG05ZcRwV9uwJoIkrlkfpa+eJoE+J/tk
 tK3q4yRrUTNuxaz/iyQX8KhLL9DcsGgi4Tj9j+ChIZLDnjIh3caHPB5MboZLq1mL
 6Lks8s8cdhfCSCXYawF0N9OdXZs6w2FwciGO9vePzhcXoilgThF7DVCP2yCBqrrD
 4O/kXVOkaFea+Xt8v12v6fa4ltPjPlFmB90cNOHqCfmeG9qaoEzPG0w0lbYAmHHB
 26kSYcSX4As0pefc2T7/a/HrL7Rg9ef0V83S3fjet0hyL2w2waHhN5hRDCMxPZsy
 v0AkUKDyHrlgsQ+CxPQhyR/NgrYG5FOU7f4nJmNv59wRWHFeyjiIsnHB0G3Fx/nb
 GmV93m3jmnjDTTdcK3y/XiKLeE6DA9N4+o9B222FEy9aACXKM2/nNyWCVqpyB4ir
 HwV+Sf+3dFOnJtOqskjyBqH+jz7MMzXZ48h3iJj5CsJ7EioLTQ8iUJsjB9CfogD4
 uhIksJpeRXiuspj5M8QgSP0x2qEfFnn94ZYqhQnBT+9a

After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
journal init later than before, it makes NULL pointer access in free
routine.

Crash flow:

ocfs2_fill_super
 + ocfs2_mount_volume
 |  + ocfs2_dlm_init //fail & return, osb->journal is NULL.
 |  + ...
 |  + ocfs2_check_volume //no chance to init osb->journal
 |
 + ...
 + ocfs2_dismount_volume
    ocfs2_release_system_inodes
      ...
       evict
        ...
         ocfs2_clear_inode
          ocfs2_checkpoint_inode
           ocfs2_ci_fully_checkpointed
            time_after(journal->j_trans_id, ci->ci_last_trans)
             + journal is empty, crash!

For fixing, there are three solutions:

1> Partly revert commit da5e7c87827e8

For avoiding kernel crash, this make sense for us. We only concerned
whether there has any non-system inode access before dlm init. The
answer is NO. And all journal replay/recovery handling happen after
dlm & journal init done. So this method is not graceful but workable.

2> Add osb->journal check in free inode routine (eg ocfs2_clear_inode)

The fix code is special for mounting phase, but it will continue
working after mounting stage. In another word, this method adds useless
code in normal inode free flow.

3> Do directly free inode in mounting phase

This method is brutal/complex and may introduce unsafe code, currently
maintainer didn't like.

At last, we chose method <1> and did partly reverted job.
We reverted journal init codes, and kept cleanup codes flow.

Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/inode.c   |  4 ++--
 fs/ocfs2/journal.c | 32 ++++++++++++++++++++++----------
 fs/ocfs2/super.c   | 16 ++++++++++++++++
 3 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 5739dc301569..bb116c39b581 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -125,6 +125,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
+	journal_t *journal = osb->journal->j_journal;
 
 	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
 			       sysfile_type);
@@ -171,11 +172,10 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	 * part of the transaction - the inode could have been reclaimed and
 	 * now it is reread from disk.
 	 */
-	if (osb->journal) {
+	if (journal) {
 		transaction_t *transaction;
 		tid_t tid;
 		struct ocfs2_inode_info *oi = OCFS2_I(inode);
-		journal_t *journal = osb->journal->j_journal;
 
 		read_lock(&journal->j_state_lock);
 		if (journal->j_running_transaction)
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 1887a2708709..49255fddce45 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -810,22 +810,20 @@ void ocfs2_set_journal_params(struct ocfs2_super *osb)
 	write_unlock(&journal->j_state_lock);
 }
 
-int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
+/*
+ * alloc & initialize skeleton for journal structure.
+ * ocfs2_journal_init() will make fs have journal ability.
+ */
+int ocfs2_journal_alloc(struct ocfs2_super *osb)
 {
-	int status = -1;
-	struct inode *inode = NULL; /* the journal inode */
-	journal_t *j_journal = NULL;
-	struct ocfs2_journal *journal = NULL;
-	struct ocfs2_dinode *di = NULL;
-	struct buffer_head *bh = NULL;
-	int inode_lock = 0;
+	int status = 0;
+	struct ocfs2_journal *journal;
 
-	/* initialize our journal structure */
 	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
 	if (!journal) {
 		mlog(ML_ERROR, "unable to alloc journal\n");
 		status = -ENOMEM;
-		goto done;
+		goto bail;
 	}
 	osb->journal = journal;
 	journal->j_osb = osb;
@@ -839,6 +837,20 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
+bail:
+	return status;
+}
+
+int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
+{
+	int status = -1;
+	struct inode *inode = NULL; /* the journal inode */
+	journal_t *j_journal = NULL;
+	struct ocfs2_journal *journal = osb->journal;
+	struct ocfs2_dinode *di = NULL;
+	struct buffer_head *bh = NULL;
+	int inode_lock = 0;
+
 	/* already have the inode for our journal */
 	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
 					    osb->slot_num);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 477cdf94122e..babec2c9d638 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2015,6 +2015,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	int i, cbits, bbits;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
+	struct ocfs2_journal *journal;
 	struct ocfs2_super *osb;
 	u64 total_blocks;
 
@@ -2195,6 +2196,15 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	get_random_bytes(&osb->s_next_generation, sizeof(u32));
 
+	/*
+	 * FIXME
+	 * This should be done in ocfs2_journal_init(), but any inode
+	 * writes back operation will cause the filesystem to crash.
+	 */
+	status = ocfs2_journal_alloc(osb);
+	if (status)
+		goto bail;
+
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
 
@@ -2483,6 +2493,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 
 	kfree(osb->osb_orphan_wipes);
 	kfree(osb->slot_recovery_generations);
+	/* FIXME
+	 * This belongs in journal shutdown, but because we have to
+	 * allocate osb->journal at the middle of ocfs2_initialize_super(),
+	 * we free it here.
+	 */
+	kfree(osb->journal);
 	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	kfree(osb->vol_label);
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
