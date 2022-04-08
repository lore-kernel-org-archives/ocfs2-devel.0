Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB871C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4PPG9Xl8p2o5t+lCtUJa+Lar1d3RVSgNMZ0HBvA8NZk=;
 b=HKriWJlY8oC55wDiIGSLW4sOy7rsESaWubGgSSt6prinwEzQQP1x+3N55Bu2SDGVSz1MtzbczRfp
   83hf95dLv3501w0fqsyDqiwzqxcf47jI9IV92204KFo9w11sKGp8xjH+D4swplNdvubOSY5+NQoE
   hP/5qXfCZgYcw7V/0EmY1OCcUvzzwASmGlE5OgZvlycaEI9IISrMEto5FOFu1qXqUha8JAunxoBj
   ByhmbwzRXDUQaAfY9m1F4sg8sM4jl8zEg2Gee58wH/snHFmonH9gAwF44oOInSwxVsTDD7hpl9gD
   5ONnHeUDe6jX8JiNrEhKk/D25ELxG315ZuVreQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4PPG9Xl8p2o5t+lCtUJa+Lar1d3RVSgNMZ0HBvA8NZk=;
 b=OTS+C7lwG8VUM0hESSmeNq/SV00sQ7Exf9xO+3zboSBWBbQroLjlHdDRpe/DMcXJ4bA9HgREGd9z
   4g3ISEw8ZJfGYrHvz8+A+CYnBafTjVV1LOkjNxdZLjrhQ2Jvv7SLaq35YtDnPulIoeNmYR1R9Mt4
   Lhbq7F7JqznAn1KFP/QkbtmaRrPGg9H4bf1wyA5DlEPaFsPt0CEIbDMgFB1sfDIvDRVaHuDADwec
   uUNtncwXhyyZHUwiPB9ka653RKqroKNRNqevtEJjYihM3vk6VLpAfVOxRtrvC81Zl3EwLUy+c8S8
   Rf+tL4p2InhMA1g8kjIO0vYezRleOxpumVGNiA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA000BXPNWJIQ30@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 08 Apr 2022 10:31:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649413868;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=E0VwJg0EsOx98iokirLTTTU4yxYHEFunv/eWK/ICvp8=;
 b=UDZoRluSPbo69GzXYlWG79RsHaDDhSLlgzmx0rXBmeSuO2599kytBGS1G/V6Jxd+pxSKE/
 +ozHISptC/wHyWYQYjkQBGvTzAp5rsX1Mk2ZzGX8PeNbun4YJavL1GHVixu5ILCpyyo4DG
 htD/l3fHVE5RBKPRvZ7AwVwGJ+eDs44=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MrWWVddxJmdzdMaiQVg6g7+d1Gk4C91MlFb1V8lqLMkO3EbDnyVPAautE13f3YYpIGQdRi2ILL85zAdFSGdSKpQsEl6CWVJiolwrAS+4TedTKYyuZ+FUjX1KT7N4PYQwpgr3vKiEICIOQ4HYk20qZM+4lz+WcUGZumW6a1BgleFX4S/Uu/27ByyHjZfathTuAS9pboN6mgSUDnt6BJUmAUZ7en6RcI+pn99MQuOO05+OegbX2pgjHCpPzQmKG0hjLx6KtZ3n5SBnYi4CebMG8tNsI9p3VLA8baecssFqBTSSUV3e6HntVHFzoQrsTPumPKkOlUadVsYsfMJlekZi5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JfSen11lHLWq6MAoBbZBKFvGeiMkYQlwRnKIhDVMXQ=;
 b=FhqZlphFP+GwlmFk8Pzm+QMP4z6xn/jMTElb3u/TDeEXcB2q0sP1OoQNHXPGIENV3MUk3zKKse/NGQJNOQl+OHvN/xDF3lnxWI6xBylWRwP2Zl8B/+M197gH4O03Wdxj1I1T116ZXqvvzAAvdMs3JIJUgxmD5l9VDG8TCi221uT3a+k0s+jSgo/X2w47I+6mqxNtjfgqzXVLSyfSvmnBesgQC3EMIEtelE7jM8IiHTVImPRtWkCqATXXWTTbgKbklcLB42hXKPeQ/4qb2yYTXjKD2+qFr6WZ/C5G5tiFh1YAEdtFMlqj0wCBJbauP7zA2XRNQJwexP7FGH9uATL/6w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Fri,  8 Apr 2022 18:30:11 +0800
Message-id: <20220408103012.1419-5-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
In-reply-to: <20220408103012.1419-1-heming.zhao@suse.com>
References: <20220408103012.1419-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(44832011)(1076003)(6486002)(316002)(38100700002)(2616005)(86362001)(107886003)(83380400001)(2906002)(508600001)(5660300002)(4326008)(66476007)(6512007)(66946007)(66556008)(186003)(8676002)(6506007)(36756003)(6666004)(26005);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 10:31:06.1174 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=233 mlxscore=0 clxscore=183
 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080054
Subject: [Ocfs2-devel] [PATCH v1 4/5] ocfs2: ocfs2_mount_volume does cleanup
	job before return error
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
X-MC-Unique: bAPQRblFMT6dJ1g6rguFMQ-1
X-ClientProxiedBy: TY2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:404:e2::25) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 278b83a4-f8c7-422f-1280-08da194ae370
X-MS-TrafficTypeDiagnostic: PA4PR04MB7840:EE_
X-Microsoft-Antispam-PRVS:
 <PA4PR04MB7840683E9F8252C5E68792A497E99@PA4PR04MB7840.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 Lh3DRNTIKwNwwUBYPktnGATA43qSLkT0o4x9wArTOdlSsvGJhBzOMRzDBvVwsA57WEmSBWvy4C730CHdzVVd5KzxjJs9HLW1IS13IdaB36LRTZ1k/EiiJDkkUkkgjaE39UypYtb1fRW669UoD0+vp9YdMALAX7ukZhfA/ZmbZV2XaflLPNFCZL2WecS4sjgpOpXlBdCq/lw+CjFPHZriO/SHm7KWRNluZsppbD8OlBy8B6VYR2zd/qnHl/SxMlI5InfqVmJv7CWEqYLNwkvp8qFhA6uDc7v8JKSCOGevY5w/5qNVlZ+a2oum2yw4czot14eIN6E/rxi5NcblYgGjhtxBhMN5zWV+5ZQc6BoWlUMxBmvwnB1XQwjO2vPC4It6gpMkBXrn09Zya/MMatEqFxCvb/6c+WdPQYOUUkvsIeekNCVHT5c7FTu9MDKv+XE+QFSwgaa/ae5o4DzTEhUEEn+ybIP/s8PxSM83+I50hnAlyKdnMSZjtxMjNCtyOvwe+jW5VIQSAHzmTK/hNhTNN9x9VKEXurQpRsshNTo8brFMd7RM/T1S34K+WTjtLveIylpSxuSWiYYXLudhuFsh5aKl7wzFg/wvRsyDxpRjybsEVYQf7CaMER7Hr5UIurOeii0wzDquPyOet9oY/jYPIA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?YWy3hhEpVvcYLLFWp55KKtutjzO4fRqIcdl+3ncd4nfthlOB84szQCBHpj+P?=
 =?us-ascii?Q?Cl7UpKK/uP4QziFLpo9LYIL6KTiuFJ6TVFAu5hXe1yCA0CnmVlwYjhVt9yJ6?=
 =?us-ascii?Q?yBLMV7HjOhKMTU8dDdRk4S71k1IfxKxER+NqdNR5AFZXLpky4j/0+HqJiocg?=
 =?us-ascii?Q?A+LuVWBEP7UPYETWGgWDnjL4f3emFButy/CUEw7cOz6ZluiEf93Jcs0AEaWx?=
 =?us-ascii?Q?ewFGoLULs2+oP+s0biEXjjR+z+MuNh+iZi1CrWBtxwsToFFEH9cbsEpSXRKr?=
 =?us-ascii?Q?9oQHtTMla49LAAtfReethRzR6ZR2tXuM5B3YicGH8cm5NsOSyzmNcEjzxjQM?=
 =?us-ascii?Q?cGALd7yhBY6MGl1ZGgua8X/V5COVoKA00Kz+fL0mrSsG267PqiRyANd8CMWt?=
 =?us-ascii?Q?JKIJU8WAWDPM+GjdcfYBkarqtqZ0VDpax8arIWRIFusaIpxnAG3KQZGEHTEU?=
 =?us-ascii?Q?AH1kkUphGablrVSzonc128QL5/oIEYu3+m2hSKyL5jf67h31pxGIQOwMZVxp?=
 =?us-ascii?Q?CGSXi0udMCKiBre6bbzCELaqKsgsefsI8ST2d5X1KqhG9nLv5oonbYzOZpjL?=
 =?us-ascii?Q?Tm3MQ8PqyqYXJ1HNlIcOIphHRpyTpin1xf2kW/fsFpcnHRmDDtdF1C/7IlDp?=
 =?us-ascii?Q?e9aHwoJNrLZmrts/fDGg9Ym8CF3R3onAxMcyYxhZLs1bVULd3lDKFeOIYmjs?=
 =?us-ascii?Q?iS8hvZ3Yl3EqjhikExJimGRwClv0BKmQT8aqRAnX/b0n8qz1bQ7TWOluuifY?=
 =?us-ascii?Q?l7mecqfCqjO62MdTvhhOmz/+Lfd00qGvZGPrbXorUT6QxJ6DVPJBpZnFhoz0?=
 =?us-ascii?Q?Z34X22iaFgBZo0JyexCFG9Y1RR1RZVByszXf8LgFI+nBPUKWHwOuQSuQg6av?=
 =?us-ascii?Q?0BiLxC+wFYGUx7Cvt4fqzjopMLygTak535z1OAZNUo5uHP5YySMPvJ+0ytSF?=
 =?us-ascii?Q?7cmCuyzWMPzatJEzVoiXw/7qieKF6VpoNb/WUmgvEA0r3PJbaG6TmDtL867f?=
 =?us-ascii?Q?hHsXfFj+Nkg+C/5p0NRKxnonugX+syaOOaE9RNkueE01pD+4OFupjPIyN41y?=
 =?us-ascii?Q?Wt30Nn7q6vQnlia7nSB0/dvVHsaMDfJgCImoJqsALE9KuQiFCLceYTaMI+3l?=
 =?us-ascii?Q?2mHtYVapX4LWg0fK22CHu0ITJsxeDT5heDbBCWCAalVLNcAxFNwpnnNy31Z1?=
 =?us-ascii?Q?gD9z3F5zY7fF32FzCMsDSTnP+5fSaKCz1qZT94U90eNZp7ngr95OL2lynsQJ?=
 =?us-ascii?Q?wrb/umD0x7zn7kDdpUeyqffvZQHkToD0TQLrkWt31kWcK953coi2Gu65b8pr?=
 =?us-ascii?Q?1pug0S6CREhL562SNhBjggIWk7UwjKjiJXiMxI9MPtAbqhohDw/Y9mOs538l?=
 =?us-ascii?Q?ekcBLcTBmf0htL+bH5+8t3m08V2mhJjRIe+F0Ib47jxIDUTH1QvwwkbTi1+B?=
 =?us-ascii?Q?iZElScVEYvcJD3gPfb9nD+q9ooTHB4nd8GfQJJGkCxHB6sWUNRizy6D7g/GD?=
 =?us-ascii?Q?NieW0952vn/bBWv26WYrv6j1qaVa/W1gN11gbSQkWKWb0XvXRbIIroISeZ9T?=
 =?us-ascii?Q?gfYfT1rCZ4DHX/cMuYfHHulOybEwWLP8sd4cTGCNRkwHlYXtCWoOiGytj+3m?=
 =?us-ascii?Q?TBL6HMAzBO0EzqaIRdLbYbx7qWkYVr24hkkxhXPK53aEg09QOB/UwEuv7Aed?=
 =?us-ascii?Q?AHT1Ey6rN2PNsNyfmHCyVjUMVD4Qkmng339s9HtH6YS5RQ3418ulLNAJVyCc?=
 =?us-ascii?Q?5wZhiPKRXA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 278b83a4-f8c7-422f-1280-08da194ae370
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 OSt2DmYqmDJ28KfClMNsJhzIO4oaJlNm7x/llJmRCJERuOCXpCt1lcbo5srQBqBXXVGjNMj8aeUOChfeoq0e4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 1vgd2Q0Is0Psi4scbL6ApQOCPW9pqYC8
X-Proofpoint-GUID: 1vgd2Q0Is0Psi4scbL6ApQOCPW9pqYC8
Reporting-Meta:
 AAHuqZdPnE7T/tz8MmlKjlPKSvMXGK6+9gmwmLB7riXKPMHB8zboLxLqGJwEJMr0
 k8LXNLK6w8eoAp6nc3fX3VPcAhnHWqmrA9aYXSgkgdG8oMEo00qyv1RYmcxaZSoZ
 jsMk7gb7iU81+gdyKH9swWKOhQYlOGGN/Kp9TyAQpnqYkD+jvHvq4+1dtmB1It5u
 fmCixsAfmRhPs9PzNgKXyr21+41L7CzBu/s4Es9nRsZNoHfbgCll2a0Z6SGqQfXD
 MZnLTdoVja6o2/15lVHY100y/YX/IqgpupzRdyphJMV60YBZTtItlO0OohKLUKaU
 TmUNRtY0BCglqHfJJIjmg2q3de+q1it2XiAh+QflGIti6oBafTwDz3JK2l9bNnn9
 NDPxahcSGmjTJGaK5ooASqJFog87BQUanpQQ9PDiEVj24OhSYfaD3uJu/igWANyL
 WLN1lWz5QnzJHk+JWMXeJWguzVLzhkskEh3psC8uniWU5avgX8eIU0zohnhSHWTA
 NE7TPUGIIRLE2/9/gy0v9QR0UppJ5Ddcm9A2fA7A8i8n

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_mount_volume.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8443ba031dec..d4b7a29cb364 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1803,11 +1803,10 @@ static int ocfs2_get_sector(struct super_block *sb,
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
-	int unlock_super = 0;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	if (ocfs2_is_hard_readonly(osb))
-		goto leave;
+		goto out;
 
 	mutex_init(&osb->obs_trim_fs_mutex);
 
@@ -1817,44 +1816,53 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		if (status == -EBADR && ocfs2_userspace_stack(osb))
 			mlog(ML_ERROR, "couldn't mount because cluster name on"
 			" disk does not match the running cluster name.\n");
-		goto leave;
+		goto out;
 	}
 
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_dlm;
 	}
-	unlock_super = 1;
 
 	/* This will load up the node map and add ourselves to it. */
 	status = ocfs2_find_slot(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	/* load all node-local system inodes */
 	status = ocfs2_init_local_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	status = ocfs2_check_volume(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_system_inodes;
 	}
 
 	status = ocfs2_truncate_log_init(osb);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		goto out_journal_shutdown;
+	}
 
-leave:
-	if (unlock_super)
-		ocfs2_super_unlock(osb, 1);
+	ocfs2_super_unlock(osb, 1);
+	return status;
 
+out_journal_shutdown:
+	ocfs2_journal_shutdown(osb);
+out_system_inodes:
+	ocfs2_release_system_inodes(osb);
+out_super_lock:
+	ocfs2_super_unlock(osb, 1);
+out_dlm:
+	ocfs2_dlm_shutdown(osb, 0);
+out:
 	return status;
 }
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
