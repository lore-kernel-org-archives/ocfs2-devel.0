Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BFBC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=o3G7/sqaHj7UhmM4OrgEH/2byptt8H/h5h0xt4D2wLE=;
 b=Ut1GtFlba3pzupP84wdE9J6a/XbvcmIzjmd9/+1AYWpet+w3otbPHWTdZnPVHf0pipVabwSyMrqn
   NbRPcEyvTOzy0kgtHiSdiuIOSXf4rhJOG2BD+7S8uGnOAQ3fvboagsivFR8i/RQ6FnXQ4MG3FhMv
   3dZDDw+dq2cAe+q80UoHhTgTltmHSdAXa/pPAU7/Zyh4vpGmhkVYrpoCMrEXOsIvA/MPGMdYiXKY
   x6bnv+50G4PJkPJxqkyUb5p9CXLsmgzDFjhmLSOSAZXcw5rPd0lBoZnp92XA+UtKuTxeT7Ny9uiH
   8PdzBXkHsnS9dN4GB6Yf42J6BeUI8cjQZeoxTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=o3G7/sqaHj7UhmM4OrgEH/2byptt8H/h5h0xt4D2wLE=;
 b=VMjcsAzGWoId7kNNU1B1gjUsjmI92oBRmh3wQdrJbKF/viNOendR3H763Lo6rMGSyuUKW3v1ZCBF
   MzEzIp8cjYEn8zKJDMlfn4xdJUwt2DAyvzBXSUbCFi0cCfT+JFnHqjZ6+kCk29Icm1mCPuouTcDS
   DbYwhSLANilly+Ih5doMvqwAP8BY/UDovj9mwRGyhI89dmJHM5fditwsixoU4KAwlKvhlt8bHySI
   E6QOsYU6na5TNBUhKv0Nno0G3eHPPZjOOiFoVu7kcfuONFFNKYJAbSH9lsuN82nSU6ryiYg/Ye/Z
   B+TUCytKxmXDwvT5Aben3m01ECCZFsD1ijiQ2w==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAA0022L4NCZ3E0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 13:11:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649855480;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PAvE1C4MrQwJgrQhEv9Csmm9GD6mutwBaXXZSJrxQZQ=;
 b=SGG6PK8C0hM1CguxnIOsEGhO18XC0hGr6+fdYw/AxHImUzQPECl3aGm+3MNUeNId8tiggJ
 xcVdfKJvcKzF42yWEGUSYFmR0lFWeXAZfcx1CeLSbob2YdFggReJjqBPCJjrmi5+oPMPAa
 RFpToTH1I3LooB+s/mNhdP3Rf9P8wlM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwb1TgVvTPLvsIgRxXdbB/bhJ2Gsq0dJmpZawE9UVShfWgmXy7WgUuI+3byAd9e+uE46vPQjA2ybaKzyykYUVTK9rzYXARdfSakKUO32TIP1wUJIPc77UAj0ItllQjT8cHT0dZwE4pp6pbUdhQ+EQttJCR+O93nJHH2EJItjz64LgBw1rbvMO841dTFWmHuGaR2TFWsrxU1Zh3pTEAAWSTpaprVj7zRAMYrJHYdVF8PezXIqVrGXvfLEQlH1LRjWtoBrruTAbIiCYypzsg93oS3sQKzz/VW4XxaZA74ZTN+SzM23gKlFR2RWQ7bcbdY+Mw7cFkpyGfFbyhDhq/BAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAvE1C4MrQwJgrQhEv9Csmm9GD6mutwBaXXZSJrxQZQ=;
 b=b3QslU9FDslr8/9HOMdh/ZRKbwDl8UApnG18yUgogMnn3i5gJJbPbTdVdzjDgmSJzBbuDeHHtc4y91ySO1Ge6UxTm+zbDSvlYnGIrkI1wOqK1mic/FNPqQoCRQaSfJYMqtFrq4I23OiNgmBSH1k7sAbzytaXQHbhTx6ZRbCh/KrOXftIH37ecZe57PyoxlbLMC12We7G1jXaGgVl8FVGIoiO5oRSltAm3ndNRE9NfrUjlsVdl8/Bz2hHHqjHLNQCvsh9Tauv3VCFfnIssOAhg/DNMkghZMfAGpMqfa/UFAU3EpK3bn/x3gwniNtpC0OFCeauVOTtRdte7BSwMW4scA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Date: Wed, 13 Apr 2022 21:11:05 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
Message-id: <20220413131105.7k7xpmlzemwgw44x@c73>
References: <20220413082957.28774-1-heming.zhao@suse.com>
 <20220413082957.28774-6-heming.zhao@suse.com>
 <dcceb610-3c1b-d46c-493b-c836317e6d4b@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <dcceb610-3c1b-d46c-493b-c836317e6d4b@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(7916004)(366004)(33716001)(6506007)(53546011)(9686003)(5660300002)(6512007)(38100700002)(83380400001)(2906002)(508600001)(6486002)(86362001)(44832011)(6666004)(8676002)(316002)(186003)(1076003)(26005)(66946007)(66476007)(66556008)(8936002)(21314003); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 13:11:17.8093 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 clxscore=184 phishscore=0 priorityscore=78
 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130070
Subject: Re: [Ocfs2-devel] [PATCH v2 5/5] ocfs2: rewrite error handling of
	ocfs2_fill_super
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
X-MC-Unique: ga3pb8TROWuL0pVyBYqd8w-1
X-ClientProxiedBy: HK2P15301CA0008.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::18) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d481c0f-d3c5-4add-3be8-08da1d4f1863
X-MS-TrafficTypeDiagnostic: VI1PR04MB4781:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB47813464E87DDE34AE80EB0C97EC9@VI1PR04MB4781.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 HlZXIBLVV9pb+P3KqMWotuL1RmifLFto3KqQHYqJURNxtV7wPtQpXfNNCmY4HpgOsXTeT3KlsznvOb2yGp9LOAw3TTbloIK6rMWGqjtCTo8beniZ2LO8k/KmyIPwoqDv6Yu/fvVAmyzv6VoL9HVJP25RaR4gd5Dq+ASgo+A0hGc4WS0ZQgMiFCVU7dNhVD0BvCflTfyeCEkhINzRefYsRkJElJ/vu2ZN7uQtq9XgUMCr/CWP9+/unnlvEa9GcsiDbxrtiKnPwr44IInuBYcva1pCwWKKKtsK+W3LnBhCd1gsRW+XK6AnG017LXgnvD9B5UHpbL5ZQRBIDFwMw72bPs58XABl2Izq8DkPAOgy5nt4PoA+ddMBaxgSxbuiMH6OPBsVbHsm7UOYhP5H7DMxxJQeqtuwO0uV+KkwA0kqz8nmfodwzlD++azTijvEh6r/EC+2d1GS7DxRuM7WfAUqHWcSn6Q97501ul9E43GZ+/ytjBfpo26t1URpDWkleIrW6hPlNKAsPRoxnpNmNTbpUWFzHHn7w64k7JRTXo2YsvZIF2wsIPE/Y23osJZS3ZSjvYFZCT9crtZubVq4udtoJSZfm3bELj+MrUXq/McpwZsHDJbBLnTGTOQ1/VOiPDzjiTu5URHBSH+0CGdmVBI+fzymK5Jq3uciuEL30YbmNo3eHW8mIvqxHPlU2E+LeaoJ
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?0xinEDZ/RDI/2D5L/Ua69D/zT1WMc9ds/P4TFgIu8Ts8sPN0b+naEh8X3KZp?=
 =?us-ascii?Q?1fu9fDvyIMGEB6AM3bD9mtzokwxbD6lJE3Nr0xndFZfDhvBrvnMGXX32ereD?=
 =?us-ascii?Q?i+5S3nFwb6c/ysOVYaU+8yXOpXk6bMeA+YYsphxBNSuJ/SEn0eFB2uP8iuFq?=
 =?us-ascii?Q?sANKa/w1xlmRjnFm3HxyQXbDlQyDf4kGqxNXfeBB/7f+6XbZlOnO1VXLAql8?=
 =?us-ascii?Q?TP76hF2Zj/zg+P7Nns7OJ0474dKD0iefndHpWzyuRLUBU/8YmDDMRXvUJNyO?=
 =?us-ascii?Q?e1SQvSMiRM/OtELdBWAagUT5Dy/v27w2ObYOzTit/ljZsD1Mk4/jc4bpCQPP?=
 =?us-ascii?Q?TR/kIdo85ojItgJ1f3kA2Ps+aUnxEMdQXdYQrBG2icuut9Pxk1dRF+zYTRvQ?=
 =?us-ascii?Q?3Or9cfzvL/iiSwKKbyMUuvBHtxAC9Rky8xmHV/0Or58f7Jc/y5m/InfedrCV?=
 =?us-ascii?Q?cgEUmhTPWpc3+Mm2QaXQKvdYfEJ4lm5et4B2Z5pHRK6RfYltwu2OfRf8wSkM?=
 =?us-ascii?Q?u3rXur1E3QfdL/kSXEwVVD1eWXXoWY7z2FfXY6iWUecbxLijLA92is2KXm8d?=
 =?us-ascii?Q?o6+Tee3NFsIoNMvYLcN2M7KwSGudmakrMhI5m15EVFr2HZrTeSTk13Do7oAM?=
 =?us-ascii?Q?EORwBu2xUS5FvsSO69CEjDX3NB92KHJJ3DdvBcix3S0ckaV72yoFuB4xFuf2?=
 =?us-ascii?Q?DKP13OMMhYFhqHmSaE+Tp6PbR2drKFfSAmcv/1A6ydrVy6o6H0ACdEgbYvzj?=
 =?us-ascii?Q?tPdQT9B3MO7OoBE8sAwY+C1RIXVfIPw1IEObtR41efrvbl/T28vvTVLjfdu4?=
 =?us-ascii?Q?Bu8RWZedkAGg9dzETpBRKPuvIbM1tL9lwARBIXohQWs5JYKOmA7t/7ZZrod1?=
 =?us-ascii?Q?StC7aSDpcIPqndTMdSh9iyIdAeeOz8Q8427vwJ9m0tSjyvN5IP2ZDJ8/AwIZ?=
 =?us-ascii?Q?O4lhk1opHmw4bPRe4aLZK6IpH2p7TE5LMex3Ufe+G+Cd0aqX32yCC8ceMwM3?=
 =?us-ascii?Q?k+jrqG1WYSTBxz8pDTcXYPVmTW1LOfKyKflAWcp4M4FNd6YicarMz8xZ1Eye?=
 =?us-ascii?Q?f4gnVv8fofxd9fMP3wPhx5d0DOfOQwUOlBSuSkLMkbHTltNfxczbRS88gpG7?=
 =?us-ascii?Q?MJiFS+tZ1+SQAJFrimqZ4ye31nN3Pry/9mkbSxcrwj510DTEQ/l5CO4lRVUr?=
 =?us-ascii?Q?YIHqdgV2OOeA/HOKIWl/K7Kc89RaZcLhPsP8cLurpuXKwFSfmIhuaIVzWuDp?=
 =?us-ascii?Q?YgjusyK3RqlI/Gx68fRMLvIy8jfLlvLFibD7wXy6GZQaQlheNzfl3s1UUvSF?=
 =?us-ascii?Q?CRxnS3QJbN6BjLaqPoq5qc0fpnskq2brHaOxrCEoABujec4GOxeJW4AHlYB+?=
 =?us-ascii?Q?AIVVes6APlLqnPwIPSZguRmYdhCMdpMnyL59zgAYxud/Oym/AyzWgeSWTVUU?=
 =?us-ascii?Q?Uh3uel/f8JnwP9Zz3ZnT9pjlxF12GZRe3jrDw6YpAT54F9YS6Kf0NE4rS+jK?=
 =?us-ascii?Q?96m/XO01lghBsMEPIgW4MgmNqAeQUewJXWyF+bYQBjHoon7vYz0H8YMpAngn?=
 =?us-ascii?Q?beyUn5B/I1ugwlfNOC7tbyh/IgSKtGmQile5kPU10tjYDPL896PWd4tEO5rr?=
 =?us-ascii?Q?4r2emqSbzI7/a9iR5s7yYMJl4v3eju3V/pqp5VY6ZG9l1tUe90fvmUE5XLGa?=
 =?us-ascii?Q?hi+iENnRTFWKow/XfeKG00nEYGFD1n/j86etTLef6x3ViqBz53QWAk60b2FY?=
 =?us-ascii?Q?upjbUlGCs86paEBrzSWdHfMrACunaU8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 5d481c0f-d3c5-4add-3be8-08da1d4f1863
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 p2760TDT45Ntatoe1ghLcKqN78TCzpCk17fk2+NaNiTF/AqBl4vc9aHn+ZahQbmY20tO0xfPgaZ6nxX5xJB7oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4781
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: NiYYQOHn2_L4ljrmqF-rTiukm-CgBh-2
X-Proofpoint-GUID: NiYYQOHn2_L4ljrmqF-rTiukm-CgBh-2
Reporting-Meta:
 AAEXpB8emGTs2biMMLq/QtX4InpYqftWrvNAKVAzJzlIUqSR0GTrJhelPHnNtR0K
 VvnahBUxJvfwS5iCtBMDqCeVJk49YvtUGItQIKBkHEkUNcmjGk4gfVdX2AG7DEmI
 SaVVGPMQmkQsYtOdt7hYvmhGybly2ohMJ0cwF7BUXw9yKB8zTZNbyIr2s1g40h8P
 UqpurYhCXv/86MDHqRY3gsCki4K513vxogrIAtlhJoIxAsgL9PwcUzkHDi8z1FnP
 RTIr+kUU55ilfCZeH6CG7+C4O+kuFYrjxPXoKb/UGafdG+1IeBedvh0wCltc0S2e
 Tl7J6pKKq2rUlQoTgk+nUcuiVeYwf1RVsrvyDuek7wp8QaWaz0fCtAxWpCkpd32/
 vIbi6Idv3MdE5QtqLI7Wjz7m/DdS0F+XldT9qmyd2IoyZdEy4neJw0+9SazGT4zO
 CpbaSbg3twQwe9DzWrRkTck5YOu5OvaBhyxxNvVFuDgfGys4ySb6ne/ivXCLfhIb
 VXtoSswqsLcYdo0cpR7VjnEcjbeklHIz8xwH1tloMjC4

On Wed, Apr 13, 2022 at 07:37:59PM +0800, Joseph Qi wrote:
> It mostly looks good to me.
> Have you done error injection test after this patchset applied?
> I'm afraid ocfs2-test can't cover this as of now.
> 

I plan to write a debugfs api for error injection test.
The code only for these patches test

My idea:
echo N > /sys/kernel/debug/ocfs2/xxx/error
N: 1,2,3,4,...

"echo N" will make ocfs2 trigger Nth error point become true:

```
 	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
 	brelse(bh);
 	bh = NULL;
-	if (status < 0)
+	if (error_inject(n)) //eg. "echo 1 > xx" will trigger there "if()" becomes true.
 		goto out;
```

What's your opinion about my idea?
Or do you have other method to test?

- Heming

> Thanks,
> Joseph
> 
> On 4/13/22 4:29 PM, Heming Zhao wrote:
> > Current ocfs2_fill_super() uses one goto label "read_super_error" to
> > handle all error cases. And with previous serial patches, the error
> > handling should fork more branches to handle different error cases.
> > This patch rewrite the error handling of ocfs2_fill_super.
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/super.c | 67 +++++++++++++++++++++++-------------------------
> >  1 file changed, 32 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 5e860d7162d7..72673d40d29c 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -989,28 +989,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  
> >  	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
> >  		status = -EINVAL;
> > -		goto read_super_error;
> > +		goto out;
> >  	}
> >  
> >  	/* probe for superblock */
> >  	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
> >  	if (status < 0) {
> >  		mlog(ML_ERROR, "superblock probe failed!\n");
> > -		goto read_super_error;
> > +		goto out;
> >  	}
> >  
> >  	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
> > -	osb = OCFS2_SB(sb);
> > -	if (status < 0) {
> > -		mlog_errno(status);
> > -		goto read_super_error;
> > -	}
> >  	brelse(bh);
> >  	bh = NULL;
> > +	if (status < 0)
> > +		goto out;
> > +
> > +	osb = OCFS2_SB(sb);
> >  
> >  	if (!ocfs2_check_set_options(sb, &parsed_options)) {
> >  		status = -EINVAL;
> > -		goto read_super_error;
> > +		goto out_super;
> >  	}
> >  	osb->s_mount_opt = parsed_options.mount_opt;
> >  	osb->s_atime_quantum = parsed_options.atime_quantum;
> > @@ -1027,7 +1026,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  
> >  	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
> >  	if (status)
> > -		goto read_super_error;
> > +		goto out_super;
> >  
> >  	sb->s_magic = OCFS2_SUPER_MAGIC;
> >  
> > @@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  			status = -EACCES;
> >  			mlog(ML_ERROR, "Readonly device detected but readonly "
> >  			     "mount was not specified.\n");
> > -			goto read_super_error;
> > +			goto out_super;
> >  		}
> >  
> >  		/* You should not be able to start a local heartbeat
> > @@ -1050,7 +1049,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  			status = -EROFS;
> >  			mlog(ML_ERROR, "Local heartbeat specified on readonly "
> >  			     "device.\n");
> > -			goto read_super_error;
> > +			goto out_super;
> >  		}
> >  
> >  		status = ocfs2_check_journals_nolocks(osb);
> > @@ -1059,9 +1058,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  				mlog(ML_ERROR, "Recovery required on readonly "
> >  				     "file system, but write access is "
> >  				     "unavailable.\n");
> > -			else
> > -				mlog_errno(status);
> > -			goto read_super_error;
> > +			goto out_super;
> >  		}
> >  
> >  		ocfs2_set_ro_flag(osb, 1);
> > @@ -1077,10 +1074,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  	}
> >  
> >  	status = ocfs2_verify_heartbeat(osb);
> > -	if (status < 0) {
> > -		mlog_errno(status);
> > -		goto read_super_error;
> > -	}
> > +	if (status < 0)
> > +		goto out_super;
> >  
> >  	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
> >  						 ocfs2_debugfs_root);
> > @@ -1094,15 +1089,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  
> >  	status = ocfs2_mount_volume(sb);
> >  	if (status < 0)
> > -		goto read_super_error;
> > +		goto out_debugfs;
> >  
> >  	if (osb->root_inode)
> >  		inode = igrab(osb->root_inode);
> >  
> >  	if (!inode) {
> >  		status = -EIO;
> > -		mlog_errno(status);
> > -		goto read_super_error;
> > +		goto out_dismount;
> >  	}
> >  
> >  	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
> > @@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  	if (!osb->osb_dev_kset) {
> >  		status = -ENOMEM;
> >  		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
> > -		goto read_super_error;
> > +		goto out_dismount;
> >  	}
> >  
> >  	/* Create filecheck sysfs related directories/files at
> > @@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  		status = -ENOMEM;
> >  		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
> >  			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
> > -		goto read_super_error;
> > +		goto out_dismount;
> >  	}
> >  
> >  	root = d_make_root(inode);
> >  	if (!root) {
> >  		status = -ENOMEM;
> > -		mlog_errno(status);
> > -		goto read_super_error;
> > +		goto out_dismount;
> >  	}
> >  
> >  	sb->s_root = root;
> > @@ -1178,17 +1171,21 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  
> >  	return status;
> >  
> > -read_super_error:
> > -	brelse(bh);
> > -
> > -	if (status)
> > -		mlog_errno(status);
> > +out_dismount:
> > +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
> > +	wake_up(&osb->osb_mount_event);
> > +	ocfs2_dismount_volume(sb, 1);
> > +	goto out;
> >  
> > -	if (osb) {
> > -		atomic_set(&osb->vol_state, VOLUME_DISABLED);
> > -		wake_up(&osb->osb_mount_event);
> > -		ocfs2_dismount_volume(sb, 1);
> > -	}
> > +out_debugfs:
> > +	debugfs_remove_recursive(osb->osb_debug_root);
> > +out_super:
> > +	ocfs2_release_system_inodes(osb);
> > +	kfree(osb->recovery_map);
> > +	ocfs2_delete_osb(osb);
> > +	kfree(osb);
> > +out:
> > +	mlog_errno(status);
> >  
> >  	return status;
> >  }
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
