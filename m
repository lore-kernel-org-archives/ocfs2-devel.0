Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F47C126C06;
	Thu, 12 Sep 2024 03:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726110075; cv=fail; b=OkBnkf2pE8MH93D+ihjwmRIhZIwSJZRHBNJVk/anQ4voMZmDyk0M/7eaOT2fJs9eVdbb+0lIyrPOXQw5BVVChgo+5YBHwA1W8TnVnZLHI/sm4upjNgJ+6mFVyH+ZaeSlexZs8Ed/poWmcfYAlGrN/i1POKj0GsTgvnj/BgLUTZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726110075; c=relaxed/simple;
	bh=c2PvCNNX225W1gT0ykTs5M4q7yIx8bDH/PDFMtN8Vyo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W5ZoCqUeZMm82YfcUW8LT2ZqIa25YAd4TJZ4x0cBeWi2AN5mPVKGdDF0i5TD0Mte1HD68VxDIzwuBV82W16pTvpW/Zrf8NKTzaflrZcOkRCpOCmJ+bDQbNoXX0Jt6/JF6KFXkStzXIY+92KXPSdArPY8w57IyNooGk38AOf5QIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M3STZAVS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zOMA4+Q/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M3STZAVS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zOMA4+Q/"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BMfYON016816;
	Thu, 12 Sep 2024 03:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=c2PvCNNX225W1gT0ykTs5M4q7yIx8bDH/PDFMtN8Vyo=; b=
	M3STZAVS2VC4hW19RI7VUSaR83NsX5qVW6UDe2myWXLWO3G4TA1W1FHVHxzOPHCX
	KVNfCdXQVh4zGGmzzKzcmy5GC+dRGb4+TlgyMEp0GBxk+GbEFmYY3BNhbuHCYLFD
	mNIdjlCG8deLKkKJJQRX7pKDWX6jydhyB2G+GcR6aIc9ZWMISxrWWYhzHq/WjsQp
	QNXQVBuS7LvEmn1TvLNkQuYA8COQtWFRtaBcRrxk/u0tr1jK44B1DZO3YrlqAYaS
	O7fiVd0p5BGH0+cPJrWGJ4Hq6BpgwSTk1mWA6Eq4vxhen+VwuyBMQT4tNjlCSnS3
	VsUJ2UlDmnMduXe20eVE4g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gfcthkkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 03:01:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48C2UDsU004186;
	Thu, 12 Sep 2024 03:01:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9arjmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 03:01:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c9SkLveDGalBVb6WeVbpvu76AYt52/fmns2Q4/GDjw8GrLmMuekvhjlK3fn6UzSW0X1SaqC+ivbpMBGgNT3gZtxQLK1TIdkZZZgBEMt71LC+OArY8VPOHJHB784sUrC2U+XkZ6Blhcv35iUHxRGjspD4ktphn/EbLkTGL0+v3Jfw11kPhwhQdCLntALKbct5LEbY4/5x0nq5qrFGYu0u6JViAG34KkpyH6Z4M5lu84AVqV+BDNxuB/h591bpDQ9HbR/dimNKHOg8lvdy9QciHnAS5p5lEd6MX69/lrmrHrR5V2cGIwZCyHSpLbMdmMWL9MQHgkXvcPRslD/Ahwrmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2PvCNNX225W1gT0ykTs5M4q7yIx8bDH/PDFMtN8Vyo=;
 b=bQuEqIOAkzoU5bBaDzf/Y7F/QQEcd8io8DP7ikfl/eADPPw5C9+y7L8zvkA0PhTiZqUHeU9QavLEeaZz8KEQxu60x4d/uWRqixNURNsoBClBXTGOwTnyIg0jvqdItOGWuiKg0FqmvapxZHWVvW/2fTU8vRf8kTYy/OrHPSum1fyk08Tekhg0UOZIYNLGk9R0srHUjoAPYe2SBCcoVUPCuXVap2M1ADgpp7KLvZxU0t6/Zym7Ob1asv0Vs+ojLy3FvRiu+3srIHA1KMMtteyq1VcU251xY0GJxEEdXTNaRrR822Ye9D2Ff+I/TYXaaCJEm5m9PdpTmcOa9tWDoTwoyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2PvCNNX225W1gT0ykTs5M4q7yIx8bDH/PDFMtN8Vyo=;
 b=zOMA4+Q/LJcbevUu7xjGZyzBia/mwNywHbnJ+mMLv7LYmLYUlQnpPebYriiCQ+Mw3yN7IubHWjzWTmz7GZXxmbDx/+sobtpYk2kyypsDHYXkMbXQ/yDMQ6s7XQBCbPKIHnm3D6xyqtV+TSZ0xN41W9lwQ5XfHXmVJQRlabuAl74=
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
 CH4PR10MB8027.namprd10.prod.outlook.com (2603:10b6:610:239::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 03:01:04 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0]) by DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0%6]) with mapi id 15.20.7962.016; Thu, 12 Sep 2024
 03:01:03 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: Junxiao Bi <junxiao.bi@oracle.com>,
        Rajesh Sivaramasubramaniom
	<rajesh.sivaramasubramaniom@oracle.com>,
        "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Topic: [PATCH RFC 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Index: AQHbAzuchhJs3uz9/0eQNZPcDSyJHLJSMd2AgAFHZYA=
Date: Thu, 12 Sep 2024 03:01:03 +0000
Message-ID:
 <DS7PR10MB4878186AA17BCE6DD545943DF7642@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <20240910044045.257958-1-gautham.ananthakrishna@oracle.com>
 <6b8f2dee-12a7-4a8d-a67f-e4c67277d230@linux.alibaba.com>
In-Reply-To: <6b8f2dee-12a7-4a8d-a67f-e4c67277d230@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4878:EE_|CH4PR10MB8027:EE_
x-ms-office365-filtering-correlation-id: a315a077-9998-4bb4-a047-08dcd2d72389
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cEI4aUQwWFFQODZsTm5wa1V1ZU4wVlZ2YVFCSENpR1E2Mkp0cVJieEN5ZGFF?=
 =?utf-8?B?SlNWd0xXaGVWcEJ5L2Z1aUcxM3ZGUGVzSUdNdW1USDhKVFQyc1RsL1ZrSGt1?=
 =?utf-8?B?c0RRc29MeWNUOUs1bjQvSmx3cmNZdUszd3RyNWFqMzJKbDVSQzdCY1VtWmNI?=
 =?utf-8?B?Vm01OFA2ZmQ1eUVubVVBRDVGcGZsMmsvU2tOLzVuK2FJbTFrTVpNMkVFbGJi?=
 =?utf-8?B?SzJLRGhkMi90aDZyaXJqeUkwK1h2MytFMGpiT1k3czBVUTdaWktZSG9MRFpz?=
 =?utf-8?B?MVRjUEJlbmhvc0hScnlWb3BnVGYwSkJMdVUwaVRZbE5yczAxNXFQc0VuUlAx?=
 =?utf-8?B?S3Y2UmhEUmdtSlRORVYzemhreGNOcHNMYWd6SjhXYXdVUVl0eWl3bzZzWllH?=
 =?utf-8?B?enRjcDI4SXBrek51Um43QTl3aTY2T0IyUjNBVFZIVUdSUGhOR1ExUjVtZTZv?=
 =?utf-8?B?aTdONldlK3NHU1psaEFYd2o2Z1dPcXZRR1hYaXJCWTNQOVI4OFJIaUgyRE1v?=
 =?utf-8?B?Nm5pMjd1UUlMY2RYeElNd0tyaVFrZExwdjgxMGNKRDR2bFZDbVd4V2dOTkJK?=
 =?utf-8?B?MGhqTDFRMUFTbXh0MTFYSFR3VHA3UllKQ3AvNXd2ZnlONFJBU3R0VzBBVEVD?=
 =?utf-8?B?a20yZ0k4NUxVRDhVd0tPZnpmOWw3bHhJeHd2Ry9Wd01nNzlSZHQrR2crQk12?=
 =?utf-8?B?S2JEd2IvOC9ncHk3dVNMOGZ4MW4rZmtFSUdkRmRIMmtsdGtYZ0VmbU9qSWdV?=
 =?utf-8?B?R0pQSUpsM2dVK0ovQVgxRnZiQ1A4NXlYUkNGSm41djVrUlZOZlV6YjQyY3Z0?=
 =?utf-8?B?VFdlbU1RdjdUSDl2TjJiU2FNWWE4VHRST1FtMm5aK2hJTUpyZUJkRHFUZ0l4?=
 =?utf-8?B?bmV0dHh4UkhrMUw3TVRwQVA1NTdKU0txNE9ZVlkvV3ZzbFFQNUxaaE90V09o?=
 =?utf-8?B?TW1LZEZGMVRZT3U4K0YySUxxaWtLUk1aNlNBWTFkMTZHYzgrMU83SWR3aTdy?=
 =?utf-8?B?c2p1NVR5cGJHWFpnWGNwbm1jNWhXUmVpZVFqNzE4WmF3ZFJPUVk3TGhidkxL?=
 =?utf-8?B?em5JWGMzUWJmOWpXdTQvRjZjNjVTbXlEOVlzenFCTUZxc0NPZm1WMDBReTNQ?=
 =?utf-8?B?ZkJPczYrQSs1TWg1TmlWLy9JWWdFTGFqU0FLdEtFRERpdnY4VVY1bDV3cThr?=
 =?utf-8?B?ekJCaThSTCs1SGgyeGp1TnVqUmduVnB2TGtnZllaMjZHZDZaY2VBcjJ4TFlG?=
 =?utf-8?B?QmpnWkxlbUhOMjQ4NlBWYXB2MHRPS0c0aXRmRk5uTmJmZkZvTWgwZENtUDJZ?=
 =?utf-8?B?dzVxV2ZlUFpqMENXV1JaVlhDZ1lDTERVMnNUY1ZaV09xYlpUbzVnYVM5L3ZG?=
 =?utf-8?B?M3pDeDI1RThyNFZFakhXRU1QZUtDM3lSOGsxbHFqNExiKzdtbmtsSGExQjFW?=
 =?utf-8?B?ZzZsdGJvN1B4WFo5MDhqU1ZuQ203L1lMZkE0R3V5ZEhHNXhRNFJoMHY5NFp3?=
 =?utf-8?B?VzVUU0c0eXhoVWVOV09YOFF3azhPbU9UUE1rNElZZytFTk1WYnZXWlkxY2cy?=
 =?utf-8?B?ZjBJbjI2b0tsU1pKNUpsTnljZmY1SjVRbjBxRVc3YmRnV0t2VE0vOCtwb1ho?=
 =?utf-8?B?VnJsWmdIRWhvdU9ISlQyYzkrL2ZZVEZIWmpKbDBNd1RTVENzZzVqVUdjRjkx?=
 =?utf-8?B?WWRKbGt6SFVoRjVxamhFbmMzRkE1NU5URGh3SDNhOXdmZ0pRa0pzR3ZYRWd5?=
 =?utf-8?B?c1NoOWdTamFvNXJNakw1WTdFL1I3bHZQV1FBWUdMaEQzZUtZOFRHd1V3a2Y1?=
 =?utf-8?B?ZkNyUElTUWt4djQwcjU5K1ZVN2NmSFlTMXRIOEYzSU41N0FOSkUwTjBPUU1o?=
 =?utf-8?B?aGNCUlErQTBMRUNYSHNiYUJ1cW9oemlFbEIyVE9icXRNQXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4878.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TUQ4NDVacTI2WUhWYXlwR1hMTFpIQ3ZKVFVaaUFKeTVXcHBvWnVEZS94MlRi?=
 =?utf-8?B?ZURNRENOTjF6ajd6UEhmMjJSa056ZmlyWS9CcEdEUVk3RWVkQXBoeXY1ci9I?=
 =?utf-8?B?b0VMQ2pXTWRYNHdxaytyQ1h1S3hndVMyV2RYOXB3dXY2M0tKcFFCYkk5cWxN?=
 =?utf-8?B?Z3o5T3B1eTZVck84eDgrWjdpRk1MdHhNOTZBQzg2NWVWUjBocmZCMTFRMHZk?=
 =?utf-8?B?bHBuQXZmWlJzQldVSjkyRHdhWXRRMTBTT2dZRC9lOU5xRXd2dkpRU3Zsbjdm?=
 =?utf-8?B?TVVVSjJlRzV1VmxqUlpOZ25jWTdoMWJvaWIzVUVPb0hIRjVKVGpxNGNZbmd4?=
 =?utf-8?B?czRBM2FVeVpobEZ2V3JyZm5Kb3FTRThkVlhVYjg1QURRc3FGNm9KTVlKbGFY?=
 =?utf-8?B?YWtLWHJtdmFIUUVaZW1wYmJDdERwUmdQMk5WT0FLeE5GYzBCQWpYZ0I3d2ht?=
 =?utf-8?B?UnYzN3JYSzdCZkFrclVsQnUrek1SZ0ZKaUVqbkVmd2M5VW1vay8xNjlBVmg1?=
 =?utf-8?B?WWxuZnd2dE5kQXI1M2pHZ3FCTUNVNTB1ZTMrd1htdFlVN0d3VXZkeExhOU5w?=
 =?utf-8?B?UFNCMVBjYlFzVjdhYUVhSXVML00xM3JscDV6UGdiTGRpR1hVV3pBUmUwNlly?=
 =?utf-8?B?bEdmOVR0dmJvM0M1czcxdVphTy9OYy9NSDdCUDM4bGlXaWtza3ppRmRPTlhC?=
 =?utf-8?B?MFhpdmZkekZIMDR6d1NCak42eFJxOFRRTnVmQU1Gcit0S3p3dlowVUVsdXVx?=
 =?utf-8?B?TDZiTCtvKzVmZXdwTXZMN0NBeklWeDhvdDRURklWQmI2SG5PTUtxWG91UExs?=
 =?utf-8?B?U3hqOHR3MUVVbTFoZGUrejZGYlBnWHZmSWE5MmhzSkxCWFBGNjV3MDlidmVP?=
 =?utf-8?B?b2M1Z0htd2JxYWMzbkp4TVRMeXB3NXc2UHFMbS9nME5wMTRKRC9LME1IVENL?=
 =?utf-8?B?OVJKVlBqM1c5cXpVVVpQN1FIbFVzdWY4a1UxNE0vUzJlR1hBQUlGQ2JLYklM?=
 =?utf-8?B?SFhvYm1BeGFMZXhlRHE4MWF1QitWNExIYnFsTDFQdVVTVUdJZy9JVmxLYSt6?=
 =?utf-8?B?eWVyZ0FpNWxCWVpDcTduNUh6VnVSMlVOY3NWVDBHZDEyZjlya1gzbmFORkZi?=
 =?utf-8?B?U0hhOFBDR0xERTZFa25ORjhFTUtDRXBtSWNxc2VSSG9zbWFFemRLMzczRWpl?=
 =?utf-8?B?b0lIRTF5K05rU0dBZTdFamdtRHJZWjhaU08vZ1dwZnNsK29PbVg3aW5MK3Ny?=
 =?utf-8?B?Um04MWpKeVZVOTBTQkkxMUZMOEFFb000SE9ualczSnIxd3B5ZlpFWlRVa1Fs?=
 =?utf-8?B?VFlKYlhwUDlSKzFCZHhBVk1VRXRkcGs1QnBOLzhoN3Rqa201N2lhTlcvdERZ?=
 =?utf-8?B?NEZLaFExSDJQMTdUNFFOb2o3cnRtUEl3Rmc1ZytyZFZEcUVVVlA2TUVacVJX?=
 =?utf-8?B?UWlxZDlTMkdUNm94STNoRStxS1ZQMlBoMDNRTmkzMnEwaHlrVzFsNTRlZFc4?=
 =?utf-8?B?U0xTU3pKWTdWV25uTk1QQ2ZXaE8wUnhPb0UyWUJhbEtNbWFDYXhHMnpHdlpC?=
 =?utf-8?B?MlhMSDcrTlFTQlovaFhzL0p1ajZlbVdiUjNNUFpKbTliRHJrS1lQbTI4dzN2?=
 =?utf-8?B?SzhkQ1NzR2JQUy81K3pOa0dFbmx1eWVuTm9MZ2NHOStrVmZqQ1NKcFY3OWxt?=
 =?utf-8?B?TnVrRGFqREdLcW5vY3VZV1FrVFMwTDZOcnU2T2dlQnliTFBHN1NQdXV6RUhT?=
 =?utf-8?B?TldnNXI2NkpxVHZ4d2dOU05CSy9zNlNVYW5PZ3VWWG1JL2RQWWpVa1FtQXF1?=
 =?utf-8?B?cFZrQWNZQmtnNGFLak5JT0tRcGxFbVl0OFVRbjIvbjUrQWVHcXpLY21MVUhM?=
 =?utf-8?B?cGhFMjFmRm1IVmFxV1M5Yjc1SldCK1ViWkJpV3ZWWGJlcy9uaEI3TVlCQjdO?=
 =?utf-8?B?dTd0R1I0SnVMSWVNK0tyeHQ3UldBNm5mMEM5UUx1MU95M2dOR3NYdXR4dzN5?=
 =?utf-8?B?UlRnU3M1SVIxYmUzZVQrTmZUMUJKdzF3TWovb3RTendWSWwzYXpTdkxiZ0Zp?=
 =?utf-8?B?bklGK2NHSnFEbTByMDE1KzlLSEozTEtuQTZPYm9PTm5JdHIrNUpqRXcrOTdJ?=
 =?utf-8?B?V1hpcUc1TS8wYlBhN05IR1VaRGJFL21pbEdyQkJwYy9Ea2FPVGUrL0VLcS94?=
 =?utf-8?B?Rnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t47pnG78/yhd7bSHcCq+bs1ZOBzpGPv6xxtp6B6CgMMZfDUeHVpMK2JfikzyXWgGdI5tQRBpzljB/TMIhbWWEOHmrs11cndBjWMjEIzHeHTegMKEvX/y7Z4JWpVLDdeE12y5IIatyU7ASj1JEFzEojeL1VY2Gg8501jVK6bwShyXbUmzteVKelSmi1Rhi/0VrZpw3s34A/QOyKrlGy8HkLg9wrIWwatJUVSFxjW2T4HKY9dBQtQLzN4eiMdksCZLv4xZt8PK9S3nBtNo/eA23FatMfAc7OAnEuYzsLjJfbN+4ZMQtjuRY3OTA0f2nhVbwteGHKB/Xz18+SO4XIqtVMKBwSEG1gJ2a4znPuA9t/4BcqoFZEHqBpBWjGww4CNOW2xWjceo+4aD12g5iKqd8rY3oJSYT2nobvXYGGZZQodihyv5Bcbaha/gVA7hG9gBUy+xVqWYHBXu7Cub7yUKphdTXQ8/CXwfWJXcUKJ6QxsrRDiZ83BYjKXCFhYauK24R9r1dL+hK8Dldg3cTpCx8fVZAN/xWLWYyMi028eiDGoQC20Kvf8nXLLTDgpajclIU5Q6POtxKxF/MUtCaJE+MLbjnrJaM3m3gcSssJ3S6gg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a315a077-9998-4bb4-a047-08dcd2d72389
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 03:01:03.5643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YdnQRxmdARez+/o34Ou/9InXKpMMsFPrqC50pMiXlMtBt0jOakFoKdQlv8YtnXieT8CYfxqNewbPGA9iPUFqcgfVqXtcwOv88y29Hh/G0lDAytK8fGegTL5fVXGYHsbm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8027
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409120021
X-Proofpoint-GUID: 8pVRakZDXshtiV0Vj770N_hXKCFBTYt3
X-Proofpoint-ORIG-GUID: 8pVRakZDXshtiV0Vj770N_hXKCFBTYt3

SEkgSm9zZXBoLA0KDQpUaGFuayB5b3UgZm9yIHByb3ZpZGluZyBjb21tZW50cy4gSSBoYXZlIGFk
ZHJlc3NlZCB0aGVtIGFuZCBzZW50IGEgVjEgdmVyc2lvbiBmb3IgcmV2aWV3Lg0KDQpUaGFua3Ms
DQpHYXV0aGFtLg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSm9zZXBoIFFp
IDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+IA0KU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1i
ZXIgMTEsIDIwMjQgMTI6NTggUE0NClRvOiBHYXV0aGFtIEFuYW50aGFrcmlzaG5hIDxnYXV0aGFt
LmFuYW50aGFrcmlzaG5hQG9yYWNsZS5jb20+DQpDYzogSnVueGlhbyBCaSA8anVueGlhby5iaUBv
cmFjbGUuY29tPjsgUmFqZXNoIFNpdmFyYW1hc3VicmFtYW5pb20gPHJhamVzaC5zaXZhcmFtYXN1
YnJhbWFuaW9tQG9yYWNsZS5jb20+OyBvY2ZzMi1kZXZlbEBsaXN0cy5saW51eC5kZXY7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBbUEFUQ0ggUkZDIDEvMV0gb2Nm
czI6IHJlc2VydmUgc3BhY2UgZm9yIGlubGluZSB4YXR0ciBiZWZvcmUgYXR0YWNoaW5nIHJlZmxp
bmsgdHJlZQ0KDQoNCg0KT24gOS8xMC8yNCAxMjo0MCBQTSwgR2F1dGhhbSBBbmFudGhha3Jpc2hu
YSB3cm90ZToNCj4gT25lIG9mIG91ciBjdXN0b21lcnMgcmVwb3J0ZWQgYSBjcmFzaCBhbmQgYSBj
b3JydXB0ZWQgb2NmczIgZmlsZXN5c3RlbS4NCj4gVGhlIGNyYXNoIHdhcyBkdWUgdG8gdGhlIGRl
dGVjdGlvbiBvZiBjb3JydXB0aW9uLiBVcG9uIA0KPiB0cm91Ymxlc2hvb3RpbmcsIHRoZSBmc2Nr
IC1mbiBvdXRwdXQgc2hvd2VkIHRoZSBiZWxvdyBjb3JydXB0aW9uDQo+IA0KPiBbRVhURU5UX0xJ
U1RfRlJFRV0gRXh0ZW50IGxpc3QgaW4gb3duZXIgMzMwODA1OTAgY2xhaW1zIDIzMCBhcyB0aGUg
DQo+IG5leHQgZnJlZSBjaGFpbiByZWNvcmQsIGJ1dCBmc2NrIGJlbGlldmVzIHRoZSBsYXJnZXN0
IHZhbGlkIHZhbHVlIGlzIA0KPiAyMjcuICBDbGFtcCB0aGUgbmV4dCByZWNvcmQgdmFsdWU/IG4N
Cj4gDQo+IFRoZSBzdGF0IG91dHB1dCBmcm9tIHRoZSBkZWJ1Z2ZzLm9jZnMyIHNob3dlZCB0aGUg
Zm9sbG93aW5nIGNvcnJ1cHRpb24gDQo+IHdoZXJlIHRoZSAiTmV4dCBGcmVlIFJlYzoiIGhhZCBv
dmVyc2hvdCB0aGUgIkNvdW50OiIgaW4gdGhlIHJvb3QgDQo+IG1ldGFkYXRhIGJsb2NrLg0KPiAN
Cj4gICAgICAgICBJbm9kZTogMzMwODA1OTAgICBNb2RlOiAwNjQwICAgR2VuZXJhdGlvbjogMjYx
OTcxMzYyMiAoMHg5YzI1YTg1NikNCj4gICAgICAgICBGUyBHZW5lcmF0aW9uOiA5MDQzMDk4MzMg
KDB4MzVlNmFjNDkpDQo+ICAgICAgICAgQ1JDMzI6IDAwMDAwMDAwICAgRUNDOiAwMDAwDQo+ICAg
ICAgICAgVHlwZTogUmVndWxhciAgIEF0dHI6IDB4MCAgIEZsYWdzOiBWYWxpZA0KPiAgICAgICAg
IER5bmFtaWMgRmVhdHVyZXM6ICgweDE2KSBIYXNYYXR0ciBJbmxpbmVYYXR0ciBSZWZjb3VudGVk
DQo+ICAgICAgICAgRXh0ZW5kZWQgQXR0cmlidXRlcyBCbG9jazogMCAgRXh0ZW5kZWQgQXR0cmli
dXRlcyBJbmxpbmUgU2l6ZTogMjU2DQo+ICAgICAgICAgVXNlcjogMCAocm9vdCkgICBHcm91cDog
MCAocm9vdCkgICBTaXplOiAyODEzMjAzNTc4ODgNCj4gICAgICAgICBMaW5rczogMSAgIENsdXN0
ZXJzOiAxNDE3MzgNCj4gICAgICAgICBjdGltZTogMHg2NjkxMWI1NiAweDMxNmVkY2I4IC0tIEZy
aSBKdWwgMTIgMDY6MDI6MzAuODI5MzQ5MDQ4IDIwMjQNCj4gICAgICAgICBhdGltZTogMHg2Njkx
MWQ2YiAweDdmN2EyOGQgLS0gRnJpIEp1bCAxMiAwNjoxMToyMy4xMzM2Njk1MTcgMjAyNA0KPiAg
ICAgICAgIG10aW1lOiAweDY2OTExYjU2IDB4MTJlZDc1ZDcgLS0gRnJpIEp1bCAxMiAwNjowMjoz
MC4zMTc1NTIwODcgMjAyNA0KPiAgICAgICAgIGR0aW1lOiAweDAgLS0gV2VkIERlYyAzMSAxNzow
MDowMCAxOTY5DQo+ICAgICAgICAgUmVmY291bnQgQmxvY2s6IDI3NzczNDYNCj4gICAgICAgICBM
YXN0IEV4dGJsazogMjg4Njk0MyAgIE9ycGhhbiBTbG90OiAwDQo+ICAgICAgICAgU3ViIEFsbG9j
IFNsb3Q6IDAgICBTdWIgQWxsb2MgQml0OiAxNA0KPiAgICAgICAgIFRyZWUgRGVwdGg6IDEgICBD
b3VudDogMjI3ICAgTmV4dCBGcmVlIFJlYzogMjMwDQo+ICAgICAgICAgIyMgT2Zmc2V0ICAgICAg
ICBDbHVzdGVycyAgICAgICBCbG9jayMNCj4gICAgICAgICAwICAwICAgICAgICAgICAgIDIzMTAg
ICAgICAgICAgIDI3NzYzNTENCj4gICAgICAgICAxICAyMzEwICAgICAgICAgIDIxMzkgICAgICAg
ICAgIDI3NzczNzUNCj4gICAgICAgICAyICA0NDQ5ICAgICAgICAgIDEyMjEgICAgICAgICAgIDI3
NzgzOTkNCj4gICAgICAgICAzICA1NjcwICAgICAgICAgIDczMSAgICAgICAgICAgIDI3Nzk0MjMN
Cj4gICAgICAgICA0ICA2NDAxICAgICAgICAgIDU2NiAgICAgICAgICAgIDI3ODA0NDcNCj4gICAg
ICAgICAuLi4uLi4uICAgICAgICAgIC4uLi4gICAgICAgICAgIC4uLi4uLi4NCj4gICAgICAgICAu
Li4uLi4uICAgICAgICAgIC4uLi4gICAgICAgICAgIC4uLi4uLi4NCj4gDQo+IFRoZSBpc3N1ZSB3
YXMgaW4gdGhlIHJlZmxpbmsgd29ya2ZvdyB3aGlsZSByZXNlcnZpbmcgc3BhY2UgZm9yIGlubGlu
ZSB4YXR0ci4NCj4gVGhlIHByb2JsZW1hdGljIGZ1bmN0aW9uIGlzIG9jZnMyX3JlZmxpbmtfeGF0
dHJfaW5saW5lKCkuIEJ5IHRoZSB0aW1lIA0KPiB0aGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCB0aGUg
cmVmbGluayB0cmVlIGlzIGFscmVhZHkgcmVjcmVhdGVkIGF0IHRoZSANCj4gZGVzdGluYXRpb24g
aW5vZGUgZnJvbSB0aGUgc291cmNlIGlub2RlLiBBdCB0aGlzIHBvaW50LCB0aGlzIGZ1bmN0aW9u
IA0KPiByZXNlcnZlcyBzcGFjZSBzcGFjZSBpbmxpbmUgeGF0dHJzIGF0IHRoZSBkZXN0aW5hdGlv
biBpbm9kZSB3aXRob3V0IA0KPiBldmVuIGNoZWNraW5nIGlmIHRoZXJlIGlzIHNwYWNlIGF0IHRo
ZSByb290IG1ldGFkYXRhIGJsb2NrLiBJdCBzaW1wbHkgDQo+IHJlZHVjZXMgdGhlIGxfY291bnQg
ZnJvbSAyNDMgdG8gMjI3IHRoZXJlYnkgbWFraW5nIHNwYWNlIG9mIDI1NiBieXRlcyANCj4gZm9y
IGlubGluZSB4YXR0ciB3aGVyZWFzIHRoZSBpbm9kZSBhbHJlYWR5IGhhcyBleHRlbnRzIGJleW9u
ZCB0aGlzIA0KPiBpbmRleCAoaW4gdGhpcyBjYXNlIHVwdG8gMjMwKSwgdGhlcmVieSBjYXVzaW5n
IGNvcnJ1cHRpb24uDQo+IA0KPiBUaGUgZml4IGZvciB0aGlzIGlzIHRvIHJlc2VydmUgc3BhY2Ug
Zm9yIGlubGluZSBtZXRhZGF0YSBiZWZvcmUgdGhlIGF0IA0KPiB0aGUgZGVzdGluYXRpb24gaW5v
ZGUgYmVmb3JlIHRoZSByZWZsaW5rIHRyZWUgZ2V0cyByZWNyZWF0ZWQuIFRoZSANCj4gY3VzdG9t
ZXIgaGFzIHZlcmlmaWVkIHRoZSBmaXguDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBHYXV0aGFtIEFu
YW50aGFrcmlzaG5hIA0KPiA8Z2F1dGhhbS5hbmFudGhha3Jpc2huYUBvcmFjbGUuY29tPg0KDQpG
aXhlczogZWY5NjJkZjA1N2FhICgib2NmczI6IHhhdHRyOiBmaXggaW5saW5lZCB4YXR0ciByZWZs
aW5rIikNCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCg0KPiAtLS0NCj4gIGZzL29jZnMy
L3JlZmNvdW50dHJlZS5jIHwgMTggKysrKysrKysrKysrKysrKysrDQo+ICBmcy9vY2ZzMi94YXR0
ci5jICAgICAgICB8IDExICstLS0tLS0tLS0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2Vy
dGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL3Jl
ZmNvdW50dHJlZS5jIGIvZnMvb2NmczIvcmVmY291bnR0cmVlLmMgaW5kZXggDQo+IDNmODBhNTZk
MGQ2MC4uYzBlZGIzMmE3ZmY2IDEwMDY0NA0KPiAtLS0gYS9mcy9vY2ZzMi9yZWZjb3VudHRyZWUu
Yw0KPiArKysgYi9mcy9vY2ZzMi9yZWZjb3VudHRyZWUuYw0KPiBAQCAtMjUsNiArMjUsNyBAQA0K
PiAgI2luY2x1ZGUgIm5hbWVpLmgiDQo+ICAjaW5jbHVkZSAib2NmczJfdHJhY2UuaCINCj4gICNp
bmNsdWRlICJmaWxlLmgiDQo+ICsjaW5jbHVkZSAic3ltbGluay5oIg0KPiAgDQo+ICAjaW5jbHVk
ZSA8bGludXgvYmlvLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvYmxrZGV2Lmg+DQo+IEBAIC00MTgy
LDYgKzQxODMsMjMgQEAgc3RhdGljIGludCBfX29jZnMyX3JlZmxpbmsoc3RydWN0IGRlbnRyeSAq
b2xkX2RlbnRyeSwNCj4gIAkJZ290byBvdXRfdW5sb2NrOw0KPiAgCX0NCj4gIA0KPiArCWlmICgo
T0NGUzJfSShpbm9kZSktPmlwX2R5bl9mZWF0dXJlcyAmIE9DRlMyX0hBU19YQVRUUl9GTCkgJiYN
CiAgICAgICAgICAgIF4gYWxpZ24gaXQgaGVyZSwgcGxlYXNlLg0KDQo+ICsJCShPQ0ZTMl9JKGlu
b2RlKS0+aXBfZHluX2ZlYXR1cmVzICYgT0NGUzJfSU5MSU5FX1hBVFRSX0ZMKSkgew0KPiArCQkv
Kg0KPiArCQkgKiBBZGp1c3QgZXh0ZW50IHJlY29yZCBjb3VudCB0byByZXNlcnZlIHNwYWNlIGZv
ciBleHRlbmRlZCBhdHRyaWJ1dGUuDQo+ICsJCSAqIElubGluZSBkYXRhIGNvdW50IGhhZCBiZWVu
IGFkanVzdGVkIGluIG9jZnMyX2R1cGxpY2F0ZV9pbmxpbmVfZGF0YSgpLg0KPiArCQkgKi8NCj4g
KwkJaWYgKCEoT0NGUzJfSShuZXdfaW5vZGUpLT5pcF9keW5fZmVhdHVyZXMgJiBPQ0ZTMl9JTkxJ
TkVfREFUQV9GTCkgDQo+ICsmJg0KICAgICAgICAgICAgICAgICAgICBeIGRpdHRvLg0KDQpBbmQg
c2luY2UgdGhlcmUgYXJlIG1hbnkgcGxhY2VzIGFjY2VzcyBPQ0ZTMl9JKG5ld19pbm9kZSksIEkn
ZCBsaWtlIGRlZmluZSBhIHZhcmlhYmxlIGZvciBpdC4gVGhpcyBjYW4gYWxzbyBtYWtlIGNvZGUg
aW4gb25lIGxpbmUgbXVjaCBzaG9ydGVyLiBlLmcuDQpzdHJ1Y3Qgb2NmczJfaW5vZGVfaW5mbyAq
b2kgPSBPQ0ZTMl9JKGlub2RlKTsNCg0KPiArCQkJIShvY2ZzMl9pbm9kZV9pc19mYXN0X3N5bWxp
bmsobmV3X2lub2RlKSkpIHsNCj4gKwkJCXN0cnVjdCBvY2ZzMl9kaW5vZGUgKm5ld19kaSA9IG5l
d19iaC0+Yl9kYXRhOw0KPiArCQkJc3RydWN0IG9jZnMyX2Rpbm9kZSAqb2xkX2RpID0gb2xkX2Jo
LT5iX2RhdGE7DQo+ICsJCQlzdHJ1Y3Qgb2NmczJfZXh0ZW50X2xpc3QgKmVsID0gJm5ld19kaS0+
aWQyLmlfbGlzdDsNCj4gKwkJCWludCBpbmxpbmVfc2l6ZSA9IGxlMTZfdG9fY3B1KG9sZF9kaS0+
aV94YXR0cl9pbmxpbmVfc2l6ZSk7DQpBZGQgYSBibGFuayBsaW5lIGhlcmUuDQoNCkJUVywgYWxz
byBjYyBsa21sLg0KDQpUaGFua3MsDQpKb3NlcGgNCg0KPiArCQkJbGUxNl9hZGRfY3B1KCZlbC0+
bF9jb3VudCwgLShpbmxpbmVfc2l6ZSAvDQo+ICsJCQkJCXNpemVvZihzdHJ1Y3Qgb2NmczJfZXh0
ZW50X3JlYykpKTsNCj4gKwkJfQ0KPiArCX0NCj4gKw0KPiAgCXJldCA9IG9jZnMyX2NyZWF0ZV9y
ZWZsaW5rX25vZGUoaW5vZGUsIG9sZF9iaCwNCj4gIAkJCQkJbmV3X2lub2RlLCBuZXdfYmgsIHBy
ZXNlcnZlKTsNCj4gIAlpZiAocmV0KSB7DQo+IGRpZmYgLS1naXQgYS9mcy9vY2ZzMi94YXR0ci5j
IGIvZnMvb2NmczIveGF0dHIuYyBpbmRleCANCj4gM2I4MTIxM2VkN2I4Li5hOWY3MTZlYzg5ZTIg
MTAwNjQ0DQo+IC0tLSBhL2ZzL29jZnMyL3hhdHRyLmMNCj4gKysrIGIvZnMvb2NmczIveGF0dHIu
Yw0KPiBAQCAtNjUxMSwxNiArNjUxMSw3IEBAIHN0YXRpYyBpbnQgb2NmczJfcmVmbGlua194YXR0
cl9pbmxpbmUoc3RydWN0IG9jZnMyX3hhdHRyX3JlZmxpbmsgKmFyZ3MpDQo+ICAJfQ0KPiAgDQo+
ICAJbmV3X29pID0gT0NGUzJfSShhcmdzLT5uZXdfaW5vZGUpOw0KPiAtCS8qDQo+IC0JICogQWRq
dXN0IGV4dGVudCByZWNvcmQgY291bnQgdG8gcmVzZXJ2ZSBzcGFjZSBmb3IgZXh0ZW5kZWQgYXR0
cmlidXRlLg0KPiAtCSAqIElubGluZSBkYXRhIGNvdW50IGhhZCBiZWVuIGFkanVzdGVkIGluIG9j
ZnMyX2R1cGxpY2F0ZV9pbmxpbmVfZGF0YSgpLg0KPiAtCSAqLw0KPiAtCWlmICghKG5ld19vaS0+
aXBfZHluX2ZlYXR1cmVzICYgT0NGUzJfSU5MSU5FX0RBVEFfRkwpICYmDQo+IC0JICAgICEob2Nm
czJfaW5vZGVfaXNfZmFzdF9zeW1saW5rKGFyZ3MtPm5ld19pbm9kZSkpKSB7DQo+IC0JCXN0cnVj
dCBvY2ZzMl9leHRlbnRfbGlzdCAqZWwgPSAmbmV3X2RpLT5pZDIuaV9saXN0Ow0KPiAtCQlsZTE2
X2FkZF9jcHUoJmVsLT5sX2NvdW50LCAtKGlubGluZV9zaXplIC8NCj4gLQkJCQkJc2l6ZW9mKHN0
cnVjdCBvY2ZzMl9leHRlbnRfcmVjKSkpOw0KPiAtCX0NCj4gKw0KPiAgCXNwaW5fbG9jaygmbmV3
X29pLT5pcF9sb2NrKTsNCj4gIAluZXdfb2ktPmlwX2R5bl9mZWF0dXJlcyB8PSBPQ0ZTMl9IQVNf
WEFUVFJfRkwgfCBPQ0ZTMl9JTkxJTkVfWEFUVFJfRkw7DQo+ICAJbmV3X2RpLT5pX2R5bl9mZWF0
dXJlcyA9IGNwdV90b19sZTE2KG5ld19vaS0+aXBfZHluX2ZlYXR1cmVzKTsNCg0K
