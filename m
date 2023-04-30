Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA40C77B60
	for <ocfs2-devel@archiver.kernel.org>; Sun, 30 Apr 2023 03:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3XZ77myXbih14u9VRCc4blcn7HyH2AXmprSeKT4OM7Q=;
 b=APmqkBs+IMum5tSjGZCcVqJg7c5gdpNr81Ha88ocfL0n02RNUdfaXy5ZbbT0RLR+pTFCHGTUwmFM
   fH3bsb+lEW91txSaC2V1pcJVfm+YKlnKgxxX3J9/FTbXktS8EqCVIN7wcedkATLGnp04zsnm95mn
   NwFSW+V3YxeP6YvO8Q9zSG2lmjVBNT0xw83ppdNE981LDYYoLISGS6GGn1+AdxT7n730RRHp0BYR
   Qd85EfdjOeoNlncIhFBG3TE1lbOcNIpVJ5KmoLZrpQws8nisBeX8JUBfjQRYQSEPYfK0STsZfaSn
   L7wL7ni0UaVSRRSdgXjunIS8wZCOEGd8Rd5Lyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3XZ77myXbih14u9VRCc4blcn7HyH2AXmprSeKT4OM7Q=;
 b=l0gQdGNjLMr0Cgb/fyNxha5/OKbPvcsnf7Fpb1Ph+4KgIWMtin/F56yJQQ/mt5VdSmo4YFy/EQbq
   52pq5OD2oE1r8bZ9Tv3QR2/0schzd/rg7bg9RuEO4ydu50vCYrWLbWhcPcDksErx7LoI4jY++YHR
   N0nf+ZQcb0d++gqhP/8MxJNnwXKBJBXZ+u98l6WMT3zbRgmzYgLjQEz1wdMTW2Tlc3Gohdka8DOr
   Uu1z2jVi4mHAfIgaFRNuXo6pDSBFscktI6mzUfjlZsMgYA+7rx3fL9xenXo0Mb8c5acpn5ZttkeX
   O0+swRcgSoRefBcW/Ghe/hIEXk1CuVUvfrhNjw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTW000TQS1XB070@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 30 Apr 2023 03:22:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSwndaFKN8Ch9/jUB7B7qDwdxJD+pTs2atcd3MVjiv0fE9qXtLXjTMyDAcoiFiDEP5i4N3fv9+ijtfQgBol6bmCfcgzwBv0c2MOKxjjUz2JKSQtaIkZ6sIDedQVrv7OSHQMukH+Wf35+BA/e1gPl/KvZYxZlsoWa3gYOXY3qe0bqpcZYd/zK0QBV8QbYHCEWBn22EpeiTgW+BcZ1cXDqb9jlp+5lSwCVBFRevrvD4/LlnRdM22vj/g13b1G4O6PRFN0uK5awETZqWeFHRsgd1tXnEIuaqoYGNacKcx/32LGaLmvBXFZPYQAC/gtBCAbpMjVczti5DsxjnnFUD6gRFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42PyFCMHFnvDBnPAIqgju/VD7jJg4Z9nJDfnSHJVVGc=;
 b=h9p+VHxWJANdMMJrSweSX6wY4JUVpn2nFhPOe28F2V04cQatphjg5N6q28e5CreVrPPvTNB2mUn2qikuG8HZJV3EthWkXHrhFuqJGdRY8p/3n10nPb6jRsqChwWEKti2ai3ZNf1PjtQWSLpgzWfz+TOQpH0uHd9Nwhbseii8IQbvOffAAp+xB7d4jfUmzX6oXG5GYfTfdWms0Q01wZMGbOAZopUC4+E8DuoRUDKSnLMtu4XC2CDxVda5ixADLCIlEvKn11iIOB3m7wCnoUt82hUvo9McbTHeYjW02wQxke83NK/eEnJJehJdbuiVNXxAHJVE0iicjPfKqt4SiTMIhw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42PyFCMHFnvDBnPAIqgju/VD7jJg4Z9nJDfnSHJVVGc=;
 b=PAJiuuupMjkEPHRd8LZgM2jbh0w4pUH16llpZEiCEapLdXeaXHWOka0l3Njanw3H5sLO5CXObtZ/1glLR8tM2Q0jD6+MuE06fd+qy20wvk/Zs1B83a7fyX/cAXvA6LErTC4hn5bBhwwaoZsKNKiglKTaKSRmV6UT2rPFLZize+e5HOVdKOQA1brBW+jdeIMI89l8b+lAkn4UNCQewHhv04QjlUcU/MXc1PHbPP+tcOSlLTYnsHtvAprII6woXgr1zpXxRaCoxXbz6LSwpPaiqIJtfN7uPoMdoCPkEU3BdHEAATkHuyw62pUWJGMiwDNesOkStFce+d4+FRmCnNL8jA==
Date: Sun, 30 Apr 2023 11:22:20 +0800
To: joseph.qi@linux.alibaba.com
Message-id: <20230430032220.mhaeyikzcxxaponq@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <20230430031302.15597-2-heming.zhao@suse.com>
Content-disposition: inline
In-reply-to: <20230430031302.15597-2-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(39850400004)(396003)(136003)(346002)(376002)(366004)(451199021)(33716001)(316002)(9686003)(6512007)(6506007)(1076003)(26005)(186003)(41300700001)(83380400001)(66476007)(478600001)(66556008)(66946007)(4326008)(6486002)(6666004)(6916009)(38100700002)(4744005)(2906002)(3716004)(86362001)(5660300002)(8676002)(8936002)(44832011);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2023 03:22:27.5020 (UTC)
X-Source-IP: 40.107.7.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10695
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=280
 priorityscore=111 clxscore=179 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304300029 domainage_hfrom=9714
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: add error handling path when jbd2
 enter ABORT status
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
X-ClientProxiedBy: SG2P153CA0019.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::6)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AS5PR04MB9755:EE_
X-MS-Office365-Filtering-Correlation-Id: e8da74b8-8d0e-459a-3deb-08db492a1fc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 k6I1yg3JSYkBynDN3t3YCVYil7Vk6eQHx4ay8yKeU5N9aUmCZD1lWwN/3PlaFu3qHSY/9mnj4CTvcYoVvip9a9OdNLvSzgonFpwns7vxYFiLrZOvNnbLhbIQsK06DjRuUG2YLOBvekQdbT95IhWwQRRNExZFaCH6y/m7oSCKxJk5jFmJiTqM3O3C8DEcWzwBYIt8V/mb9YXp/BvJR01DmN0cbJFQibVdP+b+1N1hboZcbKE+fQPHJJ922REYxUKWhSIQDGSGLoAuSdSBBYT/ZB9hsRsaTwJYesZbzKY/skQ2O7NkVTvtQYRSBL5OLVpT7fYvblunZ6LuWz3xie8TH6+FKXi8t6e609VfYZWvGJngNa6h7PUF/cs/IiKepw1zFmIG80oee5nB+iudyDpejQABnvKWKE630ChRPR3cLQWf28d5Gu7SDeoPOOWq9Wd66p4Usj7WTjTDs0KEJ4ekZTbpZjLIXRlxV0GUwUsqkZZ0ckBj0TMUJYaG4PPwScDq45d2l93dRyJLRyPI5GT721b299ckO79a8TpPf6UwB3r8JaTWGBXgF6a5rjQAriBc
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Nz1L/IpZQsElJ8oIbztzK51ce8c2B0dHpJUs/mXwWbuUvIIOMdB/yoZy0z2y?=
 =?us-ascii?Q?x7gOO9dDKmhBxlQ0GV/byFJ6yA+vVMxcL3dUfObSV8uriuQFDBaGfCGSftBV?=
 =?us-ascii?Q?GLkCpW6k/QjBdt2r8RmidQduwBMKkpwdYOM5GBO7+kSeI+D0gfPsqBFm8lC5?=
 =?us-ascii?Q?mSoMJwEp130dOS6AMKJ+lGoeWk6xC3S5t3yruyjnndmddpR7+cwgHyrUPzrV?=
 =?us-ascii?Q?ET3JIN5IusdoYg95IBOJtrPo5/rUwzA8l2Ih+teYKt/tcSrhMhY8VM/jNuKR?=
 =?us-ascii?Q?5S56yWZ5DHOudwaULo3QVPL+PFjOXUUyqoOR3VLs8Eo8ixdTT6H4LKk5w0+F?=
 =?us-ascii?Q?p9IWDW8G8svTRMzHy0Za9HM/Cl9KhsWFOS+eucKpeNLg+kqJU6aQGAQaWktY?=
 =?us-ascii?Q?QQT0IGavGW8OL5tKiOAapLD2B/As3JFRbX/PhzgBvr4LvHw2OBoP2CKxhND8?=
 =?us-ascii?Q?tC5MiWxDVYEYj9fVfqv/8f9x83ePBmwKPUtd9+157adGgQJToIANBjjiKiUb?=
 =?us-ascii?Q?/lcqmkm7OelgsxMoGoxX74pi8V5cArvQOQGPIpx4O0BZDgHiMKp8mXi5AB/O?=
 =?us-ascii?Q?Lz4U89dg2B28fHTJMJ7G/C/xtwE3gbM1j7jEz2IcCIZ6JM8s2dKFhJLjWudq?=
 =?us-ascii?Q?a8WZHmWcZIfW9tfNRA0UB4Dz4HwTTC9KEwnS7vptMTuVH6BFFlxIIKJhKNah?=
 =?us-ascii?Q?8J3aWqOMDwYF0qhzfJ9WC0HAag5YGE1mygxjIwpSY5778t0ng3BWXT6pOSPL?=
 =?us-ascii?Q?ABPzLAnngbgBHmc110WAX69aEiyXcxn+Cwkc52VgrPOo8keSyzvZzvCW3aAo?=
 =?us-ascii?Q?Rpa8/DqOMjr5Uuo3OB2UPjIiXMrUw0YzzhJQd3h93+CtUSy1XzpI89pgaWsz?=
 =?us-ascii?Q?M05AsDwUcZYVxUhCORD7h7HVScaTj9HNU9QIQKEI82L+CjN1lFOIHb/2xYqS?=
 =?us-ascii?Q?GrLb92SWY27s85R73i0DR4Of+7M/rvsFl2ftrs82Mz3ZCStgKP5MyXmcfmQ2?=
 =?us-ascii?Q?lhPvJm5zirOSlq/DQsbnaLdVD+Qpk+mjuClTyIK1nmvYF1r8r75ixsNGFLWd?=
 =?us-ascii?Q?TwB/+T+jVIYCxCnc+iaZm2R26tqvxTeYx05XdqfMpBSImB2hiILB/h5GlSuP?=
 =?us-ascii?Q?mNqCdtrm6bWyy5sKngYX5VnjrIyrBP2wQV+0nQj42YRZnXH+mwnqevmo+LIe?=
 =?us-ascii?Q?VaLGc/qC9XRj5pjKCuTsHDE2tBrvtGRyIDEIrSX6eExBU4g2K6eQJzcOFFbG?=
 =?us-ascii?Q?B+Dev5yomoO3wYKkn5b0MLmb0eMDWbGaHX3iqqIgAXXP5yRynalGUhQVSG/W?=
 =?us-ascii?Q?+HWB/2hBZ7MDiYNk/0SUC3ohfJniKLDR1Z56DcNf4RCc6Pd2b8+I9bTABIhd?=
 =?us-ascii?Q?3QMm2j+P/Fy3wIB0SP9zjDpF6V4iAtYh11eQVTv4aKfE3hqJYeY2AFMxTKQ2?=
 =?us-ascii?Q?ir0vtH2F7LmUd7zSNOGwUadbcXLe508SHIato1bnN0zIlFzaUq6LDhhkS6Oi?=
 =?us-ascii?Q?lrbUsr3m9tjtvTZMN+5hn2HSI/S5l+LYUyzO1R4gApFG2urCMxuG7DdYuW6W?=
 =?us-ascii?Q?Na6z+pguYUryAVGLila19T8neHhIYslxKonU2dvT?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 e8da74b8-8d0e-459a-3deb-08db492a1fc8
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 wBU7Ebq3sYVG2Y9xXgRg0wlGEWPednQUTi4XCZVdJ9veC+h6lUxf0c1AAsxR37ceNSgctkbWbCoPXZsa+0wDxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9755
X-ServerName: mail-he1eur04on2075.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 56jlndMjGpI_ze2UiTfLKBdC-cQICQv3
X-Proofpoint-ORIG-GUID: 56jlndMjGpI_ze2UiTfLKBdC-cQICQv3
Reporting-Meta:
 AAGLZE6px2itwfij8+6Fv+Gsom7j0Fz1ujRR8wLu0ZqhYKeFEDkogVlikjrOabfW
 nTc93Bp30w27d07zpZErNhBz5xnofNBWMN2HE9gY4CgU3yy7VsvW8+6+kaYx1SuC
 UgkIBQIvys/SlJcYoEzVMjaUHxdxpg8HNWBiob5AaAknm6MuUKFJFWc1yZrw8I8a
 lUCEJhcTTzCm+OtShsTUGDqDumImXYA/BuLeYyefkvwQEuWS0uQ5kcrqIyHLVWsG
 eVJZsxPGy99f3Bo62lxBb9FkQQhxpeEzJ/c6hjOhFiMSRlE+G5SlXObLA+qQQzfn
 4/mZZI5za1bg90T1R2q6Is7WYGjcS1aj0vOAwUsVxUdWfXsk+pYMFjw9N8LyftTv
 zvYkMC4XDeZNOoGuSjOt91xRF6Oag81CSZ5/YljlYepkEOYgJEk1dHZc17uUOOYd
 chhv0nZlRx2PDXLzThm3ns4NijKeV3yerisk+sZqrBqARJ1IWc8glPd0eqIPVL+t
 y6OPxWwv7+cLNoh/7nc86MJOPcmg2Fp/SoPLlq4iCPX4

(sorry, my last mail format is by Thunderbird, resend by neomutt.)

----
More info for this patch, maybe I should write below info in commit log.

From the comment of __ocfs2_abort(), there is another way to handle
journal ABORT: panic.
And fstest generic test NO. 648 will trigger ocfs2_abort then make
kernel panic. I don't like the panic style, ocfs2 should elegantly
handle journal abnormal case.

Thanks,
Heming

On Sun, Apr 30, 2023 at 11:13:02AM +0800, Heming Zhao wrote:
> fstest generic cases 347 361 628 629 trigger a same issue:
> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> journal.
> 
> This commit gives ocfs2 ability to handle jbd2 ABORT case.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/alloc.c      | 10 ++++++----
>  fs/ocfs2/journal.c    |  5 +++++
>  fs/ocfs2/localalloc.c |  3 +++
>  3 files changed, 14 insertions(+), 4 deletions(-)
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
