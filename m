Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2B4C433FE
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cUCVwtelPVnJgncUYrGW3GF2uaPjoFOgkZAo06VaIB0=;
 b=hmKjqXNYmnsMplie5QVKu91hlpNfscCxgunZPGcbQC48izBuaocCfsNral3gNvjrcgHRZNuDIjPe
   3qdZO2JSGBWR99/jmb6QrS4DH7/pSrpTScDwSe4//hDwbzyRY8HqBp69UP38prR51Ag8IOhtv5hV
   nVBO3GgukgL+s4ktbONu+xldB7MrqttZgxSUpMIS9Feh6/5zOEyrKWOtgw8GU5B8biFWQywcfhKa
   Bltwmh0FfAOfiPSAbKyBnxEERXAGLGO37JdyGahntfGBEzW6vWlmgVhgRr8CU8luG+MoDJNHkUjX
   KcrFJtLF/tJslDrUrrO4I72JNXwsABCbzecEhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cUCVwtelPVnJgncUYrGW3GF2uaPjoFOgkZAo06VaIB0=;
 b=G18ioiYalEplssA8oLZu9t/DJJLQ8P1bni+3vksGQ38cArU6ObuSQxnV+ns0bacsuSTTG41nnQx7
   zBAGJNOsDKP++nN70VI7AXsJg5JGCqqAgpjzwAGyqHWzvh7hFK88a0AtlhgcT7dJfo1RMf99xSUQ
   HMVAdBns11hqwAJshR+Z+GladYH8mu3njJGLQYXzIImSv5dp8N8Ev0WdLjzAir9klrInTHFHifjZ
   7iDPrlV2b3O+5To4U8mD130FLtTRz6X5aKyz02x4ci+CqXJbNmPNmnKqlVldlwz0AueWKcMMvIwk
   Yevt4j9R6McklTUGVxpcSWZrC3O820En5X2JuA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA000CG2NVL2Z40@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 08 Apr 2022 10:30:57 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649413841;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=exOphKurtM7ua5Bw1r9W7OtrmIMK5l0dVfJgaxXPB1c=;
 b=XuPDuBmYH063A8OOkcPD/U+pD2lsVmHm1NsfCYbLNBZdQV/FbeyyeMOSP9pIMaeBgDWhUG
 gKJL/pzbTAfJIDqbEBCfkfwRfGttW/lLYdOANfzlhDpJmOhEPYi2feDw8qA4vSQvzPwVJE
 sNg1d+qqJGQqTJ+jbxahoV2bV0hBb+Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZI/6Y3k0GB+RbvTTUbmMa5fL/nGcdtnzFmBHFFCF59UcGVvh9ty+d1LRwBULhPdIYBSHNsEvNo34qBvspqksAut3X3ueX4b5HQ9VIhDfgYH+Gx+WtU+oulEg7qnUck/EBYotGFCohQuMyIcUhFbFiY94VJV3ZVWztZ4WrmZip+CuqEK6Jylj7JER35QLfh6MDhqbvFgaMO/jYLr2O/zmmRDrVB+bDU1RhZfokDkLtWRsZsAS/3GduBU33uqvBoi+mGa6xNYUhBkZGaCufrmi7kwh5e/9hf4qfidvpKuQ/vJs0lu4qDjzUz4xNnCq68IEgs1GIJnErwcSk/bprbeAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FuyWX3mjgINldw+qDYDDe+88cMlCImF2iHoAElQu1RU=;
 b=VRUyTGrcoYbpXYbescdzT7O+p7MWhldWwSsB2iJRnIs26Xq3V4M1iSug1IHuX7uqERZuzYRSflG6+vwwrlKgABHo0tJKH2TglV7c3ms4lYnZEB9nQRJ4liWtVMtkucTzqrgxVmg9LfatD1lUKBYupgU1XJV8t7ClIm7vkOXf3g0UWxMwubYeRLnbxrBbjzYwKD+9ip92duREu5mLMAyAFfwbM/iD5+R8OtdBcuq84Oo1JZSGl78dZ6ia7B8Yqw0xixeW2VV5s1hojpjWLEI5uoegEA7T5/kqA0psVBHWX4gRb9BX2r59VAkhpVDV1kMziFjjgqF3+XhZYnJO1y7yMg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Fri,  8 Apr 2022 18:30:08 +0800
Message-id: <20220408103012.1419-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
In-reply-to: <20220408103012.1419-1-heming.zhao@suse.com>
References: <20220408103012.1419-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(44832011)(1076003)(6486002)(316002)(38100700002)(2616005)(86362001)(107886003)(83380400001)(2906002)(508600001)(5660300002)(4326008)(66476007)(6512007)(66946007)(66556008)(186003)(8676002)(6506007)(36756003)(6666004)(26005);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 10:30:39.1195 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 mlxscore=0 bulkscore=0 clxscore=182 phishscore=0 mlxlogscore=999
 priorityscore=233 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080054
Subject: [Ocfs2-devel] [PATCH v1 1/5] ocfs2: partly revert da5e7c87827e8 for
	mounting crash issue
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
X-MC-Unique: pyU6xfmkMsOf38eroictKQ-1
X-ClientProxiedBy: TYBP286CA0019.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::31) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1296a23b-e694-4feb-beaa-08da194ad353
X-MS-TrafficTypeDiagnostic: PA4PR04MB7840:EE_
X-Microsoft-Antispam-PRVS:
 <PA4PR04MB78401AD6FEA43BDB8DE5243797E99@PA4PR04MB7840.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 dnCF/lmDfz6O8oJHGH436fJCf9faOXWHLBXtau+txPfR7D72sd6542pW1rzFoGVXlN9CsrGL9zsTEUHDKv1BcIm5wuVP6Z78Dce5KU9FKFCDRpsoH37iXXndAV22zVbrLUJxQMhzGdE9XbefHu2t3d3uu1z0bt/Xz6fcqfVMXjaQEu7WeRv7E4dWKnXBZ1xpuRDvUy0T49b0Oji15xN5Epw0ltOaUep1EJFAVsCkAzONLoEmg3VJdeDANGtxYemVYoVHAtSjvSzUVmCljf1We/rrYqmEKWbSzCrpKx/6iAmIkoPjUQSQvgU4WPcb1uCGdhzKw1VftpfMn8T80LMS1qk+PtD1k6t0Y+q/FS+vml+xkiLNL967y4K+jFBYP9C6KVjW1ylfZwSwFD2/vmxCDIH+ppVNWqd923xk+OujFGA4ytj3LQtId3ASg2XCHUW5mltls9fiblJHF071GLoywuSOv/1+c0sBDIjI+GvlMtZyBxAwY+SWfrzGgosuMigsEtDy2apPJzZq2nA8+jegeS0awFoEKp9FkiT8zMb8yegaW187DI7Kl4IYZgnikXJ7a12Z8pR3eVqLIcPQz3k3DH4whO3L8bdjL72X4+UocykZQIiD0i3DXDJDih+zPZHSyb+PNIJYX3joGvRBlvG/UQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?usEoNbuGoscQRYfI93KmbZHCC4WQ+/wn0NyFrPI9Do+eSE//K0QFkM+6iKIk?=
 =?us-ascii?Q?X5zLGqlXF+NiWqkH5sjm33rqcZmPXuQd0wmD+Nhs9qcTE044C96RKBHLL/7B?=
 =?us-ascii?Q?2MpwHLiGVK8BqG6ykGI0MH1BG7LuG5BQVPmJH/S0QUh1OHRiq0DA4q4ApKRM?=
 =?us-ascii?Q?RV33D/+d0v5B5pwsGKH8H2pFOnb4/Yn1YqxgGe/0y4Pys64Aud3b2Bul1oOD?=
 =?us-ascii?Q?l6zR6KwwZi6dIYVOQwraaUlqIsg2M3N0ZoxdWGSA13qcJDOKaiYiGhiA+gI5?=
 =?us-ascii?Q?64i89WHXWnrcVs+tO30gvdLYZXd46+QhSK24hSndQwFWgXDwDM0ioipkQe5V?=
 =?us-ascii?Q?k7wnBXUYyC42/F9Z/yXa8W0CFy8z2SgafsrmVL+KF0m328i3hyzBh0eSQ8W+?=
 =?us-ascii?Q?2xJbQRdAWyMkfUJGV9ogiPkLEkUTzKIaLbyjqFEw73McCK1lNnM509iM+njz?=
 =?us-ascii?Q?YnhrWj8bqxBvh1AwkGjl9+KjhciEWCBqd9vryP0P50z+PmLzEcmgkzo6kbTQ?=
 =?us-ascii?Q?+4GHthDhMJubsVvBGST9QS/advEQlX93cqU9VOGAfyIoRgdwPh3VN1JigK45?=
 =?us-ascii?Q?rJ0rbtlHK14CBPLB1ndr57dmqJKZKWK3fUJWFz+ZZXr/QEJ80aP4sjtDiebX?=
 =?us-ascii?Q?lLdGvM+n4IbW6zEJ8YZi+vNaqroFSkO8S+2yBfPw74ppRxRd74hjA3HRKOCa?=
 =?us-ascii?Q?gw/mlSiIOidA0MssbZpuP9LHVS4reCZPAWHSlvxxHd/da/XiMPLjv2vZ++PH?=
 =?us-ascii?Q?o+x9/l4vEqJb4k8ypBPpx9HqVZp/sf9Lae9kRDU/JB2POmt7kViRIOQuqZGH?=
 =?us-ascii?Q?aBKO8kwBhUoc7HliM5QPNPkPFsOtmI0ofzPwdn7xD9cdlrtEg+0Q12b6cUdh?=
 =?us-ascii?Q?x8NS0Cb9qmwf30DhlVsjXJXd8NYPaRArG0ZJIZLL3MplK7d7hrE/8xa5gsGK?=
 =?us-ascii?Q?UT2HyMYcausTga3gF/ppBSLgFIA4CQjwmdM/jPzYl6NsZ5P05yi+VaWGJ/FL?=
 =?us-ascii?Q?n4vZndpYQiH6ZMrzRnOXlubYd1MIUuS6Ri7NGEa/PadFTyxY7oi3YhoC/ixV?=
 =?us-ascii?Q?2XmF84oqPKFUAN7hw1jDc/ylagAWbCgH0g6tVrBqGMSbwwKBTBFtwkYIwygu?=
 =?us-ascii?Q?p5soFnycFCcSGL+/sKTHoME20RwHpVC3TGsfEUwKgNxGLYa/iSXLbA0AHM/X?=
 =?us-ascii?Q?DkSVxt1VlJDvpvey22cNDH97Wzp8bkuqavHLeyH4WA/Dn7Q63q0kF8/hEvxN?=
 =?us-ascii?Q?61k2KNaUE4gKM9J6cfhCNWk92Z+rcS3z7truwFWH34HrpU7CHYVGykEtBSHb?=
 =?us-ascii?Q?vs/uagq04YTaRGAnrMba9XzUBVc/wumz7HC/156+GQ9313USEnxSWPLoEEJQ?=
 =?us-ascii?Q?xO5MNseIVNoxt0RQ3bgn38ztZ7IlSIneyBt48sD4dgOIFfOT7DqzRj0KLi+r?=
 =?us-ascii?Q?t11Z34Ag6hoK1Z8lIPAtqd8jaoHFnVuHGMe/cPCpfMhVQ+HxdyNaJLJHuLwp?=
 =?us-ascii?Q?XiWuYNHarr+notHqzzDw2239PfYs2P8eLDRyfQKZbaeoPCI8WGGDqsKXeYeR?=
 =?us-ascii?Q?kGOAltO9M7UxFPEKd0ZWaAxMKA552cQg6PDUqN8Be/M/uKaIckbaS9hT1z/V?=
 =?us-ascii?Q?tbIOlAk5qMgbJ1mbgvD4qwf0wf89hpDET3rHWqqohf5CH6rLhqehPEHSrQek?=
 =?us-ascii?Q?jYISlTX15GrT0v1y0vdFuuXqKJAQWKBVYR7eOOjE7mFxpTUOGxvFw9W3Oynu?=
 =?us-ascii?Q?0s8HUSWiGw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 1296a23b-e694-4feb-beaa-08da194ad353
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Iuzom2jRnyC/drccrMaxidgqpYSYl7lXer5zMc+6/0HtgoHu2qYs1EndtVUdqxU0cP7qcYjwC6RF8+ByYpNuIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Kgm07d7nf3AutEiEq81OA2RXa5pdk0BX
X-Proofpoint-GUID: Kgm07d7nf3AutEiEq81OA2RXa5pdk0BX
Reporting-Meta:
 AAEyXtZESWeh3F6ZtS9YDiwbVeVlZfrneu5hDiYT0eP2Eqw1Mk9a8vB8ln4PlYRW
 OhzamNzn3CQDYScTQRVuSoNolPhvK+vLvkp0zqZrBaX3xsX6NVn5CAB4jvc4Bj2d
 eAwl6L6vE5JYDJ2Jd70a8WlXzXAa3cem/bHTL5jqlqaGOj6GS3y6eUUzTvdkrGcO
 tlObr+UiYvfGOmTCKBhtWf/zfCtmAW9itlZuDZeR6DsmyI42daj8FSoMJnI8qJkm
 4Bcpd6MVGSvz3WAdWgmInKmLVCYA3nr9aoFT1rnAPtdI+Re1jBlBWq0UhiPK+Oed
 hMWnhjV4M6xiPvd+XdcwMkPUyohZ8sOVvJyXi+b3XVjOWd/Rn/YkFycvgyJiIbS+
 Rr1yE/AgN8AotHqeQponWyIsKoZMNy6QsuqTLCTfScKV4wnlxm3BbXeFrsHh9RV1
 UKQzO2n3IeR93mmCswfez9oOhZ5qhQJbLBdXYej3+ZML+hPI3Ekik6e6Am5sTFa+
 0jyuXcWywUn0cCDDwTJPNK339phRlFy3FnZ4clFjOeLh

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

1> Revert commit da5e7c87827e8

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

At last, we chose method <1> and partly reverted commit da5e7c87827e8.
We reverted journal init code, and kept cleanup code flow.

Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/inode.c   |  4 ++--
 fs/ocfs2/journal.c | 21 +--------------------
 fs/ocfs2/super.c   | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 22 deletions(-)

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
index 1887a2708709..afb85de3bb60 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -815,30 +815,11 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 	int status = -1;
 	struct inode *inode = NULL; /* the journal inode */
 	journal_t *j_journal = NULL;
-	struct ocfs2_journal *journal = NULL;
+	struct ocfs2_journal *journal = osb->journal;
 	struct ocfs2_dinode *di = NULL;
 	struct buffer_head *bh = NULL;
 	int inode_lock = 0;
 
-	/* initialize our journal structure */
-	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
-	if (!journal) {
-		mlog(ML_ERROR, "unable to alloc journal\n");
-		status = -ENOMEM;
-		goto done;
-	}
-	osb->journal = journal;
-	journal->j_osb = osb;
-
-	atomic_set(&journal->j_num_trans, 0);
-	init_rwsem(&journal->j_trans_barrier);
-	init_waitqueue_head(&journal->j_checkpointed);
-	spin_lock_init(&journal->j_lock);
-	journal->j_trans_id = 1UL;
-	INIT_LIST_HEAD(&journal->j_la_cleanups);
-	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
-	journal->j_state = OCFS2_JOURNAL_FREE;
-
 	/* already have the inode for our journal */
 	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
 					    osb->slot_num);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 477cdf94122e..5f63a2333e52 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2015,6 +2015,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	int i, cbits, bbits;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
+	struct ocfs2_journal *journal;
 	struct ocfs2_super *osb;
 	u64 total_blocks;
 
@@ -2195,6 +2196,32 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	get_random_bytes(&osb->s_next_generation, sizeof(u32));
 
+	/* FIXME
+	 * This should be done in ocfs2_journal_init(), but unknown
+	 * ordering issues will cause the filesystem to crash.
+	 * If anyone wants to figure out what part of the code
+	 * refers to osb->journal before ocfs2_journal_init() is run,
+	 * be my guest.
+	 */
+	/* initialize our journal structure */
+	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
+	if (!journal) {
+		mlog(ML_ERROR, "unable to alloc journal\n");
+		status = -ENOMEM;
+		goto bail;
+	}
+	osb->journal = journal;
+	journal->j_osb = osb;
+
+	atomic_set(&journal->j_num_trans, 0);
+	init_rwsem(&journal->j_trans_barrier);
+	init_waitqueue_head(&journal->j_checkpointed);
+	spin_lock_init(&journal->j_lock);
+	journal->j_trans_id = 1UL;
+	INIT_LIST_HEAD(&journal->j_la_cleanups);
+	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
+	journal->j_state = OCFS2_JOURNAL_FREE;
+
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
 
@@ -2483,6 +2510,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 
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
