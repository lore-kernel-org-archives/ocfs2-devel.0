Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454742566
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 19:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756408945; cv=fail; b=aQBkOVsmYidWzVbo02TpAqXP3ANC+jEHANxbQ/9+V9Q7kI9sIrFkJ0AWlX+2uhIOtquta8nXOlCABsUc44ogo8HiHfWuayp06FuhzRXH6rl9TnZhUZGYWylohUiV74dYlxVRaxcygG3uooy36BBqD3ytegJCJlu8EMCyKNmYvhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756408945; c=relaxed/simple;
	bh=uW8Mim4HsjSAxQ+g+kQucM4ZJUsKD6u4N6JR86mkqwU=;
	h=Message-ID:Date:Subject:From:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HO/pLNQ3VFEXtmyd6+KYUIH8v4Sk/kG6jVkdf3qR5tBQZWs0DE47E34/WF5OIe68XsAqiUJuMo5cpu87kmm8tnpSm38DeHsde5k8+AePXUTqw6RJmDVVcZZcpiIBxZVgwo2SmULcoe3F97NxRXmZF82jn1lHTyhK/elZ6osRFYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hHJ/EzKR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eeoulhI5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hHJ/EzKR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eeoulhI5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHNAQW023685
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 19:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=psxAC/L/pnPoIyVgupYqUNLhsXXcs3yU6jXHz2MokH4=; b=
	hHJ/EzKRYe+JBVaD2ZLtXammqgJPlnUqFEwy5yY0X3KUgjlC65ORE9nJD2IxWDzh
	MH1olTTUiTeodMH9Q0qEDtgcQSVBh16B4X7bQP/cjpqF7eUtL2C4EtfImcX7Sr7H
	tmdiuLM5Rj9bk8TnKDFWaIfLbjGQ4eI4XTUP69+MrxhfLVrJESFpsYF2D1DArWaY
	u5u/AQyULFD3J8k6cWlNURfnWZRTXUoFdBqyYMF7VWXnt/QtLOGSR6BJ8T7PT5+V
	3gEjdV9/cR/8BAKPyB8QkZHfqz7oyyBGhDqhq7qACRZwC7KrAL7gWBazHYfGvBJx
	Re1mgPILWjuNvTS5YGq3Kg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twfy20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 19:22:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SIbFEC019683
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 19:22:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cdgy7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 19:22:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssaR/yZQidlc2nIKmvnIhEhhbFc0bdSGTUcDh52no/vN59UvVkWpf1o21yH+bCFdur0vW3F+mrGhD/+jb6MAxfLls5U1yBosPXTIAbmbS/qlHL6umzJgpJln1Ya67NjJhUSmp/aDupG3mJhOEBB7PdqGPluuWXyXPoiT0a7ZIVn+TXMvYIqNNUAhMVsVxmdUS26Sk+0Y40A3995+decrTbHkAVOJp/qDcTZl/1yd9NfeRRzH2Gn0EuRffDyQVaqxREcoftF8Kni1xXFdnMVXP2wJsrCvm2zifKSGwaqLIN1v4ugkmNwiLnCYh5wnlLu/tlmBjhGTxKWgxzrbR1N0EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psxAC/L/pnPoIyVgupYqUNLhsXXcs3yU6jXHz2MokH4=;
 b=m6Tx31Vlj2VmSfwBDCOHRq4yTKlGyxXEnij79Grbo4jQBdxetQwC1IjMy/kXCF3wZ7xQEDaSVYeQbzkfLSeflR7T8xFMr6G/aazcB7cYrT1gFifwQn6vuvu1KUTYawwvOWi7I2m1/D2mEtzE9MC/HLqDCkKExR8FRolH1kmdpfHyJgDKgwVmqF/UNFGuBXcGSXoW3eOm6bieNqpfKZgGOrabETu7xLN9g57uxu5GhEs+6kFR9l30b2YyHMwrLAJlc9zFr7gdJyymaI0IIf3FP5ROgdCrEMd4jcfZ3igSJZsocHR/TfWBz8Ts7ILhoUyOwnS1bOadjN+2wrHSxFFUdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psxAC/L/pnPoIyVgupYqUNLhsXXcs3yU6jXHz2MokH4=;
 b=eeoulhI5mGAsAxVfFoimeE+CPkTkyQtQK9RVzNylrOM31hZUSBwZ+E9fKyUcEnZZZxQPHbVb1p3a12R/fNyva3/V5NYRb7EwH2iu9XXkfanhYY020mEfUPrWRvBDPJde3VBq5n6e2TGZQZNVxSfcc9lLPfZFXj66gy0cLJO0gBY=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 CYXPR10MB7952.namprd10.prod.outlook.com (2603:10b6:930:d6::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Thu, 28 Aug 2025 19:22:13 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9073.017; Thu, 28 Aug 2025
 19:22:12 +0000
Message-ID: <fcca9858-2f39-47ba-a905-136e81c40dd7@oracle.com>
Date: Thu, 28 Aug 2025 14:22:10 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [v3 PATCH] ocfs2: fix recursive semaphore deadlock
 in fiemap call
From: Mark Tinguely <mark.tinguely@oracle.com>
To: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <DM4PR10MB7476AAACC3BCFAA61077E606893BA@DM4PR10MB7476.namprd10.prod.outlook.com>
 <0d3e5061-47dc-449c-8aae-757c693218af@oracle.com>
Content-Language: en-US
In-Reply-To: <0d3e5061-47dc-449c-8aae-757c693218af@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:510:2da::29) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|CYXPR10MB7952:EE_
X-MS-Office365-Filtering-Correlation-Id: e12c2f1b-bf9c-455e-0bc0-08dde66830d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a05yeEF4UmF0ZjlIcVkxQlBYb1hOdTU5RmYxSGswQVJhNm9Hck0zVnZ3b0l6?=
 =?utf-8?B?eEtFTVBhaEpGSUZ3SzhSTjQ4d3B0bUM2WkozcWdvdUtMZUZTN3B3U2dKQk1E?=
 =?utf-8?B?YytNSkNCcHZ1aGp2MG9rZ2RZdkhNa0YvTFhxOWUzNlQ3WmVIbHhJT2JTVGhx?=
 =?utf-8?B?Y0IxRmxWYW95VlNKTGVWaTVzMEdWVVBZTktka1BnYzBYMFNUcFJJYy84aG1D?=
 =?utf-8?B?SjdJQ09DengzRG5ObHFVYmNMYVFoQjZxc1ZLR2J0SEhrT2cvTFBZeTJ5Y1dL?=
 =?utf-8?B?cjZxNityU1FVMnh4ZXZoTjhETVhlbjE1OTZJZ1IvaXJsakZLUXNDam51ZmV2?=
 =?utf-8?B?Vmp1UUJhYUVIWlhsSkVLdnY3TjJTNXdSUUF1ZE1uaXlaY2ZyaTBPdVFEVjM1?=
 =?utf-8?B?VHphcVc0N1VaeDhQY3dKZ0VRaWFUbnl6eVRBZ1JyVEZzL2Z3N09MSEk3TmNX?=
 =?utf-8?B?blZ2ck1vOGlmR1F6YXlIbzNxR3VXL0ZuQmxGeFVZcHFDOVdZOU1JM0JMN0pI?=
 =?utf-8?B?Wms1eDlkbDlzZGRRdjJLTVJGQmNDbkNiSFpwampFVWFIcEhIc0x5cVlpcFJH?=
 =?utf-8?B?UDFXM2NOKzdlWjlnems0cVVDVWRFTjY4dkZjdnNHdFFuTlpGNzdmYitOcmpa?=
 =?utf-8?B?ZXBlWEcyQUdpclBKTFNOSzVZZ3EybnI0bE1iMjh1YmZYNlNwKzA4NFM5VGxH?=
 =?utf-8?B?S2RIYVd6alJwRC9FTWZTVFFIQ29IUmthQlJudTdmZVFQTCsxK0pYSVFjM2F5?=
 =?utf-8?B?bnQ1S05obDhvRmZnTXVoRjVodEh3NHJaOE1LRzB5TndjZmpIYnJvclhkZFZu?=
 =?utf-8?B?VHZjdDVaeWhUcEx0eTdweGtndllHUngzbFZkcVpPVDBJOUtYcExuZ2pvREVC?=
 =?utf-8?B?NTh1RWQ2K0JDYmptbG9icXViYmpVMGp4TGY5OXdmeCtpOXBkNUl4OTY2cldL?=
 =?utf-8?B?VlNlczFmMWp4SmorZS9Qc21uRThuMDlNOUlPcUFBNXQ2WEpQK0F4aklmMkI1?=
 =?utf-8?B?QUpOWHlOYklpODJ0Vm1OMmRvLzFYdFN5cjA0eW5MS3NFbWovcHUzaHYxaHlX?=
 =?utf-8?B?ai9zR0QrdVVZOE44NDNzWXg2MDUwTEhFWjcxOVJwUXMvK01lbkY1NGxRdU9T?=
 =?utf-8?B?N2s3eHM0cmF5enFQSW5xbitjR0thRWF1ZzdCVjEwVHVHTUNaNnlNM2xhQ3JI?=
 =?utf-8?B?b3JLUDcrWG91OTFUS3JhQTJ3QVRKVkxwUytKMXI3alp6aU9PWGx1aFVFVVpB?=
 =?utf-8?B?N1o0ZllyWjlTaHg1aThNQlcvV1FLa3BGcWxOZlVnKzJsRHNZL0hEbWtiVVNN?=
 =?utf-8?B?emcxaWc2c2Njd0hEbVRtdS9EMytEL3F3eS9VR1lLT1hSbGlETGFOTmV6WmFr?=
 =?utf-8?B?cExIRStUNmtmMHgwZ0ppUGtLN2Q0QUpIbnRsNFN3K1RZRlpBODdlS2NLOXFa?=
 =?utf-8?B?aFZkazBxY1A2SE1iVDJPdlN1Zk0yRmprMnpRL3E5OHVzVGIzM0dQSVc0NG81?=
 =?utf-8?B?dVhNZXBOMVRiOTZvTnRqa24rQnVDb0ovRmJ0MGNTdGdYRmczUEh5dEFhM1lN?=
 =?utf-8?B?TGd3a0xzUk5RWGhlUXRDdGI1VXU1Sk9ET1hqM1JqRG5ZS3JOTFk2LzkzSDRM?=
 =?utf-8?B?WXowV1NkemZHZmJuRUdQTU5EUlBtbFR4RkdkVnN3WDZwaDczbUJqZkh5VTNS?=
 =?utf-8?B?V3VDNmo0a2Nzd0Q1cmM1YXhwVjZwNzlWanJvT0xnc3puaEl3c0NUUEdnc2tx?=
 =?utf-8?B?Z1B6UlRpMU8yNzFFOFRzd25uUi9PT0lCUFYrMHFQYm1XVzdKNjYvQks2d1ht?=
 =?utf-8?Q?TBHV4wJlWQszASJmc7caBuH1d4qt8jDmcR4C0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEtnbFRzTXRFejNxY2UyRUpoS0JBS2g3cTZVWERuZ1lyTmlqSFhJTHkxakdO?=
 =?utf-8?B?ekNuSWtxbWV3VGI5QXVNMG1zbHliQUhsS212MStqeEN0aXRWaVo5SU1OS0Vm?=
 =?utf-8?B?Vys0L0l0cWxsVE9HbkxtZFM3SGxIc25tTmttYmxJVUpueUdwL3BKUHJpdUhX?=
 =?utf-8?B?LzlNMUNMRkVhYTZpSGdIbWdRSVFDcmN5a0R0Q3J6WmhHUzRJQzhEK2phSEdN?=
 =?utf-8?B?YmNuRTExdlUxNW8zRXJPUSt1bEM0aFNNVnBEdzBjRmNzVnVtakJzaitFT1NS?=
 =?utf-8?B?KzE1aEtvVXhGZ0h5cDBLR3JPSDYyai9QUmN5eStBd3N2R1gzQXZXRzc2QVE4?=
 =?utf-8?B?VWxOMkxWSFJiQm85ei9JRXRXdS9YTE1ENmNZV0lvU2VLazFuK2kwakJYUkVX?=
 =?utf-8?B?STl6WGJpdXYzSU5Pd0p0ZjBNOWFZOHpoKzhueUpaUHNjR0VOL0RKQ1VzV0hH?=
 =?utf-8?B?Mm1ZYlNPV0dQSmhCZFZYOFh1SXkwZTlQMUd4OXoxN2hkTTNCOTVXOFo0NFk0?=
 =?utf-8?B?MzBISmljVVdveUZrcGRXS0o2b3hEMHFYUFdlTzhQdDhHYnAyaUNPSWpjV2RS?=
 =?utf-8?B?N1NkTDZGWVAxTVFHS2I2ODYyclg0TGZYNzFDOXQxOC9NSk1OR2drVHVNdkd3?=
 =?utf-8?B?dVFDVlpJT1JGdE1tV0Q5MEJod3ZteDM2MEt3cTBOQ2xhcnlDbW5zdEJ4L3ps?=
 =?utf-8?B?VUtOdFptYmNucjF5WUM5SWU4MWJYQVd6TTdzZTFTeDdGSEdRZm5kdHNvaEo0?=
 =?utf-8?B?Wi9Xczd5NldCQWRRTE41UnM4V1p0UlRxN0tTTWlnUDNkRjZxcy8rbThXaW0y?=
 =?utf-8?B?L1EwL3F4OWpVd3UrdjNJMk82Q0U1czdKNnlMQnF0OXNuTkhxUTJUK3YwQ3Qx?=
 =?utf-8?B?dzBZOWlQcmZFdFpqaDFpT1BaTXNwYWgwTDNMMEdQWjJSK3d0UEFsK2xyOTRj?=
 =?utf-8?B?ZDlKZGZuK24vanF5UGpIakVUWTU1N0xkVXAxNDR5anFFQ1o1OXdqSEZVZVNT?=
 =?utf-8?B?YmloNW43by81SzN3ZHJ1TDFpQnkvWFRUVTJuYm5Bc2ZGYzNCeE5xODlwYzJI?=
 =?utf-8?B?VlkvdGVCUzIrcUNxbzFZS1lYSnpDU1FpcGZ2RmtnR1poeTlRbjBaelVMaGNz?=
 =?utf-8?B?ak9GL3VOTGtvUW5mYWhia3k4bFFNZVBwTXdzczQvcWFpNVJvN2o4UHB2cFpm?=
 =?utf-8?B?MXY2cEY1NHZneDdJb013blMwYmdqS0dxOW50MGYxdEVVRVVya2lWVnMwYjQx?=
 =?utf-8?B?QWNnb1RCaGRFSkFQNGZiNXNKUVVOT3pWSFFLdHBnUGE2OTM0WG1sVmlia1ZY?=
 =?utf-8?B?RHFoZGxZNTIzSForVk5Kb0xvaXUrRFdmejRCZkl1TktFK2R4NXg0TjBDc2xS?=
 =?utf-8?B?UXNCUis2ZURMbVVpY2FBQXA1UnIrVjREYjJFSmMzWU5SZENWTVI4WmN2R2NB?=
 =?utf-8?B?RkRLa09UUXJWTTkzbW9kMmo3andJUnZCTmpTL1VpdzRRbmdud2swcUFuR1pt?=
 =?utf-8?B?VTFIVHY0M2JTTkVxdnZQR3V4ZUFXQVd3MWN5eFJDZ2szUndxcXd3M2tlVnUx?=
 =?utf-8?B?MWxmdUlPV3AzcWVsME9hSzFPOTVNSkwzcGp2NUlJN21jZ3pTc0NsRUpnbUJm?=
 =?utf-8?B?cjdjeGxkamFTblg0dGljOXRtZ2cwdGNrTng5cW1rMEYxdHBsUmtINldFT2RJ?=
 =?utf-8?B?QUxmNFRWaFVhTU85djA5WmZZTGpWcTJWM0FvYXJJc3VVcWdVUHdqUUNjNnBM?=
 =?utf-8?B?TnQ2N3YvN1BRZVFLeUtrT1o1TjIvZ2g4cEw5S3hzWU9JdEVsLzBtRHBaYy94?=
 =?utf-8?B?dllRQVk3MVZtUGVaZ3VNUDEzUWVKeHVETmdLMVNVYUVIMjdkWmprdFNpczdO?=
 =?utf-8?B?S1BiNVVteDU5RkgyT1hZZng5T09tbWFIUUxrOUxyMzBOU25RNUN1bmFTUlFi?=
 =?utf-8?B?LzA4MGR2S0p1alhLRUFHbnJDa01CNjMvTUhGUU9jM1MzUEJrditobHVhM1N1?=
 =?utf-8?B?cGQ2clZPYkxYS1hmTW9tTThXL0tPaG1sYWh6WmtuallubXhHSG1WbXNDUjF0?=
 =?utf-8?B?SkM2T1dqNm5aajhmVEF5ZDZhQTV2THEvT2s3cThwOUdNVGRLcmJzR0J3RGIz?=
 =?utf-8?B?b3VSc0pQRlNjNG1vdG54SGx5Sm5Xbm40cUdYbEN0TmR3dm5XTTRFWDBFUmpk?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6mOFi6uqDhuFkAe94bM/jqgIB7+FjdaeiaCO2srPNKJ7IgpnfoVkjplv2WGz681PPiNMZ28f0sGB7jmTym7cb7hBqWTT9cTIh2nkFBwYUSyiP+cV25Qwv3jgoL3MZL+G8UK6kzkXPrrrFkY1AW2H4/aj36jyVxZgrThLr7sjqJC5Av1IXFWTZB3piM+HMsD41WPYbUmusqmEuda/bTwemCFEpSqNhMH+sN+JpNnCXF2XfqYY7GcKXp6C1QjdT9zzScpwuRrVxyyaKli9/UkWQBfngZlY6N6V2jxTg0gZfwZ8YPMev/jyzbESVvlj30GOky6/IXrZqyrsCZorqHyir5KpV+6elp03yPwTWc9v8p+lYaZpKA49XIwSB9mioMn005vAKBL+DgbJGzyqrFbLSaPrczwOBQxG1L0hUIFvLKmyxQS2bJH2h8jkkmn6aNPAKOaQZsrR2ej2foxb7Fvr+aD/EOQx/u/qfDFnNfAvWXADJLTq7ds8woeFL0d4wWj+mBspYgIPsrp3HpLQeiYUZKpEvgXNPzwfDNnqStgBi0yfKkchUc4wSZB0ttqFMe/rK0SZaMs/p0QFssy9P9DVoltqwJQQoybAGteV/lTVfVk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e12c2f1b-bf9c-455e-0bc0-08dde66830d5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 19:22:12.8738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMoRE+imtGCB5zyFjMM5qbMXYCuN+etG5LqxZfYhDFr3nykPJpA9+f2kORuDNNMUlZdYD6K1oLKgSg2TAH2SsE1ljgqNkAkw1AhaRqXxNJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7952
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280162
X-Proofpoint-ORIG-GUID: WhGkzqJl3XO-nSxGAsb2UbzmS2PAbwRJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfXy+n1+JlIjwjh
 m/A5P0xtV5w+/OsQin4QqGkVBBxZmPeFeoxM3jSKprXquUp0YQSntLMAgJZ/bw4IKfKgc/Q5MOl
 smEAVByy6yeblJhwQRtYBvEFl5Bj6MHUqcKG5EG1lcpvmGjNsD7qT7zcsmmM6auTUJ5RZXc2SFm
 otZYfmvsihzYJTWq9q5gd3oz7YTKa583tHiUUgo80ppOLQSK7gD5XjAKwhJ1c8PmVmgHEulBCHd
 MFLWNxhwbswXsaESYmHcg2/hH1Tj+2oQ8w6pZsZlhgoWffNXiR2XmZz6p21pX0r1BgMsa6+yZUc
 q/xw4VUsZJjWiTEfwiPE8VeFF0PKuusBdEJgo7VJ88t+Qn8FI7sEPoxvUDo/4dY9A+pdvuNQxCc
 gBOUuexX
X-Proofpoint-GUID: WhGkzqJl3XO-nSxGAsb2UbzmS2PAbwRJ
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b0ac6e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=edf1wS77AAAA:8
 a=hSkVLCK3AAAA:8 a=yPCof4ZbAAAA:8 a=EPIeVRygGw_3aSd_E8MA:9 a=lqcHg5cX4UMA:10
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=z2U-W3hJrleVIN9YIjzO:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22

On 8/28/25 11:28 AM, Mark Tinguely wrote:
> syzbot detected a OCFS2 hang due to a recursive semaphore on a
> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
> 
> context_switch kernel/sched/core.c:5357 [inline]
>     __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
>     __schedule_loop kernel/sched/core.c:7043 [inline]
>     schedule+0x165/0x360 kernel/sched/core.c:7058
>     schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
>     rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
>     __down_write_common kernel/locking/rwsem.c:1317 [inline]
>     __down_write kernel/locking/rwsem.c:1326 [inline]
>     down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
>     ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
>     do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
>     wp_page_shared mm/memory.c:3762 [inline]
>     do_wp_page+0x268d/0x5800 mm/memory.c:3981
>     handle_pte_fault mm/memory.c:6068 [inline]
>     __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
>     handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
>     do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
>     handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>     exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
>     asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
> RIP: 0010:copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
> RIP: 0010:raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
> RIP: 0010:_inline_copy_to_user include/linux/uaccess.h:197 [inline]
> RIP: 0010:_copy_to_user+0x85/0xb0 lib/usercopy.c:26
> Code: e8 00 bc f7 fc 4d 39 fc 72 3d 4d 39 ec 77 38 e8 91 b9 f7 fc 4c 89
> f7 89 de e8 47 25 5b fd 0f 01 cb 4c 89 ff 48 89 d9 4c 89 f6 <f3> a4 0f
> 1f 00 48 89 cb 0f 01 ca 48 89 d8 5b 41 5c 41 5d 41 5e 41
> RSP: 0018:ffffc9000403f950 EFLAGS: 00050256
> RAX: ffffffff84c7f101 RBX: 0000000000000038 RCX: 0000000000000038
> RDX: 0000000000000000 RSI: ffffc9000403f9e0 RDI: 0000200000000060
> RBP: ffffc9000403fa90 R08: ffffc9000403fa17 R09: 1ffff92000807f42
> R10: dffffc0000000000 R11: fffff52000807f43 R12: 0000200000000098
> R13: 00007ffffffff000 R14: ffffc9000403f9e0 R15: 0000200000000060
>     copy_to_user include/linux/uaccess.h:225 [inline]
>     fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
>     ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
>     ioctl_fiemap fs/ioctl.c:220 [inline]
>     do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
>     __do_sys_ioctl fs/ioctl.c:596 [inline]
>     __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
>     do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>     do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5f13850fd9
> RSP: 002b:00007ffe3b3518b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f5f13850fd9
> RDX: 0000200000000040 RSI: 00000000c020660b RDI: 0000000000000004
> RBP: 6165627472616568 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe3b3518f0
> R13: 00007ffe3b351b18 R14: 431bde82d7b634db R15: 00007f5f1389a03b
> 
> ocfs2_fiemap() takes a read lock of the ip_alloc_sem semaphore (since
> v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
> to read the extent list of this running mmap executable.
> The user supplied buffer to hold the fiemap information page faults
> calling ocfs2_page_mkwrite() which will take a write lock (since
> v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
> semaphore will hold filesystem locks and causes a hang of the
> fileystem.
> 
> The ip_alloc_sem protects the inode extent list and size.
> Release the read semphore before calling fiemap_fill_next_extent()
> in ocfs2_fiemap() and ocfs2_fiemap_inline(). ocfs2_fiemap_inline()
> now returns with semaphore released.
> 
> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
> Closes: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug? 
> extid=541dcc6ee768f77103e7__;!!ACWV5N9M2RV99hQ!KtyP2cHen- 
> zXLVmJXh4CmpXisEbTC01mhqQIZPQb- 
> tKoEgZT2UhmXJNaiY4HXGpqTR9pYFHNSWzNyNyxGosOgxburSg$ <https:// 
> urldefense.com/v3/__https://syzkaller.appspot.com/bug? 
> extid=541dcc6ee768f77103e7__;!!ACWV5N9M2RV99hQ!KtyP2cHen- 
> zXLVmJXh4CmpXisEbTC01mhqQIZPQb- 
> tKoEgZT2UhmXJNaiY4HXGpqTR9pYFHNSWzNyNyxGosOgxburSg$ >
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> ---
> v3: also release semaphore in ocfs2_fiemap_inline() with semaphore released
>       move semaphore before calling fiemap_fill_next_extent()
>       change the error path to release the semaphore to avoid an 
> unnecessary
>       semaphore down/up in the last loop..
> 
> v2: leave the write semaphore in ocfs2_page_mkwrite() but remove the
>       read semaphore before calling fiemap_fill_next_extent().
>       Add a Closes: line
>       review noted missing semaphore change to ocfs2_fiemap_inline()
>              suggest moving locks to fiemap_fill_next_extent() call.
> 
> v1: change the ip_alloc_sem from write to read.
>       rejected in review.
> ---
>    fs/ocfs2/extent_map.c | 27 +++++++++++++++++++++------
>    1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 930150ed5db1..20045fb1bb70 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -706,6 +706,8 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, 
> u64 v_blkno, u64 *p_blkno,
>     * it not only handles the fiemap for inlined files, but also deals
>     * with the fast symlink, cause they have no difference for extent
>     * mapping per se.
> + *
> + * Called with ip_alloc_sem taken and returned with it released.
>     */
>    static int ocfs2_fiemap_inline(struct inode *inode, struct 
> buffer_head *di_bh,
>                                   struct fiemap_extent_info *fieinfo,
> @@ -732,10 +734,16 @@ static int ocfs2_fiemap_inline(struct inode 
> *inode, struct buffer_head *di_bh,
>                            phys += offsetof(struct ocfs2_dinode,
>                                             id2.i_data.id_data);
> 
> +               /* prevent deadlock to a mmap executable page fault */
> +               up_read(&OCFS2_I(inode)->ip_alloc_sem);
> +
>                    ret = fiemap_fill_next_extent(fieinfo, 0, phys, 
> id_count,
>                                                  flags);
>                    if (ret < 0)
>                            return ret;
> +       } else {
> +               /* return with the semaphore released */
> +               up_read(&OCFS2_I(inode)->ip_alloc_sem);
>            }
> 
>            return 0;
> @@ -769,6 +777,7 @@ int ocfs2_fiemap(struct inode *inode, struct 
> fiemap_extent_info *fieinfo,
>             */
>            if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
>                ocfs2_inode_is_fast_symlink(inode)) {
> +               /* ip_alloc_sem is released in ocfs2_fiemap_inline() */
>                    ret = ocfs2_fiemap_inline(inode, di_bh, fieinfo, 
> map_start);
>                    goto out_unlock;
>            }
> @@ -784,6 +793,7 @@ int ocfs2_fiemap(struct inode *inode, struct 
> fiemap_extent_info *fieinfo,
>                                                     &hole_size, &rec, 
> &is_last);
>                    if (ret) {
>                            mlog_errno(ret);
> +                       up_read(&OCFS2_I(inode)->ip_alloc_sem);

not sure what happened to the white space here.
we can remove and change the goto to a new lable, say out_upsema ...

>                            goto out_unlock;
>                    }
> 
> @@ -803,22 +813,27 @@ int ocfs2_fiemap(struct inode *inode, struct 
> fiemap_extent_info *fieinfo,
>                    phys_bytes = le64_to_cpu(rec.e_blkno) << osb->sb- 
>  >s_blocksize_bits;
>                    virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb- 
>  >s_clustersize_bits;
> 
> +               /* prevent deadlock to a mmap executable page fault */
> +               up_read(&OCFS2_I(inode)->ip_alloc_sem);
> +
>                    ret = fiemap_fill_next_extent(fieinfo, virt_bytes, 
> phys_bytes,
>                                                  len_bytes, fe_flags);
> -               if (ret)
> -                       break;
> +               if (ret) {
> +                       if (ret > 0)
> +                               ret = 0;
> +                       goto out_unlock;
> +               }
> +
> +               down_read(&OCFS2_I(inode)->ip_alloc_sem);
> 
>                    cpos = le32_to_cpu(rec.e_cpos)+ 
> le16_to_cpu(rec.e_leaf_clusters);
>            }
> 
> -       if (ret > 0)
> -               ret = 0;

... could put the new out_upseama label here

> +       up_read(&OCFS2_I(inode)->ip_alloc_sem);
> 
>    out_unlock:
>            brelse(di_bh);
> 
> -       up_read(&OCFS2_I(inode)->ip_alloc_sem);
> -
>            ocfs2_inode_unlock(inode, 0);
>    out:
> 

