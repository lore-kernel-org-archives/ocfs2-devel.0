Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012027.outbound.protection.outlook.com [40.107.75.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C3B203710
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Aug 2025 13:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756128979; cv=fail; b=fuhcKQKXNewN87TTJgP7ufPj0mLJXd3IvFZB+LNhm8oVMx4NtIqWN3V1wH79QaqsehwUKnfBBBdNrRAIYekBbJ/th9yAI1EH0FRw5LoO0ubNUB+lqJGy6y0M//bqaPD576oT1sjNd1jTaFzUvLatsNrJxY00vK9mNVprC3Rcl+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756128979; c=relaxed/simple;
	bh=ZTnsAu49h4ihnCgRZeIY9ge3BPbAgT0VfwCFNN92PWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=ln7KLempqKQj2x8JnGFvgn423Dzr5Vjj/FdhRrrbcIEVL5InAw6z2U5rTLkooZwkv4icNNwW390ribKY2qANSMXISKjKLGb9pRwOB/blUSVZsLMzM/U3VKznMRuPj+24sVzm3vIasVUr4FZJakOc2AcNJ3G4Pz9WsWm9Eq9auD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qQwJdhVi; arc=fail smtp.client-ip=40.107.75.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qQwJdhVi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c3kXaWSK9AHtEl0lDplmLR5yUAb/5Cdh/Su9z4l6rDTsASxFmAONdS3law7xUxudO8wBEklt2USDSjWSRmCxfe2PdVfVdDS1BDbZJsG4THFEtP1oB+1pnkf0t+VDx4psGMUB1JY9Pz0+KhCQ27rm2NQD2d4YrAosZWhQLUrgXjf1POa1dAXmFUlmgLuD2C9uKL/H4omxo2AUanz4X7TGkqGDJ9T6Xnzmn+hOcGU38R/XsuMXRGdfzmDp22v8UtWL9/jEQZJWcvCKSAefIcK+8PlO6Q7662hPzc9NjJ/RRShHlgzm1/Gfka76u+T2hHVo/yPHhBINnJI0CAd3qVcJbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOpAC3VBfx5s/XlF0n7DJDqQViyyMZ4dcU3ck0lJf4I=;
 b=tUcNgZQgKOye4HObpKUEwLsqUpxg/U0hcWatnUGW9KX2DzfDT6dn1ZB8Pvrkz1p+W+tPB4+dZQ3Q74XV0WtCnOjKmH/xEvg1aF1Tx9uMbkDrd39uGGShvDjjKYhTOH4wII2YnxcWknw0+dPphwiHC6Y6dHMy1+nYMNr9JxHwDWltsuSge3Wdus9FfVPiZYH7c1cLWW81AMH4byDi3DXwxFgZRw+LJrVhT/mW5zQ0XvVeDYDxpHfcpvjrsqvWet7+Uv8uRZIFo/PVwQj3CStN+8BfHNz/qgkjWSJQY6SIWD+tD3p1aqBUGLcZqyv7jn2n/pfAWYa8vVsHEZNYnJKiOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOpAC3VBfx5s/XlF0n7DJDqQViyyMZ4dcU3ck0lJf4I=;
 b=qQwJdhVil/uX5cGeugC+T7/CTNz9ZMIuMDiP5jdp+WFGhMIaXTg3wzOe9KlxwHdy73CKoOd8s/kYuanKTlZ9SaiL6vmoRBs/NHq61vR77h1NHGKIugFo23gNZUS+h9O7vU2niLDXM8jZSuriZ/1hiH9rX+W5X+7k1Q0o/ZFjclNTcnZAHlW8Ice1NzCP1cOs8UoCKdajWYsJHnZ9ABSBPRjlt/CCn/Lfw+l36ZUf4Jkzpk8OEDaeANfT1I1e6SWzcZnMpbTqFhuhJlmhk9gOo4/VpOWa1d90UsgozOHd9VCjSdcLC2ACmtGxmlciuEtnYP0osNliOHd/DkndyLo4Ig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KL1PR06MB6299.apcprd06.prod.outlook.com (2603:1096:820:ce::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 13:36:15 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 13:36:14 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev (open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] ocfs2: Remove unnecessary parentheses
Date: Mon, 25 Aug 2025 21:36:01 +0800
Message-Id: <20250825133604.337407-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0006.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:386::15) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KL1PR06MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: c5584b5a-2b4d-4f55-133a-08dde3dc5ce1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VNuEP0/1PBDJTuE+vo6l24eVH1TlmTMCrZtKDjBf27wdwvizePwn0T6YlUwW?=
 =?us-ascii?Q?nWShwLx9GRuiQIXathrLKWSw6+kHCyJac19R+IakTag6oVSJg5Z47A+RVNZ3?=
 =?us-ascii?Q?q6bG/4hx0jBU2s+vqIGeVV/zuJGcpwhJ7mQHlHRkg97ocJhDxagpyebPtYv/?=
 =?us-ascii?Q?Bdtj3duS/0csPlhi8+KT0wNYgB6wR4oiOZgGrQv3xViufo14ElhaYKW0xtQ9?=
 =?us-ascii?Q?LqsWn/Gkq3t3md9CDmxtHnQDtmEKveiGXXY7Nnjf4CfAf4wUZAxt2e3kKv12?=
 =?us-ascii?Q?jOqELuz7eiKczVk+QKE9SAOJzw+rbARAQOsbr2Na7MhRmIdGS1g4DHSF6SZs?=
 =?us-ascii?Q?hNwptHHyjHfM1HdNJrWwJjKZTmjOxudniUjxptjp1EoEi/rsL89B/O7D1cov?=
 =?us-ascii?Q?tZe9bfD9NRe2XVtf+DK3yTEtcyD+Lnjew7VpwrPk6WDbR4PC30hHWLx3C4Bw?=
 =?us-ascii?Q?chwxWF9ChF1rzhj+eqX8uLCcDuxBb3rivODMnhA7mxa74xkUE+5/cSYyaz13?=
 =?us-ascii?Q?N7lwH0ogy0/1aSsMA+yz+y3A2DtJSzudxsTemFeosEULuUL7ejlywcFIi7s2?=
 =?us-ascii?Q?Ji6l+XVF0oUYxWO9UlN7hQZvK5Fo0jkQx+hTtDJQt8DFc5aLY3g6ZehRU1jJ?=
 =?us-ascii?Q?+z4a8kI2dQVNsE1m1NPbu54ygZDJ5X1iHeluGajSd5BKE9dG9xKAV9dsUAkr?=
 =?us-ascii?Q?rESyLb9ZLXU4x+H1RPI6qDNrF3L3C94JRm3exh5/AKTV7sRzA7uejmOyVsfG?=
 =?us-ascii?Q?qeU4360jNykE+os3HQc4mIjt2iyStJi1kTZDytS5Sd1BSrKwcsH6JiJ5KeqO?=
 =?us-ascii?Q?mH9htDL2qeZUMOoxxcxTi/xeeQUEpD7uF3gRj+AVbpuE6FpyaDe6NAGqI/2O?=
 =?us-ascii?Q?EF8ke3YqCLPHHg596RHxNTAjgCmqwvN7xq8ZGXWulSwwxf85qtsMtMii5wZn?=
 =?us-ascii?Q?xEKoOjR0qFxG4JmFCabxPOyeQlfA9kSfVAW66C1cRyAED0oeBgFToHiTRb3N?=
 =?us-ascii?Q?gr/YUavVEC7jACwf/JTqpwiBODoaYkqOIIPb38SjBhKKI6UBgxylBoAs5p9A?=
 =?us-ascii?Q?ebu66e0iijNSlBypnHkWgR2vN+qT2GrEGX9oGL7oCjRP0+kDigA3FwDuq5hi?=
 =?us-ascii?Q?JNswFrD3YZHwRvtc1vuH6Rgz27jZEBFeZbah+6dMVNcA3NiVjTvxmmBuS2IJ?=
 =?us-ascii?Q?WBJXE8UiWjwx4eY9XD/gZtz52mFejMITcnJoo6xem4yl2FTROOblKhPHApJx?=
 =?us-ascii?Q?yec98aXM10sCp8MMi+4dZgOrys3ShUkGUXwYyLdMQz4hMhp/rspGJw8bES+n?=
 =?us-ascii?Q?qVLiWxTv+ERiHWbli5DqtIVJtNU9i1Py2Z8SSQ9aa2NNBXZdyowvMHnbZcRO?=
 =?us-ascii?Q?lf8gxJjmKGCpGKHVRqK9UjJdbpO2aQRW1dLOq59jAu9s7uEJIEv7qvyP3uWO?=
 =?us-ascii?Q?CzeA0DlZSeKy/4BECq0zl6v0zoVtm2Zpni63u/8g7xEmfu/fkQws4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lM0wUdSE4rrjMgMsfHZcn1BFmFaKPTVzNg0b0t79Pb4V5+Eta+ffZrpHY+ah?=
 =?us-ascii?Q?EA0KdCbG3nLLx2GldCcerhFnuzl1o4ERE481aB9RBXRfjm9wxuQ+whpwiCAG?=
 =?us-ascii?Q?+fubBm5wgcZABVQm619AK/KFHLIkaXNHgPsm6Ry0ynboiwb/jF6ni5cQzUV4?=
 =?us-ascii?Q?vABTVcX6fVesP/rGA1d/Qw5Ptn6i5yWiHDhi+plOyqqnGFab01ISc+eIWkJx?=
 =?us-ascii?Q?VLL4UBUYT751XaR3N+aX03FQ6zwTnCfEJhlOharbIFARkzpJHcCfJLGEjTvM?=
 =?us-ascii?Q?8WNN7YagHNy7aXsleYxVKj/fMopjtQ1azeHoeC9D8Rlrp1q1B82+vB7G7LEF?=
 =?us-ascii?Q?s+4Z7MYFW4CfK+bs3mmewVettYNoYSArQps6Gxj0nPsGglV+nw2qSGNmAvTE?=
 =?us-ascii?Q?4krFUmLVUW+XDfepU9yq1MKP3Ed6Y1gRtpDq8q+sxmSPCOTDKNcjLT4dcMQt?=
 =?us-ascii?Q?GYoxvw7DPO71NtviV+ttqOAxqJJ5VBiwYJiT74QZImtGQI73pwgeISZPt3Q1?=
 =?us-ascii?Q?e2sBsu6XNdr0RsKqfnfFom75Az2NlfTnqb1TdUOU63F65DXsI1ZUHpE6jhLG?=
 =?us-ascii?Q?aoPFbVKX8+pifssEhEg/NW+mdPBhiyONkpd5Fzca4j3cZXbVeNJpIp4mQuK4?=
 =?us-ascii?Q?pAkPO0dJK8M/+/YstJhiMROOgncIL7ALtKQNp/Oec/fVthOzwLfAisFFmI7z?=
 =?us-ascii?Q?nLqP8r+oNixn/t6mCYLGd0UsD3CTEl7mdZHyRkfMc06pYVv5AkRpTF3x7oxI?=
 =?us-ascii?Q?4moEgxeuQKyyAkU4sYGuWb2zls9hAQGC64KnMD8gI1fOz1C6hIPsBsTu1T4P?=
 =?us-ascii?Q?wALgDlyx3y4pYmtIBHNBTOmCqs4pZgEaao6CJ0fT6ObhGI8LRTqSy/OLBQ4E?=
 =?us-ascii?Q?59M20VJM8eNbFt42jWVthgZsWvWg7TOGxaUMLn4WutQNGZxnonx9O0ZFXxRK?=
 =?us-ascii?Q?3eOwKciVIbSuhFc8rYw5YB77/1g/KbGB4Qrqn5BtqqEw0iyzGQQDO934W/gH?=
 =?us-ascii?Q?iDUVKI0uaqTAq55I8ZdpZzHnyrDf3cIdxqtIrLE999v1qX/Gx+eXgCMkgeMI?=
 =?us-ascii?Q?qA0+xfCXaCZu1BRJE7cpqar5im8QqOK9RhBXcqzSqGskPlLo3D4aemU3Ehon?=
 =?us-ascii?Q?/y9baTk5PkFee2PhVmbLJ6ILcyr51WU9K2TV4ISFUR5FKqWGHbmzzTMwElBc?=
 =?us-ascii?Q?v4jF9rbQFPEQBVDs80FGST+kdUERIYFFTa3ArAhxncaFptJjREAMDKrqGq/I?=
 =?us-ascii?Q?pej27T0k5PI5jatj9WMls8QAFYHC2uN/JTytng93CfWfEi4QsZbhNdA9x5Yx?=
 =?us-ascii?Q?z12uPjEOQsP2agMSsfQbsJ+Yu8lDK6uqH1Fe8E7wcLYoBQndFndLCAnhN6Tq?=
 =?us-ascii?Q?bwNdz9WGrhNHnOsCXePo6tppRNGy3A7pWTBAr7/gxqGnPKmBCUiBCm4O4lga?=
 =?us-ascii?Q?1mQOZr0vgT3AAOnrjkmVAEjCy7gVdzfUVOojNJ5SQwKFRco1S/kNp92xI5vw?=
 =?us-ascii?Q?VBDbrgbRk7w3s0Wter+vaWf4H6xl5pxi1u3cvAxFWoyHriUFgBCgBA8nKsxR?=
 =?us-ascii?Q?/lxroNyc8CoOqPA/PyCE6Gq+EoPAcwNvXcuDACD9?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5584b5a-2b4d-4f55-133a-08dde3dc5ce1
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 13:36:14.8395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nyMnyVkV6IYgma+eRbi8ZcEYMKoXh/KTgB4GJFnDQfeHPoyxGe/7qBGne8NrPEVgpVrPV/QXsZkr8PmcPQnmoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6299

When using &, it's unnecessary to have parentheses afterward. Remove
redundant parentheses to enhance readability.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 12 ++++++------
 fs/ocfs2/quota_local.c   | 10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 2018501b2249..3729533db9a5 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1160,7 +1160,7 @@ static int dlm_match_nodes(struct dlm_ctxt *dlm, struct dlm_query_nodeinfo *qn)
 
 	for (j = 0; j < qn->qn_numnodes; ++j)
 		mlog(0, "Node %3d, %pI4:%u\n", qn->qn_nodes[j].ni_nodenum,
-		     &(qn->qn_nodes[j].ni_ipv4_address),
+		     &qn->qn_nodes[j].ni_ipv4_address,
 		     ntohs(qn->qn_nodes[j].ni_ipv4_port));
 
 	for (i = 0; i < O2NM_MAX_NODES && !status; ++i) {
@@ -1191,14 +1191,14 @@ static int dlm_match_nodes(struct dlm_ctxt *dlm, struct dlm_query_nodeinfo *qn)
 				     "registered in joining node %d but not in "
 				     "local node %d\n", qn->qn_domain,
 				     remote->ni_nodenum,
-				     &(remote->ni_ipv4_address),
+				     &remote->ni_ipv4_address,
 				     ntohs(remote->ni_ipv4_port),
 				     qn->qn_nodenum, dlm->node_num);
 			if (local && !remote)
 				mlog(ML_ERROR, "Domain %s: Node %d (%pI4:%u) "
 				     "registered in local node %d but not in "
 				     "joining node %d\n", qn->qn_domain,
-				     local->nd_num, &(local->nd_ipv4_address),
+				     local->nd_num, &local->nd_ipv4_address,
 				     ntohs(local->nd_ipv4_port),
 				     dlm->node_num, qn->qn_nodenum);
 			BUG_ON((!local && !remote));
@@ -1235,7 +1235,7 @@ static int dlm_send_nodeinfo(struct dlm_ctxt *dlm, unsigned long *node_map)
 		qn->qn_nodes[count].ni_ipv4_port = node->nd_ipv4_port;
 		qn->qn_nodes[count].ni_ipv4_address = node->nd_ipv4_address;
 		mlog(0, "Node %3d, %pI4:%u\n", node->nd_num,
-		     &(node->nd_ipv4_address), ntohs(node->nd_ipv4_port));
+		     &node->nd_ipv4_address, ntohs(node->nd_ipv4_port));
 		++count;
 		o2nm_node_put(node);
 	}
@@ -2001,8 +2001,8 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	INIT_LIST_HEAD(&dlm->pending_asts);
 	INIT_LIST_HEAD(&dlm->pending_basts);
 
-	mlog(0, "dlm->recovery_map=%p, &(dlm->recovery_map[0])=%p\n",
-		  dlm->recovery_map, &(dlm->recovery_map[0]));
+	mlog(0, "dlm->recovery_map=%p, &dlm->recovery_map[0]=%p\n",
+		  dlm->recovery_map, &dlm->recovery_map[0]);
 
 	bitmap_zero(dlm->recovery_map, O2NM_MAX_NODES);
 	bitmap_zero(dlm->live_nodes_map, O2NM_MAX_NODES);
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index de7f12858729..675c1eafc732 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -330,7 +330,7 @@ void ocfs2_free_quota_recovery(struct ocfs2_quota_recovery *rec)
 	int type;
 
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++)
-		free_recovery_list(&(rec->r_list[type]));
+		free_recovery_list(&rec->r_list[type]);
 	kfree(rec);
 }
 
@@ -376,7 +376,7 @@ static struct ocfs2_quota_recovery *ocfs2_alloc_quota_recovery(void)
 	if (!rec)
 		return NULL;
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++)
-		INIT_LIST_HEAD(&(rec->r_list[type]));
+		INIT_LIST_HEAD(&rec->r_list[type]);
 	return rec;
 }
 
@@ -473,7 +473,7 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 
 	trace_ocfs2_recover_local_quota_file((unsigned long)lqinode->i_ino, type);
 
-	list_for_each_entry_safe(rchunk, next, &(rec->r_list[type]), rc_list) {
+	list_for_each_entry_safe(rchunk, next, &rec->r_list[type], rc_list) {
 		chunk = rchunk->rc_chunk;
 		hbh = NULL;
 		status = ocfs2_read_quota_block(lqinode,
@@ -574,7 +574,7 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 			break;
 	}
 	if (status < 0)
-		free_recovery_list(&(rec->r_list[type]));
+		free_recovery_list(&rec->r_list[type]);
 	if (status)
 		mlog_errno(status);
 	return status;
@@ -599,7 +599,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	       "slot %u\n", osb->dev_str, slot_num);
 
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
-		if (list_empty(&(rec->r_list[type])))
+		if (list_empty(&rec->r_list[type]))
 			continue;
 		trace_ocfs2_finish_quota_recovery(slot_num);
 		lqinode = ocfs2_get_system_file_inode(osb, ino[type], slot_num);
-- 
2.34.1

