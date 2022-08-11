Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45212C19F2A
	for <ocfs2-devel@archiver.kernel.org>; Thu, 11 Aug 2022 09:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OBvEsj47/Q2+xLgIUXs8xic4h0TVJxs0wcKPB/KNwBk=;
 b=LWyndqOcSMJTvBcBlubOH567AQvGKSo79h2Mmfk59oVy5QFclhJQzwNzkVNuARjaDgULr7zq+1rb
   RYY3am7ufGB4ylXynqpAsatwG8jfEvHsmetSedJPgx7Ihd7dxOwBjbQi8F0o5Jgw/uU2aaExOdsH
   5OudNWlVXxCZwAliRzegTUUQVirWcJFK+2x5Q2xPLRJ3gTJwb62iHQzcPvNZS4LMyk+5jS/YspOb
   q6UCChmvPU0+XO21HdTJQbf+L4o541xPxSaNA2ihcdZ1bZ+FIn/OHXmF0bMAx1RL73K8LYGQjNgW
   jc+bmtLsV+N12AyEGsegJfNnwVGKscNXHBfumA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OBvEsj47/Q2+xLgIUXs8xic4h0TVJxs0wcKPB/KNwBk=;
 b=hQ71hbckK5aydxFcjGZ98oXBewooC4Zv5lWoDLtKiZc+4weAe535LHsvTEn09eJXG1zLSImfVm1x
   SaRB9pQXRgJzmMiGu4N2+saAaSUqz+d7jvuvYM9aFio/dzVMDfKo3k0UGgj5TYu/6bgXkv8J08KU
   aC4OXXwLYVeIz6EAPzWKZLTVOjqYNzyBOwlatQ/9T7HO4BooHIkHLopW02CL2sIN8AeuurEiTBhk
   NmUWAjrulkaJQfHLVgqp0wf9dXVdoWFlh0C1AnxPNJXT7937Q3+d/6M/xU2NFplUOncy+m7U2p1i
   eRdpNY1EfDE0Q9p98sPoOz8Mr8pzzw1/Mzf1TQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGG007GM35UP7A0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 11 Aug 2022 09:46:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYPIF1QH/8xscjnpUaT9Ql9HPVwvXkFc67LawgQxE4AKX24nDR1j1+6gwm4cQyPK8s+F87/ZyHZSAqvAh13X+VCtt+y7nPIP/cn4uzNHZvF9rKtrK8h4yCjMKhJow+bM9B/rb+qLPbIrje1sC1uRjXuDjN3Hk46wcfYIhlmEE4EBYrAYLw4GSUkLXvLLb9Q6WzdnkC7eYWXYiVbSTufDrAy1D1ZxS8IvU8EzC0FF0xqYnlqNhli/z++3GIiXyUKOsSZVA4ZZCV4zympTpz6IQeG/ynUxyiW6Wah/SwQtSHy4DtYtEhsXlH4UgLZmHHJ6WmwXXOAvWmAJaNFpD2Hcdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5A0G4YSLnFpxzs0u5ANet0Lbd0ufPHVoICZNCPcKOyM=;
 b=UahtNCZy6hqUAmJhDkmEGOBob7WSdWzVAkgD5OkB66/9hPOWB7eBWr/vEQysGWIMSNGHn7ypYj72heFT+yOoZ/vcbEhVuug8KrORvR6kDxJxcv02NHs8lhAcmMd7pm+xV9vrc3/Ej0dMI/OBaC8HHEGLBI6oMsHV7hARRegCN6zmx9DcF4QTZ9mC3I61H1xhfi6trbhh2d+1evt4LVDUiiQrRHYapYO1hq2hwlhIJiixsm9MFXDQUxmPQSHgUV3wLohUJlR5yRtOoM3HiJFfCPa03WFnGxgb7xxZEdurI2QYcm3R1l0qK6cVKcbjyeTlon6dKRt7BSIO8M7ENW+QuA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5A0G4YSLnFpxzs0u5ANet0Lbd0ufPHVoICZNCPcKOyM=;
 b=QFOo6AklShdCXyrlo64m4lw8Xa4f1Q4uaJRbWD9RZQdWNcUSRsGdRDT576RzGhu8iggDt5tYm6uvWXIFW6HCwEPSdlYZn40cu+G55T8WukA8xV5LMvVaxpchfs7W8pfdh8X8UFrHpKlt9W4UQLQll14iAYyQ8OWzDfHH6akXP0rlyOizushUjF7MYoi8arC0f9ICj1xjfl1+KmSE0dUgulD+m+9gECP01oBoiIlGPSY7I+iWJtytqfTN+s02lM8Ru5iCRZNnpw3JB62fKDP+IV2O9BtLuj7rG2G6YYXFvH27fE0pregIsn3rfLNz77qHBv7H0GvcTqaftTmqdLFVdw==
To: joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com
Date: Thu, 11 Aug 2022 17:46:18 +0800
Message-id: <20220811094618.23175-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR04MB4671.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(376002)(346002)(136003)(396003)(366004)(39860400002)(1076003)(186003)(2616005)(83380400001)(8936002)(66946007)(4326008)(66476007)(66556008)(8676002)(316002)(6506007)(41300700001)(6666004)(26005)(6512007)(2906002)(44832011)(5660300002)(478600001)(6486002)(86362001)(36756003)(38100700002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 09:46:25.8720 (UTC)
X-Source-IP: 40.107.2.60
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10435
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 clxscore=243 malwarescore=0 suspectscore=0 priorityscore=85 mlxlogscore=786
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110028
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v1] ocfs2: Fix freeing uninitialized resource	on
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
X-ClientProxiedBy: SI2PR02CA0020.apcprd02.prod.outlook.com (2603:1096:4:195::7)
 To VI1PR04MB4671.eurprd04.prod.outlook.com (2603:10a6:803:71::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 796aed2d-a4d5-4d01-37d5-08da7b7e5b69
X-MS-TrafficTypeDiagnostic: PAXPR04MB8877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 mZFyF0SHE1Hw41pky5aVII0cb9947xQU2Pp45E8pedJvSY48hF7LfSnfS/bJ9Mb8V02YYEVkki/FJuFhPzvg/yP5ZhNb2Eva3jpYedopFzN6jikBnzUqYe6H1F72Cu8PY/0alth70WOlmfnkfH+PUO5P8i6wky6m3Nb9fCIVhvQ4dDKnZEU0Q8BXIy2mxdjr/bgcKJ2CzGUFWYBibqyWYBimoyCjMA2WW0VgYi1vgGYrERV98RF+qagaspvZ4ss38f1+J2/VHOZgV+kwm1kanvAx75ameWuClWocPIV3aN/Ao/jC/u8jPyHQdxXz1SWZTtCzADIcnlXoFwiOi9JghAMxdgszRYj67nfoWH4cuRXik5TjFTlN79hbG5ovYvluXSLKs/rLoZ9B5joABNwSJKOCE7Tm1bnrwD1qGu/f7JpfVYVZj5vm+/cjpIEwRBFMTonLV/+o2dSwPBc/53Oq3ibUqqVxooWrdyK5q6ELc0bUS7TzRDkV7JATz1xIE7qifz40WiTToIEP3mrvgyYJScw1xcy/rig9rTX8THYn4P6LLWIAwi+1QpVRZhyA6xPbXbpPMqgK8M2DX29GQEQBtWV60FiViwnApym+co4Q1KI8a89pTJlWq4HVwgZsex5jQNyqv5ybLDf8q7Ld1b4Wm2f+0NyaVsWYE5T9o3W6lSyG60AGFrYBREAoaoDClIIYQi11FdWWA0oqBhiEsfmgRuJkFxpDluqxOq8XDkghQOs=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?5wjIS6/8RfKaqqjICSzOpGRwWqwluFaNG/sv2/DNpHhxJJWU4DruoLo7nW+I?=
 =?us-ascii?Q?BwFAY9EwP3L87QRXB8joTJs184dKftgAtkVHQFeJH6ZB7wYy5iiBPBROJ7I3?=
 =?us-ascii?Q?G5EbcV/Ltii3g/t7w6+8rq4aRLq0b5KwiQGRH44U1hzxGgmywBG78PJv8Q1Z?=
 =?us-ascii?Q?agcBigZTMNb0JYjjBboAOh+A3J6VIsef98usdjE7O9RwwEqcLmW5ZEq2jTpD?=
 =?us-ascii?Q?3EqWHR7MLG4F7CkSl+Hfr8v6m4jwEGt7zPqi1+WnT7thhDed9Ga9ZTvoB1b7?=
 =?us-ascii?Q?NUpSSJ7ZHqpVuKtzrZLP88W8PG5SSZK3OJrx/JjAZPOEOMuC9ZqrlGD+ZaR4?=
 =?us-ascii?Q?yzWfZyxvzdCnuyIJXfgtdWP5CZi4KsPcOvQnDu8Ybiu1bT6a+TxbJpMMF8xQ?=
 =?us-ascii?Q?O+p8B0W2s8xgSPuWCa+VeLIs22XuyzJHH3C+H5Hh5/JX4c8JRefU+Y9kMX8w?=
 =?us-ascii?Q?Guzz1Cj9UfH/43l/AHP01QR+oxJ6H3vCfwju1qRy4Zeg/1y4XqFvGq8HLgL8?=
 =?us-ascii?Q?pwTcAzckUu+aLs6g4giQI8qaN/p+W6zfLos4n8dII0QjDXR3OHCB9djWDq+o?=
 =?us-ascii?Q?Dxu3Ltaa+LhQnGOpJPpk8O67ZVi9PssXZEYuioK7hXzEGS3t+org5NDuWMLI?=
 =?us-ascii?Q?1HCWpRahqoshvs3Y7s/iOsmMzwmxCPdWZ9W/KdcDssL/apmWdbm1g7RqzdC2?=
 =?us-ascii?Q?aiTv1ZuqwyiGH7oe0RWdh+dKewIyiG0pUtl+H64F32U31xVuFQ5BCaJ1hFOE?=
 =?us-ascii?Q?E9/ME/zKGhSxNER2+VUYR4r9UP8634LxVF1cEuoa38Ea/SFSOpfPBRhdHsqU?=
 =?us-ascii?Q?akrKDJsIBL7zTp+ag/3DkMn9Ahb01ARJ8NxLV10q8bM+AuSrdPm43DSDcklh?=
 =?us-ascii?Q?DF2CjV672kXxnqzj64aOy+ynsWHVPYP3uxUogiFupO8/pi07gemz2I698Sml?=
 =?us-ascii?Q?9CmdNY0liEo7ogkxHDCNdBC9eALj0uspo77VLSLnM3EgQKmsmUxYHyY/fhH0?=
 =?us-ascii?Q?TCunGfKy4vGlXL9wYpKS7ha9TCMhKhdaDswEgjwfFJXAOkb0eKP4D4opvyP9?=
 =?us-ascii?Q?yk1/bg53lbTWPPFQw5nNXWQqcBx0uGGOrhTexCgkmTnxrgcxVQHSLFu2yl2M?=
 =?us-ascii?Q?P82H8MdrbtUXh/grwV0Rog/gOqPJrOPYzgzN3lHuTq9TOz3gt4zGo+mssBQx?=
 =?us-ascii?Q?cazpBRHiPsSTP4BJa4Fd1yAeL7jtx6LNAXsjAZGF09ESzq3+BkGnXc9ccnkO?=
 =?us-ascii?Q?DGiPSfmQwD4IFoqH2vputdi0QWze57/Qzmfz4ff8X5WnCss89mia0Jqvn3DC?=
 =?us-ascii?Q?LXl81AUeVEVryDG4mLrr5/LXNXaXlVCN5sucOOPWobaRW7rq1bPJgzffVtoo?=
 =?us-ascii?Q?D6uZc3xrQGMGKVrqM31Q7k1xYWlUuvocyW5SbnZsp/zAESSJ3uBbivweF0jv?=
 =?us-ascii?Q?k1ZxSNmiDGkCMLQ+A+1cT1wwX+dtb7PTWHu4hmC3YophOtzeRThtKSVFdVAU?=
 =?us-ascii?Q?MeprhYUhpXHWkTdk0kKTkb/DRfvOO1PovmvpTA9AJDBlDDAS0MtMraDNsD7W?=
 =?us-ascii?Q?W9yei2dL7L41GGrLJWY/eSJcxHrB/Xrd97g+fl5B?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 796aed2d-a4d5-4d01-37d5-08da7b7e5b69
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 OjA1j6nSYHAE7Xelg7F6tUABf2cqVagqSAey77uPDA4JFvCtl8hAa9KS50vqPrA/pR3MQxYN0+14TRlXjTeqXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8877
X-ServerName: mail-eopbgr20060.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 6waFgwyU3nNkK41J56iuzv4L_VcHcpeC
X-Proofpoint-ORIG-GUID: 6waFgwyU3nNkK41J56iuzv4L_VcHcpeC
Reporting-Meta:
 AAEGwAXONmnls6PLYEYX/kq0b9VrtSfSFrYwBuSO83O/X8vFzqD92AVSu6qeOzWj
 wHoF8k8OzXJmtUTWP+jIZbvx1Gb1AO0ZIhz9tky/wHLZzfTNh6Vxrq8vxyUqcoIA
 jtr+3oKcztd9vvyeESMTBKNtve/M06eRE52nqksAroyEi+P8t0FA/iCBfZRTGEdH
 /+UJ1dv1WoLFl6mHoMfilUt5baqHGuhS1dNgkxhrf0O99YUvtoZ6yIvmxXiURBQf
 KY89FYiZJPrLGCY/hw/qdbrNwSr3Gz/CbYfnDLV0kmH18e/jQzDcRPGLr14LoHgO
 gX1nNS+dwTTkoyl+D65+UDKCxOU6XJFvmgljhOyjXo/vlxj6ZPjUPTRgiVu71/HU
 zgRClubGbwTS/oKPxbsFfWz2WBtTvl9he219aOSvB7U7KQLX2QyJkgTkQYcmzMcz
 YQQjjvEd+4vGvfDqmj6xoazlXrHu3WJ+Q5rPPWPAxvRQ6J8pmpmChMAW+4GeXJz/
 q3+HiR9SIuxJxKsSvATmVCmNFwvqfmj5mnZgsXkVFDTk

On local mount mode, no dlm resource is initialized. If
ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling
will call ocfs2_dlm_shutdown(), then does dlm resource cleanup
job, which will trigger kernel crash.

Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before return error")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
draft -> v1:
 - separate to a single patch
 - by review comment:
   - do free lockres in shutdown path
   - put 'Fixes' string in one line
 - revise misspelled & grammar mistake in commit log
---
 fs/ocfs2/dlmglue.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 801e60bab955..c28bc983a7b1 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3403,10 +3403,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
-	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
-	osb->cconn = NULL;
+	if (osb->cconn) {
+		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
+		osb->cconn = NULL;
 
-	ocfs2_dlm_shutdown_debug(osb);
+		ocfs2_dlm_shutdown_debug(osb);
+	}
 }
 
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
-- 
2.37.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
