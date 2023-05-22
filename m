Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9693CC77B73
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 12:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sV6de84oQKwSRHBIi0if0ubG8BhjrmUf5wDxQmRjGW8=;
 b=0SC7+nS6ZDjBhphBU220+P13GTbDM3/1Q0tlmU1uVqp/uJDkY2m7Nlq7aMopW1NXSG0tJYKMWtLF
   wBacJgdGputRHnSx4BlTimQT7ThuROvsXqiBJA0ApBTZdlV6RhLXTdPfJS+O1ZrpIyngwum0I+Vy
   QTGL2JKjsWsi4Mqbug4C7UvwtFD6B6qk5HHluDk593HyW7O95gJ8SWYQAwBp9nOOxtBMuLMoW5tC
   lx+iO8jojJ5vuknVZTYUGMjrXmcV1UGB7Xg/NcMMZ2UcvYtrVLCrFAlILaTLqF2M/0IcCPcaEvOj
   7ppHLOcu82TR0E3EK8rWyo6PY+RiRZDFkKKlgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sV6de84oQKwSRHBIi0if0ubG8BhjrmUf5wDxQmRjGW8=;
 b=WOzEFGQO8ZWr10iH5A+y1DKDFx+jXkpvtkooq8j3gYj07cWBmWYNJgnCVtcbTYDOyIukZxp4GEUn
   jbHVBPIvp7vRzFmIVVMdF473ABhLzepvQr1ZcPcqvGHHEsjreMHFvAZUSDd/KGr0WOuBby095f7v
   6tBRYuLc5Cs/V4eYIkqXhcN98yLkI9XHXiJLpL5x5St7A4iWjFf8NoQuB9XofnX94Gqhs1hsD/4I
   5Xk1sCIXUXvCioJ/DBM/QXWeagDL9spmYO+M+xGGfnqiwXKm5ptq5ChNWWTqWv+RambKe0oYt4J8
   /FRqUuON6RrctbBQNK9U30myg0HIjU2MoRUR3A==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV200BF98DBM580@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 12:36:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6FH3VRuU0Yw71u/sqTkJ63ct7oO1VpzhnWFboUI47+QbC6G2tj1JmWCCrD4HpfGQP85W9JAW0E8RHCp/v2dsQe9OlrabNJtrbdfPt8ekQ075fzmfpiF0G7/DfNq31gDWGsV7Oh2HiU38MrhUIaUX1C19P45WeURgN4A7cpSRDf5yaGo7/XZI1krbSRr+JfE4PB4rcH/8MWle0sgEEI8cIFIX9oWRTvqFYWcqnqY5yLPCD7byE3meQX1fDnXxTMAKWPkE0A2R4jAZZvuADx5QrzI9y98xn4dHPamU+fpF/AW2eKsu5jblIeYi/7bNOm5WxI/2S7dHIbaAzStQVdrjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srwT58UtPmTSfhvGg0HXE4eygBAwvIgHKN3yqqpYufM=;
 b=HdQqN77CltjxQ/A7w4G1f1zEDAKfpaJV/nFxa9nskXSdEO4K/uczGsphfryspzqjPoRPAcnFp923G/t+v1moQ6W13nZhyzkgqnbPoe1RkLebDWc0xcKmzq1WHGATq0Nb1ZaPs/T9EikL8uneaiMeF4+stNUJdklZODuYIycIvuFARV33AxtxTY2f3oS3LZtLXY/CPZPtytMre3a0sjay6dv1j24dyeRJ7kUqkAg1AossVT5KpipoKNPEjdFoGFPSI6hMpBV0lLH2UnD1Iz2QgfZhSqOwgHs4y8azYNq71q01OO8I9ibHZkVE8z+FhreSk18lAlyTMC7yssXkPnOnFg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srwT58UtPmTSfhvGg0HXE4eygBAwvIgHKN3yqqpYufM=;
 b=Iugw38dsZngXHA82z2XBzQ8Qjowzb/ZGWh0tWemM4Uo1lvPOwtMsXfbj7tFVM6JjyzV6QHFwvKTa2iBTUu6ifX9xmF4oy7NRNDCmeGA3Ttd6jfrZ3JBOH0bkYG3pXF9iLDxzYFmsZjNbHphVg7wWP9e5bQylDgE6Zjo+6kGUoQNDj8ltj5Gz0xuU5nOmoqnYAZ7NBcU2PeGllFHy4SZAKnzYXCAnZAlFfVDWbqgf1sJB5cSztKGmJkozXh+ce+0xkhH6kN+qwRXsPfKg8PvzJi+oWrel86no1/bcRvivTCMP+w6f3JWFWIr8/JFWjMs7mTdZSx/XtZqCZwiYn7R63g==
Date: Mon, 22 May 2023 20:36:23 +0800
To: =?utf-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Message-id: <20230522123623.eozzedrogy4oaj3w@p15>
References: <20230522102506.9205-1-lhenriques@suse.de>
 <a57047d6-8f57-3dde-f15f-b24f63d675cd@linux.alibaba.com>
 <87h6s47dxw.fsf@brahms.olymp>
Content-disposition: inline
In-reply-to: <87h6s47dxw.fsf@brahms.olymp>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB7990.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(2906002)(5660300002)(66574015)(83380400001)(44832011)(8676002)(8936002)(41300700001)(66946007)(66476007)(4326008)(66556008)(6916009)(54906003)(316002)(6666004)(6486002)(478600001)(9686003)(6512007)(6506007)(1076003)(26005)(33716001)(86362001)(186003)(53546011)(38100700002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 12:36:29.7816 (UTC)
X-Source-IP: 40.107.104.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 clxscore=323 mlxscore=0 malwarescore=0 priorityscore=48 phishscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220105 domainage_hfrom=9736
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix use-after-free when unmounting
 read-only filesystem
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
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::11)
 To AS8PR04MB7990.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::10)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB7990:EE_|DBBPR04MB7692:EE_
X-MS-Office365-Filtering-Correlation-Id: 77c7d4c8-5eef-46b6-126b-08db5ac12ab0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 SYaUOcYyvqIzv/yGufNRrITCvYcvaJUxgAn+yjb1YO2TP2J7XAybOilyNAMTn129dX2NPR5Er4xIStHs3W/BPneh+ehe95kcIfrkbsKPIfV5+SfYGldphvV9m16vKOYqnguZI3syWjH+2QfXtztzgJ8UkeVxuvp6RI+lEN5Y6Hinvtmpf0Yl+QHqfSenCzp6xJw+w+lgCRb8yt/23pqs0x0UfO+lodIYfzEsWxGb7rvZIseRl4PBz/EjwiNm9egdbIogUaVH4etMBFnAajBl/7RWeq43U24SkJU9OQAuO0W1VpYFxdthTxctZ0hsUYL65cq0367xgdRHYlrfErzAVOQUKgB4jrbgVHJGvtrWpbqm435VpvV0Qy1/gS1XLSZRWDGSWjHKm8pZW4jyk0QvyPDGO2Gif4dwG1thbl6jOC2ah2kPKbah1N6tAmwrHHXtLqUcMIDepsU1mye3GaIbWIKzCfDvyQvNsZviSySVIEixcQ7XkYWld0hKivkM6Koer05VGgN9TqhBFQI4znZiENX0sfTKdfK3b/rJJAIa6XbcD2ei5EF7T5mvptCi8yH8
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?iso-8859-1?Q?JP5ZkavlDewb3fnVucTCnoU4R9beAsE8HzwoKmZnB7qNbgjQ5dlFgsEZKD?=
 =?iso-8859-1?Q?BK+E/2/WagHOcLEMMjKAk2K/7u142o1vzk/7XeoBMze757ESWBf2cJLkwp?=
 =?iso-8859-1?Q?hCKpfkPr8/7bIveHRYJTZNqcIZzbHx60ifiteN2/MR9Bo9wI507cULHcGX?=
 =?iso-8859-1?Q?LM3p+J7V/Qxev0rp6Yjg71dNXXrKMrvyyWU28Ryaiv8vRkyTxdkRrRKNi/?=
 =?iso-8859-1?Q?W6IVtjyQ9YIXAoZp8scNESLFSOLrV9jgssbwW6UCQiCsD8XtHS87f69IeE?=
 =?iso-8859-1?Q?KxaosYr6M1VWKFRhurkvQUnhNSqfzia1XM4iVdZCethGv51TznmEpXuWgU?=
 =?iso-8859-1?Q?8NNS7m5x2rjo6fafk23xUe+REeyyd5IyMiUEYymGroKX94lTsPg2o26CdO?=
 =?iso-8859-1?Q?ctLYW5R5j/jTIHLpkP28Vl8uoWxIBXEYznFJCHUc7MI6o24F9z9NwQoFJV?=
 =?iso-8859-1?Q?jsEQ8MpUHInLccVrGdLAq5aqS0XKvYuhyu9V9+90FOv8dsXcXwx3l+8vA9?=
 =?iso-8859-1?Q?JYLMTkLme9Pve2xVFK8Vx2yVRAjxjzHNpGEb160Nsw56acREEXvtyVA4rX?=
 =?iso-8859-1?Q?B58Eydwu3u6k11epFv41OjGTtghnUq23sb4dY2pDbznKR+qdMwNbh/Ow7O?=
 =?iso-8859-1?Q?eOn/nmhnw9b+XPbChnoaiL2oW/3Inc5kTsO+qct65JeDnn4iOEu4KK3jKi?=
 =?iso-8859-1?Q?JCQhVM6pL/GDFDAa0dIVjbcmw5V9q1at7RLP+Lm47nDoQJXGyDOWwfiC0U?=
 =?iso-8859-1?Q?WdD9sreff/FEYnktkxYvXFz9o+9HXhuS9v3LkHRYuVjMFaSSltbn8u9u/9?=
 =?iso-8859-1?Q?Ts/+bObMcbyG6M8ZJqQOfU5RYHZoxnV7Hgnr8b8anPfVm+TYwgloYZj35K?=
 =?iso-8859-1?Q?t5YlBgGc/1ynE5jK+LeKJFn+wDdPbC/0XkB9AoURz6ktrAMjIZN7NeUeKr?=
 =?iso-8859-1?Q?hTqKzC6dI7Z6miPMDR4E491jfue0K6cV+AmGqsYXZ1Zfga5Hv6DmX8wZF6?=
 =?iso-8859-1?Q?V9NHHbGmMzDXWvYmya/lrbXBoVEjH9oj0nJRnPtvlBl9StFluoYHN3mir4?=
 =?iso-8859-1?Q?A9p4ll7EjAzLxxTAd5V2djcr9QAgEcanXjKfX36Srci1g/nDalPjIHPWXU?=
 =?iso-8859-1?Q?MxHeV8wVYcwtqwuhijNogDld1GMbAez/sftdAyXVM3/fWCbdATW6By98Ye?=
 =?iso-8859-1?Q?azR2KwNIhqQ/SEaomXjZ8+CVj7Uxxz72wb0EZhwjkTocpzllvi6TSNJyd+?=
 =?iso-8859-1?Q?23w90swxY/wB4P4dMTiFka5MYWFL6XZiFtK88CywkwVZecOG2GoihusXwZ?=
 =?iso-8859-1?Q?sinAT7a65uQAuuwUdcunCYSbW+nh9Jq134+UM28x7O3NOukQ1Qk6hr7OVd?=
 =?iso-8859-1?Q?MMQG8xNfi7TaLUyPhEXVcwqUfF3ZNwfJzU+jVI0Kg6s85Qo4Gox7Pkcy1S?=
 =?iso-8859-1?Q?V+RY1LyfxTRzF7MEK6ZdjcIAFI0St1oW91We5zfrN0fbwXKaQkY9Wgg7bm?=
 =?iso-8859-1?Q?pqG9Ic+rNdYM9TRiu1vPbGLO+pIJ3VtL7+CMlNQc0a6tMzs17argj7k3Pq?=
 =?iso-8859-1?Q?e+VCtid6+AybfFI0GPZilnCe9YMJgVfdAwcmbsA+txXgMm97vlistw1VsL?=
 =?iso-8859-1?Q?tRGoK8/EgJRnCH+RxYJtxiw36NuxirOe5c?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 77c7d4c8-5eef-46b6-126b-08db5ac12ab0
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7990.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 PzWmzEmSNPioN3ElFjPu22ho5mfDNMy3m0CLiChDQPM8ZKpG0eINclsdlWMadQJd/5gqDtjO7kxfhqE9Lslu2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7692
X-ServerName: mail-dbaeur03on2046.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: rFbGvTXZV1_g-gtYa5p9IoY_rIJTkrcB
X-Proofpoint-ORIG-GUID: rFbGvTXZV1_g-gtYa5p9IoY_rIJTkrcB
Reporting-Meta:
 AAF6haGJdatFoueFaMbUWuCsdsPgs6UiIdsPGoorvGss5OUpkOqEkqEzznBcRDmi
 iPo0opVpXKU2preKNGYOedLtAqy4DBbwVhoq7RNI0ZSMyHIduuX5gAp/5LQwBX8E
 mwCr+jmIN1ixjHTUoykW6j5QZvjkw8mZ/4C09Q35T7hbS26kIetgm6UtFgrtgcGM
 T01/ixmICGC1aJCd2sV9p2WXwpIum843xMPzwPETa+LqY+M4p2nwptnLPmQg4U9N
 Fw6d+xheV6PnsZ2spi/VAmDIvaAOienN70n64RpV3mTbdbYcnzlZoLajhcd1O1Eq
 umVLkBaY1CaicHPylx6Xr7pv0sgl91kD2sU9KFArzJXC4YmO6YfmCWtQR/w/uM1l
 6ll+sJH2BcWpGYW45hzbAbd1Zjsy5RHvprsgCPB0nPCSrJKgBTKF/tQ3KpHdlweH
 a76i9T+Zz4OZAkWDgMFQpGWqFl2UDPutClZNf2jur8U0A53GyBFf0lrQ01+R1kUx
 9+lEcv/7MGlvFXvYURumTFE0DkWOqAkqT3Pl+oM6r98+xQ==

On Mon, May 22, 2023 at 01:23:07PM +0100, Lu=EDs Henriques wrote:
> Joseph Qi <joseph.qi@linux.alibaba.com> writes:
> =

> > On 5/22/23 6:25 PM, Lu=EDs Henriques wrote:
> >> It's trivial to trigger a use-after-free bug in the ocfs2 quotas code =
using
> >> fstest generic/452.  After mounting a filesystem as read-only, quotas =
are
> >
> > generic/452 is for testing ext4 mounted with dax and ro.
> > But ocfs2 doesn't support dax yet.
> =

> Right, but I think it's still useful to run the 'generic' test-suite in a
> filesystem.  We can always find issues in the test itself or, in this
> case, a bug in the filesystem.

It looks you did some special steps for 452. In my env, without changing
anything, I could pass this case successfully. =


- Heming

> =

> >> suspended and ocfs2_mem_dqinfo is freed through ->ocfs2_local_free_inf=
o().  When
> >> unmounting the filesystem, an UAF access to the oinfo will eventually =
cause a
> >> crash.
> >
> > In ocfs2_fill_super(), it won't enable quota if is a readonly mount.
> > Do you mean remount as readonly?
> =

> Yes, sorry. Instead of "mounting", the patch changelog should say
> =

>   "After remounting a filesystem as read-only..."
> =

> Cheers,
> -- =

> Lu=EDs
> =

> >
> > Thanks,
> > Joseph
> >
> >> =

> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Lu=EDs Henriques <lhenriques@suse.de>
> >> ---
> >>  fs/ocfs2/super.c | 6 ++++--
> >>  1 file changed, 4 insertions(+), 2 deletions(-)
> >> =

> >> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> >> index 0b0e6a132101..988d1c076861 100644
> >> --- a/fs/ocfs2/super.c
> >> +++ b/fs/ocfs2/super.c
> >> @@ -952,8 +952,10 @@ static void ocfs2_disable_quotas(struct ocfs2_sup=
er *osb)
> >>  	for (type =3D 0; type < OCFS2_MAXQUOTAS; type++) {
> >>  		if (!sb_has_quota_loaded(sb, type))
> >>  			continue;
> >> -		oinfo =3D sb_dqinfo(sb, type)->dqi_priv;
> >> -		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
> >> +		if (!sb_has_quota_suspended(sb, type)) {
> >> +			oinfo =3D sb_dqinfo(sb, type)->dqi_priv;
> >> +			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
> >> +		}
> >>  		inode =3D igrab(sb->s_dquot.files[type]);
> >>  		/* Turn off quotas. This will remove all dquot structures from
> >>  		 * memory and so they will be automatically synced to global
> =


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
