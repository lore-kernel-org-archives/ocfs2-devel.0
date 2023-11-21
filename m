Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40153495E3
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Nov 2023 12:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LOwe/fmD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H4nr0Ilz"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALBA0eB010515;
	Tue, 21 Nov 2023 12:19:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vx3b8X5/VCbgMnxcDxD0MPD/4XQvVVrYpDXCWJWtdEY=;
 b=LOwe/fmDx43FuKJ2q03w3kEahuOx15aCg25cnvaHDWOb7tt6K8MLyXe5w9Zp40yU6FJT
 fEBnNyuWfBB/ugTnBtxpMQtRhQ2JvtATBPLUPgh80qbrxXRYbyUByXJTLRYm7Cc+EbCO
 VMKQd/maV0B0yewco0gyjkQ+HQB/lQ0Kc5f4H9vrehdG9X1TwC/7jhpGShCCFtzdV6Qu
 4dAb76igwidFukfpGmkV+lXBzxwzi9bHQaiqStETDAxil9AxcbHCBhfBjyJu4F/SbDXf
 L6kuzCU8Ordbt/tlXhmWUIOTWpOj1oNUnNd5sBI0co6A4FTzKKfKTmHs8tyCVPSlvlbq nw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uem6ccygb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 12:19:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALAtkeI037517;
	Tue, 21 Nov 2023 12:19:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekq6vkr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 12:19:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6ihKuquKAs3Gh1kpEvBKlLXB9mYaQWE0otE68cUJTpLJj5ov06FEfIrGRyim7aYsrUPtPqc6oxYmjOINZeVKQUtGnYlmdf+Aogx7/Vc6VkQLZtsr3JSGQ3zKF0TsDVgkqk4PzC3w6YDLu2xeXUPaY9js0GYSkczU9VbFdtYYt8O4Ai+J1Kn+VHZ6xNvnrEVPlbHNp9n4FNt8qFAz4/uynoICk1OY+ZxlmItYXjLHmv/Nc/HlEUaGDbmBAfpYvc6Yfyovt6p/adpj0y0miPjVPCf5o6MyzNts5wwm1wIQbKZHj4BKopcljhxa85RGlZJ+EKgP0cwSLsPzVpLkKK7mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vx3b8X5/VCbgMnxcDxD0MPD/4XQvVVrYpDXCWJWtdEY=;
 b=f3tK5ZswRHZIPtBDpjrG4c2okpaBB+CiqzjGZDQAKDw76y55dKSfT8wFN6WEiCqPlmuGUONOpxB/OAMcG0gxRKYiGRG9kIHk483sdF/DPsE6gBud6XBb068jkBHA8juoGCIK90JrZPkylo6gIaeTtDIulGPn2ZhYjt98vJPKqOf+CjPxYxGgRLPhECrygeOginNyiv8j7XjeGtoQEA6tFpiPBCEsqJz4Bvh9UfQmdN0fzAhgem756ZutV3QDZwQn/Sy3EyZ2BEbW2+uckQYbA8aOXyRdstd/pqe73vVyaWgJ34QRPzrc5BGegbZEwtS2pApijV1XwEeDw/QWEYkr4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vx3b8X5/VCbgMnxcDxD0MPD/4XQvVVrYpDXCWJWtdEY=;
 b=H4nr0Ilz3gOYThQqpUtozdrxX4zwxrVFNHuV05ZlwWbfbWGThmebXd8kx8WO0aUi4J3ZDTgHgAiFSlU6wz1w9svPgoKiETQUTWHJ/PsHP0SpIsgidwOC1L8/o8sSNlA4DegYNm1jkeH+4sIsVJKY2ed79vaGDokHH/I5kPpb7Ec=
Received: from DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11)
 by BN0PR10MB4888.namprd10.prod.outlook.com (2603:10b6:408:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Tue, 21 Nov
 2023 12:19:03 +0000
Received: from DM6PR10MB4347.namprd10.prod.outlook.com
 ([fe80::f68b:8982:e7bb:326a]) by DM6PR10MB4347.namprd10.prod.outlook.com
 ([fe80::f68b:8982:e7bb:326a%7]) with mapi id 15.20.7025.017; Tue, 21 Nov 2023
 12:19:03 +0000
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
Thread-Index: AQHaCyjVirm9V9gc6EO2rgLGIm51GrBkjDGAgA3hOjCAEmXa8A==
Date: Tue, 21 Nov 2023 12:19:03 +0000
Message-ID: 
 <DM6PR10MB4347E075A7DADE3FEA97707BA0BBA@DM6PR10MB4347.namprd10.prod.outlook.com>
References: <20231030120057.928280-1-srivathsa.d.dara@oracle.com>
 <7ABBFC08-4350-4D6C-B740-80DE590F9476@suse.com>
 <MN2PR10MB43491806209E4381F0359573A0AFA@MN2PR10MB4349.namprd10.prod.outlook.com>
In-Reply-To: 
 <MN2PR10MB43491806209E4381F0359573A0AFA@MN2PR10MB4349.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR10MB4347:EE_|BN0PR10MB4888:EE_
x-ms-office365-filtering-correlation-id: bbd84d5a-8776-4187-9e9a-08dbea8c0ca6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 kJyeJRXliE/fhkMQPszGTJnA49tfALKrirftyg3Vci4zNBpAwQ1MsC0rkKehB8ttLyEaaSlRtNWg5+c3+cG1ernodzX+NlxeFwgssXrUOPDnQYlJk3K+OflaC0Boka8zA8oI9se9ExQoruS69vlAQfI80b8w58NF5wWPZ/CashePDRVQYleabj1wOH68dqSliuml8/4HVLgjgFqHN8yxXHn3Gl20/t6+ZkwBRvUKBKKG5oLWI+X4VNxPcG7PI2F8rGfklMXpF3vEMIuDZVc+zuuDq3bXPbjHqnnzUv+ri3dtJ/t1cXVy/Z/OJSDzwl8LkuekYVzu4GbM06A3h8olLaE/U2Z+a1tVpx+TOO96jb9/v6Y2PckBagxM9RFEIJP6tAic7VygD4mZd32iB0eN46yQcQ+iHsyLtfkCoApRUlkD+oEmpOzI/IWFRY0xiTRit5Vs+v2pSyjbu8NkaQj4HCub1+3tOUtPHxQayC+WVUUUD4W5MuiP+DPoEUkCqXh5QJGlVq5wZJMUef1hl0qXYwZogt6uLyr4WghynTkrtjXJpLNUAjOCs4Mt0JujRtcXmTnl7G2ZoIMwFKPMa9iH7XesjpgZ1LEnRPO/BkWor6aKqlZYtqlQ2mpX99fCin/fjwNVVUJsZawcu6+o8JKAVO8JzFLzEUE5OZKAPr70/5I=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4347.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(396003)(376002)(366004)(230273577357003)(230922051799003)(230173577357003)(451199024)(64100799003)(186009)(1800799012)(316002)(6916009)(54906003)(66476007)(66946007)(64756008)(66556008)(76116006)(66446008)(53546011)(7696005)(9686003)(6506007)(71200400001)(26005)(38070700009)(107886003)(478600001)(38100700002)(122000001)(83380400001)(33656002)(86362001)(55016003)(2906002)(5660300002)(8936002)(8676002)(4326008)(52536014)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?Mji1fxN5zSNVhHZAL01q6GwIpGu54BWI4GzJUnwu3D2YQBM/nMmYlKFdpPCK?=
 =?us-ascii?Q?QTV7Mfe3Pw/9UEN7BwLdR2NMitH1Psek+JWDMxak0b3qqabYcVkAkWqPmCDN?=
 =?us-ascii?Q?oROV9XxgQlL2W2FJ5hzXpcmGYv/ppcJZWqT82FEV2LKtE9LStVpC+ZJ3HWZv?=
 =?us-ascii?Q?LrrlDq7RjPjizUyebcVtPG26IWVpnM9WEjpsQXkj0awVlOs/nqe90ZOSu0CC?=
 =?us-ascii?Q?nQmii9OkjqBTDOxGAJEHzNTtYGZMQdZOsLiwXt31q0Fhi/9hkRq+6f6V680V?=
 =?us-ascii?Q?DOook26K4HnRn6RtGM3iqk96GWWFkzaW0TfXwgl/WHTdyZbvL014vYZximoJ?=
 =?us-ascii?Q?HP2kqCHYTSb6LCeJJywPGyyrDOjVQLkGuKdeX5D/wI4FLpwBuwwSMkI0FjGe?=
 =?us-ascii?Q?23qNCTyM5UGMsBpQZxp8u9Js9OTpTmHQ5XGFE7apVUR2SrGHajSXH0q57L6q?=
 =?us-ascii?Q?aiAhdz/nhsOvNa0JJH6grm/OrddfHoMM+y4f5TfKaGcpp+PZjBPP+X99NW2i?=
 =?us-ascii?Q?BvBSwb3yFyRVvwewJ39+PzToJaDwCAhH54KpOtZHrr+6AnJgE0OoTSGDpRAX?=
 =?us-ascii?Q?czICoosHwJ1XEseIWlKE8QSrQ699WKF/9hskRsRTFeElxA3LS4/wX9O3IH7c?=
 =?us-ascii?Q?ltwpY4/zTD5FqBHfLiaT7TyAoGjtxiEpgU5sUvkFSF8b29j3m5eW0NeC5MGV?=
 =?us-ascii?Q?daKF/Te+CW5/uMxM+iAeAM++daAQ43AzDqPykRLqTJLmeRDI08ydEIfawZQB?=
 =?us-ascii?Q?dz5opg8hrXlKAG+xZBEMhn9KPs+sn8fZU/IhWE6+OGLuK/GIqZUFVgkjCRhI?=
 =?us-ascii?Q?v/ek7ibRcYi0sq4GuSeozR+PZ3bDnUxHct6S+ETmI9F32ydH5Gd3LYI8ZSZb?=
 =?us-ascii?Q?b/OydUuSnTaUluufeZQmKSuIv1H+hmyNTO/PNBfRml4NU/kldhTSy98mJojN?=
 =?us-ascii?Q?s2cjUcDrxW0EyC4xMU7gzer/7tbscXh2+cadkDcKI4fU3lXaVTpBdWv+WkBq?=
 =?us-ascii?Q?HIzfMMMs7k+QAHWdu2HYZyM54uKJBSD9zwcoYI045zgXO0MVRBqRFodushEW?=
 =?us-ascii?Q?38IAEmbvFmYbyDrln9GWKnsPm82zQ6TvZhmq3PcwFS3gYnIEj03XpeQci2Qw?=
 =?us-ascii?Q?AsP2tn4ONmcLEtpv89xv8G8S5qoPM6Y3kyugXkOXiTXeW6+Tu8wyakXKi34x?=
 =?us-ascii?Q?VgW9cbi6+ED+whOMb+jeuzEe0+fYf0HSfHrMOC6U4a588f9EbjBO4KTjJnKA?=
 =?us-ascii?Q?9ObY7S2aYhF0N5x/xfLXQe++SB64+FB2EqgEqdwdoCy67IgttAqjgPAwoNu4?=
 =?us-ascii?Q?y2jru5pjE6ESGsza/zNHMTMzFuMtsIJji/AA372KUA1Z8gEV9pVVaWmmV9fV?=
 =?us-ascii?Q?GXmc7asbQ0H6ZfF820KZ6s0eoN7LFP/pEg0M/puOwfvxUF4L9bc9DbJV3xdk?=
 =?us-ascii?Q?Sv0Bh5Z8EY5KlaSWbyrhWScEAqaDEye74YjmXFWLd5/de0BDb33GVACAw6Kz?=
 =?us-ascii?Q?f+7r22SYXIAdESqIki7eA3kLg9wHmZfeEBgAogkJyIQ5pKULGt2LaC97QePV?=
 =?us-ascii?Q?9xaWXkhx0OYNj2CoH0TPE4thgDxXtlKI3O9EaeIH?=
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
	5bWKRTl5v30v6gOIwl/6R3mjyBq8ZczH+v5XUvOowpyp8gzx0arl8jy1i4KLdObNApVqvT2PuUCZcPDPNeplpKBtHSLiE81iYBFa6He5qsjStBtDUJE055jOMPLALc7mF4YgsuzlywOzfCkyxKtA5z9OUK/c62HNY4Ny/S4vGwiZ5Yn0f8wXtZp7yX3eRBjaebkXEDBMVtyy0IXsvzFGkeCShiyo9Wv8UIWF9adaSGFzFTUoZJs7M4lvhoz4HTwVw3xE5Ob0grEIv5XfoWmZZmn5IrgU+/KwlNDkSfZA5PVRIsAoo6nonDwS+mgHVgK9laCVj2L+nT2KvPUutBJrN1SgB0XCF26RW06PA5D6s76dV1iYnOab4MKdtXWK6B+t5Tmimrmnw/fafGVe/bg5JZPn2nBT+xARIhOyWXpaxWRoVXY8KdCHTSLMHJ0tydGcGiW2+L72OzdEmXnnzdEMaPMY2ofbFKBG5yxrVlxlOhHGRUkBQj0shyYOPd4Dz0IBmzfKJQXMllsTTYnU953amY3dozUTkKCDn0YPqn/MOvqnUm7xYY0OTp77m6ZvQqSnOTK9dNY2VAQKQP9o56dbQ920ZWqjk+6XCM8Vvm/wx8Ei/BUpKdNmF3VeawifsQTzMHtwvBhDP71kzxfc7Ftl/UEUrozCPQK6s1NpSKsdmv2QY3rB9oQ7Ji7TfIuDHkJj6C9hk3D6v2ztNWtRrYqYw9xI18khKknSOWiboHin+N6N6sNtlbHrD3SNsJ/ckfj0Kws7Pf4KNS5EByCcfE+YKH2xs//DIkQVivl5L74VeulBBIjQrgxDMi2uIkjG/Nmjk0yMMxy68HeQ66/kL1HOVcX/gM3XafGieTCbw19glS2y49WvYiO6fFQ1ReMgjbur5QqhliAL0iBrTTThWz3Okg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4347.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd84d5a-8776-4187-9e9a-08dbea8c0ca6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2023 12:19:03.1002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oNHmTXQA51ZmphHWdgEBOALlFjiOEg3YHt8upmPej0fK1nrsU5adUUTgJCl8XhXP60pvUo28TQsjy3RNhsNcyAhlmY8oI2gnAVgWA4WFJAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-21_05,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311210096
X-Proofpoint-ORIG-GUID: Tbbav20TulN5kh9qroZzGCqZCEoWxda6
X-Proofpoint-GUID: Tbbav20TulN5kh9qroZzGCqZCEoWxda6



From: Anthony Iliopoulos ailiop@suse.com
Sent: Friday, November 10, 2023 5:28 AM
To: Srivathsa Dara srivathsa.d.dara@oracle.com
Cc: mark@fasheh.com mark@fasheh.com; jlbec@evilplan.org jlbec@evilplan.org;=
 joseph.qi@linux.alibaba.com joseph.qi@linux.alibaba.com; Rajesh Sivaramasu=
bramaniom rajesh.sivaramasubramaniom@oracle.com; Junxiao Bi junxiao.bi@orac=
le.com; ocfs2-devel@lists.linux.dev ocfs2-devel@lists.linux.dev; Gautham An=
anthakrishna gautham.ananthakrishna@oracle.com
Subject: [External] : Re: [PATCH] ocfs2: call ocfs2_abort when journal abor=
t
=20
On Thu, Nov 09, 2023 at 07:26:16PM +0000, Srivathsa Dara wrote:
> Hi Anthony,
> thanks for the review
>
> -----Original Message-----
> From: Anthony Iliopoulos ailiop@suse.com
> Sent: Wednesday, November 1, 2023 4:53 AM
> To: Srivathsa Dara srivathsa.d.dara@oracle.com
> Cc: mark@fasheh.com; jlbec@evilplan.org; joseph.qi@linux.alibaba.com;
> Rajesh Sivaramasubramaniom rajesh.sivaramasubramaniom@oracle.com;
> Junxiao Bi junxiao.bi@oracle.com; ocfs2-devel@lists.linux.dev
> Subject: Re: [PATCH] ocfs2: call ocfs2_abort when journal abort
>
> On Mon, Oct 30, 2023 at 12:00:57PM +0000, Srivathsa Dara wrote:
> > From: Ryan Ding ryan.ding@oracle.com
> >
> >
> > journal can not recover from abort state, so we should take following
> > action to prevent file system from corruption:
>
> Could you elaborate on how corruption can occur when the filesystem is
> in this particular state? How could this be reproduced?
>
> [Srivathsa]: Corruption can occur due to storage failure

How does that failure lead from aborting the journal to causing fs
corruption? What exactly gets corrupted after journal abort? Can you
provide more details and possibly a reproducer on this?

[Srivathsa]: Isn't it a bad idea to leave the filesystem like a way it is
with a journal error. Because journal is not working as expected, we
might run into some trouble in future.

> > 1. change to readonly filesystem when local mount. We can not afford
> >    further write, so change to RO state is reasonable.
>
> This is generally the strategy, but unrelated to the code that this commi=
t
> is touching. The ocfs2_commit_thread() only applies to non-local mounts.
>
> [Srivathsa]: Yes, you are right, this is only for cluster mode. I will re=
move
> all local mount related comments.
>
> > 2. panic when cluster mount. Because we can not release lock resource i=
n
> >    this state, other node will hung when it require a lock owned by thi=
s
> >    node. So panic and remaster is a reasonable choise.
>
> Panicking is never a reasonable choice :-) Why couldn't a remastering be
> initiated without going through a reboot instead?
>
> [Srivathsa]: Without reboot, we run into a journal failure, the only opti=
on
> is to have fs in read-only mode. Could you suggest any other way to make
> this node release the locks held by it?

Switching to read-only, and self-fencing so that another node will take
over the recovery.
[Srivathsa]: ok got it.

> > ocfs2_abort() will do all the above work.
> >
> > Signed-off-by: Ryan Ding ryan.ding@oracle.com
> > Signed-off-by: Srivathsa Dara srivathsa.d.dara@oracle.com
> > ---
> >  fs/ocfs2/journal.c | 27 +++++++++++++++------------
> >  1 file changed, 15 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c index
> > ce215565d061..6dace475f019 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -14,7 +14,6 @@
> >  #include <linux/kthread.h>
> >  #include <linux/time.h>
> >  #include <linux/random.h>
> > -#include <linux/delay.h>
> >  #include <linux/writeback.h>
> >
> >  #include <cluster/masklog.h>
> > @@ -2326,7 +2325,7 @@ static int __ocfs2_wait_on_mount(struct
> > ocfs2_super *osb, int quota)
> >
> >  static int ocfs2_commit_thread(void *arg)  {
> > -   int status;
> > +   int status =3D 0;
> >      struct ocfs2_super *osb =3D arg;
> >      struct ocfs2_journal *journal =3D osb->journal;
> >
> > @@ -2340,21 +2339,25 @@ static int ocfs2_commit_thread(void *arg)
> >              wait_event_interruptible(osb->checkpoint_event,
> >                                       atomic_read(&journal->j_num_trans=
)
> >                                       || kthread_should_stop());
> > +           if (status < 0) {
> > +                   /* As we can not terminate by ourself, just enter a=
n
> > +                    * empty loop to wait for stop.
> > +                    */
> > +                   continue;
> > +           }
>
> the above is unnecessary, given that below will induce panic upon failure=
.
>
> >              status =3D ocfs2_commit_cache(osb);
> >              if (status < 0) {
> > -                   static unsigned long abort_warn_time;
> > -
> > -                   /* Warn about this once per minute */
> > -                   if (printk_timed_ratelimit(&abort_warn_time, 60*HZ)=
)
> > -                           mlog(ML_ERROR, "status =3D %d, journal is "
> > -                                           "already aborted.\n", statu=
s);
> >                      /*
> > -                    * After ocfs2_commit_cache() fails, j_num_trans ha=
s a
> > -                    * non-zero value.  Sleep here to avoid a busy-wait
> > -                    * loop.
> > +                    * journal can not recover from abort state, there =
is
> > +                    * no need to keep commit cache. So we should eithe=
r
> > +                    * change to readonly(local mount) or just panic
> > +                    * (cluster mount).
>
> commit cache doesn't apply to local mounts.
>
> > +                    * We should also clear j_num_trans to prevent furt=
her
> > +                    * commit.
>
> that's redundant given that we're about to panic.
>
> >                       */
> > -                   msleep_interruptible(1000);
> > +                   atomic_set(&journal->j_num_trans, 0);
>
> same here.
>
> > +                   ocfs2_abort(osb->sb, "Detected aborted journal");
>
> ocfs2_commit_cache returning with an error does not necessarily mean that
> the journal has been aborted; jbd2_journal_flush will return an error for=
 other
> conditions too, some of which could be recoverable.
>
> Therefore unconditionally aborting here is not necessarily warranted, and
> presumably this is why the current code is a retry loop.
>
> [Srivathsa]: Even the journal is not aborted, there is some serious
> error with the journal, keeping it running at this stage could lead
> to corruption.

How, precisely? Irrespective of the journal state, this should not be
leading to any corruptions, the ocfs2_commit_thread will just keep
unsuccessfully attempting a journal flush. Otherwise there's a bug
somewhere that needs to be directly addressed.

> But even if the journal has been aborted at that point, there's no reason=
 why
> the node cannot self-fence and effectively shutdown the local fs, instead=
 of
> aborting with a panic.
>
> [Srivathsa]: By self-fence, did you mean system panic/reboot due
> to heartbeat loss? If so, that can't be guaranteed that it will happen
> because the storage failure can be intermittent. Even if that happens,
> it will panic or reboot, how effectively it will shutdown the local fs,
> considering the journal is failing?

I mean intentionally stopping the heartbeat and switching to read-only.

> [Srivathsa]: will send a v2 addressing the redundant code.

Apart from the redundant code, I see two separate issues:

- the claim that there is a potential fs corruption bug after a journal
  abort in ocfs2_commit_thread, which needs to be clarified and
  addressed properly.

- the method of handling irrecoverable journal errors.
[Srivathsa]:  Switching to read-only and self fencing affect
performance in production systems.

Regards,
Anthony
