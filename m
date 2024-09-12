Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA8E13AA5D;
	Thu, 12 Sep 2024 03:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726111926; cv=fail; b=oeZ4GetRa91KwkoxV7wQxMwe7vNCr6ZkJ2pd40WOyiJn+QFOgsuVmiogjaVCzBOXoMHbiKXe95WTLMRMKJeAHkC0AWMe+DvLSQ3hsneCP159SjLoSVmFprB01+w8QWlcM0IcYtwoEzf7ktbhf2NiQUPEYN9LYyeTf2dzVDScntk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726111926; c=relaxed/simple;
	bh=cYeQZ+cP1CjOSQzUNeppOoPt5OkktJsTC7IFCidsKBU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eqdQA6G0uuV6dvghJ1JJcqvK4LAbGjfOuagV14yq9UcDS+zSDHgA2KClobcYkK7XIfnO3b9hOHavn2ztTLvEI7S5M/SIRyB0j4XcmvqbmLgoOR3Ld/oVsi8asutPf2nMpYf5Zs2UdLyq4ydLHdh2U7Av4lqYumqzMUSrG9hYDM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Bul5GQru; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D/fmGf3V; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bul5GQru";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D/fmGf3V"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BMg7YQ008328;
	Thu, 12 Sep 2024 03:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-type
	:content-transfer-encoding:mime-version; s=corp-2023-11-20; bh=c
	YeQZ+cP1CjOSQzUNeppOoPt5OkktJsTC7IFCidsKBU=; b=Bul5GQrupelErbc7n
	PilJ0PMBfAkuY2n6yERtYi/KJpUCJZSttaH5I6rVV/c14utEYjnVdP9Lg/qa5oFR
	Z4lQlqh6FavqfPFCw+I8SHVFti0wiRXIvkX3qXT5/lxWXUCGwNDcGfKN5EnqiJN2
	BRuqyVAKChQ0b8qaR039+iN1TMCv7MuAfW6IMC6X/Du5ak6A8dEJ0b/5/XclWzMv
	CFzGg7JdKoPc2+6zBEezS+7fdI8/C84g5IEzk49h6dxGncEaVbtN9GCpV9CijYXK
	Q93gQ1dbHgPBi01el5gI+MmH+lBqb1lCA64k18XfelUoFu+0I/raCSs892Hme7ce
	YBBdw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41geq9sjag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 03:31:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48C22dfS033542;
	Thu, 12 Sep 2024 03:31:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9are2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 03:31:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rqNXfJv10QI6h3ehNbzCZb7UqEf2IIqvlAX2dtSk+pCW9E6KxVmv2AumLVZFJ7dCCjVzKEv1rzb087yqPorBBCohjqwboMFtEUFPs+tI6LotVEWupp2LhyZc46gtD2c2O8mn867IsiMMIORr6bKQxkSowVDLaUUVs1J9b4T0YG7YO1poAWS7LN/RjBtrRNrEnicVDktXpnQ47uCq7tE+zSLsxK+mbLQO/6PXjxxXBWcG32nqOPAWoVmu5bLXjqxmn795firHK2nUA8+Z0qvOxscV9Vek+1wxw6koY0ZpeFZCUFRaShldWFf6/LUbWZ3i3jmIikiyR3SVljMS0XHExA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYeQZ+cP1CjOSQzUNeppOoPt5OkktJsTC7IFCidsKBU=;
 b=wPk4kODam1JMVKszwaA70JXqjodTxbCHe4uYvviQfIsdni0n/sT1lJTR0LGzI1jgEud3yYa++ZYzjS82TTcJEUv0QVlgY6lMLZWsJQ+SFRG+gVsOVpWm/2rGyFqz80v2p5hzGMuGEpDpms3JRCMLI10LNAe6GpcdH9LcOKpH7/E9PGcTwNdVkvKKhhGGsuhCxfa8yOk7TyRLcPfQgAEalkEZpq6PLuCuj3FCUup8hvIE0lE+4OB+4uRkri7cOGhq5KP92qWOk1ii9eKaeOsZwUYcJGD3euH1+p4zZIaqQjQr/LgN3ntYXAxEYRrz78bf3IfYLotBpQCncTrAEmuNYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYeQZ+cP1CjOSQzUNeppOoPt5OkktJsTC7IFCidsKBU=;
 b=D/fmGf3VbuDmkj9175hWa+vwQufdpfHLXaYz1fvj9+Gm8MCi7IUfbgoq3d430IfjEZIgFMnAZjVRD4smdWxHXc02clLNdl7/RN3DyMxhINQ/soOgt9RwEP/ZAMIL1LhwgJTxxvLWMWdEGBHpsl//kNN2HGz8IpQHpQdFsciCumU=
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
 LV3PR10MB8106.namprd10.prod.outlook.com (2603:10b6:408:27f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.7; Thu, 12 Sep
 2024 03:31:55 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0]) by DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0%6]) with mapi id 15.20.7962.016; Thu, 12 Sep 2024
 03:31:55 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: Junxiao Bi <junxiao.bi@oracle.com>,
        Rajesh Sivaramasubramaniom
	<rajesh.sivaramasubramaniom@oracle.com>,
        "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Recall: [PATCH RFC 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Topic: [PATCH RFC 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Index: AQHbBMRQ9riVxvvyKkuwu2TLDBI1tA==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 1
X-FaxNumberOfPages: 0
Date: Thu, 12 Sep 2024 03:31:54 +0000
Message-ID:
 <DS7PR10MB4878BC77D92DAD4A9E35824EF7642@DS7PR10MB4878.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4878:EE_|LV3PR10MB8106:EE_
x-ms-office365-filtering-correlation-id: f6e1687f-ce15-4882-59a7-08dcd2db7315
x-ms-exchange-recallreportgenerated: true
x-ms-exchange-recallreportcfmgenerated: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ZsRkfVxBzKYiUljF23Y/dbhKnbLAlotw1YZPSRaRJ+ZHdNAXI+cCVPp8axvR?=
 =?us-ascii?Q?xEp35rcd2wWmO2KWQg3HtJ2TfcgfaXEQ/ZutKWcRLm9ms0CcAiUZUAKOpUK4?=
 =?us-ascii?Q?dnaoSVnQhJfiTo5/+is210o8jX7x/uqTofcm2BYZc8Jk0xrfBFlZJs+CGbnD?=
 =?us-ascii?Q?bovYm6Dhl+ENktzY8jgwlBsKWQnrNzNUlg3Ly3H14upEkzPCpC7hNh3tJHfV?=
 =?us-ascii?Q?DBqmG/HazQ3H7cKsznrFuRdiS5w2WBfM1H/gaF34WFzKBEZhQyEfzxljiMwc?=
 =?us-ascii?Q?9IDBI3HHZt3b1Fx2M8t81TkvIiQ9FFuDAPciE8fZcXo5BVnE4LYnLKavUe5G?=
 =?us-ascii?Q?pqw2grKUxcOFnaHZeL2vvuCK4jZXxXVdXnZW/FDOfJAsF8PBsf45CJeBU4uI?=
 =?us-ascii?Q?CFwWBQSkAepAkM5pk/WnxiZEI8HMTOi47G9Zv2+3HO7GvlHGssLkcoGi/pHn?=
 =?us-ascii?Q?2ufA7e1CQAExJtjq2uXDSSLYrF30lYUBiBRoGTsmzeN17KSViItdXzRyw9Pm?=
 =?us-ascii?Q?fIMlRSBP5wx6/Nxp2VQjtT60BfNcU2BfZYLKSkLD8nqljJK3rPD1deTsHB4K?=
 =?us-ascii?Q?gjLt8AEUPh3BmBfGHO6+SEpbpCf7vhlMZPfqLMF7g0xlamLZ19R3pvj3pKzy?=
 =?us-ascii?Q?HkUSf8lZS5xm5x1GruEOG4MiXirqowoP+yIUenOXsCe5zZon7+NUUQqRO7NA?=
 =?us-ascii?Q?v40avwR4H+9vsmJZXcDTiKNmEm67vQjP2ceyW7KZS73lQ/vPB9qMYukd/y0V?=
 =?us-ascii?Q?cvtaogb6kzkN5WoWVsJ+Ax95EW41kmrUIX549VETDMGwZhCSiTqBSQpb3016?=
 =?us-ascii?Q?qh2kmYaFZnPK61GVvbrZUFk7Y22jvC38eF3dPi82VzIeN2aGv3hvtVwHeG7t?=
 =?us-ascii?Q?hZmKE9dwpvxhDyv1d/oQOOi8l7+uz6OTJ/eAvP4cNI6+PMmfA5k+9pZcIFQT?=
 =?us-ascii?Q?P+puxsi4lLU3Hix53cRP1cV2KmyKI3GehlmGeLGiPr4xbRKfFRsKUEveRKr4?=
 =?us-ascii?Q?V4ZboTr2fEax+oLoOhl4ROjWr0ZYbFv51R0BtPJqA6SYO2WDF7p3MVkUs0Pu?=
 =?us-ascii?Q?fiWspNIUrHQRtLE665UhQwfWmZsJVmN1LoSv/s12RD2NXNZ8x/0uA/nhKCWH?=
 =?us-ascii?Q?tdF+dWBm61d68BYKsp5NWLxMHXo63OLmqaBU/es4xoF0TSXDfin46n2acrim?=
 =?us-ascii?Q?CgOo13S7VQgXUFCiymEV6SlsqpmOms7VAEajKufuLoVbALX0icfxwPHPPUFC?=
 =?us-ascii?Q?TTVtt44MJJpJsQsP+Ij7V5f94i7PDEHiSeyv2l1XoaTvncGrWmvZK7bRMlJJ?=
 =?us-ascii?Q?QEhsrbcCe/bpE6bkdWSxINC14FDUWWpNSFhedt81hZcabx8bhRedrp+mbdag?=
 =?us-ascii?Q?ZexG9a4/jOpPaGM1RdTaz2AWTu0PvABL/GeNfE1BCinyXopYog=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4878.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?e/5Fy5u71SNDGNs73z4uxtULlvZmsz0T4mV2MOJGLjyKBbz3yuJ+al55btuh?=
 =?us-ascii?Q?l1d2tDEcA4RpiGzv0CdtpKyJmoyYfJ+mg0GhBEj0imCx3CCaLpRN3xxFzvMU?=
 =?us-ascii?Q?LDwCuBB9STBJJMvHVuuMZ6EdLHPSCWloPx57H6PzSbGdWgDjsW1UOzUOqGOm?=
 =?us-ascii?Q?k4cR8uL2ow8MwpoOHICmDzSy+MuFECm8/zvnrRY0R4I9kQo/FOqXn/iVyXf9?=
 =?us-ascii?Q?9gY40UtgHC6W4+gb79TEg3+o6PIGuTtjnFmgiX9TmxYJpkiIAQkfQ/6MpHUd?=
 =?us-ascii?Q?yPX9aw1lMVleEyoqY2LEoxpvA5tiF8LSEVNEnQKG0eXCF7kcGvsyXVqguNPK?=
 =?us-ascii?Q?T15LKYfyly5QYKWyxRuJUByHSGzoS1Dcff43AvxwdmEGJKPuDlvZtDQud5qr?=
 =?us-ascii?Q?rG14L/vt1nk9EWR7pqciClFIQpC0t6fD0DTK6svtpsXmv7LrLnLqOMTOBRy8?=
 =?us-ascii?Q?lBJpdj5IaYvvDei0XEk3of6Xt+z15CXvrBPX/mEXdtpnPKBnIC40Dm1Re/WE?=
 =?us-ascii?Q?s7F/jlaILxkeIy9+wtvoy4pXRGFHRyeyKoqZXcd9yPOEcmsiSbqIGI3iJygA?=
 =?us-ascii?Q?w3hMLNlceXtlH1RgHKhzW75+8jTYsUM4ljAnG1HrTDwQF07RieMBsnb1bZkT?=
 =?us-ascii?Q?XaWbKp1MsB6jefJMa6Q7/Yq6I8t/0XY/a12SWqEYCeeZNy0rtHkmh+OtERus?=
 =?us-ascii?Q?f9qt8YYuBrTcOZkMz45xH2tWqPf35Uim+e+l5hF+/J42hRTcEdS6ckDSKv9q?=
 =?us-ascii?Q?PVQsvQh6Sw7daWp1d4jqdtQ1GO5xxkCchAuA73hBuL0FvmYcuoB1omv+wnit?=
 =?us-ascii?Q?1m0POwhhyXVOA71vZv6Z9bLBja3Wt74Op7cp5OqBgb8Damrixwss08nmUFFY?=
 =?us-ascii?Q?N6sjXMpZZW4Y67u8ihujahqCdU+5Pm6eucLCbG+6l2Wyvq8E7ILmUgLxaTuM?=
 =?us-ascii?Q?CY6+zg9tJgQuFJ5gNZJtcCwTfXb62CJgT1isiBV32eMOZBuRknDqIJf9ef0B?=
 =?us-ascii?Q?/cn7Gs+RszFBbn0BJEocAjev4w1YJVn3KHbGzOQ7yxS7z2CQIv+cCpcWenNb?=
 =?us-ascii?Q?auAmWU9N4e89EOgtRH7INv4HoLXbKeNyHhWCuEbVDACzqtbTQAK2CYKbZ9h5?=
 =?us-ascii?Q?Rt78SwJDXkl7IVeEzl8n89HhYjtym9a8TMr8xLhn+21XR6heV8CGw0v6eqfK?=
 =?us-ascii?Q?rqNh6iURxeA5F995K8OQPoOPB6DkE6wn6alKXeuWNic3O/A24dre2d8LG2U6?=
 =?us-ascii?Q?hxg1KAXvt9rcKk/udLrRjJjGXp1Z/Q5dBcl7S2fpf1CuEnQUPzT7huQpItbl?=
 =?us-ascii?Q?4pKHinOcXhZf6NfdzdSHZ7ZA93wQszmiHsvcJ997FR1kFqreMUKPSxFHs8Fy?=
 =?us-ascii?Q?4+/U156nO7lrC9uDPGv3eG9idNO13Jzm39EyuqXOFOo2sv9CEUzA+qhQKCVc?=
 =?us-ascii?Q?jB6MXD+x+HGNEHlw3FYcc7nRc8CsEyCX8fP3D4tTD/phhLE4a4CqE+HoaJqo?=
 =?us-ascii?Q?xvgxGb0GhsblJazSA7ibROQJcPUkxTQRCr8gR7jBzxlBiBzdid0UDc4fwm6z?=
 =?us-ascii?Q?7fgm8MVmoVeMwB40jMorxQhLn5eS4/Ap9uqqB7wf0KqOI8tYdI0QrkE6nQgF?=
 =?us-ascii?Q?3Q=3D=3D?=
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
	/dvcsaVe6qhYCkNROVa6YNOy67YSXxk6oCwrZqnw25eT1V/ZUbzOaK97pllwXjZjcRsUGD7vn7ertvT4t8w6FYEdn5wVytO//NnuwbvpSKh0/Ru5du0NQsELkiECnP/iPKzmb5jfbD8/2jnKaNEXkun+5YSJGaZxHuQzTTLMsN8yqD71qlPSyy+G9jclYlbseUx8GWS+3YECZCTf2RV9/4Od2XXrPgNEkS6gWN5Riu1tbGDRjZsfLiDGA6WR712FEyuQO7uUbOGq1+NLL7UulkAVT0FN2kmsO+4zxC0c1nGv94CESh+BcS7ko87v+dgshOrdhAkxEc8/+eDJNUkoR8UifirpAiAstunbs2l5WwONBfPkjzfn0po1B04KOGyx/MsfXNPo3y62nVcLrGp15vPuLaXZCzUdxiyQ6VKyu9giyOi6W2TcJmK5S+ZtWwNQfgALpgH3ZB3QGpEDDg3ZoGa05LYBoYa1FJEEml1lT1giig5pRkmsHFRbPAmx1BdpV/rq+NPNhZ6ejEx1FBStwNqFf+Bh7iAEPCY3Nr2ASDRd8zoMOA3o2IFEwqAR5HwjCK/+2xCAO/Dd0fAWjyg/d1T998i9vltUA4AfBzevwto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e1687f-ce15-4882-59a7-08dcd2db7315
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 03:31:55.0008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ftJIMwihyVE2sRptK3nP8nB4vYOmAOI92XpJ+MCbDeNQbhKkZA3G/OhPch3kkK6hgZQJbHECMb0+ubRAaPnoWFWxHjU/Y2bGQ6Xoh68tQfWQLJzhgxuCAKTZyJf+A2C5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=747
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409120023
X-Proofpoint-ORIG-GUID: tAObnU_STcz2Dp1oBx0D5VIW5PbcgwcZ
X-Proofpoint-GUID: tAObnU_STcz2Dp1oBx0D5VIW5PbcgwcZ

Gautham Ananthakrishna would like to recall the message, "[PATCH RFC 1/1] o=
cfs2: reserve space for inline xattr before attaching reflink tree".=
