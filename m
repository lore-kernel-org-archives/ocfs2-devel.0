Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F744C76196
	for <ocfs2-devel@archiver.kernel.org>; Thu,  6 Apr 2023 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mDJlrSY+2S059B3z1X+5xJAYO6tnYccJjdV/+hqDAKs=;
 b=HeSKzjQVZCW4nJ7xJ8fNMb0DOvUkXmGCdt17I3eGBuzoOvW1tZ1Yk+0Ckf/aDE4MT7BPu2bxUDb5
   9pM9pfrizK2dRsVxI+JkhP1+ISCUin5QBbI67PbxSx/abZKg/x/Qy5RBju4eRpMWVQNQvubhN5YL
   ZCPA+pC8AlZ60NtCGMqCrKH/kq8d22sELW4vGfAqX6zjceJw8lo/8AkHIV53EvU/vwPgwQBKmEAH
   8dcT9T38IHCQmbMLSi7rJGfBO+v45ywT40tN9X9JzHZ4D6OgPrSZxYeNvfaRLpdWuqijhbEr2Vtk
   4V4YLVIzbvNm8nAAXHyLZb0HlmOkTIgFNo+Ywg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mDJlrSY+2S059B3z1X+5xJAYO6tnYccJjdV/+hqDAKs=;
 b=Y/sURdN0N6o2pVTBcynDVFJeom+H3hqiwqeL34VVq1k+SheHVPxUW9sitm+t0xZXP11EJNyhObfA
   bQ9000KDLuDgMlRxKohTHCTQDJ6CDZzJt2mKW2O5iXvNxgRqkcoA2vgQzwDLRTO04kAV56qW7KSe
   bwGl/4lyib406YXXFlrS5fN97cWHQTX51Nw3NPFeqZwQKmV2qW5QT6MU1MJEyrO9m+izRS3GwjRo
   a11QlsX0oA0hX9HDSYJnBKVcKO+DyUAk9pRVQMa0+9hokC4jm3pDk9SBzZVz3gRGsJ6SlO3ulAvX
   Josbm+BXPcMOK3szAuPMEzUIYXhULLtH/BZxAw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSP00KP6A902740@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 06 Apr 2023 15:41:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FChDPBYp0dfDPL27exvljJKt9LjVrcK9k6HPd/mRIYk5wy2WlGMyVmkRXBK5pWUPmJqXvB5OcvVCHAKVqmREV0TOTjzQxCbGS2dUvo0YzNimkbAMlfeObSMtYr4Ye3AzOxm5yExCAfvc3SIyTyK/U4GkfMFt0WGod22XjV/nP8LzDVzN2dttmk+mKg1F+SVAtDRfWY0Q/Vpdccqew8YB63/zcKRpzPPEvzAupO6/d/IrTU/DwM0wagKKDp1+m6NkrJ+gsOaLFbxUrUcwjmiTwErbr15B/OjTFg1Yg+Wm7p2yOfzTbBs4IW7vhHPRh87W3rbvUkPuejxk8sDfj1mi2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hNt5qyhyYbNjSTwNDrR0WLUrrx0A724l9Qkk7Mr5dQ=;
 b=RudG5bscePHf16DPI4bV1gkp4py75wrXu7zH3KpjG5XjBeuoWES/dEEd6H6V9XuyNFzgw613BezfAyyoUdU9PreNUcx1/4T532euiplFQtbVkEDTwy3uo3x/LAFUW3Say+lGzGgPAT/V1/x6Dad/M5yYfZuQnRdDH6wNh8GS10g8CMcR9cEDcs7jemLg1fjdsWK2g6pynKTdc0YMMy94Aidpf78bjCo8+hM1pRu3Iwcaj11mU0tHqY2zNtuWfMqvawhIVLg0nJ4op8fmpX4kSkxuHcXrMpwo7FBzy8mNzfqkjuXHNKV88vQnzkbxZPnrgJ4ewkpOQdw31GWBAnFOgw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hNt5qyhyYbNjSTwNDrR0WLUrrx0A724l9Qkk7Mr5dQ=;
 b=wwH1/OEKJSd6zr76PXqJwyOi/CmBAXlqkLZukQUZr8h2+Y+jSMS7RFCxTKzYnWEM+8sHXhwD05SrYBdzW2oL8uHwi+T3okGWk3hk3h+9iEWb1jxDcx1RmSEn/FkxfqGKESm7mtvgETr7euLlV0QWZAvXERHJRBppJ+8RygnzHFLfs28zRFiZbDZm4w8helbMCkAXHFhtIB1e63m5v4HDl5wIORauTjuKcNQVTjfIgUyivvCfuPWn09pfIF+PTdhdN2ORMWIwj13CCSoilotdyok1W+RJOAiMAolbDDkQUegYkKoNL6pLj+u6ds8tB+ccAvuAfdBsziJQTtXxXxmGpQ==
To: joseph.qi@linux.alibaba.com
Date: Thu,  6 Apr 2023 23:40:52 +0800
Message-id: <20230406154052.9863-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199021)(66946007)(66476007)(66556008)(8676002)(5660300002)(83380400001)(86362001)(2616005)(2906002)(6916009)(4326008)(186003)(44832011)(6506007)(1076003)(6512007)(26005)(6666004)(36756003)(38100700002)(6486002)(316002)(966005)(8936002)(41300700001)(478600001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 15:41:04.8692 (UTC)
X-Source-IP: 40.107.22.50
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10672
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=188 spamscore=0 priorityscore=188 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304060140 domainage_hfrom=9690
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix wrong search logic in
	__ocfs2_resv_find_window
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
X-ClientProxiedBy: TYCPR01CA0110.jpnprd01.prod.outlook.com
 (2603:1096:405:4::26) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM8PR04MB7954:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e8eecfc-99b6-405b-6ed7-08db36b55500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 IQlLZh0inQgmSR/IF3jq7otRMOiyivcXNPTsJ8G8kgybmEU6WUUD1afOJdYSiFycqV06787AWWgQOjPKqe1iAWvJVKqolDQawypgQGQj116EvatoQjZ8EVjQos9xuiDgHvjhFRrvdkh4HIC6nnY8lbv6V0xl9jPpV3gcpSWadmfUKUmwcrkIj3snIu4gGleLnaYHTPH75LnsXeBw5h0NMPxXcMNeLsnQAzJwnElz1LPyercsu5Kf2hl/zu00jyv7qCdn0IcoY7KYxdb/QOIT4j2OzVCKeieTSVjZtMju9y1zUXS8rOgGItgRq5MdwSp5MPx3yibb0m4BNmeFwmviYHU0PEeY6WXXiOIE1DtyBnZZMGS6/mTElXuyfpvg1HJhEm2S1JMOeLgvVhN/kXvblbybEDwIdKcLjbGJU//kULUuyFXcVaXkem4WQRvr5NFtuCr75e61c/QtBnnjsl7Yox/HHqVjM8eTA7msEyCGqpb2pU2nF4wTU7a24qzjL4HK9dpXDRvSxL1Xfp+CB5xhkazYY4UapFZdegVnHLQeJAk=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?amLvPWw7Ftw31sei7r5Q/emBMe5y2mVUnqSmX58YUwfAu3al5OdbtS3JYyqn?=
 =?us-ascii?Q?g2/bn6OUwpCu7as0uw40+L/CIMuPkfFVDlKPQTHRQIszKWhfYfDjGeaspsYB?=
 =?us-ascii?Q?AE2m61th0jRYlFN2np5SN+ulyoVuA35ApfeSqWdJTS1oHg4MsLo6/Z2Qw9P9?=
 =?us-ascii?Q?x5c7WAK1LzwoOBFCUJds6G9I+SXxpZ2dc9ZgKWugCI7lv/Fw61VgFbeC3FUF?=
 =?us-ascii?Q?AY10y86uPKuBs33v3LEjR0fxzvLRqvsU0+f58e595cpIxXxlTNrLZdn4clGp?=
 =?us-ascii?Q?EeFbTWopRKvA4GaXhIy7fkUwxLfBX/EtewcJqla3miP7PoOjK3vOZtnzQZNf?=
 =?us-ascii?Q?cdQdA6kPmmpW2hvOjnbKsKB25tEfXB3l7Sm9rSgn08fcbmHuTOnhIQxXCr55?=
 =?us-ascii?Q?ZLobmCTVii6gdlNqoN0D1U4u7moKTAijXyJoZR4SiC6TLOptNk6DY1WVLgVn?=
 =?us-ascii?Q?ao5TkbIcOrlNzJ9I74UQkTJnfjY8FpHnI3wcBIpuM7ooVVDl0rGQg12vdJdn?=
 =?us-ascii?Q?oPfxwM+xVBeWnaPeY6kH4bME1tGnaD6IhV0SLMx42LG6fE/X4jkNYGo4mRG0?=
 =?us-ascii?Q?PLE3FGCGr283TBwh+bUVMrp8Xp86YJaVauzgDj4avMUHPsTz2OteFbf5T6OM?=
 =?us-ascii?Q?V/7PfqRZOI1S1kdRVbrlhqc5Aesky+mD0kBHvWLyvXV/iqr6zuwffZ4xvwy7?=
 =?us-ascii?Q?tJ366JUlI4TG7ga9blpMdrqPKb3x3yDUwRKn/3yYG+PmCXz/RYjJTkz/8g+A?=
 =?us-ascii?Q?HTqsrTfA8ROPoD5b9umgmnYeqanI0X7vIC2auisIZUd98phlS9r71kYM/QJY?=
 =?us-ascii?Q?Oaow/Xc2I3aV205MZ6YxfXKZkNvVJSKyqkXU+/be3jjXeGkmv3btuNcBTKFX?=
 =?us-ascii?Q?wPh3MQX51Mbp5lrL/mAyBmJGqgwNXfRMEQirEDaeHNQPsPnk1okm3NSJBhsr?=
 =?us-ascii?Q?bcWbAUp8yh6e5VQCA9cdaYgY6i6NGGoWsaUyeQnDt51sAcO4o5Kr6vmKdqoq?=
 =?us-ascii?Q?/s93j1Y3WPNt9Jbupf77rn7NxFrv/t06hlyMaC8R8mVbJh+QSZ35zG4aTxzl?=
 =?us-ascii?Q?i4cSabYZA89cWx/2Oc9WjFeIeYQHMlwUXSP4IyryB5/dE16eTVv7ojedIK9C?=
 =?us-ascii?Q?dYNuCpWBXul3lDdh5OvnqWU9uzTxNnpJKnDOCzt7K+ybMXdkgFp4IVuGbgJ/?=
 =?us-ascii?Q?UGCqus3kGq6yz8T/xpsceuBSqwpeKFB7r7TNbYIz9hpgTdwhArLE5YE6+cx0?=
 =?us-ascii?Q?xyBs1ydK37QM9Pd9EEPub1RJHCCiggs6Xr/0KqeFwKLpfoLKYOClyjYHL+NJ?=
 =?us-ascii?Q?Rol/8F/X4Jl2Jd1n2sTyY8U6br8W+ctZAFKR/fbMr6xqWnxJAle7TQna127W?=
 =?us-ascii?Q?58NRgiH6K6hvvYInZpBRAhctsU6gwfvGH7zikSVd/uHbSwPh/lQ2ToagyjLv?=
 =?us-ascii?Q?5OgXuhb7gfy3n4x+WZDoDtWKbCsWCJ26s15loK1LpUGLoh7tx/to7dmmic79?=
 =?us-ascii?Q?Nh06IVv4abgRV8i6bq/t/O0l8PoE0sbKL1CT97vUkAh1PKt2Y8mU15S8tayP?=
 =?us-ascii?Q?HBsmSoCn69+DMOhYuKVp4BTkFZingkPTU3IlOaK7?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 2e8eecfc-99b6-405b-6ed7-08db36b55500
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 6GaMGawt/X1/MaWAf5CFWn4+zAeAYoVVho1ECBKf1JCergYZDsN+354PBG1KByUDQyDN2WbY6Co4QwZSKBRcaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7954
X-ServerName: mail-am6eur05on2050.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: qxxQ2pUJinW-ActrUf0jZ32B5K8ipu4R
X-Proofpoint-GUID: qxxQ2pUJinW-ActrUf0jZ32B5K8ipu4R
Reporting-Meta:
 AAFyqGDyYG+Q5kvQa6o39Em3sY3B7K9i150/n8N4L30smPiuuYE5/9HnzQZlLTKp
 IRa/pLTI1q5HIzd0BCK9KUMjppu1gCM2LfdvI+9n2ENtS25MxhaDWq+IjhOmV/Nm
 WJLCw/8CuELCfVS6YyxsywmITqkkNe8IZQvNV1XQ9uVhzF3pGsb2uTNCvirx2YHl
 eX0qHG7GvbpoUtObASB0TEDro/gaXkgwJMyf+6hrukECzA07X2c2HjwMWAkaIdK7
 9GWOdYbt11E3EbBn5BGjUV4YK82ekrd6l2cmxBBSZDt6n0wB1YNGvUAKyFNIfYzf
 ew/PA6x7bL5gXeUzSmoF34hXgTNQuk0c4GKK8QAzeG/DbFPeY+J5IQLhFxB9G2gM
 3kuCOxOCzoXafXPH495v+EPUeU0bboprGE04GV8neJmxg4hhv3jJRHgCkq60BJJe
 j20mfu5dZWdVL0ZdvK5ly4i7UqGZFY+vVx49GEry/IYbITgseJbdVVnW9vy/oJ4W
 +wTB9CCatxeb1QrVcVRLLyT9GR9uOYLLgTe8UlGmSfTF

** problem **

Current code triggers a defragfs bug [1]:

```
tw-tst:~ # defragfs.ocfs2 /mnt/test_from_dd1
defragfs.ocfs2 1.8.7
[ERROR]Move extent failed:"/mnt/test_from_dd1" - No space left on device
[ERROR]"/mnt/test_from_dd1":No space left on device
```

I added some debug messages in relevant functions. When above error
messages appeared, the la-window still had enough continuous bitmap
to use, the -ENOSPC is wrong.

** analysis **

__ocfs2_resv_find_window should use resv node from rb-tree to do linear
search. But current code logic uses un-managered area between two resvs.
The searching logic deviates from this func job, which should only focus
on reservation areas (when rb_root is non NULL). Another issue of
__ocfs2_resv_find_window is more inclined to generate inner fragment.
It doesn't search & consume existing reservations but be apt to create
new reservation item.

This patch pulls this func (__ocfs2_resv_find_window) to do what it
should do: search & consume resev. if this func fails to get suitable
bitmap area, caller ocfs2_resv_find_window fallbacks to use oldest
resv from LRU to do the final search.

[1]: https://bugzilla.suse.com/show_bug.cgi?id=1131931

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/reservations.c | 48 +++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index a9d1296d736d..eda672622d1d 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -458,10 +458,11 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 {
 	struct rb_root *root = &resmap->m_reservations;
 	unsigned int gap_start, gap_end, gap_len;
-	struct ocfs2_alloc_reservation *prev_resv, *next_resv;
+	struct ocfs2_alloc_reservation *prev_resv, *next_resv, *best_resv;
 	struct rb_node *prev, *next;
 	unsigned int cstart, clen;
 	unsigned int best_start = 0, best_len = 0;
+	int create_new = 0;
 
 	/*
 	 * Nasty cases to consider:
@@ -540,8 +541,9 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 		if (clen) {
 			best_len = clen;
 			best_start = cstart;
+			create_new = 1;
 			if (best_len == wanted)
-				goto out_insert;
+				goto out_create;
 		}
 
 		prev_resv = next_resv;
@@ -557,13 +559,9 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 	while (1) {
 		next = rb_next(prev);
 		if (next) {
-			next_resv = rb_entry(next,
-					     struct ocfs2_alloc_reservation,
-					     r_node);
-
-			gap_start = ocfs2_resv_end(prev_resv) + 1;
-			gap_end = next_resv->r_start - 1;
-			gap_len = gap_end - gap_start + 1;
+			gap_start = prev_resv->r_start;
+			gap_end = prev_resv->r_start + prev_resv->r_len - 1;
+			gap_len = prev_resv->r_len;
 		} else {
 			/*
 			 * We're at the rightmost edge of the
@@ -575,8 +573,8 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 			gap_end = resmap->m_bitmap_len - 1;
 		}
 
-		trace_ocfs2_resv_find_window_next(next ? next_resv->r_start: -1,
-					next ? ocfs2_resv_end(next_resv) : -1);
+		trace_ocfs2_resv_find_window_next(next ? prev_resv->r_start : -1,
+					next ? ocfs2_resv_end(prev_resv) : -1);
 		/*
 		 * No need to check this gap if we have already found
 		 * a larger region of free bits.
@@ -589,10 +587,16 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 		if (clen == wanted) {
 			best_len = clen;
 			best_start = cstart;
-			goto out_insert;
+			best_resv = prev_resv;
+			if (!next)
+				goto out_create;
+			else
+				goto out_insert;
 		} else if (clen > best_len) {
 			best_len = clen;
 			best_start = cstart;
+			best_resv = prev_resv;
+			create_new = 0;
 		}
 
 next_resv:
@@ -604,12 +608,28 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 				     r_node);
 	}
 
-out_insert:
-	if (best_len) {
+	if (!best_len)
+		return;
+
+	if (create_new) {
+out_create:
 		resv->r_start = best_start;
 		resv->r_len = best_len;
 		ocfs2_resv_insert(resmap, resv);
+		return;
 	}
+
+out_insert:
+	if (best_resv->r_len <= wanted) {
+		resv->r_start = best_start;
+		resv->r_len = best_len;
+		__ocfs2_resv_discard(resmap, best_resv);
+	} else {
+		best_resv->r_len -= best_len;
+		resv->r_start = ocfs2_resv_end(best_resv) + 1;
+		resv->r_len = best_len;
+	}
+	ocfs2_resv_insert(resmap, resv);
 }
 
 static void ocfs2_cannibalize_resv(struct ocfs2_reservation_map *resmap,
-- 
2.26.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
