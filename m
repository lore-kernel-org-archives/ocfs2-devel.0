Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1A4C00140
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Aug 2022 09:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=imiIrTxQS+P40hBGQ0EvLAW8OBXVgvnbSC0a2wObF4w=;
 b=rdChTHlQVlzgjmfuex86BUCmkgkAqx70GqfRDYnzEAkdtreD9gPyrSd6c55hWbqerBnxOJ3Lrwom
   SGxn0kSeavC+X9YTWpcnd0hzl10uS9FS66/mj7vp6v2x1J3Tqr2L7R4MXYvcR+LPObc+nblx41Ln
   29Ui3xwHabK6yuTo3ei8UseHckksUKi1DB9tjoxTvlHTKb76bUS8CpixQ7TQj9KMgD6FpeSghJkv
   Yra4WQqtqsQsHqcEaDY7Tav2Q5PjxVkksjX0WRl+Ovir6ATPkq+N53U6kHvCsJeYQWzGza6zUatu
   YeGkH3OM0IftLmEukTPJ64pMqti3oNnzsqaJlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=imiIrTxQS+P40hBGQ0EvLAW8OBXVgvnbSC0a2wObF4w=;
 b=FsqAqw4QXCIjPmbZTGW6jD6t0Jnphymb04vm/HlY25kunbf7OzvYn95jdW39IDAPvphrVr4+LNRP
   Wx2/IIjT5qpkU6AeTS+UxuQ9JLdzjojTarwHGJXW0ouxJPpxIDtaPbO/C5L2U8kjLH+akQ1q7lOF
   RUofR+A7BD4ZoqrP4nWpv7zjU2gUJSWnuXgh8BTOUXzqnb91jqzDs7QQso1u0psgRPGqi0HSMU3V
   XIgCD/1aGlAwZYmcXyJDLHqj4lI7I2Y6Ato5Azi+wQdCF1dn+Di4E1Wqyq/ItgqOTUUyogNIb0q4
   de44IQ6sZ2s+uh5T5hwSBs1s0DEQ/XqlbzKwUg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGA00BACHCVTO40@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 08 Aug 2022 09:07:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4dFodFwCs+Dnwg6Gpe0smgKia7Qotk2Sl8DzzNeQyXGPkr34yV9pqX2oxAcY/rHl/VQI4jsDjYhwlIBlXktZUeo3byxSbMM9NdUtLb+rqcLf6sEEoqXgsiLWvqjUCoC0BQyGcm2hFu3pku5B2z7Jle/6FsO9O78lRNQG6Uih6PmoElmGMY+SCTAKoXVQZnyKlRZkVpc+yyEhoz7XcNOxSQuWAcaj4DbsafO3kZ2m+Em5KvDZC0Sh/NdqWipPnoEuZ4BsGGG5oWI1/DDe+G3V8ewFTLWTCGKcKpXjmvHMtjDeMSjwXIZvPsBFDOusbWcSj2umjAqkyh33z+YQukdqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqLG72xUIOg7H6L4Dk8FNZdkKg0sBKBb1FKHVkHJws8=;
 b=M2Dc/TNL7i/vR781Pp8kd3Mwd3nPN/jH4VRgO4MBmZ0msp6PfZHk5Wz7mM3hUWRRtUD90krLB2TzbUrPvt4NgBJt/iRQcpjc7ARq7IfVIp+Am8YulZX98TTBpkEfr5sVTY7RJNTPAM/CwsYAQnWTIUWiZSjEEkd6ehPqdlOw+AV/aXRxU/SHnUShCoiN/0oraAaM73+UoHewIDC1hHm46XMDQzErsGknC0TdxL7zEMvsyNxHnwhECVW3TXW0cr4kTjkq52W+SCgy2p/YfTYD2qE1W4TOfdAMeu9TlHdr7NUrMBQOlfm1+j2gZw+wCgjxT9CB1OvTAzEAvV7mp0Hb4Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqLG72xUIOg7H6L4Dk8FNZdkKg0sBKBb1FKHVkHJws8=;
 b=H1Ly+X2bbXgeoOaQVOy0Tzx3jsX5IJ+yQrBgMw7N+APiivBL9AX0LOGhnNME/xqjGPPEDTNYz3kwHla+Y35oCyGXQhxcRm6fu1YyiFpsLKk7CJTp9rFfBPqbsZXUCly4b9OOhk3SiBK5afMnR8KcJKHACrgrQqaOF2UM+Pqo8KlufpqwvAQcXLH1LigQHGJN5aysSmXPqwBo8HV/PWTIeEB7Tt4DpJW99ozPO47vob5qBnagDfYW9a11ot+8I/koguFSIBzGc+2oZ7ZwA9qlyF0VRM21tu6QKVZxhdmeHUCIhXKMEjP7QoWxXhWSlXRmB2F/AVcSRKFfQpnSJKNxWw==
Date: Mon, 8 Aug 2022 17:07:14 +0800
To: joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com
Message-id: <20220808090714.w7vojxh23zka4cx3@c73>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-5-heming.zhao@suse.com>
 <e90f3f19-f790-8018-ddb4-0bb405d45ad6@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <e90f3f19-f790-8018-ddb4-0bb405d45ad6@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR04MB4671.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(7916004)(396003)(346002)(136003)(366004)(39850400004)(376002)(6506007)(33716001)(53546011)(41300700001)(8676002)(4326008)(66476007)(66946007)(66556008)(6666004)(316002)(1076003)(186003)(9686003)(6512007)(26005)(86362001)(2906002)(38100700002)(8936002)(478600001)(6486002)(44832011)(5660300002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 09:07:24.4578 (UTC)
X-Source-IP: 40.107.7.51
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10432
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 malwarescore=0 clxscore=238
 adultscore=0 priorityscore=120 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080046
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
X-ClientProxiedBy: SI2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:196::14) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a4aacd6-3358-4258-c0a9-08da791d688f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4304:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 auiRzV+LsIxVJemdi24R0rZzR+8IRenxZGM0WqpHG753zzZgJtfAIOCvOg0c+mty3/TJWzqPrKc+aFQFZj14GBmu/H81uoy1xHJiu0EJGTUgYeJ39YZXPLvtwsTuDGBsowj9aZT8Pw+DXr0ptjGtsm5rzgsBTjPEW7SL954IqR1xHTW+WCA7ZJVRReMkT/XK5p6+4SDoNDSD4yB2RmT4g/BPnpN71bSO14Og4Nu+QP+76zCtzMjAAAavBaupZeLxgHwiQWOPhCrOhVjRPriWoOrVjEngknHanB+YJgt/Nb615ukCH0GeU78piNwsKcWTVBaUw6XzTUAWnDFXk7vecMtcKw+8SgsDZJipMd6Uiz06p19TR6jlu8WPONRnh5uMBnMwSoA1POcvZ3isPR21EFKvsB4w6VtJQAUPLasOb+VYTBieaX/aAD2W0OhryfzjJQrMpTNiU0Vsbk0sjipQdAK2iTlciMteykVSyoxSgHa7uaL9bmqDfHYRSFapztTe0Mg4ECiXudSMRysN3yso6HTLzW4oZ52HdSeKd2Nu1xiuGi6mprmAaYS3ANTQkS5aUM2JGNMheHHzt9JXUGPzHKmzoBpaUyAseZn4+3eFlQgle3XjF0hmUU0sqXLp6HoQQGtTKz9ht/Ig3UtBc1TNxRdqaE6q3nFE4JjevH+vVumYU+lHg4P6SgizOGh1TDhS3hJ+iBebO/ekeuRTH9fZf3WUhRQEfobiXYPB2F58yE8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?E0LtWUpvdlJKVA0t3UjxXsi7qXBAePhOkxXQD6/sYNMPOfgG7J1HOuIHGMye?=
 =?us-ascii?Q?7p02hHyYDeXXjDfhnKnVIMRbqqySaL30rZi0Gon/JFh88wXQaoKFkNNDsGWQ?=
 =?us-ascii?Q?u0oowXw+LjpDH0DTEnt5h9qlMors9bjxX6z9gDi8AUeO8tSPuVV57Bj5CufX?=
 =?us-ascii?Q?l78CIUPhAqVOo8zgFnGZPbxn5rFu2WtUvp1BAG9Zif0BFqkaCLk7OR45g+KF?=
 =?us-ascii?Q?w/vlGwOMHBr835n0IDWegPskG8R47mYRUQZIuHBCj64Q+RB5Ev+xYkoezT0E?=
 =?us-ascii?Q?BzcN+la50cBVn8AZS+ylkStS1RvHYm2eBNJV7vgrU5BNB3NGDP7/miESx5tv?=
 =?us-ascii?Q?XX5YvCKKAV1e97gA2LnjiSKVv73cfXTeheoR8XaNnSt/uXhGsMB2LUqCkGhw?=
 =?us-ascii?Q?r56Adox/dNbIk3qw+yYBHRGtD+JOw9odh5Pn7Z6utf7Vt6oRMo31ZWksUkph?=
 =?us-ascii?Q?4TLY00ATgDdsl08eBK83hZDSZ0dgZ0WkBz0Ni98Thdib504Au2zLIGnNsyPj?=
 =?us-ascii?Q?7O78/6NW2H3xR56j8Qx5mPsirvMQ8FEAp1SOhoOdl0BCrC3iUr8gDZmMMjb8?=
 =?us-ascii?Q?gzUCxptxKr9ewLZaUxvuyimf/KOjLppA6JCliP7AbRtE+jv/wauXIieaoVmg?=
 =?us-ascii?Q?RIMli8HLWw+LYx6jOng4Ak0j6OXMIAUE1LKcsyAgKidWHT/UJo8/pqt6aRsU?=
 =?us-ascii?Q?LiPXHctukY0HIOl8Rf7cGYy+MeEu3JnjaMv0DaqfkJf44DWpIY6Be6YQ3Kng?=
 =?us-ascii?Q?qv5nSd2im9aD7TB0jtVYNn+VD0/DE5J0KEC1D4nPnnVAnZFSSDILiIgqbWb3?=
 =?us-ascii?Q?W6ydIMI+iiu279r5EhcEJS1yLGi/nDWNsLMJWtR3fV+UBbwvJ2KswQdbCECY?=
 =?us-ascii?Q?GuMoI3y+KRGOjUuIW3Cai05Q6b5tOWYZrX/jMmt2na1hRR+vvFyZRXFvdo++?=
 =?us-ascii?Q?f8H3Z+ul9vg/iFXH/LzweGkrVSrUW07XcQHGc6d8AW+FSqQVrqMfZ6gG7rTl?=
 =?us-ascii?Q?Qg8ZNhdW2lJX6srDolx6Dl3b6ieGVTNgUfC2aTjIWC0s1GYjYoEjshJE/SdP?=
 =?us-ascii?Q?jtS5QT/3tXF3aBN76HXMUl+oMBsd+Ky5Im+g+LvkSJIVO4p1ufTe1KQk+Rd4?=
 =?us-ascii?Q?KT15GL420wVJxR08tHgQaaKn5ptcQwgn8s5OYgDaxgL6UrN3bbwixuCuXOoo?=
 =?us-ascii?Q?5RcJDLoClmrXWYfArmBhvTrwbAEa02vVRUIjbZlnxjhMAv2TJOFArwb5/c50?=
 =?us-ascii?Q?jxSFlT5ijaimKDF3Qm/+VCtkjQ/S803DBwu8FCU1bTNhctj1ukOLIoVt8XSk?=
 =?us-ascii?Q?UfDQFzA5MWpVaMtPZYCdbaebnWB3mkfwh0O6QkPNsJx/40AFpIGz5x/8h96p?=
 =?us-ascii?Q?aZ1Mp9AoNIr6aqZmhKxH4+r5zWKa7Cu7gbQYiP/X8XbFUsbAcmfLTwX6+3PI?=
 =?us-ascii?Q?Ln3HMbwk4BIBYgU3ShPWFn9Znk1jEmeQAcg/Bti+VFrm8J1iq3P3Lawt8IBD?=
 =?us-ascii?Q?Zfyl8TmDg3FDt0qRQvivn3o3AUH0Qu2cLHofD5FkD9dkIZ5Z+vXmYpRmxwrA?=
 =?us-ascii?Q?3WNFJwayJ70/UmkzYdhJa4icJxpdCdc3D4ykhtOX?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 8a4aacd6-3358-4258-c0a9-08da791d688f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 imnPykbWEoKRHaBpKA7uO2ceVi2ZIlFC5FFT2ziss0xQh5gc3dRJrx0NISBot8hgtXBKACjH8NwGdHG9glmFlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4304
X-ServerName: mail-eopbgr70051.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Xv_7QsAvqiY56mzJN2xb26u0JVa_2zby
X-Proofpoint-GUID: Xv_7QsAvqiY56mzJN2xb26u0JVa_2zby
Reporting-Meta:
 AAHuJljMsvRfaZyeyZlYNsUmyCl+6yiXFxL3UpP2a7c3VuOOLCmQabVPUK9COygG
 d2XXzx+8NlWsMd5/z6Z/UXv1YPf58zLaR/0vnfcFKfWHQ5iNHkoWdYWllvcvNY2H
 PxDVa40+7LPa039vgQPirTELTRALKz5aqNG2wAdv9kVMKgwWb4LzUgckF26dRTEH
 3cEXXQp3NM2O+EWXTq9/DcAxBZ2MYQZT75vVG9smCvvC+a+gFHsTutntcQM+PZue
 sCPEbb/55N88/HTUVB+EUM8TBH8xpOoTFo5L2Z8Ykc55UEKTzQgcnDzPO2tEvSN5
 4IPnG3DI5CqCj1H5Tx2K8gJnN8NedNNlOswGYslY8Zj84HehMMENs4mNM1OE755U
 XdIR4OWvMGkl4Rqo1KWeo3u8/HixuG2gHR+oRth5+RW6esyFqdP3L8m//oxSZ1fY
 EnYzzcWlL5MY9EJ684vTlgr3Ql5g/48puEr2sT3I/R98nDpMTXAJ+jxEXAavvJn7
 iQf5hcoHhU2MRur2jUc55bd1EIrxdLlFYnD822TR7WG/

On Mon, Aug 08, 2022 at 04:19:22PM +0800, Joseph Qi wrote:
> 
> 
> On 7/30/22 9:14 AM, Heming Zhao wrote:
> > MMP (multiple mount protection) gives filesystem ability to prevent
> > from being mounted multiple times.
> > 
> > For avoiding data corruption when non-clustered and/or clustered mount
> > are happening at same time, this commit introduced MMP feature. MMP
> > idea is from ext4 MMP (fs/ext4/mmp.c) code. For ocfs2 is a clustered
> > fs and also for compatible with existing slotmap feature, I did some
> > optimization and modification when porting from ext4 to ocfs2.
> > 
> > For optimization:
> > mmp has a kthread kmmpd-<dev>, which is only created in non-clustered
> > mode.
> > 
> > We set a rule:
> > If last mount didn't do unmount, (eg: crash), the next mount MUST be
> > same mount type.
> > 
> > At last, this commit also fix commit c80af0c250c8 ("Revert "ocfs2:
> > mount shared volume without ha stack") mentioned issue.
> 
> I suggest we re-split this series (especially patch 3 and 4), but not
> revive a buggy commit first and then another commit fixing it BTW.
> 

No problem. I remembered this fixing style, and won't make this kind of
mistake again.

Do we need to wait for Mark's further comment?
It looks Mark didn't like non-clustered mount at his first reply, but he
showed another idea for non-clustered mount on the second reply. And I
am sure what's his meaning/attitude for non-clustered mount.

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
