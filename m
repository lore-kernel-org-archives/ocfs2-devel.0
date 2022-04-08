Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F3C7C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=coozlD4L0m5SO9Hlmp/TOOob3jLuTPIJ0yE1iTHMxoY=;
 b=NICHEFH2o6LjXUNbQkBjI0HvNHwKSOEUkxXcSHYc7rmR9HRKv/A1utYAZYsgnhupf4uVX1bJQQKP
   F8sGK5oB2Z83ykQkLOyrUrYdYJiXUwz9UzuZtgqIIThAfF+fD701CyHv8namyj/JLZs6CR8dP8D1
   l+ZkQCrqj/KguYnBeVfsVjCUsQL9Y9P7gjo/UocbqtzsVcrgey4nDaQS0buGjC3q5Lp/eniJlY2o
   AO0U3D5Tgv1H+oJWcEumXlk0MaZJxhZJZs+RZzPrS4GQPSrDDdDnEiDNllJ0xbvT54tYxzUykRQo
   X30CmpaCTMym3XIcThbkkDhM4VVwFU91Q2xseA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=coozlD4L0m5SO9Hlmp/TOOob3jLuTPIJ0yE1iTHMxoY=;
 b=E7F+pfwl0ZdQefX9ZuH+dDAYW+1IHah4UGmIjZ1wgoSukPjfsmJZeEk0PD1tziI7dyqjZK6gbS9L
   3wfO8652lQUmOWF8XMNUYYUJZL1GOzzz5C7O4py1NMr8lNl+Y56YopqxHpejuznIkf6WesKNH8z3
   o4FGyg7ClNPC5j0Iw3/Y6nEZkyuC3iSnL+z+hPKtXZ8s6gmvgPINvX+vQYFNYDcif2J3D4bdP1+S
   gVZOI4h8C5Dy84RSziz3qg+A2/xjeAO2PQBEVfZCxZlLPCZr049L0jRm30+M2jW0lSWaiuEzCMpN
   H5owbOJWE04AJ79WPB/ODn2FLrqB62MXgD/x9Q==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA000AQ4NW5SEC0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 08 Apr 2022 10:31:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649413850;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pAjck+DiX0RGlE5Jh20l4arHHvUB4v6aBVHBZozHpEw=;
 b=eK1rj3hZ9ZPhJB7uozEb/kj5owe7BSpRcKw6de/udQ6SJ7dgbH4pfX+DfdhEckrO16C6Y9
 Ig+FpeaUdihoQABu7USIGslR1hh9JIsqMghVR834S/PkZCIzjSvdJ9YJqIHa6RbkSnwFjp
 s5baze9C/0+R1NMX3MR3yod0yM/GAB0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAXUsMWRDO597tnu+h8BmE7ItEZqtxbTYr7s8Phspc4npEgGOl77GjbL5cEXdrPiiQ0r85lllXl34+2ATPSk3IKskaSWA25/nHZyvS4/EVFd57c/959mf2EZM1SJbnHN3pWGFLEZa7eZxPu2ZdBE5JcqGVbq7hiR4/2vqxUBpWggVyOF4Fa7VMPHp/Eo3cl0s5RhFHLwvqjyodE11U0gaKGYv++caQVSlWgrXZsFU/0I5ic53ellfNgA2LnV9H6b5mVq1IttiRtSDPhKXm4NFbnPbUwojxEk+xXrHUSsfXkgqZIq5A+AiC5WWWfSzppcxP/pL15meFyu602siFg88g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYTBbwErP/rHpDdoSHWIuvjOfailyA3FEljtGjmfzQc=;
 b=PNydgtTbivOzqLcLjBwxLxpzX4e2AETGr9mW980+WPvGUjnRdcPcncF/sXTycSGjOC8zk8zsettCOr1FyxF34QIgIE4ac6qXqHIpv0XgqneNm3V/QYzKEILLZ7s49oczpB7GCRrNOWTpHkD6gtX/+xXe8V2/pTjlNM/onnCXCVqCrbSrFbD5KPiRlHIqzVQ8vCm1XwuiVKeHxyITjOM1wTWq62QhyQPBzi2D4pTkBx/3pfv4mUDbHsbtj+OYGMgpMdZsWbxsKJGitF1JDNxsNIE/rFlOw5TVZqVZS6UmyRgS4MVaG4tiEIelTOUiQ0NjT3VmFqMyaha+SQCJJN8gUA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Fri,  8 Apr 2022 18:30:09 +0800
Message-id: <20220408103012.1419-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
In-reply-to: <20220408103012.1419-1-heming.zhao@suse.com>
References: <20220408103012.1419-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(44832011)(1076003)(6486002)(316002)(38100700002)(2616005)(86362001)(107886003)(83380400001)(2906002)(508600001)(5660300002)(4326008)(66476007)(6512007)(66946007)(66556008)(186003)(8676002)(6506007)(36756003)(6666004)(26005);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 10:30:47.9938 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 suspectscore=0 priorityscore=226 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 clxscore=177 mlxscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080053
Subject: [Ocfs2-devel] [PATCH v1 2/5] ocfs2: change return type of
	ocfs2_resmap_init
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
X-MC-Unique: rJGwiwDAPk-YUxkGYAsJ0A-1
X-ClientProxiedBy: TYWPR01CA0033.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::20) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ca52589-be53-4901-a096-08da194ad8a2
X-MS-TrafficTypeDiagnostic: PA4PR04MB7840:EE_
X-Microsoft-Antispam-PRVS:
 <PA4PR04MB78404CBFEEB722CFCAB8128997E99@PA4PR04MB7840.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 NkCIw9waREPU9htoQXS6P3V6vDp6IyhfQSbXHT3VtMSVriIQxHqd3OtaG4bnQmWQBFGpxcn8+Kv3qnCghf4+waFhD1cbfkJaICTyb3dUhgGFZd+oR3+c4j8HU+3tKoMHauCZLx0hQLNx281gppSdnxJgjoIGxC8JcPdHe4X8QR0FPcH7cWZXE8JSOP83Lx+8kTT8wwb19b5knpmPVB+8VwoN/o0FUMMET3PP222nM9HxgMYnz+qwUf0jVBUmSCpjJhVPUeeIdxACmSbDKVv7rvl79z1Jir4swtdK081R14dwXwf7S0KgiyK2WXoYBhr/wkLgx6x60lxfQgsrnhdxO93quJuiin14hs13m0B9KddQbsHv1oLdD5ASv9zBLeQFdIL8J0ZQg2kf6Mw0UwSekI1m+XJ92/yW4jtRK5Px48TOfsll809RuifGcvCeARkaizinyh7DaWVjG4SjKAKNHCji+IO+fWR4SLrTt0gCkR1C38bIWufBhaMKx2sa6EpeSwgHpAm5Xe7XyqLwBuvvcBAtjUbmQLP3yM53EjX+RGfop0bF0Mmwg9WFMOgGbKBS5O48IP7r8JjJRPuOwfrZBiiy5SqzmIcgrAKKI72kbh3P2eWiXv66oxFsN4KG4SjkPO0w7GlI7IlG5PuFANG3FA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?a9mlzd3hKmIa4wZRGw/qucUZl6+XC4/BW56rjHU4nTaRg8e003304LB0JiR5?=
 =?us-ascii?Q?hbuDZejdFmPc4IW1vz02BHAzXVz1IjF2tMcarV4J6ioRIfzOv1qhUO/LaAK0?=
 =?us-ascii?Q?XT/Yn0bKG00WigtxVd0Ks/p+mgTTvctrYwtBBJjoJnEy3jlnvCvnhNPjm+Du?=
 =?us-ascii?Q?DuN40R4ZJy+vNboPAj0T3y/ID8JJueJXkfs145C+AJfVjekoWPNu+b8RUVSZ?=
 =?us-ascii?Q?R8Q3tLHueVO5A5xfam7/LZvmCCfEyjbimZJSCS2qf4/833+Uxq7ykwW4lqJo?=
 =?us-ascii?Q?/JDlV1EyksntnkacSYxN8qDXTgRE5crTWMOL5fbXkBj3hRR5KCFgghHwVNO8?=
 =?us-ascii?Q?ynRV0032YXlVkpzezMyDpZzEulTO+sh/Du1qIgbcxQ3v8YlobzN9lyua1o+G?=
 =?us-ascii?Q?TsLFtKfWGZiSLVGiJDIiZ7//drQT1h6WvqHJscU5aoZCRMaeJZ2VbuP7Gh5q?=
 =?us-ascii?Q?mlIOHsGYOACu9STu4m2iGeqHwtxhDkAJd473QmEHmTsgabHMLY2HK6Vezn6X?=
 =?us-ascii?Q?8SvtUxD7NKjB1194t+w2HDAB7iS/GFuV29fEf3KTKPhE3fzkNL+/aW8rLWyM?=
 =?us-ascii?Q?6u6kULhGP+/3R3Se78tvxNhWxCSNmGMJEjGExHUz4NY6EWI2RsaLfs2a2BMF?=
 =?us-ascii?Q?xqXbJYN+B7IDDr4svrHDwEV+rY1UiAo4eH6lfQIkZbgOFgKd14nmc/7upd2w?=
 =?us-ascii?Q?mcQamA8oFxEONSEanAiewrX2i+qd/x/yba1sDh6lWfZDa/cgxxt3b7702HRo?=
 =?us-ascii?Q?FbIb5t9HzbbF/I1JyJ6zWP9KHW1kJDetobg6C+WkdsgiQJ37COtzyRPlPTkE?=
 =?us-ascii?Q?6xLHiXjlL3D5TBjUD4TxChcC+4vERpzSa4x2doQN0/4/BDogdeIv1X/loKVh?=
 =?us-ascii?Q?ZYdh0nuXRZWnbyj4FQjl25jueKK55xUkQcSonBHnL9fp4QYjBz74hY+CculK?=
 =?us-ascii?Q?ubhv6188pyNgcIsFAQT923R11w060RPi4CY7lcLovE2NMMMlezhGm40M2Suy?=
 =?us-ascii?Q?1BmFfjlMUVVDRko5waU1f0X3MVJ8Rz0TzKz+oy294V8zKVaQHR2Cpxnhi/aR?=
 =?us-ascii?Q?6pEgvEjTf2YXsUp36Nrz88T7y/ZO1/Md0JXbp1oSETVTF2YvmMisgx0ntEd5?=
 =?us-ascii?Q?2PcmlSlKOxzy/Yq7anRtvhdbVRMUlzunsOU+JPpsb7l8RFQOSXnj2lv1h5rI?=
 =?us-ascii?Q?gOsImYT8KOKJ031dDmXbkT9J2HlAGkHK1RMACPa9TdxfWFp8s3BMt1eZRJ9R?=
 =?us-ascii?Q?hfYekRqYr1YKpv4Tzh/QysrZOdlT8ySXiA/NPDNRSPohmXqCs0eRJmfgqmE6?=
 =?us-ascii?Q?kmMP4bdL7sXGdjI8EgHxgzgwE5ve/moIkLyXd6PVUoETdmeye5xz5nuXLJ4m?=
 =?us-ascii?Q?a3ST473gItDt5y9b3nqCtCW1iRFtuKyahaDXUuUsoZziNPgXddf/Bv6ZbROg?=
 =?us-ascii?Q?hHlfGxNWtW0jdxBY0RquozZp17ysomHcWeclvhSm5RP43JryvV+zlq1tGPoW?=
 =?us-ascii?Q?OOm+YEu8hsi+U5lFhwFvhnhpERQdM8VV878gMcYWDefe5z9w6pZwzG1VzoMD?=
 =?us-ascii?Q?+oWeBxiREL8KFuqjWv2rxzZ5lwfSVngiwvqbwJnScjwBNdadsB+4ruko4kN1?=
 =?us-ascii?Q?3y/MetD7Iu4/ZBum1w325oF6ZI11ty1L4AoaYnIGKLMUfGcutvzf/Rx8CPT/?=
 =?us-ascii?Q?DpIpDfkHHpkSumVP1SOd0/RubOkDrVdONCpGVWHwsrqapB8epvdl/K+MXG63?=
 =?us-ascii?Q?W3V/x4bLtQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 8ca52589-be53-4901-a096-08da194ad8a2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 iJlJdQcYovGGBB96ngJPQ1zn6xxiVQVQT4kv9I28Hr38UZl33txVb7iPjiR3Jjkn+EQIyQPmI00b7kpcp1xVDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 0NAOVn0rF3SealZchnVu6IUjUT-eAiQo
X-Proofpoint-ORIG-GUID: 0NAOVn0rF3SealZchnVu6IUjUT-eAiQo
Reporting-Meta:
 AAF9ofAet3r3RF5W3UBz1fhEe8qSyG268Og8XfmqzlTtoTjS/WQknZcwpzEOjojU
 mS4xTLosVgAiPK6DaxoEUDOVoib5xvLk2mlJb5WtoorAeZppeUnAlb8k09jb7tDK
 8tNCAtiEsOu3U6lz4RrUJpcJJgbfyUIwRiR55tl21ApTcFAPhuIf5r21DKyvBzDH
 mI7XOXcwOpreMcTQn/lMowOSiGpDKxw6wQVH7hJILsegdaGpTNoBlEe2wXRYJp2m
 Yt7IetH6kMHUp+XmeaQeYXZm5ZDFS9qC/6bOgnbMNjSxmEuQdK6KwNlPnBPDLUHn
 d0TH7ZWzvKOOSK2KLJn/qjBDM6KbOoKMQldS2Wh/dMk/7IM9QW/XXGEnV2dnWbrw
 cGfvRWIcPwY1ccG58MHK03Lb/2WrcrWajeoUYb9bfbGh4bTmdOtHl0ox7VJPqD7Y
 7WCMIVejuXnVoat8FFRk3M+5fxjz97Hltka3CKZQCgRcGdMlwyqqvmJGc4kzLrbc
 a24LDEIBej1lXn7Qc1efwQr2upDELQpmH1XL5pC3a8CG

For rewrite error handling of ocfs2_initialize_super, change this
function return type from int to void.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/reservations.c | 4 +---
 fs/ocfs2/reservations.h | 5 ++---
 fs/ocfs2/super.c        | 6 +-----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 769e466887b0..a9d1296d736d 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -198,7 +198,7 @@ void ocfs2_resv_set_type(struct ocfs2_alloc_reservation *resv,
 	resv->r_flags |= flags;
 }
 
-int ocfs2_resmap_init(struct ocfs2_super *osb,
+void ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap)
 {
 	memset(resmap, 0, sizeof(*resmap));
@@ -207,8 +207,6 @@ int ocfs2_resmap_init(struct ocfs2_super *osb,
 	resmap->m_reservations = RB_ROOT;
 	/* m_bitmap_len is initialized to zero by the above memset. */
 	INIT_LIST_HEAD(&resmap->m_lru);
-
-	return 0;
 }
 
 static void ocfs2_resv_mark_lru(struct ocfs2_reservation_map *resmap,
diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
index 677c50663595..532d42eb6db7 100644
--- a/fs/ocfs2/reservations.h
+++ b/fs/ocfs2/reservations.h
@@ -78,10 +78,9 @@ void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
  * @ops: unused for now
  * @max_bitmap_bytes: Maximum size of the bitmap (typically blocksize)
  *
- * Only possible return value other than '0' is -ENOMEM for failure to
- * allocation mirror bitmap.
+ * This function does initialize resmap job.
  */
-int ocfs2_resmap_init(struct ocfs2_super *osb,
+void ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap);
 
 /**
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8391592817f8..f91c5510bc7e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2111,11 +2111,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	init_waitqueue_head(&osb->osb_mount_event);
 
-	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_resmap_init(osb, &osb->osb_la_resmap);
 
 	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
 	if (!osb->vol_label) {
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
