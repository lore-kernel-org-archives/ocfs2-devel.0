Return-Path: <SRS0=eIKw=IB=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFC6C433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 08:45:31 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F32964EE1
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 08:45:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F32964EE1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1238id4d022354;
	Wed, 3 Mar 2021 08:45:29 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 3726v781uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Mar 2021 08:45:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1238j3Be143847;
	Wed, 3 Mar 2021 08:45:28 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37000y52qw-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 03 Mar 2021 08:45:28 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lHN8J-0003Ym-GO; Wed, 03 Mar 2021 00:45:27 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@fujitsu.com>) id 1lHN8G-0003YN-RK
	for ocfs2-devel@oss.oracle.com; Wed, 03 Mar 2021 00:45:24 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1238iaGo053439
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 08:45:24 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 36yyut5hbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 08:45:24 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1238hb0u038507
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 08:45:23 GMT
Received: from esa18.fujitsucc.c3s2.iphmx.com (esa18.fujitsucc.c3s2.iphmx.com
	[216.71.158.38]) by userp2030.oracle.com with ESMTP id 36yc4jf9b0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 08:45:23 +0000
IronPort-SDR: 44OMffNQnyXP1gR8MhMwnRWqHWJ2zDeL02PVmTya0xCGBy1ilm1Z1Qld9s6Vf9ExPQjV91/l05
	RQcoFENYI48UKAE0ui6i9hVDnmuZ9TfKNeHGdjG1CwnxVYhh/tD2tMzV4TzE1YNWIGMVdUaQWj
	OzI8UtA9Jol85U7wxT+H1EAKKhqfS41neI4q1e0oLngZ5xK5XY5S5EVSFzF314qU5GdlehY/Iy
	JFqBfE79EgW/P8/qt5Hgyi5aRqhUxdtbZVEtuhckgibvRRk0zh2qd7MbY5SxtdKohpKKtFg6VX
	fGo=
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="27498756"
X-IronPort-AV: E=Sophos;i="5.81,219,1610377200"; d="scan'208";a="27498756"
Received: from mail-os2jpn01lp2059.outbound.protection.outlook.com (HELO
	JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.59])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 17:45:16 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=RrD17N0fCoFw1DiKd41pb6c3BBNf3+/2zvYRD84lFhK76NGUo2Airfbb3CbH4XY3q2WAdF84lceXhuXpTHXPOqRXfS3ggbEtEISj58wejHJgH/OkpKDrnsKQ+HosXnLXn4ODkediaCbmpQc8AyFRjdzYa7L4Y2wTp5HqcFBE+p4cM8joyLIyRMPUEAr/4Jv1Z0i/gRgS/eWZhl+SvpqqBtIAoQQq8I8zb1weIqfT8vmkU8DXyZO9u/Nv2Q6fYY2JaS/Dd2HrBl/ZN/HxR178Qr44qtU4X/VEi+RM73pdXXkgDf4uR7PeAfiKNTtgCv9SspQZOrvMVWmpDLEj7Wd+jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=52k4wHevKWKquqJiQ+jcLO4k8mciicv+dMAw1ZUM0xw=;
	b=BObBbCUBAhuyGchZ5Igm3XcSE7czWleu76jGwhi+Oxf81GEApxWpJoRZMBqO37tcJ9sFvxHgKcWgAyOJXhKTEQXnqkrI9c/Qq8Lj5y3hX1Z7j3uO5znf3GqOUsoAqvTSMiv3T0CEdS2BOu2fzoMDSq4chj3LiZ+armKPbvAGr7UWkWPT4iHEPWbfa+qIemJRXJxZNeN0QkRl3ptBnFKAf16CmKuI5Se0is4wFuWZvMSh4lTYOIUuHiP9CSLttMExAeE0Q81HlIJ5ufoWd/mXY7rc3FsMDILuNPsOqRFHLVNNmCCSRwM2t0W4INW0WqHZ5FIlQ1f/IgCocYWcH6D8Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=fujitsu.com;
	dmarc=pass action=none header.from=fujitsu.com; 
	dkim=pass header.d=fujitsu.com; arc=none
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OS0PR01MB5794.jpnprd01.prod.outlook.com (2603:1096:604:b3::5) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19;
	Wed, 3 Mar 2021 08:45:14 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::7de7:2ce8:ffc0:d098%7]) with mapi id 15.20.3890.028;
	Wed, 3 Mar 2021 08:45:14 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Joe Perches <joe@perches.com>
Thread-Topic: [PATCH v2 08/10] fsdax: Dedup file range to use a compare
	function
Thread-Index: AQHXC9ViwxeQhGIw4Eetxx4lR6H52qpx9GcAgAAD9Rk=
Date: Wed, 3 Mar 2021 08:45:14 +0000
Message-ID: <OSBPR01MB2920D986D605EE229E091601F4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<20210226002030.653855-9-ruansy.fnst@fujitsu.com>,
	<aed5d2b78c4ac121ca0cf46107334673a3c9a586.camel@perches.com>
In-Reply-To: <aed5d2b78c4ac121ca0cf46107334673a3c9a586.camel@perches.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: perches.com; dkim=none (message not signed)
	header.d=none; perches.com;
	dmarc=none action=none header.from=fujitsu.com; 
x-originating-ip: [49.74.161.241]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12705e02-5bca-4ea4-04b4-08d8de20a9c3
x-ms-traffictypediagnostic: OS0PR01MB5794:
x-microsoft-antispam-prvs: <OS0PR01MB5794565BD85DE951DB21B55FF4989@OS0PR01MB5794.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N76uqLBuJ3NmA+j6Xu1frkrJGN2Dz+xnLu2uIMbJ+u1F65oFqVPvhCzpbRPZrXMNKTdSKTkZ2MAm88WmBLYa2IuQjt8DNCjJvXVoDedKpGlzczb0Gg45zzqYBIsdfMvEBjR744R8FAw4JcInKEwxSr3/XvpWonli2pDbZMkIFR5Z9i1lUuLaLtzXbK+z+y3lF6oucNCnHq/XjHDkgJhj3trYNwq6QYJkcye07gZgK/3RCDB8lUKEnHtkUg8OGVdF8Li5t2ZCG40KpIcS7NOPA2xLhOBtQfJOCydW3zpKuJHD2ervaAYbDleKWny4TnmyVUY6sEqipmKKHGLE1ngPLq8ElVQpxGVstYdY7hENITm44+ixX8MMts8e8lF433mQcAEZGeRQ22K0o+ydV1E49Oa9ZL32Jq+VPfTX8GUk3NnN+17uDBxXTK93/EP6KTy0G84Sgi/1dCIskB26+D8v+261cfcxUXAJdRZ/KLjalJGJcmdXvMQeWsaUsAwHfcpaPrIEkZ2x60nFdOzp1+0Dvg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:OSBPR01MB2920.jpnprd01.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(91956017)(8936002)(33656002)(5660300002)(7696005)(4326008)(66446008)(6506007)(2906002)(66476007)(7416002)(86362001)(316002)(66946007)(26005)(64756008)(66556008)(85182001)(6916009)(71200400001)(186003)(8676002)(55016002)(9686003)(76116006)(52536014)(478600001)(83380400001)(54906003);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: mmhvT39BFeUQDVpU6mILhhhXw1LWcv9ho73ewGuiEkQgX3gWkyiHDpp4Qz78QSSU/a2LMxnhNTqQQmbW63Zn2jMuEPrCZ2nEspY2FcmD5pt5t7wA32SaiB1iw57y3iNL9jjShEBMBn29/CJ5W/7Zgk68Q2rUR5wt2SLKvCeTwAgj4j3+vYdLjKCOMfxV3BpXcw9Mca9iI/zi7DeJS1xVkr1YssXvTJ7dX02Mv/6jQvvqPLlczFJFVht1gYKWGAFNy0LosOwWXhO3f4k3kVaMKHAB6T+606Y2UOAVrcuZe6IFXhTyHyeCnIOW9+S6m4XQpxd7zr2Mx0AiTU+Q8+wJbSP/cmBxpwGBDstW1xvDH90rkETcbXR21K1c8RbvWldXrIPvwBvXT/5eH3GnOyDWVjhG2UCbJARfM4sdeR8UcfeDTvH5Ge9k5Why3N8/WgVpgXmTVkWehWjn0eYed2b7muW3HAOMZfPgMZdqrt7GHM5CXMP8hNV94WYktqY2MEuzLXcSfSUGsDEvhgZ0EK5nYHrD2mn5zIVMr0dDkEiZRLVuxUZhYInFpZLdgqpZPpNkhKktOjABp0lZ8VxzBaWm4WUICQAXIMyYvJS+y4XDfbZkusz4XlVawhertQ62XZlmj9BMHEo3ssPHIM7us/6alTaAqBQ5sdJTtAtECD0a3RhLDXHPWQB2DCW27OMPpyA9kv0JAHTAZrP3bNPV/E+qOg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12705e02-5bca-4ea4-04b4-08d8de20a9c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 08:45:14.0525 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mFoMG4+bfpop5yVorYb75Pot2jRZezK526qxRVzgBms9/B8AMqSRnxyg60H6sVrGu9glLQg74QDGEjMAybTSWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5794
X-PDR: PASS
X-Source-IP: 216.71.158.38
X-ServerName: esa18.fujitsucc.c3s2.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:211.128.242.0/26 ip4:202.219.69.128/26
	ip4:207.54.90.47
	ip4:207.54.90.48 ip4:207.54.90.49 ip4:68.232.139.117 ip4:68.232.139.130
	ip4:68.232.139.139 include:spf.protection.outlook.com
	include:mktomail.com
	mx:fujitsu.com include:spf.messagelabs.com ?all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	adultscore=0
	mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0
	lowpriorityscore=0 clxscore=157 spamscore=0 mlxscore=0 phishscore=0
	priorityscore=78 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103030066
X-Spam: Clean
Cc: "jack@suse.cz" <jack@suse.cz>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2 08/10] fsdax: Dedup file range to use a
 compare function
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030067
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030067

> 
> This code looks needlessly complex.
> 
> len is never decremented inside the while loop so the while loop
> itself looks unnecessary.  Is there some missing decrement of len
> or some other reason to use a while loop?
> 
> Is dax_iomap_direct_access some ugly macro that modifies a hidden len?
> 
> Why not remove the while loop and use straightforward code without
> unnecessary indentatation?
> 
> {
>         void *saddr;
>         void *daddr;
>         bool *same = data;
>         int ret;
> 
>         if (!len ||
>             (smap->type == IOMAP_HOLE && dmap->type == IOMAP_HOLE))
>                 return 0;
> 
>         if (smap->type == IOMAP_HOLE || dmap->type == IOMAP_HOLE) {
>                 *same = false;
>                 return 0;
>         }
> 
>         ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
>                                       &saddr, NULL);
>         if (ret < 0)
>                 return -EIO;
> 
>         ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
>                                       &daddr, NULL);
>         if (ret < 0)
>                 return -EIO;
> 
>         *same = !memcmp(saddr, daddr, len);
> 
>         return 0;
> }
> 
> I didn't look at the rest.
> 

Sorry for making you confused. This is because I misunderstood how I should
use iomap_apply2(). I have re-sent two new patches to fix this(PATCH 08/10)
and the previous(PATCH 07/10) which are in-reply-to these two patch, please
take a look on those two.  Maybe I should resend all of the patchset as a
new one...


--
Thanks,
Ruan Shiyang.
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
