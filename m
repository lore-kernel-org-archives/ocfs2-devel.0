Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81E3C77B7F
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 May 2023 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NgRDu/C82NA0xFb94I9aPWQV5s8H2K49rwdO4wxlIDc=;
 b=Z3DJ/8KMpRfYksCx/taSxT1azxcMBaWg+PdBC+xqo0E97wDDWkxX+OSMrHYCZa9kkP5pXdk0WSXn
   Ap8+yyMCdDjuwbDarz1VlP+Qu+Ka0t0LwezSWsaes2YXfAnpWuPcQPHDBcOZNVS5ttLMeaZgIQUv
   oP9XDaO+Y7VPJ16v/uEMHUtzcXtqUH4iR//lQGd7Fyd2lCA0TXxeceoU0wLgKa6a8vdoe2iQmnBE
   De17nONDtzoHAg1pXoKb+lcptP3sFjlqLJ86BK/MZxgnIF9pbPyEy5TP4i9MK00tWj8N0ngskOrc
   wWZhqNrLU6r38AzMK8ADIbNtwdtAsaba6Ip9RQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NgRDu/C82NA0xFb94I9aPWQV5s8H2K49rwdO4wxlIDc=;
 b=WYDF5gJ1LFoaZNNVZXr5K+ViijWwdwt98+RxHo9TX6GLAi7WU2kNO09gUZHrVoWJzxF3PBezDPGf
   5iVBESTxYj2ll3VDykmGMkF7TvE2+N1Jpw4gkETrkfa5ArbSrBa2AT7ytzzFgHAJWGmsMQzqsMhJ
   xCfOnDE9h/qcsOwaTFhwzwttmh8w9mnDbEYEEksZ/ozqofUZuw/eaaboj44F+fPi9NF436pmtUXj
   J9Zix30degl0FSQXLxk6a6XD24B5litoYdzOk1s6YEKngi55BJnPjNFy8CldBs91Wp42txl8iwOI
   uidYGQe6clp7T6t5Xdv7cBGyDCXI2+0IazWqJA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RUC00CPBMCWJ4C0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 08 May 2023 16:41:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2NauDKZtNOwwmHy/ftlgP6p1uBzPSIbCMyvoxdtKVyFeCWEc2Q1uBeFrSXub7QGhG4e8KU/POrEU4UEoPS7Z4VyZlyLwqFZlvXhgiarEZFus1xMuwdmsTH59Iy7YCIMMKQmO/EBZc0KtcFfyy3/elo7o2TN5CcAv3htK63P5gzxD6IbCu3FfzwsCJdszFxRblDJbI47QFfflHnfU0juKZ+ryQ+OA+PdAuI0X9UR9wh9rWmjIqPUSv75XYoClxT7k/ngVCjngoHhQntgFifT1S6i/Tbggw+2mFZfPWz4+fjmuMI50u6A749JFtMkQEfhIV6KEhfwLFpzASmhJtSXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6dMHlmH6rqBv85IKyvE3JzwA0n7uEaCCmn5thaUjzs=;
 b=QBjAXxmC8+aVgOdNUa2LVrHg2gioXFhQC5fuaEchR7BiSmaHPt8LtDuVsHjdWt7dw3unKylVIlMHzOqnSndKfFQHMytRRFthtwdfsp3DTs3k90e26cuZTvwn0CMEFKX0BI8vx6z7rqDiWqWtZ10IWKVHQ0csyEJA5Yy37z++8bxxqImFtBuFZH6AYMEBgfQ5Nmk4JV4/zL+zMkF72bvBDTF9gTRQK9LT0sEssF5mdeLodR0hdjPFpxeI1BGFORSMHCpnsKAOYHh4mAUwPzMPaQ24chHJQ9l1faoEARfLx6MZyp2Kcyr1jbIME6EwQynENL3C1oplv5fizmsnSHftqg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6dMHlmH6rqBv85IKyvE3JzwA0n7uEaCCmn5thaUjzs=;
 b=Q4PrwMtqE+EMwI1WPSgv6Ig9lWmSB4FCw2bEgiMT7zs78lVQEGJrl78rdP8Z3L/vYgKSybH2Or2TbzMHcoj35ySp0RxVbN4Kn8h4Ivwd4oSXeWOccdljakQ267+XrC+qIemnV7NhIUqVoux5HV1xFctlzfCd3oxCRy8kqKktiUC9kw77ilf/BMO67NINxe+Unj2ZOa+WcQNv5K0JmPXK6311JHCmn8JjAEODNf0vo/VvUS5QViXualFVO642GR57TxfpbsDGq5RDbeHZxELiDpcrPaN7y09HMW+StQ244E3pshmh2KspeNTuRYtJQ291JPcR4tZ8mnpr3vKJtBLrJQ==
Date: Tue, 9 May 2023 00:40:30 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230508164030.twkuuqr5l2pubqek@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <20230430031302.15597-2-heming.zhao@suse.com>
 <5b3e7709-3a5e-d9bc-0e78-edc28b529d6e@linux.alibaba.com>
 <20230504062136.3d5x77fsms5kx6cs@c73>
 <0fbbae4d-4815-ddcc-9508-606416697508@linux.alibaba.com>
 <20230504080232.5a6suqn2hvtfz52b@c73>
 <faaed412-7577-ed61-bdb2-7751ced323d1@linux.alibaba.com>
 <20230504162022.jajkdgj2rgus2w3x@c73>
 <2b90546e-d23e-7d45-22dd-a887a73f3e61@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <2b90546e-d23e-7d45-22dd-a887a73f3e61@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(376002)(136003)(396003)(39850400004)(366004)(346002)(451199021)(2906002)(4001150100001)(41300700001)(8676002)(8936002)(316002)(44832011)(6666004)(4326008)(5660300002)(6916009)(66946007)(66476007)(66556008)(478600001)(966005)(6486002)(6512007)(6506007)(9686003)(53546011)(1076003)(26005)(186003)(33716001)(83380400001)(38100700002)(86362001); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 16:40:45.0335 (UTC)
X-Source-IP: 40.107.8.51
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10704
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 clxscore=181
 malwarescore=0 adultscore=0 mlxlogscore=999 priorityscore=172 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305080112 domainage_hfrom=9722
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
X-ClientProxiedBy: SG2PR01CA0178.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::34) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM7PR04MB7189:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fa8a04e-4f20-4624-cd5f-08db4fe2f80d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 4s2UOBPX/XuPc1+EEzKGsqPS8ZDQSLBxcf0A2xL/VuLShXaG5YAlNtiAAER04h4EAh/eFobb9+nzjUa8iu0F2wYcqYmavTucErFS7zzDwIttIFUp5FX8i/a4S77AT2U6HQ/L8/W/C8gKMQRTGut1oag/FxfgLde0vEZ0s52wi2kmCmdEInusu/UjFPhsFOjJkXlJfhkI5STYBi8nGcvEXtGun6NybnlDWUypGKQ/B4cmgLYJius399QSSs5nXDocEFbdzuwGlQiPWV2bGmX2XenONBKqPssg72tpfZ+RJoVGKGCIwSvnHCZf6FYDs9DzjXFpX07OIYb+SomF40eUKcawiqeY9HJ/lF1mBzHfyd1uHJM/0UYMnLXEnv+WWV4Fw2nrG8GGTrJfwayarS6Si0f5/Ue0Vc30vhfbUIAvv5C/pK7BNhMq2jeqP9Az6k6XZ/4WTIMTBLR6DlyBGpXPBAuCPGqnet6Xd8SXbbTgmo8VS9Tq5naRLyTG6x/O8Oi+sN30SlmHRLeInUTTdPrv/2t38q9J4CaDCkVwYdsEOpM=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?TJsVF/xV66zoYXy0ntRPl8cHa6NiCqzILYYAeyVtXTQkFnxEj+9QQdqVFlA1?=
 =?us-ascii?Q?BjmMeCI0mBy0S+TAdyLLNgs1fyAC2BQzqJEYoBIOjWRtTen450BR0KXW4AGB?=
 =?us-ascii?Q?6dwb86/ow6/M0PF+729rMUxXIEBdp0MYgKg+aiaavbhkQTZNtTAD346tiqdt?=
 =?us-ascii?Q?EE6x33Y+6S2Oos6X4w2Mdrytt/G2haebQsLc0lsHK17uYsVVtneN4XVhm7k2?=
 =?us-ascii?Q?FfuYvDJ8EfyoeZlooXfmVllBmHW1/W1yy1GG1fIDDggL2Rbjg7N73Zdid8HN?=
 =?us-ascii?Q?ou/tA8VsP6MoC361Z1BEyyoty2JJJJa2SrQdw8gQN+5XVKhI8DZUNzAgCB17?=
 =?us-ascii?Q?2qZUcudvyKWQADIvuAUZzTTWGnrjUuraBhmt9DjlvJUFjC4LpZ/YhMdcntgC?=
 =?us-ascii?Q?VnIrgbVLKMpCjFpxFtLuTuMlW0+bHZANUhz1hKZJE5I3LIrcsZM78aT2xnmg?=
 =?us-ascii?Q?kg+W5nPxvEi4NJpkcaT6Aq7DqjdjSoK6lJpIjgnq5N2Fcnol1EI2WhyZxE73?=
 =?us-ascii?Q?6icQ9iBuRDcHk31Lqeh51gxG+ct7KGQhhq3pjJdBNAdyi6bNJts3fIdn+D4L?=
 =?us-ascii?Q?iWiV/44EQUA4MXpjklKmPBnQ3i6ztuDhmvPhF8trXpzviLL1/GpNqjwCH8zB?=
 =?us-ascii?Q?tZyWxczfCmnJJBVbqhLUc6bRRHw8SUH3o8DEj8IPmPT1eGXdNzuWqy6UQltI?=
 =?us-ascii?Q?IPk0/JKgcH9S4iazJ7stMz9qHnQAbvQvq5J8LEngq538U+mQ3huLy3jTwKw+?=
 =?us-ascii?Q?oqV/hbCiVerr0QD93dMSclj+0H4YpNwnTvroLEDZs5ThylnGlut/n1vUbbp6?=
 =?us-ascii?Q?k7yLqum4YuADqAW8YTKoHoANSXlRR9myE3mthEEtz3p8DkeuJ7Dy6ILe4LsL?=
 =?us-ascii?Q?j6nu/rTgFKgCqCWXZc7spQdb/fxI/rJ2V+ts9YgRjVUiXLRqffoY8PF2Jbd6?=
 =?us-ascii?Q?Z1xxckiF4gapM2UyYN8PQ3p5LsW20KBRSFZuv8eF4UaqCzKd/NO/Qgmp2tEA?=
 =?us-ascii?Q?MnnCE+tcNUFEDPie6XQ8QlanUOkGHfMKFImU6PgU4Mi1KW2Alki+StKQjhpa?=
 =?us-ascii?Q?axHcCKTv6Qf3huUVV7v5dQQD9fMqBdDsa45UKeYphCAFdNJxvLGQcWYkS7Ht?=
 =?us-ascii?Q?ZNdziLtWwQKdm68GkHIEVghgC4XlsZtokTMs7k+WL2XQ9kAevrjvivF35noQ?=
 =?us-ascii?Q?btl/TvE6i18xpUHP2bH1azd2qdSZgQj3EmeIVNW2o3FmL7wb2BtxQY/tfl6I?=
 =?us-ascii?Q?IQ9HlJTYJMq+Fm5FlzFWd5JE2FuYlwIhxSS01aOiJ3A0o2VUBTpKZ5FvzUP8?=
 =?us-ascii?Q?kGHY04HxGNcCA/yt/xGT3oQk1Uzs9GHKCfUw07zidZklpoIIHK3o1Kd2ECBJ?=
 =?us-ascii?Q?PsqXD/RxFs2T1ngwRcaK4UIizP3/951heVPA/oNfBB3YZ1MCFsDmozeefDwd?=
 =?us-ascii?Q?Orrxi5JwXUkkZ51DhSpwMZsuHOVbbqXMHNo1SmfjafVjbiE0FkwfoLr75TF0?=
 =?us-ascii?Q?YcII75s6HskrImAnzQmZTWuays5+UJgLZCxED5ft9PO9W8ZWgT9r9MvdTREz?=
 =?us-ascii?Q?4IIPn0E2PbP47MM+r1Tjx7EJUtD15/PVwnqIvqCM?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 8fa8a04e-4f20-4624-cd5f-08db4fe2f80d
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 8agiyky9z7busc9YshDlgvSxw8KbyWnI9sTtI/AcliDysS7rytjgHBih53b3Admay6isbYHHR1616BFVoAS7YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7189
X-ServerName: mail-vi1eur04on2051.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: IArarLAifdRcvgBgyp9w8CJozH3Ec6Fm
X-Proofpoint-GUID: IArarLAifdRcvgBgyp9w8CJozH3Ec6Fm
Reporting-Meta:
 AAG8ADDveic6XXJr7MgsBDm05fe2qUR0eKGR8yCHx+G5rL53UKVuJT/ojfVXg46j
 VTsLe0AYYogFvGXwLsK7nKznsXH7Wu9elngtyeauizlHxmRJSij/WP5rWVSPo2At
 u/YgFuCItnEShntGljYNHEa3WFq6KwS49ofd1KvW5NS8iza4cM4k+VZG1/dsVpkA
 a3DkzGl/hWabWQnCaifvfbSKSPz14BSFpcGQevLL6X+QCPqE8lgXz2pQkia4SjbX
 y8pPlBohxtw8OUKxBRbX2cu+VvZbUQ6wN4Ya7gt9+TRXAf+A4ILWZXm41T9s97uM
 rOmogRLDyvOLkaOStfgIhgMrFwYy6yedVvGEXH/MkF6YvzdWpreINRmHcKjQ/UL+
 uaoJjiQRHlgEmI47TbKRGmn5wCBatVpqSrv8GvAjBjAVev/4RdmW7AaFuAp8F0jY
 d0QCjZotkbSjB5szkEzR9BzXaXODGj+M+MNXOWafdb/IQ0Olhz00Kuh75DHNm8D+
 TcMJ3ksXijk74cqslBFrBf2WoN2IeZ0QyFoZ/YGBQMn70w==

Sorry for reply late, I am a little bit busy recently.

On Fri, May 05, 2023 at 11:42:51AM +0800, Joseph Qi wrote:
> 
> 
> On 5/5/23 12:20 AM, Heming Zhao wrote:
> > On Thu, May 04, 2023 at 05:41:29PM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 5/4/23 4:02 PM, Heming Zhao wrote:
> >>> On Thu, May 04, 2023 at 03:34:49PM +0800, Joseph Qi wrote:
> >>>>
> >>>>
> >>>> On 5/4/23 2:21 PM, Heming Zhao wrote:
> >>>>> On Thu, May 04, 2023 at 10:27:46AM +0800, Joseph Qi wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 4/30/23 11:13 AM, Heming Zhao wrote:
> >>>>>>> fstest generic cases 347 361 628 629 trigger a same issue:
> >>>>>>> When jbd2 enter ABORT status, ocfs2 ignores it and keep going to commit
> >>>>>>> journal.
> >>>>>>
> >>>>>> What's the end user impact?
> >>>>>
> >>>>> There are two impacts:
> >>>>>
> >>>>> 1. this issue makes unmount command hanging.
> >>>>>
> >>>>> No one likes or accepts filesystem unmount failure when underlying devices meets
> >>>>> error. For comparison, other FSs (e.g. ext4, xfs, gfs2, ..) could do unmount
> >>>>> successfully.
> >>>>>
> >>>>
> >>>> So umount hang should be in the patch description, right?
> >>>
> >>> OK.
> >>>
> >>>>
> >>>>> 2. for developers to verify their patch doesn't make any regression.
> >>>>>
> >>>>> fstest is a famious & important fs testsuite.
> >>>>> (Yes, I know ocfs2 has itself testsuite ocfs2_test.)
> >>>>>
> >>>>> Current status, there are many test cases (about 9 in my env) cause fstest
> >>>>> hanging and blocking fstest to run. I did test for gfs2 on latest tumbleweed,
> >>>>> gfs2 only has 1 hanging case.
> >>>>>
> >>>>> In my view, ocfs2 developers or maintainers at least make ocfs2 to finish the
> >>>>> testsuite. Long-term target is to make ocfs2 to pass all the testsuite.
> >>>>>
> >>>>> On kernel 6.2.9-1, the fstest 'quick' test group result:
> >>>>> (the result based on my two patches [1/2] & [2/2])
> >>>>> ```
> >>>>> ./check -g quick -T -b -s ocfs2 -e generic/081 -e generic/648
> >>>>>
> >>>>> Failures: generic/003 generic/013 generic/015 generic/040 generic/041
> >>>>> generic/062 generic/082 generic/104 generic/107 generic/228 generic/244
> >>>>> generic/266 generic/272 generic/277 generic/281 generic/322 generic/329
> >>>>> generic/331 generic/336 generic/343 generic/376 generic/379 generic/380
> >>>>> generic/383 generic/384 generic/385 generic/386 generic/400 generic/410
> >>>>> generic/424 generic/441 generic/448 generic/449 generic/471 generic/479
> >>>>> generic/493 generic/495 generic/510 generic/537 generic/552 generic/563
> >>>>> generic/578 generic/594 generic/607 generic/620 generic/628 generic/630
> >>>>> generic/636 generic/702
> >>>>> Failed 49 of 568 tests
> >>>>> ```
> >>>>>
> >>>>>>
> >>>>>> JBD2_ABORT indicates a fatal error happens, either in jounral layer or
> >>>>>> filesystem. And we should not commit any further transactions.
> >>>>>> It seems that we may unify the behavior like:
> >>>>>>
> >>>>>> if (is_journal_aborted(journal))
> >>>>>> 	return -EROFS;
> >>>>>>
> >>>>>>
> >>>>> IIUC, do you mean add above code in ocfs2_commit_cache or in
> >>>>> ocfs2_commit_thread?
> >>>>
> >>>> Yes, break the loop in ocfs2_commit_thread() in case of journal abort.
> >>>> Actually we've handled this case before, but just limit the print. But
> >>>> it seems not enough now.
> >>>
> >>> I wrote in my previous mail. Follow your idea, The code should be:
> >>>
> >>> if (is_journal_aborted(journal)) {
> >>> 	ocfs2_error(osb->sb, "jbd2 status: ABORT.\n"); //this line is important.
> >>> 	return -EROFS;
> >>> }
> >>>
> >>> Only return -EROFS then break loop in ocfs2_commit_thread() is not enough.
> >>> Without ocfs2_error(), ocfs2 could accept new IOs from userspace, then the new
> >>> IOs will trigger IO error then trigger RO status. This flow is wrong, we should
> >>> mark RO as early as possible when JBD ABORT happens. In my view, the best place
> >>> is my [2/2] patch code which in ocfs2_commit_cache().
> >>>
> >>
> >> Agree, but ocfs2_abort() is more appropriate here, see
> >> ocfs2_start_trans(). But ocfs2_abort() may panic system, I'm afraid it
> >> has to change to read-only accordingly.
> > 
> > You are right. I ever used ocfs2_abort() then got panic. :)
> > So I changed to ocfs2_error(). I also sent two mails in 2023-4-30 (the first
> > mail has mess format by thunderbird). I copy the mail content here:
> > ```
> > More info for this patch, maybe I should write below info in commit log.
> > 
> > From the comment of __ocfs2_abort(), there is another way to handle
> > journal ABORT: panic.
> > And fstest generic test NO. 648 will trigger ocfs2_abort then make
> > kernel panic. I don't like the panic style, ocfs2 should elegantly
> > handle journal abnormal case.
> > ```
> > 
> > fstest NO. 648 could trigger ocfs2_abort from ocfs2_start_trans(). So you could
> > find my previous mail, I ran the fstest with parameter '-e generic/648', which
> > means fstest excludes NO. 648.
> > 
> > The only different between ocfs2_abort and ocfs2_error is set
> > OCFS2_MOUNT_ERRORS_PANIC, which could trigger panic. If you think panic is
> > brute, I suggest to use ocfs2_error.
> > 
> 
> Looked back the history, it is designed to panic in cluster mode:
> a2f2ddbf2baf ocfs2: __ocfs2_abort() should not enable panic for local mounts

About the panic action from ocfs2_abort(), in my view, it's too scared to
acceptable. I am not familar with o2cb stack, in pcmk stack, there is
resource-agents RA Filesystem[1], which includes two level to detect fs abormal:
- Filesystem_monitor_10 : read the device
- Filesystem_monitor_20 : write and read a status file

if ocfs2 enters abort status, Filesystem RA will detect it and trigger HA stack
to do the handover resources job.
if Filesystem RA doesn't apply monitor_[10|20] level, a readonly fs (not panic
then generate a coredump) could give administrator more info to locate the
rootcause.

I write above base on gfs2 fstest result: gfs2 doesn't panic for the ocfs2 panic
cases.

[1]:
https://github.com/ClusterLabs/resource-agents/blob/main/heartbeat/Filesystem

> 
> >>
> >>>> BTW, the basic rule here is, we don't want to change journal to prevent
> >>>> other nodes corrupting the filesystem.
> >>>
> >>> If my memory is correct, every node has itself special journal partition.
> >>> If the HA stack assigns the same (before fenced) nodeid to JBD ABORTed machine, 
> >>> No other node could corrupting the fs.
> >>>
> >> I don't think it's a good idea to modify journal even flush fails. Why
> >> not catch EROFS in commit thread and break? Now we can only expect
> >> umount continues with error, right?
> >>
> > 
> > With your idea, I spent more than two hours for coding & testing. The result is
> > my patch [2/2] is correct. Please believe my patch [2/2].
> > 
> 
> I am not arguing if your patch can pass the testcases above. I am
> talking about whether we do it this way is right.
> 
> Now journal flush actually fails since journal is abort, which means
> journal data are not reflected in filesystem. But after your change, it
> behaves like we've done a normal checkpoint.
> 
> Take the following scenario into consideration:
> N0 does some changes on file1, but now disk down and journal is abort,
> and checkpoint behaves successfully even it does nothing.
> N1 get the access right on file1 and does other changes, and checkpoint
> normally.
> N0 is crash, and N1 begins to recover N0, then data corruption happens.
> 
> I've fixed a similar issue in the past:
> 6f6a6fda2945 jbd2: fix ocfs2 corrupt when updating journal superblock fails
> 

I agree with above description. Thank you for pointing out my mistake, I forgot
the dlm layer callback for node-down case.

- Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
