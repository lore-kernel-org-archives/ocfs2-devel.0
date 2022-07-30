Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 229FDC00144
	for <ocfs2-devel@archiver.kernel.org>; Sat, 30 Jul 2022 01:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2lqSQYB93ZFlc5NuhjPVwsnECKlJ4ZS3IOWViUQ1Q8A=;
 b=EhTRubwc8ks2N3Wjez+vO8n7SaHdVFxeHShsw8ror4YUkxZAodwR+6rgRGwtJEHukSjvm7R29mBT
   yhe3yTZmnYF13AJ97bVd5P2W/KS1h8/zl1arC7lQI1kvnQxXpAVGmtHamAZnJonpK5lEajPFukTs
   Pgkk+ZLIeD9iyt38LyWfEdUh2GdOTaUQKMbCbP+8OR4Ru/2uTWAHDYxURT3FTATtbnL8RuBYvr2J
   2inoAmnIflQcRl1yrZtGy3bT2dEQjVE7aHZEL3o/PD1jwxWSFVNTbrKqdndOP5IcvlPSkEiwglk8
   ckKCjwqWNiwv9DJi/IJbwplwqf4BeBipCmZwMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2lqSQYB93ZFlc5NuhjPVwsnECKlJ4ZS3IOWViUQ1Q8A=;
 b=qXO/Y8nOA7s/E1YLO1JCSQcYVc2C1LByYwvnrCjLbkbzojpbWqtUflvxU0IbAvbFGoj5pCYt/uuT
   3t5Tar1fjR1VOETTUYu6Sh1KSv7b3RcCVl8rPm9UDLOO1saQ5SFLNrBDV8F+qSzH0I0Jc0MyNKKy
   PlgHgjm0HksZTxxi5+kiwtWaR6TQ8SWCn8O4A1JnIpmTzM8mwAW05jn2E2PLxHj3aY5zDdW8ibPK
   Izez0Nc4jZP8rVLOFnYUb92AjxPgKcxZtQBJUWM/5ngyJflHLxaLHRJXKjIbh8U+Jhe3fnuhs9di
   e45KqVt1pInDolbvoblJkYhLSAyzkANfnQVrTg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFT00CQQ7IWKGA0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 30 Jul 2022 01:16:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIMVQTGmcgJYFOqLdoPpP9xrIaLdn9XHT4nt0H+bHONNSIgexwRtksHOJ8ZMNNlmzqhOCqRU+IQw7xuDco7ql6SF+g0nH1XneCvfR3KtTN6RA5/clz4OaDM32YOnw0Tlg4j0X22zarX/XnxxOMFWidM7+2DvmMzqAW1kWqXde3meGualEb2nOlcTHBsImHHYJOT3KCgFyqxL9AVu7/9w64QP25NffJiD47ZQfSC4VVRHrU4ok4+5wUnxDwYKpmh+PHu2hkdX9Lav4X8ZSn086VUL8+GKOVywfYUupwLraKPmyB4Qg0iJtgC+WOEBYhGpS/Hd9pCNi/cmwsRBhA6C+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYOhpJ4fwnUDdb5+ttdraBsf5p2FWLO5hio+0UNQEHk=;
 b=GbxnD1v2NPJZwlAiMcXNTsj/rKBwMZqNDlPzoDPQCOIKdYatseNBA+UQ+oz60svp7BQigkoy+MEqpAkebhiDhzodfRXWfos1oL5Vu7CZkcyCasaVi+yeHs4NeEKOZo2h+6qN49o3yCmTKC44aYROVTfOnCVD1lcH+yr7DkZ8dkoXl8A054WBplIiO3x5l5PpvtbZBhFj8o/EH9tueVwu/D3+D8FBvGRuCRgN+7+14WcPcpptsTEdL/AEyOToIJzTlJUsWR/9KNnsZTawpfdCXOVsjKwWYlpSp/6ejz92bkfNFs51x34IV4vS13Bh0M4c/rM7SFFectllBSKKXmGFxw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYOhpJ4fwnUDdb5+ttdraBsf5p2FWLO5hio+0UNQEHk=;
 b=C4NHG5VLMvBgwZEAgzQQvDm1Bi0xWP3VDUTXjmm0FV2HMWA3ZrkXX6DKZrMNiQFTLt6VIxDZ4z/asfBuaW17l0IfHcKtyAy4gVeJZZhvaV0y1VTAhQ6tJ7uEuSfMBTpfKimNLgAIJjFgPL/v3M0oV0yN1zGfuFHlbC9sg/Ojnw8g35pIejPa/hQWOKPxDpgiKh8WR7ATCqG5j6e4eZpYs6iUTY0PL3Kv4CKhKxNWjNgCsihp57WN/h77qfwI49qiFyftPMlpfNOyyewdbSJFBu7ezxr2Bbd6V4bdXndD95+xbn+awe8Twoxy/rvpOqGOjizxpnsAJI9idaxv6IVI0Q==
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sat, 30 Jul 2022 09:14:11 +0800
Message-id: <20220730011411.11214-5-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220730011411.11214-1-heming.zhao@suse.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM6PR04MB4662.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(39860400002)(376002)(136003)(346002)(38100700002)(41300700001)(5660300002)(8936002)(66946007)(478600001)(83380400001)(66556008)(8676002)(316002)(4326008)(66476007)(6486002)(2616005)(1076003)(186003)(6666004)(6506007)(26005)(6512007)(30864003)(2906002)(44832011)(86362001)(36756003);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2022 01:15:41.9302 (UTC)
X-Source-IP: 40.107.1.84
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10423
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 clxscore=238 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 malwarescore=0 priorityscore=140 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207300005
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: introduce ext4 MMP feature
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
X-ClientProxiedBy: SG2PR06CA0220.apcprd06.prod.outlook.com (2603:1096:4:68::28)
 To AM6PR04MB4662.eurprd04.prod.outlook.com (2603:10a6:20b:1b::21)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1627ad1-ad68-4685-c5bf-08da71c9053d
X-MS-TrafficTypeDiagnostic: AM6PR04MB4840:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 8fzTUOoxWyZTcvABXeNZqVYdO1TRSou0/SLsfmgbJTAssqDF/j7cBuN8oxvn8JGYq1/QxMtxKU/iZcN/51eB1Nin3S+ZItbUkRG04oH4P6JvBfiNpWFwNWMsN4TOZ84rg+GH2uBoqVOMJZz9/zrfyUIOI0QQOYKX/XOPD46x0nR3qXVzFidobFcqMUHnMeeeiWmmnjduVFCVTAnWS+TgR6nazU//0ZH8RiZ+jbjGqV8nao+md3cWOO/ACXrfMsltwcYUWDWf76wpygv8N6apbs308hsXa5qbPjqUPvh9wFGwtrmYU3do9K82BhnuYeUqPOwwoke/MNRezANOQUAmohD/xdRT2uEm+NKeYLy33x+B0Cd2HrmfL59NFelXgo0oMeXI4thRwhYcOqvS1BUa+mom2s0H8zavlbXzGq6q1Cc4TlLkf63SbpiCz0hbuKDVjSQNthI1U0NMOGySD5RmWJ+sjMkutD28ZFV4ba8vQrei2hT23m3mpUrkmyooIFSV+6YHD1AMCkOLjWSt2XeSgyRkiiS83kgMRJxzSy4RVp/0OcQCrSGZxLzKerTvS/sqEkTzZ7ATMtFjtkIMVHb1R2ZnkBmrjzTh/ipdUrPUYTJeRl1gM52YkCtXGgUjaKiyFRRYwN2GsdHSbxLTeR5Vpis0VKYbu5EcgXOahtCn+XuQSnRMM7/WMWl9kCXG5wle5fxZutyIQjmXs42B8Wi6UgD5fHt3ADORItSGrhvTAkkVAgJZv21kbtJyRcqebaGe
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?iTVM6DPQ1TJG4B+Ih6ELxS9967yK/WZRiH8iWI8bM/Yx0XIirMZbl0sBE4h2?=
 =?us-ascii?Q?jwYEiXINaIWFS77NRPMKoZMLbzbkxmoAGAHrgWg1ZjdkFu0AgS7jXioGAfge?=
 =?us-ascii?Q?V1tzlyPvlavxaTu4uWMvLgDTlNuRA3mfOqALwunPnjIGOFYadfz0oo9HhTsF?=
 =?us-ascii?Q?SMUuZAG7xnK6QrlaDJRQKAwiNAgjw2cUxa2zF97nBw44wpp2aYl5308FJiO+?=
 =?us-ascii?Q?kZQ/BGFbWdi47L+RqVntoPHv/O87da33UzJSkU2UqmRvzLmdMzCzGR8LJIyv?=
 =?us-ascii?Q?y1LCEIrHd+wdV33wu3v3LE42/9o72CKz3pjL/T9zu9S96FhAYGHAV1SEKZGA?=
 =?us-ascii?Q?e7J6tTFU1LRgW2s7j4jIBOTf1Y0dbkZrWA/O55ZGYT91Md3jnc7GxtI2vIFR?=
 =?us-ascii?Q?VgaEQP99ueiKo0KQ6OmZ5Ec8S3pEj3DGEI4OsLSxWNy5UdYUCSSvHpXgOeaJ?=
 =?us-ascii?Q?xtXA562Vf5WNdUEGJ85IVqYFsQbpag5jQob5lo6FUjMQuRb/vklHyJXww2K1?=
 =?us-ascii?Q?rXnVzwYjwUzW8QrxLlcjDkY8jpwJPGvnjrlyvSeSZo86Xv19g7pIS9vZQtpV?=
 =?us-ascii?Q?kPz7djEFZJT5hIIE+9nr8ej1cnegYupTwKsJpmuXPJoBtia/S/zSUfvt2gU7?=
 =?us-ascii?Q?kO89/2Fr4a4/PbggZmgwu8KqsGNipDdFhyHa/MNBd+PwVeOcJPA7JgkdLWMT?=
 =?us-ascii?Q?XW7fcGA835HJzhKuVxX7fWy4eTyTHUY+PN9FRDt5W65eRzYZeAyZjF39iwEV?=
 =?us-ascii?Q?pv2O3+lpveZtk0zS750pm9noe8Badxv2txUfbDOWCN7LQlZFaJzx+IiTC2Mo?=
 =?us-ascii?Q?n0SCf5tU3unglcerfUClMk5YruEY3padCS3sBHF1NCmKZLkUBQmyOLmb2we8?=
 =?us-ascii?Q?Nj3GTc7/VYkioGIKNp31qm2wJ7gDMMLL1NSeiH72wZBbxCKiIMUML1q3ceWN?=
 =?us-ascii?Q?wKEIOqZN+CAeHsx1ajoKmddgSOXr+l5Djd+wWwXJs6V8uJU4zvsWM95xXCyT?=
 =?us-ascii?Q?u6H/olxbCel53EF5GO98CWoiTk3NB14sysRD6bzdyyNG4+jGGw7/z45PqDvm?=
 =?us-ascii?Q?6zS0vt9ALiJOhay58O8uywQDZ0cS0hjqu299opuyEF5OSbE2M5YyYdPlbMPK?=
 =?us-ascii?Q?074fQ8maAMUN7LQ4sZveMbxccKUhRozPp7iOSB0z6tDvPZ9TdwjHO4FmHsLO?=
 =?us-ascii?Q?TO7maVmQIpWtsI5Mr61bT7Sa6zh4e0EQGWF93oiWA9RenhHmKCn32qts79fF?=
 =?us-ascii?Q?DtoPVK2lBae9JqNShQWAy4n5kc1yvyJltKnoJSErTTkqkxey/lQQVxtESQAP?=
 =?us-ascii?Q?nsTvGtzrPEi9PT8RCA6Kxx0KuP9OdzGgsUkpBKB/Vtod5J3TuUS8lXBTeJmh?=
 =?us-ascii?Q?fj/vbMxzfrLg446ls7vCpd3g79Wi8GkkrAylpm9FPPtNrUlQ5fi2MqlZfv5J?=
 =?us-ascii?Q?PBcyhAwUAgbJ7LJAiKmtSiWdHmSsXvG5J+i8uGoOu/2jWnGp1qO/vwAYelu6?=
 =?us-ascii?Q?OF3ZbcZmv+VlzOu86LTB2gkCtTT3YmnDFfyiSA0WkA/9mgP8kcRX9AdM38jm?=
 =?us-ascii?Q?YOMHp5H62Lj83OvtItWgUe+M72qjZJCes7EJWjOH?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 d1627ad1-ad68-4685-c5bf-08da71c9053d
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4662.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 z19F2zbd3uIaS71KxLUTg8azcoZdlSIOCvMP00EVfVZiAZxI/hjxptbfCUFYhkjgejdI/CD5iMkmprBL2bv1cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4840
X-ServerName: mail-eopbgr10084.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: RWrOkXj0rL5PnsPwCVjDBV-_HgrK53vH
X-Proofpoint-ORIG-GUID: RWrOkXj0rL5PnsPwCVjDBV-_HgrK53vH
Reporting-Meta:
 AAEVTnDnICN6a7kNav0bf01jdKJOmBSFL55ehdtxOBtg8foFvOdlFk4Yg0WA9GPb
 UdQX9muSG5qiLwFaXDB3qcdeT7OTJrv7K95Lc4a4VCaD1MKSMnloQBzSU0m1wo2p
 vqUyT9inmJ8nlHAvYr0xv6BGrSzFAudmV+YVvrFZcQqZATwMQNwOW4aa4AFLyII5
 InFrsNss+W3PyTe0UfynQUYGFgSxQ+DC65QNI1g4MAs2NOQ0AkZ50+uuygSX1qpk
 WwmyiSbmfCTTiahMmOMjTRSXQfqMYs9zf+C07I1nrIyhnrIs+13OY8DS6VaEX6iH
 Qm4qxcM8Nr7rbgN5PKQofZEuwM5ZOqcdevKs9KCkx8s+1HvHg1uK8OT5Tu8zwnJ0
 I3qodfglSTIVWUaPjwvtdJq2P1alF7b5yrdYEHOX8/PrZ+VhCa6OL2T5w8KV8fpj
 Lti+UIKGKX6jIVGHliQZV+LdgXP+t8xcEms14iv0cqtPj88mmoJpOWEZQZ+1PRF+
 lNRtYER1xnhHOd03yhI5FJIBk4S32ER6V+qgl5OkBjEL

MMP (multiple mount protection) gives filesystem ability to prevent
from being mounted multiple times.

For avoiding data corruption when non-clustered and/or clustered mount
are happening at same time, this commit introduced MMP feature. MMP
idea is from ext4 MMP (fs/ext4/mmp.c) code. For ocfs2 is a clustered
fs and also for compatible with existing slotmap feature, I did some
optimization and modification when porting from ext4 to ocfs2.

For optimization:
mmp has a kthread kmmpd-<dev>, which is only created in non-clustered
mode.

We set a rule:
If last mount didn't do unmount, (eg: crash), the next mount MUST be
same mount type.

At last, this commit also fix commit c80af0c250c8 ("Revert "ocfs2:
mount shared volume without ha stack") mentioned issue.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/ocfs2.h    |   2 +
 fs/ocfs2/ocfs2_fs.h |  13 +-
 fs/ocfs2/slot_map.c | 459 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/slot_map.h |   3 +
 fs/ocfs2/super.c    |  23 ++-
 5 files changed, 479 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 337527571461..37a7c5855d07 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -337,6 +337,8 @@ struct ocfs2_super
 	unsigned int node_num;
 	int slot_num;
 	int preferred_slot;
+	u16 mmp_update_interval;
+	struct task_struct *mmp_task;
 	int s_sectsize_bits;
 	int s_clustersize;
 	int s_clustersize_bits;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 638d875eccc7..015672f75563 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -87,7 +87,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE \
 					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG	\
 					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO \
-					 | OCFS2_FEATURE_INCOMPAT_APPEND_DIO)
+					 | OCFS2_FEATURE_INCOMPAT_APPEND_DIO \
+					 | OCFS2_FEATURE_INCOMPAT_MMP)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
 					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
@@ -167,6 +168,11 @@
  */
 #define OCFS2_FEATURE_INCOMPAT_APPEND_DIO	0x8000
 
+/*
+ * Multiple mount protection
+ */
+#define OCFS2_FEATURE_INCOMPAT_MMP	0x10000
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -535,8 +541,7 @@ struct ocfs2_slot_map {
 };
 
 struct ocfs2_extended_slot {
-/*00*/	__u8	es_valid;
-	__u8	es_reserved1[3];
+/*00*/	__le32	es_valid;
 	__le32	es_node_num;
 /*08*/
 };
@@ -611,7 +616,7 @@ struct ocfs2_super_block {
 						     INCOMPAT flag set. */
 /*B8*/	__le16 s_xattr_inline_size;	/* extended attribute inline size
 					   for this fs*/
-	__le16 s_reserved0;
+	__le16 s_mmp_update_interval; /* # seconds to wait in MMP checking */
 	__le32 s_dx_seed[3];		/* seed[0-2] for dx dir hash.
 					 * s_uuid_hash serves as seed[3]. */
 /*C0*/  __le64 s_reserved2[15];		/* Fill out superblock */
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 0b0ae3ebb0cf..86a21140ead6 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -8,6 +8,8 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/random.h>
+#include <linux/kthread.h>
 
 #include <cluster/masklog.h>
 
@@ -24,9 +26,48 @@
 
 #include "buffer_head_io.h"
 
+/*
+ * This structure will be used for multiple mount protection. It will be
+ * written into the '//slot_map' field in the system dir.
+ * Programs that check MMP should assume that if SEQ_FSCK (or any unknown
+ * code above SEQ_MAX) is present then it is NOT safe to use the filesystem.
+ */
+#define OCFS2_MMP_SEQ_CLEAN 0xFF4D4D50U /* mmp_seq value for clean unmount */
+#define OCFS2_MMP_SEQ_FSCK  0xE24D4D50U /* mmp_seq value when being fscked */
+#define OCFS2_MMP_SEQ_MAX   0xE24D4D4FU /* maximum valid mmp_seq value */
+#define OCFS2_MMP_SEQ_INIT  0x0         /* mmp_seq init value */
+#define OCFS2_VALID_CLUSTER   0xE24D4D55U /* value for clustered mount
+											   under MMP disabled */
+#define OCFS2_VALID_NOCLUSTER 0xE24D4D5AU /* value for noclustered mount
+											   under MMP disabled */
+
+#define OCFS2_SLOT_INFO_OLD_VALID   1 /* use for old slot info */
+
+/*
+ * Check interval multiplier
+ * The MMP block is written every update interval and initially checked every
+ * update interval x the multiplier (the value is then adapted based on the
+ * write latency). The reason is that writes can be delayed under load and we
+ * don't want readers to incorrectly assume that the filesystem is no longer
+ * in use.
+ */
+#define OCFS2_MMP_CHECK_MULT		2UL
+
+/*
+ * Minimum interval for MMP checking in seconds.
+ */
+#define OCFS2_MMP_MIN_CHECK_INTERVAL	5UL
+
+/*
+ * Maximum interval for MMP checking in seconds.
+ */
+#define OCFS2_MMP_MAX_CHECK_INTERVAL	300UL
 
 struct ocfs2_slot {
-	int sl_valid;
+	union {
+		unsigned int sl_valid;
+		unsigned int mmp_seq;
+	};
 	unsigned int sl_node_num;
 };
 
@@ -52,11 +93,11 @@ static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
 }
 
 static void ocfs2_set_slot(struct ocfs2_slot_info *si,
-			   int slot_num, unsigned int node_num)
+			   int slot_num, unsigned int node_num, unsigned int valid)
 {
 	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
 
-	si->si_slots[slot_num].sl_valid = 1;
+	si->si_slots[slot_num].sl_valid = valid;
 	si->si_slots[slot_num].sl_node_num = node_num;
 }
 
@@ -75,7 +116,8 @@ static void ocfs2_update_slot_info_extended(struct ocfs2_slot_info *si)
 		     i++, slotno++) {
 			if (se->se_slots[i].es_valid)
 				ocfs2_set_slot(si, slotno,
-					       le32_to_cpu(se->se_slots[i].es_node_num));
+					       le32_to_cpu(se->se_slots[i].es_node_num),
+					       le32_to_cpu(se->se_slots[i].es_valid));
 			else
 				ocfs2_invalidate_slot(si, slotno);
 		}
@@ -97,7 +139,8 @@ static void ocfs2_update_slot_info_old(struct ocfs2_slot_info *si)
 		if (le16_to_cpu(sm->sm_slots[i]) == (u16)OCFS2_INVALID_SLOT)
 			ocfs2_invalidate_slot(si, i);
 		else
-			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]));
+			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]),
+						OCFS2_SLOT_INFO_OLD_VALID);
 	}
 }
 
@@ -252,16 +295,14 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
 	int i, ret = -ENOSPC;
 
 	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
-		if (!si->si_slots[preferred].sl_valid ||
-		    !si->si_slots[preferred].sl_node_num) {
+		if (!si->si_slots[preferred].sl_valid) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (!si->si_slots[i].sl_valid ||
-		    !si->si_slots[i].sl_node_num) {
+		if (!si->si_slots[i].sl_valid) {
 			ret = i;
 			break;
 		}
@@ -270,6 +311,43 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
 	return ret;
 }
 
+/* Return first used slot.
+ * -ENOENT means all slots are clean, ->sl_valid should be
+ * OCFS2_MMP_SEQ_CLEAN or ZERO */
+static int __ocfs2_find_used_slot(struct ocfs2_slot_info *si)
+{
+	int i, ret = -ENOENT, valid;
+
+	for (i = 0; i < si->si_num_slots; i++) {
+		valid = si->si_slots[i].sl_valid;
+		if (valid == 0 || valid == OCFS2_MMP_SEQ_CLEAN)
+			continue;
+		if (valid <= OCFS2_MMP_SEQ_MAX ||
+			valid == OCFS2_MMP_SEQ_FSCK ||
+			valid == OCFS2_VALID_CLUSTER ||
+			valid == OCFS2_VALID_NOCLUSTER) {
+			ret = i;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int __ocfs2_find_expected_slot(struct ocfs2_slot_info *si,
+								unsigned int expected)
+{
+	int i;
+
+	for (i = 0; i < si->si_num_slots; i++) {
+		if (si->si_slots[i].sl_valid == expected) {
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num)
 {
 	int slot;
@@ -445,21 +523,357 @@ void ocfs2_free_slot_info(struct ocfs2_super *osb)
 	__ocfs2_free_slot_info(si);
 }
 
+/*
+ * Get a random new sequence number but make sure it is not greater than
+ * EXT4_MMP_SEQ_MAX.
+ */
+static unsigned int mmp_new_seq(void)
+{
+	u32 new_seq;
+
+	do {
+		new_seq = prandom_u32();
+	} while (new_seq > OCFS2_MMP_SEQ_MAX);
+
+	if (new_seq == 0)
+		return 1;
+	else
+		return new_seq;
+}
+
+/*
+ * kmmpd will update the MMP sequence every mmp_update_interval seconds
+ */
+static int kmmpd(void *data)
+{
+	struct ocfs2_super *osb = data;
+	struct super_block *sb = osb->sb;
+	struct ocfs2_slot_info *si = osb->slot_info;
+	int slot = osb->slot_num;
+	u32 seq, mmp_seq;
+	unsigned long failed_writes = 0;
+	u16 mmp_update_interval = osb->mmp_update_interval;
+	unsigned int mmp_check_interval;
+	unsigned long last_update_time;
+	unsigned long diff;
+	int retval = 0;
+
+	if (!ocfs2_mount_local(osb)) {
+		mlog(ML_ERROR, "kmmpd thread only works for local mount mode.\n");
+		goto wait_to_exit;
+	}
+
+	retval = ocfs2_refresh_slot_info(osb);
+	seq = si->si_slots[slot].mmp_seq;
+
+	/*
+	 * Start with the higher mmp_check_interval and reduce it if
+	 * the MMP block is being updated on time.
+	 */
+	mmp_check_interval = max(OCFS2_MMP_CHECK_MULT * mmp_update_interval,
+				 OCFS2_MMP_MIN_CHECK_INTERVAL);
+
+	while (!kthread_should_stop() && !sb_rdonly(sb)) {
+		if (!OCFS2_HAS_INCOMPAT_FEATURE(sb, OCFS2_FEATURE_INCOMPAT_MMP)) {
+			mlog(ML_WARNING, "kmmpd being stopped since MMP feature"
+				     " has been disabled.");
+			goto wait_to_exit;
+		}
+		if (++seq > OCFS2_MMP_SEQ_MAX)
+			seq = 1;
+
+		spin_lock(&osb->osb_lock);
+		si->si_slots[slot].mmp_seq = mmp_seq = seq;
+		spin_unlock(&osb->osb_lock);
+
+		last_update_time = jiffies;
+		retval = ocfs2_update_disk_slot(osb, si, slot);
+
+		/*
+		 * Don't spew too many error messages. Print one every
+		 * (s_mmp_update_interval * 60) seconds.
+		 */
+		if (retval) {
+			if ((failed_writes % 60) == 0) {
+				ocfs2_error(sb, "Error writing to MMP block");
+			}
+			failed_writes++;
+		}
+
+		diff = jiffies - last_update_time;
+		if (diff < mmp_update_interval * HZ)
+			schedule_timeout_interruptible(mmp_update_interval *
+						       HZ - diff);
+
+		/*
+		 * We need to make sure that more than mmp_check_interval
+		 * seconds have not passed since writing. If that has happened
+		 * we need to check if the MMP block is as we left it.
+		 */
+		diff = jiffies - last_update_time;
+		if (diff > mmp_check_interval * HZ) {
+			retval = ocfs2_refresh_slot_info(osb);
+			if (retval) {
+				ocfs2_error(sb, "error reading MMP data: %d", retval);
+				goto wait_to_exit;
+			}
+
+			if (si->si_slots[slot].mmp_seq != mmp_seq) {
+				ocfs2_error(sb, "Error while updating MMP info. "
+					     "The filesystem seems to have been"
+					     " multiply mounted.");
+				retval = -EBUSY;
+				goto wait_to_exit;
+			}
+		}
+
+		 /*
+		 * Adjust the mmp_check_interval depending on how much time
+		 * it took for the MMP block to be written.
+		 */
+		mmp_check_interval = max(min(OCFS2_MMP_CHECK_MULT * diff / HZ,
+					     OCFS2_MMP_MAX_CHECK_INTERVAL),
+					     OCFS2_MMP_MIN_CHECK_INTERVAL);
+	}
+
+	/*
+	 * Unmount seems to be clean.
+	 */
+	spin_lock(&osb->osb_lock);
+	si->si_slots[slot].mmp_seq = OCFS2_MMP_SEQ_CLEAN;
+	spin_unlock(&osb->osb_lock);
+
+	retval = ocfs2_update_disk_slot(osb, si, 0);
+
+wait_to_exit:
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!kthread_should_stop())
+			schedule();
+	}
+	set_current_state(TASK_RUNNING);
+	return retval;
+}
+
+void ocfs2_stop_mmpd(struct ocfs2_super *osb)
+{
+	if (osb->mmp_task) {
+		kthread_stop(osb->mmp_task);
+		osb->mmp_task = NULL;
+	}
+}
+
+/*
+ * Protect the filesystem from being mounted more than once.
+ *
+ * This function was inspired by ext4 MMP feature. Because HA stack
+ * helps ocfs2 to manage nodes join/leave, so we only focus on MMP
+ * under nocluster mode.
+ * Another info is ocfs2 only uses slot 0 on nocuster mode.
+ *
+ * es_valid:
+ *  0: not available
+ *  1: valid, cluster mode
+ *  2: valid, nocluster mode
+ *
+ * parameters:
+ *  osb: the struct ocfs2_super
+ *  noclustered: under noclustered mount
+ *  slot: prefer slot number
+ */
+int ocfs2_multi_mount_protect(struct ocfs2_super *osb, int noclustered)
+{
+	struct buffer_head *bh = NULL;
+	u32 seq;
+	struct ocfs2_slot_info *si = osb->slot_info;
+	unsigned int mmp_check_interval = osb->mmp_update_interval;
+	unsigned int wait_time = 0;
+	int retval = 0;
+	int slot = osb->slot_num;
+
+	if (!ocfs2_uses_extended_slot_map(osb)) {
+		mlog(ML_WARNING, "MMP only works on extended slot map.\n");
+		retval = -EINVAL;
+		goto bail;
+	}
+
+	retval = ocfs2_refresh_slot_info(osb);
+	if (retval)
+		goto bail;
+
+	if (mmp_check_interval < OCFS2_MMP_MIN_CHECK_INTERVAL)
+		mmp_check_interval = OCFS2_MMP_MIN_CHECK_INTERVAL;
+
+	spin_lock(&osb->osb_lock);
+	seq = si->si_slots[slot].mmp_seq;
+
+	if (__ocfs2_find_used_slot(si) == -ENOENT)
+		goto skip;
+
+	/* TODO ocfs2-tools need to support this flag */
+	if (__ocfs2_find_expected_slot(si, OCFS2_MMP_SEQ_FSCK)) {
+		mlog(ML_NOTICE, "fsck is running on the filesystem");
+		spin_unlock(&osb->osb_lock);
+		retval = -EBUSY;
+		goto bail;
+	}
+	spin_unlock(&osb->osb_lock);
+
+	wait_time = min(mmp_check_interval * 2 + 1, mmp_check_interval + 60);
+
+	/* Print MMP interval if more than 20 secs. */
+	if (wait_time > OCFS2_MMP_MIN_CHECK_INTERVAL * 4)
+		mlog(ML_WARNING, "MMP interval %u higher than expected, please"
+			     " wait.\n", wait_time * 2);
+
+	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
+		mlog(ML_WARNING, "MMP startup interrupted, failing mount.\n");
+		retval = -EPERM;
+		goto bail;
+	}
+
+	retval = ocfs2_refresh_slot_info(osb);
+	if (retval)
+		goto bail;
+	if (seq != si->si_slots[slot].mmp_seq) {
+		mlog(ML_ERROR, "Device is already active on another node.\n");
+		retval = -EPERM;
+		goto bail;
+	}
+
+	spin_lock(&osb->osb_lock);
+skip:
+	/*
+	 * write a new random sequence number.
+	 */
+	seq = mmp_new_seq();
+	mlog(ML_ERROR, "seq: 0x%x mmp_seq: 0x%x\n", seq, si->si_slots[slot].mmp_seq);
+	ocfs2_set_slot(si, slot, osb->node_num, seq);
+	spin_unlock(&osb->osb_lock);
+
+	ocfs2_update_disk_slot_extended(si, slot, &bh);
+	mlog(ML_ERROR, "seq: 0x%x mmp_seq: 0x%x\n", seq, si->si_slots[slot].mmp_seq);
+	retval = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
+	if (retval < 0) {
+		mlog_errno(retval);
+		goto bail;
+	}
+	mlog(ML_ERROR, "seq: 0x%x mmp_seq: 0x%x wait_time: %u\n", seq, si->si_slots[slot].mmp_seq, wait_time);
+
+	/*
+	 * wait for MMP interval and check mmp_seq.
+	 */
+	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
+		mlog(ML_WARNING, "MMP startup interrupted, failing mount.\n");
+		retval = -EPERM;
+		goto bail;
+	}
+
+	retval = ocfs2_refresh_slot_info(osb);
+	if (retval)
+		goto bail;
+
+	mlog(ML_ERROR, "seq: 0x%x mmp_seq: 0x%x\n", seq, si->si_slots[slot].mmp_seq);
+	if (seq != si->si_slots[slot].mmp_seq) {
+		mlog(ML_ERROR, "Update seq failed, device is already active on another node.\n");
+		retval = -EPERM;
+		goto bail;
+	}
+
+	/*
+	 * There are two reasons we don't create kmmpd on clustered mount:
+	 * - ocfs2 needs to grab osb->osb_lock to modify/access osb->si.
+	 * - For huge number nodes cluster, nodes update same sector
+	 *   of '//slot_map' will cause IO performance issue.
+	 *
+	 * Then there has another question:
+	 * On clustered mount, MMP seq won't update, and MMP how to
+	 * handle a noclustered mount when there already exist
+	 * clustered mount.
+	 * The answer is the rule mentioned in ocfs2_find_slot().
+	 */
+	if (!noclustered) {
+		spin_lock(&osb->osb_lock);
+		ocfs2_set_slot(si, slot, osb->node_num, OCFS2_VALID_CLUSTER);
+		spin_unlock(&osb->osb_lock);
+
+		ocfs2_update_disk_slot_extended(si, slot, &bh);
+		retval = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
+		goto bail;
+	}
+
+	/*
+	 * Start a kernel thread to update the MMP block periodically.
+	 */
+	osb->mmp_task = kthread_run(kmmpd, osb, "kmmpd-%s", osb->sb->s_id);
+	if (IS_ERR(osb->mmp_task)) {
+		osb->mmp_task = NULL;
+		mlog(ML_WARNING, "Unable to create kmmpd thread for %s.",
+			     osb->sb->s_id);
+		retval = -EPERM;
+		goto bail;
+	}
+
+bail:
+	return retval;
+}
+
+static void show_conflict_mnt_msg(int clustered)
+{
+	const char *exist = clustered ? "non-clustered" : "clustered";
+
+	mlog(ML_ERROR, "Found %s mount info!", exist);
+	mlog(ML_ERROR, "Please clean %s slotmap info for mounting.\n", exist);
+	mlog(ML_ERROR, "eg. remount then unmount with %s mode\n", exist);
+}
+
+/*
+ * Even under readonly mode, we write slot info on disk.
+ * The logic is correct: if not change slot info on readonly
+ * mode, in cluster env, later mount from another node
+ * may reuse the same slot, deadlock happen!
+ */
 int ocfs2_find_slot(struct ocfs2_super *osb)
 {
-	int status;
+	int status = -EPERM;
 	int slot;
+	int noclustered = 0;
 	struct ocfs2_slot_info *si;
 
 	si = osb->slot_info;
 
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
+	slot = __ocfs2_find_used_slot(si);
+	if (slot == 0 &&
+		((si->si_slots[0].sl_valid == OCFS2_VALID_NOCLUSTER) ||
+		 (si->si_slots[0].sl_valid < OCFS2_MMP_SEQ_MAX)))
+		noclustered = 1;
 
-	if (ocfs2_mount_local(osb))
-		/* use slot 0 directly in local mode */
-		slot = 0;
-	else {
+	/*
+	 * We set a rule:
+	 * If last mount didn't do unmount, (eg: crash), the next mount
+	 * MUST be same mount type.
+	 */
+	if (ocfs2_mount_local(osb)) {
+		/* empty slotmap, or device didn't unmount from last time */
+		if ((slot == -ENOENT) || noclustered) {
+			/* use slot 0 directly in local mode */
+			slot = 0;
+			noclustered = 1;
+		} else {
+			spin_unlock(&osb->osb_lock);
+			show_conflict_mnt_msg(0);
+			status = -EINVAL;
+			goto bail;
+		}
+	} else {
+		if (noclustered) {
+			spin_unlock(&osb->osb_lock);
+			show_conflict_mnt_msg(1);
+			status = -EINVAL;
+			goto bail;
+		}
 		/* search for ourselves first and take the slot if it already
 		 * exists. Perhaps we need to mark this in a variable for our
 		 * own journal recovery? Possibly not, though we certainly
@@ -481,7 +895,21 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 			       slot, osb->dev_str);
 	}
 
-	ocfs2_set_slot(si, slot, osb->node_num);
+	if (OCFS2_HAS_INCOMPAT_FEATURE(osb->sb, OCFS2_FEATURE_INCOMPAT_MMP)) {
+		osb->slot_num = slot;
+		spin_unlock(&osb->osb_lock);
+		status = ocfs2_multi_mount_protect(osb, noclustered);
+		if (status < 0) {
+			mlog(ML_ERROR, "MMP failed to start.\n");
+			goto mmp_fail;
+		}
+
+		trace_ocfs2_find_slot(osb->slot_num);
+		return status;
+	}
+
+	ocfs2_set_slot(si, slot, osb->node_num, noclustered ?
+			OCFS2_VALID_NOCLUSTER : OCFS2_VALID_CLUSTER);
 	osb->slot_num = slot;
 	spin_unlock(&osb->osb_lock);
 
@@ -490,6 +918,7 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 	status = ocfs2_update_disk_slot(osb, si, osb->slot_num);
 	if (status < 0) {
 		mlog_errno(status);
+mmp_fail:
 		/*
 		 * if write block failed, invalidate slot to avoid overwrite
 		 * slot during dismount in case another node rightly has mounted
diff --git a/fs/ocfs2/slot_map.h b/fs/ocfs2/slot_map.h
index a43644570b53..d4d147b0c190 100644
--- a/fs/ocfs2/slot_map.h
+++ b/fs/ocfs2/slot_map.h
@@ -25,4 +25,7 @@ int ocfs2_slot_to_node_num_locked(struct ocfs2_super *osb, int slot_num,
 
 int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num);
 
+int ocfs2_multi_mount_protect(struct ocfs2_super *osb, int noclustered);
+void ocfs2_stop_mmpd(struct ocfs2_super *osb);
+
 #endif
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f7298816d8d9..b0e76b06efc3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -609,6 +609,7 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 	struct mount_options parsed_options;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	u32 tmp;
+	int noclustered;
 
 	sync_filesystem(sb);
 
@@ -619,7 +620,8 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	tmp = OCFS2_MOUNT_NOCLUSTER;
-	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
+	noclustered = osb->s_mount_opt & tmp;
+	if (noclustered != (parsed_options.mount_opt & tmp)) {
 		ret = -EINVAL;
 		mlog(ML_ERROR, "Cannot change nocluster option on remount\n");
 		goto out;
@@ -686,10 +688,20 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 			}
 			sb->s_flags &= ~SB_RDONLY;
 			osb->osb_flags &= ~OCFS2_OSB_SOFT_RO;
+			if (OCFS2_HAS_INCOMPAT_FEATURE(sb, OCFS2_FEATURE_INCOMPAT_MMP)) {
+				spin_unlock(&osb->osb_lock);
+				if (ocfs2_multi_mount_protect(osb, noclustered)) {
+					mlog(ML_ERROR, "started MMP failed.\n");
+					ocfs2_stop_mmpd(osb);
+					ret = -EROFS;
+					goto unlocked_osb;
+				}
+			}
 		}
 		trace_ocfs2_remount(sb->s_flags, osb->osb_flags, *flags);
 unlock_osb:
 		spin_unlock(&osb->osb_lock);
+unlocked_osb:
 		/* Enable quota accounting after remounting RW */
 		if (!ret && !(*flags & SB_RDONLY)) {
 			if (sb_any_quota_suspended(sb))
@@ -722,6 +734,8 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 			((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) ?
 							SB_POSIXACL : 0);
+		if (sb_rdonly(osb->sb))
+			ocfs2_stop_mmpd(osb);
 	}
 out:
 	return ret;
@@ -1833,7 +1847,7 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	status = ocfs2_init_local_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_super_lock;
+		goto out_find_slot;
 	}
 
 	status = ocfs2_check_volume(osb);
@@ -1858,6 +1872,8 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	/* before journal shutdown, we should release slot_info */
 	ocfs2_free_slot_info(osb);
 	ocfs2_journal_shutdown(osb);
+out_find_slot:
+	ocfs2_stop_mmpd(osb);
 out_super_lock:
 	ocfs2_super_unlock(osb, 1);
 out_dlm:
@@ -1878,6 +1894,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	osb = OCFS2_SB(sb);
 	BUG_ON(!osb);
 
+	ocfs2_stop_mmpd(osb);
+
 	/* Remove file check sysfs related directores/files,
 	 * and wait for the pending file check operations */
 	ocfs2_filecheck_remove_sysfs(osb);
@@ -2086,6 +2104,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	snprintf(osb->dev_str, sizeof(osb->dev_str), "%u,%u",
 		 MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
 
+	osb->mmp_update_interval = le16_to_cpu(di->id2.i_super.s_mmp_update_interval);
 	osb->max_slots = le16_to_cpu(di->id2.i_super.s_max_slots);
 	if (osb->max_slots > OCFS2_MAX_SLOTS || osb->max_slots == 0) {
 		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
-- 
2.37.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
