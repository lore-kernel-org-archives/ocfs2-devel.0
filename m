Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCEEC64ED6
	for <ocfs2-devel@archiver.kernel.org>; Sun, 26 Feb 2023 15:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MB/zdXMBT3UpVF4yVh36H0J7THFgfXlI16qzSOHfBi0=;
 b=AgCGXLFBKApJt2S7SwfeFTnSM3mxj25JfK3xdrrHEWlS9/JVOMAXR/gOgw1zWlLmswgmq0XYdGyl
   akbqJJ9MBV2yESkEM63AgETIY3YINejfZZgANA8yo9SEsUBinRP3CDqCgoF0Gkvn2BmjHOb2Oz5d
   YbhRMAmjMX5raXp8THvMK5hjwdNf7FbxgeH35/6kfsjggZkxliGIn4kxrIvCsPU2l2Wgy/5wImAV
   lLDlzqNibjgW53pafOWqpd746TidKeR6E0ucM6k1HwGeSzwPKFRzZYc20OOL5utw++GCQFdRN/AT
   tCb4EXK8F2BUgc/rqp/C9L+A2Q8X8O21sytw6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MB/zdXMBT3UpVF4yVh36H0J7THFgfXlI16qzSOHfBi0=;
 b=c+JCpHESS9xXrI69rF2vnck9dimpSpRb2ekdUqjO+cGBuLxuqiy/aw4nq9a9dZa/ShYcrpBObirF
   4DVlhn+/dAVGy3iA0UV4wAXhmnpIZJetdpDWjEYJGIb5wr9hCNSimhAsszqU8N6WQZoWBDVY5cB2
   hRwL+XAtPxwcXK5xVmENLWbKu3UOTQySjADzL8TLRJxuNKFCry9KnOOH+3ZRowsHGIiddTJLNk//
   Lv5BXLbEwpvwPQi1hKjwchWkytVFyTqC0TPqzaIR89ck9HBNCYzkGzgCs0eg2/KRG9xbAYAuYJdk
   Z1pgu9um3/T4i+BJgVhABHoEDDAJgGJkgvsjDg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQP00CP11FPNJ50@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 26 Feb 2023 15:23:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f34JJn84mMjvayOnifeqKiXIrfOC+H6EohEihAbgX4rQ6b/bRp9KwFtuABtowPm/0E82GEvPb1IeZoQjLgr0d/lFx1GerQSMSxh6fiZXEDgxu1IfKvCEhGpKjGYPC3Xt5RgZmpXTmPDB6HNLRCMpSGM6WDOsvWzBF/STsB0o/NCJcxFBVXEpQRSru/Ii1vewfkJjhrvSevXh9aCCHesTXlmh08lTaz2zImsdrfs0DLCGHIYD0a5b0lUnh1pE6gGJ1pwA+BCLWDNir8+Si4T3P5r0AMh1q80q6HD4QZKQRyxTO2/Y8R0HX/gsKC1p0s5SqTc4Ff6vS7m5Clkzy9ppWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQP9ePA0ry8MWdhLyDNfbHlwLuIjJXanMkhcjxAwmWs=;
 b=JYCoWoQzk08gNUcNygC3UXl0MDV8owcY3GmasnmWG9REuU9RzV86z7Goq/VMD9Sv+8YOfylYw54rm1nrZHi9qcOTQdIwIbWYO8u/yJm+8BHfeuPgq4BfbfUfFZ6utKeigdJxc9ZrWVQH10VkmhZLXqW80x8PuWDnt1D8MXjj/cl4i60nCgNUCrB8nema00KpOcptFM6iifah/Fnsc0vvVxZ3aaCsHccK5r7Q0FCd+k4tJaMdjIjIVg4Qfu5VvrKAMouuNr1vNRRa2P5212Qlo7vjFveeg6dIXSbm24QpwRJ5AhvD6xbQGAwgrgU/nFUHg1EstVBhazRL35Immg06cA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQP9ePA0ry8MWdhLyDNfbHlwLuIjJXanMkhcjxAwmWs=;
 b=LIH/3WwpMM8u48s/dMd/JnGeTyqc+ZkJtDJrlbwUxcpDOvAp7zRa9ph6ODEhylsWs0GFsWjCuNdjU8jvny1RvbdyZevKFsFIVv20mezVQF+vNcFZuTfBxjafMvS3I2v6fiq1cUoENOkWNZhSpYIYyucQKM9bYLlJEOEKl0E2ksiTyhLmbvEpaNt0Q/zdiH7BMRcZ9rh5cIWVVBTfFOBiNHxKSp4vUC89IvcdaIcwhs50fD3Xah/qC/Sf3q2HLsuP+flQdxXrwarcmClUgjKR/zfkryKaRNUtniS3MvX9TGBTaZznGcigLmGm4sl23GtYWO03b1b4nrSUm/ayvpgJ4g==
Date: Sun, 26 Feb 2023 23:22:38 +0800
To: Joseph Qi <jiangqi903@gmail.com>, ocfs2-devel@oss.oracle.com
Message-id: <20230226152238.a2wxbriw2sbxmkbk@c73>
References: <20230224003251.otqzmap2f64o3fpf@c73>
 <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
 <913a31c3-c3fe-b421-da63-e7d436ec674f@suse.com>
 <5d9e2335-c00c-6c7f-1e51-88c23b49aa7f@gmail.com>
 <87be76c0-b94a-d6e6-3435-e1764110302a@suse.com>
 <e1fc4970-010f-17a5-c2b3-7bf2dc937e73@gmail.com>
 <20230226084544.weep4qypu3mzgjic@c73>
Content-disposition: inline
In-reply-to: <20230226084544.weep4qypu3mzgjic@c73>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(7916004)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199018)(6666004)(6512007)(1076003)(6506007)(6486002)(53546011)(26005)(9686003)(186003)(316002)(41300700001)(4326008)(8676002)(66476007)(66946007)(44832011)(66556008)(2906002)(8936002)(38100700002)(33716001)(86362001)(478600001)(5660300002)(83380400001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 15:22:47.1050 (UTC)
X-Source-IP: 40.107.15.72
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10632
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 spamscore=0 clxscore=195 mlxscore=0 malwarescore=0 priorityscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302260125
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
X-ClientProxiedBy: TYCPR01CA0144.jpnprd01.prod.outlook.com
 (2603:1096:400:2b7::20) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AS8PR04MB8833:EE_
X-MS-Office365-Filtering-Correlation-Id: af569ad0-00e1-46eb-b56c-08db180d5082
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 Bm+HBCGhDQhtgXN3vnYhPhv+giPg55Cid5pqwP9Fd1SfecnHJy+EcbzEOeZ3jMdYPNDTk1M0reUntC3yRyvwssILHhrc0JA2R1+tAzey6horXxPt6bI+BDjjHvxUuuDZlL5rlvktR7V0901CNw7GuMqjmNwQtWE2zPiC/KPaYxylCiNCUIbaOUew3Q3ueqSGN5WFH+FA69NYFiX2siuRF9OYGBRHaOg5yniFWGfnyotEgG4O9Y+M48E6bw7185Jb9Hf68DVRtDy+LPbYrKJ2p148t2XyJOlJt9Hcus0p+7RUQai83RHWrVtxiOcUXtlAYRciSr/H9fQIKexcmb1j4DZgBIqT+ciFrL2WzXc0y90ErZ/gM21lPSE2L95pWUKkEZ+vMOAVL7USWsI5P+NUE8B3a51DpGZkz53P7RObSidreXIhEC56saHyYZiHBk6+4Kqqd61AFFAbd9vsLATx1rI6aXWczgfvOt1uLhrdURRydK3PSiSKvfFyR0XCm4c8LOnsAMzaRv+40Fj4y534P1vrY5rTALoT+CxSEMjNQlDDFF9yXvRo0B11YfdAB5OVvkWi7p1bvqIDbMGgkFw7pwHPhaSBW/N9rzd59T9jkfoNIZ29P31QLZ6kEQHhd10ZvvFSzQXxt1qUhQ9XgUgbUw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?iso-8859-1?Q?EKL9Xpj9CUbOAp2nR1NyTeDoi+CaArUQi026Y08TAgJjZ2To4SurifSna9?=
 =?iso-8859-1?Q?amJ3JfmT2uHWMQsDtoiS5JnNjtuIAat3PM4igGf/yxftKcb+GDZpDpZa7D?=
 =?iso-8859-1?Q?/VAzYCGYW+tAa4vm1wBHm4OmH1JwUU5+O7eT/3j7QwFDyAQycwSN0/nOAh?=
 =?iso-8859-1?Q?fgEyLCuIlzulZMbd+XY5ZShzAkA34esrGMa1Pb34aECbVGlX2LJV46VJKa?=
 =?iso-8859-1?Q?+8PjiNsDG6d5US8iVvo+vf9L01qoPV9ebPQQoyf8IQtH5kOSkaIxuk/cGZ?=
 =?iso-8859-1?Q?+nTPX+AWqT2rnHLHS5/VrLTKWa4HRMLdoWPFPBwAvECMkVx6V3YxbwVujX?=
 =?iso-8859-1?Q?8YeL/EVdlg2AHWcrq6fsqb3381hNjl3ZxF6V5CWv6MaTFHUR9jt1oal0Gt?=
 =?iso-8859-1?Q?4GuEdp9s7dZ2OBL//wxPrDFWII9NIHjGvfHqVuPBl7kTIZDfFrc1NkpB8D?=
 =?iso-8859-1?Q?5CCyNiZEWGTnXdgp5bVwVqpVUD3/ix9ZwQGwk/2+an1W0jS/+8BoGgrlev?=
 =?iso-8859-1?Q?Y22FObfmW1s9afzQ2B9UcjN97zjgMoqEgABZl2e46nDTVUd3Jt9YonSeBY?=
 =?iso-8859-1?Q?iY8pEtb9puv53Zyw+Iz0l48bGrDrt687hF5sk5Dp2CKEEhTB8SoBjalHOM?=
 =?iso-8859-1?Q?0vsrAyrK8ND5TeWgTQcyP/i3N4Q0fGu8rMyQE4pHTJRegLeSycdP1UqfUg?=
 =?iso-8859-1?Q?RzQucPSEtJtGJE4ikeXod7SIJnBkPdURkmxLaXp5VksOV2Y9hmf4fkVArs?=
 =?iso-8859-1?Q?stBlGXhl56pMb3PH1vc7kuva6II8Tl82y7yKi3cGvzaVhLLbYnKY/cHH+y?=
 =?iso-8859-1?Q?N8HPxKGVhQRVqOvPuelGD0CVgKWiRF+P6qwYYQT/1CJSTtqTAERVlM3EP9?=
 =?iso-8859-1?Q?Zpwmhb26v4rZ//xckus75cLfGNxfv7youMz/GeKsX6kI4o9Q4aaWEBtDLu?=
 =?iso-8859-1?Q?S6TE8ZmZEwqM+5eXycgWjcCrFdS93uIW9LV7ZSMdwOZx+FbyP39KYIeQ4U?=
 =?iso-8859-1?Q?nnr+anKaYx/OwRexz0Q7mvweoPCILMi18wgFD2v3lKxtkt8twkNmQ9eh58?=
 =?iso-8859-1?Q?oV4/yeRx33RaYHzvWZ5xaQGvfZxUJ+pe4i6+p6DbOW32AzH36fT1nzSLxE?=
 =?iso-8859-1?Q?rMVXR4IFZtARmXSyv8Eu5IzHsK0auWCAl2NBgPXAZJmyHlGPFlvaLON/wg?=
 =?iso-8859-1?Q?xphr9GaSSwFJFepsDGBpI07sH6FkpbaqOGp24FOW1HPltOuY6h8voH8ypQ?=
 =?iso-8859-1?Q?axY395kKWh8wbezQB++UiFB3+MRcc+9Vw/XhIb36HTqcCFxTb7vpo1kRAm?=
 =?iso-8859-1?Q?2IUtHLDcsyfb+lp077OGOJMjJagdzU9iAnZpd7lrBTPVoVIpp76+h/jbc7?=
 =?iso-8859-1?Q?bogWRmFcvuOyIv3UqiCFka0M8IIfRGcZmE4S3DbHaYFQGvcK2N/dUM4At0?=
 =?iso-8859-1?Q?uf10i3csLAMpfqnhVZ9Wx4X+c6sfPmWtn74Mkr5/ZiWH232O+GDVzoMdvg?=
 =?iso-8859-1?Q?yRxNAfDr3AeinUvjf49tIlUPPqXAch7ok5+xVFsByJFoE1pQxwIDc6kvZj?=
 =?iso-8859-1?Q?iP7C7wwKl2C7d/BIzGoreamhi0twFKvKA4+k7Szs/P++fJywnTICE9++qb?=
 =?iso-8859-1?Q?riJFkrayyM/S9/u8lC6yI13ybtSfo+yoZsooRniE2zQAJQTS5NCiH6Kw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 af569ad0-00e1-46eb-b56c-08db180d5082
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 ixsbpnBm8jmewWzRTXbhImXk+BH82FzYobMfK84T1TYQA92xxJg83AHGKBYBDONeUfmhvh8WVQGOLgmbwUd2LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8833
X-ServerName: mail-db5eur01on2072.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: qeA9OImFR-tW3vyEgctN7PI1zBo1IHLs
X-Proofpoint-GUID: qeA9OImFR-tW3vyEgctN7PI1zBo1IHLs
Reporting-Meta:
 AAFyJxZbPH6ogKmHs07RflEikajOI7flYBn17++7GQXEJ24mEzNOQ80yG15STdXF
 JMq2GG+FlvFe3STDUUijPQL3V50NaGqaDeISBT6Yb8fBa7HbHSEsYPU2c59lG2yK
 xK4SS2jNYZRYxicbyc2OH4whL/V0izih+ayU5wxhLQnVtl3h1xbfsc7kd5M+LtHX
 V5xegdA313XZUidrHcDXkmL9SzcE16ZyfaPi4riZG/f8L6Un1x+nmk+AzdK9tilC
 4pn2FuzilnLcBB4vdVoacwHcOiEnOHAWnpwz+VS99lS90gqn+WfPifvC04DJ98NF
 KjkWJEqDi05pE/prnHEVu9249hxyvTYuSEYAPpxgzMXfo42NdkoLlBgoDMfZarZv
 /mFsh4S3yO5rdIWc1nNHp9KBJdVcnGijr8kFxlCH9ao+oQdcdopCLr25Z4a0CU92
 8dltQ+/t7/a3102sDezIQldm0ufkdFiUyG4tPSGAHm6M06kGBnSY7zAjx9aUWQUC
 m3wNEONRlWiENgVQ199qIZo8sCZy6K4lIvkiHmB0sAvq

On Sun, Feb 26, 2023 at 04:45:44PM +0800, Heming Zhao via Ocfs2-devel wrote:
> On Fri, Feb 24, 2023 at 06:59:47PM +0800, Joseph Qi wrote:
> >
> >
> > On 2/24/23 4:03 PM, Heming Zhao wrote:
> > > On 2/24/23 3:52 PM, Joseph Qi wrote:
> > >>
> > >>
> > >> On 2/24/23 3:48 PM, Heming Zhao via Ocfs2-devel wrote:
> > >>> On 2/24/23 2:54 PM, Joseph Qi wrote:
> > >>>> I can reproduce this in my local VM.
> > >>>> I've traced ocfs2_dismount_volume and found that it hasn't been ca=
lled.
> > >>>> So EBUSY is returned in VFS layer. I guess something wrong when do=
ing
> > >>>> a copy with linked SQEs (normal copy seems no problem).
> > >>>>
> > >>>
> > >>> I am inclined to agree with you. I also test liburing examples apps
> > >>> on ext4 partition, everything looks fine.
> > >>>
> > >>> I used below bpftrace method, the retval is '3'.
> > >>> =A0=A0bpftrace -e 'kr:mnt_get_count{printf("%d\n", retval);}'
> > >>>
> > >>> It responds to flow: path_umount() =3D> do_umount =3D> mnt_get_coun=
t (gets '3')
> > >>>
> > >> Yes, that's the place return EBUSY.
> > >> So the problem seems to be getmnt/putmnt not match in this case.
> > >>
> > >
> > > I didn't familiar with setting up kernel bi-search env. I used one la=
st year
> > > openSUSE tumblweed (with kernel 5.16.2), this umount issue doesn't ex=
ist.
> > > So there is a possibility one ocfs2 commit introduced this issue.
> >You can checkout each mailine version like Linux 6.0, 6.1, ... and try
> > to check if it can be reproduced.
>
> I drop this method, my machine cpu is old, compiling kernel will take too=
 much
> time.
>
> >
> > I've tried trace mntget/mntput using the following bpftrace script,
> > link-cp output shows it misses a fput.
> >
> > #include <linux/mount.h>
> > #include <linux/string.h>
> >
> > kprobe:mntget
> > {
> > 	$n =3D ((struct vfsmount *)arg0)->mnt_sb->s_type->name;
> >
> > 	if (!strncmp(str($n), "ocfs2", 5)) {
> > 		@[comm] +=3D 1;
> >
> > 		printf("%s", kstack);
> > 	}
> > }
> >
> > kprobe:mntput
> > {
> > 	$n =3D ((struct vfsmount *)arg0)->mnt_sb->s_type->name;
> >
> > 	if (!strncmp(str($n), "ocfs2", 5)) {
> > 		@[comm] +=3D1;
> >
> > 		printf("%s", kstack);
> > 	}
> > }
> >
>
> I used below script to find source file hold f_count.
>
> e.g: ./link-cp /mnt/aa.bin /mnt/1
> The script will show f_count of aa.bin only down to 3. We expect f_count =
value
> down to 1 then trigger mntput.
>
> ```
> #include <linux/mount.h>
> #include <linux/string.h>
> #include <linux/dcache.h>
> #include <linux/path.h>
> #include <linux/fs_struct.h>
> #include <linux/fs.h>
> #include <linux/io_uring_types.h>
>
> k:fput
> {
> 	$f =3D (struct file *)arg0;
> 	$cnt =3D $f->f_count;
>
> 	if (!strncmp(comm, "link-cp", 7)) {
> 		printf("\n [link-cp] fput() name:%s f_count:%lld <%p> mnt:%p\n",
> 			   	str($f->f_path.dentry->d_name.name), $cnt.counter, kptr($f), kptr(=
$f->f_path.mnt));
> 		//printf("%s\n", kstack);
> 	}
> }
> ```
>

I am not familiar with io_uring, and can't make sure my analysis is correct.
Because ocfs2_file_read_iter() returns -EOPNOTSUPP, then fails
io_iter_do_read(), the io_issue_sqe missing fput() which causes umount fail=
ure
issue.

io_issue_sqe
 + io_assign_file //call fget(), but missing fput()
 + def->issue()
 |  io_read
 |   + io_iter_do_read
 |   |  ocfs2_file_read_iter
 |   |   return: -EOPNOTSUPP //iocb->ki_flags:0x8
 |   + kiocb_done
 |      + io_rw_done(&rw->kiocb, ret)
 |      |   kiocb->ki_complete(kiocb, ret)
 |      |    io_complete_rw
 |      |      __io_complete_rw_common
 |      |       + req->flags |=3D REQ_F_REISSUE | REQ_F_PARTIAL_IO;
 |      |       + return true
 |      + io_req_task_queue_reissue/io_req_task_queue_fail
 |      + return IOU_ISSUE_SKIP_COMPLETE;
 |
 + return 0;

- Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
