Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B603C77B7E
	for <ocfs2-devel@archiver.kernel.org>; Sun, 30 Apr 2023 03:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yDgLk91SVRobxhSvf4mGfqIEYTfPMgrEXTuMDoSBJV8=;
 b=T1gSX/MFwxG7JoPCTogGMjV0/3u39kLa0GKieKTPLc90n4ygF+FReQDyDWXJ3FhDEfiO56t0jonm
   I8eDHxOs3HVkVvdHaeCby/haExGWdc0G+Y+L7mBiSoyr2CmbgzWYxJGpbsfjH5yLC33A8+mcSpPO
   g0514MkZndrxT0Ztc19pIiBcOzf7LfCI72JpILkK2jqUCJb8aSNzI6fh2aHBqjFac7G7Vb5M+o0z
   O3QpEfM6mEIdNnU0y9CidUoR+zqZ1i33epnZJomB+N1KAuETVi1aWZLuIdrtDdZKkRa7Gx0KNfcW
   ZPD1EbTebddg/qCdadvRCgASIAB2YRAeBDlQUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yDgLk91SVRobxhSvf4mGfqIEYTfPMgrEXTuMDoSBJV8=;
 b=s5QlxE/unUn8mlk4g0ecJ8AeEubN1aV6pMarDZdCDygHYeEaeWlgdjMvRV2Bu+Oaio9ZwiLbBobV
   1E0fTSi2yXfoTBI9s8gbCylp+PLEV4XrAAo+RMY/u8lUYTMP++WXR5MIgkexqK7IGkplMGAbVPXe
   BySZN+Aw36EJ97Hfk6ljdIbuZXRapYGHjkivVoFG07IBccqUooKJ4srUbH05NofuT5uBkrnhB86w
   i+I7K0jir/91g6dHUMD0sPpFGi4SQPbrHIUZcmzxodax2fZT5x2XWIdMuBA8AoaMU+hMizq3lCnb
   xoazWPocxm7COZZlzmH6vNLPAx47O+0g/KFw+A==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTW0088VRMS9L30@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 30 Apr 2023 03:13:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRalJMltwzkh7ryjrjtGwEORHPdOyuqR9ZixBXXab0CxjTCYazRxi1DFK1RNhdX+7Tv1xyz8sTCB4rqZ2s8kgfLcg5T7+EmODMPtbSFAnVrN+m5FyAh72eXe1reMlwsUnfdMqu7oBjvG3KAAcwMEMXv/dO9n8rRLT0AApIy036y2g9kEYJc/guHO3T5saOCZl2Bp+8C2Olt2ByUiAVeiPOWbuXgJDwnRPd+nZdVaxjfrjHNaGF6OvwVlw/PWjHkv1nbamwdVbxC3sMUzFDvcP3a3eFZjZ30cwwmkFc5uSQCoFrvPbmy/7E426Nh7q4bBZyxzbHoJxawCxXcZPWOaHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qxrFdsldC2kljVwosYMfkBNQXaXQ6Nr/T+96ktg578=;
 b=GWYo5xbTO5j73zNG7Bey+P1q8tAgb7FRanJgRV+udveuvQZj/7pi+oE0aqvfYFJ9mPcT+seGhzLvbscivaF0kaQ6MIFCDsi6JMTPEB6CVKWsEi+7O+8rBMc9ymblQ6aVI5DGgJGJW4/XOujk2g8JSCIv7HOT74wauINOuX1RHeTRR/bhKUBZ07/18s2LI/kAClrobUCuzxiTz8/Upk2+zwak/hy1a4uGg9gThgrB911BVIJXUrXHhJFhYeN6tqZCk8c4AJfisWDSl6PXIrHeLmeNcSZrh0jqicQJhEzS83tXCzP+EeVCGgC9YNFspN0Xy3PPiGlFodv3XiQDo7KwwQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qxrFdsldC2kljVwosYMfkBNQXaXQ6Nr/T+96ktg578=;
 b=ZwJXpqGLtnhKfsPLs+ibD2Qn86bq7s1r82voVOQCLCxErvhKmBW9nPPS3zGeUQhxhO0ewwnet+C1W3HvQ9mc1qQzM+92r8H57UVM29wUDMNW0yG96GLJkkc4Jy0I5ie4DW9MBEhyqh94zx+NRsrZzVp9xPNTkX/5qcA1cXNQtM8u27wmuy8mXn4bYXx6pbuc7P6/6D4w11QTLtYpj1yTS+hRGNL1mFglO1jrvQ94wnwXaDcMayHr7Li/5z7qhtQ8xStVoFyoYScYdAe+Ugqs8JYAiiupuRUGxRpCLXQot2PAl1UJ96D54Ip+HBp9FVx878Krv3wuda3kyATPO6mhfw==
To: joseph.qi@linux.alibaba.com
Date: Sun, 30 Apr 2023 11:13:01 +0800
Message-id: <20230430031302.15597-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39850400004)(396003)(136003)(346002)(376002)(366004)(451199021)(316002)(6512007)(6506007)(1076003)(26005)(186003)(41300700001)(2616005)(83380400001)(66476007)(478600001)(66556008)(66946007)(4326008)(6486002)(6666004)(6916009)(38100700002)(2906002)(36756003)(86362001)(5660300002)(8676002)(8936002)(44832011); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2023 03:13:16.8782 (UTC)
X-Source-IP: 40.107.20.60
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10695
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 clxscore=190 impostorscore=0 bulkscore=0 priorityscore=120
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304300028 domainage_hfrom=9714
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix missing reset j_num_trans for	sync
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
X-ClientProxiedBy: TYCP286CA0025.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::16) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AS5PR04MB9755:EE_
X-MS-Office365-Filtering-Correlation-Id: b3849737-183a-448e-88ea-08db4928d796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 2ZNv6/uOc+ffWmTQ7FMxGYSeimKw03wtfifTlmRrwed0yjdT5M3dZHmpD2GnkvuaJrNR2U7sWKYRtPy2790BoQ5cYHUigDeNVUs/LKzsttg26GwMW5+YBdAxEtYTYlXOHEjOQpQLx9dPrnd74QQ2EuHg0y5uUGkUYx1tA1MWL95Nuqt6z6aizBACFYW/sOU+XQg8rXemcRjOyZ/MPmYfKdixz6XP4SBy3/vtBOT30xXEnDV/DCBLPtIZ/3GAliPMfM8szL9Z2SN58O/psl56jBGyi6SSr2L0xoB2f8IiDo+G59Yj4+Tb2RouPj8JJ/nFQpRLEJRnr1Xw+02/V/F6sedkd2OynKjguD0lUiE7ngUdTEEHG/+a2Qzs5+H3WAa4imyJbAmKTiqN8c1sP82VlZ99gO18kHwq4b5VbMyV8AYJgJDtJfP79e8a5bsQlSqfRGadtgi4cxbXtsn8HSRUKsQX36ggJv8xPzZRycxtabSHgJgObgJBdL/EjGc+29AiAuOIzLJ1abIyUNSe/JFPrhMKHvxQp5WUAewmpv54DS/0bVFcdTu4L7y/nwJqTnNn
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?+c5Eoz4IC/9GSo6Z+pGxzrEkpjAiBrUI27vo2vDPx3tmSMP+p4hQh2AGRmJM?=
 =?us-ascii?Q?RwOaVvVg3XBolME/fD4/nj0Z+li4chASYE3NqY5tbjzOOzhFA2l2mRwr2nPG?=
 =?us-ascii?Q?OAtU5dCyZrL3s76XSXcnCJSl3uefqDCbITzsiD5K3IgCCW3BRfEuFhsmD+Ia?=
 =?us-ascii?Q?5v8jKH6oNv/Y9b+xYS1mRCIyP83FFZBmxU4WSjNjJ8v8i8wzswp56YEBj18G?=
 =?us-ascii?Q?rTAADjwWZY84WLFfnSNvs/vLG+M6gq59veAhhzSMnmK6unti15mj4HZ8n3Ba?=
 =?us-ascii?Q?pZtUuGCDOIgGob210ck7ZSp7doo4XbvJ+/rXXl1uWezcW2umWU/uvS5iLCYT?=
 =?us-ascii?Q?toKQhML3SU8e0MTa8DQhQzQV45GIZsCS9rJ//3g3prRufX7zYbMtYcY5M07A?=
 =?us-ascii?Q?F4jDmeNnLQtrIjtTaCglYvsGZ99IHJ5hNGARDOJtwWelQLTtFhmkLX+4UH6R?=
 =?us-ascii?Q?F+AHY4k+O/8ZcKxNoId/MUA6jL1y1E0FqjGEImxd6bqAkpc3l8pS8SGx/5Ne?=
 =?us-ascii?Q?AtjMyLlZrLdNVHOxIQrxePIzq9DN4JRpmfd9q+CrU8lf+07rMl3ZLhuPcmrP?=
 =?us-ascii?Q?Pju3Hid4apG5Ru/Ft9OLuPcW0g2n+IMlntaIY+zkz5OvARwC6RGgwxaoJZc3?=
 =?us-ascii?Q?77Zzs/hdGE1vv700JGBmTZFNFmdqH+wZMKCClvZ1tcZCHQlcrJ0vgnUCadD1?=
 =?us-ascii?Q?JRHgs4yrNHH8Y3sTkCNby+FKmi8iKrjPFcENC3eLx5nYywrxLpoE6eUDR+6f?=
 =?us-ascii?Q?v/mQfxfEQDIDb9pWDjOMevDcAAgpjqiJJ9wQr11aheYxAxOU9LgNZdjOzN7o?=
 =?us-ascii?Q?GdiCEZH7Fz62wGLccbjbp1vavwIl7lFsQSa1H0LIJK6IpPza2IX/WIehqluf?=
 =?us-ascii?Q?sOMfqIdx9YS9xamFPd9RK8sFLF678T/XhsQQGvXqyh587sTWYnEmiYmoQ6cP?=
 =?us-ascii?Q?xBTGG+heNbcBwg6gDGw77rsFtEUxpWUnGBxa04i6No0e/SUfdzdDoInvc9jc?=
 =?us-ascii?Q?RG1YfAs/d70yDwDZtIOr6N3792l9llXIsmAZ5k1MRka5cejJUf1Q3l/7jFUd?=
 =?us-ascii?Q?n6N09MTvHeY8ZyuQZG5zUd1Hk1ASbZ8xgt8t8XyhPerYdxU7e620P926XBhr?=
 =?us-ascii?Q?07470+KJy0FYxWolMaF7xBkwSE2nE3uOEdxTNapp7oDdsF1ziIi3J1WF+dYZ?=
 =?us-ascii?Q?RMjLHRDpve1x/T5kFTwz2N9HKsTzSI2tJqhKeSJ/8bTw1DRdgCWuW0VvGe6T?=
 =?us-ascii?Q?TWPQZdkocnSqqhdNdSVQuXzM8Ee8X5/CtE5xU72mVe+Xhwt2Nf2S2JiWD2/X?=
 =?us-ascii?Q?09ldhJ2WFwUf7sRkwCuJ9ka1SZMvUSUuPNHMyGihHv2MhUFe27xY76S+oWp4?=
 =?us-ascii?Q?/tK4W1n0ryWuGn6kFlC5ttBXo0M57WbNcP4b5KchsKJ3AKtDhOZZU5FopY/i?=
 =?us-ascii?Q?pxSsD7tZNGejoRMWZhv1wLpKgZA+fH3xEbnVO2DmqXxwvSa6EX7eT0lIr9O2?=
 =?us-ascii?Q?78crIjSKf4CudzFzJfqzy0iXD+HFjlxoQG2AIWDXxcXL9o6vpaMDBSzVA0EM?=
 =?us-ascii?Q?CNgRiybpwBsGhffb7VJ4YVvRpiXxLin3nn/NMZrO?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 b3849737-183a-448e-88ea-08db4928d796
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 PSAF+QKd2CYbmaX9G45iaOjxq6xt8mVcDWL6GsyKg/dQ4CPZPb7EicxMZ2XX6kVG0JS+kB+F4nYQvETl45HW9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9755
X-ServerName: mail-db8eur05on2060.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: NA2wjvtADZtlf-0vXtB5OdyOJpkpPEpn
X-Proofpoint-ORIG-GUID: NA2wjvtADZtlf-0vXtB5OdyOJpkpPEpn
Reporting-Meta:
 AAG5OwTfWjAS3ypeLLQtw2pxVuY/m7KoBwWGQpk9S9rP8tiCqDiei8NLgaBO+RMl
 NxZR2CS93K0V/ikaYQol3JkgeRHPKeyHhZAdso2sL3kLrhYQlveRlXS2Bme3/H1U
 79WdugQBXOBPsV/FJ1q8LTF6GSOcz4+d28LibDyN1CBxsKrworkAGVV0H8zzZR9Q
 ste9dHtr6VIE2OlitVA9+M2FjUf2Sxp/MFVWnoHFQFSkgzc/CUkQAT1uCqVkDiHm
 r3NTz+1Bjx5WMde8LS2aqtaScd/Z+nq60+mpvDl5Go1yl9DMUI3h2k7zuAAqDNor
 2j1J7lKZIdpsknaegvr7/n6yfxhd3mFzUNMufdwksJ6rCSRM237CwBS1J9fQv11+
 eunQjKAaFrEFCgS3Du3anV/kFXvT5PQG0MzpD2DWca/S/ZZ33TXYSoeLxU7rHtbv
 mLVlD5/89sEV9pyG7vgqKdPkU/ia/KSP3xnUPGyzyqJnXw0UqcNexKxC68d2HvwG
 9Y01Ttv9Kibd+WdYuELhTwWnuM1CDdpZDvB5GMYfcowN

fstest generic cases 266 272 281 trigger hanging issue when umount.

I use 266 to describe the root cause.

```
 49 _dmerror_unmount
 50 _dmerror_mount
 51
 52 echo "Compare files"
 53 md5sum $testdir/file1 | _filter_scratch
 54 md5sum $testdir/file2 | _filter_scratch
 55
 56 echo "CoW and unmount"
 57 sync
 58 _dmerror_load_error_table
 59 urk=$($XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" \
 60     -c "fdatasync" $testdir/file2 2>&1)
 61 echo $urk >> $seqres.full
 62 echo "$urk" | grep -q "error" || _fail "pwrite did not fail"
 63
 64 echo "Clean up the mess"
 65 _dmerror_unmount
```

After line 49 50 umount & mount ocfs2 dev, this case run md5sum to
verify target file. Line 57 run 'sync' before line 58 changes the dm
target from dm-linear to dm-error. This case is hanging at line 65.

The md5sum calls jbd2 trans pair: ocfs2_[start|commit]_trans to
do journal job. But there is only ->j_num_trans+1 in ocfs2_start_trans,
the ocfs2_commit_trans doesn't do reduction operation, 'sync' neither.
finally no function reset ->j_num_trans until umount is triggered.

call flow:
```
[md5sum] //line 53 54
 vfs_read
  ocfs2_file_read_iter
   ocfs2_inode_lock_atime
    ocfs2_update_inode_atime
     + ocfs2_start_trans //atomic_inc j_num_trans
     + ...
     + ocfs2_commit_trans//no modify j_num_trans

sync //line 57. no modify j_num_trans

_dmerror_load_error_table //all write will return error after this line

_dmerror_unmount //found j_num_trans is not zero, run commit thread
               //but the underlying dev is dm-error, journaling IO
               //failed all the time and keep going to retry.
```

*** How to fix ***

kick commit thread in sync path, which can reset j_num_trans to 0.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0b0e6a132101..bb3fa21e9b47 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -412,6 +412,9 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
 			jbd2_log_wait_commit(osb->journal->j_journal,
 					     target);
 	}
+	/* kick commit thread to reset journal->j_num_trans */
+	if (atomic_read(&(osb->journal->j_num_trans)))
+		wake_up(&osb->checkpoint_event);
 	return 0;
 }
 
-- 
2.39.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
