Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EB33016F7
	for <ocfs2-devel@lists.linux.dev>; Sat,  7 Mar 2026 16:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772899585; cv=fail; b=fL5Z/NOkmOyHnPuCZjH8nvkMWhUE30AIqC/zowEQRuwEsOdwq8QRD93NRgnntiUvviGsTVDo8HZRL5CakIeekp0D2Z+Ak5kZhthW6WZme8EHgo3fshzGeun1bpw9fjkztffZnfrOZ20xvSzFkLZ+8QWab3uHuutTEe8OEuM3uso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772899585; c=relaxed/simple;
	bh=wBuXqKpISTQZrwrUJXk/3daDNb+a1MFg9PzEeGqAO+o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kKJrB9G3gOBvgqoFxWy6lRRHg/DjUFtBhKbNZ2z16W2mhax5+Lb9/gim5YbGUx2dcuEZXAaVRZxaQT2kLIlwih2iAixPSLsQzTqU0Pf1LVCIpLpzvOLHkc716phII9iGNfkNTOCjYCUgByyzcJIEQuLSfmVxDypD+ni/svKFpRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ByfAfHv+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZKTiWfZg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ByfAfHv+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZKTiWfZg"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627FQWwm1624531;
	Sat, 7 Mar 2026 16:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wBuXqKpISTQZrwrUJXk/3daDNb+a1MFg9PzEeGqAO+o=; b=
	ByfAfHv+8glEvyuOMAlyPcWcjokIeP/FiWedAw27aILsjZB5u6fQVFm/PML7qtUG
	WBZo1b5AqnIqmbdROZQCf6BX3FZYZAiZNUWgFJMPy51+Bp5wjzdecVelttXiAZRz
	0zMb9dsbdo0DWRtSvhOsEs6lK69COLslkgua1TX8PHXMK+T0wnE0jFwzFOHubtlC
	oIFLmf+4VmpS26oEd/2258I0JwiQnVaOfNOLNrEui0TR4LUpCwB/SN6c5w812IZq
	24vxJvOpfOLaloVAh1/OE92NHSj3SbEqagKoa1KA4UETrE18BbRd/f8QFQL1mtsk
	rOk8hzmBoV9iD7KhMhCAJQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4crnxs0111-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:06:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627Bj1MA012829;
	Sat, 7 Mar 2026 16:06:07 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012025.outbound.protection.outlook.com [52.101.48.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafbq0st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:06:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J/Nu5MHH9yM14Yy7JhSZ75q57OthCJxqpCwIddCmoAZPXC2Y5chSznYPIhTVNp7NOuVL9VkJdkSc2E54YOUZFt0uEgvxDgHKivsWsq7l7w7NM10movrUNf2ZT1Lj/1HyqzFjas7q21C5pBymqpVRjtTajyN/oRBcZbgmQ9n8uqIfynJSE6vbsPzsE4osX1k2EsbesciVlXHarZL3QUKkV5w/lMZBvC48w8ljEPXYZYmTgtN/XkczSEOyKI3g1sJhPkZfHr2+sQldz1vhDLG4LdV8picTQf5EEGGsa5yquYL16RHrdj5Gi0QWQBDjPe1fbXFgL4jXbs2MNgkIlTG0sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBuXqKpISTQZrwrUJXk/3daDNb+a1MFg9PzEeGqAO+o=;
 b=UME0k/dq5KM6sNrA+45okOGc2uhh8RpsqDrpxs2XJRL13VJoM9jC4zvUQzNiH4F5cG/q9/YK+EvTQbdnrlupxHSkiBYRw+XIgOopJfIJZtl+NcNXz0/Gr0mR9L3GNA4Q3KRxoou/eqQlGOvi/2FlDjTwtLDKHSXMlcMKFsm+RZnctiULoUunqYhSXDyT9LLWwOXoU7W2hzd58caI7sytt1YOwsqUKUeovn1WuXfSAvBRNmHznMm5RdgCCpRXBgbepcp3iMkJQexyyzNECZbztK9xwIMqkIWYLrMBR83hyne2GLOp5GO3xRGWvY4WKunkNLNFI11swfGQFYdpHWvSsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBuXqKpISTQZrwrUJXk/3daDNb+a1MFg9PzEeGqAO+o=;
 b=ZKTiWfZgwNJo3KyYQM7P7mSwTAiPhkHymBUk4CgyVhKV/Vc5LvJaZwT5FomQHXKCCRssKIGxub4dk7dPHDvgwRNpimtTpfK/r7bbD37iSNX0cUENcZYP0IF2EqTiS02um5WnfNrP0Iympb4AFYVva1M9/52oGyGF9ud+YkRdHbE=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by DS0PR10MB6126.namprd10.prod.outlook.com (2603:10b6:8:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.22; Sat, 7 Mar
 2026 16:06:01 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::dac6:5e5:7de0:d399]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::dac6:5e5:7de0:d399%4]) with mapi id 15.20.9678.020; Sat, 7 Mar 2026
 16:06:01 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Junrui Luo <moonafterrain@outlook.com>
CC: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi
	<joseph.qi@linux.alibaba.com>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yuhao Jiang
	<danisjiang@gmail.com>
Subject: Re: [PATCH 0/2] ocfs2/dlm: fix two bugs in dlm_match_regions()
Thread-Topic: [PATCH 0/2] ocfs2/dlm: fix two bugs in dlm_match_regions()
Thread-Index: AQHcrgNTg/DHcZNOEku5rQKKyW3y0LWjPIEA
Date: Sat, 7 Mar 2026 16:06:01 +0000
Message-ID: <00EF98C8-5E0C-4778-9506-E6C2F54FB93B@oracle.com>
References:
 <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
In-Reply-To:
 <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.400.21)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|DS0PR10MB6126:EE_
x-ms-office365-filtering-correlation-id: 1690cb87-8de9-45f0-74ee-08de7c636d57
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 uGIMsL185TV5UjOxP7yHR+rDzqtGn8FNydChtsPEDUAUsZD9ANlDz096DvLA//Xz3Ffcs9fTA2L5fL8xD2cgibjXw84xQCgctcFOmehdy88oAbXuw9CcSVZe6TLP7E4FerRBp+MIwhYWZfGxHhfghMlixSVyhgJyKL4+nvjjCnzRpVcNwFrOM15ytYdM8E/usxA/yDFVuBRzD9dpHF4zQ9kk1VIf7wjOVpdSMNpc3ADLYS2SVPA1NsLH4c+g76mZj2aGKNHomEraFSkM4gHR6WRN/QE0sjZLdExrT57i6yqVDVZHtmFHg981v7zWG1vpA7FS93wQtJd6NN+o/bDJ+q+rtULIieqd2D5L4LbMSAAhKLyr+znrZXYzj6cxneBhSteWl8g85RHw6euYJQtLHtDbGRBWu2e+YZCCCGHjMEO2iPkda4cKXkM1tH7mI/3P03UeeaIcY5pUf51ClsV8+JVsdKG20mOFoHxSo2KGe9mzqiRMucoRzZy73rzgDEar1+LdCmzsgAHXXo0BG5eNJRPArlywafymwRncx/cxrcZUs+ullz7Rj43p7QmjQjDk5mt/U66ptsS/kS8z7buyYLbKO6V1OTkN3ZPMEjWBRihZhky1S1Z6uGUVjqdR6SjJHK7A5jv7JAQu0qROsjS+D1Csb0QyS2e2cAyPdllqfg6UxjpX2pb7R6ptYDY3j+Wp5KXglKlzS+PtZ4E0ft7e4/V+Q0r8He7Q6ZoAqBcvTSLG87reUnCLzKPBlpwJGWmT0B2ihI2ysF1Q32jIqb48nIUgjT+590arQ86ZJmsNbas=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TTJNaU5JVGtnbFByNFUzRGdvODl4YUVub0VibVRKdHEra0YrSW84N0YyY3N5?=
 =?utf-8?B?QkNlYUQ1M3JSYzJMUWhoRytsMUFWdXVtL2RCcEhkeHJYWjliNjZzQWtURHZO?=
 =?utf-8?B?d1FvbkQ5VmVLS1Q3NFRGRG5XRGl6bVBnZlVaazVML1A2djJ1V1dRUGEyUnpX?=
 =?utf-8?B?SC9vWldSRGNIdzg2Nk5XVnE4ZmNFNjk5M3F5RUIyY2l3cDMzeWd1a0JORUhy?=
 =?utf-8?B?djB0UndhQmNJK2M3VkhnWEtHMzEraXR6cnZFbmhlTjBJZ1pKbzZnVmlvd0lv?=
 =?utf-8?B?YTFtWjRsTHpSN3FzcGIwdDJObUxld21MaUhZd0hkSHZ0bzNjc29tbE5zT00z?=
 =?utf-8?B?d3hGbHVWeTUwR1pTMDVybzhSalNoMC92dGt1NTBpVlBXd29JNmlabTVwazZU?=
 =?utf-8?B?dllVaXVrRkxJY1ArdHhaWGVTeHpxWTIvQTEwQUlmV0VFeVlPWkhKaXpEelUv?=
 =?utf-8?B?ajZUajJ3bW1kQldnQnhVMVJBeFpyMmNjZyt2cWNSaWhiUWJ0aVQ4cXRWMC8v?=
 =?utf-8?B?elQzVDRUU0RvQzFsTjhXbkVkMUN0Uy84UHJJVGd1eEYrNzVGZHc3VEZRaWhx?=
 =?utf-8?B?RzB4eURobTc4RStXc0JrK0R2RGp5aHM0cnBzV1lKZzUyM3pJZnpPbW9sYXFC?=
 =?utf-8?B?N0ZldGdIK1FnTnpDTzkxbGFCZThGeUhWYm0yVCtSd1VTbnovSFY3UFB2d3VK?=
 =?utf-8?B?NitQTmhxOGxBT25yT0dVTEYwNHpUQXpaZXVlcDZyWllTRXdWaUZUWkcwNTBp?=
 =?utf-8?B?b3Z5YktmazRJR2JDT0hnZ2Evck5KQ3hSTXFEM3BrRU81aVYyMjRJcjVJNW9j?=
 =?utf-8?B?ZzJpRzM4YUlNRkpkNTRjeU9MNkw4UGZpTHIrUTdNNzh1YUtmMUNPbFduUVRr?=
 =?utf-8?B?N25xR0pwSkZUZUlvWTNVNklqTzJ5bnlFQ2JSVVJCUXVUTTBJdEtZdlY4L0Fk?=
 =?utf-8?B?eWFwK2UrWkp1ejZNM1dyUUR3UElIN0JnMlZQV1FtWWpUVS84NUxyVHQ4Zk9a?=
 =?utf-8?B?aEhYeGR5MWVjNjM1a1ZSbDVZZUNiWEdWS25veE40cVM5TkExUGphWlhkc1Yz?=
 =?utf-8?B?enlxTGpSbGtScXZYSnc4R1Q4Q3QzRlBtcFBJcGIxZ1JRWDFhZjJuaXcxL0dB?=
 =?utf-8?B?bkI1UllDT2RzVWJrWDBNOFNlSjB2ang0UFQrYVdJTnNheTE3QVJyZWpydEI0?=
 =?utf-8?B?VCswd1B4a3hoaWdDcnNjeXFIc2dIdHdkWEdTUjJ4YUsySHFzMnpQRjAyRjN1?=
 =?utf-8?B?ZmtVSWI1TENBTDNFQU1uZWRyN1g2eXJzSEVocmdWajFZWGJsKzA3Q3RKc1dM?=
 =?utf-8?B?VkpZUzMzaTFmNWZaNndwYUlsQWYvQmJ2VWp0T0Rlc3hMTk52YWd0ZEZHakFu?=
 =?utf-8?B?MWNlT1J2Sk5CZEY5ZVErWGtrcTk3aWVPS1dMQlhoWlFzem5vdEFQYi8vOGNI?=
 =?utf-8?B?OHY3bHdSUUxQRzJ5T3FZNkc5WThqQWFaUWRWZkQ3VnZLeDQ3Rlo2dVlFMmI4?=
 =?utf-8?B?dDhXVzBTNFBmcG1maHQ0RHVFTzEwQXNUei9DWDl4T3VydUttWDZWUFM4MzRk?=
 =?utf-8?B?UVk0ank1QjhTT1hZTHJOOFBCTXZTYWJPeGhuU1F1dTgvR1NmVU5CV0FQbzRC?=
 =?utf-8?B?SzVOSTBrUFYvbnp0dXlnLzdZUlZNWWd0aU1CeEFueWtSN2d5bG5yM1ZwcEtQ?=
 =?utf-8?B?QitEWTF3UnZyS1NrbWVzOWoyS2ZkZXdsZ0ZtQkkzbGZJbms5YUNqdytGZHVB?=
 =?utf-8?B?Z2dQMzlPR2xzYWhMVmIyRG9XNzVqbjRSaXNkc1BhU3g2ZGNoc3pCanpXblJO?=
 =?utf-8?B?aUNCTDV4ZEg1N0RlRkJtWEZoMlRJL29vMnA2NjNvY1lvWXF2d0RaUFhDSGNi?=
 =?utf-8?B?TzRpUS81WWw2YzVJRUpldkswQmxTUHNweHpOYjRSSDFsVmpNVlppaWVuUzhG?=
 =?utf-8?B?T1NtNTV0aGE0cUhZNHg0YitlVDJESnVyTUsrWllCcjBhZlRRVHhkbGNQVjht?=
 =?utf-8?B?azVTRUJmcUFmRmNDT3VEcU5QeDF6c0RVQ3FBOWE0aEpQR3BHZFdYSXgvT29F?=
 =?utf-8?B?eGc2dkE5WGwzRVU5djZwcWRrd3lRK2NackFXcGhjay9HUjhXWTNmd2NFQndT?=
 =?utf-8?B?ZTZSQXRrZWphaE50eWNURGdOb1FUTmpyRlV2Q3JXbVNreHVMYnl1ZmZycy9X?=
 =?utf-8?B?UHJ5QkJjWDNQMHJWd1FKeUpQUTc2cTc0NTViSnpqSU5PN2cwV1BaM3ZleGFD?=
 =?utf-8?B?QWlHR0RRN0xXOUVwKzI5MGRsMXlnOGR1MjBENUhEVW1uVm9ueDJKaTdPUHJl?=
 =?utf-8?B?L3FWcWZlcE5PSUFBdGhhQWdhQThVdEh2Q2pXRG1VQ0RnTHpJL1NwQjlMa3h1?=
 =?utf-8?Q?46/7K9HXeh4DbccFvBO1ou3RKk25hA5NgZ8BU0xofaT3k?=
x-ms-exchange-antispam-messagedata-1: fnqyzb9Y7J2sIqTPr+aE42N0XhRRuUpdWKM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91D24D056797294CBBDD0A8918AC3555@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	eeIF1pd7Ry6YO93zuIQE2n/M1yfimUo1KDcoN9fpRxnrssxjl+VQt/F13ct945LrqCStmmyNsniuGtJ/zJCG1MHFrj4vFZp76H9hXXXVbbKsMXchdBqXXqkfG15fo5/zfXu//MFze7AQ9MH/uVymgCiRmFaCU5OULD3a0S3sW7pDVSvT4ZeDLSeWFwDjozYSZDZ/HJAvGuSbuE6qNdry/rccHSdFlY1SHeSxyv1HYRvrcglUhO0YMK6YVVS0GoBB++S6rmHTHX5zqwuvCEBxJ33GIqwpmq1KKryAvco6cwhS4tUc1vsHPo+IPrloh6vPtaXxfdsydgUTIX7C9seHoA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	csV74PEddYf1QoDvkmar4mOllyCw2zYwQ0r3FcG6iee7SVLHVhs0l3t42ZWrGthjZXhcubFKxggSdAS5oOsZXKVlFo6cSVsgSFNbNIXsDihA1OUhwYITQEP+nx+xX4+WsomJXzBPaJuAQKcKJniyZECk7hHuZqJA1knwaYVAiPMXWb9u50i1MZ1vtyqb1ZlfJf5m3tbQwh7WTTZKEEgVb1M+Lypb+56A0diUPwXslurR2ehK/ltcANPMt8yUp3CeckDC+2AJpUbkU6AkdhGfZc7wOr+9QAPxJ6JJXjeN6IustFtHSlVLWQ81vY8A2UF7otutk2parUV5U6N+GYfLHeo8ipthp2tTuOYmlDArOkwcP6SKAJWxf/xPxFcHK4WO2Jg1iHDjiU/dvuWG2Vlrhm9glmEVsPpoX7UiskS3hpZiGQ/cjWQyRd1AUz92pxmU6LPJEhWIS46kPD8CC04UeDjTJjk/GQvAj8nOEp9vlU1IEhM2Fcd+ZE7b7f6jHvAzIu34xrKKIPt7hhEUArBQ5OlDL3g5nfkI5r5o3qScS7CAvcU0f4BM//Kl5+yG4VpUOx31/ILTwntIN2+BtX9I6I0cmrkoirce8Dx4tNL9gA4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1690cb87-8de9-45f0-74ee-08de7c636d57
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2026 16:06:01.1077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6nbJmNyr5KUeHZJRJGxueyJVNXy61Px+llFocqnhjmHxD1Ky8VwHEBY6WWAHSdxNALkkWXcPqK+4RdqiQQfYwORjgvpEm8OGSygFFU+5HIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDE1MiBTYWx0ZWRfXxOpiMvy5dogq
 lEZ/KjY5Rej3hBGDVvpXGnCxYJWOOWajKhIxM8N4vrIer+G8nkIDHWQg96eKQsFWAJ97F1tX05O
 QOw5+JP8u+pcejsl7mdr1LIwrxPsebmw6OmTxgFa74ZmFbLdV/ZOTUENgL3l1J3Zn3Wv9+7qYw9
 Z/CmG49PBlj3HCKc3MRX9P6fbZGEvLJECpTrduq8pGMyOifLV31EjVMvhjlJSe3Z182/eLKcQjo
 qiHEvlC71zp696FfFT1ywkUDcB/DfIlG205t74eSzHe/vmhCwqMzyWF51Q5v8jeH0Z9JXNXTLZt
 8jJ116jVTcKZVZS4RxhL0z+HM0kU7qVZCGlgEDpEqAukMDETcyOgHC5YV/3+5bRxY6nJOwnQV+8
 JliY7OhWp3EOVCJ3qsLFqfbPmL+21O4Q/HQbQX+mxRi0iQQts+vRk6UmOmiDzk8xX5UqvLavn2P
 90Bl/VDV0GAs/ddJB7Eic5GiOVvNbXqCmCoklDy0=
X-Authority-Analysis: v=2.4 cv=e/QLiKp/ c=1 sm=1 tr=0 ts=69ac4cf1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22
 a=yPCof4ZbAAAA:8 a=UqCG9HQmAAAA:8 a=IzjNCGbW-juLwAY1jKwA:9 a=lqcHg5cX4UMA:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13812
X-Proofpoint-GUID: _bOifOgFqyZgKpe3MeE5TbpN6mJIBz4W
X-Proofpoint-ORIG-GUID: _bOifOgFqyZgKpe3MeE5TbpN6mJIBz4W

VGhlIHR3byBwYXRjaGVzIGxvb2tzIGdvb2QgdG8gbWUuDQoNClJldmlld2VkLWJ5OiBXZW5nYW5n
IFdhbmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNvbSA8bWFpbHRvOndlbi5nYW5nLndhbmdAb3Jh
Y2xlLmNvbT4+DQoNCkp1c3QgdW5yZWxhdGVkIHRvIHRoZXNlIHBhdGNoZXMsIGxvb2tpbmcgYXQg
ZnVuY3Rpb24gbzJoYl9nZXRfYWxsX3JlZ2lvbnMsDQoNCjI1MTkgaW50IG8yaGJfZ2V0X2FsbF9y
ZWdpb25zKGNoYXIgKnJlZ2lvbl91dWlkcywgdTggbWF4X3JlZ2lvbnMpDQoyNTIwIHsNCjI1MjEg
ICAgICAgICBzdHJ1Y3QgbzJoYl9yZWdpb24gKnJlZzsNCjI1MjIgICAgICAgICBpbnQgbnVtcmVn
cyA9IDA7DQoyNTIzICAgICAgICAgY2hhciAqcDsNCjI1MjQNCjI1MjUgICAgICAgICBzcGluX2xv
Y2soJm8yaGJfbGl2ZV9sb2NrKTsNCjI1MjYNCjI1MjcgICAgICAgICBwID0gcmVnaW9uX3V1aWRz
Ow0KMjUyOCAgICAgICAgIGxpc3RfZm9yX2VhY2hfZW50cnkocmVnLCAmbzJoYl9hbGxfcmVnaW9u
cywgaHJfYWxsX2l0ZW0pIHsNCjI1MjkgICAgICAgICAgICAgICAgIGlmIChyZWctPmhyX2l0ZW1f
ZHJvcHBlZCkNCjI1MzAgICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQoyNTMxDQoy
NTMyICAgICAgICAgICAgICAgICBtbG9nKDAsICJSZWdpb246ICVzXG4iLCBjb25maWdfaXRlbV9u
YW1lKCZyZWctPmhyX2l0ZW0pKTsNCjI1MzMgICAgICAgICAgICAgICAgIGlmIChudW1yZWdzIDwg
bWF4X3JlZ2lvbnMpIHsNCjI1MzQgICAgICAgICAgICAgICAgICAgICAgICAgbWVtY3B5KHAsIGNv
bmZpZ19pdGVtX25hbWUoJnJlZy0+aHJfaXRlbSksDQoyNTM1ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBPMkhCX01BWF9SRUdJT05fTkFNRV9MRU4pOw0KMjUzNiAgICAgICAgICAgICAg
ICAgICAgICAgICBwICs9IE8ySEJfTUFYX1JFR0lPTl9OQU1FX0xFTjsNCjI1MzcgICAgICAgICAg
ICAgICAgIH0NCjI1MzggICAgICAgICAgICAgICAgIG51bXJlZ3MrKzsNCjI1MzkgICAgICAgICB9
DQoyNTQwDQoyNTQxICAgICAgICAgc3Bpbl91bmxvY2soJm8yaGJfbGl2ZV9sb2NrKTsNCjI1NDIN
CjI1NDMgICAgICAgICByZXR1cm4gbnVtcmVnczsNCjI1NDQgfQ0KDQpJdCBzZWVtcyB0aGF0IOKA
mG51bXJlZ3PigJkgY2FuIG1pc21hdGNoIHdpdGgg4oCYcmVnaW9uX3V1aWRzJyAobGluZSAyNTM4
IFZTIGxpbmUgMjUzNCkgZHVlIHRvIHRoZSBsaW1pdGF0aW9uIG9mIOKAmG1heF9yZWdpb25z4oCZ
DQp0aG91Z2ggY2FsbGluZyBvMmhiX2dldF9hbGxfcmVnaW9ucygpIHdpdGggbWF4X3JlZ2lvbnMg
YmVpbmcgTzJOTV9NQVhfUkVHSU9OUyBsb29rcyBnb29kLg0KDQpUaGFua3MsDQpXZW5nYW5nDQoN
Cg0KPiBPbiBNYXIgNiwgMjAyNiwgYXQgMTE6MjLigK9QTSwgSnVucnVpIEx1byA8bW9vbmFmdGVy
cmFpbkBvdXRsb29rLmNvbT4gd3JvdGU6DQo+IA0KPiBJbiBkbG1fbWF0Y2hfcmVnaW9ucygpLCB0
aGUgcXJfbnVtcmVnaW9ucyBmaWVsZCBmcm9tIGEgRExNX1FVRVJZX1JFR0lPTg0KPiBuZXR3b3Jr
IG1lc3NhZ2UgaXMgdXNlZCB0byBkcml2ZSBsb29wcyBvdmVyIHRoZSBxcl9yZWdpb25zIGJ1ZmZl
ciB3aXRob3V0DQo+IHN1ZmZpY2llbnQgdmFsaWRhdGlvbi4gVGhpcyBzZXJpZXMgZml4ZXMgdHdv
IGlzc3VlczoNCj4gDQo+IC0gUGF0Y2ggMSBhZGRzIGEgYm91bmRzIGNoZWNrIHRvIHJlamVjdCBt
ZXNzYWdlcyB3aGVyZSBxcl9udW1yZWdpb25zDQo+ICBleGNlZWRzIE8yTk1fTUFYX1JFR0lPTlMu
IFRoZSBvMm5ldCBsYXllciBvbmx5IHZhbGlkYXRlcyBtZXNzYWdlDQo+ICBieXRlIGxlbmd0aDsg
aXQgZG9lcyBub3QgY29uc3RyYWluIGZpZWxkIHZhbHVlcywgc28gYSBjcmFmdGVkIG1lc3NhZ2UN
Cj4gIGNhbiBzZXQgcXJfbnVtcmVnaW9ucyB1cCB0byAyNTUgYW5kIHRyaWdnZXIgb3V0LW9mLWJv
dW5kcyByZWFkcyBwYXN0DQo+ICB0aGUgMTAyNC1ieXRlIHFyX3JlZ2lvbnMgYnVmZmVyLg0KPiAN
Cj4gLSBQYXRjaCAyIGZpeGVzIGFuIG9mZi1ieS1vbmUgaW4gdGhlIGxvY2FsLXZzLXJlbW90ZSBj
b21wYXJpc29uIGxvb3AsDQo+ICB3aGljaCB1c2VzICc8PScgaW5zdGVhZCBvZiAnPCcsIHJlYWRp
bmcgb25lIGVudHJ5IHBhc3QgdGhlIHZhbGlkIHJhbmdlDQo+ICBldmVuIHdoZW4gcXJfbnVtcmVn
aW9ucyBpcyB3aXRoaW4gYm91bmRzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSnVucnVpIEx1byA8
bW9vbmFmdGVycmFpbkBvdXRsb29rLmNvbT4NCj4gLS0tDQo+IEp1bnJ1aSBMdW8gKDIpOg0KPiAg
ICAgIG9jZnMyL2RsbTogdmFsaWRhdGUgcXJfbnVtcmVnaW9ucyBpbiBkbG1fbWF0Y2hfcmVnaW9u
cygpDQo+ICAgICAgb2NmczIvZGxtOiBmaXggb2ZmLWJ5LW9uZSBpbiBkbG1fbWF0Y2hfcmVnaW9u
cygpIHJlZ2lvbiBjb21wYXJpc29uDQo+IA0KPiBmcy9vY2ZzMi9kbG0vZGxtZG9tYWluLmMgfCAx
MCArKysrKysrKystDQo+IDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCj4gLS0tDQo+IGJhc2UtY29tbWl0OiAwMDMxYzA2ODA3Y2ZhOGFhNTFhNzU5ZmY4YWEw
OWUxYWE0ODE0OWFmDQo+IGNoYW5nZS1pZDogMjAyNjAzMDctZml4ZXMtOWQ4Yjk1MDEyYTQ5DQo+
IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IC0tIA0KPiBKdW5ydWkgTHVvIDxtb29uYWZ0ZXJyYWluQG91
dGxvb2suY29tPg0KPiANCj4gDQoNCg==
