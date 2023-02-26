Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B9D2C6FA8E
	for <ocfs2-devel@archiver.kernel.org>; Sun, 26 Feb 2023 08:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GYZ2bOacRqi2sahbEKWlhX5YFm4zXQlEdoiUrqSpN+U=;
 b=yyq04bCvhfSXt3OgnNv+MgRJls0z5My/Mb3ufon4CbHbNpR8jwS/+uqphYCkqAp0SItRmIvsUxQA
   F64k8nEMRaertdirJPS4gRzbViaODWnSYbt0mU6zfQ9sm3h9JttJGkSEhfyCHl2YmNJszgY161KX
   lkRVZv4xoa3YijNndxPiuArUUhE6iojLqMBP57UuLYlPrnqpQ0404rjq4GYyRrzNbj9WwwpXisXE
   so5eHQU1174JnfTX2ef//N9xdiSQTxEEQ+5Ps5glwJHrNazlob99aYfBx3oILHwYG0rBlsQ+056I
   tmT6ye4fmHYpwfI2pNv3XfO1UMrABtlp0Oag9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GYZ2bOacRqi2sahbEKWlhX5YFm4zXQlEdoiUrqSpN+U=;
 b=MTLUu4z2lR6T2UHGDixYQEt6l0Kg92iDXLxqedvKt0bZyqactd8vKnKL1/lnSv66lnVOd5xhz7QW
   wvfSoZ8b4JFqOMXAW6z6i0FE9YSMcWbIjNqOJOWjXoeHp9UshaoSZmpxujWhDT7h65QVzLZGC9RT
   pLWHfkV5drpHF7SsZLKhJKN5mhTzgZPBKS9/4QJNuAZh1+FRn4Qb9MEKtACGAJqyyAz1ZcV2I9u8
   JftEmzfcjdGMG8Nkiyx7Yuv76DMV3NWx3dGThyY+zZjpXGBZdQG4Z96lSvKMwiTl68EmaSY1gMSs
   y2SpFCLWBF0mJUtFP+c3us1zOP4C5WwzrjpAFA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQO005C4J0Z96C0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 26 Feb 2023 08:46:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNZx8WdcbY3LhQ+BZif/8+fySLYVFBlCLnA6kpzdxg66J0KEvLiq795K7q3KZx3R4TQiHANN8l8hxi6G4vKoHn/5aPZnEEY5HBKBxfeGyWTk2lKLAaAHz5jGleXT1a5UdaZR7h3GFcUBWw2EEAQCDPSOWupkZoWOkECHejXtbf6fqtLIdcJ2Sln3FpLjF8YjHyE9mt8sYO96PwmStXLy+g2g0/RV2gbcMrko3UqcnPpnpxqke8OwnbMxtcFUyHKW+px2qH1l4nmu75opem2KCljrrFejpj5Btj+/a+9OiIkbTCRLO31gUXUTJ5Lb7WDqfGnwzaUP05Qow4V7LOQx0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRwePdSCfV67y5omlngVvMB9/ccGRfwKvi91YYCJcP0=;
 b=GPHaJ23ddlutj5KbG6ms8R+bDvHtdRsq6bRUULbnOC33HW16j2K1DUH8H6ZJxu7BuGtfycyDnIyi4QEma7Sw8XhjWrz3pEIu+hhqaRYcdaM8R8CdeBClaCz8QeGuA3V/LmxD+gK1gX1lSziFeYYuXBO5gl1t8gfhw2aiQHBCwKQxHP2lk1DLQKgSPTunT1zemrfE2xc2+vakRhnCJyo+9fudBaVe275AH727LGOnfVv74RN527trj/v5/WBILVbtl+IxMsiKanVdoqWdEurcFJ7Asr82GwLWEkU/QiwU0Hif4wF0Sk9LqIV9+52kkVm2xUQwvW7T4MJbkVfDH2vHiA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRwePdSCfV67y5omlngVvMB9/ccGRfwKvi91YYCJcP0=;
 b=tNtfpocl5SXuEpS433AKTvEuNgZSmN5Y3VpjqywUvjnmroQKKVD6I251+fO9E3P2A/urGIP+7TtwnoGa/YmEL2dkVn5vuQ8HIsSYHZthGYn+D9bUSNhBeeYwt7faK6Icz6LjoUKhziMvRSEHz9rWggrJICwSeARd/msbVzOmc2dJDbGKALLuWPdfn6h9qZmezLsyJnA3ffCRNkpxKhnbzpK/p9f8V2L5mpV6qoJFChwZEk+kRaBeGCbdY8nMHnQn1FfZhdJRp7nHIx1sBLfQ8u6LMEna0nAsI8rTrjcPRYtExZaTMzP6mcjye3Yu53E7QZY2r03LzRwbrv/5RQIS5w==
Date: Sun, 26 Feb 2023 16:45:44 +0800
To: Joseph Qi <jiangqi903@gmail.com>
Message-id: <20230226084544.weep4qypu3mzgjic@c73>
References: <20230224003251.otqzmap2f64o3fpf@c73>
 <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
 <913a31c3-c3fe-b421-da63-e7d436ec674f@suse.com>
 <5d9e2335-c00c-6c7f-1e51-88c23b49aa7f@gmail.com>
 <87be76c0-b94a-d6e6-3435-e1764110302a@suse.com>
 <e1fc4970-010f-17a5-c2b3-7bf2dc937e73@gmail.com>
Content-disposition: inline
In-reply-to: <e1fc4970-010f-17a5-c2b3-7bf2dc937e73@gmail.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(7916004)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199018)(86362001)(6916009)(4326008)(41300700001)(478600001)(66476007)(8936002)(66946007)(33716001)(66556008)(8676002)(316002)(44832011)(2906002)(9686003)(38100700002)(6506007)(1076003)(186003)(5660300002)(6486002)(53546011)(26005)(6512007)(6666004); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 08:45:55.1163 (UTC)
X-Source-IP: 40.107.20.88
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10632
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 clxscore=298 phishscore=0 malwarescore=0 priorityscore=30
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302260070
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] report BUG: io_uring triggers umount error
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
Content-type: text/plain; charset="iso-8859-1"
Content-transfer-encoding: quoted-printable
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: TY2PR0101CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::23) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DB9PR04MB9427:EE_
X-MS-Office365-Filtering-Correlation-Id: 9121cee2-acdf-4ecb-33ca-08db17d5df78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 F9WPT7PNO6tDYae4o4jS50i9L4l7oXkvCBFAOlvGstUR658NHIcomjxic7rO8GiBuuCvcxBQd0d+Hk2BiylG5P/VLnIXygXKF9P3tiyaS4Il7d6fI7mh2Uh1Dxq5Kqy+7pVHFrUCvZ4AGoPym5F2kp9I7uPFRggNGp2Gu7fT8THjSdwMIV0L9/GoieRkVQzD+PiYhZhP+y0cPsy1/tXk4GilBooVB4eRexFi8w2uf7b+TNpKq/hJ9Cm1WGDQVFf2beecxKQa/SpkSE5b/2nVzFdslWjLslx4vrCDBF9RR0jQjWAgHTRfBhv3DA0V4NtrLSG2YP2zcHdhM64efw/DfaCs3oNxvitnKySHnw9vQAYcHA4Vk2kJL3ToOTsm873ZIGsTIXJydDexWWayatRqyYMDN3D/P9gFmrtV1U528CZy7S/sWTw7JA68ajwzon4wegxuLrbv3P1OeZqhz9ZQPFPDguAWmrnTzuBuGewwWhkvz1WIVT/dLPlGC3RfVGKG1sl/ev/hnqzMXy2X/pFoI9cdZB/gOp7d2ZPRWjM/PBRnIemkR7H+4GkLyxln/KtPxqjQfl6+j4PJjfhgn7nikAKW6rXPLkgwOVdgG9I5hZsIlQOQBYaPKlu4GeU3w+eQlT7VTKTxEU4AEqvmI+CXbQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?iso-8859-1?Q?xGG4ydTbb3JTc3fOm8aVn/H7QJyA3SnmHgMmQfiax1249clonXHNxF0Vbq?=
 =?iso-8859-1?Q?r0rvm1MI+XGEDHFGyQjthtctJeIn8V0MS8r7HOxct+D55QnrTjbm9I6h+U?=
 =?iso-8859-1?Q?J1qF4V5A9lNHIEgI5eeDDDmOmXS1M/dILXdnAyC+wbSUrINJ0vfrMIzrJp?=
 =?iso-8859-1?Q?k+yj1M8ueQ7Q1Z4Ocv0+PtaQTOau5Uj3xcNxh/rM6cFWBxX4zHqZEU1fiv?=
 =?iso-8859-1?Q?beS1YgH/dhkV18H7NRYdYheoHYMbG/1mpVSW7n2utsYwX4JkrbTyIn0GWJ?=
 =?iso-8859-1?Q?yCi69lMUc+Nrk8IKMbVmz9Tpk3ZPacxu5TWkx4vCJyyGS0G96axPzlYXZ2?=
 =?iso-8859-1?Q?zm7FfqdjxZ6+pDXyS9OmQiLPxPpXVKlNjjPeZxVM+DWJshF98m7TICdPb0?=
 =?iso-8859-1?Q?yniiqdlIARzxBnbSbtHqhMeylXDFd8nlIgZHob7Np0Ke1Q8OdWv91AVJjg?=
 =?iso-8859-1?Q?mNGIHTs4jlOiuMY9pU1XObo87vHLdFwscprd+ZupUX1aFEMdXxb+wc0MoD?=
 =?iso-8859-1?Q?UujLcutn129vqn/IAh5Dwrh0Y1At8G2gjkDcq+G+zz82ONZjlkXhP2WvwX?=
 =?iso-8859-1?Q?RH6ZBN0kwnIhZHxmOwec36X1nn9QH35NMj0sYubtBSWmt0RWVY11Lf8AXM?=
 =?iso-8859-1?Q?yhWqn7SIXNTMu1MHz6s177vvd46e7Wl9oVs/z1zUKVWFOc+KO9l6TPKlMa?=
 =?iso-8859-1?Q?5fDHSvDi5npi48QA47a0wce99yKRTxGZ+yoMPbc5Wt+x/+Ep+BlIjtexnv?=
 =?iso-8859-1?Q?4w6JSiQKfki48IXVZb7oneObagPf2slvSK/e5DIjZRETCVl8RMpIQ0h5Jk?=
 =?iso-8859-1?Q?y5yeDuEitvG8lSbAPUwucmbbq5uj37N0AzSjLvaXqctdG2ZCRWSjLoH4e+?=
 =?iso-8859-1?Q?85ihSnPUgo4+KEyIO3mBuTYSPIajT9OENHlfzrW7ap5q0pHnwi1wdGgqc/?=
 =?iso-8859-1?Q?OTjggV9R2+dzsUK7SjbBupS++xsk7aeSVXWdw8OjAMnjMiMOlDHN9rcAHu?=
 =?iso-8859-1?Q?9fU2x+y4LyIXz16OXGXB+GLNq2jMpnNgaxE0Rx3UZbRT6UAG3Z2JxS7xr6?=
 =?iso-8859-1?Q?GvwKngKUCX092iAf+9GvjQ68J3Wy+t7aa5YDFBtjO4dPwIxZCt1g5IFuuU?=
 =?iso-8859-1?Q?M2IulO/Ks5XVO4Mz0ZAl/gdjxQjX86FBEdsLQf/KiLwktTKxb/A2n/j1MB?=
 =?iso-8859-1?Q?L1esPidKApcyn9Nw2QUe5jssWEIIh+Au7VtUbngqGyziXrUIcGev0L8+d4?=
 =?iso-8859-1?Q?1q6p0WKvZbl5LrN3/a8BBmcak2QirchQ33cl5kCbAHxdmqAN4+N3IBICf3?=
 =?iso-8859-1?Q?dawuLC05EBWCTXuYMEWwaGzevV8RkjVn90K3gubgNCcxoKSyRvivlroA7X?=
 =?iso-8859-1?Q?03awtg8m4ZnwsmZ53qTIgUcYMZavTRUEZAiU0xiSpZuVUlHooUx3P9jyZ9?=
 =?iso-8859-1?Q?tT/jkoHYsfBFaPi6prX6TYwBTrTM/nFgZJilYNc+ha/uK+Rqx4cDwkCUZe?=
 =?iso-8859-1?Q?E16FIdjY5L7tdnwS2Jp5lu4XMRzF+RGgqKUeLsBSZp5WslKg8EiPL3iJVF?=
 =?iso-8859-1?Q?MGT2mNl7oxsFHGprRsaVarsgmUXyLqaFnbD9HxsXIAPaCiRpMaTN/8UXGs?=
 =?iso-8859-1?Q?J60nwzGIHe4eY1iuk8nGMeIdIL51EHCvKTp3ZJqS4+F9vTnJFL05wStA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 9121cee2-acdf-4ecb-33ca-08db17d5df78
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 6c2FkumoBbwALmgRoTRtZIrJWwxw3cSTHVijqt8dqJvEBTkLH+JEU0LW3VuzfFy8XxxVCg0gLl3EbgKUykOxkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9427
X-ServerName: mail-db8eur05on2088.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: NgRnEmlHEks6rFs5097f_IIxjCp3pXdQ
X-Proofpoint-GUID: NgRnEmlHEks6rFs5097f_IIxjCp3pXdQ
Reporting-Meta:
 AAGhoLGTu3n+cSGni5719GyLEPXJGn+6HPJwJEN2MU5kqwSKYld1RTk3tNB46Vv/
 nXFUZjIOSjng7Ps2QY/qTGVAhRFvJBDKMda87wPe9MWMgEq5d0KZc/Bs0I85IOLS
 MQ4DQIveD1pomJruKR5MPG1ndK785bHEl9OwJYIPI7DxseZkWhhEgYnSx1EHccp1
 o9GALtr5LhGHlUgMNP0YqeULE8M1gtE+vblptxfYuiga+2t43mWgATbQxZ1CMjaD
 dU4dDMHDTHq2f3jGDDozb4cRt1H1nBfMY4EiM4Df+Y64Y2lCWOuzD/vOtoBW0Xev
 WSwVaG9EyTJbvQ17rOEhjlOWtRu+BLeSNYsZ7v4nhoTXvMUnx32DvQAWtc2+GliX
 tOHwVP9j76x6NAYNOv3R5kQO9sXYRvs2NERuicGv4GCfQGh1C4VhLMFAPQ29llBk
 n6JIp94aaxOiF5DMpW7fCPND0UBUoJJOEA+rfnynqJj8qjfXj9/sck4NdwzdMkCl
 RxQKNJsTRLJEgnLNHQyGvAz8FD3EmKwKarDBo6arCJ4r

On Fri, Feb 24, 2023 at 06:59:47PM +0800, Joseph Qi wrote:
> =

> =

> On 2/24/23 4:03 PM, Heming Zhao wrote:
> > On 2/24/23 3:52 PM, Joseph Qi wrote:
> >>
> >>
> >> On 2/24/23 3:48 PM, Heming Zhao via Ocfs2-devel wrote:
> >>> On 2/24/23 2:54 PM, Joseph Qi wrote:
> >>>> I can reproduce this in my local VM.
> >>>> I've traced ocfs2_dismount_volume and found that it hasn't been call=
ed.
> >>>> So EBUSY is returned in VFS layer. I guess something wrong when doing
> >>>> a copy with linked SQEs (normal copy seems no problem).
> >>>>
> >>>
> >>> I am inclined to agree with you. I also test liburing examples apps
> >>> on ext4 partition, everything looks fine.
> >>>
> >>> I used below bpftrace method, the retval is '3'.
> >>> =A0=A0bpftrace -e 'kr:mnt_get_count{printf("%d\n", retval);}'
> >>>
> >>> It responds to flow: path_umount() =3D> do_umount =3D> mnt_get_count =
(gets '3')
> >>>
> >> Yes, that's the place return EBUSY.
> >> So the problem seems to be getmnt/putmnt not match in this case.
> >>
> > =

> > I didn't familiar with setting up kernel bi-search env. I used one last=
 year
> > openSUSE tumblweed (with kernel 5.16.2), this umount issue doesn't exis=
t.
> > So there is a possibility one ocfs2 commit introduced this issue.
>You can checkout each mailine version like Linux 6.0, 6.1, ... and try
> to check if it can be reproduced.

I drop this method, my machine cpu is old, compiling kernel will take too m=
uch
time.

> =

> I've tried trace mntget/mntput using the following bpftrace script,
> link-cp output shows it misses a fput.
> =

> #include <linux/mount.h>
> #include <linux/string.h>
> =

> kprobe:mntget
> {
> 	$n =3D ((struct vfsmount *)arg0)->mnt_sb->s_type->name;
> =

> 	if (!strncmp(str($n), "ocfs2", 5)) {
> 		@[comm] +=3D 1;
> =

> 		printf("%s", kstack);
> 	}
> }
> =

> kprobe:mntput
> {
> 	$n =3D ((struct vfsmount *)arg0)->mnt_sb->s_type->name;
> =

> 	if (!strncmp(str($n), "ocfs2", 5)) {
> 		@[comm] +=3D1;
> =

> 		printf("%s", kstack);
> 	}
> }
> =


I used below script to find source file hold f_count.

e.g: ./link-cp /mnt/aa.bin /mnt/1
The script will show f_count of aa.bin only down to 3. We expect f_count va=
lue
down to 1 then trigger mntput.

```
#include <linux/mount.h>
#include <linux/string.h>
#include <linux/dcache.h>
#include <linux/path.h>
#include <linux/fs_struct.h>
#include <linux/fs.h>
#include <linux/io_uring_types.h>

k:fput
{
	$f =3D (struct file *)arg0;
	$cnt =3D $f->f_count;

	if (!strncmp(comm, "link-cp", 7)) {
		printf("\n [link-cp] fput() name:%s f_count:%lld <%p> mnt:%p\n",
			   	str($f->f_path.dentry->d_name.name), $cnt.counter, kptr($f), kptr($f=
->f_path.mnt));
		//printf("%s\n", kstack);
	}
}
```

- Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
