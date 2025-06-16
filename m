Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4891720297E
	for <ocfs2-devel@lists.linux.dev>; Mon, 16 Jun 2025 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750084802; cv=fail; b=Otx96I2z8pEXr07XooLXP4AJvLr9a6NRlPR8vklP4xvetYjaQ0bgONl6D+v4xvAiXQPxurSxx6c4IpGrititvr5N/+4B1WiRQo+Vbrim84NeHpDq6BN80XHxS1SXNQLVni4Beoabm1Y8cl1lAHHrgtpOtYKR4AuRaTBEOVEc6CM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750084802; c=relaxed/simple;
	bh=1aQoU+C+R8HQptgyU64M0/LClSKuqeDEIMvkIDDSvMo=;
	h=Message-ID:Date:Subject:From:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EQ6HPZ1Tcgzw4OMNw48tmr59eHEoghjMFBwSd3ddhfiOl9Ak7OWzgTBhoJKxXk48NTjixx60w7MArHLrskG515OEPMJvitrcTRL5LTqli+/2TsXid9bUcrWCnSfeUIB1BMYcVFCqzfWBUHpYg/LIEPGii1+J5uGHpqIBU2e3RzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QzizU3Uy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uk3oOqor; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QzizU3Uy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uk3oOqor"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55G7fcaW024197;
	Mon, 16 Jun 2025 14:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Rz+1rukYX7VWTQexz7eDvFqsGyi6+3lUwcaQoVvW96Y=; b=
	QzizU3Uy1cwAmBOZ6mf44waH+76TvTTbqNq/ssHcZIT/BlpBqX3GdrTYWLUyUSHg
	1I/QoMlj9Z0ZwxHY4bS1tLMp8pjTY3vVCQKH12aeZ6WoDKclcahb0aiY2hS4kCqq
	bGRsAahI8I6CU06yyZvarcoN7OA+J+XJ2FXynRcQ64T1Jezg9UdZlcE5msM0zWnz
	paGqsqbmPWmJA0Bx0ZzT+5cHmA9FcMKPJ4nvHTLj/29QSzLL7R0StHVfn2l627YP
	I1PFl9+0WAT+bF18oS3Ot9f3Qt8Kkr18x2yl82DBVjSe4rjQR1VpqzQdHDeHFe4g
	Y3Szq0qo+VAmTWVtCOjiqA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 479hvn23r0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 14:39:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GEMaYd025986;
	Mon, 16 Jun 2025 14:39:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhe8nn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 14:39:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ugRT717GCjqYo68EnLAXYTIvuZVD3VIljwazjWOxKUNQuw3CxvVAZIo6lMN9jiIg63b23IMYBmszEIJVEH7pO8+URYxg4NZq/KxNM9+PHXC53jBZDPy5B23fxRwleCVTQ6q5K3mhfmPkuwsUTdeAc6+AW8A88573Asv1DqY8RbvV37W5YDgNMldMPhzIa891D4Tn/6CIfBwJwAk5NVShIjF5qD2eyjx/hGEmEi1m0uYHIhg8/5rREcDNyNn0roNbIJvewwn3pq9A6yKcekm3bcz5FjT8ulW4SkZnkn7bukpbig3dWWfH3OuQ3d9bmlA7r6gdLYDo1DavYGxE59HDmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rz+1rukYX7VWTQexz7eDvFqsGyi6+3lUwcaQoVvW96Y=;
 b=D+NWkpZlYbwPVipANrUfGjtn9QBoy0dDMQP8Q6LawdncWLn/SeV76Tp05XhNtYZd08eC4oyeqEea4jpewJBllAxtcNhAIlylKe8aVpYzCqQONscz0W5zvGCc30R52rwvS8tuMvrO9/d3ZiwssdJIn8PZYctmxZtrmTRYe9DnX32HeKiVteULx+yU1TwBUqL0Bnvagg3Co5x5EkDK24epd9WyXeHPlvK+nlKiVuTKoaIvc7HA7B9us/4psB35f98kT77HSdLcfTgCM3VJTxBDqrl89YhUY21gATdYZJFuzJ09dT8DVr5vNNcexFP0AHW88pAw6UJUhGyi4ITM5+av2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rz+1rukYX7VWTQexz7eDvFqsGyi6+3lUwcaQoVvW96Y=;
 b=uk3oOqor97KXknscnfjPOVbJiYw8XRwNVuxCyoBkysOINNhqo5dWafM6RVtY5M69MsII6ANinVfY4uaw1yaxrES6P1TLMI8mfNUY1qfSZxJEjyifTIzS4VcyL47t3TPcKG5342EerGpBsB782Vl6V2VfKvC7Lep0XjBH+Cecgng=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 SJ0PR10MB5670.namprd10.prod.outlook.com (2603:10b6:a03:3ed::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.19; Mon, 16 Jun 2025 14:39:42 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.8835.025; Mon, 16 Jun 2025
 14:39:42 +0000
Message-ID: <93f61af8-64a4-4993-b003-7f0b94bc5573@oracle.com>
Date: Mon, 16 Jun 2025 09:39:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [syzbot] [ocfs2?] BUG: unable to handle kernel
 paging request in ocfs2_unlock_and_free_folios
From: Mark Tinguely <mark.tinguely@oracle.com>
To: syzbot <syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com>,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        linux-kernel@vger.kernel.org, mark@fasheh.com,
        ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <684efdcd.050a0220.be214.02c1.GAE@google.com>
 <b92b26e0-e6d9-49e2-b46f-b855831a86fc@oracle.com>
Content-Language: en-US
In-Reply-To: <b92b26e0-e6d9-49e2-b46f-b855831a86fc@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:303:6a::30) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|SJ0PR10MB5670:EE_
X-MS-Office365-Filtering-Correlation-Id: 405d817c-1468-452b-41c3-08ddace3a179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXp0UklkN3RJU3hSWGx6aDV2Y1BiRGNJTHpFM1llSFpTT05HMGU2MWRpL2tN?=
 =?utf-8?B?amo1SVNtQVMyMUhpZGZseXJDOW1ER0JpUGRZYVRTaGwybDV5ank1c0tNbnl6?=
 =?utf-8?B?aFEzSHkrTlFRWU1ybjdnMzdhdGh4a253SFRhdURKUWNER2Z4empydnA4Yzdv?=
 =?utf-8?B?NklwSXNISU51QXhELzJsT3NtaGs0M3NjSEIxY2xlUmlkRmNyWWNmS0wwWVNi?=
 =?utf-8?B?SGltcVVBVU9iTy9keEJuVGdSL3ZHZkozeldGblpLNjVrM3pGcTRqQ3VlTms5?=
 =?utf-8?B?TjN5TTNSS29pMkVSZEdSKzZWNlprYkwwREFVTUgwY3hwb290dzBSN0dIRkhC?=
 =?utf-8?B?R3dOclV0WUs1OUlITTYrL2xqVG5FT2o5WGs1cUFhMFBTc1k4YW0yNGUvWDhs?=
 =?utf-8?B?L1Q1NVRUMzdYekp6RlFqTjgxZFUreTZFMzJ1L1FrWncrSTlrcHdxTjlLbWVU?=
 =?utf-8?B?dXhCMHNuMDNOZGFlbFVDREcwQWV5Z0ZDOXRTRGx6QXdxWCsxYXUxM1N5K1o5?=
 =?utf-8?B?NjVGdk03OWd6R08wNVBRZEFHSlNpUVh4VStQbmtoR3hkaHZqdm9WSTU2eSt5?=
 =?utf-8?B?L0ltMW5kVnd2ck5mWGxEOW1mZG1qVnVIVHBXQno0L3p0R0ZrcDIyU0JhS1RH?=
 =?utf-8?B?V2dVTXcwRE92U0p5UUJISlVTdmw1b21aNDNIeEg4WlFNRmFiOFg1RW9pZzlR?=
 =?utf-8?B?OVMyaU0zdGRsclRlRzdBVUNhemNhTVNOcmsyeFZSVzkvQVJUNjdIM2xVL0Z0?=
 =?utf-8?B?bUJiRWJqZ2NkSlVXVzh0RU1lU0lXZVhpdjlpY1lPdlpmNmFNaEVzZkcwWVhN?=
 =?utf-8?B?N2dmNXFZZDVSbjBoZ1d5UStzcEpwNlErQmxlWEp3U3hvTS9UQXdicHlsNzRs?=
 =?utf-8?B?dTlQclBnakUrQ3FKNXViZi9FdTlCS1pTZ3JGWXBVQUMyY3A5ekNsdnV2WXc0?=
 =?utf-8?B?VlJmbGdDN1h5eVRUYzVSejU3cWFnOGZwY0tScE9sVXNQejZaVGNWTjljMzFl?=
 =?utf-8?B?c1F3bVo0ZW1xMyswQnlWa1NUUGcrUm41TTQxcmsyNHlHRHR6MHN5czJJWjd1?=
 =?utf-8?B?RGtoRmZIOVptdVJSUVhlUkMyN2FvMnZjQk5ROWI0dlIyVzdaWWpESVJIMXlB?=
 =?utf-8?B?OXgrRDgxU1lDRStCcFBQVS9Kd05keTQzZ25lTUoyYUZ5N0gzbUNwZlozQVFR?=
 =?utf-8?B?YUFMb0hjd1ZtSVRVeXp3ZVpnNXVCNFgrbU8xWUZFeWxKbDZ0cFZjaURUa2ND?=
 =?utf-8?B?Z3c5NDJMcy92eWxNTk8rbXRYb3AvNHd5L09kUHZFaTRiVERoOWlTN00vdU5D?=
 =?utf-8?B?QnJVYnZOc3NEMm5VUHlrN1c4WkVOZ0FpY1R6KzZGSmdISTltVktSaWI0bHRT?=
 =?utf-8?B?dml2QUxaaEpHTUhRUnhidFNud0EwRnVYeTY3ay9HWW8vNXZTallsbG5MYmds?=
 =?utf-8?B?R2ZuOHo1V002TnJQaHI4c3ZGc1JCOUs3d0xEZURTb05INXZnUW1BZUE3TEhp?=
 =?utf-8?B?U0J0RkJHSUdxcStRcHZZN1pYaTNTNTRJSkpyL0k5TFNaVnRsN0N1MXVMd0JF?=
 =?utf-8?B?dTIxOXhjY0Z1ZldyK1UweC8va1MxRitxNzZKcGJHdTNWN2NwYmdha3lKc0tz?=
 =?utf-8?B?VE5zWTQ0Uk1RaWxybzduMDBNVVgwN0xpNGJnWUN1TmRUa0VIc3ZGMy9tTElP?=
 =?utf-8?B?ZTg1aUJaWllkZXBuTS9adzR6ZmkzZXpJL1ByTVFNMXhQbklwb1NxS1pLSjlJ?=
 =?utf-8?B?dDZUVkJCMDVYeld5cGxjaUJPeCthRTU0YmF0UXNJOS8zVlI3OVYwcGZLYzZ2?=
 =?utf-8?Q?QacU2kJyMbb0i7U6foouKpExvCKbjjyL+tOSo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3l4bE5ZN3FGWGI5anh0cGkvRFBoTm8vek5IUCt3VDl5ekVtQ0xOUi8zSm9m?=
 =?utf-8?B?em1ZOWEvWWN3RmN4eldGZ0pTelVTUDVpMktWV3ZFUGxPTENzTkFvZlFuK1Qv?=
 =?utf-8?B?S2d1MnAzNWExNkFxbkVEZHdoN1VRV1c2ak9OZmZWT2lUUTY5L21qWjd2V2pL?=
 =?utf-8?B?ejVxMEVGcDZ6Ly9kYi9zK1dXejIrWVZXUVJJWmw1M2U0WGd1SllsZ3BoMnRs?=
 =?utf-8?B?bkEzc3kvR2ptdGxyVU5FZDJiUGxycU5GNXFxNkl1SGhVakkrMkI0NC9lQ1Ft?=
 =?utf-8?B?czdWK0NxN3hvT3FJcVRwMVoxenJaV1FZOHRwVytXUjIyVFRBOVpVdVNQVUxJ?=
 =?utf-8?B?NHhzcG0wUC85YndQdHU2VUlqTlUzbmNxNVdldlUrNmhaR2dLY2kyKytLL0FF?=
 =?utf-8?B?bGtkb0ZaT3Z0WXhBTGhIQ25DNUxmc1p3R0dLbmEwSUNTVkVxd3VyTmJlcXBt?=
 =?utf-8?B?R2duQ2ZCU0Z0Q2lhQzNqOU9GZ0N3UzJLSzA2bWYxbTNLeVp0Y3lrK1hpNENq?=
 =?utf-8?B?Ui94RmZaWk95ZHFyMm4zcGtUTytLdVVLNE0vc0tlWTZqN0dUd1B6MDNLQkNu?=
 =?utf-8?B?ckFLOStrOW9EMThtc3FpVElDYXJrLzZvQXJXTU9OTUt6bWppR3RiQkJtUjFD?=
 =?utf-8?B?QTl6OENEQ3BzRkh1N1BDbnpaN0FVRFZBTWhkeEIyZkx1RXgvcmxNeGF6SVpP?=
 =?utf-8?B?NHlLVEpUWklZM0h3Y1ltN1dQL3pPcDdKWG00TjZ5Z3J4bmpCeFdDQXlWVUxq?=
 =?utf-8?B?LzFPeHY2OUlON0QxZ3ZTME1JTWZzOWFuVS83UnRxNzg4dHNJbGRKdHQwN21K?=
 =?utf-8?B?UjhUMXUySWFXaDlPL2NON3NLajFrcDZCb1d3OWZqalFqUXF5eHB6T2ZoMC9X?=
 =?utf-8?B?UkE2VkdxbkxJUDNCTUxmM1J2RHFsTkpHTldmUVJvL1hWUFhtbkllOW0vQ0xz?=
 =?utf-8?B?RmtDVkc0VmE3VFA5OG4zV0l5NWFLSzJDTTQvcWRicGxoL212NzYyaUthMkRT?=
 =?utf-8?B?d2lNSnZTUW1mUFZ4ZkZJeTllaVYvMENTMlpVYU1Bd3IvVEF4Vm9rMmhSR0FH?=
 =?utf-8?B?NlFlR0VWLzIyRDQ5Z2RaSis0Y0RzSXJWS05EVUFvYTRFSFM2VTRYWnd1THc0?=
 =?utf-8?B?YUl6em9yYk5MZ0c2UDFobjRvMHdBUEZIVEZOR1A5SGh4M1RwTHZGQW5XL3px?=
 =?utf-8?B?d2lib2hnVmlndU0zOXUyNFlqMDZ4SFJURWtESFlNTVN1SXhWVm9aNiswY3Vm?=
 =?utf-8?B?b1V4UThzaS81dzl0aUpvL28wenRyalhueng0OWREUnZYemlRekZ5V3dUYTdo?=
 =?utf-8?B?NElEZ051eTQ1NlNzV0hwUnUydWJkQzd1OG1JdDdYUXhjaGZOQzlUY1IvSFpS?=
 =?utf-8?B?ZHF2UGY2ek1IWHVoaldrNldMWkVxc3VLZktOZHFHVGc3elluNCs4UE9TOWhQ?=
 =?utf-8?B?S2hwaHRQRllyblRJNVI3YlNmMFBlZ2FtYUErZi92OHRDb0t2WnJKUW52R1RZ?=
 =?utf-8?B?bGQ0VGtOSTU0MlZYYUx3YjM0T1VxaTBxOGJvejRXWHArMVlrOHljNTdZakNT?=
 =?utf-8?B?L1psZnFlalJkS0c1SXhkOC9odDJnaDZJY0VCTnRjRTZiY2lCN1NPU3FkQXhv?=
 =?utf-8?B?V2dkY0JlSmZGN3FaSzVkYVF3RE0rdlJ0b2c5VXVHano4QnpjRDAvZ3hUUHMv?=
 =?utf-8?B?dHdxb0YyZFNHaE83TFlzUStGNXAzTVFPMCtvb0J6ZmRiTG5YNGxtRGk1akdz?=
 =?utf-8?B?MUlNQmlPV3BGd0tBTEpYT0dqMXpZcWFodmFKcUlIOUI1S21qWUM2QkYzb2Vq?=
 =?utf-8?B?S3hobXYrT2xQcWRUa2szc29hMTRZaHBIc1poWWYxeW55MEpDazhqZlZaTWNv?=
 =?utf-8?B?NkJwQS8vSXZiY1BMSVpvR0d3SWFKYUZMRkkrTzhCRDlhQlgvV2kyNElJemZE?=
 =?utf-8?B?aVY0WmJnR1dmYVJHZHhtcWVId3VLTmgvRHc3RXRmRklwdERCUnNPSllnU1Nt?=
 =?utf-8?B?QVhjRWJGcy9vNmpJZ2s1K3djUVpiWkU1TFF5cGpaOXBXeWVaM0ZaM3A1dDJM?=
 =?utf-8?B?UU82aWNuS1NtdmVJanovMTJ4MVQyOW9SMjZMMTFYeEtqSGFZM1hMYXg5K0FB?=
 =?utf-8?B?OTdlQ1lGZUJLTHdMZENPV1ZvWFRKUEUxUS9kaEh0OFBTbHlMZTExMDJHeUhF?=
 =?utf-8?B?NXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5AFp/wS6kNU1Mv0f2SghRrmsH6VVgVYpMjiC1JPbFpsoIhBtGQbAu3WbjsHEpBzaQSwce3NlUAThUO3RkUU9rThzYIYcXhIxQ5D7LroWLwZX0Jeb7mByp5L2C9XoEfJPPHtvb9+FLvGlhz6a7nGl5pE+tZ/wmQwUJHOil7lU5wJQAlszXV8a8lytnKg6JnOEvuyQCZivULwuCYTwmfysCXGb5Fr0ZQWvxoAhaqrqaUDCMJkFtz7dZ5S9WyJsyFWkYS6YOnwTSkMIfEvTtemATMWfP5OsGBSYemvbdiRAU9+U7+2nHjI89V+zGER9YFiobztSrlQhOLqdyh2DrF/UduidfJSF8sYFZwBCy1bo6XyHEKtQAu442TJoQvKvV3Tsh+VCtpudxbd/MDu0r5QOlsHOLXul239JuBsNyR2JJIr2REgDtoE/qeTDcNmVzg4CCGhBZOZc35e0Tz6YJgmkCKedERJ4VcrLN1eA/BjbK7rsTlUEmhB7tpqgRaO6WQsn1gCVpVTTZ6pnWGTQ0LwBZdUIFT/HYHMn32zm+XhOq8TjHRlb5/WEOqv8VzXJIfTYsVQ09cLwztt7FIgXRWa7fPG0qFg8mRn9nFz85JggJQE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 405d817c-1468-452b-41c3-08ddace3a179
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 14:39:42.5046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PcMlNJ4/3LO96sgPKjia2XdBFZroJdwGXUErRc6YyRVm9NSROJpLnz1ejYaA2a7CU8jNoKDX/HJBG8AIAP5buS7hVx8Hl85o/T2WLu9K30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5670
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_06,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506160091
X-Authority-Analysis: v=2.4 cv=XeSJzJ55 c=1 sm=1 tr=0 ts=68502cb3 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=yPCof4ZbAAAA:8 a=3t4M_GOpBDnhUjV-VHAA:9 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22 a=FdTzh2GWekK77mhwV6Dw:22 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: WRi7USR21XBnrVWsUAOX61IX0TepVvCQ
X-Proofpoint-GUID: WRi7USR21XBnrVWsUAOX61IX0TepVvCQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDA5MiBTYWx0ZWRfX12kGYexGYPwH vDQJvYt8KIsyZlMCdQKifmUBaW8edbGpEVUYVYPpBq89noivzo4TPJhb8foA8uGonb9z1gmy3Di pMVaxY10vBQtYQH81Enzey7i96P2bIxXloq3IOhv93pH9CGyt+0qb6pcaz4ijgPgxABkpiNTMiB
 ZHkpNcfON4pjLGUfhxHU4J/iMLX3Q4pwN4M8L7JUdeUgq3u9TsHJxDfDYqG6Hga1jEJhJqDn/y9 h+aV2mz97i4p7Kd78P5CYRSTlmuXJiM1mVnE5NNJ2F1FNuf73kN+HhZiAHo8GEVbEb/eqBDOUDb Cm3QSiZZYlC3sLit+8MWFMGQOH5/XfX6IApcbNFeLtg0ZI3g9jU8SRrGFD51b5ZIuKWDpHgLRht
 gmwTdo0gtylVMoBTaVFdZTEJs+tkpeIxcjeyRGm/noPulA6MhwJMdHGEFsB31nUlz9qUqnHf

 > The reproducer uses FAULT_INJECTION to make memory allocation fail, which
 > causes __filemap_get_folio() to fail, when initializing w_folios[i] in
 > ocfs2_grab_folios_for_write(), it only returns an error code and the 
value
 > of w_folios[i] is the error code, which causes 
ocfs2_unlock_and_free_folios()
 > to recycle the invalid w_folios[i] when releasing folios.
 >
 > Reported-by: syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com
 > Closes: https://syzkaller.appspot.com/bug?extid=c2ea94ae47cd7e3881ec
 > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
 > ---
 >  fs/ocfs2/aops.c | 1 +
 >  1 file changed, 1 insertion(+)
 >
 > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
 > index 40b6bce12951..89aadc6cdd87 100644
 > --- a/fs/ocfs2/aops.c
 > +++ b/fs/ocfs2/aops.c
 > @@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(struct 
address_space *mapping,
 >  			if (IS_ERR(wc->w_folios[i])) {
 >  				ret = PTR_ERR(wc->w_folios[i]);
 >  				mlog_errno(ret);
 > +				wc->w_folios[i] = NULL;
 >  				goto out;
 >  			}
 >  		}
 > --
 > 2.43.0

sorry for the cut and paste reply. My email system rejected and bounced 
the original email.

ACKed-by: Mark Tinguely <mark.tinguely@oracle.com>
