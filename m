Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C36C19F2D
	for <ocfs2-devel@archiver.kernel.org>; Sat,  6 Aug 2022 16:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mu2Tuj4n3Rxa1hf9bCNPUU3tCMjC8wRYatF7MjFWQlU=;
 b=TDjpfODIULB+sSzX446A36NhP9LF92on25J+q2v9/Me38ISOjLPjUPNteiVPOXBEgb1diKBlnS3w
   pa0Gq6+Zo4w9nlTaNZJDlEx+LJg/75C0poSZYaVirAmWOAGn+XxVtPa9rvbyK1/gFjseGGqW3fH4
   MAEneLLQ8VMrBgY6VIbTWVjCYZH+2CUnWkBhEBA5ckTeaSzuoYWkeIsDWECDqAiImsnPC+WWTG6+
   XnqdCQLvPmN5v+Or3/Up54IPO7gLGFA5hWd/GyvbExW/+ytIhaIm8HKL6bk8gtu6E+HpyBYwtW79
   k0NpGjhqBCydDjYvBZT44K9PgICSn9d5RJ5jxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mu2Tuj4n3Rxa1hf9bCNPUU3tCMjC8wRYatF7MjFWQlU=;
 b=C0V1+V53MONWEbFgufOih6UtebN7r+neZZbk69qSvcY+EdYL50+iXTN44L+dlK4e3di8AcxGLkVa
   +SyV9+CreGiLlwEHzlyxJKdgBMr4gLETaJ7lCu9f1BgGv+WOIC6baABZdvZwXRSgYdFfaAgDj2SK
   0KTaPBFB6i2221mLzEeSjMUffor0gDpffjKzzORdvsDT0St8jvAwbX2KM4Vv8sMxk0Gnnz25YUrZ
   NhSMIj4zfZedvQmcGd3Atx2+oYebV2VxJ/D+gdl1w79fG4avx1cmKTCzyP31Q6pStwk9GZ4ioue0
   ejDoA+8Phn4AEoRNU+WZdrQ37q3MbSluGgrQpg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RG700J4KBUJOMF0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 06 Aug 2022 16:15:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DItlsvcs9RUN60YE5RQMt4H3/EoB3+OETVQTX9Cld4H10io1jRPHkkm8tYlAxHUwivY6iLDDBBzD6ewGkRq22ZxEWEoEpxW5c3jDr0gtJeksSAA0Rv2PhozmpPSsRtsFQxSi3pFVNp3PdlGBCUsgmCBvvG8vpXh/GWCvsMDSvWaiJqos5vdiA8ATJ3nw9H1vrgEcKEqrABB13lQlXFLuCx+cN95bTkdOca3cTaN9/r/Euk+eshjMTqffsxOizcF1VMt2qvyG0sxcZysFHf8HZ7qml3Cro5f0r9djQ83P1hUNnjtKt9DpMP+4sSQ9HvAlWQ+qcJhWgpOyHFHlvxXnbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bc6q+687Mb2Q2+G+r80Z8oqAutDU8CzhFLWLPPXRLTo=;
 b=NAjvHv5QA7hArYOgKRoXkoOskISbByWobjGe0eP8N/Uwxqw0Hxg6E2iKRL7bKiKXKB/lmbqTObY7CbYOG31Atw2tA3Iqm6wDkI0+LrcZcUNY4ZYEEojp0RMS8snLyhJlMBx/qZHzWMGJoue3wrcV0NJddw62sxeL/At1RUXeO7onywNjnt4w+niq8A9QjxK3cbiBheR0FFBfke19NCg70yD8WOl22/s1+e67xgdT8aKQ20X+SIpscC5FoMSPzvpgAZBqnI9l6ONI1465KhTwCF4v2ilfJOuzyScyTYWEtmyMjUeHw0P9V1UT0SHFSoq32G0eKFq60LTv56RlgGfJ5Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bc6q+687Mb2Q2+G+r80Z8oqAutDU8CzhFLWLPPXRLTo=;
 b=ixM7jz3ivx/n1nOtFmJHfx94LCc9pyxn6l2xBB+8c8iEFSUNqamj5y6VV+HLSXq7gISq/nZkTPM2J0esWL3aIppxnCTEFuaMN6LGum/ElosTet6/b4WX0+OFnYPshp54GAN1vV/xCGmWBB6+rboOPkw4bBnt3j/ZuohoWEdKK0I3NSus/LcqxY4/WPuYUrqdD1A0n6YpyVJLX2oaEMjbzT0eeKRefO6f9BFGnheY7TIasbC75OMLVCzuF4VNsfnbwAWKS7W8ZH0YrbTU+yb1aQImxNSq1xRDPgYaorPiCF25PSF0PoO6WTth0BjpSb+XarWRYb4Bk9eq4jGU7n1JqQ==
Date: Sun, 7 Aug 2022 00:15:29 +0800
To: Mark Fasheh <mark@fasheh.com>
Message-id: <20220806161529.awcwarizyibbvbkj@c73>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-4-heming.zhao@suse.com>
 <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
 <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
 <CAGe7X7n7J52w3Jn5Sz5=f2AQohLMK5xK2Pjsd9oPAMSn52+SrQ@mail.gmail.com>
Content-disposition: inline
In-reply-to:
 <CAGe7X7n7J52w3Jn5Sz5=f2AQohLMK5xK2Pjsd9oPAMSn52+SrQ@mail.gmail.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR04MB4671.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(7916004)(376002)(396003)(39850400004)(346002)(136003)(366004)(6512007)(86362001)(26005)(9686003)(6666004)(53546011)(6506007)(41300700001)(83380400001)(1076003)(38100700002)(186003)(8676002)(4326008)(66946007)(66556008)(66476007)(33716001)(3716004)(44832011)(2906002)(8936002)(5660300002)(478600001)(6916009)(6486002)(316002); DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 16:15:39.1469 (UTC)
X-Source-IP: 40.107.22.51
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10431
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 priorityscore=151 clxscore=178
 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208060087
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/4] re-enable
 "ocfs2: mount shared volume without ha stack"
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
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5634aadf-fe03-4545-cf69-08da77c6e6fd
X-MS-TrafficTypeDiagnostic: VE1PR04MB7278:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 ah4JEYk6QTafXaJnjWhDhGUEqe+2sVByz4NO5IRrHbzXTWSvot5JxVIu2KPVhYRX4qfx49a+Azv3oxPmzftjtVBnobnf/JpEIUhPAnU8tbvLH6EyMgZa+b9j600VlPk9XUF9ytSeWrXZw/dGKls9pTTYpo5FPEQMDWAL3yDy3oaM6TxARPs2PQgretL5CwWBvqiJln4TydNvWAvUWuAiVRR04o5a9Ruju24isHKgby1EJ4YRfMv7vtLPhDbMgQvRx7qnE23HxW6ycj0rbBhoO6LLQ13LxLz4cdJQB70R7dZhrAM0M2s9bvArH+MLBMHZi/qPo11I8nNEjMYGUZ/3roHpTc7a+F/HqpQjO4s+ekZLpgQFUs4SYTeG00+x6kkmdk71ATgjvgHbe/2L72qnUH3Pj0xu3t2MEPvgZpGkLi5uo3vPIGjUvHdY6s2I9ljPDwOOPlE+6hfK2OmELLO/TXWsFmZe1p2mftTX8lkXfFIxbxib4NXWijg8NJMx9i13otB5yLuabdxuOtGL4vwm7xFAPxC+95cxfmgn7ZG70ztNfAaI7mnaY5dEYBxWwty1uDYAFxtQuWMPH90N/OTShLnd1YjfxFscrXvO9moD2FL4v7mhLftJXhfUPYYHxhwj5hGI3yEcTv1WnLJ1Yert/aTowdxzbdrYL6a2h1MuTo4BHdL4dd1iUXxob11eU2I74OQxAKaszdSo+0fe+9qJMDlSd3ECeXn37+mcvpSatS4=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?FplZIfiQHNGdhafRiQJrNfXdVjGKgZzmbSSrX/+xxQPhifeWmpZUG2HMJcmk?=
 =?us-ascii?Q?oI1LRXAP1aOJOiPvuVsNmPFdPIZ69HRhgWmZX+InpCLT7Pj3kTl0Jv4qg6u5?=
 =?us-ascii?Q?OE1q/I19e7ziOCQW/lrG8+qBCGZpcF9Lz1RMsb32qRkwXQudWC0D+kOs/7xm?=
 =?us-ascii?Q?jXUolUt1RfZ2BFpBOM4M4IwAJOq/Mmj+bz71xat7HUFn4jzy+s95Gshl4Zag?=
 =?us-ascii?Q?Qf7rI6LtlJwcNNtOowYPqaeIggGdjwOHvBGn+xPptKhpIlOMt5A16A1CEQa7?=
 =?us-ascii?Q?5xxLXtKNPj8/zbjY8ySnLOSxcXABcI0jyEGsBvxOLrD2RsLwXe3ed0+HQ78f?=
 =?us-ascii?Q?ZFLzVxWEdjXworKY0YT/yTvcmCo6/WqXKZ9ZHrUVjHv4F7z3rYNQb73AHo2S?=
 =?us-ascii?Q?2CEMbxEfKetRmcBMQuiHVG0ivBNi7fTtHTam0hSy3sGCXvT0oi2gwdLouirL?=
 =?us-ascii?Q?QCgp2W7YhsuHmxqMCOa46rgmvC2+iXrIKpHfFzKuwX7X87fuXNGrw43Nl/h5?=
 =?us-ascii?Q?2N87O2X6K5sqe07NQaF2WtMUmi2f80axBgjw7aXmLhY2Gn/YHQ+CSWRAX5Sb?=
 =?us-ascii?Q?dBr6bt95QwJ+1Drl5pGZ8Jp8WQ1sQAFPbcCcTBrv7/JQBWKVyexayj7sHvnS?=
 =?us-ascii?Q?5dW0CsudTKaZF9zQ/ya0rejPk/LH+jFjXMu8DqFlS4kQBP5F3xLszV1wqZJf?=
 =?us-ascii?Q?dAbPMQLqnZ098U8Br1lyRqSIJ8hr43n07dYmVzIjur7mTwFTP+0zd5Yo+THW?=
 =?us-ascii?Q?RZqivqTyS5luCJrlANiggXH2ltxE0WiIJa0HXhexFWFpFKbdhZkzerzk0T5n?=
 =?us-ascii?Q?u/9WiNlgjU7hthBCFEn4P9RIhrH9UzDxxLTyt45Td3q57ji9FP6rXpbJiFC9?=
 =?us-ascii?Q?rwtHqFJSJPgIlCJO70qXwe+QpnQ1V+y0xW3w7vj77JK9wouPA8tfNvD3a94E?=
 =?us-ascii?Q?tDukJmo6w0FGpVWdvUbS5I1xvJw2yUNpnjvYVvitPWKvkwFYHw/WYL0tzlk3?=
 =?us-ascii?Q?cvnx9Fo7RW+yW116KUU0LWFNp+p9j7mICaplKWBGwIBXUYwsBNJ+ShcynSJn?=
 =?us-ascii?Q?ShK5VxW+CkU5Ni/LFdnVhB1UyYAzKlD76LiqvwpyFRksrOME1eE4r/TsvV5Z?=
 =?us-ascii?Q?SXmYHSpA1vZlHIl1Y016ArKv44gyfNO48kxe9B1Asx6O1hRfxfJIxJIdpFTC?=
 =?us-ascii?Q?dBCsrF15xo5x9Rt5TDFzyq96QusBwHlqA+xZmfrbo4MDvjibOXMPfZl0zIHP?=
 =?us-ascii?Q?XrBbtTidWpk1X/IWpWSebkS60SSGAMwC1R4cZDN6OpRJeicE5LNkoJYZCSPk?=
 =?us-ascii?Q?UkPzcs3TZubz+w0Pqq9di+s7x2hWVZJb6ioidFZOKV7PXVO44gDLvZVT/zrt?=
 =?us-ascii?Q?d7zlKa8+KizqhIk5kke6C6JEFDgW0hPlhrtQjNLurq6j/aGFtYhe12ehprk+?=
 =?us-ascii?Q?9CHSPP0e8X4qucM669fWPao9ZBFhPSKRRE5kqwQcxlfcpphvIBpgcBJl+lV0?=
 =?us-ascii?Q?mR/wD78ZyDjIwI74GbEFdbE9rO00XlMunAPzeovKSzZ0W545YTGNjB6Nomde?=
 =?us-ascii?Q?hvkL7A5yYwJvrb59k0J7sSOxjK3RYHAZoNVeZaLg?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 5634aadf-fe03-4545-cf69-08da77c6e6fd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 P2t5q+aycsUEEgdpHGPmTpFFotqbTW/tqoviY4AapKBf+f9+3Ca1ofvYNNXfgudPq9YfbyeEIZIkvdmbEgvMag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7278
X-ServerName: mail-am6eur05on2051.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: EibEeHM7kxn9atKqnRQl2GPAxJkHL9Ip
X-Proofpoint-GUID: EibEeHM7kxn9atKqnRQl2GPAxJkHL9Ip
Reporting-Meta:
 AAHeVumIdhwVqmf6eFTeNRFHrvApvtp8g91CehZ6SLGHdUlAxLYeXlc2J4ke0j6m
 H02Yx0CZtIpXZt0YK5wnyTg+izMYa4SVHLWnSri5l+kRTiDSMef7s55LhH1w8902
 cdNOilhyLPRbxbivE8VX5DBVyoIx0sod1p4M1gCsafanOdzZbilAnngyMjzMPKj6
 7WaZURIJfWz4LJDevMoGcl72Mjg3of2VnftEAfUOwVX0bkFEQ77JcjpQnsWD+okQ
 nhAl5mo9YAesg5PINE/cPVI9IPcz0bFTHlPhNphIrUGZrRV/ZVVgXx10AiMhRfzJ
 o4Iff8NUxmkQTKu1uoSKH22dPbfBKKha9HHCstWqQuLJ+HeSJeLMIP8y4UdMzpax
 xAGbsahxiREEH+yw1fKgqR4f5rfvBEOa1HeJgjfDtL9muJSZulg8BxghaNeKHCZf
 3hxp/sHLm5GwQPPs9drBBwNQ7vgWr9TUAIrCrvNScLN0gmaaeD666rmJyw7mlWCj
 wNW6IMigYsjixWnqmZJOANAdrc1q3ckjr7UH3ZWRgaAs

Hello Mark and Joseph,

(please ignore my previous reply mail)
I may met thunderbird bug, I clearly remembered I added you (Joseph) in
CC for this mail & previous mail. But I only see Mark and ocfs2-devel in the
receiver list.  and the mail format also mess, thunderbird replace '\n' to '\r\n'.

For fixing this problem, I change neomutt to resend these two mails

On Thu, Aug 04, 2022 at 04:53:12PM -0700, Mark Fasheh wrote:
> Hi Heming,
> 
> On Sun, Jul 31, 2022 at 6:02 PM heming.zhao@suse.com
> <heming.zhao@suse.com> wrote:
> >
> > Hello Mark,
> >
> > On 8/1/22 01:42, Mark Fasheh wrote:
> > > Hi Heming,
> > >
> > > On Fri, Jul 29, 2022 at 6:15 PM Heming Zhao via Ocfs2-devel
> > > <ocfs2-devel@oss.oracle.com> wrote:
> > >>
> > >> the key different between local mount and non-clustered mount:
> > >> local mount feature (tunefs.ocfs2 --fs-features=[no]local) can't do
> > >> convert job without ha stack. non-clustered mount feature can run
> > >> totally without ha stack.
> > >
> > > Can you please elaborate on this? Local mounts can run without a
> > > cluster stack so I don't see the difference there. We have
> >
> > I am using pacemaker cluster stack. In my env, the trouble of the converting between
> > local and clustered mounts are only happening on cluster stack.
> >
> > the non-clustered mount feature (Gang He commit: 912f655d78c5) gave ocfs2 the ability
> > to mount volume at any env (with/without cluster stack).
> > The 912f655d78c5 derived from SUSE customer complain: User wanted to fsck the backup
> > ocfs2 volume in non-clustered env. They wanted to access the volume quickly and didn't
> > want to take time/resource to set up HA stack. (by the way, pcmk stack at least needs
> > two nodes to set up a cluster.)
> 
> Ok. I had some time to look over the ext4 mmp patches. I feel like
> there are two questions here:
> 
> 1) Is MMP a useful feature for Ocfs2
> 
> My answer is yes absolutely, the user should have the option to enable
> this on local mounts.
> 

me too.

> 
> 2) Should we allow the user to bypass our cluster checks?
> 
> On this question I'm still a 'no'. I simply haven't seen enough
> evidence to warrant such a drastic change in policy. Allowing it via
> mount option too just feels extremely error-prone. I think we need to
> explore alternative avenues to help
> ing the user out here. As you noted in your followup, a single node
> config is entirely possible in pacemaker (I've run that config
> myself). Why not provide an easy way for the user to drop down to that
> sort of a config? I know that's kind
> of pushing responsibility for this to the cluster stack, but that's
> where it belongs in the first place.
> 

the reason for creating commit 912f655d78c5d4a is user didn't want to do
any set up job for cluster stack. So any HA solution (eg: automatically
config single node, auto install required software, create VM with already set
up HA stack, etc) is not remove the pain point. Base on bypass cluster setup,
there only left non-clustered mount. And in end user viewpoint, non-clustered
mount is also the most easy way to mount ocfs2 volume. 

> Another option might be an 'observer mode' mount, where the node
> participates in the cluster (and the file system locking) but purely
> in a read-only fashion.
> 

In my feeling, the 'observer mode' is just read-only mount, we don't need to
create it.
For 912f655d78c5d4a, user take a snapshot for ocfs2 volume, and do health-check

on a different env (not production env). there may belong to two different network. 

> 
> > > tunefs.ocfs2 look for and join the cluster so as to avoid corrupting
> > > users data - that's a feature, not a bug. So what I'm seeing here is
> > > just opening us to potential corruptions. Is there a specific use case
> > > here that you're trying to account for? Are you fixing a particular
> > > bug?
> > >
> >
> > Tunefs.ocfs2 still needs HA/dlm stack to protect joining action. commit 912f655d78c5
> > works on non-clustered env, which needs other tech (eg. MMP) to protect corrupting.
> 
> FWIW, I'm glad that we pulled commit 912f655d78c5 and I do not think
> we should go back to that paradigm.

If you or other maintainers prefer to pull out non-clustered mount, I respect
the decision.

> 
> 
> >  From my viewpoint, the non-clustered mount code is based on local mount code,
> > which gives more flexible than local mount. non-clustered mount uses unify mount
> > style align with clustered mount. I think users will like more to use non-clustered
> > mount than using tunefs.ocfs2 to change mount type.
> 
> Can we get rid of the mount option, and make mmp something that users
> can turn on for Ocfs2 local mounts? I don't recall if we make a slot
> map for local mounts or not but it wouldn't be difficult to add that.
> 

From tech side, it's possible to enable mmp in local mount.

Without 912f655d78c5d4a, local-mount uses slot 0 (the first available slot). 

> Btw, thank you very much for all of these patches, and also thank you
> for the very detailed test cases in your initial email. I'll try to
> give the actual code a review as well.
> 
> Thanks,
>   --Mark

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
