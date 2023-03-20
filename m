Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BEEFC76196
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=U+W8xZKoR9T3+NWnSLTT0vXbyQ5EA9g3OvJLWcNfkx8=;
 b=uTMVK4sJOYTNyp+EkpfiC0XCq55O+HPx1HmeH02UbXZWEvVMqfPKE02ONPTmkmYVnWbJ04gNwvJR
   0usdLiX8zCXwzlWEZD2wp3Y+5CeHFXRu9O7Lgi3v3DFe2YLj78RK3Fm97IzGpgIQWwqtflgQIza+
   Yjh7s1JBN5IjBwKvc69AZdt2lD4KP6qSqnbYkhSadbSxxP8/JlKt/Q8KOyQ3xZ86g8DXL5EY4j5o
   IOOYRY/TG5ZU47gR7c3tVHyqZVWgMbTguMnfTdtiHrMdPDPP7jAczMAigm3QQie/hwYz29kq+P39
   xD3cZw1bmoyCvQReDZ1yf7gJ/EfWUqRwI7IYDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=U+W8xZKoR9T3+NWnSLTT0vXbyQ5EA9g3OvJLWcNfkx8=;
 b=r/GEdsPh4BVWksU7KWHDE3H8w+JQWUgIKR4B+4cv43bHDXi32CFVzwuxat6D6m5XuOoiqA9/7fpX
   NLV+W7bokMmT4e8P/V3ygPELCVfpaRvkLYVT73vGLwzV8dq8kVCNLN1ymtT7zaEkAuXLkTynqkbH
   IetO9SXaVexmKId5yVkbfkKiLXlyxSz+FZfz1rDbg6p91kyuTC0kn63ZfXQcbZvRkp+OO4ffxWtf
   WZK1PR17LoLnRypTlOv6hmCK8OzaATqKdjYUHGH8/Lp9pTfSTAugSHDlbAcRfqblL/XwTdnqhkEk
   igL4OqYLQq8XVHJxJdIt+zGfXCPXPIhvGrbcoQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00988M1ECIB0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bw6NAuMazjgG+pnIUPhBJZaXKI53zbIc8coOpaeUSrUVhSa5GnWzAFUbiVNsv4dntS+PFR1JhefIqvEU6pYI0QGQ93dp3Rwga2jsdBJ7ukKaojMmxMs+oGbkJOeB4XUC8UIa+bOWKHizpGum/hGzWVD2Gh6vao2PmKs//VmE+DjdTctngIcQYciIn4GWZA2w7/2V+ORZYHhRKCrch4agbd/SlO8XzLWHswO0duN1P8fcifuw30olW8HkOxvxM8+vXe9Z4RvT4dMkIjX2NJHZitqpdkbwWZZpI/32F+mfZg4GhBoAhQ2U/ogSX0F3EQO8Bshfn+yRrMI1ufn0LcYp7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNtRww3+WurnR/ssb+TOIf0NNF1vkQf8qeCiNRBrFJo=;
 b=gstabiD1ePKHrMRSO17DM1ZuhX6Sl76pgepb/2RyZZqklYl4PP8/UlfjN9hrhub1w7jJE03M2fRlLeQ8UK/k+/yaBWUf2kHDPxZBIYgFxWYIqZ1HvwC6y0nfO77EphAgmgjHmuYhVZ6bqf2UeN3f+G8m4fhw8LLkbcmEjCTtFrJH/I+55rF/9XB3s+0z0tLTyUotcIZ+Wj+9IjTAx0YVffRj5RWuHgVsF4d3lNj5e88MLRyN8eCA3l/pxJWeZLaTXOYb7DP6HFsSCs6SQh25nQx7N9tBPyB9yc9H+Q5Kky5Wlb+vgQFNTXwg20RTGkSyNgm4lUoZoIfHO+iPtyv3ZA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNtRww3+WurnR/ssb+TOIf0NNF1vkQf8qeCiNRBrFJo=;
 b=aBATDY5Vo3vpDuXkqimotq9ggiIvP1OGInZNLcfyPUBAsRdU0W+gMB8WCl51ZlLssRFDfOkAfkIoQIzYX0blXKcH+wJXG0lkx3HJJHRDcToOFO1UAKR5FudUNnFfpTy/vHodnh6aTSO5rICWrWQmk9rs+vJBi4MVSVuq2dK6ieGc3Gojfm4BQhPzw0iDJ0JldtkKHZGQ9zr8oUdRyrCgSJPYoOPCS60zyGAAnV+94w8Frhl2+oZD2CnGoznQ7LhHTwouhNDTWp54lPlrebDi/pBO2NrSyGJwN1Gn7nSB7TIkA6pzbicgwCCvTj1B03tQe0IORiX3bwCGvuyCQ9Pgmw==
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 21 Mar 2023 02:47:27 +0800
Message-id: <20230320184730.56475-7-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230320184730.56475-1-frank.li@vivo.com>
References: <20230320184730.56475-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199018)(86362001)(36756003)(52116002)(316002)(4326008)(83380400001)(66946007)(478600001)(66556008)(110136005)(54906003)(8676002)(186003)(66476007)(6486002)(26005)(6506007)(6512007)(2616005)(6666004)(1076003)(38350700002)(38100700002)(5660300002)(4744005)(8936002)(41300700001)(2906002); DIR:OUT;
 SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 18:48:00.2917 (UTC)
X-Source-IP: 40.107.255.103
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10655
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=98
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 priorityscore=185
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=953 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200157 domainage_hfrom=9113
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [RESEND,
	PATCH v2 08/10] ocfs2: convert to kobject_del_and_put()
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
From: Yangtao Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yangtao Li <frank.li@vivo.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR06CA0215.apcprd06.prod.outlook.com (2603:1096:4:68::23)
 To SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SI2PR06MB4121:EE_
X-MS-Office365-Filtering-Correlation-Id: 63eceeff-0fc2-410b-745b-08db2973a0ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 Fybil4OFEqy3zdSH/6jQHXx9vBcTAX7fZTM3qTpdn+GiNnsJ3W6NRcyk+xFawmnFv4M3eiTAY9V/LyAa9lpmAaiDvvTvGBXAzvrg1BO5TZP5dw75ZpZKwI+CUDNsePVpkAXzimqHp2KqnRdLHem3vG5h4EWWU8ESN2AENA/t1vYTFq/pL0m9NWVSQ8lmkPO4c3kPt0Bq0XR1zf6Dc4hUsY86qFlq9ZDilCTtDaD9s4Jq/VovgT1P/dflc/bRr5ChztybqgmVqp+Gett2+tIQRaPbASsGERVjGQn58s0yLlPMUFA7gBi/WF51GBNiVFaB26sC7Ha6vjuYO7d0IUb89lDKGgzHjF8E7TX6jd2JOjI5ow9l/DjM7b3Hzj69KClrLXzWPkW3TRTNS8UQB6/cpKdmzisD1IlLE1Z0MHa9RWVlrGz3MsuzuaOAu7sR1PKIcmTwfU3kYKuaHrjKrS4azyKdPnEpjIO9QaYj4P/j9EQETm9MMCV1nUrJb5AJVkEtVBGrGR3XfnArcPQPElk8jxJbF//6cOB0SCjtQXxLOotU66hjELsK4HxtqzRPp4QN97QJfNYc5jLbEolP6rForyxxQMCLBJuQrtf/4dpIpdILgQlR4saJCS9GmlZCMGvUL203fdLQWEgVlsFNLLVd4raBYaHPIu1GQTESX8cU/afG5u7ksPzzxbVUYXJiJXccsayyz8eTSl/DQpNZK0KZbg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ABatkFZpoQ8IdTUB4eOk5L1vYjpCBHQ5Fly6zDZX55+0KjR8exjk5LP+nnmH?=
 =?us-ascii?Q?YIOw4RCu4kFOkB2LMsJXvcbHKyL1DwSSewp3sEieaQkSIoezgsecNN9MFXek?=
 =?us-ascii?Q?/zvj99rzovFXF39O7QIgvR3EyLRE6sQZjUUZ6cwFtqbWI5eAJuJ37vq2mtTO?=
 =?us-ascii?Q?jmNjVTBq7yTIC/SQ5LYStxnpubLAhees+HKPyO+svDaoL0PHqgJj5kKhZ9Ic?=
 =?us-ascii?Q?QstJJ/3jSeo3dXK0p1GxZJwkToCVd2tBDqGmS67tWYeGl46QqYTczKX7fUMe?=
 =?us-ascii?Q?Y9oYYyLzdglkYo6MliWfVWmKrQHLjPJzMUy/f3k+eSfCofxPoEUZh/FpMxMH?=
 =?us-ascii?Q?l2kmPUWww5kvVRxveN5S89viJEBtn4Afg+y8VGKKDr+zILnnOXVvS6l8iyrk?=
 =?us-ascii?Q?npHreH4C6PNTtYwWiti/gmUM0lMyeT6btAJiyL4V4XMxN9ZSYPCjMDMpa6hV?=
 =?us-ascii?Q?uU1+TVSiqJTC5R97EH6ZcBrR8uE2FK05/F5Cj4ChQn797Ymv5FgpYGgjs4MH?=
 =?us-ascii?Q?Hm+GbqDwfwy37GZ+hDvmP911MCiuRkWOnjAZsplXih7CyRfh+ycm78ZziV5M?=
 =?us-ascii?Q?3EhT8oNjPv4sINVhStmoN7BN5o/LyqLFUsa+/MfVKf1yRtCwfispXry0TVMP?=
 =?us-ascii?Q?QvfYOpoFjoChKHv1FiDfyyNeLqaoVxmwMc8vSMF/CADl7W9qAQcQvI/Za4ZC?=
 =?us-ascii?Q?AWsXrqp6lkdzD27yVct5bP6MwxmJ+Egp2uf7pT6D3LpMfvJYmf4gJnXUGlGx?=
 =?us-ascii?Q?BqfEdV2pMYVS9i9N7B3ZEdZAywI7u32pDMCZf8Iyt3mAY1IZ/ZiiEG593C9W?=
 =?us-ascii?Q?qtiI7IwwFunkR7tGxKnYBHFTN6ffPUavTl5JiVJswFDnLHuYNT94dErLfCzd?=
 =?us-ascii?Q?7d+SdwTGda6L9uhj+SU4BUTKcV0/xUPeTdp1V1ez3pyor2TVU7+sDEcHwzKn?=
 =?us-ascii?Q?Kv/mpL+8g1iqbZd+yg5GeaZiU7G9VFuvHK3SisS3CNchSY1jAP8T7mCX+Qt4?=
 =?us-ascii?Q?v9o/bvmId9aDBK8MYBpntcgxzSfowd6zc/uDa/aWR7259mojIUBJPEoHIJ/n?=
 =?us-ascii?Q?kxLssDHUgc/tNin0cQAI4fn+5pQC7+van9XCdTxwao2dVd1PUQPWTRtHcHxO?=
 =?us-ascii?Q?7SwH8crEFZPmiZeCksc85ontkZpSN+Qf3xX5wwIMKDqpdQo5gdl+r+LE28KT?=
 =?us-ascii?Q?4loGfSxAKRzRpErsCxPA1kt3Ivjm+3SlTBd8+CaTlih+osKMgbfVI7ykSQpE?=
 =?us-ascii?Q?btt/cfKHUYTeR7fZfhMOF6rFdexDuJi5rxBT1Wf6X7JeN+Rn87rV4FJzSFgx?=
 =?us-ascii?Q?APXWKAVr9uIOcJb0owGaMRryFR5ZiIDGAOc4aP5x51o9pLJmK35MIMyGGmDV?=
 =?us-ascii?Q?BTWcgnnX9g8urRMVUtsS7AshaYkQly2SOYBMEiqsIg9QaC1fvPkfmzEP5MMZ?=
 =?us-ascii?Q?wpNFAyf08jpksNimWYOx/fQg4jH/6V3N79wf4mY/R66jcSu01JgM16ckwKK1?=
 =?us-ascii?Q?UmSm8E5RazleI/Mwdvu4LLXMV+RSyClvf8JgfpnQD5Ih8v708lQwN8ZKItWw?=
 =?us-ascii?Q?2iHJgO1Oi9sUJ87bBsdeL/fc5Gq4dZaCoNEA8ajt?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 63eceeff-0fc2-410b-745b-08db2973a0ec
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 ahDJeqPPStJH+6UOapanRMUCIqPoirXWDkKmXi5kbzwvOgOzZtcw9ns34UE9qAq0umexX9XXuupALxfY3UncZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4121
X-ServerName: mail-psaapc01on2103.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: HTxdJ5n_FD0Rl9VVwmKOsZ2zTy6Q4wgm
X-Proofpoint-ORIG-GUID: HTxdJ5n_FD0Rl9VVwmKOsZ2zTy6Q4wgm
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAEg8qBlNj+L5mMy/qwJPphGyOQZS3Rt9hEQkQ017GVmYvJLlozei99BpNbU6GjQ
 wLMcYOviJz4OEJCQ0sjj9HxigdlcBvjlxQdcb826VRlmyRIhqMbUOgb79DQm8NyU
 G3DvyuId6ZYUIlQbOlHCoc7bfWsWfy4bc7XmUdgk6DVtNBDGHt+h/1HqXoWaVG0P
 TZr29jkgYbTMqBhwh22/q8XARg0bHTqLDbM/bKsGXNGtkdyqnfcw4yAKnWseSqnd
 7PxAlzyuUru14tiDe0jBER6wMF22ZABXuwWZG1YzI34VvzN8FMXPNwJhnBt9S/ax
 XkqUKV9+dAw8YPGNd+RUWVhu5XjkxMSym8oh7UQv9z+2iiErZlfJOoqCMBIYitwJ
 xz00+cy8cBQqKnEXMVXEvrXCNpJPOp3ofcw3m+IQmTDtzEkHBEdTdjW0b8ghgpDV
 6IXyTew7vy+QZtwn2T0kA9gdTAO0IODAz0vQm2kjje8plSk0DOmaubTCY2LAH38Y
 zVca9qMGKI8XzjnZXayT+0XzVkPWIeHgGiiLwU7XXhv9

Use kobject_del_and_put() to simplify code.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
 fs/ocfs2/filecheck.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 1ad7106741f8..fb9cf601245b 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -198,8 +198,7 @@ void ocfs2_filecheck_remove_sysfs(struct ocfs2_super *osb)
 	if (!osb->osb_fc_ent.fs_fcheck)
 		return;
 
-	kobject_del(&osb->osb_fc_ent.fs_kobj);
-	kobject_put(&osb->osb_fc_ent.fs_kobj);
+	kobject_del_and_put(&osb->osb_fc_ent.fs_kobj);
 	wait_for_completion(&osb->osb_fc_ent.fs_kobj_unregister);
 	ocfs2_filecheck_sysfs_free(&osb->osb_fc_ent);
 }
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
