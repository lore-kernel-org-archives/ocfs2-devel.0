Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153C636AED
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Nov 2023 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vGYBAELB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NzNE/jkW"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9IJp8Z031022;
	Thu, 9 Nov 2023 19:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=U3km0I4vRADnLWzRtTopATllm9GiJ8hvbj/1vJdqAk8=;
 b=vGYBAELBGnZgyOsf8v1e2krGAidKWR28kg5RBXHRNFLR0g21k/kauItoZ8Jgn/Sg//7E
 p70Fn2XDKwXXYrBT50oJqSSvbeuVgD/Bl83+fJb6yJ+dcTTLCSQ1iA3N0MiMxSYGvEQA
 ByuN9rfDgNqr2YPTWjxmtYJZqENtp2qylUc/XIByOyf5qovSdCS6wY6btIabC4hiNMqn
 l4U+e21xkjZxvKtvx1Y5iqS6pAzUZy5Xi3ADUj5n56n1UD+H1TIotd4ue8CxfE2D4XMZ
 xPgRdNUGdhr9yGwuWBb/stwt6twgankVjyVRO6yB/fx2fY6eWWy9+gt6DuiZ3gsjmlzf GA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w26vra9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Nov 2023 19:26:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9Is8H4003856;
	Thu, 9 Nov 2023 19:26:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1ywcd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Nov 2023 19:26:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nopry5HxHGsXPVZ3myqU5edsbFGZOjuxRnmIPDo6f3VPbVtSWq9CdT9659pdcdygpzxD0VV/OXoE2wYizf3KoAIBldrk0ZMhUSngBcokNutU4bOLMAR3A+QiVFoKRirvn71+KZLbszXW0LBsCV18XOIBWkmtbLDMjUljZ3xLSDJFPifFlUnj77ZwVcasT204Zs7eOWvqf0Y7pmWiLmvUWP0uHlUm4KtxiRXfQoWJC/Tktnhdotxa9ioL3aTToeSObG08Y1gPanlOZt40ip6PB/6uU49AHwocQqeCKLa7YHTD0Ykzp7j2V8e8pMxcm5LmVbzdkHFwxITY6VRUFIdEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3km0I4vRADnLWzRtTopATllm9GiJ8hvbj/1vJdqAk8=;
 b=GkrEicgNvhhAokvsdQl0NlBzXWbLKCvPM1XVkhP5O3ZD994WurfWhAj083TymYioJIXRi9dFwx7z+6huJXEoHkt6nQM/nvICy7vmHCMkITMsVj8Y9wmsUAB2XjxiPmitx5SrKiHNG4CIwYlh9kn+YJc+99VDL/O62hVeAt9H+7ApCEaN80ZorPlAf+EVccKOiIZTpV3JejtLb547xA3xxbUheR0oAJFleXKjBG6x+1lhmKMw/VcsZz6HEA6nUztS5UEVYZiwISuPckw1h7ypbhQStyQHJni8ovkfTtsPPCZlmJbwD9M7+XzmnvUp/E6+/nR+u71XB2X6f1C0OJo+Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3km0I4vRADnLWzRtTopATllm9GiJ8hvbj/1vJdqAk8=;
 b=NzNE/jkW7AvTeICwiBR1pSHdfv1a6HO/wpQLjOyMUpz6mRz1DZbJ7ogf9lsm4McZjd/PqKsW3syW9xwjas0SAxVrKxiu7ISE6jkOdIzU83+IyS8Nlhk9Mee0WHMtFxqqI3ivK+zuKThW3gVCkS3jawSsh4HNq9sq8ZatQPmdNYM=
Received: from MN2PR10MB4349.namprd10.prod.outlook.com (2603:10b6:208:1d4::9)
 by SJ0PR10MB4686.namprd10.prod.outlook.com (2603:10b6:a03:2d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.30; Thu, 9 Nov
 2023 19:26:17 +0000
Received: from MN2PR10MB4349.namprd10.prod.outlook.com
 ([fe80::51a1:6e96:e4cf:6f0d]) by MN2PR10MB4349.namprd10.prod.outlook.com
 ([fe80::51a1:6e96:e4cf:6f0d%5]) with mapi id 15.20.6954.028; Thu, 9 Nov 2023
 19:26:16 +0000
From: Srivathsa Dara <srivathsa.d.dara@oracle.com>
To: Anthony Iliopoulos <ailiop@suse.com>
CC: "mark@fasheh.com" <mark@fasheh.com>,
        "jlbec@evilplan.org"
	<jlbec@evilplan.org>,
        "joseph.qi@linux.alibaba.com"
	<joseph.qi@linux.alibaba.com>,
        Rajesh Sivaramasubramaniom
	<rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
        Gautham
 Ananthakrishna <gautham.ananthakrishna@oracle.com>
Subject: RE: [PATCH] ocfs2: call ocfs2_abort when journal abort
Thread-Topic: [PATCH] ocfs2: call ocfs2_abort when journal abort
Thread-Index: AQHaCyjVirm9V9gc6EO2rgLGIm51GrBkjDGAgA3hOjA=
Date: Thu, 9 Nov 2023 19:26:16 +0000
Message-ID: 
 <MN2PR10MB43491806209E4381F0359573A0AFA@MN2PR10MB4349.namprd10.prod.outlook.com>
References: <20231030120057.928280-1-srivathsa.d.dara@oracle.com>
 <7ABBFC08-4350-4D6C-B740-80DE590F9476@suse.com>
In-Reply-To: <7ABBFC08-4350-4D6C-B740-80DE590F9476@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR10MB4349:EE_|SJ0PR10MB4686:EE_
x-ms-office365-filtering-correlation-id: d3b5d8fa-9b98-4a45-457e-08dbe159be61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 XXd522byLAToNGhZi1o9O0W+hufDfbxEfH404+5F5bpCY3vvmwCoEb8Glrq13Fzoo2V2L2kQvDlcBRh13RaC6CARJ/wBycYipxoTTHfftCrm/j4XHZLULhPiaHtIyxGd84Uo9NgEzEtK8HJkhTuoDUbBnYFBvXEY8tW4sPXHWj7mzbHF6KGVOqJfjRjwTcRRdrjnnN25UjOuXB+eaACeQgwFlmnxHiexxuPu5yPboN/oRqLulRrwuYP4bjXokEp0Ek0GEZE3ukNvXnxOdnwYDVXejK0JAMfKrncRHVEP7e605sPlPXOpu7ccbpNNROiMhfZoj8n6fzq2aeR/BZ9AVd6ZoVR3OiuJyqi+SRLkzirTCSSwq72mHlTKitWM0n0q/w1mgi5ftvRYALQZnOMGaewNxFFuTg634Zs7C2Qjye+mFWYznP12HuWvj4oc7Ni/RyGNLlA1m+wWa6gGnPchyPEgBzyXj9NGSJXR/tErgl2bB7mYHdw5vDAp8GACeY8lKteYhs9sS5G/x5xt0OYlbNCM1ucLcGFXAZ4UA7HBqqdkIyT844HPd2lkZWN0rASKGNJiSyO+AeB1CCq5Lw7WNSle1hxfmCDpXeo3NWf9xbVMNAsDeyviMDDtBJaJM0Ma
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4349.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(396003)(366004)(376002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(86362001)(6506007)(478600001)(7696005)(53546011)(316002)(26005)(9686003)(107886003)(66476007)(66946007)(71200400001)(41300700001)(8676002)(64756008)(8936002)(52536014)(66556008)(54906003)(4326008)(5660300002)(66446008)(6916009)(33656002)(122000001)(76116006)(38070700009)(83380400001)(38100700002)(2906002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?XQ9giyXSz5HHZJ+6V5h9hvg/SPEEz7VIwYcTlLjzcCohPulxOPjbuzenXUBN?=
 =?us-ascii?Q?0jH1SwRb1pH0BGeOxEeKV88jzhz0kuNhoPW8v/mWckyr3BNerXDRMQ0bwdi+?=
 =?us-ascii?Q?moAwwtgJrH+C4wD245rXLS1gqc19YOAxcVg1iGZx0TjvPWh6JHOuhNzR0mti?=
 =?us-ascii?Q?hHnY784Gz6pgYz+VLh58XUKNL9xQq5GFjCuRpef0f+nHl6rk7pLpjQIJ5GeA?=
 =?us-ascii?Q?yBR5SADE087oMadEaAxypYI8XH2pAIo+6jFzSqCb74vsoIN5Ur10n8Rc7rfR?=
 =?us-ascii?Q?pPz6NnO1eQkDxhGFtzMCVuhAwUCw8/T8/hvqzLzEG4k0yu1s82hWbfJJ5iHE?=
 =?us-ascii?Q?xVmv6LTlge6Oxi+vzXFa3GmNFgfb6aBzzZvq94aF0jBldiIddqZbhB6RWIry?=
 =?us-ascii?Q?bVegkew5ezcyGK6KLco9TP/HxdyK/QenLvuzr6Os6eWW7NJvCSx3kBHpUJzL?=
 =?us-ascii?Q?4IbXYFy89CawBo3+8pqrOguuaZkzuXY+hLjFW8pJHYrEgniSwpTC0WeXt/JL?=
 =?us-ascii?Q?4lkTZMmng06AOJJ87S7uL38bReXiKRa5negA8i8xnunkbnJgGZDzKa83GnDR?=
 =?us-ascii?Q?qOqr0rpipFr+4n+66+7Oee9LQHb4jO6R3NGS+vkrusjNYQzy06eRCFwyjiCb?=
 =?us-ascii?Q?TZgoLLupbdAO7hhM21e7j61vy0g2MKhFTpPN+X/cMDbeicPt3fqNDfSlfFWL?=
 =?us-ascii?Q?ph2XxiMWoEDXT4TUqoP9E5t1ym2w1zFI6rGwsBsOmlSeXZTVBZErwGM4iO6/?=
 =?us-ascii?Q?Lj/qkUvSozCggNXc4VDXTEoZ51ksLIKt6qqypgV6F9DuDfdVgEgS9/sTK3ux?=
 =?us-ascii?Q?LN/qF5M12Gw3tvdLKliyJiWeFeDCayY38q9CMQq2yCujLJAnvbq4KL+hcXV2?=
 =?us-ascii?Q?FIKhLqxro7fdjZf3UOjmtfSYNyg4e1NVTYIoUJ0QVe8YAJRmwk8pjIyrmWO2?=
 =?us-ascii?Q?af3FQExLNWOF7VKRqVDnEq5ZdhUflYs6kXxPeKPgXrh53RbUM+rLADlHnqgF?=
 =?us-ascii?Q?0Wf29ZBzGt1f9fJiYPrgplOHGHl7CsW1haCkBdjInB4nhA2DL1lHkqui8UsE?=
 =?us-ascii?Q?NLnGvLDU2gn5SJ1e0FZcPMx8QzQCt8ftXwWmChsJjrnP0VlEUMKOc2nbTZZF?=
 =?us-ascii?Q?8xSaCyd3JhFQQrk+BK2VtiPgOdG2hcESLhNv12lGmvRvl1M6Tw3pUFaVkT9P?=
 =?us-ascii?Q?mnvyZD/GqIalVQPai9XVx1VZ66q0xJUaxnYl6ksyYBOvvxpJIeBYtDgdevtU?=
 =?us-ascii?Q?qZeiNLbPVIyZ4KHSMBeab50RAjJ+HOpdy7UZpPxD92X1U8jfwCqaptRvRdc3?=
 =?us-ascii?Q?95hvofVygm4XI83tUkheSRjO5Vmc17jwoc5uz/YFKKNDeaIzYOm6/iIpTZBd?=
 =?us-ascii?Q?URrC6HfyGDEzd6GBOeKLg3dQCgb5EPYpizKpo9C9/52KS4wNLbx6nj01ettV?=
 =?us-ascii?Q?Vfm2LgmUYrEGa8QB6/OJ87EcpXmtcF0W4uK9bNJt8+jLLjFAqTtPTU4sx14/?=
 =?us-ascii?Q?8lnnDXRYCONYZ7zIgwRZUX8F8kPehsVLWIdMQR9LT+riE3TK0Vr3zMbC0Z2i?=
 =?us-ascii?Q?+tAEy+7GZs/nCbDQXTIwK4juWbHA+S2dfTDSdZa1l4aVt4R/oy4ND8LfCAlr?=
 =?us-ascii?Q?IA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	J9u5HKr2NBNDWpfQSzc6VivkFkGVa7h3Bc9+QtbBRP2iLntlBx2g9/n6D2yymZJhKAp0GpfqTuKh4MiqGtvUFGboMsr90D0ty5BKUKx5zbQOrvWv6EA/9RweyOZREx3W3taOQ2/cd0SUDc9WhK6VMsv2Bklot4xhHaZ7QHP7Qsz3lOtiAuQuf70likDWycvt7bS59F1+Xy8ydvQ7V/PbYfWnEkhDu1jOuaDZXeoAbfuGxCHo8JHkVcS7XM3I9/dOrqGjJvbUE4GYJgWJvDqDcpcEoc6QXdSY9FJ1/1ZEcepKSXN4GtXqsj1W7AujMnZkjXB9gomDLiU8tMOth9nGcJVAeVmzaAH6ScX5w0cTWPgX8XzC5scmfhszdMJRjtookdt4FB46BuuWpLHnAg9xbL/dPbWQ6w5ZXAucH2lqo7xuH/SpQFPQUefFhQhVUS/BqtHl2M6Ka5ze+fWoyzFxeKvdpFTrbwrSlbLrFgBJXVXL5HKkU08HPS4WP5GA71BsSCj9XaMbXsxImaG8Hc43EwDIVjzlEcT+ByM5KG42G4Ifzvp0Ii1R7BiTcmwJDMDCHd54Mnt4VbUlOhYnL2lsMACZi33AmhkimCJclLcLcXJWKzhwK3ek1TGXjSWCn401MSWeICcMD4HFfWaAFSr4bN7c4TSDWfhSDekcftGNWykeFP9gW/MeZPfftf1klOmA8nPuuMbdfTMLhdCrIamwa5XD8tjC0g0+rL5ClYH+HkBvFteFJh72yd0zQohKAKL1/qtlbKocmVlEu3aZT/PoUwubSEfJ0y4XVOCLx8qldy/miZfPCQsOfVk9eA4YY3oggp4dIPSgtdxR/0R4e8kbBfiSDWVyMkIYL2cqNiVP/dcl9BvZNB304lHoGJqZZaCj1YQa/l7KyxDimW3RZt5JZw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4349.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b5d8fa-9b98-4a45-457e-08dbe159be61
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2023 19:26:16.4876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9+e3wlwl5vzHzxJxOCHCzjpvk7jyHjA6SDHLgkCk0OjmHHu4mvo6XbxuQnjI29NI2VT+/4Hq4+2QOf1REft8NP6NYdNzJ8PFHoDHDKB7VJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_14,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311090140
X-Proofpoint-GUID: URC4T_0u4L7qVkWD5XlDmTuI-aov1rVN
X-Proofpoint-ORIG-GUID: URC4T_0u4L7qVkWD5XlDmTuI-aov1rVN

Hi Anthony,
thanks for the review

-----Original Message-----
From: Anthony Iliopoulos <ailiop@suse.com>=20
Sent: Wednesday, November 1, 2023 4:53 AM
To: Srivathsa Dara <srivathsa.d.dara@oracle.com>
Cc: mark@fasheh.com; jlbec@evilplan.org; joseph.qi@linux.alibaba.com;=20
Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>;=20
Junxiao Bi <junxiao.bi@oracle.com>; ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: call ocfs2_abort when journal abort

On Mon, Oct 30, 2023 at 12:00:57PM +0000, Srivathsa Dara wrote:
> From: Ryan Ding <ryan.ding@oracle.com>
>=20
>=20
> journal can not recover from abort state, so we should take following=20
> action to prevent file system from corruption:

Could you elaborate on how corruption can occur when the filesystem is
in this particular state? How could this be reproduced?

[Srivathsa]: Corruption can occur due to storage failure

> 1. change to readonly filesystem when local mount. We can not afford=20
>    further write, so change to RO state is reasonable.

This is generally the strategy, but unrelated to the code that this commit=
=20
is touching. The ocfs2_commit_thread() only applies to non-local mounts.

[Srivathsa]: Yes, you are right, this is only for cluster mode. I will remo=
ve=20
all local mount related comments.

> 2. panic when cluster mount. Because we can not release lock resource in
>    this state, other node will hung when it require a lock owned by this
>    node. So panic and remaster is a reasonable choise.

Panicking is never a reasonable choice :-) Why couldn't a remastering be
initiated without going through a reboot instead?

[Srivathsa]: Without reboot, we run into a journal failure, the only option
is to have fs in read-only mode. Could you suggest any other way to make
this node release the locks held by it?

> ocfs2_abort() will do all the above work.
>=20
> Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
> Signed-off-by: Srivathsa Dara <srivathsa.d.dara@oracle.com>
> ---
>  fs/ocfs2/journal.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c index=20
> ce215565d061..6dace475f019 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -14,7 +14,6 @@
>  #include <linux/kthread.h>
>  #include <linux/time.h>
>  #include <linux/random.h>
> -#include <linux/delay.h>
>  #include <linux/writeback.h>
> =20
>  #include <cluster/masklog.h>
> @@ -2326,7 +2325,7 @@ static int __ocfs2_wait_on_mount(struct=20
> ocfs2_super *osb, int quota)
> =20
>  static int ocfs2_commit_thread(void *arg)  {
> -	int status;
> +	int status =3D 0;
>  	struct ocfs2_super *osb =3D arg;
>  	struct ocfs2_journal *journal =3D osb->journal;
> =20
> @@ -2340,21 +2339,25 @@ static int ocfs2_commit_thread(void *arg)
>  		wait_event_interruptible(osb->checkpoint_event,
>  					 atomic_read(&journal->j_num_trans)
>  					 || kthread_should_stop());
> +		if (status < 0) {
> +			/* As we can not terminate by ourself, just enter an
> +			 * empty loop to wait for stop.
> +			 */
> +			continue;
> +		}

the above is unnecessary, given that below will induce panic upon failure.

>  		status =3D ocfs2_commit_cache(osb);
>  		if (status < 0) {
> -			static unsigned long abort_warn_time;
> -
> -			/* Warn about this once per minute */
> -			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
> -				mlog(ML_ERROR, "status =3D %d, journal is "
> -						"already aborted.\n", status);
>  			/*
> -			 * After ocfs2_commit_cache() fails, j_num_trans has a
> -			 * non-zero value.  Sleep here to avoid a busy-wait
> -			 * loop.
> +			 * journal can not recover from abort state, there is
> +			 * no need to keep commit cache. So we should either
> +			 * change to readonly(local mount) or just panic
> +			 * (cluster mount).

commit cache doesn't apply to local mounts.

> +			 * We should also clear j_num_trans to prevent further
> +			 * commit.

that's redundant given that we're about to panic.

>  			 */
> -			msleep_interruptible(1000);
> +			atomic_set(&journal->j_num_trans, 0);

same here.

> +			ocfs2_abort(osb->sb, "Detected aborted journal");

ocfs2_commit_cache returning with an error does not necessarily mean that
the journal has been aborted; jbd2_journal_flush will return an error for o=
ther=20
conditions too, some of which could be recoverable.

Therefore unconditionally aborting here is not necessarily warranted, and
presumably this is why the current code is a retry loop.

[Srivathsa]: Even the journal is not aborted, there is some serious=20
error with the journal, keeping it running at this stage could lead
to corruption.

But even if the journal has been aborted at that point, there's no reason w=
hy
the node cannot self-fence and effectively shutdown the local fs, instead o=
f=20
aborting with a panic.

[Srivathsa]: By self-fence, did you mean system panic/reboot due=20
to heartbeat loss? If so, that can't be guaranteed that it will happen
because the storage failure can be intermittent. Even if that happens,
it will panic or reboot, how effectively it will shutdown the local fs,
considering the journal is failing?

[Srivathsa]: will send a v2 addressing the redundant code.

Regards,
Anthony

Thanks,
Srivathsa
