Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5121C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun, 24 Apr 2022 13:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s5J5jAEpcbLmlJ+AKs2/FDwY91Acw4Gx9Ra+f+OAHJ8=;
 b=OV+JFVnNWrYjTiNbiabaedlCKUh5ENiuHRSEHfFQ/aaR7h6B4UhA3SS1VeUh4fVZt8ZeaN4Ctgzs
   MFN/55ZbQt1ZN5d4fvr4TCsmlt0N2mjz/YFxkT+BaYibNBfaMKxdsJob/iVsK9n8H4EEUeJgv2Ji
   qdHAyCw/TzvIUEvQyWdQ/x7JOyh6w/QfOrt5Uwltyhpn3hBAumxER4wKCDHrM6jWsC2hT3H6ZZp7
   +FjJjT8RMzU5eNgu2aPpUgtjowOfmaLcwJ9NeXUK7cSUwJkR+FBrNTKynGYBecsm8LOAHYxq+RFT
   ItYzIUBJFdioyNUQJJh17gWyawDlcpjf+ccYrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s5J5jAEpcbLmlJ+AKs2/FDwY91Acw4Gx9Ra+f+OAHJ8=;
 b=VCwrSnTzuH5ybGOmOVaiblLsNjgXKWTSH6JaD6mQ0RUnwMe7BHRclQyPlW2t1lLDKsINx+eybldH
   g/0smVUZG3Jyj+dMw9CEAEdOaeG7lkAyR297PCIuefTqrn4mqeXYDNRFngpphWnlJr+D67zAIU+r
   CHX+pwaWQGrooO+CoCZhEx99IxQq9OlYk/PLfGFia4jnXMnz69cbGewuqA0Rwi9V6GM73FUbgGdM
   A67upXa9ngaGvbQCZWJbKuIcGlr5mqWc0wqBCVHm7zi0ChLSrbc3NjEx1Il+FqGbuuL/9lZ/eEpA
   5Np2VogdGHu3mwcmnre4oPmYv8kREiYhEkI72w==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAU00MG3HXLAS60@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 24 Apr 2022 13:10:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1650805812;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GnvzV2x/ZyAPTQtImfCdZLyq6O0lqL1NUQBmdYYFoOY=;
 b=LUv4dAtK6H9TkVzCmYYbjxATsvzixXS0EHCKt/ryhgLsQ/vJRX4j7e6xz4M8HjeM77wyaw
 izE1Rsan6aQCWcET01ekAqbWdOCdp5shmBNAfF9FhEM0t5RporYb+kwny9SX/rTg9RjJPz
 nx9Te1WzJEfIyTwaHLAuuS5GISfkpS0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dK9/XmUVNFIOBUNWhW6VnZ2+Z/02I09ElQMAGjNbjXNL50SzC2FRgfD2Z1SKujXdBpZ90v5wvNw2qPe3HhmvIHYjumKoX2Wei1gIkFlgSf8LKbBcFR3Vw0Da29sYmvM4LvkqmFNF/AI2r6ptxigvHBlvADQulUD4rzwRnmxHg4Bz/mm8XaFILXQNNBawXmXdWg0vDzWJWKTI5PD119tnF/RMM2vMahm1VUyB7Eatn4gXgwfSAFaIkCn6Z3uLTwmGzYTguKjqTOzWGzGkzWE2PhW7AMEkDa+mFLyr4NIV/J9zP17/FnDLGpYzfBMc3o2j6+NA8XXf++iRS7bXYi+v5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhR8a0NcW4XrC1mgYh41IWwxMdgHp2FzGPe/GipmiPA=;
 b=SsPuUtnsoruSLb8teR4AHYimh0WFuJ+xbPSlCfm961CSTAIwCxeCuqIbZHqBHGZsFCqYRNFdzcmAPVv5UknGC0HMeDQK+cPwSS2haOGOQwKwe/TySNjPliRjaiGtJvgfnaejJOUlQlgXoMidWFWuVIWmqZFjTKyRxcnmUKGH280skGATgSHZeLgHN/zVAQ+L/lT+7YCBpIpmQd7kWBWpKgr78uFfKYEofKv4Av/4uzGNvSXmUv3KpboMwTobIfN2beURZYpAsTGotMGvRS9kwNdb45IauZYIf0qu5bIimAHl9VVWDF/W5fLaMi8NVbTD69ykcHyk9/mHWZnswZBS3Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sun, 24 Apr 2022 21:09:48 +0800
Message-id: <20220424130952.2436-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220424130952.2436-1-heming.zhao@suse.com>
References: <20220424130952.2436-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(66946007)(1076003)(4326008)(2616005)(66476007)(107886003)(86362001)(83380400001)(26005)(186003)(66556008)(8676002)(36756003)(6666004)(8936002)(38100700002)(6486002)(44832011)(6506007)(2906002)(6512007)(508600001)(5660300002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 13:10:09.6824 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10326
 signatures=694694
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 mlxscore=0 clxscore=190 priorityscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204240062
Subject: [Ocfs2-devel] [PATCH v3 1/5] ocfs2: fix mounting crash if journal	is
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
X-MC-Unique: JMaxU2yXPmeRRlOl_iuhBw-1
X-ClientProxiedBy: HK2PR02CA0173.apcprd02.prod.outlook.com
 (2603:1096:201:1f::33) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c02a0aa-95de-4472-7391-08da25f3c261
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3344:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0402MB33442B51D6E9C176F20E450F97F99@VI1PR0402MB3344.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 yIucC7/dzTrHPt86QArjrHGX+nUsaJJic4xVg9OOFqkLHqqmH3HprIppt2YRw9jngrqw6Yr4a1dquNG4UF8YGq7Jc3qatRGM90BzKtCKXAlV1QXiRQB24SsIgKGz353Ls/0sh38/3SCtWMq9HXlPJIaCAgtmDdnMZpqyZQBurtaL7E7mZUmh8bB470ArZoxfEUJpHs+522jGSNy1KhUFzImoPl3wd2hdZSiZlDPu4Gp+Gk/Eiz/3SW7DPOIW9MaUR3u0mP4gBEgnSdHbhNmZS92rXWhn2OA47uXAQtUWauiRqRjSApYzVqgocBI+ZXMIXR0Bg/VRyzDNq61VoMj3w/VwZfX0NOORbxwWEqzyYH0IMksEd70VJ7+craAqK/TtX1s5iA6pIIw062Tdurus14NWBNghXKgzT2RlD8+OUbqhnnBVZAG0EGQ8JfPpOGqvB+0DbNsCLeNHB0V0vyFKvQ+1GqBX/ZdYgeXqj5RRdj2+iZmcB9ICIWfiH0QYQY4ewAfUMUFo64LMfwXfoh8U8/HYWHjkPuMYh4mcMtTv0zG3jTU4BGh4syxSruxS1Y3Wd+7BIxDJm8khxtx3ckSfnYj/dxc6eIxHeMpDpEm76M6jv2ffVhQjRDILDKGa5R2ZSzwMH6t0R/S2HIpmJ1KAXQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?72Gu0FZ3ph1sYc2cyq7ku648XX0Lu/kEwcnUYTa7m6fDEuCH5cQOU7UfeNzL?=
 =?us-ascii?Q?Nbzm6YGCtl/efYurm/cbXeYS2DL42uIUTHCVYFwO2PgHmxsjW+zeK6nqnoz4?=
 =?us-ascii?Q?vKowpRwSyJMiFgkctNw1BzbhSFGiK3O91+qTIcRZEBF5OGCZawAMFHaGFURj?=
 =?us-ascii?Q?tK7M70fpqOILz0GWX7JgyfRSBW6nMu98GxLVEOD2htPNd/S+hF/o+CrKSSz+?=
 =?us-ascii?Q?F791TBhQJLVnRtvWcmOmBMOFowRwiX6Py1qNRo1aFAenaGLz7f7wxlFTZLTv?=
 =?us-ascii?Q?r3falRU79fGyBqv25+TL3jAu+78nxi0K8EJ+wWc4lY8Pk20Nb9vswr64AXI+?=
 =?us-ascii?Q?WIqozZrvCEnddU627G+0gnAVffTeYZBeebfgTE903ZzxnnHLjJW7T3enyzan?=
 =?us-ascii?Q?wbrIkRgQCSqKY23YL6fKN3jwGPwJfMqsL173vwN6uAXAuxIc5J2pnCRCUoiK?=
 =?us-ascii?Q?gqh0mrCR6p4orJxUszvjdXkXSl8ZtuJ9vtiJH5T9oq69pMSvEJBgHQiRAalX?=
 =?us-ascii?Q?00XcNNYNbrxdzfRofalqjUeTOA4FxMdrXhPnj8Rw0tgyp2CHqYFyCd33Na4I?=
 =?us-ascii?Q?fGrwUt1tS/LR9l+GrBXGMwFJDSVwo7kfmwCHB9W9YHvqa+ONc0UFnU1TndaR?=
 =?us-ascii?Q?on/OLSJ1oDhEbHgoifI+SVR5vJ7zVaT/qbvry4qxZxIwmphMn4EaBqHAeQf7?=
 =?us-ascii?Q?Zyv69nUYSuG1iMXajxKayOdi2+/c31GskDWk1hJqfKWjVJk2/p2ENsNgO8YY?=
 =?us-ascii?Q?Mto/o258r56M5uzlua6WSVficiFKhXWOQtKhIPHXu8qcHrVDYV5JsHuWIRHC?=
 =?us-ascii?Q?WeP8+zJ0qxwgg5CzTFl9kmiVGDboLUizJoBzhnV5vm+Y+fiEhcnMXWoxETB+?=
 =?us-ascii?Q?H+DX+zoJXuvXuAB740qfy1eG/oeAgFl9gucAksCrcm691p65GpT02Ex39g+q?=
 =?us-ascii?Q?3ryLYVGzLY9UV/27JuMzZgGCOPG4TyYMP0lxVAIUAwYZvH28ph+IMDGeUcUF?=
 =?us-ascii?Q?+BeaWo34pWHZpIroYlPiOkwb/RiM1y+4kQNqREOhgvV9uYDee9iIkFPkMZQG?=
 =?us-ascii?Q?ZBC5YYVdPNEq3T//qFvWnuJne6DowtAeFcRU2fliDO1XYoAglhEIbnXTVRUR?=
 =?us-ascii?Q?cMnaT37e/DJmwe2Du4vTZspulwtqehj2qO43OxYcPxop9w+kFaUUJtT3GL4O?=
 =?us-ascii?Q?wnPWvmNU4cKkLiMdT1fpkSm+LbenT5VoxXdyyxqERcvoX93+Pig2wXnAd/JE?=
 =?us-ascii?Q?A7Ij8N2q6JY7fqi8WGnRzzrLTKtFdUEztPhugWwCTlQCHgn3nrmIXmqUIRAO?=
 =?us-ascii?Q?aHYknB5aIydT25hutsGPDT/3kwVWif/1m8GVnLUQU15wnNvp6XYx3KpWX65F?=
 =?us-ascii?Q?Af/L6QK2QamuWLXvezBaex8HY4z1ymqma8rWfIIPnBM85ciLD4WyY1PYQmna?=
 =?us-ascii?Q?l71gwyuVAxzO5aes60wGqsGXgueW97oD0UrGlsoRUZjq44D4CsMhsMXM9iqb?=
 =?us-ascii?Q?xlWtxJuwPp29vuvwgzaROILzolWD6+n3V+v5t9C0l/vlIcW6n1RZrguKVq7c?=
 =?us-ascii?Q?K9JdUiwiff/utTf03PpPEOeVMx0eqdzi5qijiAAvn5ie6fRo+1dlCkei/t/6?=
 =?us-ascii?Q?ql0ALWUL5zuU2zkMDJkAQ7iL5kGigQXf4qfwDH6ZcvbWnMkTHmfnNA0RA0oh?=
 =?us-ascii?Q?1nZdua6aFrfkPE1Rl9/HBjO6Tj3MmfKBkaVGZ2EAvuT7tqaSM1tYL4sBE/Ul?=
 =?us-ascii?Q?AOeEtB6h/Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 5c02a0aa-95de-4472-7391-08da25f3c261
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 NM9eQ1euQrw9DE9k903OmfsxE8APJHT6qVLYTkqH76B9ArmKKF43FGAYISrencoxgAuH9y5p2vmGmtJwHkTNRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: AY6AfS3n_g4FCknrJitHx14yjz-Kz4L2
X-Proofpoint-GUID: AY6AfS3n_g4FCknrJitHx14yjz-Kz4L2
Reporting-Meta:
 AAHx7be8YjHjs2s5BNEk99zUyo5oxrzYI1Z6rJEqzg4ih0Iz/6dPA6lBrUj+J6W8
 CcrwO2VNZS1hwzT/fJ9b32ZgYKPwJfp+KtTHq+I+8G0WGZ84xEJ+NCxXJLJ4ujSQ
 5ROlkN+9Jp+vebvW+jcP/oYl7Ak6I9BpUj4zf41QnQ8lD3MJGDKSZ4dGQluvhDJQ
 dz7x3Ji7B5O0e3abn0nn/AUjx5S3M+WGpiHsITw8gRHw5Cq5NPcwem57Uo95paFu
 HWba8RDzZj8PB2ahTYZa5N5QNzvg0EdfMalYY5UsyDgJnkpYXXzkJSMmDfmiJOMC
 CR8dT7gKv78m4eT42A7Aqi0Owukjwx7ZlhxKaRf6WD3b9halcsU+s+gw+5BB7py6
 2+hK6T1+Qw+2HvIZ6B77B9W4tmE6kqOmnVvch5xQcOartdPpOQ/Ko8QuGMBb2oGw
 KD7S/QUBBKcMw6FLqARfM/bO8r7SbV865EEs2rqlZvv+PJlhL1h5kVuKhHD1127D
 0zwYr90qah7XP8uvkyYJ0tqJfIao2jtsHRu5924u9sp1

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
 fs/ocfs2/journal.c | 33 +++++++++++++++++++++++----------
 fs/ocfs2/journal.h |  2 ++
 fs/ocfs2/super.c   | 15 +++++++++++++++
 4 files changed, 42 insertions(+), 12 deletions(-)

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
index 1887a2708709..fa87d89cf754 100644
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
@@ -839,6 +837,21 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
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
+	BUG_ON(!journal);
 	/* already have the inode for our journal */
 	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
 					    osb->slot_num);
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 8dcb2f2cadbc..969d0aa28718 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -154,6 +154,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
  *
+ *  ocfs2_journal_alloc    - Initialize skeleton for journal structure.
  *  ocfs2_journal_init     - Initialize journal structures in the OSB.
  *  ocfs2_journal_load     - Load the given journal off disk. Replay it if
  *                          there's transactions still in there.
@@ -167,6 +168,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
  *  ocfs2_start_checkpoint - Kick the commit thread to do a checkpoint.
  */
 void   ocfs2_set_journal_params(struct ocfs2_super *osb);
+int    ocfs2_journal_alloc(struct ocfs2_super *osb);
 int    ocfs2_journal_init(struct ocfs2_super *osb, int *dirty);
 void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
 int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 477cdf94122e..311433c69a3f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2195,6 +2195,15 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	get_random_bytes(&osb->s_next_generation, sizeof(u32));
 
+	/*
+	 * FIXME
+	 * This should be done in ocfs2_journal_init(), but any inode
+	 * writes back operation will cause the filesystem to crash.
+	 */
+	status = ocfs2_journal_alloc(osb);
+	if (status < 0)
+		goto bail;
+
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
 
@@ -2483,6 +2492,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 
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
