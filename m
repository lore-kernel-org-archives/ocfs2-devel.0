Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB08227E82
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Aug 2025 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756134822; cv=fail; b=C2qhvBR5/8HlPpnlsvxMawKuMK9Zy571ohM0poXz6FJKWgE8RZJeUfJQfUsdF1dbEExKqVNOjoXW2WLtmNDkr18pzK7iYyOncmlAxhwXqnhgyaS3WUoy1TIKr6XflL9BLYBUT0qBTUengjak8nk3nXYsBxhn+OY3wxMZ3TIuCHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756134822; c=relaxed/simple;
	bh=bxQlZ4es5dsT/Zy0CiwCW2aQenGcDNamaz2wOlj+Rnk=;
	h=Message-ID:Date:Subject:References:To:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZZidWMTlyOric+GTOuPZABJ0mdtSeXexidLPxfR9PlZem53SLqFVrA3CrflDdPv6Uv7CXSFvh6CZGo86VjoIAatf+4zt9UMgROPC+1w1kVm9X2XS+0o8aZbDHlLDjt6+Gpw8m6l6j04npaPm7RzcJw5LpG1YlVqUZNEHj4XKapY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=obHsOipf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bHfB25YP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="obHsOipf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bHfB25YP"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PE1cUd032057;
	Mon, 25 Aug 2025 15:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3v+g34MhUxo30iHIA/obJMFrtPBhiczezd1rAIBLE40=; b=
	obHsOipfVerzZckHUsLBDEs9GoFS743MNRgGtPix75TGgBrwiASe5chQKfV5DuWI
	i9jkqkraNf3zqJ66KIYVW2gMIVy9afZXlK/bxHrc9sShWOVk2A99xCJ6EekYCDn9
	wxhBmuNimiFrajnH1Bfj9LzVyfaqMH+yq1Knx7jdibYgJlh9wTndFOeDIB9OTm3i
	445zLaUu3PrwoOopr6g2DRqXvxyEe23IGOtHD8Dw1HsDqPOOi6pUbCil/twHj3TC
	R1mY2pJ5La4avYHB261B6IbFE+ZsQRrgn3UEsTDgWFBHDlwbZdGpH/5vuioGYiLf
	m21tiaS2H9Bh+4iekHqevA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58s2gad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 15:13:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57PE5TLx014567;
	Mon, 25 Aug 2025 15:13:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q438b26n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 15:13:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ITEAh5r8kGqSt2X8AfzWpiqR457UqXMC7BZKgcYDuqXZBoyVp5QGXYNMPK0t232ql9ZH9ATMIy6VMw7aGfjPqbSr2eGI7btoRHFgKtqiS370h5bS68Z/X0Giv1MCPCOCPQbdBQMNiZKZwAvJ9KjZtLeZi0cUUDlwewbo3PBKYoeM7OpKexOuqP7QtZ5HkKEE5qPyy1thz0uuvudolRLwsQPG2nre5NjeGiZmrFZ5eJDa97eZ3QgQl2I7krNyaX6sh3ALDTLNykZlhSWpRTSfL16ueXzcjg3ERAIQctfvVA+DFF8fibV4ZBhIaDciy+Watpz5XlWrmROG5xyxFwFEug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3v+g34MhUxo30iHIA/obJMFrtPBhiczezd1rAIBLE40=;
 b=ZOUITAzGbfBWWQuTHSY5yJlq5h+1TdgGmVtiE+C8A/tP1I3Wa5Iw5/OKldyZDtVwXuWdqWoMgyEhsLwaw7AH0a5owLqPBn4nOmVu+GD2P1b84vi8Rwhp09ehGN/ryK9ZT79hlKoz5GcNzlmzjxjSwV8fyDI3JjJJy22QyREh8oxWcCHVubP9BGNpL5A5SHXdkSN8XBHxXIKCgOMSAAtBdc16wgEegwig7JHWLx7+F/nY5uxegYT+3Vpaht3piqaCGkevbeNRPkc7GdUZkXjzFjTuLdht1kZhTfsFA1pECM0woLuntMj11jqPFpUTnt0r8rL4yvuMdOZcbAuY6W/YLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3v+g34MhUxo30iHIA/obJMFrtPBhiczezd1rAIBLE40=;
 b=bHfB25YPOtYmEafdglO545EoJlSoUHc7Az4Z25uXxgldZJ8S0/iuqp51+gkcBAvR3aYi0UR0gkZILlnVbsARLXqduAMbcilp0DSiitLOxbl62um2ZxZN2Fm0i52YHOeIAKvF5xVPO1ZKv/sbazczNmb4kNR9aWoQ4lDDH5c9Cj0=
Received: from DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) by
 CH3PR10MB7305.namprd10.prod.outlook.com (2603:10b6:610:12e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Mon, 25 Aug 2025 15:13:24 +0000
Received: from DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036]) by DM4PR10MB7476.namprd10.prod.outlook.com
 ([fe80::f32a:f82b:f6ac:e036%7]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 15:13:24 +0000
Message-ID: <d05b1d06-3b03-45b3-aa5f-97b5e8366c5e@oracle.com>
Date: Mon, 25 Aug 2025 10:13:21 -0500
User-Agent: Mozilla Thunderbird
Subject: PATCH] ocfs2: fix recursive semaphore deadlock in fiemap call
References: <20250825145825.3596-1-mark.tinguely@oracle.com>
Content-Language: en-US
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
        Mark Fasheh <mark@fasheh.com>,
        "syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com"
 <syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com>
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20250825145825.3596-1-mark.tinguely@oracle.com>
X-Forwarded-Message-Id: <20250825145825.3596-1-mark.tinguely@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:510:5::22) To DM4PR10MB7476.namprd10.prod.outlook.com
 (2603:10b6:8:17d::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7476:EE_|CH3PR10MB7305:EE_
X-MS-Office365-Filtering-Correlation-Id: ec424e94-59be-4593-3b3b-08dde3e9ef8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzBlck1qcHNHbHZiRkZrdzVseXBycEpyTGJ3bDF5dnZidzBHZm40MWhEV3R4?=
 =?utf-8?B?dXludytCeGo0ZTh4Nk9YSTdxYmxUdEt4WjNuV0xwTjdMWmNzT3BBMHB6am4r?=
 =?utf-8?B?ZlBtVEltTjVLOU94V0VxSFVrQy9xblM5Y1BwUFZ2bDdkUDYyTU5Kem14d0l4?=
 =?utf-8?B?SVZIVmNLVkg2MW1IdjNWcnJSQkpsM2NxbWNoOWRHV1dLYmp4dU9PQ05SNlU0?=
 =?utf-8?B?Mi9ub2c0SWlTRlBWM3REbG9LaStRWElsSTgvUGpHVERldWlhdEticVhLd2lk?=
 =?utf-8?B?UXVFdFVOZVorYXNGRDR1d2dhTXJzc0dkdm1RdXhzeHVOOXI5YWZ0Wk9EU1ll?=
 =?utf-8?B?MytPL3JVRkRQeTV5Qm82RXMxS3dScHVzWS90Yk1FaTVBWHFPWDRqSUxCYWk4?=
 =?utf-8?B?bFA1dC9vb1FFM09adGFQUHkvUWs3aWovU0RsTWt5UW1taW96TGdGZzhGa1pl?=
 =?utf-8?B?ZnFMUEtvemE1OTdhQW9Sc1hDT1J4NlY4ZkdjSGhmT00rK0tWdmgvSWtySnJu?=
 =?utf-8?B?dmRqWDMrQ3JRRnNYczFVM1E0eFp5R1Ywd1ZETnFZYm1zZW9za2ZKb1VMQm1W?=
 =?utf-8?B?ZG5sTC9BSFdQdmVCcnRBcHFDTit2NWpXMmZDN1FkclFGcXpibTZ2STFvMXE5?=
 =?utf-8?B?cUVOQ0pJTGRwWERrUlNkdlpJeGdIc1Y0YVRsTmFQK081blRWM0xHZW55NHZu?=
 =?utf-8?B?c1l3a3RzUGs2S0ZkdjhRMzdMT2NJUUhJTjJYaVZWZEpYbXlHbjhNOTRvWDA5?=
 =?utf-8?B?RTZ6L0VHbDdZMUxQc1F5N1haT1laaHJ6cFE1elk1NHB0UTJBQXJBVTFwWnd3?=
 =?utf-8?B?Y09CK0wxdWdmNENiMVU0NUhqNUVwTVhUUFNjZlBtc2lxaUtEN2RUeFlsMmFz?=
 =?utf-8?B?WnlrcWprTncrMjVWY2VZWVg4bGQ2WnllaDF0eUZBOFFwMU1RVWh1bUJvRzQy?=
 =?utf-8?B?MTYrQ0luQTlEbnRqYnZ2ZllxVTJmSzNiMzgvUklxcllhZk5GNHVYMXhMODV0?=
 =?utf-8?B?cjJRU1EwRkZIRWNKemxwaVlPdDRkTFk2Y05yS2ppWFlrb3krMFVjV3NGb3dn?=
 =?utf-8?B?MHJtRXdqVnBWSEQ0L2hXcnlzMWJwcnB0OTI4WG9EUngxWW1nY2dpMUYyZDY5?=
 =?utf-8?B?Y0hScXdwSHMzQkdNMTEvU1hpZEZRc2gxeXRua2lpeTEyeTE2Z29lZ2F3cTUr?=
 =?utf-8?B?V2IvWUJlYWxrTzFBdjNJckFqSWNXUjdJaVQvL1JvYnRoZTVFVkgxaHdFQkVt?=
 =?utf-8?B?YmIyMEdHL0tTOWJZb0h5UXo3Vk1UMFdkcXhCbENYd2JQc3Uxbmc2VkdBeVBZ?=
 =?utf-8?B?OVZLMWQ3MUQwZUplY3FmS01xbTc4SStjUzhudWNXRHVyZlkwdTlNeFFyZ1Bk?=
 =?utf-8?B?VU95MmcrUkFZLzJUS1Y3VE8xb3lTK2lWU0NPQU0xSE1jSm1MK00yellDRW8w?=
 =?utf-8?B?MnJwRFBTRVBDYytITDVMS1VuTkJTQXk0SnlDUzY2dmdPT0FXK25wZjZQV1pY?=
 =?utf-8?B?T2l0cUQ1NDRRQ3ZnbEw3SW1DTEdYTjhzUnlacldraVh5Ym5wd21ZMm50b29q?=
 =?utf-8?B?MlcwV2xFL2pUdmpoM0REV01qNHI3S1VwZ1RyUS9WbWM0Q0tXTWEyRWliUUZB?=
 =?utf-8?B?aTROZktyQmlIbTRrTnlzbVNOb3crdCs0S2R5TUhFM0J2U0YySExhWmVZUkYw?=
 =?utf-8?B?N0Vob0kwZ0hhNTIwOW9obVNtNkpVVzlNeFh4RW5la3JPZ1I0bmJxQTFVd1Bw?=
 =?utf-8?B?WnRxSlp3Z2h4dDdsU2V5N05KZ0NBOFNRU3lIUkZZb05SOW5vZHBSZy94ZmNU?=
 =?utf-8?B?K0thSkVySm5kei8xSStWb0VRZG5CUHJxT24xZkF1RTlLU0JDS0hWWlFCNmZr?=
 =?utf-8?B?ZW9OUTlHT0RnTmNacFk0Z2pYRnQwOWIrNDBGTDBSR0JIK0lhMHMwVkhvbkdn?=
 =?utf-8?Q?s+G9svr1w/4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7476.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dThiek5tTndiNFVSNWgwUUh6bUd1K1Z3a2pUWEplZ0tlazZiTEJucFpBUUlw?=
 =?utf-8?B?RG0zb09SZkVESERxQUx3RE1XRXlxOS9TRUovd2xndElycHNFdjA2RW11UGdN?=
 =?utf-8?B?VjBRSnZQak0xY3pjellSWnYxWHpwU0JaU1MvWmVobUZRUG1PbVF0MXpSVGRw?=
 =?utf-8?B?S0wySHlUd3N2U0U3eGZvbk56cnNnQ3pqNTVlQVpSN01aRG1HYW9EVXJPYVEr?=
 =?utf-8?B?Z3NWbXJyakJNT3R1dSs1bmRGZmhnSEpYYjFnWVpJRk51TlRRbE9yWXlYWU12?=
 =?utf-8?B?NTYvQU1iMFhxekVhS2d1ZFU3Z25QTzFvNzBrYTM3TlBJWEU3R2xNNFRNS1N6?=
 =?utf-8?B?ZDZPMXdhVXRaenBFaloySkxXSTdUdU5nYTFhMktHcklOeHF1NDh4TnUwdXUv?=
 =?utf-8?B?YVBXeFdLVVhJU1A3cHVqaXVYS1ZrKzJyRlJueTFGLzlTaThvVUJ6dXVhTndl?=
 =?utf-8?B?aUJYV0hnUlM0Yy9pSC9jM3dNbWRmbEdZeTBZVit3RlRaUTgxakZvQUF0ajBF?=
 =?utf-8?B?MC92MGIvQjJNOU1IS0NIVVdHd2RrOG1rS1QyNDF3ZEdtZ1NOYVBLZ0pCVFZP?=
 =?utf-8?B?R2wwYTBLMXZnbkJXeUVtRDlqR0lQMUlvTmlzUm9LVzltZkU0NkdweFYzQzV3?=
 =?utf-8?B?REhKbmVzQmRmZmQzemFoSFdEYTFJZ09nUVMwa2N6MkNQNzBhaVlFcjRRSXlk?=
 =?utf-8?B?OWI5Y3RaN1YyaU9YcUZHVG5nV3pmVmtKT0FVYndrQjJwK0lUT1FFZnJjaW82?=
 =?utf-8?B?c2JsQ3pDMmtIbjJFYWVFaVVoSnllQStabGdYUXpibkhWRWl4TlVmOGhOcE5h?=
 =?utf-8?B?RDVjUnVaVVduUFBSWmMrTEsxWnZIcjVCdTB4MnJtUnJNREtNQVJFaFc2MVVU?=
 =?utf-8?B?WGhGNEk1N1dyMmprcTQvOXJHeElOS0czSU1LVWs1RDJrQ0MyYkFkRHRlaWxF?=
 =?utf-8?B?anM2L1RnNTMxQzFhdVRiRFhEZ2o0cWtmK1dDQTg5T2RRSU5DTnQ3cHViRVpa?=
 =?utf-8?B?SWNBQkhvVzVSbHczZEJGNlBuS2Z5WXpRZVpIaFEzK01BUzVzelRTRTdUWVZ4?=
 =?utf-8?B?SjVNN2RLVHRVMDBBSCsxT0VJZ0hmNnU4WXdKU28rVXAvZGl4dDJUVS9EZlBB?=
 =?utf-8?B?RktISDUwYzQ4d0xwb25HRDRab3dIQzlyOStpUFRMaW1wVFBpYVZLQkNUdmJt?=
 =?utf-8?B?WlF1S1IxN1IwMXArcHFWT0tGNHZvTVlhaFlKSVhNUWV1cEc4K2xaSEV3VG5W?=
 =?utf-8?B?TmZMaHlQeGFwbUZRN0o5aVNuTlU3T3NrSFBabmxoY2pYbWF3N3JhSGY1MFpz?=
 =?utf-8?B?NDhUVTFjdk83emZad2tXQ3lpbjdMeElxY0NWalpGZGFxb0pQL1g4dWFWNW5B?=
 =?utf-8?B?WXZXNE5jckV1V3FVVk50Qk96OXBDMU9hSzgxbE1HakRrSmcxZHczVSt1dVB3?=
 =?utf-8?B?MDNwWVRVWk9YV3kvY1B6NTBDbU9hbDZmaXAzUXJFNlB3cDBOay9jQlRVTzJK?=
 =?utf-8?B?TmRjaHpPTWp2Z2xMa0dKdmpFdkY3MVZBTUdZRk50NDJBRzdzL3NJNDRTRVM3?=
 =?utf-8?B?blp3VEZYVzhkdFkzZndObCs2WjBlK2d3SkpWTUozZElIckhpM3E0a3hQOEhP?=
 =?utf-8?B?emRHSUhBTEs1eEE4cFJVYms5YmQ1Y2M5UytSUmNtWDRqU09ZL3dtSzQyN1FV?=
 =?utf-8?B?dTZkRTQ5M0o4SUY2WVVaOFhjaFBUa1NkbG8yVVVmb2tXQi9QblFSblIwYnlX?=
 =?utf-8?B?YkdrTm1neEowbk5mV2xMcEl1L1hvQ0tVTE9JZFhESjdIWFlHckMxN2xIaVR3?=
 =?utf-8?B?UXNDOHJvV28veFoxRDUwMlFNajZlVlVFS1Y0NEJlMmtIMStuSTlsajd0MWpo?=
 =?utf-8?B?UGJuK1p3L1NhdGlLUnMwL0ZxSGxxbXUxb0RjREczcVV3NkRRVndKeEdQNGo5?=
 =?utf-8?B?QUhyTlRXL0dpaEFLMExSYkROWDRhYjZmVUhnZUlFSjhTcmpxQXB4UEZhMTZo?=
 =?utf-8?B?ZklBeW10b0NuaXpOVVhiaVc5VUxDUmdRbnpzMURIT3lQY1NlbXFjaHdXRFZJ?=
 =?utf-8?B?QTRHNjJQcXZYdkRlaVFsSmx5S1NvNFNnRmYrN3lqOVVmS1dSMGlmQ01ZTmxs?=
 =?utf-8?B?azJxWmNRY0Vkak9nKzNzaDNEVHVCdUtDZkljS3dmc2lGam5PazlFNXVnRDN3?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G7gefFld8RsVgb/LSZSf+EmKkTMiDjEaX0y3ogPXnAeBymGfIyoDzlwMh2KNvUACQu09WwJGPjOpnW5MEp1pxWikzLPftWKFni5c0oCzZBlQLHeTmb6NuxhWmUXMGNILl+NrY0HlkcqJc4cbiosZnpSByz6zA7M/j/Y84tvzbuqHdX8HWpL+bMEL+tm7/L8eWLrFLsJbkLcjOm40d3/wlXXTVr4XgP4KXT5E1p66G5Qo/dnfhRoUCt2NiykYonVfOKXypyLAFZX2QHKCYJoOClCwXlRKvrD02NN4aPmhQo14KwPM5Ojozztb1zqqq9ebzzcVRZecpiZ/SUttkqoRmhzbg8dUUX0sLea87/YMdlTBPeAMb2/4RqGTNl9STGOwuIsqUz8RgoHuSNiPrtwHJnxCVo0YPlzxznj82AS1B7t+tw8+a+SW3YXVg8aZGV2iHDgnKxjScxBdwbwbJ6ZjrceAwLXih4Rqf9GgB3dTmSqT8c7S239P9bPKLDkB5LN27iPXoIV5hf78WF3nFe+WgoCNuzlOsqbkNFDZZH5c9NoqCbvDcfH05/RvdbZfykCwocMAyQJ849LLqLZM2EHDRxsci8TgVF4J5aIm/ghh2UU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec424e94-59be-4593-3b3b-08dde3e9ef8c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7476.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 15:13:24.4070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZjkryUEaEwyObYc+xNgHXftj95qez6K2cF5ScykG2YpbZV2mEBv/ZmTlCZvU/VBco8JTivrCzK0ZIdpIizOXsDnZHHMishnEtZN2E/MuEVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_07,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508250138
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68ac7da1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=hSkVLCK3AAAA:8 a=yPCof4ZbAAAA:8
 a=vBr5IGRyJBBAEpwekxkA:9 a=QEXdDO2ut3YA:10 a=cQPPKAXgyycSBL8etih5:22 cc=ntf
 awl=host:13600
X-Proofpoint-GUID: O7DepDB6PHrd4jlISLhWSOEo_rS-87A4
X-Proofpoint-ORIG-GUID: O7DepDB6PHrd4jlISLhWSOEo_rS-87A4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfX+O5dsYxmuxOb
 GT3IAlECB6mkOFuM6q9Q9OCcY6h0mFC+hXS5zPL1Gf0zj/6A1g4qLEFWKZuJBGArAW3mH/3omYd
 Nk1+s4iJZMsBwGAhS+sY3/HjPYX4Jp3CfX1SjZYm8a2RMjdMCJB8rpA7/s9WswmK5+HN5XZ51LP
 T9n5WRocr0qPufqyIAsa2JzKidwAZKuujFgFO64xyZMao4+oo7izfT+5U2NUAdetDEiRbXtF62f
 1/7ccYayw+dQI1YE0Ev0V93hCD8l+gnMIbHuB+pOC/Zk2kDu4TcDrGLeGRXkQ43QZnh92qlx3zi
 VNiSMNI6CFTdL/tvdWM0wYZl/jYpevnwMzsoO6VqrEvbu0qgK9Pzdl26ShxULGK1oXBbkdcEffn
 bBLKF0nrOSGKWeKqtyWDGY8J/xkYZA==


syzbot detected a OCFS2 hang due to a recursive semaphore on a
FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.

context_switch kernel/sched/core.c:5357 [inline]
  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
  __schedule_loop kernel/sched/core.c:7043 [inline]
  schedule+0x165/0x360 kernel/sched/core.c:7058
  schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
  rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
  __down_write_common kernel/locking/rwsem.c:1317 [inline]
  __down_write kernel/locking/rwsem.c:1326 [inline]
  down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
  ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
  do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
  wp_page_shared mm/memory.c:3762 [inline]
  do_wp_page+0x268d/0x5800 mm/memory.c:3981
  handle_pte_fault mm/memory.c:6068 [inline]
  __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
  handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
  do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
  exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
RIP: 0010:raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
RIP: 0010:_inline_copy_to_user include/linux/uaccess.h:197 [inline]
RIP: 0010:_copy_to_user+0x85/0xb0 lib/usercopy.c:26
Code: e8 00 bc f7 fc 4d 39 fc 72 3d 4d 39 ec 77 38 e8 91 b9 f7 fc 4c 89 
f7 89 de e8 47 25 5b fd 0f 01 cb 4c 89 ff 48 89 d9 4c 89 f6 <f3> a4 0f 
1f 00 48 89 cb 0f 01 ca 48 89 d8 5b 41 5c 41 5d 41 5e 41
RSP: 0018:ffffc9000403f950 EFLAGS: 00050256
RAX: ffffffff84c7f101 RBX: 0000000000000038 RCX: 0000000000000038
RDX: 0000000000000000 RSI: ffffc9000403f9e0 RDI: 0000200000000060
RBP: ffffc9000403fa90 R08: ffffc9000403fa17 R09: 1ffff92000807f42
R10: dffffc0000000000 R11: fffff52000807f43 R12: 0000200000000098
R13: 00007ffffffff000 R14: ffffc9000403f9e0 R15: 0000200000000060
  copy_to_user include/linux/uaccess.h:225 [inline]
  fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
  ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
  ioctl_fiemap fs/ioctl.c:220 [inline]
  do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
  __do_sys_ioctl fs/ioctl.c:596 [inline]
  __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5f13850fd9
RSP: 002b:00007ffe3b3518b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f5f13850fd9
RDX: 0000200000000040 RSI: 00000000c020660b RDI: 0000000000000004
RBP: 6165627472616568 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe3b3518f0
R13: 00007ffe3b351b18 R14: 431bde82d7b634db R15: 00007f5f1389a03b

ocfs2_fiemap() takes read lock of the ip_alloc_sem semaphore (since
v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
to read the extent list of this running mmap executable.
The user supplied buffer to hold the fiemap information page faults
calling ocfs2_page_mkwrite() which will take a write lock (since
v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
semaphore will hold filesystem locks and causes a hang of the
fileystem.

The ip_alloc_sem protects the inode extent list and size.
I read semphore could be use in ocfs2_page_mkwrite() and
prevent the recursive lock.

Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
---
  fs/ocfs2/mmap.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 50e2faf64c19..78513109b9b1 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -139,11 +139,11 @@ static vm_fault_t ocfs2_page_mkwrite(struct 
vm_fault *vmf)
  	 * ocfs2_truncate_file() changing i_size as well as any thread
  	 * modifying the inode btree.
  	 */
-	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
   	ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, folio);
-	up_write(&OCFS2_I(inode)->ip_alloc_sem);
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
   	brelse(di_bh);
  	ocfs2_inode_unlock(inode, 1);
-- 
2.39.5 (Apple Git-154)

