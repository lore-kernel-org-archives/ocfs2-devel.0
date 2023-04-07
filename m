Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 684A5C77B61
	for <ocfs2-devel@archiver.kernel.org>; Fri,  7 Apr 2023 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FZQep50RozNVGZn5ot6U18GPetceuS6zcd/ujshGEPA=;
 b=b5tFy+4NKUlfA2Vr/bNlCrmRF/jlSUp2VwlIDsxxvGwJYmWcT3NZvLktxkWDLfeWOOpviNtWus0R
   lBs4bJ6AcMM1N2swduaajn1PxjloqXVJ/t8sXGOA3bfDKlUp0lVNibS6dNIyavlQg3UX1Sn5xM53
   H2ekSPRDm08AxYjn/lZ/f9p3Ec0nZnv0ydOhU1n+EGlB90B7ayBNKPEDf6AYtLo613RGROq1upv0
   SmXjLX9vUpSDaFSGWwRLWmdxsFz0fIEZcWvXGKAJZ+OnIWI0he40dNcQ+RZyiaJBMDMe2kkyoDfy
   X841cOT1RIfQ+4vnnVij2Wym7pNYBMR4rcqNFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FZQep50RozNVGZn5ot6U18GPetceuS6zcd/ujshGEPA=;
 b=J0d0f/e6H/5q8LkHESHX4jrsGE75YsfXFBpbeqPAwmmUS0fJVYC/ROCg64jBon7mOsNiPZCfWX0q
   KXOmoM/B3gXSjju+x3rw4kN9XD/p5VHSgzUdylhWg52YY39wgNBSi2T3yjRqwjZHvrvvaTnKmykJ
   t6n/idMtFhYWP9ToL9yVasDQRxl9Xp9HU+fhe4dQJGKfHTstSbhrDD/PAWDOh6YhoRBgLiOAyFgH
   RXbRykd/Wjdh59c7MO3u8hAr0IPNpCDR7l7fPbZlOglJmh75HYyp4+PiTTIE1BDaNmeMm+cjkZ87
   4nebbAh5WMGNgfD3LlcVHWONTuCxX8LrSbhDNQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSR00D7H50FMWA0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 07 Apr 2023 15:43:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2VbtCjs1Eotirar8K/97FMklrmL4ndthQ+Ck+9NBTMqASMEj1HhV26K56KohACfMfmkYcb8KN7wtM9nkn646TmUavy6q5LdMHxZ85lx+t+sm3LUGCcO9MdPVJqOXQSt2j72HWhT7T8bUj9sWz6u1LQBZ2RfjqMeJJ3vgJbp+MS4eklbGzoWYJ5r7Pi7DfCe5Db4yPjlfte6NOFUNf88aLGkHa7RjrmdJNtAUdhfGRNmygJkLRlmeRcW+XWhqjDdxm3qLfwlpqG9zaa6UXOaYeJ51P4cYaQXqSnAphTt7Qc1cod+UELF+5DjY0jLyF3hVQbkZ6wVH9jpgHoJcT0xtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeA/Tnp346ltmSgRQ5VxumugwKp/S2BiFhBUfR13C+Q=;
 b=OubDDrsWsfPzhkWBUbW5uaw0MZOBawqUDy1LRyTEwZiJZVkPk6WT7mEID0tg5PV+AWrjcGo8YkFe98osO53c8avRuGwXamvDYcO+iJouzxkDh3cNydH2YScZW3tkdPApG0vxbbxQIbMbzRkzK3TMDODnilmXG9lzByAD7XvVlVV9zjn9bIBieY+fy0sy0rpyk83N9a7fzTYrQWopf1a+PITCoDIu1L6RWFnQ1KtALTV+HPW57z7b05xvVGVhIlGKFny/0A7HFcHHuI1BrVF+Me2I/jPCAcX5rAc0y5hSpOBA+1FqJs0dJWxxXnsjzv5EkDD5Bv6KrPCKK7frNV1g+A==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeA/Tnp346ltmSgRQ5VxumugwKp/S2BiFhBUfR13C+Q=;
 b=APrIfs2e4r/vUEfjA10regJJ+Rb+mDwchtSnilTiwJGP/9yaRd146CXDtzwC19fnXk/I9OM1XG8avmGk4Zw79d7y79+gSW8GLkHv556HGbSW31cXIyuQoWwXZ2v3PhXJglLZRzJJLOyfRZ7xnLSDSmGkY57ZdKHcxkrW00C4QyjYgLspqIeNfsQzDYuaJ1jOzm9xS3wvfpL6TmVG6DMoygrBBerqTvJ+7mbXfPfZ7kj1DqOITV77YuywDomB+nmk69mjxMZyP0rcY3byHDF5+1+kg/SLXo6gxmQ0EesyWsvVcpiioFReejYDWbOtrRlHbgPBFGjWSmlY37Hth84CNQ==
Date: Fri, 7 Apr 2023 23:42:53 +0800
To: joseph.qi@linux.alibaba.com
Message-id: <20230407154253.2yd26vtpfq6bvq3b@c73>
References: <20230406154052.9863-1-heming.zhao@suse.com>
Content-disposition: inline
In-reply-to: <20230406154052.9863-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(38100700002)(6666004)(26005)(9686003)(186003)(6512007)(6506007)(1076003)(83380400001)(44832011)(2906002)(8936002)(5660300002)(86362001)(478600001)(6486002)(66476007)(66946007)(4326008)(6916009)(66556008)(41300700001)(8676002)(316002)(33716001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 15:43:00.6089 (UTC)
X-Source-IP: 40.107.14.57
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10673
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0
 malwarescore=0 clxscore=177 impostorscore=0 mlxlogscore=950 mlxscore=0
 priorityscore=48 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304070144 domainage_hfrom=9691
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Fix wrong search logic in
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
X-ClientProxiedBy: SG2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:4:188::19) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|PAXPR04MB8637:EE_
X-MS-Office365-Filtering-Correlation-Id: 2626b78c-e39e-447e-722a-08db377ec453
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 LSqc0jCvQ3ViSviNMu8hA5otH3XDUu1vsSXJU9A/m1emZzUB7rWHEe9sghBH4dnMoV+CZ8jYiWsj0KierzScJNS+Fwp7F7OkaAovW8yvttSsNEyEilLxIyh8HDXim7BcETEeH79J5T5MIicSY1En0T/Eq/xVJmBqCRLpudQo580qjIdaPsno+mjvZ6XY2MYir1022zTzkicXZHqJFqq7QmuWrXupy/6i/oQV1ZJHUjoVAACYDPBwIoA9lZghDmx1VskrxXG+crpQYmSjC1GuW2XDEx9h4gpnJR5/2Il5EXPoljuycQO2tPd2ZPBvRw/fXMroVMGHbC8adjNlq/Y80TCyVirppyStLUDFGyAHvlMZon/Fgw03cC+m2HF9jl5ylOMhMJt3XF5XqqMR1C+Z67wqLyYcE2x3/sM9fKYIkoMfc6PRWZ3vK+e2SSwpU9ateiWj79Qki6dcKHH9XifN+CY4Jfd2/V3Qavd9JtV334Md3aXkxTlrP1FPkb3VqTzr+MnSpX5ln5HUSjfwVWW+UrD6MC+H5329wb2KhpVgWd5if9LXTbAqy8pQDrFU8bQj
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?pGb0tFbHzEuIhJGRc3Vgkf+0GxWCXxIuuRCUwNKGSfnerQfiYlZbdIXCW8Eg?=
 =?us-ascii?Q?TR9klbE1eJNAaAlncol//TUoohDqcNkFOrB8f2AaZn2lfJt+20DkJFjpKVdk?=
 =?us-ascii?Q?qLV4mt0s/BtFHlknF0MNYyXOLlTWTyskPVzTrnp2rbrzuQWoHemRhGdbK+CW?=
 =?us-ascii?Q?rsQiFKbxzTE7+KEOwiTR8qHdVsGfV78xQEcHqZNnz4FS4W4kNexju0GKxJrH?=
 =?us-ascii?Q?De3KGRUwMRUnuXlJlS3WYhHTQhWzhkdoUqBjKzdklSZa/JDCXvobxrCHISot?=
 =?us-ascii?Q?rGFkdAw3ho40DXLp/rB5E2YSEiABl7zbCrOnFFJ1VbeGjb7azls6+ywK2IJj?=
 =?us-ascii?Q?wxmrgzgFgILEbFyOTyAv5otKJe70+VFsveqU1ud6UnH7+M7qXnwN9A20M32h?=
 =?us-ascii?Q?GN2w2CvA7SAych1wg73CfU1mtyi9mlO62VoaxBfw132EQc2IfZV35auXsyVD?=
 =?us-ascii?Q?VC0w31OrYf39zgAzRReV0vxhmaePFMDBSEgQID9GJq9FWaYWClN38xnNFvPN?=
 =?us-ascii?Q?LCbOLTw4+YpLGCVMtLkZJvpzWQpm6inXWjfCPyr+nf5Mua3hZLEtiSnBaZUH?=
 =?us-ascii?Q?UdL0LqcYwXwBba46u2pwhb7WWyxGGec/TVSWy4+nrqCKjmYW4K7/ru6drSNW?=
 =?us-ascii?Q?5Nb8SWF+uR7fKL3Mw4BqS4ldX6EKwPdGqfEx5Lcb90ktGcS3U5+1VcDxe1Hp?=
 =?us-ascii?Q?cI4KwZ1Kt94IfJrMTJ6ZAiM83aIU1SQ5ml6FStpARCbAeKZurkEqJi3stexI?=
 =?us-ascii?Q?1qsurhbjE8RuBe7ZcGKztRFsPwDq8PxKEfvW8pe/y1mUXDVZlro9286cIK/B?=
 =?us-ascii?Q?0tpiqsI1dYPemk2iyFfz9sAcSEgkJeI4JCIOhFarqSNaGagpmmsPRb4pFqwt?=
 =?us-ascii?Q?Hi2oitzykp0CpTC7oLtnrL8/TmP8UgZQ091/C1lJM2w/fEz+v0fHKXKmvsmk?=
 =?us-ascii?Q?mlDYt3ZJbKbMpz+rPzwaxmtelEPEADo71Pd1MiLJ4Vf0/LhXXmijrab+M1p3?=
 =?us-ascii?Q?cAw8K6KMob4SLqNIVg2Bo2yO6XYFL70FWACbwSWuer2F3x/kI9aWSxms+Ot5?=
 =?us-ascii?Q?ioyKlLwI7gW3euzJw0TFxul9NV6t2Hnf+NALuKbPBYOGcuSjO8mXEeEwrz83?=
 =?us-ascii?Q?oQh33Tmyu8id/jDqmdjR0npZY4eawPEHnWi3RMW/7q3vLB5aXEZpTNI84upW?=
 =?us-ascii?Q?nxB0J+qOABMGEK4w56mSqF9mHy9oRbF1MLEwP+1ZJkxoKA0hW9dZd9dFzlXD?=
 =?us-ascii?Q?NvjzFX7uSYsWKQQIAPigsxyN/wvLlQ+6DnH6Oj0o1Zx1MgkUfp8/u6qsrZNV?=
 =?us-ascii?Q?sMOEB23stTWIJT2gmGPK/6qpelTM7mIBSobc6hXcwEs2iRIThHktvHKBuJkQ?=
 =?us-ascii?Q?lsJuvM6AdMRmpdboPAM8IyRoSUtzB/DwO6lrF4+Npkr/c/goPeK4+mYbysGD?=
 =?us-ascii?Q?ClY0i1jLW8upknWCX/R6OH5UedPb1HUbpxZSQKC38oXE+qpRXF4yMwyKZaac?=
 =?us-ascii?Q?KaaRFxX6maADQvPrM81iWPyZ8nzO9XkxInwlJvpqIqhuUbyeDaGUVkSHVQRq?=
 =?us-ascii?Q?Ha/SpUE/uC8kaXq0DN0bdUrDGCGGZOH7cUs/NbKC?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 2626b78c-e39e-447e-722a-08db377ec453
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 01EOvYlDX4GI3pJiRF/O5cof5qdenHaq4qfKht0VNV+K/zW4zSa6AKNOP7gO4Wj2BjJMMptsEAqvOdxnvYOMig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8637
X-ServerName: mail-ve1eur01on2057.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: EPk-Z1h69_j1wrY_B3aUK_Kg40Qpcwqc
X-Proofpoint-ORIG-GUID: EPk-Z1h69_j1wrY_B3aUK_Kg40Qpcwqc
Reporting-Meta:
 AAH/h7ucOvKFohwnJq5EQ0Zg6R4/C1uwuiTw1Pc9G7yFV4Fq8KuyrViYYdnyYSTk
 uzqTcfTdkwl8rU9SCKdhb+PK1VYqQMAABx9s58MfSgCQ8cdcZGKwc7AMX1XnFznm
 +xIHrpdRRPYhZNg5CMlFM7KDbUH3S4NV36HMci8JCWDegaD/tUhdlT6bqCSVuDLi
 0M4Q9QKSQEVfVCl+zPGoKTNkMvFpcdrAkynBNVp4ybj3eP1uc1RoR5zzf8qAiOCX
 Xfeh7uVPvBwDCBVVr499P9TORM+So40WWdEK0GKw35A7Ww8wiMCQzh41KP7oIvN5
 DVyovcvMxBg8IltaqpG6DC/Xq5qMhTkuB8cILgWaZOV2mheU7PKplQXQ6qv+/I/W
 wOlrQdPLLvh1IQWYy62eRdk6pGHHbJnzZWj8CArf50HrNPlaZ4/3lKMzCsfLyOIO
 XRy3IZRh7430sBmuznpJ7P1oRuKOurG9ofO04/Qw86t1uP1QJOP4Q16xKP8Bjqk5
 QNnpkm0wOrVBhEY0hnJOyY2pDYREgq9SeUiOVEahXdLj

Hello Joseph,

On Thu, Apr 06, 2023 at 11:40:52PM +0800, Heming Zhao wrote:
> ** problem **
> 
> Current code triggers a defragfs bug [1]:
> 
> ```
> tw-tst:~ # defragfs.ocfs2 /mnt/test_from_dd1
> defragfs.ocfs2 1.8.7
> [ERROR]Move extent failed:"/mnt/test_from_dd1" - No space left on device
> [ERROR]"/mnt/test_from_dd1":No space left on device
> ```
> 
> I added some debug messages in relevant functions. When above error
> messages appeared, the la-window still had enough continuous bitmap
> to use, the -ENOSPC is wrong.
> 

There is another problem with la-window alloc flow, and also should have a patch.
When reservatioins are disabled, ocfs2_local_alloc_find_clear_bits starts linear
search, and returns 'bitoff:-1' if 'numfound < *numbits'. In my view, this code
logic is wrong, in this case, it should return max suitable numfound.

The pseudo code:

```
diff -Nupr a/localalloc.c b/localalloc.c
--- a/localalloc.c	2023-04-07 23:33:42.077083405 +0800
+++ b/localalloc.c	2023-04-07 23:35:10.756344502 +0800
@@ -835,6 +835,7 @@ static int ocfs2_local_alloc_find_clear_
 				     struct ocfs2_alloc_reservation *resv)
 {
 	int numfound = 0, bitoff, left, startoff;
+	unsigned int best_start, best_len = 0;
 	int local_resv = 0;
 	struct ocfs2_alloc_reservation r;
 	void *bitmap = NULL;
@@ -940,6 +941,10 @@ static int ocfs2_local_alloc_find_clear_
 			numfound = 1;
 			startoff = bitoff+1;
 		}
+		if (numfound > best_len) {
+			best_len = numfound;
+			best_start = startoff - numfound;
+		}
 		/* we got everything we needed */
 		if (numfound == *numbits) {
 			/* mlog(0, "Found it all!\n"); */
@@ -949,10 +954,12 @@ static int ocfs2_local_alloc_find_clear_
 
 	trace_ocfs2_local_alloc_find_clear_bits_search_bitmap(bitoff, numfound);
 
-	if (numfound == *numbits)
-		bitoff = startoff - numfound;
-	else
+	if (best_len = 0) {
 		bitoff = -1;
+	} else {
+		bitoff = best_start;
+		*numbits = best_len;
+	}
 
 bail:
 	if (local_resv)
```

If you agree with my thinking, I will test & file a formal patch.

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
