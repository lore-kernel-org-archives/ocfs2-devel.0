Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCD3C05027
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 05:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lBqNPhovZiQFONwS+3OzE13CMISuUJcnD214oAzp+Bg=;
 b=a5uzq3fIJxhdrjgeriFL0mGVd/QSU0KhSFqjZRlpdsdvShE3AeGhjGA3rvQNz9+0nDs5hs3LArhP
   YbO1D4X72DLc2nQfUMgVJDX5Dh7lE8B2hbqMiyLUueajF7SdliSflvKK4XRnr08gAsl7DZaXT1w9
   IRaBkaXC0VtHll52p4ELxRgH/oe+rdO7GSszHKKEIZOCHNr7ngGKp62a3fSbTxKIxRBVUjQzZt3O
   D47qM2n785VjV6vBKjKRvpVGMjctXJYMROTD0JlZ+i0t1WCvq/Vts8+94qzht0+vRqoURc8gwdA+
   0zM1N9ZQs8X8eGAXQG9zs5KRVL2sXmWr376NIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lBqNPhovZiQFONwS+3OzE13CMISuUJcnD214oAzp+Bg=;
 b=uNr/nWF8EzsKmulJ4m3simEzUTczxXeXzYEZkp3+gD0jFC2X78At1EIXdHE2nZJLMNeAgakJkzho
   ByZUuQ8Gy1863v5eXgCYRIkm3JF5iFyIYBm8Kwg6QknA2mZOeIdBjvafDdU96B6HFrXMigdEuGAx
   8ApVMWgamGLp/Von8p8+y8ICJ9A/Vcqtlb8aUv9ZGFiAWJ6wrzhFabhoOOFmaCJ8MCnpzWGjuhLz
   TnCHRJ/v8cuMOazlqishCvZLYP30gc4QHSJBTz8TWvbdo+hCRe5rEoRN7+/SglncnguCezTeF7e9
   BOt1IB6n9Q561+H1Tumei0rikN1JTEer46/EQQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD008CW4TW1K80@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 05:05:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5SmV3g+Q5ML1VuF6lceXKIfbgo9opDukrY7JwPY7Jc+rlOku/ecZ9P5k8lu+q/Quv7vU4xvKRWmwftZjWF8mniaQuW5IIzoSoB1AU2wk4NaoBAJwrtyouNUwqnkZqEXkn4AV+N4DHIcSC3hMQ8tOUy7G9FAin3/wmPhmQ8GoOwBaZe83ANui98oLUC8spFw01pPSjW4b5uXybhzhsC4hejIJFfiIBoPXFzesdxmjVVH+EDvCIDUlbJXKPJFxum2et7xiiS1fd/eEMdCyHjR+xgc+IuEyBOz0/wDJeD0lI8U6/ZUCJ88uXN4bhLDM0D0hdUTQIXUjgn2J30AA2P/fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDlLnIFnV7Sk42o1xPCbeBCPbK9z/Amiy5IjkEqzq3A=;
 b=TwEEX6nT8mmvszqgc0mx9JXMNrwEwxJuQRYap2GePNYTUFn4VJwA+EXU3k8IviP2CNuVYyoZqciKQz3ZYKlD8kaxEQuzYPRr4K6SacsLkuIbaXzMopeskWxqQPyh5JFm92Tk0il8mNmfPFqi+cLjj2DLQjzPlc45fDNZNz+KcrDTVB1krjgNlCUumVVGkIElOYPbCT4JUFQ3MWPHTynA7KPOcsvalT6Z4XRMor2wBDo7KqrrAZUouWJT1zNr1fLNKFHWH4M0AxUI16I7HrJX8lKiktDpwn4SF/9FWIk6lYpFe8o/cxzj93cpzBarVXyND2Xh31Y19Mro6RJUFWHhrQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDlLnIFnV7Sk42o1xPCbeBCPbK9z/Amiy5IjkEqzq3A=;
 b=F96SdOsXUUX+dD5db/Go/15vtYb8cvOlXLuM2t5i0bfSnwzJ1jORrYG2rxoROShwedLCuGOj5j/QorMhS5Tj4QuHMns2PqF3ejlRlQEt6L9wFy4R4471Eg0RGAzmjfWH8sSJM7IBYcXmAGLcfzGWh7Xs+kSE/BJDiq3Tem/ThKGvQ3CohHF82xvqdDGQyl7dztjhPzZ6tXIerhZNFvFBla2ZyLkHF3JnYQHa96HY+Crczuhj1rulg9HeVt9sZw9JcMnou8ReQWVz73A3oyvOqbEg5v3FfOD1ZJ4axCIOn4hvH4aL2SNm4R/FPZKbqcQiLmaHxNVNFHi9bjNyU53zqQ==
To: joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com
Date: Mon, 20 Feb 2023 13:05:26 +0800
Message-id: <20230220050526.22020-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199018)(86362001)(36756003)(6486002)(2906002)(6512007)(186003)(26005)(107886003)(6666004)(1076003)(6506007)(66476007)(44832011)(8676002)(4326008)(66556008)(41300700001)(5660300002)(8936002)(478600001)(66946007)(316002)(38100700002)(2616005)(83380400001); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 05:05:39.0609 (UTC)
X-Source-IP: 40.107.249.68
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=184
 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=870 lowpriorityscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 priorityscore=111 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200046
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix non-auto defrag path not	working
 issue
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
X-ClientProxiedBy: TYCP286CA0077.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::9) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DB9PR04MB8314:EE_
X-MS-Office365-Filtering-Correlation-Id: f45db288-08c7-4242-ada2-08db13001b9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 QR6F0T31BSQW6+4QUhKpfR9CH1MUUrVVHcVBwQ3epxhoemLinlhVRKR1KGAqZ7WKSJQrVCjjOrqJ7UNO0Zs1sgGhLHyX0MkTqBeldH/elFhno6U0tKlnbhaK2u+19p3m9P+Oai+3+FUp3JoQWbEuUZp2VAwZfQRtZ9G+Fp842re4ftXWhqQLhRLOBd79tEAce4M8T3oKQN7uK+c/rkkLwVa8fdoriecr6MpEm4C2xZuC2Ns4YkvF6ucpaqDH27LYyYGK5Q8GM/az4Rfixylbmlqx37g5EY3t+d60xG7RGFXwqEjrKATcZHF3lNrnwBmwXXzamJui3A7N9N1WDiMPGp2sHnzI9Qo0Tti9H8EwyqggdDFCKmPWhd8IYLq7OtUoqNzr2w6+ty5cyzeRvbN8QzPvJKmgllS/GQFqGOQinKBV6sRK2S4o1rMGH5VVEuR/rE+3sA7+r/oHVLnn3AQpTEwMwYPY82qvJlgBqSmd8GIdHFAfTio7QdH5AawHLL90QfFRfBKU4c+z+SzwYoV/g6bxr/HxFzQGapYhksJ/289DxPpS39bU26dVgH/rwh9D1MIz1uBAVJkxZPFvHXyHF549TAN+qcOoAPKAKQVGMfG+po+AFZxtzpPxXokGbCyc/OWIRR0GgYiPvKN8oC7buA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?BqIFFaBeT1+kWSDOEWxm3seIvvm875uuPlo6zXkEM7uQ0kYHmDnPR8S8gm3f?=
 =?us-ascii?Q?FKKx5xiGtemy6mcLWkS7Iq4HFrCL2ZhDODUiJKMsFC6TCAYHt/pl+brmo6l1?=
 =?us-ascii?Q?XtCqi/0B7g39u6zNnrs8g9Hf297Ew4Sz2gWeoOoUXoPfgonHmwML+Nqd2elk?=
 =?us-ascii?Q?yPXDb5umPZou+DKcMUjJGN0SbR3XW0XOboRDufw/dDr0Vur0wHwmDTNH4Es7?=
 =?us-ascii?Q?MY0+zvnf+4Wuz4CmNsxHjaD7Iu1BDgPq4NZwJ18cks8wxAnQxUULFhJNMBbT?=
 =?us-ascii?Q?S4ZnzCT04bfK1Fm/Lbx1xRCCqqqI618yPQJRuHwjKmzD/g6GN/bQCRMr2sKJ?=
 =?us-ascii?Q?fJw0lzWhrAXxm3kEH8wcZ6Qi3fIzG7on1Wxg5JDSX5SpBfHgktr8gaDpxV7r?=
 =?us-ascii?Q?OHNJoAc9ITzSGVlmPUHwJfmi4ZEH8pBtz1A33+yLM/KTLVKw0oO2iFnKDrdd?=
 =?us-ascii?Q?N/PWAsq/vHtg81whQ7r7dZw/YfERh47VQlWb2pIFPxDrl1DfR4DdKqDNjMDx?=
 =?us-ascii?Q?YbfdSNFVYgz583IvjGGj0Au+QekK38M29DY/UTXQnnaxMusu8J/gcjfu8Nko?=
 =?us-ascii?Q?lSKPK3lJb+yYlgVsIzYymBZEbp0+ydlLU3T41LrN6pt9f+NKhR7HqyAa3eo2?=
 =?us-ascii?Q?1WlYfCiG297c0TRRgB07vMo2jSQxPMhzTLopuivvEkfeyh6usnAtuEQcht7Y?=
 =?us-ascii?Q?HGvIb8vZOTDY3xPRU5l/BE+YNgkArgiNt9KmsqzL3GHy96qwKWAbywieYKnM?=
 =?us-ascii?Q?BFmfI2Yp7xp3kkEuicrVPj/V954XiLM4F0fKk2uxhdKkSsC5qtclZDlk7cE+?=
 =?us-ascii?Q?KG8R65tJyMvZSxj8ND+pVJ5pfNpwVc/k6GP0dSeVKPgLFQ7KoUyJe/P/ze12?=
 =?us-ascii?Q?7DhECZFDlF9GdOlFy1IPe9Vd2c+CR7hlh/EpmWFipcY9bvmRPt9h0nXNbE8g?=
 =?us-ascii?Q?m2ztJ4G4sjKL4tBEb/nzt4ssP3sElJxLkXcj5LufLQNML6EhxXeOGmegNRGi?=
 =?us-ascii?Q?f+SZA9n4ioTHC7bQdTQD6K4IXkGJTAc3FxSVH9bzdrdq8NT0gdx+tKUeBQ/9?=
 =?us-ascii?Q?0LY00FT+MI+K9YMBfXDcGUATfHpMDAk9mUKzZh2MiNW/s73BtLy9eEIeGn+Q?=
 =?us-ascii?Q?wXBmldNW8g9KzHPEwx8cclXycwH3NQw1p1KmCKGsA8/yG3P9maOj+eWBBZYF?=
 =?us-ascii?Q?mp9hQ04dSwl1BQ/a6LKpOYiG5qlxdMtHPxZPPYorVCSOBfvK9asMmkn8oW4Y?=
 =?us-ascii?Q?OtR2cpPbG+Fb8k1biAYgjeuQkDprC5Dw3zhicHbUZ2KOfRrI+Ur5GUEzV58L?=
 =?us-ascii?Q?K6pk6a270kMD9h1YeH2g92CR644g3XEuxp3dPMBHpjE7TGz/ygO1i3v2pcM3?=
 =?us-ascii?Q?4FNB35eABcVbNcuDaMVRe+Ik/vghMd8mnUriypqiqQKFgXLNj/CiZpV3pHgl?=
 =?us-ascii?Q?zysQ6hs7AvRJBnRfZajyn4a8v7QU/ai9UtW20Z4Weq95EAln7M/7JL+4xlFV?=
 =?us-ascii?Q?ltKu25xXf//RJ2zQSpvcdz8ODNc3cosj6tuy3VVju690RwmpeXadM+qB3JCN?=
 =?us-ascii?Q?Sg+BJ44o0CkR0VA/2qX4aqwfJQL/BMIAhkMQYSPPe0DnHB9glkVIFuk6wfPl?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f45db288-08c7-4242-ada2-08db13001b9b
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 aPTnm/oZy897n3qp0lqcLAHqO2+9TJEp5sQDU5lpksKes1o0nmaTsYfA/cLwnQT0eu2TPWT/Ad3FJFr6bCoUqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8314
X-ServerName: mail-db5eur02on2068.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: l0IpDfV3LHl-cFFLWcnT2a9TGNzB3IM0
X-Proofpoint-GUID: l0IpDfV3LHl-cFFLWcnT2a9TGNzB3IM0
Reporting-Meta:
 AAGQazZFduZWp62S25Iv/pLqRTMzLNyjmj/HfJqIvw+hUjA8/oDmN9doRO5UbV/H
 B7Hf1sY2IRpruAMepNclQ1XuI+ODI4qXwqQ1xQIFibKc3TUUw/HZ96DiT6dpMzDJ
 MjBwDAK6F6XAfp4vOOxqCOTQJMil1KQAA2Y8T/bMy6n9zp5AiOlYFelncZSQcBjP
 Tga5IcEbHmRew6xURkCB/4Endw2MjFHdhc7EmCRrY9m3EihpqgcYoaTfCjNF03Hz
 EYawCaFNnEnCMy5KI4uhSRVeK9yt4thjApx1i1hPEDGvuqkUwgSl14fCwpS9BTyV
 BrUjS047ztOobHMeoCsW6XkATwkqXJbObgFVknTr4AI3bivm5NMT+Fj2VAAvyKK7
 Lj8Tmwsws0yzhmDxLoKvQC4oJ20kfe3YOzk2mFfesdQay4Kri4xXdXqqY3ouKxol
 EKqD/JckYNHL0ExzsJ3nP3ip86sbDkp4XFg6/m52zvNT78qcr/sRwKFL1QMzbR+v
 MhAE/0F/1shZgSt0PWvBB9+mkaBHnqc2A1XMLa9DSg9W

This fixes three issues on move extents ioctl without auto defrag:

a) In ocfs2_find_victim_alloc_group(), we have to convert bits to block
first in case of global bitmap.
b) In ocfs2_probe_alloc_group(), when finding enough bits in block group
bitmap, we have to back off move_len to start pos as well, otherwise it
may corrupt filesystem.
c) In ocfs2_ioctl_move_extents(), set me_threshold both for non-auto and
auto defrag paths. Otherwise it will set move_max_hop to 0 and finally
cause unexpectedly ENOSPC error.

Currently there is no tools triggering the above issues since
defragfs.ocfs2 enables auto defrag by default. Test with manually
changing defragfs.ocfs2 to run non auto defrag path.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v2: revise commit log under review comment

---
 fs/ocfs2/move_extents.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 6251748c695b..b1e32ec4a9d4 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -434,7 +434,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
 
 				*ret_bh = gd_bh;
 				*vict_bit = (vict_blkno - blkno) >>
@@ -549,6 +549,7 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
+			i -= move_len;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
@@ -1020,18 +1021,19 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
 	context->range = &range;
 
+	/*
+	 * ok, the default theshold for the defragmentation
+	 * is 1M, since our maximum clustersize was 1M also.
+	 * any thought?
+	 */
+	if (!range.me_threshold)
+		range.me_threshold = 1024 * 1024;
+
+	if (range.me_threshold > i_size_read(inode))
+		range.me_threshold = i_size_read(inode);
+
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag = 1;
-		/*
-		 * ok, the default theshold for the defragmentation
-		 * is 1M, since our maximum clustersize was 1M also.
-		 * any thought?
-		 */
-		if (!range.me_threshold)
-			range.me_threshold = 1024 * 1024;
-
-		if (range.me_threshold > i_size_read(inode))
-			range.me_threshold = i_size_read(inode);
 
 		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
 			context->partial = 1;
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
