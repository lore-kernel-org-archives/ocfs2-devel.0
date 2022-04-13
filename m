Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E9FC433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yKtwdSoG6Mn29Ao82UIQQSbJApfuOAQaxQ6HIaBcutA=;
 b=KmISFVqwplennGlQEo2+1q0M4/esbiw+wUx8BAAMX18uI4A75B7cV3307HG7XTgo0e4eiGj9wyYI
   gw4PIsdYs00TwiB5eCzfyMomD/bh/F2+/SRcrnIkuLQu69e+KhWuEiIkiFa0HlvI7LiCu+x/NS8H
   I9BItrbTGTjINEGAM97PJpk7fEHupndZITQUKe/PL1rHT3tRB/qi0qPwY1ngLhaP6vVeyJpCLerg
   T3rRj2RgxHjFFn7DlnqxQk/F0W4xzC4mj8hJT+q0t1nN6NIrB5k4ntMu0vATtmDMi1aHv72UK6p+
   4obkKXqkJVz2iwvLbZR4LR+UVZ1vJkuNz7/7mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yKtwdSoG6Mn29Ao82UIQQSbJApfuOAQaxQ6HIaBcutA=;
 b=W7SEsNLBkk7LtJfG3oCsTh15ixScbz7M5vGnRivdNX55HagFYYVSGOuCkoRZQgRQZabSv8jsw+wP
   UJNqcVOpJJtoIXszLbW6gqV9I6VDptF2qTy5kWZtr3guBEyaEchfqlZvHq/SIJ9AklHRSf/3AN7Q
   /AjP4hmRzOvX0zhGlvfwdixLXn7wkt6z3ZbR7CU2cvL7F3Y83ctvespCsGJAP5TE/Sx+KRGhN7M2
   NaC05H818DF+Qf5SWTF4ER21CYWYsz1imUB4sS2AEHOFeKh5yL5VeqklvVdnWyyi+tA/hsDnHLlE
   KEWrWCKKLXNRp1RKJCUOl6N+MV21gXDrsx1yLg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAA004OE6GUUY70@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 13:50:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649838638;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ta6kF3L0w3X9dxZXi5dX0moODGNzVF58ft5uqaNKXhI=;
 b=NqNC5kyWWiv5+fVv2xiwrT0u+tJjQWgjMkH/ysEa1e18Yxi32badydXhZDMLrEdcQS2bgK
 2+vsicu86ElBPTFuvGPawNMsS9UFQ8Ozk84JUAsLh7oBBnhzKzNfb9eahtz2qpbeTrAXLF
 m/BnqbTclS7306OOs+PR6PoYqN4GuLg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKp73bppgeqVABsnfgu31sN27XVAIc/6oDrQAqEVfZHezwdorj1uXYSgYX1u6nkqG3+owQTMNnwRN4qga1i4Yx52PXZAzH2TY4/1lMjkNmSaKQXue40pdHtLX9SYEwhoZL/pbcVbM2MUnSgawKdnL08udiI2DCAt9phrJHqnDj3DiuDOJCxLYwSNkymXwnOeF9secsOI3WQi+SM1hm3Dca5M/pKzvZmrC04OWa4BNCK+8JLWH4h71uVkp2s9LNgeUUh8UDe0cnhPRiV2T7QQq/HFDjB40aElQauH9ht8RAFYyXgWZMfoUbKITI2u8k7dj5WGkh4eVxtLHDnoY0MPHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1DEE5+yVgyC0/njfhLkiM9eSCpHnirRql5N9hoyZVo=;
 b=f8MZg6xn8CgtahUaXj/lMEdIQ7rpd4kDZScUyyWnRq/u6kUNzWRqCf6J97vqsZsxXl2M67WoXi+E4SK8kZMtDAw13xiS7NTaj1rPS/52d+gnY/ZDoP9KJqkUj4hnNZKLLpvyEBboWVbyveaVcdooQrTZGjDNQQ4FXR8fuOp/3rnzL8Ri25rqtb6FVAvyQHfruEBeEcp/AFprb7tqDgmAQ9/bEwIBe61+f+ebuVA4i2xmSgWJIYNy10LoNzB7SW///dT/WqeE6x6H32WpCeGqvT2/p7FSO+weRZC3SA7tb8Gx93tTnQdj/7Vle3GEZineYSqRVQ/TqudTGFHtaqSmSg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Wed, 13 Apr 2022 16:29:55 +0800
Message-id: <20220413082957.28774-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220413082957.28774-1-heming.zhao@suse.com>
References: <20220413082957.28774-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(6486002)(38100700002)(8936002)(36756003)(508600001)(86362001)(2616005)(26005)(6512007)(1076003)(8676002)(66556008)(66476007)(4326008)(66946007)(83380400001)(107886003)(6666004)(2906002)(186003)(6506007)(5660300002)(44832011);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 08:30:36.5553 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 mlxscore=0 clxscore=176 mlxlogscore=999 priorityscore=178 malwarescore=0
 phishscore=0 adultscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130048
Subject: [Ocfs2-devel] [PATCH v2 3/5] ocfs2: ocfs2_initialize_super does
	cleanup job before return error
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
X-MC-Unique: k4mqwODJOkOj1EfHDHDa7g-1
X-ClientProxiedBy: TY2PR06CA0035.apcprd06.prod.outlook.com
 (2603:1096:404:2e::23) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84546787-7fd9-41ba-a860-08da1d27e230
X-MS-TrafficTypeDiagnostic: AM9PR04MB8100:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB8100C24379DD2D66DB8B240B97EC9@AM9PR04MB8100.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 Swc/RMCFkRu2WNN3B0TuEW/hZcDpKwN9LgP++V1A7CtuzrwjxHmMiuJcL2IVUUTjA85MgfwzUaas/QffgvjM6cwr2wyLO3+kZm/Ul0rIXuOdCWgAhgCtvA5EXWpJSEHANL5VAKRhrq70AMOOY7rK66hc12Slzk2i8ftRhRqka1/Pyp5YdSDpiKppON6IJzHKa6nGi4e9I1OTphzP0nhAVsT/eePdNHpnFL2gHG7a/ltL2VWGG+nWSNvF6h9trn5pOqL9PPnusMQ7NCB4o61akjcio7cTR1GyIX5QfU+rBdA74qtI5iPYOfSJatlB5ixVuvLQP5FvcEqy+5PLvB133DV2+3G5V3SXucasooK7FdscYRKBJiGEB4IwHWmQTAzDp4GnP9qgjjZKMvEAsg3/NAhbplm+hbtAAu/PH30TCDC8OBP/BT2ESJCKg2eHgRHLqKjfjY2R3ithDvg98Oyy7Wv5dvY25vdtlqh2Qbm/7aAAwTv9CZXCOarOVdogc08FbdDDpQaEmluW6jsmtmV8YS2kzqC9teXw+jUymTih7cGply9/yuvMZwYHHvwIC/Bb7DOxi1A2245srtAzGtZu6xM8mvqhoOwJWeQlMS3YhdQZ9hzMZUnO6eDDMAmkSD2zYkwJM9K+DbJyyFTNi6vvKg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?CR+NNei+dh+rshqXdRZoBjtL5b80yyu5kJ5W8VM4z97EZtJNaq6dQKZFR3W+?=
 =?us-ascii?Q?WkHTsLeHkmB7fd/X/4ehLQ0js4YiQx6w1ymJY1kAQhQZbzTZpbKpsKWkQM6z?=
 =?us-ascii?Q?FX7rr9PcMiyTWqzsGgeZb+wUoKr07frwWHLEqSff61+2BCVTgGxMIVUkoheJ?=
 =?us-ascii?Q?gy7tJZZQ/Rh6wAgBAQyn8k9S2uNJ4VlDjwhgL1IrR8/52WQMLnwnnAbH76vv?=
 =?us-ascii?Q?y+AoACgVDv0YYKv9MibRs8K+u6M/vPJQHsCkoUotqVm3fAGEB+WTbULwCntR?=
 =?us-ascii?Q?4+OvjAUE53UIbhgYeIP2BbEAqVwYOTewvS+WS2/KIGo3Nc/Sll2DfG5/vzE1?=
 =?us-ascii?Q?T/YaagYVtvRaHbRRvo9QFg/8KvjbvQ/YA4L7rganFVONCGTjleCZoxyFpket?=
 =?us-ascii?Q?ajqruVrcaNyWfun+sxTyXMdQp6bWHp0lWRzlVtEsO7mjh9/E1Ynd39X+X9J+?=
 =?us-ascii?Q?/rCyDTO6iurztVXKVVftUnKXNaqjlxu3nWHf22QTnXp3JmgT/B9cyXDbGV36?=
 =?us-ascii?Q?GJIBYt25B0jjRXxVff3OtIlSPt5jR9wF2yJSxKVFzo1Ocy5h5a22oHGrXrQ7?=
 =?us-ascii?Q?qo/wAVQ/Rnsf9+sKNPu3ZPOX5kr638d4IPyb1yyO+6O9EUkUM2W5zJp/+Wc7?=
 =?us-ascii?Q?qNvKNH4klotX77IQFL/0oveBqfvpRVpfhQHFQpA2vmBVnRhB3O4JZoxPxZHd?=
 =?us-ascii?Q?x4iz3vV9Vy2pztqwdM4t/jMa2CUNZ7W799uJ5nCTkD21q6d6ZefJpuJOrDZ+?=
 =?us-ascii?Q?d5zJ3mYtXCqRSm14CZ7VOFAp29aiQobOps5me6VBiL2NrbMBqUwg7PD7JklX?=
 =?us-ascii?Q?Rgp2K7uaPQiQ6uML7wPrH+/dwwAAQsS7sUbS3Ivv6aGhst4eUdDod40iABPa?=
 =?us-ascii?Q?YU9+KTAMqCBxgjXaP8uGyQOHDynJiYqWiLbBrTSQX4kfmoEyyUW5g99LYGCn?=
 =?us-ascii?Q?NfSXBDvMPOFNHFKDwIrfeyf6ebeW3t7ObYPnkviobx/70KxKiQRIYx1JEhGs?=
 =?us-ascii?Q?60Tk61TXgwT1uYXdUHGdOY0962g9jAU7qpGblpUe0PJyzlKAo8hmGKxTl9wb?=
 =?us-ascii?Q?NXt6a4jI/Hf4caBg1RT7kWvvcgkgxI+4kNQmZSpItA+g3lCdtpMpVAl3z7Ie?=
 =?us-ascii?Q?VWV3fiLODEXxe8iQD/7G8MkpkDIphk7cLjFyGKK8iwoBtnl60sX1Za07QmlN?=
 =?us-ascii?Q?u/H2KsXVgRikM5/MZ1Cv1xxssVH2ceqKgnxR38kVM3sPpDhbMyq8Vk5lrFdt?=
 =?us-ascii?Q?I+jYBlnRVlamV8dmXvJPnwJbFPNJA0JGsLHJxPJi0PbzRo5WxRU8GFSZWA8p?=
 =?us-ascii?Q?zHVwqPf6/0P93c9Cc1w3q39+DCHoJLrZeAE8IXYhFIZG9jMlMD1ee2L4eVH8?=
 =?us-ascii?Q?oobjYYHpfyEGcXSKFziEOLZIV1mH+dKQPSyYX0AU/gvszenTcprEGCPf3jzQ?=
 =?us-ascii?Q?auh62EVoxChCEJ6PNy5vSXgAzqVddPzPZX8SrY/bcomFYEUQefuba7nT5Ksb?=
 =?us-ascii?Q?F7H26mTB85zQeysuxD/mwqmk/Xk/kceBOzPWdl1B0NF1/TFZ/N+oPvPZq/kD?=
 =?us-ascii?Q?lxbN5Q0l8j7W27fr8eAnfNCwmkXY1qfom0eYrOyH3mAB6igCEPLzAHNkLYET?=
 =?us-ascii?Q?+YtkYzINX6kDvHEYMqm6cgWCvJUgQB2DQ9PgmT1LNAuYfvQ977bABU5CuXQ9?=
 =?us-ascii?Q?ekO+EFM6bGedGlcDwddQ6crmIWQj2XM4yVJKiAkKbmkcqO2xTYXsh8Gn9EhB?=
 =?us-ascii?Q?kZ4eAhD9JA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 84546787-7fd9-41ba-a860-08da1d27e230
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 jyHKtGbiYhC8ywNyRW1u9IoJMk3nb3vQb4dgSZvaI7IWQTodS9HYCjC5it/GBhSUFboczK0zyDE+m8pqo/bDlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8100
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: GyzsKVLYkVg7n7nk7h3FybbYcUqDk82T
X-Proofpoint-GUID: GyzsKVLYkVg7n7nk7h3FybbYcUqDk82T
Reporting-Meta:
 AAGnNbjM3X4BlyMGdKKHqt2dZiIQfnZtimhveY7oaF4ZnaHCRrDWUlALLkh7i1cF
 oY/Lkzp4gKFijjd2F0FTSU/KnZTBVq9X0z1BP7xdw33wk9A12iuHszTXIkWFmNit
 VKVAg0ulcPWsbS62xlyCoDCmJSOTNp7v+sKSZqZp9gg1n7MXIX6hqihn+aR+l3fS
 91XqhgmCTCXrGvGNM1Szznk1/KFB19M8j9qMoi9Ja7U8XmRsy50c2KINpyFmKw32
 8OQ23E9+jbKaRN88gc5SNoUNH7g70W5mKadG/oH3pkET0l9pG3w8wSP8Z5CRSUJ9
 4wbfLjWcbRVuvBlnZ3ycyJXtM8iK+1wzS8/YJbo6uIS5yF54D1Fc4ZIxQrUNLHy+
 /i8ijSm/h04zGYPXwSa+m8Twvd23V+x4ViPv65PX34x34I/qmz38mWc+W7SGZ/bj
 P1gBHagwavmg6aUxC4xKx0LlgZ6cllcJiD01Qle3OfZWPOC0p7u6rP7HLAfWCX6H
 A79fHrQMFGBmSzkOjrOflEzN3oLFBOVH8u+s3vmHl/n+

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_initialize_super.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 59 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7076125f5b46..4302c3e9598c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2023,7 +2023,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	sb->s_fs_info = osb;
@@ -2084,7 +2084,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
 		     osb->max_slots);
 		status = -EINVAL;
-		goto bail;
+		goto out;
 	}
 
 	ocfs2_orphan_scan_init(osb);
@@ -2093,7 +2093,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (status) {
 		mlog(ML_ERROR, "Unable to initialize recovery state\n");
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	init_waitqueue_head(&osb->checkpoint_event);
@@ -2117,7 +2117,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->vol_label) {
 		mlog(ML_ERROR, "unable to alloc vol label\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_recovery_map;
 	}
 
 	osb->slot_recovery_generations =
@@ -2126,7 +2126,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->slot_recovery_generations) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_vol_label;
 	}
 
 	init_waitqueue_head(&osb->osb_wipe_event);
@@ -2136,7 +2136,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->osb_orphan_wipes) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_slot_recovery_gen;
 	}
 
 	osb->osb_rf_lock_tree = RB_ROOT;
@@ -2152,13 +2152,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "couldn't mount because of unsupported "
 		     "optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto out_orphan_wipes;
 	}
 	if (!sb_rdonly(osb->sb) && (i = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, ~OCFS2_FEATURE_RO_COMPAT_SUPP))) {
 		mlog(ML_ERROR, "couldn't mount RDWR because of "
 		     "unsupported optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto out_orphan_wipes;
 	}
 
 	if (ocfs2_clusterinfo_valid(osb)) {
@@ -2179,7 +2179,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			     "cluster stack label (%s) \n",
 			     osb->osb_cluster_stack);
 			status = -EINVAL;
-			goto bail;
+			goto out_orphan_wipes;
 		}
 		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
@@ -2199,7 +2199,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	 */
 	status = ocfs2_journal_alloc(osb);
 	if (status)
-		goto bail;
+		goto out_orphan_wipes;
 
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
@@ -2214,7 +2214,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
 		     osb->s_clustersize);
 		status = -EINVAL;
-		goto bail;
+		goto out_journal;
 	}
 
 	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
@@ -2226,14 +2226,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog(ML_ERROR, "Volume too large "
 		     "to mount safely on this system");
 		status = -EFBIG;
-		goto bail;
+		goto out_journal;
 	}
 
 	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
 				 sizeof(di->id2.i_super.s_uuid))) {
 		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_journal;
 	}
 
 	strlcpy(osb->vol_label, di->id2.i_super.s_label,
@@ -2253,7 +2253,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!osb->osb_dlm_debug) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_uuid_str;
 	}
 
 	atomic_set(&osb->vol_state, VOLUME_INIT);
@@ -2262,7 +2262,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	status = ocfs2_init_global_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto out_dlm_out;
 	}
 
 	/*
@@ -2273,7 +2273,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (!inode) {
 		status = -EINVAL;
 		mlog_errno(status);
-		goto bail;
+		goto out_system_inodes;
 	}
 
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
@@ -2286,16 +2286,39 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto out_system_inodes;
 	}
 
 	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
 	if (!osb->ocfs2_wq) {
 		status = -ENOMEM;
 		mlog_errno(status);
+		goto out_slot_info;
 	}
 
-bail:
+	return status;
+
+out_slot_info:
+	ocfs2_free_slot_info(osb);
+out_system_inodes:
+	ocfs2_release_system_inodes(osb);
+out_dlm_out:
+	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
+out_uuid_str:
+	kfree(osb->uuid_str);
+out_journal:
+	kfree(osb->journal);
+out_orphan_wipes:
+	kfree(osb->osb_orphan_wipes);
+out_slot_recovery_gen:
+	kfree(osb->slot_recovery_generations);
+out_vol_label:
+	kfree(osb->vol_label);
+out_recovery_map:
+	kfree(osb->recovery_map);
+out:
+	kfree(osb);
+	sb->s_fs_info = NULL;
 	return status;
 }
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
