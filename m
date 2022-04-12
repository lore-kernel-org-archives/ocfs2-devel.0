Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9197C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ELeESqTNKwpMNKynuwDHMtOMvxV0J2kZrzz1wtzaTmA=;
 b=DKMJGec7zJV0iqSXvhFprDMAGrlhshmX6TW/1/Eop0tkKsoS+HZfyy/+HzkQfirN2vmx790Yc21F
   taomzJ4mBsSnVY8DgqrhrBVgNyDOGUGnlWgmyLisc+HsFgv8nMxsLPtDIkjICp7WRpTqmuU/ohWS
   ZzvytQu+SlGysa13uO2uKgjmTqAvQAaFepTpkwo2EXF+vIkP/h56jWgS0X6ikQ4bacVwYZSG0yKI
   Fus9O7gp1qIS2d3VlNCg/UYsyPii0eszcRwYZ4DFhlxiyWOJrwHn3PKip0o9nN/gLjRZ777bbggH
   V4Kk3498I2MVvCWAtrtBZ4+u7yTZBZ40pUoTAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ELeESqTNKwpMNKynuwDHMtOMvxV0J2kZrzz1wtzaTmA=;
 b=I2WqVtC2/Px0fIj5n3J0m1lkin7D4hvyueQsOVNsupIn5CTT9gifpEg0pazDKR51TEiDFAgWJ0AI
   tquOg+BdRhMZdbDllmS4trSFh+MSRK7odRWita6KHk58nfA3e150Qr1yCgq8RY8CDWoN6y0r85Jg
   S1eIzfl0b1CGGs9B+PjcZ1k0JjXWfL/ITgIGaFCOC6CZoORFKP0y7xXurm3wy3OrhZl6TFar5ydb
   lX1phNWyipzu6lzILsjCoiwyYK/+dcypUlsSi5eVV2V/+v6zKF68M+zbXi9GFTyxJvuIuK1chW09
   AZ9MZmM/o5yxsuNy1moueMaS9d5FF2Q149fMLg==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAA00MK46E6DV00@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 13:49:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649782018;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=GYACQ7dOZt7D0CuBUoSALZfSPzQz2THAWsgUIMTYkHI=;
 b=RT/xml6gr6+eRwy6ecC9W+DAP3KduYcYE0H+e8QYqruAXHRevTc0DkfXDS19fLafCncSR6
 vuQDVG5bje7haJ8X1JkAgBC9SE5772C5YQI9P4UhwNvqaQm/lj6E01lZp1osm0NA/E/o27
 K68mYcUMZ87ZWAUPnU/IIaLG2fveZ5k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lv0du/5YSnPV57QSyXkvpByZ2tlSV6vMKFovJjzOSbLxn2DzZLMLov0XpZ7O1ZcfYIjGsU7OQxnv3GkPrOqAKgj0IEpm4jKyPtneymosSSwWBRvpDoP3NOfoqfLXH9V/8ZrwpmUmVDYvVLHOWCVzlImY/W8qM+Pt/I9am+DcGbd5EI3q/gUnrwoVVK+SsM0GL8fPJNH+27j1t4tW8dJgV2YWGWk99Oi1k0A6JShJtZ/kfhZWWt0SmQl+tNq4gzghZqSp7HoI1HOiKu3yNtxCSHGeM8f6aLLDPnbHSKT5XMqwOXCIrsSHff/6YeLbv32rvrfMJ3wIkSU98gd77E2+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYACQ7dOZt7D0CuBUoSALZfSPzQz2THAWsgUIMTYkHI=;
 b=Ih9vesIoiXrdTdi49Z96KNfwLd7rqQiGCgmB75tPICSCRQdGc4djITyM1rhJVp//em6rOs+G1Rl2XOzDziYTlwRpFofogzVaIc9Z8sId/Ouu3xgIKAj7SZfb88C7Yc02Rj7KpvrgTu/R02tRzZKq1riDWNF10acqbcG/Vw5waTSJbhv/WahGIX8NxlNMd0wWuFLKA/1+C3bFSmfxqXfd7glDwYUUTPkZlvngJ2mulzMYy7VdzLuqIqXYBIDz2KElfmsqfIPYmhUabr69bB1uqaV58h1UnNGo4Q7Klm+ulhXT23g1XXMedGT/tj0MWKRL+X0ojp4MaE3HayLo/tsTaQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Date: Wed, 13 Apr 2022 00:46:43 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
Message-id: <20220412164643.ogajklufzwgzegh3@c73>
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-5-heming.zhao@suse.com>
 <5bd3a683-b0bd-b6b9-32c0-b57026f109aa@linux.alibaba.com>
 <20220412082248.qzacxmvexkpwqhua@c73>
 <5bad382a-1fba-64b8-8785-cf1c229e82f6@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <5bad382a-1fba-64b8-8785-cf1c229e82f6@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(7916004)(366004)(8676002)(66946007)(2906002)(6512007)(33716001)(316002)(38100700002)(8936002)(508600001)(9686003)(6486002)(66476007)(66556008)(6506007)(53546011)(83380400001)(86362001)(5660300002)(44832011)(1076003)(6666004)(26005)(186003);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 16:46:56.1106 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 clxscore=165 priorityscore=182 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120080
Subject: Re: [Ocfs2-devel] [PATCH v1 4/5] ocfs2: ocfs2_mount_volume does
 cleanup job before return error
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
X-MC-Unique: JoJEnJQYPImNY9GKaSMlIQ-1
X-ClientProxiedBy: TY2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:404:42::29) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfecbaa1-d3f4-4b63-0e18-08da1ca40dc4
X-MS-TrafficTypeDiagnostic: VI1PR04MB6861:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB68614AE9E2493FA4272D1D5097ED9@VI1PR04MB6861.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 QGAGUW519kwsrqcWJPXAb1uQ0Fp33i1KQn1tSwzKmiLcluyOctk5ZW87mo4uUKf9cJIfL6ffX3tiH+pjaq6oKX/Wf7ar3dT31DSz2B7yGCLe2FtFhvMOlNLY1tPWOfM7Q3xAz/ieAvIKsShJOvyzutljIVEjwziF8fADGdgdenRJd1XY0kN3i404S7PGIg9JYVaUbqqEecjXlzNTW3RUvQZiWjOGCUMSV9nSiYQWnf5cmeGWetijRARg+5fRz1G0Z9jY0kBJvBSP6iBviMswj3PKtiCYYepL29HdN8GepKgfUflYq3Ra5gVtYtU7xoCILul6uIBwbDdPFsGWF/ESzxLb4fWJHRkRCI2EUeOSlxXW4HpRE2mNRcsjsCAAhCViVPzZ9cU6XuNLYxyigi1hc9gOPxl6/FPQRtJ1DjWOteeykyegMaDzNndvtj0/0n71bawSz5bpDH2N1HDaJruIu+PyLcVjaFQaMw22mfTUs9D3tWN5hxwx6muWtWe0bPlKoa0j4X67UJJg/CvYkr3bER22+YkqynO6IUO4L1pY1o2SXnhIUSyTGEVcWncUT2Ozxv8g1jDU+mrYa6uABwNNM+YjaPZmdQ56t74XYy7UZNujIfGWtn4aqc2b4CutHwZ4EltGxMB1NDOmyCztnp+UZg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?pzbKtnpJ23zfWsVNayVExIknHoHT5TdU/Xcg4fMmEVet5ZOMcQSIcXvR1clC?=
 =?us-ascii?Q?NoknvK71Mkfj/WGMsBT45QJLPF/7JDOv2m8b18iSY9YvenK70O0bZJHTGlc/?=
 =?us-ascii?Q?D5+yKuU9wZPO1L2wio9Okh+oppNzvjIFZFsgUIMz9eLdUrTaDOTDMYGxB+gQ?=
 =?us-ascii?Q?df/81bt9xsBs53nQNZl44BxamgzHspMNv395Oodc6uyRP+wAvvQc07UZm1bi?=
 =?us-ascii?Q?moipKO4d9OJhljazvHY8ThFKxoJpsUtIP6Fcegf18IJSnxsIiUvW+mY+x2uU?=
 =?us-ascii?Q?VmbKnxUPuuGNS7VhldZp2rJ6xkgSafsXucUrg6Itd2g1KFkA3vS27r+Rh+m3?=
 =?us-ascii?Q?xOqWZ7973IxbZztYLE0QxIG8oYajc8270AnT6cJdvMvKId169gygTAtlrYPz?=
 =?us-ascii?Q?ZJ4bTSndH+f5dW5T/ATH1+2mVW1T+j1sQysFojgW2rsO4lpAhlV9QnpiuKsw?=
 =?us-ascii?Q?BSzADgFNG2WFfiy8zW7/Dza6KUG/BuEUzA1e8u3J6BSbAv9bTNgicyNVaoKO?=
 =?us-ascii?Q?/iLwlSSuyel8A66OVXrfc0QsGMp6EQhf98LigZS/T9SYFx36y0gM2rQB21iS?=
 =?us-ascii?Q?qYhCcLwJ9chT6VFy2rLIaqZ2x6PRabwpMFtivWDFGameZOLRoq/TS7224ZAC?=
 =?us-ascii?Q?6bHD4uUCrBmrlCS46H/rZYWnVfIfTm3HJh/svdzv+DdBj9vHVNJxW82z2u1G?=
 =?us-ascii?Q?xlUwXjCPutf1MscPByTiQ/qFtG0TiiCEODybi+wnryFJ/rWrrl1JNGGTRBWm?=
 =?us-ascii?Q?VXAy6UU6RrzVQWuFsk9SozySXoBnU+l8SNIOAn9VmDEjTWeS8Q5VnfRJ+tB4?=
 =?us-ascii?Q?L08elgKmmmPqk1hX3FnS9a6uIBnl1cSCKKcPGzjwqFfjbV8elljvQnEgWQuW?=
 =?us-ascii?Q?d8743aE/FRElWFE/6isaoRavqzxzQClp7cJxIeYdlrTP//yFoGowPxiYTnAG?=
 =?us-ascii?Q?LBHu3hLBTQWQwWUjC+rZorqRfEp1rkC8bE+OPNI5S7+aXG5Skc7bt9pzE+bM?=
 =?us-ascii?Q?/wJi27ayNHKPRQsJqh+iaoXzYcCFD5MDoGf31+v1SLhuccx050T6iUnCwca8?=
 =?us-ascii?Q?Ef40eM0ki1elqFEIDtqc1jbXO0WnbSIDI9jP0DpGg3JJcDSA8pDVBs51RcFC?=
 =?us-ascii?Q?4T37/SKy6puX6hMQLRH2xI0eIOYbzIXHjFgHvi5xjPhBJItPj1mvmD0N9fhK?=
 =?us-ascii?Q?CvTTC6SgS+0r5UkxN0lPATTDUjgV6Xj4oOxOLKp3aiero+3LQzQXEiB/DTr8?=
 =?us-ascii?Q?Otgqh95IXtWlbft9RX3dwJeXlSgweCGhzT0fXmZzwGAkd+AsLWU3xgwJ09H4?=
 =?us-ascii?Q?ORKUP9Mm7Q2oqtHwwYSB2G+PTSj9bMzWB6kFb/ku6eoXi8CMZ5gSc2Mxjhg0?=
 =?us-ascii?Q?xhC8rgy6LNoJOPRTMmiYmzbEFEkaFwhdNSCrZjZCCJxTeqbSm9+USSKACeUK?=
 =?us-ascii?Q?BuNExNxkpr2XL2R3TrrUsEbkweD3trbhDb+o7rjl8fUk91bSAMS/0lcFffLP?=
 =?us-ascii?Q?qbSUFBNh+CvtNOCdZSTZWrRj2/h78//ATSHDvXx5MGOdE9AdAV6sZbOBOQbz?=
 =?us-ascii?Q?M6IRNHvPfdDryYHYC44UgeHL/voxvSG0lIx5xL9SEAFAGWFDgTP1zwTAcNv3?=
 =?us-ascii?Q?G47rfgrasnSqNvr5LgZZw18lVDVD6aFLoAQPRo/VbwXbM2lmRoPOdm6N/l3N?=
 =?us-ascii?Q?3GUZbPlPJ5HrAes7AsCt4EC6mOBm7hHPr4nW00IW98eZfo2a9vh9xWYG9Vtc?=
 =?us-ascii?Q?KzRUTfTFlA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 cfecbaa1-d3f4-4b63-0e18-08da1ca40dc4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 YCdrhvdBriftirbwpr6ZGeVyEQLFt30mVDgVgHT0rNc9CSylREdv1ddHv/qWI5zO1P6so8kXmCkzCFr6tO5Peg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6861
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: KF723lCwqKFxI7GTw9LMo8WWjbaDUTCi
X-Proofpoint-ORIG-GUID: KF723lCwqKFxI7GTw9LMo8WWjbaDUTCi
Reporting-Meta:
 AAFlXPWGD5eKB91uR0e73AjaDAsScpunomaRcCTkbc2kiJQAd5Mxn9pPzTvQun/l
 NTMLIupS+pkQj4iYDMOcS9kqSOGYEM5w4pAxeE5QcHjakZznym23VHT1hd6okk67
 +zyjPf9RyDQylf1xeTb5yJSASaNNo4OdpDoW2NkQNNRZNdp4on68sRm3bfUDExfI
 K3u1f7FcqNht0iNNhFRVfNW1U4GwADjpw/VHegOGrtOiPhp+ChYngTqBuvF6NLZt
 gS4zFYIebK0cE+Y5T+QLlRLKw1hNJap+/bonTJnt2OqeLQx7r1w97c0TJiIFpCtm
 DNParKy4fTUZmXNtIvGOYffU57P+w7L4O8YmoxAuh9xIO3lPi9pEx99VN/ftwSYT
 NK9K9Ncw5xPDU8fLRKIan14BZ479qcRxIOBnwlqUxJCK/atw5NyTfiK9MmBgUul7
 ORPECHmX41mUY5CefUTQPBSy/lyGT2C8rLtfLae5NZ+UHGKDggywqzPZ7JQjyny9
 L5uLtc3HpOwexnLvg7d2NXU4mpDpaB5yB9ZFF+lbGC4+

On Tue, Apr 12, 2022 at 07:54:35PM +0800, Joseph Qi wrote:
> 
> On 4/12/22 4:22 PM, Heming Zhao wrote:
> > My last reply (on 4.10) had messy format, because thunderbird automatically
> > add '\r' after '\n'. For easy review, I use neomutt to resend my replay.
> > Please check my comments in below.
> > 
> > On Sat, Apr 09, 2022 at 09:46:19PM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 4/8/22 6:30 PM, Heming Zhao wrote:
> >>> After this patch, when error, ocfs2_fill_super doesn't take care to
> >>> release resources which are allocated in ocfs2_mount_volume.
> >>>
> >>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> >>> ---
> >>>  fs/ocfs2/super.c | 32 ++++++++++++++++++++------------
> >>>  1 file changed, 20 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> >>> index 8443ba031dec..d4b7a29cb364 100644
> >>> --- a/fs/ocfs2/super.c
> >>> +++ b/fs/ocfs2/super.c
> >>> @@ -1803,11 +1803,10 @@ static int ocfs2_get_sector(struct super_block *sb,
> >>>  static int ocfs2_mount_volume(struct super_block *sb)
> >>>  {
> >>>  	int status = 0;
> >>> -	int unlock_super = 0;
> >>>  	struct ocfs2_super *osb = OCFS2_SB(sb);
> >>>  
> >>>  	if (ocfs2_is_hard_readonly(osb))
> >>> -		goto leave;
> >>> +		goto out;
> >>>  
> >>>  	mutex_init(&osb->obs_trim_fs_mutex);
> >>>  
> >>> @@ -1817,44 +1816,53 @@ static int ocfs2_mount_volume(struct super_block *sb)
> >>>  		if (status == -EBADR && ocfs2_userspace_stack(osb))
> >>>  			mlog(ML_ERROR, "couldn't mount because cluster name on"
> >>>  			" disk does not match the running cluster name.\n");
> >>> -		goto leave;
> >>> +		goto out;
> >>>  	}
> >>>  
> >>>  	status = ocfs2_super_lock(osb, 1);
> >>>  	if (status < 0) {
> >>>  		mlog_errno(status);
> >>> -		goto leave;
> >>> +		goto out_dlm;
> >>>  	}
> >>> -	unlock_super = 1;
> >>>  
> >>>  	/* This will load up the node map and add ourselves to it. */
> >>>  	status = ocfs2_find_slot(osb);
> >>>  	if (status < 0) {
> >>>  		mlog_errno(status);
> >>> -		goto leave;
> >>> +		goto out_super_lock;
> >>>  	}
> >>>  
> >>>  	/* load all node-local system inodes */
> >>>  	status = ocfs2_init_local_system_inodes(osb);
> >>>  	if (status < 0) {
> >>>  		mlog_errno(status);
> >>> -		goto leave;
> >>> +		goto out_super_lock;
> >>>  	}
> >>>  
> >>>  	status = ocfs2_check_volume(osb);
> >>>  	if (status < 0) {
> >>>  		mlog_errno(status);
> >>> -		goto leave;
> >>> +		goto out_system_inodes;
> >>>  	}
> >>>  
> >>>  	status = ocfs2_truncate_log_init(osb);
> >>> -	if (status < 0)
> >>> +	if (status < 0) {
> >>>  		mlog_errno(status);
> >>> +		goto out_journal_shutdown;
> >>
> >> ocfs2_check_volume() not only does journal initialization,
> >> but also local alloc.
> >>
> > 
> > I agree and already handled this case. Please read following explanation.
> > 
> > Call flow:
> > 
> > ocfs2_fill_super
> >  ocfs2_mount_volume
> >   + ocfs2_init_local_system_inodes //[1]
> >   + ocfs2_check_volume
> >      ocfs2_load_local_alloc //may fail
> > 
> > If ocfs2_load_local_alloc fails, only "//local_alloc:%04d" is bad.
> > And other alloced inodes (from [1]) still exist.
> > 
> > Also note, the sys inodes release function is ocfs2_release_system_inodes(),
> > which could handle both osb->global_system_inodes[] & osb->local_system_inodes[]
> > are NULL pointer case.
> > 
> > The cleanup job will be done in both places:
> > - ocfs2_mount_volume (patch 4/5)
> > - ocfs2_fill_super (patch 5/5)
> > 
> > Related code after patched 4/5:
> > (please check my comment start with "hm:")
> > ```
> > static int ocfs2_mount_volume(struct super_block *sb)
> > {
> > 	... ...
> > 	
> > 	status = ocfs2_check_volume(osb);
> > 	if (status < 0) {
> > 		mlog_errno(status);
> > 		
> > 		//hm:
> > 		//need to release global/local sys inodes (by //ocfs2_release_system_inodes())
> > 		//which are alloced by above [1].
> > 		goto out_system_inodes;
> > 	}
> > 	
> > 	status = ocfs2_truncate_log_init(osb);
> > 	if (status < 0) {
> > 		mlog_errno(status);
> > 		
> > 		//hm:
> > 		//need to release journal: by ocfs2_journal_shutdown()
> > 		//need to release global/local sys inodes: byocfs2_release_system_inodes()
> > 		goto out_journal_shutdown;
> > 	}
> > 	
> > 	ocfs2_super_unlock(osb, 1);
> > 	return status; //<== hm: will change to 0 under next comment
> > 	
> > out_journal_shutdown:
> > 	ocfs2_journal_shutdown(osb); //hm: through to label "out_system_inodes".
> > out_system_inodes:
> > 	ocfs2_release_system_inodes(osb);
> > out_super_lock:
> > 	ocfs2_super_unlock(osb, 1);
> > out_dlm:
> > 	ocfs2_dlm_shutdown(osb, 0);
> > out:
> > 	return status;
> > }
> > ``` 
> I mean we may need call ocfs2_shutdown_local_alloc() to do the cleanup.
> In ocfs2_fill_super(), you don't do that.
> 
 
You are right, my mistake.

I also found another mistake in this patch: "goto out_journal_shutdown" is wrong.
After ocfs2_truncate_log_init() failure, code firstly calls ocfs2_journal_shutdown()
to clean journal then calls ocfs2_release_system_inodes(), it will trigger crash.

- Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
