Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9B7C77B73
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 May 2023 03:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hZDtd9/aR7tk4ZSpcui5gonVd6+zQ+vDukriw36Tt+k=;
 b=wsE8htk3UGxv9qugg5kON8AEkhee96/TvJ7qYt68thh/6tbNWzqcKPn4rwvdNhXAdJhEON7GWN4i
   uEEm+o+Jx97oNAFa/LOmIY5tEiBJhR6YyMhh7Xq6eUczasN98eJDzSPwaLTZVWa7k7141Dts1eeO
   fvFlAXd4waih/x5YMVw24lEU1vC9fZdclkGn25kaNW/Oyd59xLPiYqJ1CR/j2+jTTTnmmk3UJgRK
   FCPpaQhBgZnG5v08BouVl0pi2c0455+Xpq6gw16g/nJgv7pewAmgX79sO7rOZ17xAnqTi/GmN2ZA
   ekKjkRo3hLNlprtD4WKQqCmPgr+gWuAckrt3bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hZDtd9/aR7tk4ZSpcui5gonVd6+zQ+vDukriw36Tt+k=;
 b=FCJKJyvNT2jjVEI4ehH5BnuuQ/DNekG4MbolALtTyayi+4k2PO5bl2xiPdQdeYHs5HHrRM55/jUs
   YsqSN4ssexkUqatClbIL5eLYPC7Tn3khEQBqMYjSPL2Z5UiXC+oUP2me7gEIvBBllKX5tsaUHGAZ
   XQR8E2CnARut1HElKbUKMtglfMg/XfJxwCGXtfWSl4RF+vQnxYX41hg+TOVff6bwGokS71ZK2/ZW
   5e1QnzpG1NUlw3zK2Fex8/ybZyR6saBqd4P03w+XheR/ita4L+8JR168bwfoykvAeTGLDJ3T7kGj
   Z0DaC5K9fpjseY5CKHxXZiMx/Rb8vRlMGAx/Bg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RU0008NUICOGG50@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 02 May 2023 03:43:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbXzR100eo8qk35OxQFFSSpFngr+MWmOcp6Y7JSEYQZI2ZNrqpujnLPuX23BAcIw/eZADJUtd1R68uHNUOZmcPMckAnlcnIU4wpyRcfBjkS+v1DhV44i6Fe863Kxl4VoH9Whg43ApSKxv35oUROBNmv1pGVCJJsGSGKQbnNSwEq7RXbqDkPnT/GnAP99in83f0OqVpnQ5YY4T7BhoKA1l0xwnH8HUNlk3cT4eoQm1CZOVVVNfPBwxDAs4na9mC7F3uJHHrZlLWvXxc1kiXb3geWrUFlo9vpuiW4za7FCeIZHg0r5GhlwT60oWUZbew4H4+J/8TutAN4Cqbo9zPrMtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HDJLJQO0xkGm2mIUHxq1RN54NVdLI90dlltxJvGHU8I=;
 b=Ng6ONQoJf8W+ZcyzeJPEvLGUvHr7j4TpHt4aZ0z9fPOD3Gl5KMooLfFIXk5asfGo7yGVtiDSAqMXHump9We6+ao2rDuazEjGseZroaPPVIYiTpGICCXwONCZk6mN47JWyYIyXGx1gBgnsz26i3kh5NlBHh0OOcEY0IGYNbi9Cbmi4wjUz+Vkm8maYJRKFlCuqXfFnsCNkypd0rcY9Jzea0FVanOKuo8wOh/joLZAScPl5AZyX+w3hWI9MEuZ8LOPE5Rs/cJPtzGjOIBjGPCUPozKvL1ieNGoRMVLvlVpflpD0Yb2Zm+NPb81w6Z13uNjttFPrXGQXhDBpMNgXZ2jJw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDJLJQO0xkGm2mIUHxq1RN54NVdLI90dlltxJvGHU8I=;
 b=o1PK/uW1Lfc+soA5xE+jqqdKt2h5hv3fStGnlUJy097B3RGuVtTbmlCcOWCUQLFSuvIZZjXEPoOOnNoqlwhrWmls5gCVMHrZfmI8k1Nnae051Z6KMYTbpCl4qdYxCV1kQLWj1EArfq5rlJ00rMYqOaaWSeqIWhvLGhZn53eVaXwP29yEvqWMqXjRtokXVCNFAph/dUP92nQEigS15hSYhHM/KG/x18bWrBCwM8ztABFj/5qqT/Nw4uiZLFL1bTE+CbPBo4rforMZ8f/v7jM9Rhrd/863OjY5e+0i2zExbQc3aYhXcQbMUB5HwW6Zl3qVNXJAtuDm/r6fCg8fMeNV2Q==
Date: Tue, 2 May 2023 11:43:08 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230502034308.w7kbfc2pyu3urv3r@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
 <20230501022628.avrcx3exv3nev3fl@c73>
 <d9d1fc18-39d8-2888-c540-faac2d3f5628@linux.alibaba.com>
 <20230501030958.ps6xssjcvu6pnpnl@c73>
 <2254db82-10cc-50a7-6cb9-5344e294a3eb@linux.alibaba.com>
 <20230501045153.h5co2zn66q2unlsw@c73>
 <b395014f-4096-4471-f2ea-c6e7de6f59a8@linux.alibaba.com>
 <20230501123557.5ug5vn5chmzbgenr@c73>
 <ecfd5772-b073-af9a-910a-618f93cf1643@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <ecfd5772-b073-af9a-910a-618f93cf1643@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(366004)(136003)(396003)(346002)(39850400004)(376002)(451199021)(38100700002)(44832011)(2906002)(30864003)(5660300002)(316002)(86362001)(8676002)(8936002)(66476007)(66946007)(66556008)(41300700001)(6916009)(4326008)(83380400001)(186003)(9686003)(6512007)(6506007)(1076003)(26005)(53546011)(33716001)(6486002)(478600001)(6666004);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 03:43:15.9305 (UTC)
X-Source-IP: 40.107.22.56
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10697
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=115 clxscore=187 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020030 domainage_hfrom=9716
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix missing reset j_num_trans	for
 sync
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
X-ClientProxiedBy: SG2PR01CA0127.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::31) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM7PR04MB7160:EE_
X-MS-Office365-Filtering-Correlation-Id: 806df128-0b0d-495c-8ead-08db4abf5cad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 fVR5SvA5RpEkzp0pimsvZ52HAc+Uly4hcvuWmCPM5EuUePUwy7PC0FEnom2kn95SZms0OHOSA8+98OKvMTZz6sSQaw4LDaWwIAj7lXxAnPK2CBZ9YK968hXulRa9FuUYcOHf9Ql6xhwzqFuoJnKbPn6vo/MsYlzrXo4GN0QVDW3xNruOlIbj8oGzDbpuU/IWu6GRp7q9K4YoENQ72CW+QkrYjY9rg4spNcmEGccDBVMcB63Q03IFj/0e0AsyXU1/6k9xycA3ASVl8oo3WkgSMygvgWvjSHcs84zJFv42ReALH2LbuNU8Bmk2UqLjT658T2Q9h9mIw4AuX/zw5lbz41TAoAQACGgUvOaUx7DkXv01zyTLAdF12JC+CQZ/ohn9Ip81oG90fC6XGwlR7v9G2WpvD8SDvZJ9+btgpiGdRadKp1Mta6y7L7QbQ2+14ObrvPYsoUXjL0TjJ2lIbnizT8xtYWk5BWw7NtVV8MRUX5uX9BY75EODFFzDINv7tWu61O2M2cBMhgvpTObZ2DOtTADHo1R1mDYjPcchFgRYlV0Cex40VNEOjywTXuS98tc9
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?zZXM0VW4shCbZOHaTlHq9MOim6zWnWVh6NRbAWIyQFS8+XkvaibdpabneaUK?=
 =?us-ascii?Q?ChM3g1st/OFr4a6qG34hZsIVFcWFVts+M7Fai/Jj0WFfXn+dLtT/YMAiUGlp?=
 =?us-ascii?Q?tojVIZH9JrjNngYu+hWpNXl2Fp1idJ+VVg9t05xFi1IRObm9u42i5x27nlPy?=
 =?us-ascii?Q?6aVhWqliKmRi+1zs0GInsyyTBSrp8QZyKjh8tXnCGqlVJJvY977Tv7GeC+xj?=
 =?us-ascii?Q?kcnzvbVHBBqeo3nS9jwbA/abDMx10nwsBZpPZjM3MnxwNFXowZmeRvSz056w?=
 =?us-ascii?Q?iZXxoJ2VK3EcQCtGZnENOthqlFYktJ8fABQZ2dJFS7G+jDNIrSqxFYahMb6k?=
 =?us-ascii?Q?4Dqf+U9/enQzlQGBlyJN6RuTVmv4MZUK0Tkb7FCVjyInjfRpIhYFeDVbmgv5?=
 =?us-ascii?Q?pJz22xe7WzXKt9MADND4PsCa7CifS+zQs7yNj3LjAQJb1p5XIa9/jvyptt1H?=
 =?us-ascii?Q?0UPoNKOv+/mmbslW8nxfqQR0MwJb5HadbgJEx/dRIufsJrMi6MpeDc0hDDsM?=
 =?us-ascii?Q?wTx/nwWu824iRIITDNkonIVeKpWlE7xwtCqBmRbdG4eHfbLVcb4xPrKGeWaP?=
 =?us-ascii?Q?GiTlKMAkWrK+n0k8YHMBCTVkJiv6faTxuOesA+CVTpGcPV3Af6Om7nhfUJxj?=
 =?us-ascii?Q?KsCaHIE/aVY4vc4nYheDl1LDIVjIpK4se2vXLrTHB+1z/YEuyIS+7SJyKABF?=
 =?us-ascii?Q?tcD8OuOxzfOveUCxklka49kMo/GUtZFNWHCoyeytIAX74EEbmCWW35lGrQ4V?=
 =?us-ascii?Q?M8Yv+kyJRIZxr71+bIZIx7Bfnld+MSr1Rew6MK1dk7msmWN9/XcqyGTd/nlI?=
 =?us-ascii?Q?/6/bP565Wq7DzW7CEqaNIUIaw+Y/4JtuhT0jEOxiPz3zVL94/9h3fbGxvYvf?=
 =?us-ascii?Q?LT8iAwPyskaraRDdInKsa662VGcl2YKRwiSHcG9YzrKXYCOjUBx4Ox+57BoI?=
 =?us-ascii?Q?60Qt0mwgnQpAAI8azO2NK+8ztEFjHcMaYWYWFf06U4TTFuieyRg/0n9NgQWF?=
 =?us-ascii?Q?EhVtq0lMnyA3WJnDgvaoDVKDZuiSjcfOKiwqw6pSkCJWJZTYO1bzTOTWeNG/?=
 =?us-ascii?Q?B14+rH82zbipVY1V4hDglqB7x6ogx7Tk8gE+eqBk1xMnhUosXNt1Lehjr3Q7?=
 =?us-ascii?Q?JBFD/OWjJzYEThRmL113675W+Fsp+4nCm3GFUCY1UGVd00rDR5BcfaWECphP?=
 =?us-ascii?Q?PUO1tHQeOHThSnodKMWom1A3wCu3QfUcKYTSePRRlO+ITK6mmrChaEWOvssX?=
 =?us-ascii?Q?JFoxsumLHqjUZfVkrUSZ2srP7NR4FIOGBqdEdAlxKfMAC+p6nbuhtP9+fe8q?=
 =?us-ascii?Q?J4HvqjX8t4HbkgzbAbI2d0rc5pH/nUl9Hlnw9CuL7vITWVwBQbXhcUWZI3Qk?=
 =?us-ascii?Q?ooUd+xzehmmGoy5YmI4GLoCea4sCLi2wd09diykQE2DyDZqgfSPUuKwFJxmn?=
 =?us-ascii?Q?sBBq0Ei1FcQ9sWId/7oR7BBDKceU5a7yvOBwuR8WxiGp15890jspD30q1pEU?=
 =?us-ascii?Q?imtPT0qdsbP4bKH/rnpCPEUw212wVuxF7MjPRu/HJwegkz3HRU01DBdLZDoE?=
 =?us-ascii?Q?1g0M4sx0T2gd5tiGaF5fNz8wIfmCxtgUaYaoKCFP?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 806df128-0b0d-495c-8ead-08db4abf5cad
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 wWgmTb32N7gXeSrh2Dt04zTNWakMDZ4i+1I5pJg/DinT2r4Ig7rKaab/xzHkyUhYSriYku3WaUIKpB8RZGXHXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7160
X-ServerName: mail-am6eur05on2056.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: UGn247uW6LIdWzgwf44ISVRyw17uW2Dw
X-Proofpoint-ORIG-GUID: UGn247uW6LIdWzgwf44ISVRyw17uW2Dw
Reporting-Meta:
 AAGPqnnhmQSyrRIr+ZMVz5hCB8ftcd2CKYUALf4EaM3O6LJEaj8ZElctnqGWJRhH
 mATOvsFRcqoqVUu5mF/eyE2UL6GVdyRTer78dLqfdy4R/gA4tsamr5VYucUXxBYn
 +hY7RdvxCMaMeGaL9tg6NZnI4NOYI6u4x84eOgyDW4cmDhFe+Yl0hZ+kv7PR4zJJ
 YJ8vddIPc7TwgMTR/ehnRuiXLhJf3Ka/fAqv9ghCtCnf+XKsUCYWOLcf/pEYb/Y6
 WrNoeeg3bY6b77fPYGP24fvbLfVQ2Sogu7Mux/IBsC3iw8+azO1kV3jFimehWif+
 umqjjGUSIiAvoKhtPWyeQ+078cvUH6DE6zPXDWd0ttYppHZtsugBreOdDjtGgYcr
 az4ipBVww6Ml0HCoVs0kHHSgdr5qBacLto1RHvtmPsK6TMpi9jHxzKhfwfrS2znZ
 rQLLiEbsmy0xAzYmgHEHjTy9jDMilORkZYXIE5X2Ng++bMmeVHX30cPG/GWgUYoC
 CEIGxVxo0dAv6iTmp1hP7Xxj+bsKJTt8yjPrsU4mFiD1hA==

On Tue, May 02, 2023 at 08:29:36AM +0800, Joseph Qi wrote:
> 
> 
> On 5/1/23 8:35 PM, Heming Zhao wrote:
> > On Mon, May 01, 2023 at 07:44:42PM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 5/1/23 12:51 PM, Heming Zhao wrote:
> >>> On Mon, May 01, 2023 at 11:21:15AM +0800, Joseph Qi wrote:
> >>>>
> >>>>
> >>>> On 5/1/23 11:09 AM, Heming Zhao wrote:
> >>>>> On Mon, May 01, 2023 at 10:52:13AM +0800, Joseph Qi wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 5/1/23 10:26 AM, Heming Zhao wrote:
> >>>>>>> On Mon, May 01, 2023 at 10:07:34AM +0800, Joseph Qi wrote:
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> What's the journal status in this case?
> >>>>>>> jbd2 is marked with JBD2_ABORT
> >>>>>>>
> >>>>>>>> I wonder why commit thread is not working, which should flush journal
> >>>>>>>> and reset j_num_trans during commit cache.
> >>>>>>> The reason is in my above answer.
> >>>>>>>
> >>>>>>> below is the dmesg log for No. 266.
> >>>>>>>
> >>>>>>> ```
> >>>>>>> [  595.071807] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> >>>>>>> [  595.080950] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> >>>>>>> [  595.081091] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> >>>>>>> [  595.081580] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> >>>>>>> [  595.081886] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> >>>>>>> [  595.082173] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> >>>>>>> [  595.082420] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> >>>>>>> [  595.082696] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> >>>>>>> [  595.082932] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> >>>>>>> [  595.083188] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> >>>>>>> [  595.084721] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> >>>>>>> [  595.095436] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> >>>>>>> [  595.787078] systemd[1]: Started /usr/bin/bash -c exit 77.
> >>>>>>> [  595.802650] systemd[1]: fstests-check.scope: Deactivated successfully.
> >>>>>>> [  596.195734] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: joining the lockspace group...
> >>>>>>> [  596.206310] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> >>>>>>> [  596.206350] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1
> >>>>>>> [  596.209667] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: add member 1
> >>>>>>> [  596.211433] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_members 1 nodes
> >>>>>>> [  596.213942] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: generation 1 slots 1 1:1
> >>>>>>> [  596.215668] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory
> >>>>>>> [  596.217171] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 in 0 new
> >>>>>>> [  596.218253] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 out 0 messages
> >>>>>>> [  596.219401] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1 generation 1 done: 0 ms
> >>>>>>> [  596.220628] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: join complete
> >>>>>>> [  596.224616] kernel: JBD2: Ignoring recovery information on journal
> >>>>>>> [  596.229686] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> >>>>>>> [  596.870008] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>>>>>> [  596.236135] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: leaving the lockspace group...
> >>>>>>> [  596.237431] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> >>>>>>> [  596.239442] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: release_lockspace final free
> >>>>>>> [  596.877286] ocfs2_hb_ctl[5436]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 78CE18109AE44E6AA896722A5E25CFC0
> >>>>>>> [  596.248299] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> >>>>>>> [  596.255888] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: leaving the lockspace group...
> >>>>>>> [  596.905718] systemd[1]: fstest-test.mount: Deactivated successfully.
> >>>>>>> [  596.280602] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> >>>>>>> [  596.281762] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: release_lockspace final free
> >>>>>>> [  596.921672] ocfs2_hb_ctl[5448]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 838DD74847E34AA1839D6C4AA31132F1
> >>>>>>> [  596.299507] kernel: ocfs2: Unmounting device (253,16) on (node 1)
> >>>>>>> [  596.481755] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> >>>>>>> [  596.484722] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> >>>>>>> [  596.484729] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> >>>>>>> [  596.485361] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> >>>>>>> [  596.485622] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> >>>>>>> [  596.485861] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> >>>>>>> [  596.486063] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> >>>>>>> [  596.486293] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> >>>>>>> [  596.486498] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> >>>>>>> [  596.486768] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> >>>>>>> [  596.487037] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> >>>>>>> [  596.491655] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> >>>>>>> [  597.139758] root[5475]: run xfstest generic/266
> >>>>>>> [  596.505896] unknown: run fstests generic/266 at 2023-05-01 10:19:02
> >>>>>>> [  597.186885] systemd[1]: Started /usr/bin/bash -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec ./tests/generic/266.
> >>>>>>> [  597.566466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> >>>>>>> [  597.579759] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> >>>>>>> [  597.579766] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> >>>>>>> [  597.581004] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> >>>>>>> [  597.581820] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> >>>>>>> [  597.582292] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> >>>>>>> [  597.582894] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> >>>>>>> [  597.583423] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> >>>>>>> [  597.583991] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> >>>>>>> [  597.584547] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 4 ms
> >>>>>>> [  597.585079] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> >>>>>>> [  597.590136] kernel: JBD2: Ignoring recovery information on journal
> >>>>>>> [  597.594258] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> >>>>>>> [  598.239046] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>>>>>> [  597.606575] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: leaving the lockspace group...
> >>>>>>> [  597.607446] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> >>>>>>> [  598.244507] ocfs2_hb_ctl[5680]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u AB0245F740984C25A9D0907D61DFCF8A
> >>>>>>> [  597.607843] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: release_lockspace final free
> >>>>>>> [  597.615474] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> >>>>>>> [  597.641624] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> >>>>>>> [  597.659435] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> >>>>>>> [  597.659479] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> >>>>>>> [  597.661482] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> >>>>>>> [  597.662340] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> >>>>>>> [  597.663211] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> >>>>>>> [  597.664150] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> >>>>>>> [  597.665466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> >>>>>>> [  597.666370] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> >>>>>>> [  597.667235] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 0 ms
> >>>>>>> [  597.668428] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> >>>>>>> [  600.194974] systemd[1]: Started Daily Cleanup of Snapper Snapshots.
> >>>>>>> [  600.207227] dbus-daemon[672]: [system] Activating via systemd: service name='org.opensuse.Snapper' unit='snapperd.service' requested by ':1.10' (uid=0 pid=5728 comm="/usr/lib/snapper/systemd-helper --cleanup")
> >>>>>>> [  600.209151] systemd[1]: Starting DBus interface for snapper...
> >>>>>>> [  600.217270] dbus-daemon[672]: [system] Successfully activated service 'org.opensuse.Snapper'
> >>>>>>> [  600.217370] systemd[1]: Started DBus interface for snapper.
> >>>>>>> [  600.218969] systemd[1]: snapper-cleanup.service: Deactivated successfully.
> >>>>>>> [  599.608010] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> >>>>>>> [  599.611041] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> >>>>>>> [  599.611127] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> >>>>>>> [  599.611813] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> >>>>>>> [  599.612019] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> >>>>>>> [  599.612227] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> >>>>>>> [  599.612397] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> >>>>>>> [  599.612559] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> >>>>>>> [  599.612712] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> >>>>>>> [  599.612880] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 0 ms
> >>>>>>> [  599.613078] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> >>>>>>> [  599.615320] kernel: JBD2: Ignoring recovery information on journal
> >>>>>>> [  599.619221] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> >>>>>>> [  600.392044] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>>>>>> [  599.780111] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: leaving the lockspace group...
> >>>>>>> [  599.781949] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> >>>>>>> [  599.784235] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: release_lockspace final free
> >>>>>>> [  600.426136] ocfs2_hb_ctl[5762]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u F06626AE7D754F11A0211679C145C8BF
> >>>>>>> [  599.808566] kernel: ocfs2: Unmounting device (254,0) on (node 1)
> >>>>>>> [  599.827803] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> >>>>>>> [  599.832848] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> >>>>>>> [  599.832984] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> >>>>>>> [  599.833810] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> >>>>>>> [  599.834272] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> >>>>>>> [  599.834663] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> >>>>>>> [  599.835030] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> >>>>>>> [  599.835474] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> >>>>>>> [  599.835868] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> >>>>>>> [  599.836365] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 4 ms
> >>>>>>> [  599.836829] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> >>>>>>> [  599.845790] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> >>>>>>> [  600.079285] kernel: Buffer I/O error on dev dm-0, logical block 2621424, async page read
> >>>>>>> [  600.090845] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>>>>>> [  600.091387] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>>>>>> [  600.091924] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> >>>>>>> [  600.092422] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> >>>>>>> [  600.094252] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>>>>>> [  600.095029] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>>>>>> [  600.095891] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> >>>>>>> [  600.096698] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> >>>>>>> [  600.099071] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>>>>>> [  600.099957] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>>>>>> [  600.100798] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> >>>>>>> [  600.101623] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> >>>>>>> [  600.107094] kernel: (xfs_io,5785,1):ocfs2_get_refcount_tree:358 ERROR: status = -5
> >>>>>>> [  600.107659] kernel: (xfs_io,5785,1):ocfs2_lock_refcount_tree:456 ERROR: status = -5
> >>>>>>> [  600.108175] kernel: (xfs_io,5785,1):ocfs2_refcount_cow_hunk:3417 ERROR: status = -5
> >>>>>>> [  600.108654] kernel: (xfs_io,5785,1):ocfs2_refcount_cow:3478 ERROR: status = -5
> >>>>>>> [  600.109128] kernel: (xfs_io,5785,1):ocfs2_prepare_inode_for_write:2326 ERROR: status = -5
> >>>>>>> [  600.109613] kernel: (xfs_io,5785,1):ocfs2_file_write_iter:2433 ERROR: status = -5
> >>>>>>> [  600.118113] kernel: (umount,5789,3):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>>>>>> [  600.118481] kernel: (umount,5789,3):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>>>>>> [  600.118898] kernel: (umount,5789,3):ocfs2_statfs:1654 ERROR: status = -5
> >>>>>>> [  600.119364] kernel: (umount,5789,3):ocfs2_statfs:1686 ERROR: status = -5
> >>>>>>> [  600.759255] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>>>>>> [  600.127135] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> >>>>>>> [  600.127373] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> >>>>>>> [  600.127615] kernel: Aborting journal on device dm-0-24.
> >>>>>>> [  600.127893] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> >>>>>>> [  600.128137] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> >>>>>>> [  600.128362] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  600.128591] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> >>>>>>> [  601.147704] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  602.171745] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  603.195707] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  604.219709] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  605.243712] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  606.267748] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  607.291715] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  608.315742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  609.339724] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  610.363774] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  611.387693] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  612.411727] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  613.435719] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  614.459743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  615.483742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  615.484503] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> >>>>>>> [  616.507742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  617.531751] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  618.555743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  619.579702] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> [  620.603758] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>>>> ^C
> >>>>>>> tb-fstest1:/usr/src/linux/fs/ocfs2 #
> >>>>>>> ```
> >>>>>>
> >>>>>> So the case is, flush journal in commit thread will never end if journal
> >>>>>> is abort, and then lead to umount hang since commit thread won't stop,
> >>>>>> right?
> >>>>> Yes.
> >>>>>
> >>>>>>
> >>>>>> If so, I don't think your changes in sync fs is a right solution. It
> >>>>>> seems it just for bypassing the testcase.
> >>>>> No. 
> >>>>> In my view, No. 266 shouldn't trigger jbd2 ABORT status. The 'sync' should
> >>>>> tidy up all already issued write IOs. After sync & load dm-error, new write IOs
> >>>>> fails on rw IOs, which shouldn't generate any journal IOs and shouldn't trigger
> >>>>> jbd2 to enter ABORT status.
> >>>>>
> >>>>
> >>>> What if there is no 'sync' in this case?
> >>>
> >>> It is same with issuing 'sync' case. Please differ:
> >>> 'after [  600.079285] in above log' vs. 'after [  207.623776] in below log'
> >> I mean your solution is to reset j_num_trans in sync fs, but in case of
> >> no 'sync', how do you resolve it?
> > 
> > If I understand your question correctly, your meaning is to remove No. 266
> > 'sync' line, then how to handle this case.
> > My answer is this is my patch [2/2] job. I have tested it already.
> > 
> IMO, they are the same issue. 
> And it looks weird to fix it in sync fs.

I keep my viewpoint there are two issues and need two patches.
sync action should tidy up all write IOs (including journal transactions).
From the dmesg, it's obviously ocfs2 forgets to reset internal jbd2 counter
(j_num_trans).

But patch [2/2] (from another side) could fix No. 266 umount failed issue. If
you don't like patch [1/2], let's focus to review patch [2/2].

- Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
