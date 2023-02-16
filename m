Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DC9C636CC
	for <ocfs2-devel@archiver.kernel.org>; Thu, 16 Feb 2023 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v+vmxhaM3nbPj6QYbgYXt+HHKWDdzwTesZgihG2a3Jk=;
 b=fg5m0P1Jg4FuYy9fC+RS4B+7x6mIMam6sefOPwIQRfONE6XlnWlF209i12H3b1qnGrayiHQ5HnCj
   O+4iTotjB/JtzstA/eAUzfY5c2llCQeEiW1CCebKWnGOHPK9fa1IjkBqGewcwfg6nxaUyjvPsPt9
   rRZZTEFSMxiM9yAhXtZnV6fXK+jDpqZtC88k2yj1pkpOC0965O+Xa9zf3p9lnSwafqtS0c6w+z4q
   w2iUVzQ1cCbcizDMzUHcUE+Ks95gkHspr7JMXNUWz0vv4UV+KvaD4enos5+VYqFfR5cLcFz3zjqU
   jgdKss4cHbm1q8xbdtszCH3C7k55ctyycRC3jA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v+vmxhaM3nbPj6QYbgYXt+HHKWDdzwTesZgihG2a3Jk=;
 b=fbiVT4pf3WDDNlUYJdzzp2YvlcUzo7DiWaWfceU3onC1WWx9KTEbj/LOyJNaOMaEMFtdiHRWM3Qz
   zkm0Wg4yRp6VApVD1rLNbhJb1a8Ea3of85UgLajaevPpwOL8pelfq6Vsfpk497s0gJO8598j8hn2
   2FfYcliH/kOnScfntqJD8l9sE0hCUcLQkCL584Wx2p62LzPAPn5iqKdY7Vsj2yGCrr+x4IZCVXAM
   NnodfjXb3I0KFOELZNCSR1PFthZM5+QZ1AhZy2OHdN8DorAA3sz99Q1kjfXTLMQey99pDPHLjtaX
   tCXFkgT56ErILDeR5jsz7vtqFeYOh2mvbfDyBA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ600GWRHLWSF00@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 16 Feb 2023 14:58:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gn1gx52LUYENVVD5TW/+JdpCpuw9hHvfgo0zWzF+DTaJJT/x/Xqt+Dbjd2hDXvFibA34mC/6g01uzQcwFZcaOE14Dluy+VnIy8meF82UkGdMYzTHvsi2NQriXU+v1Nz5IRoMOIZGME+ArSwg1wG+2SEkASeai5PrKrUqHxXozaR1K4Eh4+K5lSpcVxiyuO+3r1LS94AevzyNwAMKNrjq21oHr/I+BhG9Pi1bubjH59scn3FlFp8KBYYW17V+oHF+/nbQzHeQ+bL0FCu6Ss4LzqR/Y1Qix9rOEaLwrikVDidHylw8e985MTr4Yc7TvnsEhjhmkxHGWwV870a50NGWUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uh2ByztpaHgypIeaQS4upOjMxlaFVlaqBPuPLlDtUuw=;
 b=WiYwlz0xDXDCYxU1B9fqphykG+3K2rQ5+k/+KikLfujj5nCWN5IEofqLGFvqu6k+dYkgS+HwqcmKr9i5fPt9tzK/ERBRNpmd/MLk8qw907sAvr8HdfZjI2fS3E1gpGivDMP8hqyuapJ7BkVaqGyFS/RArsXzaB1XNDnCq2maSR3mqvD8ZwjxOKNwHMXa/ZVHZ7pPLV/b2DgPGdu1neVLREEttoQt0rmu1AdOxUfnF4uFq5dX5tfs0IFYDRHAmks0kLoyv2D29Ka5YkLEHmkndZReB0PtwRwq8numLICLvYW6byse2chD/Vmawfyzz4oV1jbds3PvfV+JC3YqwG5C3w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uh2ByztpaHgypIeaQS4upOjMxlaFVlaqBPuPLlDtUuw=;
 b=n08IfSldDzsEgmVhEjnGJ+SL+OnvFrfSNGozB91nW/uSL4nDcxJ+iwjMnXKt5nZVvT9RBnj1VIWse/XodbAlU8CaPDSXmpUWOOyGVB/Jn7ixXOBdx1bDXK8LFc8Nr+sclJC98IuayH0XDcz/0dZ6V0paVq2kEnqdJuZZWcLCty5wijUW+nzMUNATUrgegYyvzRBNMFD2xnAqyFItbDn6w7Fr6JzYLZtONiy4VMOJ9oEfKdHDVmIkkkY0FksBNMAAMWPfgrkAnHhlyEn5qPWMxCRIiz79GUrNOJYupgx4drIhseUF6HF0QGZWPpRzsTTYhPjqxcs1D+CzGknxYtgqRA==
Date: Thu, 16 Feb 2023 22:58:17 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
Message-id: <20230216145817.iqysrtqiq7bw7gax@c73>
References: <20230210100457.xv5wchadnd7kkazb@c73>
 <9ceabc71-5b18-5a1f-12e2-ea63aecd78e5@linux.alibaba.com>
 <20230214043344.szvhwukkdkzsky5n@c73>
 <c60fddf7-f49d-3f7c-9383-5fee2ccf7a65@linux.alibaba.com>
 <20230214114829.zxemgnnb22sdba3l@c73>
 <6e2a7c7f-1318-b611-094c-71008d03be20@linux.alibaba.com>
 <f71ffaed-318a-f1f8-350c-fef09932feea@suse.com>
 <7c1ed545-bc4e-e60b-50c7-e4e0919d1bf1@linux.alibaba.com>
 <5b0f4bcb-58e1-d070-261b-3210432edfaa@suse.com>
 <366a2ae4-4132-7e13-f744-115fbc25ffec@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <366a2ae4-4132-7e13-f744-115fbc25ffec@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(7916004)(396003)(376002)(39850400004)(136003)(346002)(366004)(451199018)(9686003)(83380400001)(33716001)(86362001)(38100700002)(6486002)(478600001)(6512007)(107886003)(6666004)(53546011)(26005)(186003)(6506007)(1076003)(66476007)(8676002)(66946007)(4326008)(2906002)(8936002)(66556008)(5660300002)(44832011)(41300700001)(316002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 14:58:24.4518 (UTC)
X-Source-IP: 40.107.8.42
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10623
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=308
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160129
Cc: jack@suse.com
Subject: Re: [Ocfs2-devel] discuss about jbd2 assertion in defragment path
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
X-ClientProxiedBy: SG2PR02CA0054.apcprd02.prod.outlook.com (2603:1096:4:54::18)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|VE1PR04MB7312:EE_
X-MS-Office365-Filtering-Correlation-Id: c582391e-dcda-44c8-e11a-08db102e40ae
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 7DRII1jrBjt0tZTtR7UFnwkgJGzusmO5jim84lhdOkQHT3Z7hRauys/le8tLtsgAw4eG1TQyeRH//aeSks//SPHWR8XxcNr1nkq3AZRyKGAgY3oIcnUKOtz2Lmoa8Izrzg3caa9qcEIXrfetqDOL6Nby3M6xQ4O3BCn1cw1XuHk/PnSSpkMsbxY2jVa6jT1Ep90YsK5j6JHkNMpSW6GXp9GnuYV8La5bfk73a+Kvh1ag/EvpuANsN2ml5Q2WA4PeP4r1NsXcmSaXOSl+IHanBOPFnM2sJ0S4n/dz77UXJQlSn+Qa6pgXhA4T2D8hr4or5CoDJIHDhl00B9REDLYeuEnb9DxINsLJaBZw4VgiHb9y5t7u47JAwLD60vUfGMG5wMvQDCgr+lzHomn9ERZPJxIwfz2nTmqn3Q/jAtVwcEgrRNi6pmdYxzFjiOWZhw9AHTvVZCC1b40n8Mq9WSDg1mvo5JfXP4swX6GassVOfY3IEclsx2qYJuCn62+1ZwA8TQEiQLJ8Ii8445X8VzpN9l9MHze3+SkX1UsJ46oDzZpWXL8d5LLV7nmQPRnwoWeXwZLy8SncsRjX+X5dVm9xUw08l6zTLGydaOIzVOpHrjIlyWLIC6AMYo7glouXrfLA8hKWq5Jltvs4EYdg0Gfjiw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?iso-8859-1?Q?QsXBKocWAd+bVz/V/NIkO9QEjiIwEZ7ahvyi40C8XxA3G2P9qMEPyDlpfR?=
 =?iso-8859-1?Q?+cGQNYerfLg1As1Tomphia+iVs9ghe5SscAFuCoDe4UBG1iESkd498Nj96?=
 =?iso-8859-1?Q?PKlAVwMc4B0fWoZh9elLgJMvM15O1VLd2fuT+G0oilHM8gm1yXxdRq+quk?=
 =?iso-8859-1?Q?lLMaMt8Jf9lghvJ15Gf9CECKe0q+OOv/WByXAWqyZtSnAiAdmIm4u+uKk2?=
 =?iso-8859-1?Q?e+MPMdhAiqZ24g0V8eT1HcpEORAygHHdJ9QoTsNWDcDEZTN1qu/582NJOR?=
 =?iso-8859-1?Q?XpUQk9ZfP1W7d+a80C03ZBzz8d/npq4muaYCTkBtPNekqMcQ42VluZBROi?=
 =?iso-8859-1?Q?2VTgg9rbSy5CvLSugZyiHpr9pmwNrBCQOEXZkyOX4DqOM7v7gUDUebxrir?=
 =?iso-8859-1?Q?C8ITmUiAdQ75Zdt1469mcVyKmP7fvJI32zWUmFakMHuKb+b7snOTxlSchs?=
 =?iso-8859-1?Q?ifgaSi7zb06hBUdVBM680cb3yjOaeHRwCgSVbBG4DFW0TOxOtOLMlfScRh?=
 =?iso-8859-1?Q?0XR5UOr/5Yif4We8197rzcu3YEsitfwpBa409AeE3ORMp1fxB195g2StWh?=
 =?iso-8859-1?Q?m1s+G2f4WO6Llnh6llF07YxFF8yW8yIuZrMaFAIhhTqw+e8WhdZB4uBCgs?=
 =?iso-8859-1?Q?TcxKo8RJzteHrULrDl79zwxeFWRCzDpLgbPiAygtx3BGJsR8n8rM/3c2PA?=
 =?iso-8859-1?Q?s0shb/ZZN8OL4N5bJ2AFQO7MHGIyhSBMAB+5J6YoVhIF3nF8ZKKMz3DsER?=
 =?iso-8859-1?Q?JJxbDe+SF/jhFaqU1QTMAiDBimDAZTNBj31PQZxCwpwuD4uQp5/Cewe78t?=
 =?iso-8859-1?Q?EcS62aUv8AGChfiB3Y0po40VQCGCplODMDEAV57b/NnvkZWEjPM4xr1nqa?=
 =?iso-8859-1?Q?jlAfkmfxCLm3kkZv+b+Te5wPCuAdngDywwJlPTqeOM7YfUnTar1zl3Dw0o?=
 =?iso-8859-1?Q?HhDPrpBJyGc8tJgmH1j7BkukXk+FI6NlSGGD8xh1saroInaLHcbrhRTf20?=
 =?iso-8859-1?Q?hXZEBmIO2Wmz8sJ1y/knMu15IuMjyYMmKABT6CF9gZN45fmoBET1m5Rhs/?=
 =?iso-8859-1?Q?oF3Js/cRgUsLoWgrY+7vU40cU376QGZRFpQNzflupbeylb0p322eLi1Dsx?=
 =?iso-8859-1?Q?3LmrgDrHuMUViRjsh0gfZVmoIbYouHQ7jNGsl+LTUXLs+iSc14Et6lugOH?=
 =?iso-8859-1?Q?dGTkoDG5MZm/PWGC8vKNnWrAyIwH7Wf1nWti+nDNMS9227ycQyvsdyZLRl?=
 =?iso-8859-1?Q?T1xFtR8TY8D5Al1Q6viNlhP0e0p3cBytEBqeaPLO8dXMT/j2zy4eCz4Gk3?=
 =?iso-8859-1?Q?sNlCoyizcmb+y8nJbItzUmfCTu6U2dN2WhAR7nCQSPMKDqdQydgmPAWBG8?=
 =?iso-8859-1?Q?OEW/vGELb4qP4SNxBLa+gqvOkipfcsmEDFGmxlFir3LJLAnyuKsaJ0RtjQ?=
 =?iso-8859-1?Q?bF6uZTxbx249MjhTQYucRc4jkrCrgRoGiNmGVY3qLE+pCPzWKFhdNtd9i2?=
 =?iso-8859-1?Q?SwJBdi42sjrH97/ae7TkbU+Z8YdM26lY65wCiybCEWo9GpMgnJrcYR3shZ?=
 =?iso-8859-1?Q?0EEMOD0xcjBMLwyMEY38et5jv4bzkqRRudquoVMGZU3V93Giz0qOqS0pq1?=
 =?iso-8859-1?Q?rOHi/FwFhtO48S/6bOhJkkyui6JTbTKEwg?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 c582391e-dcda-44c8-e11a-08db102e40ae
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 /0twW+5y10Hyio00Kw7y+nEr5tV3H4sWp1UhzDLiCcAn/RQQW6a/Nmuq+Ta9bNoMP1dXmpB/hfi1hd6tD/wcXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7312
X-ServerName: mail-vi1eur04on2042.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: DhrqnEV0OewufBG0zc_9Nm3nfI6WpIqa
X-Proofpoint-ORIG-GUID: DhrqnEV0OewufBG0zc_9Nm3nfI6WpIqa
Reporting-Meta:
 AAGHGJIJOvO0ycjyL7vjcdQ4L7WJhAsMSqW6TXUKngXuq7ujgPF0bRvNUtpSjgR3
 k/PT5YrtByM1pPKhO+H/mKVvh2AMvPRjgG4/wnst+Oae35VQuZHO3VL/HG+Qh71t
 vXGTBgP9TtXK7va7fbIqxPsxFBX89aMYoIsE6AQPJlpHkwphm7a/MvlvNXNMm80U
 AruomB7nLoLnWf2rHJrZt4816r1mgvM9BAJQWIuvZUXeXsAJdWGN4eBWmvMnPHbc
 cofBtqgOKuaF9G7UUPD9D6I84+JqAb1Ij7LYnub/WWFIrx68mqPM6Eskaj7UEPN3
 SIQ7h0v/PxWvSxqO3qS8QF1d3x59B2DMgnwgAd8ePZsYcT31DFB557FHXltygs4J
 zKAg7+5G4ryqa5PaKd/VeFf02GIvSYGuGxI3lN3gKQfpoaQ9Vud1NKN/WJML99fE
 ZW5jUaMwA3i5+ipkckrmJ0J/dAmEnQMXhRjBQ1BuRw24KDVjTofcqDTQ94sJL9GA
 ulCbNuOwTl0Qp6WKvnSX/dMV7r+gR+1cZphHcergH6o=

On Wed, Feb 15, 2023 at 08:04:48PM +0800, Joseph Qi wrote:
> =

> =

> On 2/15/23 6:02 PM, Heming Zhao wrote:
> > On 2/15/23 2:42 PM, Joseph Qi wrote:
> >>
> >>
> >> On 2/15/23 2:20 PM, Heming Zhao wrote:
> >>> On 2/15/23 10:06 AM, Joseph Qi wrote:
> >>>>
> >>>>
> >>>> On 2/14/23 7:48 PM, Heming Zhao wrote:
> >>>>> On Tue, Feb 14, 2023 at 07:08:16PM +0800, Joseph Qi wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> On 2/14/23 12:33 PM, Heming Zhao wrote:
> >>>>>>> On Tue, Feb 14, 2023 at 10:52:30AM +0800, Joseph Qi wrote:
> >>>>>>>> Hi, Sorry about the late reply.
> >>>>>>>> This thread is indeed a long time ago:(
> >>>>>>>> It seems that I said the two ocfs2_journal_access_di() are for d=
ifferent
> >>>>>>>> buffer head. Anyway, I have to recall the discussion before and =
get back
> >>>>>>>> to you.
> >>>>>>>>
> >>>>>>> If you belive from [a] to [b.1] doesn't need any journal protecti=
on, my patch
> >>>>>>> makes sense from theory.
> >>>>>>>
> >>>>>>> =A0=A0From code logic, if the defrag path (ocfs2_split_extent) do=
esn't call
> >>>>>>> jbd2_journal_restart(), current code is absolute correct. Increas=
ing credits
> >>>>>>> can't help avoid jbd2 assert crash, but make more easily to trigg=
er crash,
> >>>>>>> because it makes jbd2_journal_extend() more easily to return "sta=
tus > 0". In my
> >>>>>>> view, the correct fix should delete the access/dirty pair and mak=
e sure the
> >>>>>>> ocfs2_split_extent() is journal self-service.
> >>>>>>>
> >>>>>>> Different buffer head issue could be handled by rechecking ocfs2_=
split_extent(),
> >>>>>>> make sure all journal handle branches are correct. I already chec=
ked
> >>>>>>> ocfs2_split_extent, but I can't assure my eyes didn't miss any co=
rner.
> >>>>>>
> >>>>>> ocfs2_split_extent are not just 'read' operations, it may grow the=
 tree,
> >>>>>> that's why we have to do a transaction here.
> >>>>>
> >>>>> You misunderstand my meaning, my mean: from the caller __ocfs2_move=
_extent()
> >>>>> calling ocfs2_journal_access_di() (below [a]) to (before) the handl=
ing
> >>>>> ctxt.c_contig_type (below [b.1]) in ocfs2_split_extent, this area i=
s purely read
> >>>>> operations. It's the range [ [a], [b.1]) (include [a], not include =
[b.1])
> >>>>>
> >>>>> __ocfs2_move_extent
> >>>>> =A0=A0 + ocfs2_journal_access_di //[a]=A0=A0 <------+
> >>>>> =A0=A0 + ocfs2_split_extent=A0=A0=A0=A0=A0 //[b]=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 | [a, b.1) area is read operations
> >>>>> =A0=A0 |=A0 + if=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 //[b.1] <------+
> >>>>> =A0=A0 |=A0 |=A0 A
> >>>>> =A0=A0 |=A0 |=A0 +---- from this line, this func starts r/w IOs & n=
eeds jbd2 operations
> >>>>> =A0=A0 |=A0 |
> >>>>> =A0=A0 |=A0 |=A0=A0 ocfs2_replace_extent_rec()/ocfs2_split_and_inse=
rt()
> >>>>> =A0=A0 |=A0 + else
> >>>>> =A0=A0 |=A0=A0=A0=A0=A0 ocfs2_try_to_merge_extent ()
> >>>>> =A0=A0 |
> >>>>> =A0=A0 + ocfs2_journal_dirty=A0=A0=A0=A0 //[c]
> >>>>>
> >>>>>>
> >>>>>> The whole code flow:
> >>>>>> ocfs2_ioctl_move_extents
> >>>>>> =A0=A0=A0 ocfs2_move_extents
> >>>>>> =A0=A0=A0=A0=A0 __ocfs2_move_extents_range
> >>>>>> =A0=A0=A0=A0=A0=A0=A0 ocfs2_defrag_extent=A0 [1]
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_start_trans=A0 [a]
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 __ocfs2_move_extent
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_journal_access_di
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_split_extent
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_journal_dirty
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_commit_trans
> >>>>>> =A0=A0=A0=A0=A0=A0=A0 ocfs2_move_extent=A0 [2]
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_start_trans
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 __ocfs2_move_extent
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_journal_access_di
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_split_extent
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_journal_dirty
> >>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 ocfs2_commit_trans
> >>>>>> =A0=A0=A0=A0=A0 ocfs2_start_trans=A0 [b]
> >>>>>> =A0=A0=A0=A0=A0 ocfs2_journal_access_di
> >>>>>> =A0=A0=A0=A0=A0 ocfs2_journal_dirty
> >>>>>> =A0=A0=A0=A0=A0 ocfs2_commit_trans
> >>>>>>
> >>>>>> In above, [a] and [b] are different transaction start/commit pair,=
 and
> >>>>>> each allocates different journal credits, even they are operate th=
e same
> >>>>>> bh, they are still different operations.
> >>>>>
> >>>>> I agree above writing, but it can't change my conclusion: ocfs2_spl=
it_extent()
> >>>>> is journal self-service.
> >>>>
> >>>> Don't understand what does 'journal self-service' mean.
> >>>
> >>> Sorry for my English skill, I invent this word 'journal self-service'.
> >>> The meaning is: this function could handle journal operations totally=
 by itself.
> >>> Caller doesn't need to call access/dirty pair. Caller only needs to c=
all jbd2
> >>> journal start/stop pair.
> >>>
> >>> Because ocfs2_start_trans() & ocfs2_commit_trans are reenterable func=
tion,
> >>> we even could add these two func in ocfs2_split_extent(). Then any ca=
ller won't
> >>> take care of any journal operations when calling ocfs2_split_extent().
> >>>
> >>>>
> >>>>> It seems the author meaning: he wanted [a] to protect defragging ac=
tions (extents
> >>>>> changes), wanted [b] to protect inode ctime changes. the
> >>>>> ocfs2_start_trans/ocfs2_commit_trans in [a] area is necessary. but =
the
> >>>>> access/dirty pair in __ocfs2_move_extent() is potential crash risk.
> >>>>>
> >>>> If so, what is transaction [a] protect? (no dirty buffer)
> >>>
> >>> Transaction [a] protects the dirty buffers in ocfs2_split_extent().
> >>> ocfs2_split_extent() has already correctly used access/dirty pair to
> >>> mark/handle dirty buffers.
> >>>
> >> Okay, I think I've gotten your idea now. You change looks reasonable.
> >> Could you please also check if move extents without auto defrag also h=
as
> >> the same issue?
> >>
> > =

> > I have finished code checking. ocfs2_move_extent() path has the same is=
sue.
> > My patch also works fine from this code branch.
> > In theory, ocfs2_move_extent() has less opportunity to trigger crash, b=
ecause
> > userspace defrag.ocfs2 very likely set less than file size on
> > 'struct ocfs2_move_extents : me_len', if defrag.ocfs2 would support this
> > code branch.
> > =

> =

> If we write a simple program to do move extents ioctl on the same ocfs2
> (without auto defrag), can we trigger this crash?

For this question, first, I modified defrag.ocfs2 to test non-auto defrag f=
low,
and found three bugs. I will describe it at the end of this mail.

Second, I failed to trigger the crash with non-auto defrag flow.

In theory, the non-auto & auto share the same defrag path from __ocfs2_move=
_extent().
Before I send mail to start this dicussion, I had tested some days, and fai=
led
to trigger the crash. This crash, happened last year, one of SUSE customer
triggered it. But for confidence, I can't talk too much about it.

Under theory analysis, the crash derives from ocfs2_extend_trans() calling
jbd2_journal_restart() and getting return value "status > 0".

In jbd2_journal_extend(), there are only two cases (A & B) for return "valu=
e > 0".

```<A>
/* Don't extend a locked-down transaction! */
if (transaction->t_state !=3D T_RUNNING) {
    jbd2_debug(3, "denied handle %p %d blocks: "
          "transaction not running\n", handle, nblocks);
    goto error_out;
}
```

```<B>
if (wanted > journal->j_max_transaction_buffers) {
    jbd2_debug(3, "denied handle %p %d blocks: "
          "transaction too large\n", handle, nblocks);
    atomic_sub(nblocks, &transaction->t_outstanding_credits);
    goto error_out;
}
```

For case <A>, in my view, if the transaction state is not T_RUNNING, which =
should
be committing or committed by jbd2. So I did:
- generated depth 3 B+tree
- modified defragfs.ocfs2 with/without OCFS2_MOVE_EXT_FL_PART_DEFRAG.
- mount options using commit_interval=3D[1,3]
- enable some mlog(0) to output log for slowing down ocfs2 layer defrag spe=
ed.


For case <B>, I did
- generated depth 3 B+tree
- modified defragfs.ocfs2 with/without OCFS2_MOVE_EXT_FL_PART_DEFRAG.
- mount options using: resv_level=3D[0,2]  commit_interval=3D[1,3,5,30]
- running defragfs, meanwhile, running dd to issue write IOs.

Both two cases with lots of times test failed to trigger crash. I only met
ocfs2 ininite loop issue: ocfs2 kept busy all the time, the defrag job is r=
unning
all the time.


At last, I describe the three bugs for non-auto defrag flow.
The fixing code as below:

```
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 192cad0662d8..19693894aeec 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -444,7 +444,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *=
inode,
 			bg =3D (struct ocfs2_group_desc *)gd_bh->b_data;

 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {

 				*ret_bh =3D gd_bh;
 				*vict_bit =3D (vict_blkno - blkno) >>
@@ -559,6 +559,7 @@ static void ocfs2_probe_alloc_group(struct inode *inode=
, struct buffer_head *bh,
 			last_free_bits++;

 		if (last_free_bits =3D=3D move_len) {
+			i -=3D move_len;
 			*goal_bit =3D i;
 			*phys_cpos =3D base_cpos + i;
 			break;
@@ -1030,18 +1031,19 @@ int ocfs2_ioctl_move_extents(struct file *filp, voi=
d __user *argp)

 	context->range =3D &range;

+	/*
+	 * ok, the default theshold for the defragmentation
+	 * is 1M, since our maximum clustersize was 1M also.
+	 * any thought?
+	 */
+	if (!range.me_threshold)
+		range.me_threshold =3D 1024 * 1024;
+
+	if (range.me_threshold > i_size_read(inode))
+		range.me_threshold =3D i_size_read(inode);
+
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag =3D 1;
-		/*
-		 * ok, the default theshold for the defragmentation
-		 * is 1M, since our maximum clustersize was 1M also.
-		 * any thought?
-		 */
-		if (!range.me_threshold)
-			range.me_threshold =3D 1024 * 1024;
-
-		if (range.me_threshold > i_size_read(inode))
-			range.me_threshold =3D i_size_read(inode);

 		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
 			context->partial =3D 1;
```

I will file a new patch for above fix.

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
