Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB25C77B75
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=67G2oOTv2Ybfl3E3vIT49jrEFsAgJBrTEyWfzVGmbCY=;
 b=fKgdjfq5wEbXv5JSWeVt533QZWuGUVw49I6UoUbOX8/xz7XCR2yPztOTZJYUQI4SBzs0p9GqH/Wh
   YZx098Iv6tcXZUXLU6QPjmwuq0erVbr+G3Y29hWnyWIVmDlD4SdrYAeFvYGKz3lSNCQ6xANSFZo4
   lhlGuuvdE3b5swnlPN1m9x1p/IN/KHTllaB9z6HVQ9Ud0L8QsoLqRYQYkP0RbeQLJjhEKq3gh5dV
   9PArZ/imBY7OBTCmUHkXWOqOTxcCAw65jQ+/8gag4ZABNWUdxsw4hYbuTnjIj0ogAvXjGZ+xtnVk
   GrDFEJWxyMmc4xghcpUAoPKchwI+QOeQZT1T4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=67G2oOTv2Ybfl3E3vIT49jrEFsAgJBrTEyWfzVGmbCY=;
 b=ABEuEBg6fbKJSXzFZVutHhbMhLsNMa4F0To2iKHi5cVu5NTdGt+b4y6XQX14NxMNhZ8n+a4YD+KI
   ylepsL//x6/PyyfJcsLDtglPFuTiJ105Ewu9Eb+0LYMlK906weQkQ1gWM8c/xxGNDTaLdjtkqTI4
   MtLCzDSc9/QPut+absUrvxT+JMAA6+gUczvZhJ6AObOF9lBnVTuH+A7x6os3ySn+VuPSDpS55kyT
   PzC5AJojWp5BOYWVTXt4Ls5Li15aesS200vNeTXUqjzfbiv0QYPrYSFMre/qj52selY3CTm8TYvx
   0nGq9In5MbhYBwJ2d4x6zleIlaozahENNuekuA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00KC7M171T20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhPrJ2u7MfwiDhatX2Gt+Hjw2dVwWlqbbSjceE5z+NvV/ugRufrhTqGx3L0aHZ/MOB8fjs1Uqr162mUwNaG8H+LH3u27yL5R8Kt/mR+o17u88cZ+/Y2hS4j6s7D777B73IeGGn6jtSfIV4d3eNL7SPQiby7H7rypxfv+Z62V7mdIWkWzWHsrukyViP5MTHnkSIngFbN8f6F2SbQL9uRj9w66FqAExV9FowPNqIh9PFStioAYRCs4IvoH6CXNGIgS3iAA9aMefxDVW6qeFDCb5BoZkG/Nfec2mEI4T9RWGgV0lU709CqYu5LVdS4yZutMGLyqRKwt3CnnGDBtDbs5xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGyFWvLSoU+2mZB6+yv46/cKOs/G2aGN6o/I+8yE17w=;
 b=oMH8TD1bangGMdN1R/mOeBSkFZrGddk+b47R44yo7kSaSqJS0W9xs0lfUsgAquOXqJBt8DPs3qKW3K6cBMoCb1LgKOldon9sfPf9waY1kL0W4sm5vvtPUg5tGxCzbl5vIz75ccvyhSz8e2M12twg/o+I7Ic78G86MYN7rHefKiv9YhOeJOgg8Z5LBqkjvhk6FeD9oUnjQFNtTOaizPP3u7I26F6+TZKWfqgY4nMdO3fjrddFwZ6diEAoR85sANsZTaMxne1uv6tyql1Mq/uc68+P/eNkzpjQQbWAFT7SBuYD3AveU4pZNkdYkd4QugJtfPxG1YjqrjnuagebzTMTyA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGyFWvLSoU+2mZB6+yv46/cKOs/G2aGN6o/I+8yE17w=;
 b=gbsRCcHS67RA3jsVpo98DqoQo+E1rTaJiWplWrETQ9aI3zbSB0Bgb0jZ5sngjknsZCCR8dYmtWuvUv9jdcijDHQzNxdSYl2Uh70O25U5cD0EvPKwO3RdaygU5WmoEcqVaygXmqULDL+W6JQIwRPy6X0n9o5bPQZ+bG1S3tzNrsrXNaSoe5fxmWlvlZIeOEfMnTEt5jqLQVM9/WsLExc4/Qbi2gkR5t+446MZ5F6A1erzJnZC9torbra/6uEZjYJ9MfeS9CVniBWNftTIUO9Bs902yt4eQdSZrtJ6KyK5joATbc8QSeGa0nPpe6+CTXwWO3nd1MYd/4vACJ8B79SqVg==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Thu,  9 Mar 2023 23:21:27 +0800
Message-id: <20230309152127.41427-6-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230309152127.41427-1-frank.li@vivo.com>
References: <20230309152127.41427-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(316002)(36756003)(921005)(86362001)(38350700002)(38100700002)(1076003)(6506007)(26005)(107886003)(6512007)(83380400001)(186003)(2616005)(8936002)(5660300002)(6486002)(478600001)(7416002)(52116002)(41300700001)(4744005)(66946007)(2906002)(66556008)(8676002)(4326008)(66476007); DIR:OUT;
 SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 15:22:23.4185 (UTC)
X-Source-IP: 40.107.255.90
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=148 malwarescore=0
 mlxlogscore=729 adultscore=0 clxscore=104 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090121 domainage_hfrom=9102
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v3 6/6] fs/remap_range: convert to use
	i_blockmask()
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
X-ClientProxiedBy: SG2PR04CA0168.apcprd04.prod.outlook.com (2603:1096:4::30) To
 SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SI2PR06MB4073:EE_
X-MS-Office365-Filtering-Correlation-Id: c0c74165-0494-4652-fce9-08db20b21502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 MRTfHU0Gm1HEODi3Ljfa6O9bH5g3gFJJw2IY9HPW3uhYS8xluRXK3a23y8m8IgGpmWxwOXO8E8KLYy+VPoBInNSZizmgycC1HobhuNxh6HiJx5AMMOoIulhfFQAWAFzjndOrHSp8c9vSSMNolIjb367EG0oMFWN0HYDIEfK1BQurQlaRZHJV3vNpVTSLkOSJZRQEyAFDQ6oHwbuZI1t2AeP15GDf5O2ynq7sDEdpI9NqjL3KLPVTuaqNjK9DIV5I5LC/oymeUMsaxjyVYWHSPSXk2WEGSKQ38258mo0rbm/D7AVn8ndkoIs40FByzSU0RZSZf9yTD6rR0oe7XDdndhCoaJKgu4lZYY1vOl97vPr1GgwedDE9/H8A/RQe6Lio38lolz8WtPT1ZEQZzcowBk/GChGIRrX7gKtGUYM51W0mCSL/i3vdI4jB1+4BEVHfGTkOBs5wrtiO/y9RA5B3Nd4tWWAhKXaTRVuZZNtU0iIwFCwlI8OAIF09P9oxuwZTmiFGcJ5WF0l3zSJKtr8z64jtQYwXmjWeS3uUX6Hpi64W5B/rQFW5G7sRk67qcSTRUenxnJQ6LKIrh+tcvfGaUQqK8c1uLGtOA9YMNEx+uCv9GxnfF20XPUpHYE16U0mXC0itvE24Kr4CR0PACS7VAgPYyBC/pnpb2l9zl1Z8I86NpwOBRmz9+ZkR76uDHqbjUm7Z0Uyr2LZnmBSguI8CukAaXN5HBOjNXq+b4qhB42Y=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?VRV+D8aIKWmOGzclNTNYDfgBdfCsAsuBCvKpSVpY4ZJpFbS2WGAP3XmgSIV8?=
 =?us-ascii?Q?g/ZEryBB9wvUAryFpE/cFw79cv/TZkRBhp+VJ4A0li7G1wrv4fTIDlmnx/St?=
 =?us-ascii?Q?bbruLtiD0yubpbSI6fepTXEVkBgW8Upl0ugu1Jnfj1l63dkPnlzRdJRr/lkY?=
 =?us-ascii?Q?M9KSZixEezHDYjQR76WxaKvoJqLLEZMtrewb7gJwKLVhxJQ6zpSdga6G8tYy?=
 =?us-ascii?Q?TklD6Q6ByqqzB+18zioLAcU7bEIQGxLe9mX1/OOL8hc9Xu6R/hBTPYQqoy3S?=
 =?us-ascii?Q?eFMrRWt5RiNq0RkzkvTrXqP0eWNKymOSGtqcqG44BGkK9n+rKf26J9tr8snL?=
 =?us-ascii?Q?LCtJRC2VWbkwcfIkBHxEPoHYoTC3xwIA7CTZZB+VKATw/NFq+rdGTXkvejiL?=
 =?us-ascii?Q?SZPSD/yMT5NkiKJXQqeGnzbSFMXMk7PRwMAnJYPanYhZe0608lNeZiqUvW8O?=
 =?us-ascii?Q?DjmmSgi1Y/nZN/cW6q25pRCKDxyeZaMJ0YIpSC0msFpQ7TKTiotej20kyqIB?=
 =?us-ascii?Q?6OsKK9aBF63ANMi15aZv9DP0q9vL3pS+ZBM9/Vc0IGBDOaeLah7Nn+XM8ZH1?=
 =?us-ascii?Q?pvAxgajUDvyvk91ePNhuivBmisvk2NDma0vrFgEqIvD5PwHhb6tyeKtEJZW6?=
 =?us-ascii?Q?tdCnO3HI4N2hojM9MdA6tMErTWzo9D09fMBxwtwhiQ7nX8BgaSuHBE6Lr1We?=
 =?us-ascii?Q?rwuo/nLam1a8dEgJtiNtsKpKn5LPK4Wzs6jYPpsjNjMfn0ZWJZiUbHXr69Ca?=
 =?us-ascii?Q?2yN02x6iYlEK8KG3bIxJfcG5e67ddkBgXl5+3nOPIBp6+Qk1BagAO8V9/DWq?=
 =?us-ascii?Q?7JcUihraDqMlc6TB/EZsOeV+fylmMk4omEmwHKX5XCgZoQVpY5+J2itJdhag?=
 =?us-ascii?Q?HpetS5CoqXc5EaHqbBgIKlwEYXLSTklTUV4t+ZFOfb57ZnDTYj8e3qj7XD45?=
 =?us-ascii?Q?EyXAavkcBgBdwTzuVTqWgOICLmKjGRyIWgl7Y+6WyjQkPz4i/jvRYmSl82VP?=
 =?us-ascii?Q?U1x5zd7kn9G/7kxLVFbLwKTAQUvsU2NdR0/1QjT75RlTP+kbMDoVkK8oNvCt?=
 =?us-ascii?Q?eRSD8ezyOzl97uN36seO0YaMvFm0EPjqlh4fg0F/lWrLvgCBmQIBqpkNrmA1?=
 =?us-ascii?Q?PnJOio6WE4cM3TEmrc6+8iUNi2Gi9tnHaxmA3xiYb5UIrkoPLQXdApTMr4pU?=
 =?us-ascii?Q?KwRRwmE5QVCwMAA1QOaP6x9mzUBEj8sqscXef9+w0WuocvkuZL6ZbeUqxU4g?=
 =?us-ascii?Q?m0bD9Lrissn7tVKNZeIvhzyfE8vjf05D+SFDzI/SZotye/Vw55JMVTl9FUUJ?=
 =?us-ascii?Q?/5KJrJJCl3MK4HA5WPbRboWy3oiMNgRok2YfCc6eqpYeSWwULgrImjiaPqHc?=
 =?us-ascii?Q?9sN48rVME6aTQvbNcC2QmCDm20j7ZOjDrjzaFcTrFLBuHuuWwShq4s7bmbGn?=
 =?us-ascii?Q?7NbsqO/RRwAKr/FBBXojj4BuYH7HRtcfobHkefrf0T4NODyzQVxlDJtiqS84?=
 =?us-ascii?Q?ymvXKHVag4LBTuZukjiCevVx/NkjP1xoHu5Ng2KP/purCpeuOBSDqha2Vohb?=
 =?us-ascii?Q?96UInTivnktiMxiGg4kdvj9zWJC49ddJeXAquSur?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 c0c74165-0494-4652-fce9-08db20b21502
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 nwLsINpxtBm3ouemSErTJcMc5WkWVEC2EPQ7vFF10iaOcViQfcsG/LK6F48BJHDGgzO1bs6r1O7WX1uk5r9g4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4073
X-ServerName: mail-psaapc01on2090.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: AQO-EoX_T7n86YcEO-8XQRbeo3wn4iN_
X-Proofpoint-ORIG-GUID: AQO-EoX_T7n86YcEO-8XQRbeo3wn4iN_
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAGIXGW8tpGQvTDhWFyEz5/PE0jOWupXW3pbo285PXFPHDoF7LgnBMQq11spRstu
 2CBQpByeF0XCtrgxMmZQuPBumToE12CzI/TBZjyjDyjQe84VZGmrNsWk4cn3C4+T
 v9W/++sYtIOsvAoJsg9Er7t/WOrfqByuENzutP1vZ+F1CjEgoLRNWenrmG56T6ID
 rCFNJARG/qXhEdS01KZ8TQ+wHx36E533fAw8mP5vEynvw+gOJz2G+rDYQHH3jf1S
 mnZv6FF5TRD8jETPTTqkE3X0iawDVrhDF/KVWqkf7lpE5BwfVxVq6ZCXkPJWtPog
 81KAT1tkBIvXPaVWSWZ7mkr87G49Ur3SllZ3lOV0OZhNXu9sRurNrWSmvEZhN4PC
 RZT25NAJASKvaVkgXDvizJALdWM8oCDHZmefS7oslRV4BGFpyxN+JHVQbI/KWd/W
 pHPKNvLJRIzhiHmnS+LrGamoHoDgPPvcEk9hWuFManryaYxFaFl83HpafsMIEq6+
 rQl4N8J6QI3YVCrcsRCmB6FUEEHFPMde3Ja8656AHlKK

Use i_blockmask() to simplify code.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
 fs/remap_range.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/remap_range.c b/fs/remap_range.c
index 1331a890f2f2..7a524b620e7d 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -127,7 +127,7 @@ static int generic_remap_check_len(struct inode *inode_in,
 				   loff_t *len,
 				   unsigned int remap_flags)
 {
-	u64 blkmask = i_blocksize(inode_in) - 1;
+	u64 blkmask = i_blockmask(inode_in);
 	loff_t new_len = *len;
 
 	if ((*len & blkmask) == 0)
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
