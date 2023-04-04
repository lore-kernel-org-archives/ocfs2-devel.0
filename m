Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD438C77B62
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KqMvQxQwnvDvDa/CIM/HPLHTCCJ3DN8+Bb9S2T1jQJo=;
 b=yFm09cB6dWuoXq8Dthh0JcCfumoMo/1ahFz34/q2UljyGpqtgbzUsDp5HX8kY0JeTik23RLOzM+r
   fqdln7CGpxFlfA8d9MXkopidup7tYcnNRAZxuXtYW3afXksXqXn+foesMEV+YwSy6cBUtKVenITm
   NgI+SIrWBp2MZ31T4qMyv1nbb4Ts0LJyLA6jQGavu1eQ2iTlDpKDEoy7tb2UP35R8n/OQ7NPXTGk
   QZPVubB9tPnKFEham5Ti9nA2OlhCtjdOErqyeQ3AXDcVfb1zZltj7u3xKDfp8Pt+5oFOlH8zn1FV
   fM4Cx2jhJpR/pNVePmJnZgnT5M1DpEZ6Y4rOQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KqMvQxQwnvDvDa/CIM/HPLHTCCJ3DN8+Bb9S2T1jQJo=;
 b=p5e24hsN5uM3UUL6Gw0RvdvmOhMHHy1aPHIR1hnL+i5EcuV0rHdoej6yT/stYSlg7iM2YSYgQ2Kc
   p4gtdw4E08umt/CQtpb/wqLYqX6zFw97Qs0QeM+YuS7UdA1rfj64bV8cWbM984KQZqqYYnhflb+O
   r+2SURNeDizGUdCJDxoCXF7DNHSjUdUIgIy71jfVrofL1EXTa5YJmg5I5Qd+1kOR6Uj5EVYbRdwh
   Sy330DMOQ8IUN+L+jPTnOrVeciatXl1H/wXmNRvuQGMzo0ZA7r0aBAXJ5R6HdCEjC1w9MOdKOcK4
   hU9h2KSUphzx60YOWiIbzKWSVU6xAJREGMjVyQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSL007V4POT3G90@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 17:24:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=intel.com; i=@intel.com;
 q=dns/txt; s=Intel; t=1680619877; x=1712155877;
 h=date:from:to:cc:subject:message-id:references: in-reply-to:mime-version;
 bh=e+uKZ+pEt1hAxV1c+IeZ/bAZmljj5Q2Z6kW029C3z5g=;
 b=CvZ18nbZmwX47yU8mgOvxC0qMT3fk42cyjayhZ6+HhLW/yJHfPllgm/x
 5anoifHQcXKx3Ox8Lt9RlG11iutXWyWhkmMIgfBB17hqsiPwr8tg1GWgq
 puPZ/P6nwTg5ev8SBbPtSIxMlo+nkjMGHvo5LkVCHfH/t/XkJILzjlShD
 pOy2ROVb+B46Tla93i4EFlkNplaIDo2w3pWP+PycaWFBvqtpt+ZfR1MYC
 drOXsBuGTdc8ljIBf752UBD9kQc7tZB5C+sUPEF/SxE/i/OUCjBwd9cPY
 3g29RNkzWGKfQdSiadXG2FjW7z2usK7Jq0Rgq8bG6KyabhL50yHBwCkOD w==;
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKVdnpdD0i6j21bsYlM5M3qzmU8UwoAOaiiCK4k5pWbWfQCsjE+w/b9Hz//FYSpT4nSdok4XOVQfTSViEliMxJjca6TyeP+xkgHKl88j1Wy3olmL4F581LRyo91A1EgcBFmBdA5MEQccYsZnKCYfZeuffbuyIEZR/ri6XJ5qnMzyU9B1EzjY2jEfMRDwvnqfIVRsrY/PEsAZA0OnYRi9B8x/GgIUxiU+86a322dZ/S3EfOYRhYWn/p/XVQ2QJKGGjMi/qZlnPvo6Pni2DAabPzdYsAj+65VVm2+Q5ArvB9XjmaTspZQ5gVeOSQfveXkf8a7WDhf363/XHZxYhz28mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7b4DrsTPbnj5AQhWDGT0JaNAWXXle+PHCPcE9NrPSbw=;
 b=dzntOgQ6jIY1rVgq5PVJX52nJ6JxQt9JabwPuS/AJhcmzGBgg4I3Hh6o4lqLSAgXUcCnrSTrFnG/dHW0frDoBedehtU8KLc0JZx2OAtnPv1a2FZqfZXyF+NXnP17L7GJDBD9Ud0aKLV0eXMwB/yNrX2jBJ/q471+vi8ML/lXtnt7qfulfqNaJy/hGccgiXQu4PCEpNJBnIC4x9Ugdx+CL80dgsuXe8Mkwe/AKbrHMCNXvv+qpa53yzlvwcJW0X7LhvUGswX6GTjzeIOKlYSlR3Omjv4/YKDVTCRxocjwBk5h/W6VZGL4YsWsbpBn2KmLkGeFz1G5cyVsgSfpl0OT6w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Date: Tue, 4 Apr 2023 22:50:57 +0800
To: Dan Carpenter <error27@gmail.com>
Message-id: <ZCw5Ucw5CS6nXosr@rli9-mobl>
References: <9e1d6835-34fc-49cd-869e-d99d9b546d17@kili.mountain>
 <4154b815-3be4-53de-1bc0-ca87ecb925a4@linux.alibaba.com>
 <1e7d7076-ddd6-41b3-b824-673986c35477@kili.mountain>
Content-disposition: inline
In-reply-to: <1e7d7076-ddd6-41b3-b824-673986c35477@kili.mountain>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR11MB2995.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199021)(6916009)(41300700001)(66476007)(66556008)(66946007)(8676002)(316002)(478600001)(44832011)(4326008)(8936002)(82960400001)(5660300002)(38100700002)(54906003)(6666004)(83380400001)(186003)(6486002)(966005)(6506007)(9686003)(6512007)(53546011)(26005)(86362001)(33716001)(2906002); DIR:OUT;
 SFP:1102;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 14:51:07.3730 (UTC)
X-OriginatorOrg: intel.com
X-Source-IP: 192.55.52.136
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=293 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=152
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040138 domainage_hfrom=13524
Cc: oe-kbuild@lists.linux.dev, linux-kernel@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev,
 Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>, lkp@intel.com
Subject: Re: [Ocfs2-devel] fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn:
 missing error code 'status'
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
From: Philip Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Philip Li <philip.li@intel.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="321862655"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; d="scan'208";a="321862655"
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="716663118"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; d="scan'208";a="716663118"
X-ClientProxiedBy: SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26) To
 BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2995:EE_|PH8PR11MB6902:EE_
X-MS-Office365-Filtering-Correlation-Id: f091dad4-37a5-409e-38ef-08db351c0571
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 aXthT7+RIEoixSxCW+4rNxoG2dHcX/flV0FNxy77JtK/1AJP8J12l8cdq4iZkq41ElVL8EIWI+KEyIU+8nt5bsTE5Dt1lG5y9u7DG55npVqN1xGaLpIWUj3jAwfctAkYMgLpdZS2raOtzd6NYTGgl3t6WZb68duw8geeQ1OcedS39vrI1TkgBNMbMNH/s8GPGewQwjKwMEm0waKJ3q7NzUuw2iNdVbhAFT5GreK8qZCMGdT7K2qsiEzuTH5pFEq41ni6uENjfzLW+5kWqPannR9BUmimpjkjZXaNTWXct4D/V2WX46eGNwOxFQcc6WsaPzJV1DyHZx+1UV4a070A6EC5yb1efp0MayvO4o/u1lKUFFi/qKiiJVrj6gQalr4EbcaafFiWQ2pBRtDACrrcfOsu1K2QMuztjsCB88/DBqeI79NQt2QYF9QxKRgrOyquR7s/g0bMaxqQJiInY5nScDis/6p4vd1yQUPmC1VR8NLSxh/xFzx/KbccunZ5kArEoi6YHUSY7ryLtHOgLMfuCJ3DHbKzHNk0bhFYvQHr9dYHLgZS8JCKecfQDzg7m/MUoChsfVnWdJen7efbFrZ7iA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?6KiE1nb9vDyJfbwRmtRWcpFa1Uv5uqkmFDPTWyVJKvVK32qTbPn2RQ5Py1Yl?=
 =?us-ascii?Q?lB/pKwPJaHLhZzO/0ULXxcnHtDY7EXJYB68glNizvI4ydAH7zG/+TzoKF8C6?=
 =?us-ascii?Q?ewDdtp5ZB6OI+vIHHB46S2Te6465OwOM82eJIugIm84PpfF/Ws1rn22vDdE0?=
 =?us-ascii?Q?t2gWX2umeqGLCWjd2nwdGEYUjC/W47THqVmaMNul/UeNR5sSnjUVDgr/N33h?=
 =?us-ascii?Q?ZzVQYy1wnoJSIvqnBv08j2/Gn1UzBJpl46V6TPBU9f8Jr0JyyswweLSaO0hb?=
 =?us-ascii?Q?/3028Cbhkyqc93s7lqYKhu2LF6nvlZTg3bvCWy1cj1Owu6jcfy7EAAAs5wv6?=
 =?us-ascii?Q?1l8VeN6b4GOGjc2thP66LrUyr5UV/KN7zhx5ndIi8gKMVPJy6YjlkHGuBSaq?=
 =?us-ascii?Q?+9gpJBIgYnE2w855f5s34kIdrZmSXyq7BexlbQDrpKu7l+4AOjqX2JzFBf2h?=
 =?us-ascii?Q?T8ZY50G4Rmbox2bN8YsS8maJnx2++oNFn0b5Ms1b7CtiP0LC0MvLa8oCp6WD?=
 =?us-ascii?Q?8o405/cOHxBvXLbiqF8B7KFjVge5O4VLOLJzwH6CeN3gKwaHPcbDW9nqCo3+?=
 =?us-ascii?Q?4AHcKOQ3vqJG7n0pVapKsV3COZhJdNLJ630miEIDI/DmFenXFc8mDxqlhgFM?=
 =?us-ascii?Q?/DiPJ62MmEQGcu7RreiD4iP8+rrr598nVy1a2uXVjacQxsiLAMkyXt30H+nr?=
 =?us-ascii?Q?29SzPLw6TOHtk4vAsFUjU2A1aNAT+HNWA0fgNc/kW8DzevwfW8LTcpG3RdTl?=
 =?us-ascii?Q?cqSmLRguVe3fXOfof3muuPG/CRsSxnHqpzXVDRYb6EwGK92+jhfBJMmbi3vv?=
 =?us-ascii?Q?G3zTMrFlWSZPrbWHMcHXKUrdFHZ23ToWcmcMfJmeyQdYfKC7jen+WxgLWZim?=
 =?us-ascii?Q?v6roLiBVWNU+xcjEZns+HYnUcl/N7v0xKtIreWS7rPKkDiE69hmglVOCZ5ei?=
 =?us-ascii?Q?GeLYBtykfV8MOE1mI2aEBqjJMNxWtF5QvEBQQuLZ//Mr2+UIWrsQ2KXXrkiE?=
 =?us-ascii?Q?6x7IDsmsTQsd4ictjl49ZKu/yUZ1grQqjLqykY8BXB8BS2wSnJjhMuEbuIGI?=
 =?us-ascii?Q?Q0tGhD4umctq4IaC3lG6x8Z6rdPP8FQ++baMHSHTQkH0MjYUGuxmGfCde69d?=
 =?us-ascii?Q?9LB1TNvvUOD3/XHaihd7d58Bg2MCPIq4uXRcHq3WB81dLupVwRHtX+FYfTr2?=
 =?us-ascii?Q?VzzWCZjD7ChqYM9kqMiwe351xRODfhkiatkrF7edAGi2oiz0KdS1wjIZoLtn?=
 =?us-ascii?Q?YlNkc42IAYtLTZrv3cvihAs5kIgagWhEC9Oj/Zcr+rPUSQD/mVa9KL5+SsyJ?=
 =?us-ascii?Q?VleZNeM87ofWUBPIe/uahS13HLNuNCIlBlTpxymmfuRvI05sZj6Cb9HPi5Ml?=
 =?us-ascii?Q?AUOwJajDPCS5RxMHBgHV5HVlMsORQ+b7btvO7eUext3PTSG/rqsztDpNqtXt?=
 =?us-ascii?Q?P7E1RH48LDRdJ1uUEY1Rb4Af6XJjn53+VSTVYMsPGQYoinuhA4/cHkjlWtsB?=
 =?us-ascii?Q?9uomIvUXyR8xK+pvEgJntOe890Xo6UCD0kqNmY0RrJ/LQOVU8QZ0C0GnOW/G?=
 =?us-ascii?Q?wyToSHgtMVQZ9vCMiBAIh/OTaJRo9lwW5oOoOiUH?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f091dad4-37a5-409e-38ef-08db351c0571
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 JPQIEprZ/ry/abEQ8fM15syFZ5vVB8Vw2KWihjnVUgz6FOTGc0qxagDbb3Mi07JvWbk99zJ7oDySPVfnAsXBRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6902
X-ServerName: mga12.intel.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com -all
X-Spam: Clean
X-Proofpoint-GUID: rqbyT9rEOPorQQP2TLV93k9Co0GmoT0k
X-Proofpoint-ORIG-GUID: rqbyT9rEOPorQQP2TLV93k9Co0GmoT0k
X-Mailman-Approved-At: Tue, 04 Apr 2023 17:24:27 +0000
Reporting-Meta:
 AAEHTOj+S1MwozJ/3M6CwhBwRL7qHXwyE2zdMO8k6NpDHnVH6YycC8Ga57f3ZdO9
 rYpVgFPMrRAY6mpd9SFtMIJgw3WQUGUhhztIW+TJ1qCunhc2cNRht1p1SUOPcUxm
 d8uJ4W30oIDuK5+UBGHyFXnBhu6XpAT+Jwce4SxIua7WNAbZ5Gb38TYZHGiwQmcK
 jRJJeMONOtTl/4ylqstfDXOmeksgob2wSXhxEMK2chAj+pa23UvD+lmAZBBeNZex
 LjQg9fr1MLTPCoeurpHRRT8hXKbUFQIfNPBwILu8fTmCTWzu0hIz9KbFw1qp+xKA
 OFPNeT3zPKnaLOyZDDJpznNKtP0AsjuMfJ9JjwVtl0M48ya2iMYhJL1/bEfuuqw4
 LC409QXX+ztdK03OE/QOg7iZ/JcbWtFOIZbJz7ISnIdIReE0eKGygBwMhveTwQ63
 QaM6kD++gc0bZqjHQRsFT1NjAte9ed/kymJ8Ur76FfSBf6aOwicXG9DUXgBodj7g
 VW7uD7VccEu41ITRY3bgEkSdGzwhh7u42MD/0KT447/W+A==

On Mon, Apr 03, 2023 at 02:20:55PM +0300, Dan Carpenter wrote:
> Sorry, the kbuild bot is not supposed to send duplicate warnings.  I
> don't know why it was sent again...

Sorry about this, we should ignore this commit in the bot. Now it is configured
to avoid the false positive report.

> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   7b50567bdcad8925ca1e075feb7171c12015afd1
> commit: 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ocfs2: ocfs2_mount_volume does cleanup job before return error
> date:   11 months ago
> :::::: branch date: 15 hours ago
>        ^^^^^^^^^^^^^^^^^^^^^^^^^
> Something happened on Apr 1.
> 
> :::::: commit date: 11 months ago
> config: arm64-randconfig-m041-20230329 (https://download.01.org/0day-ci/archive/20230401/202304012244.gX4H4rBO-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 12.1.0
> 
> regards,
> dan carpenter
> 
> On Mon, Apr 03, 2023 at 07:07:37PM +0800, Joseph Qi wrote:
> > Hi,
> > IIRC, we've discussed this before.
> > Success return is expected in case of 'hard readonly'.
> > So this a false positive report.
> > 
> > Thanks,
> > Joseph
> > 
> > On 4/3/23 2:14 PM, Dan Carpenter wrote:
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > > head:   7b50567bdcad8925ca1e075feb7171c12015afd1
> > > commit: 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ocfs2: ocfs2_mount_volume does cleanup job before return error
> > > config: arm64-randconfig-m041-20230329 (https://download.01.org/0day-ci/archive/20230401/202304012244.gX4H4rBO-lkp@intel.com/config)
> > > compiler: aarch64-linux-gcc (GCC) 12.1.0
> > > 
> > > If you fix the issue, kindly add following tag where applicable
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Reported-by: Dan Carpenter <error27@gmail.com>
> > > | Link: https://lore.kernel.org/r/202304012244.gX4H4rBO-lkp@intel.com/
> > > 
> > > smatch warnings:
> > > fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn: missing error code 'status'
> > > 
> > > vim +/status +1809 fs/ocfs2/super.c
> > > 
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1803  static int ocfs2_mount_volume(struct super_block *sb)
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1804  {
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1805  	int status = 0;
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1806  	struct ocfs2_super *osb = OCFS2_SB(sb);
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1807  
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1808  	if (ocfs2_is_hard_readonly(osb))
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29 @1809  		goto out;
> > > 
> > > Hard to tell if this should be an error path or not...  Canonical
> > > problem with do nothing gotos.
> > > 
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1810  
> > > 5500ab4ed3b8f0 Gang He                     2019-03-05  1811  	mutex_init(&osb->obs_trim_fs_mutex);
> > > 5500ab4ed3b8f0 Gang He                     2019-03-05  1812  
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1813  	status = ocfs2_dlm_init(osb);
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1814  	if (status < 0) {
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1815  		mlog_errno(status);
> > > a52370b3b182f7 Gang He                     2018-01-31  1816  		if (status == -EBADR && ocfs2_userspace_stack(osb))
> > > a52370b3b182f7 Gang He                     2018-01-31  1817  			mlog(ML_ERROR, "couldn't mount because cluster name on"
> > > a52370b3b182f7 Gang He                     2018-01-31  1818  			" disk does not match the running cluster name.\n");
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1819  		goto out;
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1820  	}
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1821  
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1822  	status = ocfs2_super_lock(osb, 1);
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1823  	if (status < 0) {
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1824  		mlog_errno(status);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1825  		goto out_dlm;
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1826  	}
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1827  
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1828  	/* This will load up the node map and add ourselves to it. */
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1829  	status = ocfs2_find_slot(osb);
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1830  	if (status < 0) {
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1831  		mlog_errno(status);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1832  		goto out_super_lock;
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1833  	}
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1834  
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1835  	/* load all node-local system inodes */
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1836  	status = ocfs2_init_local_system_inodes(osb);
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1837  	if (status < 0) {
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1838  		mlog_errno(status);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1839  		goto out_super_lock;
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1840  	}
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1841  
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1842  	status = ocfs2_check_volume(osb);
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1843  	if (status < 0) {
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1844  		mlog_errno(status);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1845  		goto out_system_inodes;
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1846  	}
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1847  
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1848  	status = ocfs2_truncate_log_init(osb);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1849  	if (status < 0) {
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1850  		mlog_errno(status);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1851  		goto out_system_inodes;
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1852  	}
> > > c271c5c22b0a7c Sunil Mushran               2006-12-05  1853  
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1854  	ocfs2_super_unlock(osb, 1);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1855  	return 0;
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1856  
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1857  out_system_inodes:
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1858  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1859  		ocfs2_shutdown_local_alloc(osb);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1860  	ocfs2_release_system_inodes(osb);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1861  	/* before journal shutdown, we should release slot_info */
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1862  	ocfs2_free_slot_info(osb);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1863  	ocfs2_journal_shutdown(osb);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1864  out_super_lock:
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1865  	ocfs2_super_unlock(osb, 1);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1866  out_dlm:
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1867  	ocfs2_dlm_shutdown(osb, 0);
> > > 0737e01de9c411 Heming Zhao via Ocfs2-devel 2022-04-29  1868  out:
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1869  	return status;
> > > ccd979bdbce9fb Mark Fasheh                 2005-12-15  1870  }
> > > 
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
