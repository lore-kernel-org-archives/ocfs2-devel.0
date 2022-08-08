Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66E1C00140
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Aug 2022 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SqQ0uYb0Ob857nirt08AhGnrunyX9DxHYhUfoXzDgfA=;
 b=z33eU7ikpBozLrOtwODG2FxEFHkim34mXTVJmMxJAVdUqq+CrODqs6iUN71EcmwdACYEGEf0PFHd
   qKvvvR98B3eiERaCvzAAkA66PcI+jZBgaNiKUOoVvTZCiqUYSpiM0zDXoQVjpGO+PI0AVhnrvoHF
   zkG/b+9nMblrmw7arm5x0CIUSCqcJEu13++YO8bwfFpjZSiiSeFNZGZYqAzbIm7ehHYLyOt8XlV/
   ECzaOvfrdsdR4VQtD2dw9yWTFHeaYapfoc2n9Uc2m7FEuP/SAluAEP1PBvGRh7TieYBml02jpKeV
   nLf61W+e4glZAvXkanomARO5PKU4qGvVIM5b4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SqQ0uYb0Ob857nirt08AhGnrunyX9DxHYhUfoXzDgfA=;
 b=qcuyuhmHfvOB4VRWxHyPoyASastX6MuZKxHfSJUOt99qTU/5Pfi7ALL3KTeFLiZxBz8DUOUSybDW
   sE6339r3e0zG3o/YquRyIVKqe9VipQKrN1BEhBy+G+QBR3DQEcbPhtcv0OHElFxD35oqhLcipaV8
   7Jzv8/Nj5CJ5u1zfTCixLOAkXEjqJdmA35F878BFPts5JmB1PyUjfLe6dcLyfT7mAsXtTz7JA51g
   ybKarkVndUg1Q6f+gFKsikV/fhd5v7no8QpHc+bZgqwFLCiz9VJwCwHEEbgez+VFar7E/l1cDz1u
   HA1yhwGWNcVQQweUcPBNK3kioAKRHcmeU8p3OA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGA00BS7I95TO40@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 08 Aug 2022 09:27:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+vLQ3y7A+QmBdJjslVKBUBnmCMvto+4GZxSTjuSK/QPGyutVdsciyzvWxGWbx4Md+yA1x5YHuo53NJgVoEQDLWy75vX6aj719vv6ufaO6WFBANTNy5LTeUG1jt56taQGqRixM8WzkWmhlgOoi2VN8FuuVSEiVVmflHuc0EW0yDAviAFYmcU4byftm6RoMrkPDyeaXtdnGR2xbfG/JIHm6kUf8sUsGG0PB6OpaXu55APOABtVMYZX5efFzhewpEijh7Fyjt06g89LSmMteOqRceTe2Srar4RXI7hXCjEyALl9HIQKpTVBf1kmFQt/lDhNAQ5IS2b06wkgGD1V1eCBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+24tPPA2HLWiz6jEQu8F1DRHg6WBRfNt9a964eojaik=;
 b=O+FLbQHtO3QR14ESqr/iagj5XjuEWF1TkHOMYJiq0+Z3KHpD1C/2sNW9pXRw2H2r4MrrZoOzl3E1aNRCOZVEYIrMzN6zfvUyWQvJMta6SNCCHZC+fViiTgeDWYtjuw27wCbq3zcCT4rx+1637JMBbQJ7ujJBdOjZBVceRT2MyJ2XxGDTBXXqgdcVwBkLLpar9PpGoIL7JiKiNeet8hz7ZcsvZzcXRhcf0C9HkCqXfUl9DNKhbHBF+b4XZaki/fnpXn0kPcFuPfQ1Zexn17joo5Oj1bjzTe3QKBOOL8t+fDuuDn9gzR1n6hUZNWkbMv0BvA0uf5BBSIvCj0OSUvKuyA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+24tPPA2HLWiz6jEQu8F1DRHg6WBRfNt9a964eojaik=;
 b=Qw6TuIxJypF1OczmGDgOcwPVOVMmCN7YRUUb81C/RHUUglNo5sb0fmB/B0YozoH3EveOK3Zi372nRpEzSW9pSMBfDrcM+fQ8Pqn34+u3F+X3v5OhuW7tx8bp+DyoTyD6IPILOftrYzFX1JYJ78yMn+B+RsiOPSFZbyAoEUT1l3ibhlbj5XMqdLsMIXEiCLwgkdVFRGenP3uGdILS2jfTehudV2kUXd3J7nBZK7oHykXp1jFzRanvLtpS+HstMjDTzhv7uR6+GNTSFaWzA5zXLjjSWwhvJHw/UQbEgTwKKCAA3aa1xuRCoMnB4qgXF4Xg2vEEaWEFLJ4VtNLOIGgqZQ==
Date: Mon, 8 Aug 2022 17:26:32 +0800
To: joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com
Message-id: <20220808092632.7sfdmyvvajy44hag@c73>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-5-heming.zhao@suse.com>
 <e90f3f19-f790-8018-ddb4-0bb405d45ad6@linux.alibaba.com>
 <20220808090714.w7vojxh23zka4cx3@c73>
Content-disposition: inline
In-reply-to: <20220808090714.w7vojxh23zka4cx3@c73>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR04MB4671.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(7916004)(39850400004)(376002)(346002)(396003)(366004)(136003)(316002)(6486002)(478600001)(966005)(41300700001)(2906002)(33716001)(66946007)(4326008)(66476007)(66556008)(8676002)(5660300002)(44832011)(8936002)(38100700002)(86362001)(6512007)(9686003)(186003)(1076003)(6506007)(6666004)(26005)(53546011);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 09:26:50.0300 (UTC)
X-Source-IP: 40.107.2.73
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10432
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=238
 priorityscore=120 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080047
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 4/4] ocfs2: introduce ext4 MMP feature
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
X-ClientProxiedBy: SG2PR04CA0202.apcprd04.prod.outlook.com
 (2603:1096:4:187::20) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3aa55e2b-3654-4850-2d39-08da79201f47
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3696:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 KzVMHqz2oJoHZQKZuquaplA9aFHdbIXdmShvPduOeGo82SRe5gGqqi2g7ClOyh2x+1dPNzl87H29RBOjlt8+DWqUo3bfD1OHG6DrT43BmfXKjtVFq6ivSQZVQnrfJ0PUlgqtHCOUoGfoyy0a6pJMwXQAKoEoiOu+4oFMKWlklkGHliErWkcUWapm7JsJQQogdsopScXZZofAuQkUrhkzLHR6v1FkPGS/oeQ5oEL//VXHHeN7vYIp9bAfrMM3bE6rq/KTcTbjPn1Zg+COr3lVu3mwc5kCNibSdJUIWapNnCYyd9Giqmu823SiElrFSdoHv4oT+5n5M5b9HnHDJAIqqmJYfr8xZpKQYGPxgL0tUpD0mriJ5WDsb7BMlWL6BhHZxc8VnGVtETwKE+DHx8vymntRfKzomFDbVd2Wra98d+HdK7im+WSXwd5P86JsBtqKPxZocIDOV/o9GHKH+8ouNdEuaVXoQZjDiymjsABwsQEwt0Rqav2FQetyK2FY9RB6EBZ9NTDARRcF+Monb4pma58Tse9p8DTVkXFfrbbOoetid5xBdI5ArWiWeRSqO4+Lp0qvibmJpbdqjey0lNznmrQwTCcboB4iluTI04b/Wvlq0HBU607tVn33DppMjfjAJQrUKYN8NVx/iX9NUPFxes2DmsJ33jsy0XIZ6JoxpWsiLhwSWpK8TdSlM+6vqN8xQpeS3yLjghssREFpOobjuRjD+S0l8Pa2mSyr9yScAzF5+O4HtUOsjJuOKntNmIE8jgOkxV/S4+3CCpmICk4M0Q==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?3TuvIWrvV7d+5Egp2gh2qRjrVBrdzddNWnC8aZ3zqY4fo8RaCSN/gE4r+aO2?=
 =?us-ascii?Q?fsa4Jdeno/t67TDbJNEe+4JG25k1xN+fDrPJspR5fe0LYh5Ag3s2nL75z/is?=
 =?us-ascii?Q?1tX4onECjohXQE6hfXH2JwqyX22xya+ZLIFRVmoFcNy/qzKGCxgsKQKMAIU3?=
 =?us-ascii?Q?J6AMQgjwigDtl8Q2G4P7bH0u74gZz/gvwaY3Xewqv01yNhn/U0vWtQRKWNnS?=
 =?us-ascii?Q?tiIV3dC+6Q3OLnUoRPeW7QAQ62LpBZf/netEk8eiAs5Fd3h/6LTIFdIOq3Xp?=
 =?us-ascii?Q?oZo3/8gimjZszRfeUgucRq7T+e7nkcKUL3gjfooLoAlODhibkhf4z4J6sq1l?=
 =?us-ascii?Q?+bEr05r6zam0hjRkVuFNke2aGYLhDTpR2CiQOK5VvO98pvMU1cjkHNWQUboE?=
 =?us-ascii?Q?kj4DI75Hi15ZjO3tiZts6R8AJbu+HcWh2h1TULhi8AA8YmPcRlclq1diSmBK?=
 =?us-ascii?Q?lZc5RaTXNYOlKxfQMH3SPu9326zn2nIBKeE7PNr3WYfmm0exZOwDxzaAb/BA?=
 =?us-ascii?Q?TX5BKQ0D2T9uWAl6sXTOtmbfXa07WPUoQfblSgzGH9/BV49bcd5deXniPwkK?=
 =?us-ascii?Q?IO7QVdg1bD3BPf4pNxk3BwFCxkgWhzz5KFq+etgObjEMIFlZU+J+ygIWrY76?=
 =?us-ascii?Q?VzvxwWx7PN1RPfzKK2Kg61Uh5HJ6dXjzKsGNNzhKBnuj/6eBRBntBxH1oL42?=
 =?us-ascii?Q?WxYbCU932M27kVM5vY5vDJjuEgiJsyN/KOMJ1I+YA29flFvUf8uOCFUjfKSW?=
 =?us-ascii?Q?/R5zjUIIhaL79BJen1Nw7tSR+mGSFFJOZ9T/gQ8y6xEiG4xhW1NkLcuKTWju?=
 =?us-ascii?Q?O//HnFRujj7Azf7NKFEq4eQ0wtdDVeMvUDw+JBaAwbd6h5mcY6aHoa4R+IVa?=
 =?us-ascii?Q?wpv7pdvsufpOhD3ZAVk5rsPjgo1MwkrdiFTzxUVO6qvqrGbxooAfOZISUHmu?=
 =?us-ascii?Q?weR/cyDkDCYgAVohnHFcID3nLGWBdTXsAW902KB4gT04k8iGj+ke4y+55E+V?=
 =?us-ascii?Q?PZsO64MvlzNGfdZ//8IeeyqIhaCyeNV9zWx75Y0j9du8o8t5jpqXQ74wTQaW?=
 =?us-ascii?Q?HSGWyvwH7RTS4MIysUZlb3xGr01/lKaVxB+PVwH5oU/RLP2kEIvGdsah7IAV?=
 =?us-ascii?Q?sLfuocSlsSzd5NN0iKxt749VVjxCSKyIthjJhScDLWeOst9pu1jH15Ll1Hvl?=
 =?us-ascii?Q?4RLupIhkSqsZ6K8W/SsUxM0KpXyl3MIcGQC+qi9t9IgCiRagRejIy85Ao4lO?=
 =?us-ascii?Q?tmLZLcz3znCBrudpqIc50LBgWUoEi4D+RpEpJ5VEzk2b54Vp5Gs2tee6ZfC3?=
 =?us-ascii?Q?soPMQBVqtJaPLmkqF5ZJCZ8+wJpyWPhPFq0Paifm4SFz/nsZrcMsTpiLc8ZU?=
 =?us-ascii?Q?Rdyrbg5QJkx0w9chrT6zF78YeBDxlaDvYH64pxlrIY0m4ruk6TxptCE9r9/y?=
 =?us-ascii?Q?gqZMVyATIPnjxWpbeiz/iQzZz1VhWpFoEc7zjeX3jRHJTRywP29mSF/B4+Hk?=
 =?us-ascii?Q?1elGb8ElG8y4/GRdOGt0pHaSTLnalL2jDKU/62d5XkXIC4bK06ibMgM+trHL?=
 =?us-ascii?Q?NJEVNRGehFwcvJaJAHg+HNn8fG40d1HyiZh6VfV2?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 3aa55e2b-3654-4850-2d39-08da79201f47
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 mK/S+omsULQ7D7Ym6VLz1mhiemWnZmn9S9424/YZ60agIZ79tK1/oQUITc3pgiS9ONZ/RLtfsmuyWXbCFgekHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3696
X-ServerName: mail-eopbgr20073.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: an2cOKzyI7EiMRPvvGE63NVP8P_7GozO
X-Proofpoint-GUID: an2cOKzyI7EiMRPvvGE63NVP8P_7GozO
Reporting-Meta:
 AAEAX+6OET4r8Lb7GrUGzSIStdTl8K5Fy7HNXyGoy2ly13jaGiOI9KeKzYjpthax
 gQqXMWEBZi7vP90N+C2rb17bC1yC/v4KGbSDBErlyZqjFNESjR49jeRpT4ZsKuQg
 9ZtHWv8UoC1xSOQW1fRKKIJXsrS8s8W7XaMRMm516jayul8QB8lVaaSpQkLz/qPT
 1gYXROotP3UyohN5HpHdCjbgOD/VokJWuvbhmD5SUvUF9rq45ZcgNmwWLHHarI8o
 DzLjOPNSe9d5PJZ33qdrDVsdWtw1GeqL4bzKDrS9v3ZcwsniMxkldE9VwW/teCB9
 AuqqYKNORDf4Wpp8tdtblnB9ZPploMfxFpu1u452leJ50A9tGJeiY9rgnxSIKwsV
 BtXNaIk61iC3GCZ8KWdxt1ZMLe0ygEA8X8Bgn4bft0DdulcUYSmTcGT2+tMq1GWH
 2CpVJgSTC07Jxspo7nrmX3Dib/yTgg4IAWnnTk4+ZdhjTfHiRTOem+l63i7K9LUQ
 xK/LAX1z4+QJky+ZGtUaTa2bTZIawX3KIVqV5eXNPZB4

Very weird problem. I added Junxiao & Mark in 'CC' field, but there is
only kept 'To' field. I tested to use CC to send mail for other mail address,
it worked well.

On Mon, Aug 08, 2022 at 05:07:14PM +0800, Heming Zhao via Ocfs2-devel wrote:
> On Mon, Aug 08, 2022 at 04:19:22PM +0800, Joseph Qi wrote:
> > 
> > 
> > On 7/30/22 9:14 AM, Heming Zhao wrote:
> > > MMP (multiple mount protection) gives filesystem ability to prevent
> > > from being mounted multiple times.
> > > 
> > > For avoiding data corruption when non-clustered and/or clustered mount
> > > are happening at same time, this commit introduced MMP feature. MMP
> > > idea is from ext4 MMP (fs/ext4/mmp.c) code. For ocfs2 is a clustered
> > > fs and also for compatible with existing slotmap feature, I did some
> > > optimization and modification when porting from ext4 to ocfs2.
> > > 
> > > For optimization:
> > > mmp has a kthread kmmpd-<dev>, which is only created in non-clustered
> > > mode.
> > > 
> > > We set a rule:
> > > If last mount didn't do unmount, (eg: crash), the next mount MUST be
> > > same mount type.
> > > 
> > > At last, this commit also fix commit c80af0c250c8 ("Revert "ocfs2:
> > > mount shared volume without ha stack") mentioned issue.
> > 
> > I suggest we re-split this series (especially patch 3 and 4), but not
> > revive a buggy commit first and then another commit fixing it BTW.
> > 
> 
> No problem. I remembered this fixing style, and won't make this kind of
> mistake again.
> 
> Do we need to wait for Mark's further comment?
> It looks Mark didn't like non-clustered mount at his first reply, but he
> showed another idea for non-clustered mount on the second reply. And I
> am sure what's his meaning/attitude for non-clustered mount.
> 
> Thanks,
> Heming
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
