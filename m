Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D8FC77B73
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 May 2023 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=p/48Aa3ygUtgXQw8Ua8r+AB59pA5D7nGLDPq1mz5dBI=;
 b=PD3Y4p/VgSLUBaZpkR+PB/Lj/y1hBm9c4nozZR8q1+4nP3W8pSKLTP9R/bX+DeyLLwg2W1mepXFF
   HrDBQYzO0HqjpdUmAZ1ASl9yFswuitTAgVoTpJ+2fnjnwUKNRB8JkkWY4AlkGXYoKRPxqNgYpxBP
   xVSJxa17yC2ucV2P/bvEpbS08F+2xKXffQmuT1EmkHPWiBM8npvUxvBVtgsbrmskdSmJHT/Qw57O
   ++XwpO6vhLZ80aFyvc9s1o51cSwfSAHYUA1McsYmRgJ4buj86KIH/DzAIsjHtefF7waTcKIUap7t
   uhKofWrxlDMgFN4RTWyxdGeyDSFuZxj3nmoOMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=p/48Aa3ygUtgXQw8Ua8r+AB59pA5D7nGLDPq1mz5dBI=;
 b=Np8ShMmINzC/b6CSzeHkQ/cZiipSWTDQp6q+g8BbGhES0WUDQSAG1xadUzPRXvHX4rZbrQS1m1E/
   56Enhf0OBD5grdsWusx5S6wWKC2gBdW+1MRTIEDkXwR6wKtyaWQr6XS3Q0t2f3tUzdcHUIFmK4CU
   jwMKPxfj/jMi5+Tjrp4v/+XAAhA5VOl25ah0+z+RpjY8SuWxDC+1+YO4exBwqLHTmj1kWyrj/bF2
   N5nYTTQs7B5SsqyMOFSxvcHLWQS+FNvavpWeFqBp7cHBYWstpHGKf3qGCneiqCHsi92X8HHa+y2z
   hTxwKqyZh5Csc+DbAKhhmC6+dn5f5ujLYZAAkQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTZ009HACCZPW80@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 May 2023 12:36:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGrpFvrfS5GWZQx84uW5lQ8wKrBeI4N871FT8AxDCU84Fm8BEISC7it2agIYQbvm+49jLJo7tPVHqGRI8nDv74y5a3v6rh8CYxmbiS/l0iGQ+rNyfaCgMBrTIAY+RkBU4T7csJSkauJVjTbeM6QXQtcm5YVKJZRgh6rojpqZsBrBTB28lFyJZjDVOcUr4zbdorYJUum5t9g3UB/m+wXSAHW1ArO2lXNnuWaQg8LQvkqEcZ72a+13nM0QzX5lmzla7TEGxXMcmUfgeKHBNGO+6+thyWzv8wc3X/SrpCPq3YuTHOdX88wjhaZZvN/YDlNw82Z7Ecdx6fxUeIP8M5PdKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=724/+FkD8fD6RYfyJgqLtrsQgTbgd5SKY+VAKeIEcxE=;
 b=DHQ4FV2VAVm1yuGqZD69nVeScZlMWB2IbCqQ/dK5pA4dcnTnIm/ymLJVbzJUbqmrCcAK0i05O3PsfCQ5AXs6hIqlHgT0wjnw+ptCcMdMvWFIVp6k38y0pNNoYxQF2ynuvBgI57NAlqGP5YUbPdlq3rt3sMXNVTCaed2zhzMryNA6ZonaiYvMiQ3DvE/+uj6PVe+9NJrGZ5lLXMiCpehYCOoBq6svg/vBnJh5ak5waoDfJPfxTMygNAjA3pM0390Qu7eotE0j5cLV/ZLcEfYD80n4ogBXh5P1ZuYIwQYuh7SNEr1Md8qKamyz1M9fW73+NSQ4RJ4ZTh7VoxODI1txGg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=724/+FkD8fD6RYfyJgqLtrsQgTbgd5SKY+VAKeIEcxE=;
 b=xP6bMuI2mi2WvXDFNT075qDymC8dgR8eu8lt5qZugWqalOhq7MBneNwnEDwKyD5ufPJjFNi1aLXr2QbByyYyPFy+Rhu/TWhtQRkhaEf2iOaYo1eDzrAiOBjWvxEvyN/0AODSeOvizj7usyfZorwcaTYLIXbtoKj9eZd94Zaj61qlpBMBSdmGflzLNw3h2tlEAQgRRTgJeDfBPpuM2+acjcr6YjpW4kTuvX+tqz70DcjRNeCMF1eaEscxlin+UR1qQl+7kxLURBfTag5TN3RhMURGNKL8mzSMB0+c6aar+G4hRbWMKR9f20ZhuFfFPPN0Y43bYBtSMyJniM7+QRCArw==
Date: Mon, 1 May 2023 20:35:57 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230501123557.5ug5vn5chmzbgenr@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
 <20230501022628.avrcx3exv3nev3fl@c73>
 <d9d1fc18-39d8-2888-c540-faac2d3f5628@linux.alibaba.com>
 <20230501030958.ps6xssjcvu6pnpnl@c73>
 <2254db82-10cc-50a7-6cb9-5344e294a3eb@linux.alibaba.com>
 <20230501045153.h5co2zn66q2unlsw@c73>
 <b395014f-4096-4471-f2ea-c6e7de6f59a8@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <b395014f-4096-4471-f2ea-c6e7de6f59a8@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199021)(316002)(8936002)(38100700002)(478600001)(8676002)(86362001)(66556008)(6916009)(66476007)(4326008)(66946007)(41300700001)(2906002)(83380400001)(44832011)(30864003)(6506007)(186003)(9686003)(53546011)(6512007)(1076003)(26005)(33716001)(6486002)(5660300002)(6666004);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 12:36:06.2562 (UTC)
X-Source-IP: 40.107.7.85
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10697
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=100 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 clxscore=180 adultscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305010100 domainage_hfrom=9715
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
X-ClientProxiedBy: TYCP286CA0083.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::11) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|PAXPR04MB8125:EE_
X-MS-Office365-Filtering-Correlation-Id: a694c441-92a5-45d3-efab-08db4a40a210
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 kM0/TR1jF6gFF1V5Q/M4xdKlOxAqHZNXo8eJjxKBHAM9wvxZQddu5Xi95lTPLIb331cZ9d3RiUiE6xnkto9lE07nsFKFpmLu50s1AC3jNfi7OreM4/4lUx1iXZ1ZFfI+7mUGCT2DDaWRZESFZeryTUbQAz7oe7zDRcwMuJJkbHMYKsW4xdWU/ciWfVtmmJAvr1Tw1d5ctdGzA5qbrLA6WvfDZY6Rlo6iMP+R9bm11I8NrLSw66O+xq8nB8qRSZvuQvNSSdzCBi3D/ZNeII5JFquke9rZYnLzlVNScQI7kP+90scJ/SidfjkJQBrF+VgVSvsG/2xbEo9HDDg+Jsh2O+VJTFR0MNZyuZnPVywW9wCKuVd3SUhfdq7t2SWfbYBU9RvNpQhkI4zJXH54dmlMnWmgnJJk5TFh1M3JDKOnVxLs2G8cbPUkavqPN2DyrMJYtb/kiuOsBTtoqjcUXYsxPME/qkvqtuv7SBgh4wGaYdVIw6qpIb9f+8Uw++RpsqgTl+hLMzc0mwf6n+8t/A0jrotfGxJofIX9Q7zuiEzQdFoqu8O5jczz2hl41dn2XyVy
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?LZdRrC4r+BrMmTK8iUge3cG+7OcH0GgeDKjBk7RIUxNY6D4n9ZXnWzSQJS4i?=
 =?us-ascii?Q?WmEfuK95sbsB6v77aWMfiOfK3tnOUxEbBWVe1EA7Jl/y6AHLX9vMQgjw0cwE?=
 =?us-ascii?Q?rdkmSLGUhICS+Vfo+ukD9r7JnjEfhMe7yTqe3cBL6t6NFV8gWvOQ2XkJdBoE?=
 =?us-ascii?Q?OF96u0iX2mQqQOxBQPjQyhYW3ZgWqG8zxlvdWWXk1aH0YT0967477cLOlYaV?=
 =?us-ascii?Q?YzLDMX/KkvJ1TrAz4oPesvE1UbV90ojL0L+KlaFG6yJfPr6g91HiFT/A7Cg4?=
 =?us-ascii?Q?Ik9bMUQ1u1CLW/zeL+DACpLc/DLYkXwLkm5D4LahszgcXcHRhy8TsSBjGp+Z?=
 =?us-ascii?Q?oUGX9zTw18mRuig/few4nzzdtnSz3nuBybadj5Y0w8OJzLAEYzw1NJCiYhZq?=
 =?us-ascii?Q?k/5Ss3etzd42D7CJUlM+tvr7i++wBujMIGsQtinoZneIoCCvyl34nWGfje4L?=
 =?us-ascii?Q?2msvpa004/XYv03CsKlkZnGA+fvqCpGFxmKtkk8K3Yco6R8ZcCQw7d/iAOOm?=
 =?us-ascii?Q?PwuwHOD32Qllktg8Liys/IwVq3f6P+7yhK5+uQb+rWfECwhEUk7/btYEPVE2?=
 =?us-ascii?Q?/45Q2uml6a5YFO20oIxEUZWzD9lEySeTUNqmCYRtrCdUpxFodsbPDM3ZJQfp?=
 =?us-ascii?Q?RpA6IGadJsahNfFkHfFro7jI9Y2f1mR9i2RZyhwYYHpa0VBit3PbjVYK2gHp?=
 =?us-ascii?Q?kPB2ufMrYYqjvdXoI77GzGd6Zh4JsEWkEJPeopG8LLg6WzojGnT38i8pUoiv?=
 =?us-ascii?Q?BLrPqCZ4i63zVNZcW4HNCNUiZXv22CYKzGJuFHvNvWQCzHnHPLGAIDPGtGEF?=
 =?us-ascii?Q?0Zhu4HeG3h1TA5aHdWRuJHqEKRVsbNZmUO3e+MYqJpsZ/zutYN4ntJ9Em5mQ?=
 =?us-ascii?Q?ZwJCChVB1uk6laoI63GNtBXI5c/HCspKJk8I9C0GjoM3hTty7MsmIK8W0fNt?=
 =?us-ascii?Q?EXbfVKoQIJcaCTjhagcZkj/kRS6BD5eFH0S8J9UtTDYNWb2M9+ZOVk3q6A6u?=
 =?us-ascii?Q?jsdfP7KucOimJ4FetbLh9xXA0qH+aYG4c5szGoxHERlyiBo44qfXTW1NxPWf?=
 =?us-ascii?Q?pa7mU/Xpsy2aFSxIJo63z5V7BW5ZOWgGsnLGvTi+vs8hdx04CYzftflj+LK2?=
 =?us-ascii?Q?iFJqdBuj/sgLrGns5gLpx89daE3QLlIGLlK1Mwa6y5wRHXQ1UHHKAn8Y5cp7?=
 =?us-ascii?Q?ITUV/4gcpC8UHmO0heeyjq2+kqn8MjsvMN+maGmIWxOJGxQFCRIDigVvE/zH?=
 =?us-ascii?Q?sy3vaabpHfd43UgXLJlyxQNFqqFQU1Z6l3OpjqB9NuOV91yN2Xp+asy55bnK?=
 =?us-ascii?Q?QFmXnkGCun/n4kbOlPX24hWuXvXXk1z9tj81s7ye9UNjBkDjr1BbaY5e+uU6?=
 =?us-ascii?Q?9l8gvQrnMgn4d7kbUccx4wwniDuFx0WO+PrIeTMV311O9ipHMXZ7/XxXejpi?=
 =?us-ascii?Q?VS2brVk35OX8NRtnFwvnXqkofyLFJy77GE8bqUSIyyhDFjF2G4+CjNbaBSJS?=
 =?us-ascii?Q?c6RiV9pRD3likZKM0dcVMLpcbM9CjIscxo10EUTBH8C/smmpFthFMG+dPI8Q?=
 =?us-ascii?Q?gZUfD/osFIZUpRtj89wRyXk5eXPa1kOTk9uSj8jA?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 a694c441-92a5-45d3-efab-08db4a40a210
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 rfgvck/DN1jWVK1NoUL+DjdRHnsBV+zIGTRqt2DcF4GVTqUedNIfXNFkNOYCJq2oKIT68rnkZF3V0C3ac/r6rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8125
X-ServerName: mail-he1eur04on2085.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: nq540DpNaHSkzrSHZhj1mzaX_2VVI8Zk
X-Proofpoint-ORIG-GUID: nq540DpNaHSkzrSHZhj1mzaX_2VVI8Zk
Reporting-Meta:
 AAERgPgD3wC40oCXT2tJgRc/oQNHncJDWixstXOgK/MPuG3wl14p8R9ku/QBjmlS
 ku0Lq2FuBq5LP8LHfmXX7G3RTyT1jHAd4Xv3WkisqSN/PDnBkKojHO3bm6oe2k8d
 lzLyIH3doyQmFvy45aSJZ+ooJMLSB8pRCO6S5lO/SPBeU+pLk/S16tiP5QyDu1KE
 5ZZzLHzZQzssUuNIeT8EBbKCcS17ARXu8qu9tUJZxKYORgpZMFbBnXtfLLCgHTcE
 aSyswRiwKo/J1HtAJ7v/BEC8IgFkHUv0BrLmrkNolDvciGqL1cEkEIfJk1m7B32t
 J401LFR0yU0MVGPATYQ9Fyp2myIdQ+S3xJEuDDbtNbOyuKL7TOG4xAxSVSbXfQGP
 WeBdDLNL5lTCmR94T8LOuGVsoEy1RfzlU4Rb8SxiU+QdG7Q1HtEUtqZl8ZBkN/t8
 bdMc3flnxjCOrY5L+FE+YAsyvHQ2ALDbdzOEitcwwSB9w4dAFXbKzQ91Ne79cyvH
 aK0FVTd6ICcbXKeij25Ow9YiEWZVioEfBRbPBl4xbqy2

On Mon, May 01, 2023 at 07:44:42PM +0800, Joseph Qi wrote:
> 
> 
> On 5/1/23 12:51 PM, Heming Zhao wrote:
> > On Mon, May 01, 2023 at 11:21:15AM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 5/1/23 11:09 AM, Heming Zhao wrote:
> >>> On Mon, May 01, 2023 at 10:52:13AM +0800, Joseph Qi wrote:
> >>>>
> >>>>
> >>>> On 5/1/23 10:26 AM, Heming Zhao wrote:
> >>>>> On Mon, May 01, 2023 at 10:07:34AM +0800, Joseph Qi wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> What's the journal status in this case?
> >>>>> jbd2 is marked with JBD2_ABORT
> >>>>>
> >>>>>> I wonder why commit thread is not working, which should flush journal
> >>>>>> and reset j_num_trans during commit cache.
> >>>>> The reason is in my above answer.
> >>>>>
> >>>>> below is the dmesg log for No. 266.
> >>>>>
> >>>>> ```
> >>>>> [  595.071807] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> >>>>> [  595.080950] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> >>>>> [  595.081091] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> >>>>> [  595.081580] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> >>>>> [  595.081886] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> >>>>> [  595.082173] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> >>>>> [  595.082420] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> >>>>> [  595.082696] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> >>>>> [  595.082932] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> >>>>> [  595.083188] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> >>>>> [  595.084721] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> >>>>> [  595.095436] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> >>>>> [  595.787078] systemd[1]: Started /usr/bin/bash -c exit 77.
> >>>>> [  595.802650] systemd[1]: fstests-check.scope: Deactivated successfully.
> >>>>> [  596.195734] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: joining the lockspace group...
> >>>>> [  596.206310] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> >>>>> [  596.206350] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1
> >>>>> [  596.209667] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: add member 1
> >>>>> [  596.211433] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_members 1 nodes
> >>>>> [  596.213942] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: generation 1 slots 1 1:1
> >>>>> [  596.215668] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory
> >>>>> [  596.217171] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 in 0 new
> >>>>> [  596.218253] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 out 0 messages
> >>>>> [  596.219401] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1 generation 1 done: 0 ms
> >>>>> [  596.220628] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: join complete
> >>>>> [  596.224616] kernel: JBD2: Ignoring recovery information on journal
> >>>>> [  596.229686] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> >>>>> [  596.870008] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>>>> [  596.236135] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: leaving the lockspace group...
> >>>>> [  596.237431] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> >>>>> [  596.239442] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: release_lockspace final free
> >>>>> [  596.877286] ocfs2_hb_ctl[5436]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 78CE18109AE44E6AA896722A5E25CFC0
> >>>>> [  596.248299] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> >>>>> [  596.255888] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: leaving the lockspace group...
> >>>>> [  596.905718] systemd[1]: fstest-test.mount: Deactivated successfully.
> >>>>> [  596.280602] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> >>>>> [  596.281762] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: release_lockspace final free
> >>>>> [  596.921672] ocfs2_hb_ctl[5448]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 838DD74847E34AA1839D6C4AA31132F1
> >>>>> [  596.299507] kernel: ocfs2: Unmounting device (253,16) on (node 1)
> >>>>> [  596.481755] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> >>>>> [  596.484722] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> >>>>> [  596.484729] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> >>>>> [  596.485361] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> >>>>> [  596.485622] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> >>>>> [  596.485861] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> >>>>> [  596.486063] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> >>>>> [  596.486293] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> >>>>> [  596.486498] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> >>>>> [  596.486768] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> >>>>> [  596.487037] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> >>>>> [  596.491655] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> >>>>> [  597.139758] root[5475]: run xfstest generic/266
> >>>>> [  596.505896] unknown: run fstests generic/266 at 2023-05-01 10:19:02
> >>>>> [  597.186885] systemd[1]: Started /usr/bin/bash -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec ./tests/generic/266.
> >>>>> [  597.566466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> >>>>> [  597.579759] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> >>>>> [  597.579766] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> >>>>> [  597.581004] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> >>>>> [  597.581820] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> >>>>> [  597.582292] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> >>>>> [  597.582894] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> >>>>> [  597.583423] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> >>>>> [  597.583991] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> >>>>> [  597.584547] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 4 ms
> >>>>> [  597.585079] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> >>>>> [  597.590136] kernel: JBD2: Ignoring recovery information on journal
> >>>>> [  597.594258] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> >>>>> [  598.239046] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>>>> [  597.606575] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: leaving the lockspace group...
> >>>>> [  597.607446] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> >>>>> [  598.244507] ocfs2_hb_ctl[5680]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u AB0245F740984C25A9D0907D61DFCF8A
> >>>>> [  597.607843] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: release_lockspace final free
> >>>>> [  597.615474] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> >>>>> [  597.641624] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> >>>>> [  597.659435] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> >>>>> [  597.659479] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> >>>>> [  597.661482] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> >>>>> [  597.662340] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> >>>>> [  597.663211] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> >>>>> [  597.664150] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> >>>>> [  597.665466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> >>>>> [  597.666370] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> >>>>> [  597.667235] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 0 ms
> >>>>> [  597.668428] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> >>>>> [  600.194974] systemd[1]: Started Daily Cleanup of Snapper Snapshots.
> >>>>> [  600.207227] dbus-daemon[672]: [system] Activating via systemd: service name='org.opensuse.Snapper' unit='snapperd.service' requested by ':1.10' (uid=0 pid=5728 comm="/usr/lib/snapper/systemd-helper --cleanup")
> >>>>> [  600.209151] systemd[1]: Starting DBus interface for snapper...
> >>>>> [  600.217270] dbus-daemon[672]: [system] Successfully activated service 'org.opensuse.Snapper'
> >>>>> [  600.217370] systemd[1]: Started DBus interface for snapper.
> >>>>> [  600.218969] systemd[1]: snapper-cleanup.service: Deactivated successfully.
> >>>>> [  599.608010] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> >>>>> [  599.611041] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> >>>>> [  599.611127] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> >>>>> [  599.611813] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> >>>>> [  599.612019] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> >>>>> [  599.612227] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> >>>>> [  599.612397] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> >>>>> [  599.612559] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> >>>>> [  599.612712] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> >>>>> [  599.612880] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 0 ms
> >>>>> [  599.613078] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> >>>>> [  599.615320] kernel: JBD2: Ignoring recovery information on journal
> >>>>> [  599.619221] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> >>>>> [  600.392044] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>>>> [  599.780111] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: leaving the lockspace group...
> >>>>> [  599.781949] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> >>>>> [  599.784235] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: release_lockspace final free
> >>>>> [  600.426136] ocfs2_hb_ctl[5762]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u F06626AE7D754F11A0211679C145C8BF
> >>>>> [  599.808566] kernel: ocfs2: Unmounting device (254,0) on (node 1)
> >>>>> [  599.827803] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> >>>>> [  599.832848] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> >>>>> [  599.832984] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> >>>>> [  599.833810] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> >>>>> [  599.834272] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> >>>>> [  599.834663] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> >>>>> [  599.835030] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> >>>>> [  599.835474] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> >>>>> [  599.835868] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> >>>>> [  599.836365] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 4 ms
> >>>>> [  599.836829] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> >>>>> [  599.845790] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> >>>>> [  600.079285] kernel: Buffer I/O error on dev dm-0, logical block 2621424, async page read
> >>>>> [  600.090845] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>>>> [  600.091387] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>>>> [  600.091924] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> >>>>> [  600.092422] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> >>>>> [  600.094252] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>>>> [  600.095029] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>>>> [  600.095891] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> >>>>> [  600.096698] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> >>>>> [  600.099071] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>>>> [  600.099957] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>>>> [  600.100798] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> >>>>> [  600.101623] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> >>>>> [  600.107094] kernel: (xfs_io,5785,1):ocfs2_get_refcount_tree:358 ERROR: status = -5
> >>>>> [  600.107659] kernel: (xfs_io,5785,1):ocfs2_lock_refcount_tree:456 ERROR: status = -5
> >>>>> [  600.108175] kernel: (xfs_io,5785,1):ocfs2_refcount_cow_hunk:3417 ERROR: status = -5
> >>>>> [  600.108654] kernel: (xfs_io,5785,1):ocfs2_refcount_cow:3478 ERROR: status = -5
> >>>>> [  600.109128] kernel: (xfs_io,5785,1):ocfs2_prepare_inode_for_write:2326 ERROR: status = -5
> >>>>> [  600.109613] kernel: (xfs_io,5785,1):ocfs2_file_write_iter:2433 ERROR: status = -5
> >>>>> [  600.118113] kernel: (umount,5789,3):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>>>> [  600.118481] kernel: (umount,5789,3):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>>>> [  600.118898] kernel: (umount,5789,3):ocfs2_statfs:1654 ERROR: status = -5
> >>>>> [  600.119364] kernel: (umount,5789,3):ocfs2_statfs:1686 ERROR: status = -5
> >>>>> [  600.759255] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>>>> [  600.127135] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> >>>>> [  600.127373] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> >>>>> [  600.127615] kernel: Aborting journal on device dm-0-24.
> >>>>> [  600.127893] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> >>>>> [  600.128137] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> >>>>> [  600.128362] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  600.128591] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> >>>>> [  601.147704] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  602.171745] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  603.195707] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  604.219709] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  605.243712] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  606.267748] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  607.291715] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  608.315742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  609.339724] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  610.363774] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  611.387693] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  612.411727] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  613.435719] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  614.459743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  615.483742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  615.484503] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> >>>>> [  616.507742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  617.531751] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  618.555743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  619.579702] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> [  620.603758] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>>>> ^C
> >>>>> tb-fstest1:/usr/src/linux/fs/ocfs2 #
> >>>>> ```
> >>>>
> >>>> So the case is, flush journal in commit thread will never end if journal
> >>>> is abort, and then lead to umount hang since commit thread won't stop,
> >>>> right?
> >>> Yes.
> >>>
> >>>>
> >>>> If so, I don't think your changes in sync fs is a right solution. It
> >>>> seems it just for bypassing the testcase.
> >>> No. 
> >>> In my view, No. 266 shouldn't trigger jbd2 ABORT status. The 'sync' should
> >>> tidy up all already issued write IOs. After sync & load dm-error, new write IOs
> >>> fails on rw IOs, which shouldn't generate any journal IOs and shouldn't trigger
> >>> jbd2 to enter ABORT status.
> >>>
> >>
> >> What if there is no 'sync' in this case?
> > 
> > It is same with issuing 'sync' case. Please differ:
> > 'after [  600.079285] in above log' vs. 'after [  207.623776] in below log'
> >I mean your solution is to reset j_num_trans in sync fs, but in case of
> no 'sync', how do you resolve it?

If I understand your question correctly, your meaning is to remove No. 266
'sync' line, then how to handle this case.
My answer is this is my patch [2/2] job. I have tested it already.

- Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
