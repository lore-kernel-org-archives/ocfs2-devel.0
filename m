Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EABD5C00144
	for <ocfs2-devel@archiver.kernel.org>; Sat, 30 Jul 2022 01:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DFKwk/zZo7EoZDlgVhbo24GfvYX+BUgRQ6NWuC5jae4=;
 b=r2vd4IPkjXwH34eDi/ZeYrePEuXY+dPJYBC+kHPCns+X3JcSiE1mcj/NftVUhJGtEr3kTsS8CW02
   3dpPu5UBp2LyIllmwwANBj537HDaLmyoM3lFVqTPPhN9c0ILgy8nXkJhhAHLX/Mwtm72FndYGhms
   0q8nGNHRgc5LbTzr1ET5M1DjhU+mE3AwYWYL5q4gSns9Pt6XCktZcGbjpGiPdDaEvBpLVXZsXhcY
   AzA6qzIfxRDfoF8VnsNYbeddrymL8JCCwGY37OOR4WlL+rkg6wr2xgvD3qept+0J7ZV4iVzdgJAY
   yKech/341Ux3fQ3ZgFYrNAQVLZD+xFRE1wgxLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DFKwk/zZo7EoZDlgVhbo24GfvYX+BUgRQ6NWuC5jae4=;
 b=Dnpd75BoyfO1X+c0LaIGmRKYCnjRuA7LOmTatLhDyJ2PubgSDgoXeAO75s7Vc0GLakE5pjhLwvdv
   UIYdu4XKtwLiK9kVpH0dWNJmtMdZJoSSDDMgIe+vF4qPn7X3lXvDaiCFYa0bU7xqzdVgvVKBn7bz
   yAdUv2s2ksYwjZqwkYa0SuiuDi6pEfqQs6un6B8IPUMxnXw+4DInRjDheY7NkDVd7uIQzaaYbg2t
   KPuuZPMlX3TflDBqfeSZr5LbaPiCYB40KyDor0prplSCtnWjL7FyS2qPcz1YUYdTYqo03oGnkr/R
   fDHwY2tThlSb8R/DO7hwcqqIdrimWYwYFs1a9w==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFT00CDS7HDQE10@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 30 Jul 2022 01:15:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkU/rtGkJDSMy1C5dAEjpDBzQO3elzrcTJm5MY/EN4HF/AKmo5M00oLQhFkF1rtSFAFLGMYdh5tJ4TEsQxZvYptPsdxjcta81B0bmPJhKKyVtULcpn6ZvuuRSYYriioXgmfV9vEKW/tI72vN8O6n6Mh4geIoMQukYAuoD+5FzGGX7LkDVX4B4tIait04em+xu9koHOEPhf7ZEZdAg71VgN9YMWb6Ie6MjAAFKyv32KlI1f0eIyVSjX0g4kfYbLWMM99ctRtVr21+qAxW/gX070jumIgf3dK7NpXftq6iT/HK3G76MD1zU5BZkd5577ofiuKWAW85Q1tNQLmltGxzfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kQN82qkD64NVy4vaY1Km1PQQDgXtKTIcRmnSUVpf04=;
 b=epkuMZxis80wAkx3fjdPYbJlL/SDdQknWtuARca01JrjTThVQSc6x5i/I33STW9Wnof2xkoOf0mXTOexnqX/ZNb+bAcjkYdsBcMM9qNcyoHZCdRoZptqG7DtdG+Al4aIzyl0wi1q1fAkujEedY+EuB3aSyhMz9BAoX+Ax/2OBCC8dj94u6lAJASTQhdgig/GKIBsvO3WOo/2aJqTPrURbt9AB1nMQDPaiRg3nUYMjeXVwsszB2L8N9RHt5NW0DFrT0yH5Hl9PIRtjPBubZ2D9796Er5iU+W4GCY/gj1oVuMD9qSjJuPGJWoH8BRY9g+JXsSgYFawt29LEy8xvP8PTA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kQN82qkD64NVy4vaY1Km1PQQDgXtKTIcRmnSUVpf04=;
 b=sjDOJXztbU94L482JlM45levzQhIAqM/2JDy55BxYbEhGzv6I7UQvVvE2SQMxuC+Gq+wZ+4ow7Q3dP3zw4MCVZpHTPx7NIAIY2buhR8IeKOy+aTtmOJkO2tlkB+bMbeUsvuUQ9PBRo1n2eWOJGp1iEuGwESkrmq0j4z/ZBPSfla4NPY6haSemI7BL03L5aR3PhmGqRLT1ED+t3yLgWbpuJpE7T3taptQ9k0PH9hc3wGDCkuGQm9o92+2JyYERfOd62/nfYsmR63M+XLzPNyRoZlpCwWI3lqgm3v46T1Lm8yhaiFrHmIy+TTMXv217+XC44JhWt602OsChWW4U076FA==
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sat, 30 Jul 2022 09:14:08 +0800
Message-id: <20220730011411.11214-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220730011411.11214-1-heming.zhao@suse.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM6PR04MB4662.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(39860400002)(376002)(136003)(346002)(38100700002)(41300700001)(5660300002)(8936002)(66946007)(478600001)(83380400001)(66556008)(8676002)(316002)(4326008)(66476007)(6486002)(2616005)(1076003)(186003)(6666004)(6506007)(26005)(6512007)(2906002)(44832011)(86362001)(4744005)(36756003);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2022 01:14:52.9491 (UTC)
X-Source-IP: 40.107.1.63
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10423
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=768
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 clxscore=243 priorityscore=136 suspectscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207300005
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: Fix freeing uninitialized resource	on
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
X-ClientProxiedBy: SI2PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:194::10) To AM6PR04MB4662.eurprd04.prod.outlook.com
 (2603:10a6:20b:1b::21)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4da20fdf-41a6-472d-7796-08da71c8e828
X-MS-TrafficTypeDiagnostic: AM6PR04MB4840:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 c76Zv51icaieKee4IYwURt0fosKCJR9M5hju4Xm4j4pf14Ht+IOWurHIqf9jas/tIDctFzOobz6eJg/qoj9/A7W8oGHwYX3S4VVjHlLQ21a5SKz5LARW3lw7TDLljjy1Mn33Fz8nnErOFlU07kiNZOnNtOG8SCaAOQiD/mT1uXhtI+ZI7/gYESgdJLGBAZvkyQCcJMie0bbt+jz0f2leWhlV3tyH/rVWB3w9eWdz3kZUhwJp4yq3wxo0hZjakFzT7yBcbsQzjkLqmzaaQI1wuOmcPaRHu0azpmW0HKP2zEibljU9T42xqdm89BynKbfP/QuHqqKmRLsC246XTK9b1uUd55dH6uoSwMgs3cj+OkiEJeaxRycS9dA8jbu7EWjKhqSgnrdGzTmLKLfCIlWQDHeIVJjDB7ckV7bt6P2dPZbm6EVCbBqozfpzcOgc+J8rIG0awjfo/JzOvgyUXeVSVaSHotdEygvIvYY3oEXH2BScU9cpZGCKav4SGV9B9LWqaYS178tca48+W7rLt28HeuM65cc0yar6afdWzhX0gA6GVy0lg1nr0lTLEFv1svShfgONc4jf2Eg/jp/p9d7pTE1FY/M47qrp/PBUY4iwr2Hehjtq3iT8L6hgkQZyCCPyg99Zo33H+VFUWpt10L5KNjb6MyUlIiPLX1rYYrgcSAXIt0XqJqwbSIcGAuSuxkgP11qwcIFSLhev0tyIBGi8s9lPVGlkmZj3rpLKGrUFf/OpJC4kRJrU05d9OAIfqm9a
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Qh4rqHCCPuw6HZLTyejPOfB/izGpphcDNVUlI8+Bcq/kHwoakThIayROfWdD?=
 =?us-ascii?Q?0v1+m0iWxutGWh3A+kYGEC4KIb3zXDC1G1rIXiaWZS3UWvP/Uz2EKDDzkbTx?=
 =?us-ascii?Q?yB7lVnllMlAUrKXcp0JWusMwtzXPHu6g+OHqp1P3BTeui+f72LIhPnlAN1Fz?=
 =?us-ascii?Q?ZPpy40u0S3rYadd+YHXrtXaYkxwJk3QBvYGLLNapsOrJ6onECImY8gLcqfxV?=
 =?us-ascii?Q?uBzrhuUXyOPTy4Kjp2XO0F1v7vVuET9oShFe0nfppajjQCmH9LbQXJ9sKCQf?=
 =?us-ascii?Q?gfO912qKJ6/0JLPwe1j3HeLdFTA9ldhUgH51BWrRdl8bD9eQoGnfm7sG5yFz?=
 =?us-ascii?Q?Jet0C0onjDoHb/S9JcZ+75HtQi3Id83oVUlZ0ppgq7Eq9aUuCkJkj9BcUdHd?=
 =?us-ascii?Q?k5yxxg7SIk1Zwk98VpvTAtvEKaLYJDlUYxmIm1LmR5wAGVU9K64vk+iA6mYN?=
 =?us-ascii?Q?YhXqK31eGnFGpvNROjM54UNoLN87sMMjsgfTtNBXTWz+53CczlT4wLiIqgkX?=
 =?us-ascii?Q?+TuK7II9NGeZ5MqjYTj7R6fwPC8/ZpXirBj519scu7SI7Jz/M0932wkOtvks?=
 =?us-ascii?Q?46tTgBSDTmtdxWLK7SB84w0cV2Wi2t6mKuxREzA4wESoz/k44QRlHUf1Xuk3?=
 =?us-ascii?Q?UW0VCG2faZj9DWuriga5JhPn8DwPFWn9hhc7RUEO5RK+MFNkWDSREjsFKY+x?=
 =?us-ascii?Q?JCp36Kz1t1DjAC5etBwdjmReMzKcUyLIwRSri7jaIoRsXk7YvBUVIqMPrgQS?=
 =?us-ascii?Q?LWNfUOJRoUMckujy5HZ/UsyVluMmQYOfPZCj/YyZzUGkrUyjFIxkJFv4NwCF?=
 =?us-ascii?Q?UjR+CPJSXNPP+DbcK/Dh6Ovf/ZZGc07XBOdixFSg7CCXJDYFa7xH8KJF/QIZ?=
 =?us-ascii?Q?1CXFs/g+bB/Nw7vSuH6wce36XIpr9gM9PQSthzlUVODah5Mz62rLQQnGgSrI?=
 =?us-ascii?Q?fZGqfiP9h4/tV+sRMZxkhkpyDP4UyFH0QL7qvPCPHAzmOADk8JNFGfBFNvPb?=
 =?us-ascii?Q?QnMhjzwNpbaXWcP9KCdILQQZpnmeutyhvgQk63OfdAbGD4E3W8+v9Nrpt830?=
 =?us-ascii?Q?tCWi+2GM+ttSlWUeOWI6BMutgYImnNbFj56qoGtAIhyUJS8iMhf8qNBMSc+1?=
 =?us-ascii?Q?mVNjFTU7sP34eWnnB4TWMGi4eON1i/JpVg8zLlDIQ+GrLgWwaM8xfccuPZ4H?=
 =?us-ascii?Q?je6MKFe7kYK5bqY1tSsbIegCwgD9KB3OqLSnz0pFk3tSPtGhhKQuYRri/jAO?=
 =?us-ascii?Q?iZ3B+J9owVHsb7st9OC7nIIMHPB5D3ydCK6lJPyAytwLla3eOug21lQ6nQwB?=
 =?us-ascii?Q?xVUr0m+yborSYER4eNq1YVWxVjdlTTqopUkEan3QhzzhrjskGyQszAzRCX8N?=
 =?us-ascii?Q?tSpZrXWQwV+sQsxW4st9WI/djs5NRY2W2SdAg5/k3NygCDE2YHn8SnUPWy6o?=
 =?us-ascii?Q?tHwjSY6kdZK2oRLkhO8sDxlsiebX03NV+zNGDxS0xegnj1sziGiIQVKE5hkS?=
 =?us-ascii?Q?W7+b4FPAKz6kpw2Iqr0y/WmJ1m95/0WzlUMEBaysE4/cIsIvrWqxq7IK32uj?=
 =?us-ascii?Q?2wdLNXh/M2Uga9pwBp0ZP2hCsKUIFmqixfyMTlw9?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 4da20fdf-41a6-472d-7796-08da71c8e828
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4662.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 27iKvAS6m9qV+MGTHp0NxuBAUbyVrdulSPmymUQXLlIAzjqR/N2XgOojqFeCZ0I1maQB5mgLX4XwAiBUl3KGOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4840
X-ServerName: mail-eopbgr10063.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: -qcCBBxQ0jY8zIG9JsOTjdwE9RRy_LHY
X-Proofpoint-ORIG-GUID: -qcCBBxQ0jY8zIG9JsOTjdwE9RRy_LHY
Reporting-Meta:
 AAE6QCW4jA13R4dKotUifuiEypCDC9h+J1uAefMF4sueB3OfoH+28MM5zXtB2GvU
 1heXzZ6kUKZXHTKTzsXBAny/TgGJLIeWyRJudf+xWGFrk7WcqtEcYoVjUKzpaRwh
 E7oqCwsOKe/abC0j5/7uHtvgnCEuO1G9YHdeJpQS30zRf3NJiets1E7Hm8Fck9NF
 jay4rs8MRsjw1wKe7r2zMp+rBkJGtvNpT64jZU3I1uXzgplKvFHdThhSYV83WCiK
 HxpP/RSg2j10XSnJhfzkV1Vdo7U03Vlfe4qq9lcKFDSz8llCEG6R2If2iFUKU2em
 fNuSsig4tDJxgYe2AREy0S2XXwwBbxci2+0PlIxJ+gcSEcfoUieYsDs46s0SSqlJ
 IGC6B05T1gABXdwcUUwEJJcHorBYEjc+aclLStKS9r0UuuVz+cTdpzLW2GLiUbfb
 y0RL1NOEtpW6OODaUf/DtU3kwmlOkovw8MFIV0XdB9y/KJLXqicSSL3vDeYl9OT7
 Q50B/g+9sN2hK8ZD12lF7xlDfOK66o2XhP9jgerQnbU=

On local mount mode, there is no dlm resource initalized. If
ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling
flow will call ocfs2_dlm_shutdown(), then does dlm resource
cleanup job, which will trigger kernel crash.

Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before
return error")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/dlmglue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 801e60bab955..1438ac14940b 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3385,6 +3385,9 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 			int hangup_pending)
 {
+	if (ocfs2_mount_local(osb))
+		return;
+
 	ocfs2_drop_osb_locks(osb);
 
 	/*
-- 
2.37.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
