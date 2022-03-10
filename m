Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16A0C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 10 Mar 2022 10:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vNQT8ixkb1X7te1n49jiXUlprZCCrOY085x5opJwtz4=;
 b=u/MbYTawdlWZKKfrwdqxraZZF4Y6hsvouXLNG0jodxuZN54ol8PC7xXY8ASHJ9XkCG+R14Wt5xMC
   IFP3QyHGyqbt1qEdVwC7fQTarF/yLWocnTIPEGrxXM/bmFYxRhsih/JYNyB1ot+ivhpwa3grxlyK
   PskqL9vgBu+mR9VSRtbExvUmfivIVQHMWFZN3vAJGy0iS5ytGFTGZgTMpd2fE7PhQjh/dLd3vNlK
   JoC6jBkmPdqklecCVZT6ROjxe6LuvRXJa0IWm9rySsPnhdO1+UVY8leANeiFV4Tr/AwcTjOeZKts
   rprG/Jr7uhP452CCu4MpSsltUDYLmdeOqcVbsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vNQT8ixkb1X7te1n49jiXUlprZCCrOY085x5opJwtz4=;
 b=mI9KHf3Rtt44mtNndEzEAU8KQyr70HwxLQ2cGMADcpjlkDH3qj045bujMckXgU3WlYcua9AJbhWx
   WUyTxYgk0LTRiHScfZ36dKdx9y2f6cXtW/sdPzbSIJtet/yPbd9caZjbrhZSjcPcTLQdTR6/Q4l/
   VormhVQFFnByUnHEr3FjT8VAaHFX26zaRNpnQF+H/OWIodatjtGLNB8+dCzIraXr+X0wDSJVvPDk
   pebimp+JXHrt2zUSmQFpvBU4IKYoktaTmLnqc7voQAY0A3nC2qxj3yh/CiYZb9eY7DeGN4qI1Csy
   pAWXrnni8JMe6UeytiHDwp3BpI0tp+wdEjzCkg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8I00EI3ZURI2C0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 10 Mar 2022 10:59:15 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=heming.zhao@suse.com; dkim=pass header.s=mimecast20200619
 header.d=suse.com; dmarc=pass header.from=suse.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1646909938;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=lLFK+8S+ODT0M9a8iHgbMH4/g7TthU5rHlE9JSH08KY=;
 b=iLFtaxOlt+URU510CztEq8lYYwfHQGqQ0SKnusjSAiFKYUBQJx9rGU9aXoWvKuBGXogqwV
 N7svqPd2Xk7eYHFvWAHMvgEYwpmSmc3P3a/QPegtVXSiseRgOpFsoDQCtLBz5rIx6SVbwv
 AlQwzHfLEMm+MjKveeBauO6l883vDxA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oThjMHeU5uqlU2k4oCPDP4d34see5bixD35zKCft9Yai+LHmpH6OKglUeuxUuzKhbPhZdznL1bOFD29XVMIdokn4Pf1uyaNnInXXu4bNr9VASBUglShBf8NTIKf4OA2bp96gXGmI+UlNgcdH8hsJ+zcl8GtTqLNNqwI6Wfglqc9/m4FurtUZXk/M5UN5uzP5XOzbQIvcYvfpyP0gwnXn+YsMY7hyiea+xVkBNmGYm6XMNLiKJ5pHSqAhmiilXZ9AyTQWgh83ttloSu9H1eQsZUlnD0DrX5xolm55HUP510mGsELfT7YkZe8O1Ms+KbYK0xTt8nRWS2zEWhxvdw7KWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fndAzVINxpkmXN2PL0o3jgMUP9wHW0BU3LhJ/dit/Qg=;
 b=ek+EfdUANdLdvjVhoZHPIaQQt8Y/EvwnhA3APq7gX2BQ1dHNKgllOe+r34ALsoEyQaTBEgT7iQi9xjO1KfXW1YN2+SJQQJx8X54DM2VPhMT8VvcczvLiVIS4HJi53+lqMNs8k0dutXjk9j6X3pV6ypOv+xb8scyyis+GVewplSPQUQOuVSfsX0hJt6AZ6uL2IrZXYgJ7jEBA/kyFFcBeTJ5JdOqxm7RwV9i7zVDQbVB6qZn8fqGNL9t6dSCRPY7zTBvqjmmN1fqYSVOmjTH3mwuL/GTWbKr2CHEguKCkshILFSfoPYJ+BGngB7dzz+2Df+APj2qpvptONqoSWLAnkw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Thu, 10 Mar 2022 18:58:50 +0800
Message-id: <20220310105850.1817-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(6486002)(186003)(6512007)(508600001)(26005)(38100700002)(8676002)(44832011)(4326008)(66946007)(66476007)(66556008)(8936002)(86362001)(107886003)(5660300002)(6506007)(2616005)(2906002)(83380400001)(36756003)(1076003)(6666004);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 10:58:56.9781 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281
 signatures=692062
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 mlxscore=0 priorityscore=118 suspectscore=0 spamscore=0 clxscore=193
 adultscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100058
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix kernel crash after mounting	when
 dlm doesn't ready
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
X-MC-Unique: dSzK3Ei7Nj21UsW43s7YtA-1
X-ClientProxiedBy: HK2PR02CA0222.apcprd02.prod.outlook.com
 (2603:1096:201:20::34) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1517f980-48bd-4345-45cd-08da0284f957
X-MS-TrafficTypeDiagnostic: AS8PR04MB7766:EE_
X-Microsoft-Antispam-PRVS:
 <AS8PR04MB77667CEC4019BFB947E9C611970B9@AS8PR04MB7766.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 VSNeZIKDKMg0qEQQWBHkx9OqOsjhAE+HRoN9yH8xzHfqyBVy7S2G6YGmAlL690kSDWYBb/yQ9OJXz1SwiQ0gtG/UzLuZFOzEdJrvVL4BIwyvR6pvqSX1ICu7kOzKYs5GGcP7XiukZia5+kVcMVPS+a5XHcNVQV1w3u5CTT4SuIrIn7M19K8FvRmIkfmiPjmCtP0bv7Tmwtw+StZbBtU0YGCYN16ZXCSroTODpbm6s9CRx3RAfC/XyGOJwY+bgpzop5v/rYnvUm0iQTF0hGKBvNRJD8PSemQPNJ+ns5tdgnHC4QadqglOJmqqHNweJ3SwJsD5WOSTLCmPJXb1aK9SefIdmQeX8LtTQK1/SElyvqsMPG1821A/KCWErvtUo69VlSvRU6sezCayxyJrfLWq5kvwbzNMTMj1+aO29lpjrug6ByLHOeAYcjg10kpHDUdMDeyv5+0F56i9egcfCZ4mg5QPk9WUZZqzIXa+JX/0scLCv3JvRvIAN0mA9efsDjVASzmesbguCFK/nlFcvvcGgJAdbXLOYqcnkBYRBolUIysw9YJXmm6Bmhj90ad7ruzVTxKypjnJ1H0EbDij3/y9NBJf7S3LUS8fV9JQ/O6brhHwA9YU7bj0WLOw7tkeS5VVLgOBIf3Fkei2Xy+YM/omKw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?kch4VReeMzbW9JDSejbV6nIyv8jiOcjX5TCFOpCypN1q/jWzzhpx4ASov1GF?=
 =?us-ascii?Q?bGojCQs7AfcQcOcSPH2vLamYvjDn3RnjnhCnhaBamYCcbTrNBsZjxTU/lxqo?=
 =?us-ascii?Q?aszVaoeHZpjGx14ERHaCrgu/T1lhrdtltfEFJ7K8iQc91eUBDYBhKhSXBJsw?=
 =?us-ascii?Q?LJYtVX3zCx41v0uACm5a3/UUoTKpDlEpK2x4wlQsfBfxVxPjgLTyL3tyIsUG?=
 =?us-ascii?Q?1u6KXhZGuMMW5q3/FZzM9eIdJ1v0bh7YS4750Sluf0zNbgvQzxBS7JlevVYm?=
 =?us-ascii?Q?3FQESN9nrs0a/Ha4FOlgyZzgxg70DURRzSfl9DsqV3bAKW/QjJAcR7UJOsdp?=
 =?us-ascii?Q?jGXaHi2H37uXz4zJ4j+myExm+y5xpLO4c83eu47jflAqiCixlEwe2r/ClBTY?=
 =?us-ascii?Q?xx9cbZ4SUoRq0RecmT5zvo5MweQqDvGltKUL89CN7aB9KewQsArdv9Nxizr7?=
 =?us-ascii?Q?buGoNhNzKQ/f+sG5xbSE+YmCjGIqgt4s9tX1SkgcFFdpchHnxvtKcfpfFWQB?=
 =?us-ascii?Q?noCACDSnz7QGl7TxYrz2KwEcXfuzUd6MjC+5aHg2glLx4zZ0cxdhcsoA/JgF?=
 =?us-ascii?Q?wuW7OA1OFGyV/RMzO/aiXJHNiogvd/l95VsDa+/GujtISxrTVPF1eY2b5NEf?=
 =?us-ascii?Q?/eYVmuJVrbnWI2YSuhWBl3uG5MWxu1+hnntXaCSrnBk1O/vN0389I7M/ZQGg?=
 =?us-ascii?Q?AtKKM2N94w/cPH7Mzf5CRtFuk7Qa+iHyNwQ3JMkx5F8SD9ALRzdINYEu7wJS?=
 =?us-ascii?Q?wtjZQDsZ6pX/f+LzxeoXaK9fH5rkIJ+mI4XOqjl8MnM6T5O3HGJ42X+q1oq0?=
 =?us-ascii?Q?oTxwWc+4lU/o6yDUDOiy0zEqrnBjewIgr9GkAXVG2DJ+0CzpF6BBgJtKXJVt?=
 =?us-ascii?Q?yT9YU+KSclu7Lw9WG5hrUtLZLx0QcSBX1dPcgJeyrNQLjXk49GMM6yIfDLUw?=
 =?us-ascii?Q?QasRzrQkNx5b5tedotUs9HKqOefeMDEE4MoQ15/Fnjb9Dve7gbXwu4uE0dR0?=
 =?us-ascii?Q?zwBG6bFMISojxfNr99XZQ0dxftHB/JjUrmLoZ3OllhiWNEpHwWO4l3lcvnC+?=
 =?us-ascii?Q?YNaALGy+7Bwn2vovVnSuao0yncQxuhPUXZtpe9z6jnYC3bjWYYl/aRAH3oQ3?=
 =?us-ascii?Q?XpaMh0cUPNHNQBc65BXESH/7xbGmp66OIxiwxPvmXonSFT3Dhz9/hS8RYtRv?=
 =?us-ascii?Q?7CBeVoSCgaFCUBud7gbt/Hu8ZF1P7pxTpBvCD0EEaDe11HRMQ7TMH6XZ3p9d?=
 =?us-ascii?Q?kkmefV8urIjDlDiJdOE41QuPu1geowPhAILv1xGulT3RagG2wi7DcamSN4vp?=
 =?us-ascii?Q?cQSY5rV9jKdroAGg2+bf5mCPzkRfDUWd8S7Nnvk3i0pfmmujwnTvRjYHT9qV?=
 =?us-ascii?Q?6GmrlP5mJdt31oBIMVW+wRDHIqQxvCcasPjUmXJWmBPpkVO5iZJcvAKtyLqg?=
 =?us-ascii?Q?1GJSCuLW4wTeSkbJIpijoVN1QfSHi7Of?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 1517f980-48bd-4345-45cd-08da0284f957
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 T+V4QPIWFIhihIUYaqvvJMs2m6qSeAHLMuOExIVS3n2D2D7ysuBht64cnPKLkwK/JoPsvdUsmRBaIeHPVW3I7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7766
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: bUt9CF0ze2NdCmJ1gKMe9m_noF40zaK2
X-Proofpoint-ORIG-GUID: bUt9CF0ze2NdCmJ1gKMe9m_noF40zaK2
Reporting-Meta:
 AAG+mQfKmBO9aXmQ8wOFlhjxrSvkUuM80DZe/eiS01zeTodRZpFx52Yndet34cXy
 H8ceuRd9EzFkr7cmpI9X3mR36NYEeFbFeAoaFHikupGphUxfXAG3kHL6IAKqnuNV
 7p6PhVezjpjmWvnxrg7dQkNY86bcS6ns/xWokWPU6cSmUnxdAaFuFNMIuAdUaJXs
 XMTOmTPtadYjhh8PLbFCxMdnwD1kPCeJB6y51LxLmbQDeWyupmaW46lI35ngrWuA
 Q5phqnympfqvJ9uSJA2rb8m68h/CZzyBCgiNDpfKgVqUMQla6Bh3pn7dw13Kg5Lh
 W85MmNmUbMbeRBFueiRjwIagaUIFb8ytR0OOJ/wjsPWGPyvWLf0koA9zaw2/wJ+F
 KwCAPJG1ySkfBRziIaqjI9Nyu88Nw04EmQgZ4xKl1hXp70RNhGkPAsvkPzitm6Vb
 1PpFQwQPXCVHMYge4djNmFG9B0pJ/e5rhMYoRUe5LtJn/DQgLj/SzNCDFC7fvj7N
 RePIb4SRye4WfLAT77NeREaRJkuk05I/j+C4HQ7Vvun3

Call trace:

  ocfs2: Registered cluster interface user
  dlm: no local IP address has been set
  dlm: cannot start dlm lowcomms -107
  (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
  (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
  (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
  BUG: kernel NULL pointer dereference, address: 0000000000000030
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1 openSUSE Tumbleweed b40...e84
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ...
  RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
  ...
  Call Trace:
   <TASK>
   ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
   evict+0xc0/0x1c0
   ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
   ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
   ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
   mount_bdev+0x182/0x1b0
   ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
   legacy_get_tree+0x24/0x40
   vfs_get_tree+0x22/0xb0
   path_mount+0x465/0xac0
   __x64_sys_mount+0x103/0x140
   do_syscall_64+0x59/0x80
   ? syscall_exit_to_user_mode+0x18/0x40
   ? do_syscall_64+0x69/0x80
   ? syscall_exit_to_user_mode+0x18/0x40
   ? do_syscall_64+0x69/0x80
   ? exc_page_fault+0x68/0x150
   entry_SYSCALL_64_after_hwframe+0x44/0xae

How to trigger:

  tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
  tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb --cluster-name=ocfstst

             == there is no dlm running ==
  tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
             == kernel crash ==

Analysis:

After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
Journal init later than before, it makes NULL pointer access in free
routine.

ocfs2_fill_super
 + ocfs2_mount_volume
 |  ocfs2_dlm_init //failed, osb->journal still NULL.
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

The fix should assess osb->journal before journal operation. And the fix
should be only related with abnormal case before ocfs2_journal_init().

Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v2: revise commit log
    add checking in ocfs2_dismount_volume()
---
 fs/ocfs2/inode.c   | 3 ++-
 fs/ocfs2/journal.h | 2 +-
 fs/ocfs2/super.c   | 7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 6c2411c2afcf..3826ab7eab3e 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1205,7 +1205,8 @@ static void ocfs2_clear_inode(struct inode *inode)
 	 * the journal is flushed before journal shutdown. Thus it is safe to
 	 * have inodes get cleaned up after journal shutdown.
 	 */
-	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
+	if (osb->journal)
+		jbd2_journal_release_jbd_inode(osb->journal->j_journal,
 				       &oi->ip_jinode);
 }
 
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 8dcb2f2cadbc..1610d49b4112 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -189,7 +189,7 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_mount_local(osb))
+	if (!osb->journal || ocfs2_mount_local(osb))
 		return;
 
 	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2772dec9dcea..01f1ab7c8de8 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1886,9 +1886,10 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	/* Wait for worker to be done with the work structure in osb */
 	cancel_work_sync(&osb->dquot_drop_work);
 
-	ocfs2_shutdown_local_alloc(osb);
-
-	ocfs2_truncate_log_shutdown(osb);
+	if (osb->journal) {
+		ocfs2_shutdown_local_alloc(osb);
+		ocfs2_truncate_log_shutdown(osb);
+	}
 
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
