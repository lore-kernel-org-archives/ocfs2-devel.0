Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D765EC7EE23
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 May 2023 08:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EHGLsz6b3U3/SNYsc/aoVZCpKD/koUuLqUN0fFLA9O8=;
 b=aoE/pYNA2CA7MoNJQHT/TSEogJ1HfaMKDYUPt4Gv1R2EKL4wtHWKMX3smuEvYnTTl6wdbWa0OkU5
   azPwzFKJ/t76ZFnQXND7UDU78bKRmILujWF1ZpccJa6jIJ/W/YRqAJbCL9pLs0Qb15qa9uC2tLTT
   x+D4ZlyHtmUov8O+/aqIhzbVf8RwCyEZE415EYlyJg2UyuPoTbRuNzdDZE2yC1x/RwpvSv6xfRvt
   YvUeX7ZHvWupdU6PlriJjxEMf9WT5Pj/IirHArdI1jI0PpXxTy6n56SAPyiL9oNLRqp/d+B08PZX
   FDNKcp9Hc7iaQrmREbYijwNuXeOBytgfnceRug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EHGLsz6b3U3/SNYsc/aoVZCpKD/koUuLqUN0fFLA9O8=;
 b=WeDgCMzldrVTeApauSHfePDb3pCvbaiXYnVR3ZHG9ji1C7SQvaIruxzipLw56CqDHoJma8FoEV/J
   RQkH4ZR/GD58DqguM8ESyIB61VL9kDnhNmv3WUFkpAJYeK6WD+bdP+E48RDs4a+Om1v5YTyo7Oma
   MoumY7ehkl1HIUwtq2W8qqBWnEJSWKRZJDgUWSmX8pDAFh+Iq1cnkuAQEVEPOnDOy0VLQKhtzp/2
   yT9xeg2yD+5zt/F1vg/GPfGx1p94UdCNv63Fqoj6QuV2reQEWhB8zOJqbxET0I8nr/GX/pdffQPc
   +Rvata8V4iFmk5a+FCAIUyLGKeQln5CUnC1RIQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RU4008AJJP0SS60@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 04 May 2023 08:03:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKlKLhUSln+5vMWUmi/nbQ/U1+bHbCdrwApopX4IsMlmWsz0JF4+Cmfq2X2Lrx49AADaZ6ZEkm12BLiRsjuXygXnY4En/Hccgvs9sKoEpnWHHyua5SimAC9CMFg53vkbf/x8X/UM0ERXK3tC1NxtjoUOcqRxMSelDwxeXrBgWS0/15U5GtZZgLI5OFJV1WX03NncQvR3nrIrDcP4K7BNCaoJc5qZs+bMKALJxyzO3d4ZPVi0Kh4ZpfEft1dzy0p5o+UsiIGYQz75+c8Czu3IB8tvPACUGB7Y4QFHJRz0iRdzVgCz7VHpvmal2vQ/yS0PVjfbza0yDpd7m8FWG+lztQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcjIBwOBdZxnVVJytNWsjh7Uyp1fteWJcDPSBV5Dv7Q=;
 b=VKoF+uH4Ur3gHwwgyWBN5pdPOrAP+k9bekz0jfi2OqRYyAKvRCXs3KJvTr08tVn1OTn2l3sB+ky7Izv6dKZU5urIoLSp2qo3VDniosYgRxVT9fMZpoIKZVRAAJE9lV3nVdsT/ONNWxpAeIUh8WEZdcChGY1vCzRQkI4J9DD4ZW2S32umI/5S3a3ThXRascKTP9JlerSwrh49OH4YoJPKmCU/MhAeqmQxRgkRC4fohjUEtYp/qN306ABKaolZXEr4cDofXfRtnbYzPat2qqJX/UJntYzEhuKi+XvlrIiI1QIVuTaxk5ng1XPLQcR5SanxaS34g2TT1XL0uerM1ZOI5w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcjIBwOBdZxnVVJytNWsjh7Uyp1fteWJcDPSBV5Dv7Q=;
 b=BFvyV2M8wifwGMHpNzC/hUptEfikifp1K3BsWrYi7thKEL5uKkALrA2qTWEp7VnaKjP4xVpUXHGvypf2BL190yB6gxV1YjwcK+TOH5DTtbSLetWj5Osco6V7f+3U3D3i9hBXq+u4LYT1woN0VTW4sdFnXh3uSQLa9WADT/KyIkIdA2v7bD8g7xC/FezuE+KkN/98UBLq/nrz2tvO4Zk/OgmGpiPw6cs3ZvpaBSV7jkCwU2DmBxf+r9qiAdrL4knHZlfyn3yeTJ0u+L3eY5UQPq5MGb4wIwlPs2yndiiSOKg5/ZReNSpuiv9+xcpNxTyIe+Cdjyr25aXr4L9OWywmFg==
Date: Thu, 4 May 2023 16:02:32 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230504080232.5a6suqn2hvtfz52b@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <20230430031302.15597-2-heming.zhao@suse.com>
 <5b3e7709-3a5e-d9bc-0e78-edc28b529d6e@linux.alibaba.com>
 <20230504062136.3d5x77fsms5kx6cs@c73>
 <0fbbae4d-4815-ddcc-9508-606416697508@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <0fbbae4d-4815-ddcc-9508-606416697508@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199021)(33716001)(2906002)(38100700002)(9686003)(1076003)(53546011)(6506007)(26005)(6512007)(186003)(83380400001)(8676002)(8936002)(5660300002)(44832011)(316002)(6666004)(86362001)(478600001)(6486002)(4326008)(6916009)(41300700001)(66476007)(66946007)(66556008); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 08:02:42.1300 (UTC)
X-Source-IP: 40.107.15.82
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10699
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 priorityscore=161 adultscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 clxscore=179
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040064 domainage_hfrom=9718
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
X-ClientProxiedBy: TYCP286CA0113.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::10) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|PAXPR04MB9448:EE_
X-MS-Office365-Filtering-Correlation-Id: f7b09a0f-6ea4-41c1-9729-08db4c75efb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 BubXGsPXRXfkXppqkAsfZMVKPO9vdxCwu8fcvqqA99D2H8SDD/boKZFo+Jy7E0R7LONEkiouv7WrdFe9svwrNe/lwoxv9DnKNCJKMBXF7Iv2XHt+SlA+RHmmFkaQdEChQTF7+86GAK8lYpR4pnqb2X0fZlTHNZwGRQxlu3e11rvytvRcjdQ7hJdBLJ5mi7KHvikpbIqQHcBgkxJOUwk7uel+rsNjgZ0vZ2PoA4O8IZfIMRqRErvYjcwlhi4nu0XoXI35/LIKndBFYZ1b3Fl+iBldMJy4iGNVaUt7cuFNPPplBqVeoQo3bqiZVBwTOHPlFwfLnIAN9e85BJNt3EijayPKAl4EXUFCb70Vv9FEzeaTgwcB9+YOuYx+ICnN5GRkJXm1+cge6ldADaERcsLvuFWjx4yJvPnPmhMdKuv29JZvby3cNKs3shXoORoVqVDbVkh4An4h/Cmf5pgQo8GRq0KU8DoB8YxoHOgvOWOMsjz3YJ7raGF3G8zGQ0Oo71McVuf/CnjSY1IYfJwKUoVNGoNqTvyMp/5GyRDm5SoacXX2kCtZqetYkjYuqgFi7QIC
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?+0OMFFFv9JXQuQziRlDG7CtVVcRL9Hx4tvLRGXvYlIp+uUEqKegycekqd2at?=
 =?us-ascii?Q?his1ROM2LgWzyGv25M0omJnDpPJWVx1mW3OwmoXqK/8wynhFIq1RKH+9ONCP?=
 =?us-ascii?Q?3rhWPnocggGDXcl7wEkl4OiD8n6YlIDPXaAR0iSvoilzD7DjDybfKTHTkXSV?=
 =?us-ascii?Q?GN42Ub0GgdpQrXG+bguy3e7UDTP9ZPLZ+I2b78l71yyoRbmfqulCRUaYXXRp?=
 =?us-ascii?Q?fmgD4Z9N4qRW73FHe0Pb8oNO+xjqckTnKz3r9m2RrKPo10R3x2tW8DWKURgp?=
 =?us-ascii?Q?uzOCl5BeRc2hnQlrmTK11FgCHOksf3FZ0XKkoG2qnh6/WT+C9hJ8h1/DmUvq?=
 =?us-ascii?Q?pJuon8SYZ+2viB8O/yxjcGJnkYq7VjM1h/kYtMi+NWCO5d6vrc5Sd88OJDKu?=
 =?us-ascii?Q?SQn8Un90dhWVMCNM9j7P0bjqk/igcmGyVW9gGgQMM6VUDc6ejX3g75a1PH7f?=
 =?us-ascii?Q?Ss5bCONj6NxipxpAzElYojBXNW+A27FgbxEg09xHpU/Y+JicMfR9oohs3KQH?=
 =?us-ascii?Q?kbynbj1zJJuDoFRjJVsLm/jIUAy9YclFn/opKhor2tGXUlz7hxjH1BHP8AwT?=
 =?us-ascii?Q?YxW4JOz+E1oNCCwFdT3wapAdVqBGQ5mVPnLpdTt2Y7X/Hp7ODyPEj1etYduc?=
 =?us-ascii?Q?qywwDvpOGszFxSIs6c1D4FkrmVpOTcaaPdCMW1tnndbQHG/S7NJqUBdKTRjp?=
 =?us-ascii?Q?Xw64CXf05V6h7K9BO5Zyaxiv85oxEdAXBQflZQfUtapvTSjixxzlL7S0MLUI?=
 =?us-ascii?Q?qm3Ybr2RuHtaWWegIZY7a+NQ2Ml34c8QrXMn1FU/Yb8ylcrb0T47Vx2E6zFh?=
 =?us-ascii?Q?KLzcgWwF0mz+nzqJNA4BWrj3iF8/Zw1MBFkzXY9jZXYvWpeDvbZHPr8kze2b?=
 =?us-ascii?Q?pUsmf69iN/RVRvaSNW8hAw5FUYo0EADXfFf0UMx92PGnA1qOIxpd/iHJsvpQ?=
 =?us-ascii?Q?m0UHPnESBHax/1iLhJspTNtHpK+MqhdBoQYx00kN08CtXjBLDgE/NUbgklFj?=
 =?us-ascii?Q?x+8r6xKzwQj8psH1rfvs7DK4f1edqxQiyg5Dg3K9YtYWzumVN1EOKhQCn9Z+?=
 =?us-ascii?Q?2rqmQD7Q4ja/X6NN2G7JtoqcgWN/mNoIeTHYn7gwQ3N3/mBGffvP2+GTiLyj?=
 =?us-ascii?Q?gxNbQgTorvSscbbz6HIqAh/1xuFLeu77kvjxhI3NeTNuZ8er/owGnQj9xvWD?=
 =?us-ascii?Q?drtBDETW9a2XiNQS3pzcMi/SPHmP6ltDHiOukdWolgLKOmYlqUzr9JsNR8iM?=
 =?us-ascii?Q?d0O3/FkOJwZO0ggh/x5WOkTMh42DrVeOR5nKQAsSIwnmq/QfP9JR04LAFsLj?=
 =?us-ascii?Q?eUEaDhT33IAtH4JBHbbZ4VuSKlSE2e+7qmtdnV7SgBPtGG2VfRMrJVQ6wLVj?=
 =?us-ascii?Q?0lbYfiXsCEuNYbjrnMwrClpnfiWwDhkLXaYmlcxxRfHK4lyl4PaSnFbUvpWB?=
 =?us-ascii?Q?5igezutG0SwXA7VceWouGoFc72hDYWkMm9BjVDbLL+gJv/WYb4XRdchlMgoy?=
 =?us-ascii?Q?mT5NDF9l+XQzSjUVW2TTQ7J5/QrO35zjnTiToIFzg6kiTKznWXpUls7kIwvl?=
 =?us-ascii?Q?YvfQuolzqSLh1IsUk7cAFzXF09l+sWMJW1YMotdy?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f7b09a0f-6ea4-41c1-9729-08db4c75efb5
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 /cTESDkhgF2nkfc+A7+uhdrrKCq7I+H25EHqmbJKI3Xa6a+OxPLS59X1fYSQxcvPyZATi5O2Dzuh6XkDDB0H9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9448
X-ServerName: mail-db5eur01on2082.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: YCQPr19RMMYQRD7P65MATU3ORWDKYxSa
X-Proofpoint-ORIG-GUID: YCQPr19RMMYQRD7P65MATU3ORWDKYxSa
Reporting-Meta:
 AAH6Qoi9K+3KRrH30KAj6o4oNtbr2SfLUFZvjfccfi23FcHg46oVI+FpxcYNi+Lm
 y/NM2tpIIpwOQRNqNonkkhvF2wSFhCST/jY4k5+lb8DDkImloEAR/tFjgyNR7ZNq
 OKVJy7hhhF0W+ZRoaaneWcD53dj/lPPo/7gW6MPx3n8omcCDtymo2NGQmUcr4X4x
 z14VOsXVDmrQbj5n63GCFA8VESYENnDagqqXLuP1HTTrrKXaDVhJP0U/JrtzkUEw
 24SxFx3MVVJ7Ucu/arWW6//EXsUwBCiKM3TCaFZL4ON+9onw6jhN0LOinpWnvgvX
 cmRxNQAXvnAaEAbET2wIsBqLwKb4A3v14Jon1r9STbxlnbHXmZg2iRcwzBt95XNu
 s7VB2ud/YQBR/dGk7CUmrjS7lP3cPER+B1jsHJ/LdMAwrQqMHtkeCviDz3hTM/v4
 UxK1EvX77/uBnn8CHqRnbLvD49H3M59grnbevNh5osvCeito5gg96xncri0nWowg
 j4C7zBipSAH3lmZHFA6GS28US+eGzABGBYHW1sfq+tnA

On Thu, May 04, 2023 at 03:34:49PM +0800, Joseph Qi wrote:
> 
> 
> On 5/4/23 2:21 PM, Heming Zhao wrote:
> > On Thu, May 04, 2023 at 10:27:46AM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 4/30/23 11:13 AM, Heming Zhao wrote:
> >>> fstest generic cases 347 361 628 629 trigger a same issue:
> >>> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> >>> journal.
> >>
> >> What's the end user impact?
> > 
> > There are two impacts:
> > 
> > 1. this issue makes unmount command hanging.
> > 
> > No one likes or accepts filesystem unmount failure when underlying devices meets
> > error. For comparison, other FSs (e.g. ext4, xfs, gfs2, ..) could do unmount
> > successfully.
> > 
> 
> So umount hang should be in the patch description, right?

OK.

> 
> > 2. for developers to verify their patch doesn't make any regression.
> > 
> > fstest is a famious & important fs testsuite.
> > (Yes, I know ocfs2 has itself testsuite ocfs2_test.)
> > 
> > Current status, there are many test cases (about 9 in my env) cause fstest
> > hanging and blocking fstest to run. I did test for gfs2 on latest tumbleweed,
> > gfs2 only has 1 hanging case.
> > 
> > In my view, ocfs2 developers or maintainers at least make ocfs2 to finish the
> > testsuite. Long-term target is to make ocfs2 to pass all the testsuite.
> > 
> > On kernel 6.2.9-1, the fstest 'quick' test group result:
> > (the result based on my two patches [1/2] & [2/2])
> > ```
> > ./check -g quick -T -b -s ocfs2 -e generic/081 -e generic/648
> > 
> > Failures: generic/003 generic/013 generic/015 generic/040 generic/041
> > generic/062 generic/082 generic/104 generic/107 generic/228 generic/244
> > generic/266 generic/272 generic/277 generic/281 generic/322 generic/329
> > generic/331 generic/336 generic/343 generic/376 generic/379 generic/380
> > generic/383 generic/384 generic/385 generic/386 generic/400 generic/410
> > generic/424 generic/441 generic/448 generic/449 generic/471 generic/479
> > generic/493 generic/495 generic/510 generic/537 generic/552 generic/563
> > generic/578 generic/594 generic/607 generic/620 generic/628 generic/630
> > generic/636 generic/702
> > Failed 49 of 568 tests
> > ```
> > 
> >>
> >> JBD2_ABORT indicates a fatal error happens, either in jounral layer or
> >> filesystem. And we should not commit any further transactions.
> >> It seems that we may unify the behavior like:
> >>
> >> if (is_journal_aborted(journal))
> >> 	return -EROFS;
> >>
> >>
> > IIUC, do you mean add above code in ocfs2_commit_cache or in
> > ocfs2_commit_thread?
> 
> Yes, break the loop in ocfs2_commit_thread() in case of journal abort.
> Actually we've handled this case before, but just limit the print. But
> it seems not enough now.

I wrote in my previous mail. Follow your idea, The code should be:

if (is_journal_aborted(journal)) {
	ocfs2_error(osb->sb, "jbd2 status: ABORT.\n"); //this line is important.
	return -EROFS;
}

Only return -EROFS then break loop in ocfs2_commit_thread() is not enough.
Without ocfs2_error(), ocfs2 could accept new IOs from userspace, then the new
IOs will trigger IO error then trigger RO status. This flow is wrong, we should
mark RO as early as possible when JBD ABORT happens. In my view, the best place
is my [2/2] patch code which in ocfs2_commit_cache().

> BTW, the basic rule here is, we don't want to change journal to prevent
> other nodes corrupting the filesystem.

If my memory is correct, every node has itself special journal partition.
If the HA stack assigns the same (before fenced) nodeid to JBD ABORTed machine, 
No other node could corrupting the fs.

> 
> > 1>
> > If in ocfs2_commit_cache, this fix doesn't take any effect for unmount
> > failure(hanging).
> > When return -EROFS, the caller ocfs2_commit_thread just print error message and
> > keep going to retry.
> > 2>
> > If in ocfs2_commit_thread, it makes commit thread exit/stop without notifying
> > other ocfs2 paths. Later wake_up(&osb->checkpoint_event) won't take effect,
> > ocfs2 will enter chaose. 
> > 
> > In my view, there is missing a place to set fs RO. So [2/2] in
> > ocfs2_commit_cache, uses ocfs2_error to mark RO before returning status (<0
> > value). The ocfs2_error is the right place to mark RO.
> > 
> > - Heming
> > 
> >>>
> >>> This commit gives ocfs2 ability to handle jbd2 ABORT case.
> >>>
> >>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> >>> ---
> >>>  fs/ocfs2/alloc.c      | 10 ++++++----
> >>>  fs/ocfs2/journal.c    |  5 +++++
> >>>  fs/ocfs2/localalloc.c |  3 +++
> >>>  3 files changed, 14 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> >>> index 51c93929a146..d90961a1c433 100644
> >>> --- a/fs/ocfs2/alloc.c
> >>> +++ b/fs/ocfs2/alloc.c
> >>> @@ -6308,11 +6308,13 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
> >>>  
> >>>  	if (tl_inode) {
> >>>  		cancel_delayed_work(&osb->osb_truncate_log_wq);
> >>> -		flush_workqueue(osb->ocfs2_wq);
> >>> +		if (!is_journal_aborted(osb->journal->j_journal)) {
> >>> +			flush_workqueue(osb->ocfs2_wq);
> >>>  
> >>> -		status = ocfs2_flush_truncate_log(osb);
> >>> -		if (status < 0)
> >>> -			mlog_errno(status);
> >>> +			status = ocfs2_flush_truncate_log(osb);
> >>> +			if (status < 0)
> >>> +				mlog_errno(status);
> >>> +		}
> >>>  
> >>>  		brelse(osb->osb_tl_bh);
> >>>  		iput(osb->osb_tl_inode);
> >>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> >>> index 25d8072ccfce..2798067a2f66 100644
> >>> --- a/fs/ocfs2/journal.c
> >>> +++ b/fs/ocfs2/journal.c
> >>> @@ -312,11 +312,16 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
> >>>  	status = jbd2_journal_flush(journal->j_journal, 0);
> >>>  	jbd2_journal_unlock_updates(journal->j_journal);
> >>>  	if (status < 0) {
> >>> +		if (is_journal_aborted(journal->j_journal)) {
> >>> +			ocfs2_error(osb->sb, "jbd2 status: ABORT.\n");
> >>> +			goto reset;
> >>> +		}
> >>>  		up_write(&journal->j_trans_barrier);
> >>>  		mlog_errno(status);
> >>>  		goto finally;
> >>>  	}
> >>>  
> >>> +reset:
> >>>  	ocfs2_inc_trans_id(journal);
> >>>  
> >>>  	flushed = atomic_read(&journal->j_num_trans);
> >>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> >>> index c4426d12a2ad..e2e3400717b0 100644
> >>> --- a/fs/ocfs2/localalloc.c
> >>> +++ b/fs/ocfs2/localalloc.c
> >>> @@ -378,6 +378,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
> >>>  	if (osb->ocfs2_wq)
> >>>  		flush_workqueue(osb->ocfs2_wq);
> >>>  
> >>> +	if (is_journal_aborted(osb->journal->j_journal))
> >>> +		goto out;
> >>> +
> >>>  	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
> >>>  		goto out;
> >>>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
