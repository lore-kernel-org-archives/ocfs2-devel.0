Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9B33290C2
	for <ocfs2-devel@lists.linux.dev>; Sat,  7 Mar 2026 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772900107; cv=fail; b=WZgtGQJack6qMGl9FOGU2e4N+JeBFDTe27HMDf57IHbYHL/DQiVfAD5IxK5Vz8636uIrlz06xjGatFeIrTXCWthteCr5Rc/YiSQsat9RRF18L7XLFTOdLf10ZdAFWcfKPHsX6Snz+iZlAaUvXrDOr3vQCdWsZo0A745SWPZFEsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772900107; c=relaxed/simple;
	bh=R6jD7IYjIcIMIl6YIqM6bNL5bUxFS2DUULw3r+bt5x8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nV6WxPqiawLQHo1p9JOgrnYs7XDk3FwALQZGlLOpKJF/xMVSKxyUsz0/JkfczAqriuIxiLJQNPlgsX7DNWGHiA1vmdZAUNSakmRLo9Upv3ER0ys5Qo2DksVX4DHS5n+t6lQ7LdmEX4Rl8qZQQ2WRbmTGCle7Z5YPnKgxEGeLGt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FkDuhk8t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zxAL/UnL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FkDuhk8t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zxAL/UnL"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627FoE9J2122174;
	Sat, 7 Mar 2026 16:14:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=R6jD7IYjIcIMIl6YIqM6bNL5bUxFS2DUULw3r+bt5x8=; b=
	FkDuhk8tuUcKVAT5FBJzlwLOB7tuhJlWwenlfpdjBn4edMIiKZvt9WxVbO5WFu60
	JoonNXnvpQ0JaScIlQBX+uUaVbT8Z6U9U1DXYnxbyR/xu0gKxlidIIcdShJcgm7E
	/QsVDSTT4r7ybBNxUse9tqPX7FWe3n/BZIIixcQr21kSt4okBN6K2qjQUYoodywH
	whW1x1y/EaRy3n2PAz8/NHGinDQqsWJh85H1SajqbYfP0KlE4guxqX65RsjUo4UM
	arv9YeoQ3lCf5EMMbjKTuaqTPmFIiLFUjIRTeypqZ0JDiRJ6p67zlfZUS64fv2St
	rZAVnJLf9FGaUQBYgutZqg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4crpkpr0jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:14:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627BoMk7022813;
	Sat, 7 Mar 2026 16:14:48 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010024.outbound.protection.outlook.com [52.101.56.24])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf7655u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:14:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPldTCrqUIXT8BUg/lYj318NbG24gh1RBx8Z1zCYE+q5fzVX80/oZknbW6h0An/A7KrT2ur3z0GqMT2nJWzbTr3rvoUaVUj3q1NWPbqj+A3BL3eMyni0Z8Eu3uShh9DpRoDor1PfCtc4gxfrscjXwUcuB/XEI6c1A1REJQVsh+2LIxgpvbp38v2hmqf18PWUiEwAOaRCAQG8ownBMfL6S6zWkbqaznBgt9N5SZSxW9LNG1LkSRv5SlGriYErPYIT/xE7leSWreOkQe5E7esC23H8/NS63o/t/ghj1uYK4nuDcuGE97RylktZjTfnXoGf4JCiMHg9ZUA16GYUYtMgWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6jD7IYjIcIMIl6YIqM6bNL5bUxFS2DUULw3r+bt5x8=;
 b=PjjGIw304QY7qBjqFXxYVA788RXcTx7aacppfvDkW9CBV/8mKc5ebO4Sp9oTQRhri2+ESNfDTDKRivqJToJ+x2XYf7/U2xh2/1ToWEl3d9XVZwc9unG9vKjaTUqzXOzlVFtbAmhXkEXTIXWAYatQTZYUGAWtsGU7bJMz2K8fjAMNyjmHqCZK1Z5oBV/gqrDFirml7wMXwomcXYwo2O8T735CgLo7ZNUGKSf9Y/A3cW/bvqUn2NfbbO9//ZnPsjxNIcqTW2ZTyFUqISrR/Q9Paq8vug9qzlMmP8+pHUkLy1yIcPqZnq3ye2rVyTa9+UVeeFHptupMojxb6PqwQx6hiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6jD7IYjIcIMIl6YIqM6bNL5bUxFS2DUULw3r+bt5x8=;
 b=zxAL/UnLIdnTDxcUnHQn7wdCA+CCP31e5AlQalM33VrAu0Fv/FHNBI4M+Ona22cFBce+rvTZVWEXJ0jZZMJr6KGAERe0DHC6b6y4ZIbs8g7wOZvrowZUfpoEOdvawZ5/4FzWtWxLspp3AzertIBVxb3ItiTzPR3GFqQ0rJAE/T8=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by SN7PR10MB7101.namprd10.prod.outlook.com (2603:10b6:806:34a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.22; Sat, 7 Mar
 2026 16:14:42 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::dac6:5e5:7de0:d399]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::dac6:5e5:7de0:d399%4]) with mapi id 15.20.9678.020; Sat, 7 Mar 2026
 16:14:42 +0000
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
Thread-Index: AQHcrgNTg/DHcZNOEku5rQKKyW3y0LWjPIEAgAACbwA=
Date: Sat, 7 Mar 2026 16:14:42 +0000
Message-ID: <0A4CA308-D578-42E3-A163-0F4E078E87D0@oracle.com>
References:
 <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <00EF98C8-5E0C-4778-9506-E6C2F54FB93B@oracle.com>
In-Reply-To: <00EF98C8-5E0C-4778-9506-E6C2F54FB93B@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.400.21)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|SN7PR10MB7101:EE_
x-ms-office365-filtering-correlation-id: bcd54f3e-59bf-4d1c-1eda-08de7c64a410
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 3UdOZV0FkUBg7wwEFhH4u9MBq0p+VOIIjbv3vcYWV0efvJHnNRntRUXSBaLO7QrvrmHsEG+CnVdM56kczIDzF/QyrGj9hrZXaf790+UwnlH5G+rXi0s/FZjp7k75GLxVbpjZqBCNUIxqsITRxuiZUVYx/6J/pAtM/p8Q6bTQECAn3SgOkqEjx34px1ZHEt3E/1oQVjTpgU3cJeDeL4EOUS4ymEJ+9l3g+sHlL0Soo7E5qhkIpNsubWQJ+OYne8VWZRI33J9CDrYqWw4/1VytH4YOmFy6WgdDsjYC1LrxAzxJwShp3ngd0i2duqlwC+6TKms+RY5KZavM8Q0PxChTWyPoyOEjU2tNxJZ0kjYmcFQCYgO8/Q2kf/Ij49eCGFhJdvoe6xhm0e/PHfpc+XbSrqHQT8vGLHuzlpolhkE5Idh74ehzckoxc4W9VlmjWfrwpcpQ439yTnYcd1Otem74LAMjSqgm9Mwe7PtGYduJPbfJx0EnG5N2NSu/fC5qSt6Mr+LF/QGd+yS7iby64xrSWAZa8FQkj0EGyvyOI1LvdmDog6B6pNniMCGgUXyQxATf7iyAr3mtA3SuoBjCIxHwAoSHRmAjRRgaoB5qpTrwZCxV+uhHJ9w9SH1K5z2tnv0prpY+ZqzDJbhm8R0BZevoATKu8BmVNM6OxnWtJWjPKdqtv+AG+xRdMiLKpVKRKg6m19g+4mED0aAj82euW+D4uMz/XK0otRERNTrllnICpr5SIlChb7CvaqkgX1n8D+f8tGc5TePEpGo8Ua2pS467rXy7KDpui2P5QRTawPO+tGk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QVdiZDVyTGJsVUl3andhajZaMmpiV216RUtQOGhLRVpneEQzbWUvZFhidStR?=
 =?utf-8?B?b1RVSDNBQUlwQXpacmU0UFdVVU5BbnU4SFA4aW5GSi9DdDMya2s0c0tEYkRu?=
 =?utf-8?B?dHVKcTllSVR0WGJpU3BqMHhBSXB0Vkg1c3VjdHRzZ0pWU0xCMlo0M3pNVU85?=
 =?utf-8?B?VHVocW5MVW9BRlpjaVhWcXkyb043YngyTC91MlNmVTJTOWR4bGVFVDFmV0dp?=
 =?utf-8?B?TW41RGR4WFdyRUc2L1FmMlk0cnhlaXhOSWdlK2l0R3pSSldndTNUSERCUUdT?=
 =?utf-8?B?b25lU3REa2hsY2RwWDQ2dWFDZkJTZFlRN2lYa1VWZHozemRwUWdjQ002YWxI?=
 =?utf-8?B?TlUvOUprZkdScjZKQWdDV3FQcTEwWGFSRHRUUTR6SmFycnM2OXhlZjdQdzlP?=
 =?utf-8?B?UmtNYnpGWEQ2cStoaGVpTXpnZHUwZ01WNjRvWG1uaDNzUmxHSWwvS2hkcHNw?=
 =?utf-8?B?UnhDU2hEZHU4emRQWndBa0JLczdTTTBneGM4RTBJRjlycVJucnZXcEV0dkJa?=
 =?utf-8?B?V1Yyc0VUZ3QwSkhFd2FsU3hicTZNRzdIWXRtQTVGWUtUc1JXdXo5VW0yZ1dX?=
 =?utf-8?B?aHAySVNiMFFWUkxUdmYvYStlZ2RpbTRGZHUxZXVtNU5tNUFQU0tjRC9WTGJt?=
 =?utf-8?B?Z2UvZ0h6bHZaaDMrRVcxWUl5ODVRdDRJVk51SnJsVmVoZ1ltaERycW9tRXZ4?=
 =?utf-8?B?NFA5N1B1cWREY0NMVzE3alQ0anJZVWFmZkU0TEIyNlh2a2UzUjF6aXhQNmhJ?=
 =?utf-8?B?R1MwdkV3cW4zUElPZFIra0Vla3czVUl6NnowLzBqNWZpZ0FKaUhBaTdTL1dZ?=
 =?utf-8?B?dVpxdGFwL2V3N2dnTm43U1NDUms1SmsrR1dYVEtEM3Bpc1hmSWh4U0d4cS85?=
 =?utf-8?B?TmtTMFE3cy95Mk81bUtpYVVtTmFVKy9NeklCaW1JNVJxaGF2d3d4SDZKWTNY?=
 =?utf-8?B?eHNHVmFpWmVhTE1yNjg4L2hDZlZCSHBMWXpiUXpoNmpENWxuc041TVhhKzNp?=
 =?utf-8?B?VXQxbDdnaHhVSzk2dEszSXFyZzZHQ0pXWkw4aitCeUtIZ1BadEpaUUo3d2c1?=
 =?utf-8?B?a2dqaC9Fa09jS3VVTEsya0hZR1NLcGJPS2VHN3JxeWFobXI0TXNVZnhKNk1z?=
 =?utf-8?B?R09PVlNXMkh2OGs0dzc4MUVCWUdUalBFVDlFSkc2N3B5Z3UvWDNCYUpVeVU1?=
 =?utf-8?B?R1B5dDRKVGNWcTk4Vng5TFJka0tDZUJwS2FhaU9MSSszMlF3Q214WDE1eEto?=
 =?utf-8?B?UTU0eWQyR2Q2VitqUVQ2SFZ1c2xHS25qcHVvWktPZ2E5MEdxTmJXSkNPRXpE?=
 =?utf-8?B?MWdWTUN6bDExWUxFZkdEQXVOSi8yT1dSZVpFK203bUhidEhTR3V0VGszVFJq?=
 =?utf-8?B?UnAzd3p1b05IZ3FsTXZMa2FGMWNhaFhNYzZjZDNKUWE0Q3Y5WU13eUF0emQv?=
 =?utf-8?B?WVgrMCtodUcyYWcrSGhQYlJiS2Jobm5IK3hyRWU1czB2QkdNODRBQWs4VmJ6?=
 =?utf-8?B?eHhyaTVNQ0ZlSThqbGdyaW8rK3ZUdzVjWlNiSUF1Sm1BZXlsTlUveHJEaEV1?=
 =?utf-8?B?cFJXUmJHZGdNRDJEcHpoRzZoc1NwbXZQaVFiWUFiRDMyaU4zNDUvMXBRcXh6?=
 =?utf-8?B?MnlUU0I4dk1FRUVwQ0hwbTVtbU00V0hoQktaQVFsTUdORXFwTXExTmpkcFZD?=
 =?utf-8?B?RC9sZkNJQ3pDc3gzak92WEp6ZmVJY3hzV1BTODBXUUZMcTVEUU9xRzJRVnZS?=
 =?utf-8?B?b0xrTEd4OUpNcU5KV0Y0YzZHWWtNanliMjlYRERFOG1IcFF6YWJqQWFxSjdE?=
 =?utf-8?B?YnNGU1VTTXI2b20yY2ZxZmdGNjVrU09WZVF6MTh3L21JWG5yalJGVjNxUTls?=
 =?utf-8?B?cjIzSTc3ZWtybjVXbEFHWDVlSnJCMEJMMG9xOGFMeVMxd1RwVXFSclN2bEVv?=
 =?utf-8?B?QmVzeUNrSzVPcHZnbW1LeFEzVkJ1ZVNpRVVORTFjZzhMZ3ZJdHR2RlMvZzdw?=
 =?utf-8?B?a0VUVjBjWVIrT3ZsOVRMLzdzdlpuYU1vcXZnL3J0bDdVMXpuWlZVclkrYXU2?=
 =?utf-8?B?ZjRvRDdJV3YwMVpJTzVtTVhPOCt2Um9iNmxMTm1qd3loSU91TnZiYlI1bmMw?=
 =?utf-8?B?UC8yTURwSUhvZkJLSmZjRXU4dWZ3dU1QQXV4WUpsQVZFNDVBNFJwK2E0clhs?=
 =?utf-8?B?d21pNWVvcXdYTDNlRjMxWkFrNEtlb1AvVTdxdFlpZ1ovaE5zWjRwejkzeTRQ?=
 =?utf-8?B?enVRMjg0UU1lc3VnQk0rUU1QaDFJMWJ3WEMvWXdvRm9LbTFyUVcxZFRyNldo?=
 =?utf-8?B?Y2o5VWxQMExpOFNrUU91dTFNWHNwN2pEYUo4aUJvSzFHN2NmZXlQRXVkT1J1?=
 =?utf-8?Q?NAkgFhqO7jF6kownmvpsMGH0Kw1biuh143XExoIZZeCCP?=
x-ms-exchange-antispam-messagedata-1: +tJ1jLVA1IQoWWCKXaotsO5bl+gCPKGmXQI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CF8A44A673E87409DF90017FF25434F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	XjJNWw7A7VLNbZhreeAS7k8Npc/MG6gVplezrapUgUxVWF/igKt8afH6TAguSpdHEpteUIRA5pscer5562ED71jLLVvQEy7DKzfV0/c3hiPVoVCOToVHGly3m0WACFZNB3liwFTw61ACX0m47VItsro0CFw97nIpBD5qBFBC5t4VWtyiMifJaXphhLX1obwExJq3Y30hX7QMqTQCWV94aIq0bfHUmbC8Wed/Lq+kf/0pwJD+TcoD53oON/mJVsw6L170M2I1xcWH8rH3vDJojhusOcPD8UwRS81LqNoHrNrZWcPZMvHNUAbqUDtnDApa29VcGCV14Cw3LyKE0FPSXg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eRG2q+1N6bq3Ta0SntNb6C/wB/ddevfQsBAJQTCwL0m06mkucsOz0ns1MfMezKnP1P3nKMubsBL/G6GXm+N916IGUTFcePwyzQSwKPoqlpIB9M4do7JdwNRDDaXs9VH+62NLHQnFiCv+1/rd14u6xcbVX+8P7z0aBbmMJ9KVLGloKzAd/6X5O1fIu7pLkdcd/yCyA0Qe8n+Q/F0B93VFZPEEwHOZIGzuXZHLIQzimUxiaHR0rcRns1I/lf+1sQaPHcMEut1fvSM/z2S4jrEOYEQ3+xxL5T0SkU2sgYWEub9fkZdwHIxD682d5Hg8stYSYMDOc4lj6/e+glJgUdviDSssXcgtKwbwcSqXQR2sPrUeQx1GhpJVcOOcvfmIy05ACEYtEwGFnpgA8ykQnYgPsih14H8a3JeGm+9D1W8vrZG9HmnjBlFoaHP0El+n6GDLbGejhq/SlDZ9wUW4GL8zVLySurI1K4ue/o6KMQvcmeUTdBVoRHmtzL6ZxTlSs0vURSUBTMNSXqym9tZyn84T4qN41jYgQprFWefyo4A64GhTXFkCxzdQz2JmTB5Wy4UTLdB09UcORRlXQBy4ggwYEPTIFVYozLBH0W+ZQxYdzn8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd54f3e-59bf-4d1c-1eda-08de7c64a410
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2026 16:14:42.3790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rroV6VEowWSCI22wFomq5j1T90prRzBqwdl+g0BcRQ/gWXdQ2BCZFAQ9wQByGPCe/6KBFeNnn4xf70KRkXbSFPVbxV/L7TI7t4ADoSe823I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDE1NCBTYWx0ZWRfX0BTVRuPD2cmA
 sTfTTuu5XTh4FgNJi55xgEOHGMzwwU7z64TfI3dP8YGN02WWMGj4vMz+ThqUcIgS2HJUPKr/kO9
 3RD6JnjgAgJVhp/McSYf2X3h1U5zRzUjmdH2vYrZdJrKqp90ozeVVAnfWJC5CwG+PwU0ePdclmu
 RQIhd1frl3EpZ7uMmzCq9X+uLRR4yRJXb1hzdsu2KpqKdxkNGNUrTyNyhA/Y/N+97hMyHvDhSlL
 p/d7qWjiLH65dCJtOOI0xbZ8HnEiRzOpUbNpTnLGi9xh2s99MT+aLbBxnrrBK6rVQgm3WjMloHE
 5/ptJ5z2ETUyACcdhl0vKK5V6LcB5UCDsl8hXlb/R/CZjMcuFQLSKp8ekOXLF4ANzvtDj0jectP
 Ne4+YGREd+s1uNjagtecfL6pJJm4UJDUHxf3RGAw8xtwjn0xAejLmh4JNSGeShCio1leUlFq2o+
 4E/jFay2S5rmh4wz/cQ==
X-Authority-Analysis: v=2.4 cv=Da0aa/tW c=1 sm=1 tr=0 ts=69ac4ef9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22
 a=yPCof4ZbAAAA:8 a=UqCG9HQmAAAA:8 a=wa5K67cUyp9D1Q9SJjkA:9 a=lqcHg5cX4UMA:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: c5XEiEaTy2yrMNkPmFejhuvuIUr5ST7m
X-Proofpoint-ORIG-GUID: c5XEiEaTy2yrMNkPmFejhuvuIUr5ST7m

U29ycnksIG15IGVtYWlsIGNsaWVudCBhZGRlZCBtb3JlIHRvIHRoZSAiUmV2aWV3ZWQtYnnigJ0g
cGFydCwgY29ycmVjdGluZyBpdCBhcyAoaG9wZSB0aGUgY29ycmVjdGlvbiBsb29rcyBnb29kKS4g
DQoNClJldmlld2VkLWJ5OiBXZW5nYW5nIFdhbmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNvbT4N
Cg0KVGhhbmtzLA0KV2VuZ2FuZw0KDQo+IE9uIE1hciA3LCAyMDI2LCBhdCA4OjA24oCvQU0sIFdl
bmdhbmcgV2FuZyA8d2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+IFRoZSB0
d28gcGF0Y2hlcyBsb29rcyBnb29kIHRvIG1lLg0KPiANCj4gUmV2aWV3ZWQtYnk6IFdlbmdhbmcg
V2FuZyA8d2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tIDxtYWlsdG86d2VuLmdhbmcud2FuZ0BvcmFj
bGUuY29tPj4NCj4gDQo+IEp1c3QgdW5yZWxhdGVkIHRvIHRoZXNlIHBhdGNoZXMsIGxvb2tpbmcg
YXQgZnVuY3Rpb24gbzJoYl9nZXRfYWxsX3JlZ2lvbnMsDQo+IA0KPiAyNTE5IGludCBvMmhiX2dl
dF9hbGxfcmVnaW9ucyhjaGFyICpyZWdpb25fdXVpZHMsIHU4IG1heF9yZWdpb25zKQ0KPiAyNTIw
IHsNCj4gMjUyMSAgICAgICAgIHN0cnVjdCBvMmhiX3JlZ2lvbiAqcmVnOw0KPiAyNTIyICAgICAg
ICAgaW50IG51bXJlZ3MgPSAwOw0KPiAyNTIzICAgICAgICAgY2hhciAqcDsNCj4gMjUyNA0KPiAy
NTI1ICAgICAgICAgc3Bpbl9sb2NrKCZvMmhiX2xpdmVfbG9jayk7DQo+IDI1MjYNCj4gMjUyNyAg
ICAgICAgIHAgPSByZWdpb25fdXVpZHM7DQo+IDI1MjggICAgICAgICBsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KHJlZywgJm8yaGJfYWxsX3JlZ2lvbnMsIGhyX2FsbF9pdGVtKSB7DQo+IDI1MjkgICAgICAg
ICAgICAgICAgIGlmIChyZWctPmhyX2l0ZW1fZHJvcHBlZCkNCj4gMjUzMCAgICAgICAgICAgICAg
ICAgICAgICAgICBjb250aW51ZTsNCj4gMjUzMQ0KPiAyNTMyICAgICAgICAgICAgICAgICBtbG9n
KDAsICJSZWdpb246ICVzXG4iLCBjb25maWdfaXRlbV9uYW1lKCZyZWctPmhyX2l0ZW0pKTsNCj4g
MjUzMyAgICAgICAgICAgICAgICAgaWYgKG51bXJlZ3MgPCBtYXhfcmVnaW9ucykgew0KPiAyNTM0
ICAgICAgICAgICAgICAgICAgICAgICAgIG1lbWNweShwLCBjb25maWdfaXRlbV9uYW1lKCZyZWct
PmhyX2l0ZW0pLA0KPiAyNTM1ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBPMkhCX01B
WF9SRUdJT05fTkFNRV9MRU4pOw0KPiAyNTM2ICAgICAgICAgICAgICAgICAgICAgICAgIHAgKz0g
TzJIQl9NQVhfUkVHSU9OX05BTUVfTEVOOw0KPiAyNTM3ICAgICAgICAgICAgICAgICB9DQo+IDI1
MzggICAgICAgICAgICAgICAgIG51bXJlZ3MrKzsNCj4gMjUzOSAgICAgICAgIH0NCj4gMjU0MA0K
PiAyNTQxICAgICAgICAgc3Bpbl91bmxvY2soJm8yaGJfbGl2ZV9sb2NrKTsNCj4gMjU0Mg0KPiAy
NTQzICAgICAgICAgcmV0dXJuIG51bXJlZ3M7DQo+IDI1NDQgfQ0KPiANCj4gSXQgc2VlbXMgdGhh
dCDigJhudW1yZWdz4oCZIGNhbiBtaXNtYXRjaCB3aXRoIOKAmHJlZ2lvbl91dWlkcycgKGxpbmUg
MjUzOCBWUyBsaW5lIDI1MzQpIGR1ZSB0byB0aGUgbGltaXRhdGlvbiBvZiDigJhtYXhfcmVnaW9u
c+KAmQ0KPiB0aG91Z2ggY2FsbGluZyBvMmhiX2dldF9hbGxfcmVnaW9ucygpIHdpdGggbWF4X3Jl
Z2lvbnMgYmVpbmcgTzJOTV9NQVhfUkVHSU9OUyBsb29rcyBnb29kLg0KPiANCj4gVGhhbmtzLA0K
PiBXZW5nYW5nDQo+IA0KPiANCj4+IE9uIE1hciA2LCAyMDI2LCBhdCAxMToyMuKAr1BNLCBKdW5y
dWkgTHVvIDxtb29uYWZ0ZXJyYWluQG91dGxvb2suY29tPiB3cm90ZToNCj4+IA0KPj4gSW4gZGxt
X21hdGNoX3JlZ2lvbnMoKSwgdGhlIHFyX251bXJlZ2lvbnMgZmllbGQgZnJvbSBhIERMTV9RVUVS
WV9SRUdJT04NCj4+IG5ldHdvcmsgbWVzc2FnZSBpcyB1c2VkIHRvIGRyaXZlIGxvb3BzIG92ZXIg
dGhlIHFyX3JlZ2lvbnMgYnVmZmVyIHdpdGhvdXQNCj4+IHN1ZmZpY2llbnQgdmFsaWRhdGlvbi4g
VGhpcyBzZXJpZXMgZml4ZXMgdHdvIGlzc3VlczoNCj4+IA0KPj4gLSBQYXRjaCAxIGFkZHMgYSBi
b3VuZHMgY2hlY2sgdG8gcmVqZWN0IG1lc3NhZ2VzIHdoZXJlIHFyX251bXJlZ2lvbnMNCj4+IGV4
Y2VlZHMgTzJOTV9NQVhfUkVHSU9OUy4gVGhlIG8ybmV0IGxheWVyIG9ubHkgdmFsaWRhdGVzIG1l
c3NhZ2UNCj4+IGJ5dGUgbGVuZ3RoOyBpdCBkb2VzIG5vdCBjb25zdHJhaW4gZmllbGQgdmFsdWVz
LCBzbyBhIGNyYWZ0ZWQgbWVzc2FnZQ0KPj4gY2FuIHNldCBxcl9udW1yZWdpb25zIHVwIHRvIDI1
NSBhbmQgdHJpZ2dlciBvdXQtb2YtYm91bmRzIHJlYWRzIHBhc3QNCj4+IHRoZSAxMDI0LWJ5dGUg
cXJfcmVnaW9ucyBidWZmZXIuDQo+PiANCj4+IC0gUGF0Y2ggMiBmaXhlcyBhbiBvZmYtYnktb25l
IGluIHRoZSBsb2NhbC12cy1yZW1vdGUgY29tcGFyaXNvbiBsb29wLA0KPj4gd2hpY2ggdXNlcyAn
PD0nIGluc3RlYWQgb2YgJzwnLCByZWFkaW5nIG9uZSBlbnRyeSBwYXN0IHRoZSB2YWxpZCByYW5n
ZQ0KPj4gZXZlbiB3aGVuIHFyX251bXJlZ2lvbnMgaXMgd2l0aGluIGJvdW5kcy4NCj4+IA0KPj4g
U2lnbmVkLW9mZi1ieTogSnVucnVpIEx1byA8bW9vbmFmdGVycmFpbkBvdXRsb29rLmNvbT4NCj4+
IC0tLQ0KPj4gSnVucnVpIEx1byAoMik6DQo+PiAgICAgb2NmczIvZGxtOiB2YWxpZGF0ZSBxcl9u
dW1yZWdpb25zIGluIGRsbV9tYXRjaF9yZWdpb25zKCkNCj4+ICAgICBvY2ZzMi9kbG06IGZpeCBv
ZmYtYnktb25lIGluIGRsbV9tYXRjaF9yZWdpb25zKCkgcmVnaW9uIGNvbXBhcmlzb24NCj4+IA0K
Pj4gZnMvb2NmczIvZGxtL2RsbWRvbWFpbi5jIHwgMTAgKysrKysrKysrLQ0KPj4gMSBmaWxlIGNo
YW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4gLS0tDQo+PiBiYXNlLWNv
bW1pdDogMDAzMWMwNjgwN2NmYThhYTUxYTc1OWZmOGFhMDllMWFhNDgxNDlhZg0KPj4gY2hhbmdl
LWlkOiAyMDI2MDMwNy1maXhlcy05ZDhiOTUwMTJhNDkNCj4+IA0KPj4gQmVzdCByZWdhcmRzLA0K
Pj4gLS0gDQo+PiBKdW5ydWkgTHVvIDxtb29uYWZ0ZXJyYWluQG91dGxvb2suY29tPg0KPj4gDQo+
PiANCj4gDQoNCg==
