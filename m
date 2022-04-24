Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CECEC433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 24 Apr 2022 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=G6StvTkjNjz0MFw4+3E6Gk7iO8KmMvH9eCA1xjPYDvw=;
 b=H6BdHV+nrQNzXJqlStzEfljkxJwMRkRggzWw7SUnt2Sp+tU8DSkzVzS8LoFOOkNCWMCSGGAe4/2c
   +mrTvU1lilqeL7tC6d8zdy5MFfsgAvqpIgar5lZaxO7bUExliuhDz0OplM2jfvW435PPoygKio5L
   9ZJGJpPv33gAVD/hyVkbDYeHGDoLgTbNc+wJfz0plxov1/DX0VuXV9mmud9sqX+BjTaxYegju4GA
   AJ6SiKHAgXtWgghscvFp3hi7Fv1tdXSGo4Y3GNUu1BUXmmSFbjT//DjUFwF13mFxOoEdTnwnUcLc
   bFTbJ3oZpaWmTJHUOrpC2FH8M+jeXdP81E728A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=G6StvTkjNjz0MFw4+3E6Gk7iO8KmMvH9eCA1xjPYDvw=;
 b=XJ7KrE6H4gLskQcj1xwwBRe2IOUOwI434h0DXApklCggcyXj2eoQ+BTZBs5gIj4IX9O+v0OSjnAy
   vDZz5lPfN/9yHigOWg1nh09VL5de29y77D6noYV8acu9Bjw6MLwNB0Uny7UIMKh3hsSPSR312WU7
   wpXhx1avnMI8ghmj8VMpFzt2K6fLw6RwGICytj0eAiyFYISe/n164x2P7Uf1JC3m+4mrSJMgOkEX
   VWDvhqc0RVLN4EOzu/gCeVfq2PjN6uzEcS+d70zbWyqDZVnpr19eXXjLw9TbFI9NlI8qGMPF8NH8
   7PX4aWcCeDfhQYMKyK886fi95DxNMi5buoWteQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAU004YHHXYZ780@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 24 Apr 2022 13:10:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1650805834;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0sbg7O8JXtY+R55pKCtXwnb0bsA13gjsife2ckrBOEw=;
 b=d4W6GJlgmydjT6BlT6UztXK4FBEMfT9CpUxynZS0CfZhwQ91j70ywIZKp3vX0fOyxSFCu+
 IMa+ExmPmi40f/qUTIOjhdifk5QFjuFYWtWav1CR7TygOAp8jQlxEYY9VpgD4Mat5Lmo6n
 4VxVubh///UnpnUEPK7Y+4TINDLPLwY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMm4GFAR2GOFAI6MEN80TP2iym8+/9SPoxThyBJBkq/9n2o1qI8dzapDWdQWkWcxnpiIm5kxmZPRrMik9w0rQbKb5J50aw8HNfKJRjQujwFzKqf71LF+lV16jbkPDKLS89KcKfVxwCib6UAO4ISVT2Por+F60mVDSqYhHGRHbNW3s4roFtRegJAP71w/vQ7PwhEoxfJ6idqevnf/kFvoPJqYIaZJ1xQ8p76UGxIFBXRmOBjpw3sNWcBL55y0LhROqTD0kVDtrRGK+HSh7LTDBqTFp/pKR9ovbFNtOpiX3Xa/I67tLQ+uBo5v82aW5C1gc4g6hkKe6ayKHkHX9jlgHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJY4L7I9XnEaBonoFvGgNGpFB9BpgO/f1AgdSXXTj4Q=;
 b=SE2U5LLVbpG1gZH01J94PMzxxiGX5GCdTE6l7KyBPqGBbSsm46kFZMzypslYEnKmQxGyX/NOnu7Pj7Q1wdyrbYPiuwSciu9L6O9u5prKg4CphXwmj1+RahF8WBFQBOUrJbfeB60RBkgMVjWN+gFxtqE7icBo/az1+hPKthSPe9g0yF/ERrl6h2ulZys3cx46PR2s/dUhu7IcUGaWCJDhuuIBvAufDOHkOGlGV7sdybTgi7hqmVpIWEi6WmyZq2d/KEmFtU5wbvjNwwq4q7JceLuDCs+ijSMRhj0vm/I0AY6nXJrGn2ahRnJGpBDIjMO5jFypJW/x4KWH6WJQkSyucA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sun, 24 Apr 2022 21:09:51 +0800
Message-id: <20220424130952.2436-5-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220424130952.2436-1-heming.zhao@suse.com>
References: <20220424130952.2436-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(66946007)(1076003)(4326008)(2616005)(66476007)(107886003)(86362001)(83380400001)(26005)(186003)(66556008)(8676002)(36756003)(6666004)(8936002)(38100700002)(6486002)(44832011)(6506007)(2906002)(6512007)(508600001)(5660300002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 13:10:30.5871 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10326
 signatures=694694
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 mlxscore=0 clxscore=172 priorityscore=148 impostorscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204240062
Subject: [Ocfs2-devel] [PATCH v3 4/5] ocfs2: ocfs2_mount_volume does cleanup
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
X-MC-Unique: _TtkwsvmONqeRRpHxWuh-w-1
X-ClientProxiedBy: HK2PR04CA0076.apcprd04.prod.outlook.com
 (2603:1096:202:15::20) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 551b2f8c-98dd-49b2-8fca-08da25f3cec6
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3344:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0402MB3344AE4D34063C50D9B854B297F99@VI1PR0402MB3344.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 yFJEu/FiTe3Pot5LQwqQX2um3UEimQ/1JoztNjf71MqTpSQ+whsBlgHVG5ivByhC8pto+bkUsjZicL078Caea/0aM6gs0ORu+7iL5fqgzXVbo5SUjhT4ZESLuRq2s5ulyuH0TnXV8NICVRMbfn/lgDutMaWAOYLP/0VDz4/hfih5PXcx0acY9fsj6M6ANo93a6CROnoXP2z891RioZRAdw5Ga/AUEGMqkU7Em8wDZnTIY1aoBYzksq9/vG3kp9/l2OzhWGWZ2BM3PitNUOQFR5OMphou3M7Ko+lt+mzysFW5KufPM7EBwXBIV3LlQ9DKGHQ6ROslCKWwzCeC8oohi0l4bQGikG9+rUcpGr1Kzcugw1e/U1VWMI3BAeLueTf00fCl4g2gnE+VOpJ3QTWREKs+otu0RSYtyiRXh7xQQepZbq7p5TX6/sxZBrAYf9XdBbCKjAxaQNsSaysk5GlT4w5obQJgV+BfvLFFH5h6XKnAPImA0soBhw9/9lSiXHRuLbhxQV3zf68S6qbdpx59CtAE5AVWAzvSVV0OzLQgQZSwSsLibahc7fd9NJ2MQncu/Z1Wcq+ltXE1Y8IVd7mvt6AmWh2y+rCxB89iZlNP2cyzm1F7/rgpyZ9NKdUOuNWVUF6sb+bzpsbLqvrL2gLL5A==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?teUa6fOotdim+V0uBhMgqDfwmvOffSatmxuiNuJ8cuJHz5jADcw7Sv+P1h2Y?=
 =?us-ascii?Q?5zmNrEbWb7Ms188xzm9JzA2dJfwzVJ/Ce5sWgfcfRXFPHQ/0TXXHi++ioEJj?=
 =?us-ascii?Q?mGGGQobR8AxlUuPo+4AKvPVDhRuYHhiRbgr8331N6kDZlCWKPkrW3ihVSUj2?=
 =?us-ascii?Q?38+RlgLoLsGYVwGMP1NRhVbgEmsysbQxVVHvr6diYrRSolzpS0xn9EBjE8qV?=
 =?us-ascii?Q?xiP99dIlD21tLMw8YPQ4jcxriM9jK9KcRsbvmp9+ZMZuCQ0zUFQfh7vnq6pF?=
 =?us-ascii?Q?gRCGMwQXnmgdsHujW79HYoOfDZfbp0F4NvrCBy1q/VbcMG8NooTN0euJfKr6?=
 =?us-ascii?Q?C5g1FgvBJRdkl+cSgmka9D2U1V2AuY+r4rkIMIv5MRiwYyBBKSsB8aDKaLTd?=
 =?us-ascii?Q?77cWRekhP3397BxiNue8pRSMVdQ8Lbdp7jOPLL5kGQNSgdk/wO/1bOyp/QcS?=
 =?us-ascii?Q?Mh3m5KkbvSr1hxiox3XTSyGEjLaBmLWLNbAwVBr/7ebdFxNm8NZl5/amK2u7?=
 =?us-ascii?Q?uNr/ar5vMCos1ZbCrqemRgYuDZKsQ2FNjR2YNZF7erqGiN2AvADz8hjJEwbH?=
 =?us-ascii?Q?jNO/DXWg2pOBikv5G+rzFnOMP7Z/FdfUpKlhckLM0MP6gifkFxxEqytrRmlw?=
 =?us-ascii?Q?cjJW0x63XqrjdRtQf9mlx4mxY/KocA/R1IpKfUMN0NYptRxH0TCBgZAVe9/4?=
 =?us-ascii?Q?lN1dCaJtBQ+3mnexmXYyR0wOMqkNTqI4EiYsvRev8JpJCuouAVsScpxURw6B?=
 =?us-ascii?Q?xSbYsJviuhsrEQNat0/ECpDm3XKRghqt/BaZtxx/QcvaO+VpB4AxuMGjsDaB?=
 =?us-ascii?Q?pB+DgymG0sjFidLXLEhSdo3j+K0LCmFCz8/2a+rPW89tZoor9bm2FwwaTdBk?=
 =?us-ascii?Q?tGA4sf16OvoaatvhBnsfY5i4eNLiX3AQsXt1Wo3GpFBkWBZH6bCLYQ7Bb1K7?=
 =?us-ascii?Q?5WGIUy/4TwXZ2hP1pXDqyFpNyb48WhlSiqypDXlf6kWzNf/+OFyN8n5xdfer?=
 =?us-ascii?Q?vEd938O/vaFZa3g2zgK3YME5c1KS4klEy103o1eBNQ67VYAQtomR0f1tzQtC?=
 =?us-ascii?Q?TBi8zyZNNzb+VU7CfELima3Nvtg7UXUXYyl4IMcnlkaAVdoePhYjwvUPGSmd?=
 =?us-ascii?Q?hcG6ArlgN8LqZtJ5okdPtfHwMzs5wrHv9qY0KDtIA7fGfQ+vOqDrxDfG2ZAx?=
 =?us-ascii?Q?WTjn8vx2XIjeW5/aBepMyWK79UOhq6UFOJMK1GRLfWxXH7y16W6I/DW6faTu?=
 =?us-ascii?Q?oP+OMfuVhtnTChI3RkYYn+wRp+KqURARyxCSIx+sgVXgxrajrDn6/ybNao/0?=
 =?us-ascii?Q?X1WFB6sil7QH6ODUsCL4flC1S+AQqN/QoUyLNas/WxsOucuLTkSmSOjYlQca?=
 =?us-ascii?Q?R3HwNE1cN+8R/0Wcq6kygjwaoW3sAvpN/8k3iXYCSqXiOSE/lLCIWh3GI/t1?=
 =?us-ascii?Q?twc16mhoqCPkQ9HsimzSpPXTi6BY5501vP2Gb1xilGUzHfBx6ex9VCZCwt/A?=
 =?us-ascii?Q?9aIuuz0y6gJWpDV1xG/sIzfeDpHdYl/lWu+aqj9woBMMZREXYl8nfGgTta7c?=
 =?us-ascii?Q?8lQ9fb57Aa4ClKGZBw86H94Mro4+FyCaozthAolA1uFlHk0N9DHsC/r9KGVc?=
 =?us-ascii?Q?bVnPYbT8+1Wi+qz39VfXlbUXg0M574ATYmKCdC37HXw2qQcf7AiACWgc1d/W?=
 =?us-ascii?Q?wdlwNfRwc3QnqabhFpcYrcqT7RMBHC2xtoaC80dHHHsG9FIj+59fwc3br75E?=
 =?us-ascii?Q?uWNK63EZ8A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 551b2f8c-98dd-49b2-8fca-08da25f3cec6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 B8jTcNx4g9yFYIL/RhoDWeWa8RKQNueH22ztYVgzGXSdsXKdHwwFLKV1GHCtLdGg7AJaisWBahLXCul75NLXeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: OhUfBNFfcQNhNwL6I1-YNn1GE_Y2Xlkb
X-Proofpoint-GUID: OhUfBNFfcQNhNwL6I1-YNn1GE_Y2Xlkb
Reporting-Meta:
 AAErjhaL1pO6IcQiM9PfEhY8rbPELETTn2yYlKsLbgnVwAnVwcYl/e4RfGqiU6Zi
 5S3RujuzOMq7qJu4ISDIJMKFUyEV2D+r7t80avLfoIRuPMO74/VZrYNwYESOqk6B
 GemK7pVIz3nSmCGCnrVF9JxAD80tJgvYOf3JvyTRw3vLUywT/REWjSRPlKNW7RJv
 IOUeMZ5w+m4XVrWKNn4hP+HvJ/vCHy/QqAMrrYBbU7v/9rI76ZroJxHyEFWi8jgx
 mKcOE40jJSwdAjF+jOIwl64Lw9fP2758sGoDgFM05ftLy52N1LsKXP/x33yfC8di
 Nn22wi1bZNvHsVvuaOJhhQRpbbYu4aBMoXfEsbnC/3QaqIoIoMrAec2hvCxMtvYC
 jrCS+EBlqaJiohE6cFiNzTXF+P13x1NQg1uDEFu6HZxY5elT8LMr+FPc2vwIRrXr
 DRXMnCP2gZw2mwUSbEFDg5VYNlAG5YKrzUB+dTSlksIYZN87QqRHqM+rAVtPwqDe
 SCWK5VsftCR/cmdYRdhQtyEVF4bsepKan+XybgQaLH1kwQ==

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_mount_volume.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 758ea3313f88..1cf18ed8cf1b 100644
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
 
@@ -1817,44 +1816,56 @@ static int ocfs2_mount_volume(struct super_block *sb)
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
+		goto out_system_inodes;
+	}
 
-leave:
-	if (unlock_super)
-		ocfs2_super_unlock(osb, 1);
+	ocfs2_super_unlock(osb, 1);
+	return 0;
 
+out_system_inodes:
+	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
+		ocfs2_shutdown_local_alloc(osb);
+	ocfs2_release_system_inodes(osb);
+	/* before journal shutdown, we should release slot_info */
+	ocfs2_free_slot_info(osb);
+	ocfs2_journal_shutdown(osb);
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
