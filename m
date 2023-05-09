Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 554C7C77B7C
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 May 2023 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FwS3iC1O1wMUw1j9VcsaVnXGcX5hlYJ33sPZaEeWPQQ=;
 b=vrbYcHvjbTDZJBjDNbNhySMBwfXeX3vNzJCCea/R2E0Wci0WkoV7VSQCWH4oJlTFkBckhRXvfdB0
   ybFagL0iPTr80a/jxNxYGdGDwbACejB2L0ZOkk7fObQk5Y9HUJhZ1Du3nmPQfxxWLzv6/pLe4t9Q
   URP49XYQ/8daKTayb5vI8EeaHiBl2lCpDM2IB0gaieWDRfTHI0kNNYy4J8jRm/gSR+xop7KF+U5+
   BYzoIGGFD5WV2CWiwMnpwqhg+t3tERjvQjjNSAXp6wVGtK1LlipLOrygIFWDrESjCoYZAJ01LWCK
   EOhy6CjKjtn/QyOKUcBy6tnHAqBagKQDNa6dOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FwS3iC1O1wMUw1j9VcsaVnXGcX5hlYJ33sPZaEeWPQQ=;
 b=buiUQAfjaaKIHlkNd1xODyYTky5DeP8Y7L6GSgW73Q4tiLwEo5jWYrcwW9eEYIvGsuw3Ih6x6lds
   T9THJraIaMo1sr8sBiZi6IC/VITKDtudAXfF29sSJOepOhOqDsdLBjPv6oB5+ztRysdzmUh5FdZ1
   +fPa8AOpT2nY9wCnjNDwB2DZoaILKDxsWz4+dzDjms0F7X1oplNHVsJCGPmlr494vL/XqvUUlhSs
   MBbfIgjQhu+J8PC0xHlOMVxZkEXPXxFLHFcGhEWjhF2gFi6xjIpdEixFMa2p2ekLgzu18FIN2o2x
   YKVDdG6X8IohGmCrU787wisZBVgc7ACXifoFMA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RUE00LQ4DEHKCC0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 09 May 2023 15:23:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOgjbt1rREn4R0WlxXrfxbNrZCu0LorIkNleG+7YAeDpb2XtwpBaJ7NqsIUB08uwHhBNzC/5YelvjtOh0pGc4PHFPMww9Fc2EXgYpBeDS/5AosVxbbrf5Q6uAAyYDI3mBzsojkxZrHujnIh9JgiBdP9sO0tzV6O68na9YYVcZPyPm7Krl0SJN3YDhB0LTetPdgQn/wVyMLszyf3PMDS5TamZTT536lOVHz7DmROBjAfj/XijhBWmEuBwZAaZFQNUXT6JJ9OqoeWoqV1kAlSMZZFYczF1Ke51tjzt/0cTo9C4IFuMoIPOKT1IDYkdpAKEbraUezlCXuHTPKaPC5Qthw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbTUcXC+xhPIdD6Qb6rjrOv9iPRV7XFgWg34y4gGJj0=;
 b=lFyIMxn46W7b/jiXosW0mgp5klHTgJLX3MiibGE2op5AUE9nK/y6mOGtNWRarAtHz1wlgNF7QfWX6qRaZH520pI7orNJhdrTW7oL8IKp8oqJP35l9se/jT8f/4l4pGY5GTnS/6us8YmThp7n4HnVekY85+DkDw0fI/Si1fumyyvDklOQQaIbiDT5HaZUy6zm8SPzbXLsh6wHXYrAOaZSHZToGWJsA3DI+C1VBoBLFtXb+5HJnviiJI0njSW1jnlDHT/B8d7mp1kWH8cghkKCEIs8DHmY0qZbuIWPVxKVtrn1ot9NfGFGq1O9ZiY/ZmfETu4PV4mRMrdPKmtjKHt8iw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbTUcXC+xhPIdD6Qb6rjrOv9iPRV7XFgWg34y4gGJj0=;
 b=CW52fhrfD0bqiJH1MKgHKfO0IQlEasGixfVExL97FaI3zV0h+bdS7ssE6K0Pdz8NCYUeM8YLTyVqaeVol3phbkzo79kHY+WFfhP5y1kxx0hroVemkrSMpuv5v8X0uzRlpSZIq0zZ8eTC9PIHxq35ZXTJfHEhXrkZf9L/WyYXCgEZVfSgqqXD7w71CDmY1mWXOqarfhTiGIv0Ni/s+U0Ciiom07R4EwwfeR8cUuYCbUoAbQb/UKv8y19jwztUWQdKHFRi08j7P4k4DndbJwvQOPj0LOwxPMmCA7NMn0VnZaUIU/eW2F75nk7w1ny1vLznql88aGD4bKWBkroyby+gAg==
Date: Tue, 9 May 2023 23:22:39 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230509152239.yfyoyjeewhqwss2p@c73>
References: <20230430031302.15597-2-heming.zhao@suse.com>
 <5b3e7709-3a5e-d9bc-0e78-edc28b529d6e@linux.alibaba.com>
 <20230504062136.3d5x77fsms5kx6cs@c73>
 <0fbbae4d-4815-ddcc-9508-606416697508@linux.alibaba.com>
 <20230504080232.5a6suqn2hvtfz52b@c73>
 <faaed412-7577-ed61-bdb2-7751ced323d1@linux.alibaba.com>
 <20230504162022.jajkdgj2rgus2w3x@c73>
 <2b90546e-d23e-7d45-22dd-a887a73f3e61@linux.alibaba.com>
 <20230508164030.twkuuqr5l2pubqek@c73>
 <a8f712c1-1256-2cc3-ddb9-14f35b0afcba@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <a8f712c1-1256-2cc3-ddb9-14f35b0afcba@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199021)(186003)(1076003)(2906002)(4001150100001)(53546011)(6512007)(9686003)(26005)(6506007)(38100700002)(83380400001)(316002)(41300700001)(6666004)(6916009)(4326008)(66556008)(6486002)(66476007)(66946007)(966005)(33716001)(86362001)(478600001)(5660300002)(8676002)(44832011)(8936002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 15:22:46.7196 (UTC)
X-Source-IP: 40.107.104.41
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10705
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 priorityscore=166 mlxscore=0 lowpriorityscore=0 bulkscore=0 clxscore=182
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305090126 domainage_hfrom=9723
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
X-ClientProxiedBy: SG2PR01CA0128.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::32) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|PAXPR04MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc4d012-1d02-4b12-c633-08db50a13e20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 S+KAXfS0SwJ9X3z0gLZMyiO8xZKd4abdtT08WRzlo2FW5q/tAnNeeRSx+6ZnWdN2UXz5ofYPIW+U2F8qmmgpNT59+KNXS4MZsiLZgP2U8HNy93HXha2NG9dc8qexp7YGji9dQVAryTkvq/r12G7L7hpiB6Yoo6DjigMRcWDxYn9tTWuEq+PSbKY6i66HnohalGqGClwZJmNEsR7unkhdTWk7i8+1rIbSbTNu5xz8RrcuoaUtv5Z2sifl2+pUx0Mlm51fMEN6D1QBZxP9IJ9rGk77Pfb9kfZJ7gOQFfBjWwDRL+vbmuvUAbRSerzJUs5bMLV6ErLR73q1e/NSwfXyvSSWjOfTgV7WiBpCvpLPAXKfro95LHX4pLj3RL9Wy9DAHMQgiMXsCuJPBlHMhFtFB4uMnhqjyO6JXieOmDUfSgZh+L/acmC5ZH4lpDQHjvNvocb8J8pgXhbZnAlA/8hb5IPt5As40DIX2gaAxjv2PHbdm8VLSyZ2zxP0QLT214Klj8CQSzx1biydh4V49f2bByyX+zVRZ36ItMQhOgzjqRU=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?qeJXnniCZu9Ag4FEYs0Jel6kDPVYHoWQNO5SfC3wZE3ITUEGRsjrsJAyYjxC?=
 =?us-ascii?Q?fnCmmHGKuMjXHAb+IU6JnVlw9t7batG1iJ189usdGsGlWOWgq5M/uotkfJCf?=
 =?us-ascii?Q?pvzLPpF4qxVxED/Nkcqlmk83feoaUSum4pDShxT7NKcXJefFXUCHQ0P+/j1p?=
 =?us-ascii?Q?LqMEyh2PLqjYQqaSlDJl8fIpPO9MF5JH/iasd2zTAXvqIIJh4LGEdTanZ5eZ?=
 =?us-ascii?Q?vEhVGNx1dOEvc0IXKjqK5Q5QC9M3cRSYULf967ooj4DVGkOzIsSLM7uFEK64?=
 =?us-ascii?Q?lvytK5SQEvac129TYAyWCg/7V0vlwOfX9XsbrJP8/4ny8uuqZirzfoNEamcb?=
 =?us-ascii?Q?kYrbFIYvpZtMDmCRpnZHFeTxY831SXUYyHplcYXcemjcWQ6BxNWYSWMTKYVL?=
 =?us-ascii?Q?UNua3qJ+XeZJ0eMAOkEpWILYibyjEMl0G3hJjJDqGavLCOIY9lN2Ooh5CHe/?=
 =?us-ascii?Q?meK0tiXNu4sJH/wg9rmRx1isU8LXTn4+H/4U2PaxQKZo7TT2PVuc+KHbIpe3?=
 =?us-ascii?Q?9g45j1Q9CNSRmKF1Ighcdv4YKpIvpGKwxX5I93+h/qWJ0A59iyyXdMBCLYGx?=
 =?us-ascii?Q?CbFi7Mlv7MZlI7i9DcB3lP+Dv5Nj7SsnUgOHLs7z/SSHxTYKDHrUj6m3+DNC?=
 =?us-ascii?Q?hGenkg8sg7i0wta0DzeY22dp7Kj4+b5l/Gx941YSBjYzdkIl+UjfMHdMgxtu?=
 =?us-ascii?Q?Anq7LEyXQwIZlevHO42tSZeYtMPO0zuz6qBL7EA5hxW9JUlFdKb7cDs9khiP?=
 =?us-ascii?Q?5iaHsMGWvzYf1F2W+k3tiTxEhoO7c0fLVpUs05+96+7xYbw57uEl2k3ZxO5Z?=
 =?us-ascii?Q?uFH5AtVBWpAX9LLIexB/H/6vA1UowLCWXg3XUqOT5NOZyyhBbFfETk63kA++?=
 =?us-ascii?Q?yXDOpenObyap7adr6e/uWxvpeSlN8vZ7g3XOjre6TejoC+UL1DXQCVxTZzrl?=
 =?us-ascii?Q?r/8u1G32xuvh++vl4cDj0GsR+v0ifTdxy7+Dnp9AQ+OScCl0TEkQqDqC9vWS?=
 =?us-ascii?Q?pPTryzg4Bc77nailt+kIZB6kSgruNXpyfNWmgZSaj5aHSRV6MZoTkDxT3W9m?=
 =?us-ascii?Q?pwWVR5OVltRLuP1rrxZ80Opse5l+zuwOrFHkBhWapAgtbGFhg8TE+AmZGYpE?=
 =?us-ascii?Q?e8vdtd6nqiATGpYkF8qjFr4o+Pz3K6q85xWkn6nTjTG2rH6ghCS9MzDYHCI9?=
 =?us-ascii?Q?h9OQZ15GRlzKrqvLAksDLJho+KzASY2zXu9WLJGwM0718sSf44zD2n28qmPv?=
 =?us-ascii?Q?YSOBXgthZm9haPCkjaCb2s2HgrfFdbXyMryZumdLGXNlu6IX3Mwp1/M5iR+q?=
 =?us-ascii?Q?QTIlixmPv5YC0u0pLuaUfYpbC2ItXLiWu526Ee5AZCenOwjyz2tid8p38W6l?=
 =?us-ascii?Q?atFXJtlLzr3us1vjtw0lIAI7amzfJQdGAXgmJgKDXFw/k5y9gFEtE8UXf89S?=
 =?us-ascii?Q?NVGV536k7RUrkAcdKIMracrG9ZuoKfYqtayGAI42VsfIHXYP9ZyBgl0xf7kx?=
 =?us-ascii?Q?8QFhwh1ZMI3tZ7IX/B3XzA+9gAs9L1U8iZcJz+CkbqWJWd86/6T0t9Uo+EDD?=
 =?us-ascii?Q?yyUeYordjMAcyy2D4+RA1bQtMdFjId/A0cIQ4/2x?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 dbc4d012-1d02-4b12-c633-08db50a13e20
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 IoTKR8HD7Pxb9BLji9gsJ1G0BB9wOUu/Lf9nQK3HYOifld3at8LlnGoD9kRIjSVJSRU7M/2d3ZMsmkeVtHNgAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8749
X-ServerName: mail-dbaeur03on2041.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: oG-bHxyGZ1Y_oy0PFWqz7NBq1zh2LGy9
X-Proofpoint-ORIG-GUID: oG-bHxyGZ1Y_oy0PFWqz7NBq1zh2LGy9
Reporting-Meta:
 AAGwZnSgse1mt4VIOg2C6eJdtpzgAgOqtWHU2QiFx23lRpG0MGs1JDOP2m3eYuvm
 QioR70SMwItFwYgU5fFafyuWjKjh/cyz3tJcbubIM85yvt/32oDqNM9gtGMRTUz8
 7jowvTVYPXtZ9uAhX4U40yY6GXV/XkriMA7JoDly9zAuUJW+MF21kM9/j4scZF9o
 NO0V+OzHcKLR1hv9FRh2ClX8xj8bI5/b1Dci11XFjax7k23AHf8YsaAwUA4h0jff
 nhr/u1JTPImnfTgK9KDCP3o/QazOYVr95ZbRKBUd9hYj0ENHVb1GF3HqxwGQnfsb
 H3uzO4eGyaavN11VFyszb4uUOCOk4yywMIe74YfrVmkkJnoLM0cLfBtqtUni9RPx
 ARH0CtrhvDjpQhZyVhLo6XTQG88JhwlG223JTpmEb39V2UsEAcyIGMjm4n6wLzqS
 T0RX/TVE5VxsoSD9NV9UlTkePgIVah6aEhGDN+20QoYA/IJlyuTEpIF1q4b9WqZJ
 kVBBLz6hS8HdpOU4TTBq2IW0CyXq3iKNk8mtx+LgwQY=

On Tue, May 09, 2023 at 09:53:06AM +0800, Joseph Qi wrote:
> 
> 
> On 5/9/23 12:40 AM, Heming Zhao wrote:
> > Sorry for reply late, I am a little bit busy recently.
> > 
> > On Fri, May 05, 2023 at 11:42:51AM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 5/5/23 12:20 AM, Heming Zhao wrote:
> >>> On Thu, May 04, 2023 at 05:41:29PM +0800, Joseph Qi wrote:
> >>>>
> >>>>
> >>>> On 5/4/23 4:02 PM, Heming Zhao wrote:
> >>>>> On Thu, May 04, 2023 at 03:34:49PM +0800, Joseph Qi wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 5/4/23 2:21 PM, Heming Zhao wrote:
> >>>>>>> On Thu, May 04, 2023 at 10:27:46AM +0800, Joseph Qi wrote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> On 4/30/23 11:13 AM, Heming Zhao wrote:
> >>>>>>>>> fstest generic cases 347 361 628 629 trigger a same issue:
> >>>>>>>>> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> >>>>>>>>> journal.
> >>>>>>>>
> >>>>>>>> What's the end user impact?
> >>>>>>>
> >>>>>>> There are two impacts:
> >>>>>>>
> >>>>>>> 1. this issue makes unmount command hanging.
> >>>>>>>
> >>>>>>> No one likes or accepts filesystem unmount failure when underlying devices meets
> >>>>>>> error. For comparison, other FSs (e.g. ext4, xfs, gfs2, ..) could do unmount
> >>>>>>> successfully.
> >>>>>>>
> >>>>>>
> >>>>>> So umount hang should be in the patch description, right?
> >>>>>
> >>>>> OK.
> >>>>>
> >>>>>>
> >>>>>>> 2. for developers to verify their patch doesn't make any regression.
> >>>>>>>
> >>>>>>> fstest is a famious & important fs testsuite.
> >>>>>>> (Yes, I know ocfs2 has itself testsuite ocfs2_test.)
> >>>>>>>
> >>>>>>> Current status, there are many test cases (about 9 in my env) cause fstest
> >>>>>>> hanging and blocking fstest to run. I did test for gfs2 on latest tumbleweed,
> >>>>>>> gfs2 only has 1 hanging case.
> >>>>>>>
> >>>>>>> In my view, ocfs2 developers or maintainers at least make ocfs2 to finish the
> >>>>>>> testsuite. Long-term target is to make ocfs2 to pass all the testsuite.
> >>>>>>>
> >>>>>>> On kernel 6.2.9-1, the fstest 'quick' test group result:
> >>>>>>> (the result based on my two patches [1/2] & [2/2])
> >>>>>>> ```
> >>>>>>> ./check -g quick -T -b -s ocfs2 -e generic/081 -e generic/648
> >>>>>>>
> >>>>>>> Failures: generic/003 generic/013 generic/015 generic/040 generic/041
> >>>>>>> generic/062 generic/082 generic/104 generic/107 generic/228 generic/244
> >>>>>>> generic/266 generic/272 generic/277 generic/281 generic/322 generic/329
> >>>>>>> generic/331 generic/336 generic/343 generic/376 generic/379 generic/380
> >>>>>>> generic/383 generic/384 generic/385 generic/386 generic/400 generic/410
> >>>>>>> generic/424 generic/441 generic/448 generic/449 generic/471 generic/479
> >>>>>>> generic/493 generic/495 generic/510 generic/537 generic/552 generic/563
> >>>>>>> generic/578 generic/594 generic/607 generic/620 generic/628 generic/630
> >>>>>>> generic/636 generic/702
> >>>>>>> Failed 49 of 568 tests
> >>>>>>> ```
> >>>>>>>
> >>>>>>>>
> >>>>>>>> JBD2_ABORT indicates a fatal error happens, either in jounral layer or
> >>>>>>>> filesystem. And we should not commit any further transactions.
> >>>>>>>> It seems that we may unify the behavior like:
> >>>>>>>>
> >>>>>>>> if (is_journal_aborted(journal))
> >>>>>>>> 	return -EROFS;
> >>>>>>>>
> >>>>>>>>
> >>>>>>> IIUC, do you mean add above code in ocfs2_commit_cache or in
> >>>>>>> ocfs2_commit_thread?
> >>>>>>
> >>>>>> Yes, break the loop in ocfs2_commit_thread() in case of journal abort.
> >>>>>> Actually we've handled this case before, but just limit the print. But
> >>>>>> it seems not enough now.
> >>>>>
> >>>>> I wrote in my previous mail. Follow your idea, The code should be:
> >>>>>
> >>>>> if (is_journal_aborted(journal)) {
> >>>>> 	ocfs2_error(osb->sb, "jbd2 status: ABORT.\n"); //this line is important.
> >>>>> 	return -EROFS;
> >>>>> }
> >>>>>
> >>>>> Only return -EROFS then break loop in ocfs2_commit_thread() is not enough.
> >>>>> Without ocfs2_error(), ocfs2 could accept new IOs from userspace, then the new
> >>>>> IOs will trigger IO error then trigger RO status. This flow is wrong, we should
> >>>>> mark RO as early as possible when JBD ABORT happens. In my view, the best place
> >>>>> is my [2/2] patch code which in ocfs2_commit_cache().
> >>>>>
> >>>>
> >>>> Agree, but ocfs2_abort() is more appropriate here, see
> >>>> ocfs2_start_trans(). But ocfs2_abort() may panic system, I'm afraid it
> >>>> has to change to read-only accordingly.
> >>>
> >>> You are right. I ever used ocfs2_abort() then got panic. :)
> >>> So I changed to ocfs2_error(). I also sent two mails in 2023-4-30 (the first
> >>> mail has mess format by thunderbird). I copy the mail content here:
> >>> ```
> >>> More info for this patch, maybe I should write below info in commit log.
> >>>
> >>> From the comment of __ocfs2_abort(), there is another way to handle
> >>> journal ABORT: panic.
> >>> And fstest generic test NO. 648 will trigger ocfs2_abort then make
> >>> kernel panic. I don't like the panic style, ocfs2 should elegantly
> >>> handle journal abnormal case.
> >>> ```
> >>>
> >>> fstest NO. 648 could trigger ocfs2_abort from ocfs2_start_trans(). So you could
> >>> find my previous mail, I ran the fstest with parameter '-e generic/648', which
> >>> means fstest excludes NO. 648.
> >>>
> >>> The only different between ocfs2_abort and ocfs2_error is set
> >>> OCFS2_MOUNT_ERRORS_PANIC, which could trigger panic. If you think panic is
> >>> brute, I suggest to use ocfs2_error.
> >>>
> >>
> >> Looked back the history, it is designed to panic in cluster mode:
> >> a2f2ddbf2baf ocfs2: __ocfs2_abort() should not enable panic for local mounts
> > 
> > About the panic action from ocfs2_abort(), in my view, it's too scared to
> > acceptable. I am not familar with o2cb stack, in pcmk stack, there is
> > resource-agents RA Filesystem[1], which includes two level to detect fs abormal:
> > - Filesystem_monitor_10 : read the device
> > - Filesystem_monitor_20 : write and read a status file
> > 
> > if ocfs2 enters abort status, Filesystem RA will detect it and trigger HA stack
> > to do the handover resources job.
> > if Filesystem RA doesn't apply monitor_[10|20] level, a readonly fs (not panic
> > then generate a coredump) could give administrator more info to locate the
> > rootcause.
> > 
> > I write above base on gfs2 fstest result: gfs2 doesn't panic for the ocfs2 panic
> > cases.
> > 
> > [1]:
> > https://github.com/ClusterLabs/resource-agents/blob/main/heartbeat/Filesystem
> > 
> 
> Agree, so a more elegant way is to make the journal abort node behaves
> like node down, e.g. set hard readonly so that heartbeat also can not
> update normally.
> 
> In xfstests, it uses device mapper to simulate disk down, so it will
> also trigger node down recover since heartbeat won't update normally?

I am not familiar with hearbeat. Base on current code, in pcmk stack,
your description is partly right. (see my answer in below. node may be hanging
forever)
> 
> Also, I'm not sure pcmk supports fence other node by only rejecting IOs.
> The built-in ocfs2 fence policy only supports fence self through panic
> or reset.
> 

Yes, pcmk supports fence another node.

SUSE HA stack pcmk (crmsh + corosync + pacemaker + stonith) is powerful and
enterprise-class software solution, which usually deploys on SAP environment.
For rejecting IOs or jbd2 aborted, Filesystem RA (see above [1]) could use 
monitor_[10|20] (OCF_CHECK_LEVEL) to enable detecting IOs error. If customer
doesn't config OCF_CHECK_LEVEL, and the storage stack: disk => dlm+ocfs2, these
will be hanging forever. 

But, for a typical user case for SUSE customer:
disks => mpath => lvm2 (dlm/lvmlockd) => ocfs2
pcmk stack could monitor layer: dlm lvm2 lvmlockd ocfs2. anyone enters abnormal
status, there will trigger fence action.

- Heming

> >>>>
> >>>>>> BTW, the basic rule here is, we don't want to change journal to prevent
> >>>>>> other nodes corrupting the filesystem.
> >>>>>
> >>>>> If my memory is correct, every node has itself special journal partition.
> >>>>> If the HA stack assigns the same (before fenced) nodeid to JBD ABORTed machine, 
> >>>>> No other node could corrupting the fs.
> >>>>>
> >>>> I don't think it's a good idea to modify journal even flush fails. Why
> >>>> not catch EROFS in commit thread and break? Now we can only expect
> >>>> umount continues with error, right?
> >>>>
> >>>
> >>> With your idea, I spent more than two hours for coding & testing. The result is
> >>> my patch [2/2] is correct. Please believe my patch [2/2].
> >>>
> >>
> >> I am not arguing if your patch can pass the testcases above. I am
> >> talking about whether we do it this way is right.
> >>
> >> Now journal flush actually fails since journal is abort, which means
> >> journal data are not reflected in filesystem. But after your change, it
> >> behaves like we've done a normal checkpoint.
> >>
> >> Take the following scenario into consideration:
> >> N0 does some changes on file1, but now disk down and journal is abort,
> >> and checkpoint behaves successfully even it does nothing.
> >> N1 get the access right on file1 and does other changes, and checkpoint
> >> normally.
> >> N0 is crash, and N1 begins to recover N0, then data corruption happens.
> >>
> >> I've fixed a similar issue in the past:
> >> 6f6a6fda2945 jbd2: fix ocfs2 corrupt when updating journal superblock fails
> >>
> > 
> > I agree with above description. Thank you for pointing out my mistake, I forgot
> > the dlm layer callback for node-down case.
> > 
> > - Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
