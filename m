Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB687C77B78
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Apr 2023 08:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qFgEflcXdL6ivG9z935Lv+gqHXaLjNaL9CoA1Pr+MNE=;
 b=x7/QNJfBGpdjaMGrNsssj5xSspsdiulTNCF1Xp3LNMUbAT9qD46E8bjVPGjc9AkLHnRMOeod2n9E
   Tb64ns+5V8ehdHUMUZyzHjAhihpgc/MV4OLZteMrjA7tl/3m1cMgC2L+I/JXeD9ifP5yYNwkvjAi
   FGZ+YBrnQSEhQ+WO6I+xyk/5hzma/icbdv4vMllMyPLTLv8cMb69z4b2gjgS+mHIHIQpq4iRSEqs
   olKgK9lppA6XaBImEDEBfTM3MMnKY5smfytHM+Q0sE+nz9+XhOloLw9l34g73k9Xgr8yuNV3JOY9
   HMvH3Z1+t5BJ9K/st82Fu5tGumxb1p+64hMY/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qFgEflcXdL6ivG9z935Lv+gqHXaLjNaL9CoA1Pr+MNE=;
 b=gTlwZwWOxtfKDJha5NUPgqINlBlJqAZoA1fvG6EtrXXWsDf6MOGd5JP5ZxFs84Ci4oJuBhh/a4x8
   oYQ5BOfUw46PxsDni8q8oAdXBu6Hb2sgzaGJnZlCtEwxMUPgFWerZVeJfZZYpqR3BlQYLeXi7vL9
   ufGDyaMFXP8S7XpWqMwpL+XpWdMaScXBxP2/NXIYOZtSaMl5BW70rxSE8fv7r1na3zAcCX3PB7MR
   w5ik10fPJm4yp8HZqmx3cwjJy3ZEGrSKlPgpUc8xSrhzSpQbT+2nzzYqvb3XUhhd2QU9rL3Ls/dY
   fRF+p0KczwxoTKf38BHSAgry9IiwWcUfiIwP/A==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTG007WHGZ63J60@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Apr 2023 08:01:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAj29M9nX9Xo4j0RSl/EJvQS0Wu9DBT7BAx/VlmAS4LoOEGLc0aAyMgK4P0nh2++F0yVZaYljbAiAXsFIMRBDFrDWFbs8WsmrGk4mzFxQleksUO49U5zx+XX5tj/tmlGA4nXcE+Z34K6H5AI6tsSUY5XzrbRMjdUuj4NJttNOcQEpKgBvURCZtjDUnXWe4gAdzazecl/JKJHvYNAipoddj04fUMasH8QJ1OH+NYfS8zQm60K0ontyNfi2vH/CJkYrBfB32kO7lqVUkgeM1DpGzW6Q4Ee97z5T5O3MRc2C4CZbPnBEE4AwcV+/uFTwwMJgyoNu4QGgpGlLteuo0kDtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgOHMq5DugEXbSp+wekQQostHJWy5NjRHxHfwUqcX30=;
 b=VLN3j8lkLCo9sngNfEha+oKr7QTyrQiomR0wsExmoEXdJPZApPYRdinheYqaL6iDc/Lcn7VpoHMfWXjY86W22D04a7jd2kJ65+nr6z8GJJLSBw3uUsmZnMBXyYSC23qG6jEsdhCnK5V+E1sU364RJfE36NjEeD3E0lvxVn9xnm01joZlWXurg6IbBFci+OTfrB9ESzR51fRm1Y13IlujV7R8uyprytd0FpCNwivRljfsGRZijQnG31Yfsm6xeoVqiaY2+K+HFCSVI4Ezip+L27jiQUq9fLHFll/fzKSnbwolqXvfv+Eru4VuEH40dc9Mjpd+7xzeAQE6HqMj5ABmKw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgOHMq5DugEXbSp+wekQQostHJWy5NjRHxHfwUqcX30=;
 b=ltVXbjs/d9U12LY6wEJafC3l4+ukgbXUQ0SfbCngrYwK5l4DdcG8pZb0Oe55lSfTW/pUTiqROZAJR4hf4H2LLkD1Ruxf+4eaK2HY2NAY01h2vm/z6EKijI/YBBOhcjq+4WltQHqQv54ktUYkmlhiP5onhqGpE8Zs/DkDdZAeKtnWwlwqGYp6wjZ/M1mxFRMKP5xyAsPu/xp5O8YrrlXdgozQ8GDj+mPHRlKlqBWBl7ok0tOp5UQr17KsGG0iDRgaRsv2egKN7F4IR1hLeFh8OQLgkZE8WekXgAkgmV9x5J1iE9jGwjFSEcdwnrvcRIImKD2iNrZjlzPG6CXTomFZjQ==
Date: Fri, 21 Apr 2023 16:01:29 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230421080129.wkp2bebqlw6mizo3@c73>
References: <20230406154052.9863-1-heming.zhao@suse.com>
 <c5034daa-056a-7603-daaa-3db5138bd3b6@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <c5034daa-056a-7603-daaa-3db5138bd3b6@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199021)(2906002)(66476007)(6916009)(316002)(4326008)(66946007)(66556008)(966005)(478600001)(6486002)(6666004)(8936002)(41300700001)(5660300002)(8676002)(33716001)(44832011)(86362001)(38100700002)(9686003)(6506007)(1076003)(26005)(53546011)(186003)(6512007)(83380400001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 08:01:38.0385 (UTC)
X-Source-IP: 40.107.22.82
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10686
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=177
 adultscore=0 mlxlogscore=999 priorityscore=85 malwarescore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210069 domainage_hfrom=9705
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Fix wrong search logic in
	__ocfs2_resv_find_window
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
X-ClientProxiedBy: SG3P274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::15)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM0PR04MB7041:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bf0cd04-5b05-4e2a-b27b-08db423ea21e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 gpQPg/nLJMo36GpMnA+jqAnbIBAAMP8lMoL0onoSIFMidEHPNC/AHaZ41gWzI9yIdA+GHgeTh8t+IHWtSaVp00GeT+Yx/Ofjto9YEGCnVJTVN79kq0eLGjmLCStKRWxObAQYMMAiUlQTKYdALinrE41pxvNJu/kfVhPeWgRhyU3ittDlhaHc9H1QgVIZz3NleCCU8q6IOR1QQFFuSihGdolXCh9D2Xqk313biz/OsS7NQOniHInppICG2E0HfB+D/FEnMdQa9MmGKwrPhGpNhb0bQaYhaflNgqbLeztCbIHJClcLnMPL0HPEcm77jKWLrsYzF4WvRnsQ27Al1Y6UZ/cJZruLdB7gZ5f1p4Rvzi/lkRVU2yb1OEiGy+6NdJ9GL3pEXWEx+qOEEXB8k8y9HXWXcfpJsLNDVkyL3vLbU8WnMVchZkNYquYuXbw+B2NBFvifjxYSzBto8n5+SiZuZ8OnGeblmhOImGZ8ta3EWIjO1nJQjzWLFI6mFOVZAuJbzIBndWuGbMaLk8Q+pxa9CWSwNx2SKdn2YSj1LcmSlAA=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?0euUR2DyPzz9YcVu2C0jDfJRK++G3DHIV6XtCofMsubclyIhXR/y17gcVxen?=
 =?us-ascii?Q?8TFnTXWIaZdY/iJhC8JuIHQGu30MCBr+rbGcMOmlDgEF0qnsdZ/fa1q/EUz2?=
 =?us-ascii?Q?qAMnX47+YtAhLcms1ybQlAg3+78zNEvA17aRGFW5Vo/FnKhVH8lQVlRMEqiT?=
 =?us-ascii?Q?SXRzdANjLt43vhKkJ2GeIMdC8UV5Fa45baivWDFLxutzwaA5wXbBjxyxjYlK?=
 =?us-ascii?Q?8MKMpxLlamXLnpqWFhSzrCi/s/cUo9g33xbtfi/xx4tUcqULrOdOj13h5Vlw?=
 =?us-ascii?Q?I6NOV7OC/6zIJYY6MM+f0T5S+Eno+O9YL65KLDvLa+v5XsvscBKxIlnbn4aq?=
 =?us-ascii?Q?eid5oxh7Yt2E+04qvm6sZJZadZdWwwEMz6679fdZjOUhnHmglOAXfkF/lvL0?=
 =?us-ascii?Q?AoQCkraPXogotLNHEXRIijjXSEPlsvEEO/0hd64Asi5KMUD/sNkcbKio7yhx?=
 =?us-ascii?Q?MM55pcF4rNNylfrH1vI2zB/9dmfOCp+e9XT2EDq5ZTGZT311mMI5iYd253d7?=
 =?us-ascii?Q?KfAY98BPnzvuPi+D7e7NtK+kSt8XYGSvb+iiHVAzPFEfz2XikgjsE+1jiFrW?=
 =?us-ascii?Q?5r9zAeuXvFjSNsSLZKXYYOJkhaW3FPVgvGU2Wlfw+i5cvd6XyJMpXGlr00tT?=
 =?us-ascii?Q?rInEUwN+tRE3YxRNFIb6sOXZfiP+VBGCHz+TASP/Un+adaI01BYPR68cJR+X?=
 =?us-ascii?Q?UBomPKuQOMlfKJa+nlFQ7tC3zMex1CzHoFlQr+CVOicSMWxNp9nK9A2hbQ7R?=
 =?us-ascii?Q?kiExkqlbV3GEQ0rNFaNtXqmVWmFsRsZIv/HwbssVDj8iLfshkvK0bWjOAxxv?=
 =?us-ascii?Q?GkRlLHJAEuUHuIzX0ihlKh99OzIZK99U+J0w+iEA64QVDd67aVxkBoran1aF?=
 =?us-ascii?Q?nUtS74JBbnhmJW1dUghPEOIwEcMPnmYeBEnJhcQLUcP5LDWS4BqmQUOc94y6?=
 =?us-ascii?Q?HVyD5uHv+HeWJbbG06XSET2RXO+mw5urGOZ39aNixZB+RcR2buAiimZHTyW8?=
 =?us-ascii?Q?43NSLx4DR2Fq2Bzvis0d/+ovU3+HzX6lBp2zNOQisxKnBbximZRV/jcSGrvd?=
 =?us-ascii?Q?Ty8VCMFAPYnkW/c42ba67s8G4JJRZkxcyySRMlj5D90ggR7LVcRjpKmDeGYN?=
 =?us-ascii?Q?6C9XOTB7Ky74CwvHtGVwWomB9SphwtQrW7eAsIbQs3p5bsyr0InkYl+k1tHI?=
 =?us-ascii?Q?BDF3EjTiEdgoH+p1ouJJT3+OGl4Wa1cbugEQnhCGORHxW7H7owFXX/vxbUUi?=
 =?us-ascii?Q?7ZDCJEOmxMbo+A3yeDIcbTa02g6IhdqN8HHt0I2HKicFk52W37CN+P7l4TYw?=
 =?us-ascii?Q?fdqLpDJD1ugVbs6uvU6IkJJTw+OTRYZ1gF0J/LqJtANYOLH5sqte1FB7skkH?=
 =?us-ascii?Q?cV4luz3NVD/q8hoFHehUClftTcK8NgLp3m86HRXXfCbBx9Bni0HeyQ+wW1XJ?=
 =?us-ascii?Q?+JIPZZg/jPPsu+Mxd6XlgogYY2RQlmW+MU5af7YqFfg2u+Rpf1TbBW3bWvKl?=
 =?us-ascii?Q?lCZ9CaKrt13OKAd/BoIucxfbMInbs32nnpt5tgP9OqNWSpYbEy0tmA78aqXy?=
 =?us-ascii?Q?TjczLHm2edVICpuNx/bqUG1+56qgeO67UaNWX7cQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 1bf0cd04-5b05-4e2a-b27b-08db423ea21e
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 9cdg5MP3ymhpt4x7O4CUAT/qfdoXpcZw4ogNIIAyzfa62lvjMBQUQmwcCfnJYGzQMMVnGybVwOUA2Km97RZqbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7041
X-ServerName: mail-am6eur05on2082.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Q8fdaZjzXxHjIyL1mQiDwBs0vc4fzfXl
X-Proofpoint-GUID: Q8fdaZjzXxHjIyL1mQiDwBs0vc4fzfXl
Reporting-Meta:
 AAElkQXURtiVqTrvJun3sAuRaiitLgYnvY6XIECoTFspFMcGKfuxRnJHis+5wkpr
 GFiblEyBhI8L3Zq1ooKT3aoVSoftjjBSxgfoUApm1/Ti/wJ1WzOJrpvIF+UOsS8/
 StdWwRFT6ieXbD9WgC8rMev19fN5K2v4UUu7zNHXS2PE0XTGC56K3ioAA5faacTz
 ec6t4a7A/gzWZN5KcNdKyZl1poCCuN1FjkAPYygHPTQVPVMyxXN9NO/uUOaKKrr4
 U1ZTg9oAaJa3VuHp5en+667qZ666Ou1z8Csnb4tHu5ysSFFKGLnILzxhnUon1K63
 ldQ/o5ivzkfcHwuKTN9jk8Vh/6XGhVob1MAGcWtwhkYqs/s/y+9074U27yBLkoXc
 PhnoGAK+EOw1UA+7vL75k6tctgxexNNtFU19fFI8VXIickPX/o09SY4vlY76jwpu
 ZfStNrtgcAQjT8u3qIUId6FXvvI7UE4B4fuGR34/WHllJhIImRAUO20dv8J01JQ4
 u7NIorOcGPJ+XjjGZVmetWGTBXIbxp5mQJHnmsMJpGyg

On Fri, Apr 21, 2023 at 03:35:01PM +0800, Joseph Qi wrote:
> Hi,
> Could you please share a reproducer?
> 

Anyone could access & download the URL [1] (I wrote it in patch commit log)
without register SUSE account.

Please check attachment file, which I downloaded from [1] and modified under
the BZ comment 1. The trigger method is also in comment 1, I copy here:
./defragfs_test.sh -d /dev/vdf -m /mnt -n ocfstst -s pcmk -o /tmp -b 1024 -c 8192

note: you may modify '-n' (cluster name) & -s' (cluster stack).

[1]: https://bugzilla.suse.com/show_bug.cgi?id=1131931

Thanks,
Heming

> 
> On 4/6/23 11:40 PM, Heming Zhao wrote:
> > ** problem **
> > 
> > Current code triggers a defragfs bug [1]:
> > 
> > ```
> > tw-tst:~ # defragfs.ocfs2 /mnt/test_from_dd1
> > defragfs.ocfs2 1.8.7
> > [ERROR]Move extent failed:"/mnt/test_from_dd1" - No space left on device
> > [ERROR]"/mnt/test_from_dd1":No space left on device
> > ```
> > 
> > I added some debug messages in relevant functions. When above error
> > messages appeared, the la-window still had enough continuous bitmap
> > to use, the -ENOSPC is wrong.
> > 
> > ** analysis **
> > 
> > __ocfs2_resv_find_window should use resv node from rb-tree to do linear
> > search. But current code logic uses un-managered area between two resvs.
> > The searching logic deviates from this func job, which should only focus
> > on reservation areas (when rb_root is non NULL). Another issue of
> > __ocfs2_resv_find_window is more inclined to generate inner fragment.
> > It doesn't search & consume existing reservations but be apt to create
> > new reservation item.
> > 
> > This patch pulls this func (__ocfs2_resv_find_window) to do what it
> > should do: search & consume resev. if this func fails to get suitable
> > bitmap area, caller ocfs2_resv_find_window fallbacks to use oldest
> > resv from LRU to do the final search.
> > 
> > [1]: https://bugzilla.suse.com/show_bug.cgi?id=1131931
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/reservations.c | 48 +++++++++++++++++++++++++++++------------
> >  1 file changed, 34 insertions(+), 14 deletions(-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
