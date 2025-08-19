Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012005.outbound.protection.outlook.com [52.101.126.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E129F153BE8
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Aug 2025 03:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755574213; cv=fail; b=Ut3ZfjMsH+QSij5lwqgZy4FNAcpsFKMzmCsWSt2Ij4VsdWqYWqFX1FFlPeJYItfnCN2AH2iWYGBPMA/b7t2EbdIANGNu1jSRloVKoaznlbLruk3rqDdRryCrFgEm23/e4W1xhcnS7+8+2FdClO+naei5rwc5dnQpAVeIjjXfEoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755574213; c=relaxed/simple;
	bh=hHJH7xCkbTQ4vicOTq+af6dRs53lE1FB9/xiJBTHyIc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=RsybQ+bjkf4cIKzs0jcysMe6bZ+y0P5chWbzHnt59kWILV6MNGbLeFZW4EFnAm5yalqYmvumJMEByC76htB6d70vYiM/qHzKi2KFgUrMKPbWMDHkrVmEmUhOMq005RIvrDVLZzfo0DQpVrOiC1HO7weg7dmSkbm05nUqMYGzPcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=VlX+/DXo; arc=fail smtp.client-ip=52.101.126.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="VlX+/DXo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gBpRFen1PwZY4u4/5cIru4e/izEcOu0vps6UPbBJJCDgyyniANMBEL3kqC0WFfEXo9vzd9O5thRtBpzs7v9VZuAGeT2ENwbGtWoWpjQIrASD7CwgV7ucvD9CR5AVyX2Ej3SsCBbUyExiZ3bUimpkkhZ2XP06sDjPWOpIqW4KZdIVQXhU1YynsuP/x8hhRKwy6o1XckBOMyRe1ojnDF60orl8pAJM/W3nkjv90CHCWZmzikMc+8i1XypQpt46STTprtkDSQ6hpqTB4lssBIYX2bLFa89xZr1QQ+95dfjxPPGLM4hXZXKoEHQVJwaGNiJvvDvp4w2ZyGVw+2OmmHpvBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71RKdE8x4uK+omKwDXu+zyzuFMJVo/7f9EUanl+8y/Q=;
 b=BJTvOuN/jD8hN7dJ7I9VbEe6wMdlFSOhB0TclLGsOKieWsSiuA9eB/YYcab1mKfrle4wc4xO8XMxC4Y8EN4OYZJMfR/Ya134nOMmTYthdIkG5ONfS8Q3ge/k7UOxPflXSpZTYKUl8UEE8BM04Sdp3teA8hHfDOvSTgs3i4WSRox1CMcvX8gaKp/3Bem6Ll3Fs7wZfXfbbZ+hABQkZmaM05+FiOfMzHo72w6bt9cR51dhnsBAplxrD3Ryq28osKD8rBj0whnPKUvX6wTfpJt1p9yR2OjrEYuaK4MHCXPmrg7JhLjlYJm1VnlJGH53JKYV0z5sJUG8+jmBSPz69Pm6Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71RKdE8x4uK+omKwDXu+zyzuFMJVo/7f9EUanl+8y/Q=;
 b=VlX+/DXo9jyr3SP4a5gRxG4OmHs5tuS2iP5hcJ7oc/AKWC0b///gm28FTViKOXSoNcmrGk0MEBYWYRcIFWF7ILJL6wnl/AL8ndufluG/qRkSnqmzMb1GIQ07gbP/AgVJiOcoN/3w0s17Jne6+2Pc2jL+JBLYxnW17t9WgD2+1yC4NbiQ4Tf2DJVSDGyCye0J/TNX1gQWfeqEK5AsgZmhDiO6IypwMIfyps5yHPc+l/30ly3PABKTofzuBvjBEgPDZ48OIE5DtbU7v+IM2FjSHTjZFF8vVpWa9Ek95uEbI3E1b0kg8uGXuUsf09fJSvJvPTAGtmSZiR9fFFhYJLaDsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KL1PR06MB6321.apcprd06.prod.outlook.com (2603:1096:820:e0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 03:30:07 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 03:30:07 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Yang <danielyangkang@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	ocfs2-devel@lists.linux.dev (open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] ocfs2: Remove redundant 0 value initialization
Date: Tue, 19 Aug 2025 11:29:56 +0800
Message-Id: <20250819032958.426932-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0061.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:7d::6) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KL1PR06MB6321:EE_
X-MS-Office365-Filtering-Correlation-Id: dc8f9e6b-a294-4c56-49d3-08ddded0b181
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|7416014|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ADcSVsqo18iMkjSh4539sojHzJzLR5OOAeepLwxJZsnbRI3iX4IDJkJjL/JT?=
 =?us-ascii?Q?8n5UsV06KP5yi70fmSO74CK6m74pl+xybraYk8S66v46BWrXgxrLedPja+uQ?=
 =?us-ascii?Q?alfP3rZZlmyWH5YY9Qk9L/ICnthfkIJ+DxHf8efGNAeq7CYNdjZvHGmNsDj+?=
 =?us-ascii?Q?05IwjyxUkXi+IDTEfv50hYBWM7RiwtG7ECeFh9JA+BiWfi9HlYooc5QBph7w?=
 =?us-ascii?Q?SmhfVhNVev/AXBXj0PPLNIM0UCBaBO5ZJKm0H75hgG99cjx4UgrXZ0AXbB6j?=
 =?us-ascii?Q?7/dY2PwOK0YKWS9RkVGsTSEh62aE/m7qCcnvqrX5HkZNYfeH266w99GzBcjG?=
 =?us-ascii?Q?93dQKdh7N0t5ywxgKHRZV+UbfXIwqwYfLOeQHQF4h7ysTDFEZGIuSzm67Fx/?=
 =?us-ascii?Q?ZE5gZ/YVS4qyus2naikKS96/xux1FcktoTIECi2DlzjR/WQp6gQTN0p61rzG?=
 =?us-ascii?Q?DlUw1vaX2zBo+8XTnlZnj1JkXZx9rUbDBXGk/5OblWa7L3JTOuHpEeXhGKsu?=
 =?us-ascii?Q?FWGq7NQTT17QL3A+HI7rE4rmG/sRHDf9cvIM8K4Qh474TnjkXTz+zbCghIo4?=
 =?us-ascii?Q?aU9NyCtpWLrQYc1WUEttd59qbVSFXSAIE/cENU/idFZsZY/qZ0dxAxlD0ARf?=
 =?us-ascii?Q?znYWdbEnPS/WT7Ln4BV/Ty7I57I5Jdz1Jfmo+6CjZbyqylBbMA/EVTwJxXCh?=
 =?us-ascii?Q?O2M7nWaNHsxObgP7TvCuH+MKV7oeVVe0YlmZ1BMXdapnnfmS/1dIWuYnAelQ?=
 =?us-ascii?Q?fKH/t23/0FBQFD64BTwSrvhlKDVMzJFyGuMW3fwVPwKx28JFngfWXQkfiJdB?=
 =?us-ascii?Q?g0HQBqvXf/D3JUKMg/yFexSSHMYpeVbXPD3LZcj1Rdd+UfaZNylBwhQR7jiw?=
 =?us-ascii?Q?/hLgffWL5xCNvbVOzwbBCF2kfcfarBMhvujkG9JrxyBS1L/o0MhUHR/za4M9?=
 =?us-ascii?Q?tAm0rKrjZq9eUx7RrrKSYQ6bkM4VYYbMV9BG+9071Eu2EABh2fAeNzB8VuK3?=
 =?us-ascii?Q?56X7pSNWlgQdf6QC741keDOUogYoBOjCcCeXXxmnuWVjiNw2xI0fAIm040BG?=
 =?us-ascii?Q?YFPkUUA34e6uqQ6hdvG66RhOoWehH9k+JAxhg0IWf4WaqhV0daO9dE8snCS5?=
 =?us-ascii?Q?999djfNelZcrvDMjlYKVG2WWGqUV4FewXUx/2SrYhdQSa7pXUa6fvieMPkAI?=
 =?us-ascii?Q?ycGh9hiHyeWN52kep/zmSLllZ1iJLcLlXhdZ3/b3tGJikP6D5QidJEcE2dXj?=
 =?us-ascii?Q?UYWz3I62i4tLKSU6sh78hWIIPmWTYvzIJQHt9/tUNyumcsN96AT3gB8+5ccJ?=
 =?us-ascii?Q?F2INLAU7Vwqk+ABkn6OsAiBYzWn7iRan9IWAykQ2R9gttr+Pb0MxgU4rETbk?=
 =?us-ascii?Q?a5Y0AY1zs781JLkQOs2JWMNTbtwq3AuSlyYuQ1A1Orgrn5EESd1Whw5jv5aM?=
 =?us-ascii?Q?EZdrQYlHlFcCzjpvNQmr6f8N3qJhvuWMNv3XDqshgy8xo8nj7x5vO++UyMu9?=
 =?us-ascii?Q?swAvjgvPSkahDXU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(7416014)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9fFHxoDKL+TQDMjvuv3LuiDWiNuZbR8rF7ZxbNhK7VoSt1d5r56iX6uZ1zeN?=
 =?us-ascii?Q?MGVwOrru00fjjH275mYEQcObp/tqezYBIUyWHss54CnHp6Se1ho69q6Xdmtk?=
 =?us-ascii?Q?W27LBJv93VBGu1Qp7obqgHSctjs93fPYkCU+b1+qmbgjLmYy9sA8e9zyNlAj?=
 =?us-ascii?Q?bGmtlG8ZckMzpaW+RX3vc8QJblVp8gJGd6a61VrXhsfEKGsB4AD17lHPhECu?=
 =?us-ascii?Q?bwFviJOfB+CA1N5MI1uL8sF5T3+5P1jEolem5GIYPLR26IlVlCvKpy/4QCMQ?=
 =?us-ascii?Q?b62D+hkJKh7MbTEE1uDS1HUALHwOKGkbFKc86BbhT9h/BNOZj//3LgkcKcgw?=
 =?us-ascii?Q?w2EjQtJsWLANAl5vK5gvWW60dfRREUreqBuqOrwhxIMH3xD4sAuGDj7PThww?=
 =?us-ascii?Q?3Zga34fujylxAhxy+P7Oq4sK6m3syy184nDSiloZyuhtOHURQNXTuOqQSYtb?=
 =?us-ascii?Q?VBZg9vhIa4YBzxLHDjxtW0eOn77fNDf03or9oR+sp89OPmOditaxlL4hCkUU?=
 =?us-ascii?Q?iSq3aBkqJtvxGJwFCnWhjwqrZUM/7j38+r1+ZcLN9z0NXj95YiSP159duysF?=
 =?us-ascii?Q?MVYrMHd1nnPvYYIp0/bmbdyUJ9QXH1h4Zs0pfcdGro4+olCzxAZKEUAOc3zh?=
 =?us-ascii?Q?ENPJy0EsdZ01Bc/vKI9d+9vRte1RhadLEPLgdIKQssoMX/qKzvYR9gcLj9t9?=
 =?us-ascii?Q?A84RGxcmqm/KKA4CCJ9xvX6vAg7etZP70IZKIwIfVr4UK4yXjWEaeDvaEyJG?=
 =?us-ascii?Q?mGNmcBDFeiGoNg7HIuqIR1H2/vLw2bz5md2yGptJ+qZNFw4CGwlUssCDkyQc?=
 =?us-ascii?Q?7GdaSN7U04Lk83NYMzo52gF2u8ISJdoZ4WGxL02IjCs07q4ML5zT/NpF1dFI?=
 =?us-ascii?Q?YXvVcUVdjx7dzJuNW18ED3k7q43uGr5HoeUTUqyYBmmfgl1T9gJ+bQmg9ZOF?=
 =?us-ascii?Q?8MFeyMW/iCD4aWW+xkax4H9Ib+XjFFcwmjK4CKFOlh9sKGXPOOsYf5guMw+G?=
 =?us-ascii?Q?2gt0R2OZtFR1Jljftu+LxjLJwRUhOuTxbpG92SDO5MmUEaIprEAiOj9ZbIt6?=
 =?us-ascii?Q?awEfCfrbMdOPWuq73ojjA6X/XAoKd3eRZTrIN5zkqiCYPiF8D8AG/rPnpKii?=
 =?us-ascii?Q?ECqU8MByibTVAltrSPPTwX4wTuRJJ4cS3RtrAGY4T9kAaCCfr8/WlijUAsxG?=
 =?us-ascii?Q?exYfG/YIK6xqtqfpyJMrUe1yDzvNLF9zq0NcqlqNSmjJCUhLMGtO7//eB1YN?=
 =?us-ascii?Q?/9enR5OuGBftO1N6UA7xn4Ib2sX86CKBOhsTMrC5JotIUmrcjGfRpDdhqnVd?=
 =?us-ascii?Q?5/IYtdjlrVgm8y/5yjqDF6RY/I9Jc7JAiniu1jbBHowXjwdl60RjChf7THME?=
 =?us-ascii?Q?iPwogopwXTnbNVsvXD6vtiVDMCk4GNIceq531dwe8w+4F7r7+WET9dh41xbu?=
 =?us-ascii?Q?IzhdT49RsH2qKu0ZdE6uPjlt9Tw1/SH6ZXqc9O+MryYiiHgfi2alB5u7XIVs?=
 =?us-ascii?Q?B5z5RpDbYcRXIHm+IWdN3dkLdO3IFIKB1lMteJSD/NDLAPkAd0VEbdHrXoTm?=
 =?us-ascii?Q?jSMdEv4euRMhnXj1jYxgvlQRsoSng/RT9rcZuckI?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc8f9e6b-a294-4c56-49d3-08ddded0b181
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 03:30:07.1653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6JEP97jUZvovbz6HdX2rxF1nUew5YfU2uwHTCzTwAUq/I32RL+7UGc1oeHY0Ae7pxnIDKHTISJMlIbmNq7p8pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6321

The o2hb_region struct is already zeroed by kzalloc(). It's redundant to
initialize reg->hr_region_num to 0.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 fs/ocfs2/cluster/heartbeat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 724350925aff..18150dabdff9 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2011,7 +2011,6 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	}
 
 	spin_lock(&o2hb_live_lock);
-	reg->hr_region_num = 0;
 	if (o2hb_global_heartbeat_active()) {
 		reg->hr_region_num = find_first_zero_bit(o2hb_region_bitmap,
 							 O2NM_MAX_REGIONS);
-- 
2.34.1

