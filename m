Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40E810FF;
	Thu, 12 Sep 2024 06:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726123831; cv=fail; b=tW5IZAbCqmEIToOphS54hp3K72i3ik+vKJwhIFYMcdo5XSy30tHqEIJXld24CcwxbG5So596CEjvqPtase4ohb68ExAY6RHPAhAlK1umPbQ8LjIDJPmNTFBW02zH/g1UwwoRWbcasND+t54yzKg7/zAo6ToFDI6bW57wwCHVirU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726123831; c=relaxed/simple;
	bh=nIPiT2hbT+qvcuyX9Bx0/+7H6C3ubB+g5rOuBePQkVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TaOT5ed2wiiAUTbTo1uI/uAC76O1za+vm/BIJBJFMju2fLmBrRngeEhW23gNGqT/6zp9oKMI4Wanm6LZQp8OJ5tlhau1Jp4snmWGJhn46p2a4Z/GlWYpTm5rItUst4DnTjHi8AUxluoXRqnWDWxKLwXiouxxAEGUZM3Ovrib7b4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lra/YEfw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rycwJWvV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lra/YEfw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rycwJWvV"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BMfiZj027381;
	Thu, 12 Sep 2024 06:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=nIPiT2hbT+qvcuyX9Bx0/+7H6C3ubB+g5rOuBePQkVQ=; b=
	lra/YEfw8129MwYVprrjIY30ALS69Ozgjlnum835uhdeFYaHMYDqqFUU+T11tbcN
	cQ8BXSSqRvBPXgPuhv8NdCLEp3rPRrBFQa/B+XOmpVkdn1dG+M1LG7dctDNEn5sV
	ynyxocEJMAZ0sr5E0rq/vqcdO5inLTcZa15c2K9Hx5ehXWKthK3rVHguGyi534gC
	s7JhMkgflmcuiEt4Fwos2wshz30JwFin2p581KNhj5Hhg40psBimSlI1vfoyPaUH
	OzdFaqSj4o0rLfOx9qPVnpLZa1eCFq84uFafm2qrFQR2z/oX4q4+ZZLpytRKYS9D
	UlcIEFS6ptXpo7bd+ock6A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdrb9xp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 06:50:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48C50sZX040800;
	Thu, 12 Sep 2024 06:50:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9cfxrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 06:50:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cv6azHx3fzKdkdxYg7w0vUG5xviGUhMgev27kMktPTxSbwDviKN+BVQAoOhDjg7vj52/66zRBRLSq3iE9Hv1YfB2WpKBBf+FZNfh0tqq+elgTe2m9HqqW/qiv9gxwwJNIMUFxWDOEUwcDNM37uBgt8CRdfHTI3bflkQ88s888dHhOSAgNsoUETX26K7rqtA21moc+ou+feNyMmA9IrXH0+aXFZa5UJ6ZZyUAsdVGGXDCEaKwgpVBLKvZpT2UJdjjtU5b/+e3rbhtYpE1v4zijC9ScCR0wySovQ6WfZkdbkW/PnNTJWwmkjCWSDGuxYJ5dTzB91o5BpnRKS5tmjEwWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIPiT2hbT+qvcuyX9Bx0/+7H6C3ubB+g5rOuBePQkVQ=;
 b=TUTM1QTpnJSEJ0bG4R+L5d4vc5vn0QrjJ16ofEEi/pIU6Iqy+3kH4lHgLK6VPjT5sNbArx05YHwvM/Qm3t9vxxm5VLVB1rWmyMa7NGTsNp6Dp3lJ+1VbHKvYiNfexaytUL8OIMXMytxcStAWB63a119iDb/pcjfz2nDGcBkbEsM4wuZIwpITFUdVJaglhiLK1L7gNomPzDRGwTJ8xVIWxKTT2tKstyc+nopcSeZajpBUdxyXJGlgD9hcoguU3T9oXF7i7WQ0T3ECY8sqy+2Afrnhbr+t6hyrJH6LyDw1D+qncrwNG2X2H7EJnApwdL+kUO1YO7SH8rYPAZboNZRJ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIPiT2hbT+qvcuyX9Bx0/+7H6C3ubB+g5rOuBePQkVQ=;
 b=rycwJWvVtAUJhG1KKBRJgGnZbluHZFVgW/vaImcMXWoFmhPIZXeiBIW/8kszPC9Ret00mf7rG8umj36zLIrYcfgxJGjucCFVq+FR9g5hwl84J6zPVjGUbyrWYcSFlyXbyIUcQD6epk3JTx0GRZYRr2EgqmxjezKLR/eDEciEgak=
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
 CH3PR10MB7259.namprd10.prod.outlook.com (2603:10b6:610:12a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 06:50:19 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0]) by DS7PR10MB4878.namprd10.prod.outlook.com
 ([fe80::e07b:fe59:d2d0:59f0%6]) with mapi id 15.20.7962.016; Thu, 12 Sep 2024
 06:50:19 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, akpm <akpm@linux-foundation.org>
CC: Junxiao Bi <junxiao.bi@oracle.com>,
        Rajesh Sivaramasubramaniom
	<rajesh.sivaramasubramaniom@oracle.com>,
        "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC V3 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Topic: [PATCH RFC V3 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
Thread-Index: AQHbBNGa7BFoHcVCXE+PgkclaolGxbJTpmqAgAAPN9A=
Date: Thu, 12 Sep 2024 06:50:19 +0000
Message-ID:
 <DS7PR10MB4878A3ADA076806BF8A0B845F7642@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <20240912050656.877264-1-gautham.ananthakrishna@oracle.com>
 <c4ac09e2-bb70-4a1f-8c5e-00e11dbb4d0f@linux.alibaba.com>
In-Reply-To: <c4ac09e2-bb70-4a1f-8c5e-00e11dbb4d0f@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4878:EE_|CH3PR10MB7259:EE_
x-ms-office365-filtering-correlation-id: 750f9700-88d0-41e2-268f-08dcd2f72a9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WlcxV1dVMENDUkJLRVhPVURLT0JaZ29pU3Z1R2FQYWZQVElxUHNIZ1ZTOHky?=
 =?utf-8?B?bGNvMTJnSTVVczBEV1lhRnRyQ2VpTTdac3hPNzU3aGh1dmZ6ZEV0aEZwTU9i?=
 =?utf-8?B?T0NpMHR2VDVRQ2RUTkd0TjJiSXZLNGpmYktjTENnQ2hjYjVacDY4OVZwaHRh?=
 =?utf-8?B?ZGhWc2hTeGpqemFlSEFGV3dHSk1jMnBUZXU4WHFDT0x1dEYvS2FGZG11eStB?=
 =?utf-8?B?SE9VMlFYTktVNGlWTDJieTJydFl4UnBQWFJMZTJwdVV6MHpIc2dqTTVpMlJv?=
 =?utf-8?B?Vkx5dUh3N0dla0REcUVnYVlYeHRBL0tSWGRzSlJzZ0dwQ0dIQlNsaUVRVjFh?=
 =?utf-8?B?R0hIYXBXK2xGeE1zalFDZWwyVFJJbXJBbVk2NXdtSFlqdHplenB6QitSN2t5?=
 =?utf-8?B?NHhGQzc4WXZKakZqNTA0ZXJWUllZTFduRUVFeDdMOSsvd0o4dFpxeXEyN3ZR?=
 =?utf-8?B?UExNRHorcEwrMml3RklxZ0MzVVdGTWVnL2pYL2FneklqUUNwalBqWmJQUkJm?=
 =?utf-8?B?QnZZU0thTWNsRjFuTTFhVjE2L3h3VDkvMVZ0UXBhMjVPYmQxb3c5eEVPWVJ4?=
 =?utf-8?B?VXdiTnNza0NicUpmSnF1N0RHYy9ZdTRhaHYzVzBjYXY2bktWbkJqMEdLU1Qx?=
 =?utf-8?B?Q3VDV1VLVGNFRTN1OHNUQXhtRktxS2s5ejlSdXJXYW16aTNCRXZOZHdxRUlx?=
 =?utf-8?B?elR3ZmcvcTd1WUJYajJocWtaT3NNOVFENklXdFZLZDVZN1ZuS1dXbG9WRC8v?=
 =?utf-8?B?VnZmMmZ5Yy9ROVlEWTFYbDU2QVRVZXdUWmJ1eFVlQzVmZW1yRzZZUGkxRTNJ?=
 =?utf-8?B?WVNURnUrOHdwQXpJWE50TFJ1UmNUTkpVUTdSSUk5dG0wT2ZxRFdtdnZIL0Vt?=
 =?utf-8?B?Y1U0WWxSaE1KM1lzWGxpY1lrRzlHajRjVjFoL1pOREE5eTV1eHlheVJwSWhj?=
 =?utf-8?B?b2ZEbmJGMlppaTVmV2tTd3RydWJUNGE2eXo1TCsrYlFPRHFPbjV1aldzSlB1?=
 =?utf-8?B?QU56YUNTUFVOcmV4OFhUUFRvSTk0cFlLQ21ZdGdpN0JLRW9JcGRvcWQ4WkpR?=
 =?utf-8?B?bjJnNG9PS0xERkdrcFpjcjNnYnBoKzBCUG9wTjlteTlFQUpZRyszTC9sbjJ4?=
 =?utf-8?B?YWE0bzVPNmhjVHNpQ3ZZM1hEZlJKT1R1QmpSTE5FeitaMjJRaHJyMXJMM1dw?=
 =?utf-8?B?YkwxSzhyQUQ4RGc4WmZYSGZuSFpoNmlEMXJocXBqcEh4a05hZ01EdE02NWdG?=
 =?utf-8?B?TmE4NFQxVVc0b1VxcGJlV0NjZEhVZ0Z3SXNNa21ZZUdiSjdQZTQ2cnZ5U3V0?=
 =?utf-8?B?VmlJdU5UQlFMQ2o2RmRaaWdBQVRuYnZjazdNZ1pRTFNQQ2YxY3RBN2lhaWhI?=
 =?utf-8?B?V3VZalB2WUFnRkZhMld3czA4d3hkdVBVUlViZjhHQVFWY1Z1RU4rMkNHaWtL?=
 =?utf-8?B?M2MzbHJwSmMwYWp4WWFLRm9JRHNhRlJIN2NROTN4NGxKdlBnOXZYejFtTTBZ?=
 =?utf-8?B?NWl1YzhtMHFTVkZFSGxteXdVYkpYMmx3dUp6M25OZ0lmL1krejgxN0V3Q1hr?=
 =?utf-8?B?d3IyZUt6U3RDYmQwZlZZZVN1OXY2T1NEbnlrR1dsNWFMTUV3eHNKL0phZWNn?=
 =?utf-8?B?Z0pHSGhFZWFFbStPQzdZNFZnWkY5VDlBQnNBQW9hRGx2bFU0aWpJQXJXWktm?=
 =?utf-8?B?eU5PbmRJUjBCeWpvcVh6QXBjc3creXU4c0RLbEJMcW5ZbWp4YTZVdFRXZ2JG?=
 =?utf-8?B?TEVxay9nS28yRjNRbG9GdWpQOHdWSnkvQmtuc0NWYjQ1MXBrZUkvU3RjaUlW?=
 =?utf-8?B?SnhGakhXeUJFUW1XVElEZmt0V3VrRHlkUjF4VXEzMmkyZ21ZVDErZnMrRGR4?=
 =?utf-8?B?d0dBY01xeCs0ZldtVFFvRkJKR1lSbVg2bXBWZjFzQldaZnc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4878.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RTBhbEI5eEk5c1BWc05VUWR0azRPYkJRNWN3VjZreko0SG5IZ3Vud2U1TEdB?=
 =?utf-8?B?czJTZXRFa2R6eGk2b1B4b1U5cDdvY1h1eWQvVzlSWU9yeUR1cHNXK3J5bWpa?=
 =?utf-8?B?a1hyRXpqN3F1VDNTcmxwU2x5blFLSmhCZ2VMVGM0OFZHT0VxUUVjUGZNeDJ0?=
 =?utf-8?B?NjljR2ZLTFFGRWFXVjNvV3pEbFBnT3JEaUxNSVExdEpOZ2VhT1dNQUFURDFr?=
 =?utf-8?B?enh5RFdVMzEyQVFib2tPRFNHRmhtQ2RlRFRpTVloN1NNTGxERWVLZXppWVZR?=
 =?utf-8?B?Z2tlNjdJRHF4VUN2dVFyRGhLaU9LQnY4b25kdXpEbDN2ODBycjUycUE5L00x?=
 =?utf-8?B?SnFKUGUzS0N5U0Y3TE9QSGhzWUlqb0Y3NzZTSzhzczZDUkdxWU9tM21RQ0po?=
 =?utf-8?B?S1BVNkNLSGgyK0pQWThRZ0dhaWlsNzlKOUREdHBiVjM2Y25najE3ams5cFIr?=
 =?utf-8?B?YXdhQjlXWmlIS0FvankxWG5ETVJZMDFOaitCQ09jNVFuNmRrTUNER1A1c2cy?=
 =?utf-8?B?Rm10YTE3dGJUclY3Wk9FM1c5ZDJWQlM0ekpwWkIvWXVDZEhYVDRBTjFGKzl0?=
 =?utf-8?B?dVFyN2tnS1JoYjcrRStQSDVVTk5yeWF3a2dxQzZGQjJOOTU5RXU4VXVJT01S?=
 =?utf-8?B?dWpjQ3NHQmF3c0RhWHk3RVJ6VzgyTERXRVh6T09ZOUUvekgrYWloWVluR3la?=
 =?utf-8?B?N2V3YVFIcXRUUCtidVRxZ3crYmkzZGN3Rk15VG5HaHlyOHFsekg5QU9Eekhh?=
 =?utf-8?B?WUVHM2FKZUxJYWRMMVhrdHNuRVMxNUZFcHBHTWdyOWNTQmxmL2NWMis2SWFy?=
 =?utf-8?B?d1RXczZiVUhXTFRJcWdhV05tRitMam5wQUpsU1ROaFQ2emR4QXlPYTVjZ1Zk?=
 =?utf-8?B?b09GUjdSdWZ0bjdpWk9tTVFLd1dSSHluamlBR1dBWDdHM0RJbjhaMDhuOE41?=
 =?utf-8?B?SmRWcHF3U3d3MUZrcE9pVmtrMENiWjJrU0VZVG13TTUyY0wzcHdrbmZLM1NL?=
 =?utf-8?B?OEt5OEhPanI1eWhlMkRwMHNGQ1lWMTYwT3Y5NVF6THRFcXkvSVl1RmxQRzBa?=
 =?utf-8?B?TXdWSU1ib3JXQW5CMFVhdERieGxpRnhmYWhMSFdhZlRUSHZXelFyS3QvRVhF?=
 =?utf-8?B?OEczU1VQK2tEYWFVaDM2QWFnRHFEWC95Y0lkL21hd3RtNkZldm10OGlNQ1lE?=
 =?utf-8?B?ODZpc3dYNDY2TlBXYVM2bW1LVVFsWjB3MDlrMkFYekoyZDBjWTlkcHpKWktW?=
 =?utf-8?B?LzRlN092RStiN3hVMHFTcWp4RGUxTnBHaDdUSlVMNUtFRkZaV2c5R3VsN1k1?=
 =?utf-8?B?T1U0Qy94TmhvZmE1bFB2d1VYeTZuOU9uMDJ4aUZRNTdYR1VGclFJNzY2RjlB?=
 =?utf-8?B?M3gyYis2Ui94T2FwcHkzYVdvTlJHNkszQ3BZaDEvVWJlemhIbk1xUXp5NnBo?=
 =?utf-8?B?U1FLTm9vc3FhM3MxV292VEV0b0R6dWJMQUo0NG1wUWVsMTgxNGl2TWNFUG50?=
 =?utf-8?B?bS8ydlZSbTJ6ck51cVUyMzVLanBrR1k4YS82c3J3c0o2S2V0a3hKcnhEWnZ3?=
 =?utf-8?B?b0tVOHhHRVp5T1RteUhLby9ySUJKblNQa3BSM2RoKzdic0drekZIaGNZTHov?=
 =?utf-8?B?VmRRYlhMRUZrYm96ZGp4WWw4WmxoaDZxeVIxZWVWRk5IK2owN2ovdlRKcnhU?=
 =?utf-8?B?VUhwUERkbk9BNXVBek9UQjdIaXpYSE1TdXAzb0JZMUJUTGh1OXNhMkFWUmo1?=
 =?utf-8?B?cXVqSXhYT0tzTHNGLy9QcVZ4aGpVbDhuRGVUOUJrR1M0cGVWVHhoOHoyR0k5?=
 =?utf-8?B?bFpUZW4ybHVaZHdlTzgxMUNFUHVWWVQzdzU5WU55Mm1lallLc3hlK3BZSkgy?=
 =?utf-8?B?UHJIVWtsbWpOK29FOTVSd3A3Qmw5bE83ZjVvbFlFV3NnODNnUzFSQmxPRUQ5?=
 =?utf-8?B?WTl0RW05S2x0UUMzSnlqOHVOakp2eGxsVUZ2b09wYVU2ZGVrMDV0d2xoQzda?=
 =?utf-8?B?QllpTE8rMkE4NXJoVjJmazJUS21wRmlVN1NxUDRSQ1FhNVliQktzV1d0L2RO?=
 =?utf-8?B?L0NkL3d1QWpFZ1RBNm8rc1NzdXpSQkZZaGJRYjROaS9ZMXFsaTJlRDlpRWM3?=
 =?utf-8?B?aG5xckR5UnlIYUpoK21WeFRHQVBxa2RnTVBkMDdVSEZadzFMWUJ1MEtVZ0lK?=
 =?utf-8?B?cnc9PQ==?=
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
	HiCN/gaiMH+CJ52K3aHrLWlhmJC1Fqsj3c926H1yNw1QAzR1bJ/pGP8Zc8J1J0iEORxE/7bNtfIOO2MQhFub6CB95aihZN+QvO3bPzcV+NAf5WauD1sXVGB2yhRYEs9A/mDVEM2ZPCX+t66BNbijvdQdVMuSgUiiY+EqABGQXsWfe/KRfxvTpith2EyCiUhOma2KlHkcSub00NUYArX1fOz0dlipRjDXpCaV598fVVSbwhpN1wawIFpd5QPt1B2La00H45Ar6Nl3DeytouYQ5mj/kuVXk49amcsBdl85MoNZs8AQUAxVomskBDrpEs3QVdVV49OELd1GWgV6pA2bRLTK1ayOvsig3F644cglN/IURDEDXYkPChBM8WLshvf1Q/0E5h5e6qfoZApBPblXgbZVQuyWcZ3+N/l3eaGuEIVDnVdjrJe5SNYajY1yxpWLL72eVBkP/vyqpuSG/704MaY58ffHnFhOK6TINcVo5vh/otC9zNlI/3ugBmzruwDstt+G28JDQ++rlfWnexd4K0Zti48URqdYLyRjJibqs5TY1y8NO1BwShz7DcxQTbsXBiDINt5PjqIkqkVhEgoG3MJsZjYTGaDl3L1r+TMH+5I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 750f9700-88d0-41e2-268f-08dcd2f72a9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 06:50:19.2762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FTcGQiMmEwhzHrjL2JKbAvEmspPmJsrAicvHs/7KDbhlGfPs50VMHaBHZkl5NBmybqU26Y+tSnhME3bi5llPfR+k5GoyVivnJZR1Cq2WPqQ4fkU7Rkz+JMxJzLlxy9Gn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7259
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409120047
X-Proofpoint-ORIG-GUID: LrlDcyYekh7mR5Yq1wzYsvNbhShlOh0Y
X-Proofpoint-GUID: LrlDcyYekh7mR5Yq1wzYsvNbhShlOh0Y

SEkgSm9zZXBoLA0KDQpUaGFuayB5b3UgdmVyeSBtdWNoIGZvciB5b3VyIHJldmlldy4gSSBoYXZl
IGNvcnJlY3RlZCB0d28gdHlwb3MgaW4gdGhlIGNvbW1pdCBkZXNjcmlwdGlvbiBhbmQgc2VudCBW
NCBjb250YWluaW5nIHlvdXIgUkIuDQoNClRoYW5rcywNCkdhdXRoYW0uDQoNCi0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKb3NlcGggUWkgPGpvc2VwaC5xaUBsaW51eC5hbGliYWJh
LmNvbT4gDQpTZW50OiBUaHVyc2RheSwgU2VwdGVtYmVyIDEyLCAyMDI0IDExOjIzIEFNDQpUbzog
R2F1dGhhbSBBbmFudGhha3Jpc2huYSA8Z2F1dGhhbS5hbmFudGhha3Jpc2huYUBvcmFjbGUuY29t
PjsgYWtwbSA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCkNjOiBKdW54aWFvIEJpIDxqdW54
aWFvLmJpQG9yYWNsZS5jb20+OyBSYWplc2ggU2l2YXJhbWFzdWJyYW1hbmlvbSA8cmFqZXNoLnNp
dmFyYW1hc3VicmFtYW5pb21Ab3JhY2xlLmNvbT47IG9jZnMyLWRldmVsQGxpc3RzLmxpbnV4LmRl
djsgc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0K
U3ViamVjdDogUmU6IFtQQVRDSCBSRkMgVjMgMS8xXSBvY2ZzMjogcmVzZXJ2ZSBzcGFjZSBmb3Ig
aW5saW5lIHhhdHRyIGJlZm9yZSBhdHRhY2hpbmcgcmVmbGluayB0cmVlDQoNCg0KDQpPbiA5LzEy
LzI0IDE6MDYgUE0sIEdhdXRoYW0gQW5hbnRoYWtyaXNobmEgd3JvdGU6DQo+IE9uZSBvZiBvdXIg
Y3VzdG9tZXJzIHJlcG9ydGVkIGEgY3Jhc2ggYW5kIGEgY29ycnVwdGVkIG9jZnMyIGZpbGVzeXN0
ZW0uDQo+IFRoZSBjcmFzaCB3YXMgZHVlIHRvIHRoZSBkZXRlY3Rpb24gb2YgY29ycnVwdGlvbi4g
VXBvbiANCj4gdHJvdWJsZXNob290aW5nLCB0aGUgZnNjayAtZm4gb3V0cHV0IHNob3dlZCB0aGUg
YmVsb3cgY29ycnVwdGlvbg0KPiANCj4gW0VYVEVOVF9MSVNUX0ZSRUVdIEV4dGVudCBsaXN0IGlu
IG93bmVyIDMzMDgwNTkwIGNsYWltcyAyMzAgYXMgdGhlIA0KPiBuZXh0IGZyZWUgY2hhaW4gcmVj
b3JkLCBidXQgZnNjayBiZWxpZXZlcyB0aGUgbGFyZ2VzdCB2YWxpZCB2YWx1ZSBpcyANCj4gMjI3
LiAgQ2xhbXAgdGhlIG5leHQgcmVjb3JkIHZhbHVlPyBuDQo+IA0KPiBUaGUgc3RhdCBvdXRwdXQg
ZnJvbSB0aGUgZGVidWdmcy5vY2ZzMiBzaG93ZWQgdGhlIGZvbGxvd2luZyBjb3JydXB0aW9uIA0K
PiB3aGVyZSB0aGUgIk5leHQgRnJlZSBSZWM6IiBoYWQgb3ZlcnNob3QgdGhlICJDb3VudDoiIGlu
IHRoZSByb290IA0KPiBtZXRhZGF0YSBibG9jay4NCj4gDQo+ICAgICAgICAgSW5vZGU6IDMzMDgw
NTkwICAgTW9kZTogMDY0MCAgIEdlbmVyYXRpb246IDI2MTk3MTM2MjIgKDB4OWMyNWE4NTYpDQo+
ICAgICAgICAgRlMgR2VuZXJhdGlvbjogOTA0MzA5ODMzICgweDM1ZTZhYzQ5KQ0KPiAgICAgICAg
IENSQzMyOiAwMDAwMDAwMCAgIEVDQzogMDAwMA0KPiAgICAgICAgIFR5cGU6IFJlZ3VsYXIgICBB
dHRyOiAweDAgICBGbGFnczogVmFsaWQNCj4gICAgICAgICBEeW5hbWljIEZlYXR1cmVzOiAoMHgx
NikgSGFzWGF0dHIgSW5saW5lWGF0dHIgUmVmY291bnRlZA0KPiAgICAgICAgIEV4dGVuZGVkIEF0
dHJpYnV0ZXMgQmxvY2s6IDAgIEV4dGVuZGVkIEF0dHJpYnV0ZXMgSW5saW5lIFNpemU6IDI1Ng0K
PiAgICAgICAgIFVzZXI6IDAgKHJvb3QpICAgR3JvdXA6IDAgKHJvb3QpICAgU2l6ZTogMjgxMzIw
MzU3ODg4DQo+ICAgICAgICAgTGlua3M6IDEgICBDbHVzdGVyczogMTQxNzM4DQo+ICAgICAgICAg
Y3RpbWU6IDB4NjY5MTFiNTYgMHgzMTZlZGNiOCAtLSBGcmkgSnVsIDEyIDA2OjAyOjMwLjgyOTM0
OTA0OCAyMDI0DQo+ICAgICAgICAgYXRpbWU6IDB4NjY5MTFkNmIgMHg3ZjdhMjhkIC0tIEZyaSBK
dWwgMTIgMDY6MTE6MjMuMTMzNjY5NTE3IDIwMjQNCj4gICAgICAgICBtdGltZTogMHg2NjkxMWI1
NiAweDEyZWQ3NWQ3IC0tIEZyaSBKdWwgMTIgMDY6MDI6MzAuMzE3NTUyMDg3IDIwMjQNCj4gICAg
ICAgICBkdGltZTogMHgwIC0tIFdlZCBEZWMgMzEgMTc6MDA6MDAgMTk2OQ0KPiAgICAgICAgIFJl
ZmNvdW50IEJsb2NrOiAyNzc3MzQ2DQo+ICAgICAgICAgTGFzdCBFeHRibGs6IDI4ODY5NDMgICBP
cnBoYW4gU2xvdDogMA0KPiAgICAgICAgIFN1YiBBbGxvYyBTbG90OiAwICAgU3ViIEFsbG9jIEJp
dDogMTQNCj4gICAgICAgICBUcmVlIERlcHRoOiAxICAgQ291bnQ6IDIyNyAgIE5leHQgRnJlZSBS
ZWM6IDIzMA0KPiAgICAgICAgICMjIE9mZnNldCAgICAgICAgQ2x1c3RlcnMgICAgICAgQmxvY2sj
DQo+ICAgICAgICAgMCAgMCAgICAgICAgICAgICAyMzEwICAgICAgICAgICAyNzc2MzUxDQo+ICAg
ICAgICAgMSAgMjMxMCAgICAgICAgICAyMTM5ICAgICAgICAgICAyNzc3Mzc1DQo+ICAgICAgICAg
MiAgNDQ0OSAgICAgICAgICAxMjIxICAgICAgICAgICAyNzc4Mzk5DQo+ICAgICAgICAgMyAgNTY3
MCAgICAgICAgICA3MzEgICAgICAgICAgICAyNzc5NDIzDQo+ICAgICAgICAgNCAgNjQwMSAgICAg
ICAgICA1NjYgICAgICAgICAgICAyNzgwNDQ3DQo+ICAgICAgICAgLi4uLi4uLiAgICAgICAgICAu
Li4uICAgICAgICAgICAuLi4uLi4uDQo+ICAgICAgICAgLi4uLi4uLiAgICAgICAgICAuLi4uICAg
ICAgICAgICAuLi4uLi4uDQo+IA0KPiBUaGUgaXNzdWUgd2FzIGluIHRoZSByZWZsaW5rIHdvcmtm
b3cgd2hpbGUgcmVzZXJ2aW5nIHNwYWNlIGZvciBpbmxpbmUgeGF0dHIuDQo+IFRoZSBwcm9ibGVt
YXRpYyBmdW5jdGlvbiBpcyBvY2ZzMl9yZWZsaW5rX3hhdHRyX2lubGluZSgpLiBCeSB0aGUgdGlt
ZSANCj4gdGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQgdGhlIHJlZmxpbmsgdHJlZSBpcyBhbHJlYWR5
IHJlY3JlYXRlZCBhdCB0aGUgDQo+IGRlc3RpbmF0aW9uIGlub2RlIGZyb20gdGhlIHNvdXJjZSBp
bm9kZS4gQXQgdGhpcyBwb2ludCwgdGhpcyBmdW5jdGlvbiANCj4gcmVzZXJ2ZXMgc3BhY2Ugc3Bh
Y2UgaW5saW5lIHhhdHRycyBhdCB0aGUgZGVzdGluYXRpb24gaW5vZGUgd2l0aG91dCANCj4gZXZl
biBjaGVja2luZyBpZiB0aGVyZSBpcyBzcGFjZSBhdCB0aGUgcm9vdCBtZXRhZGF0YSBibG9jay4g
SXQgc2ltcGx5IA0KPiByZWR1Y2VzIHRoZSBsX2NvdW50IGZyb20gMjQzIHRvIDIyNyB0aGVyZWJ5
IG1ha2luZyBzcGFjZSBvZiAyNTYgYnl0ZXMgDQo+IGZvciBpbmxpbmUgeGF0dHIgd2hlcmVhcyB0
aGUgaW5vZGUgYWxyZWFkeSBoYXMgZXh0ZW50cyBiZXlvbmQgdGhpcyANCj4gaW5kZXggKGluIHRo
aXMgY2FzZSB1cHRvIDIzMCksIHRoZXJlYnkgY2F1c2luZyBjb3JydXB0aW9uLg0KPiANCj4gVGhl
IGZpeCBmb3IgdGhpcyBpcyB0byByZXNlcnZlIHNwYWNlIGZvciBpbmxpbmUgbWV0YWRhdGEgYmVm
b3JlIHRoZSBhdCANCj4gdGhlIGRlc3RpbmF0aW9uIGlub2RlIGJlZm9yZSB0aGUgcmVmbGluayB0
cmVlIGdldHMgcmVjcmVhdGVkLiBUaGUgDQo+IGN1c3RvbWVyIGhhcyB2ZXJpZmllZCB0aGUgZml4
Lg0KPiANCj4gRml4ZXM6IGVmOTYyZGYwNTdhYSAoIm9jZnMyOiB4YXR0cjogZml4IGlubGluZWQg
eGF0dHIgcmVmbGluayIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBHYXV0aGFtIEFuYW50aGFrcmlzaG5hIA0KPiA8Z2F1dGhhbS5hbmFudGhha3Jp
c2huYUBvcmFjbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogSm9zZXBoIFFpIDxqb3NlcGgucWlAbGlu
dXguYWxpYmFiYS5jb20+DQo+IC0tLQ0KPiAgZnMvb2NmczIvcmVmY291bnR0cmVlLmMgfCAyNiAr
KysrKysrKysrKysrKysrKysrKysrKystLQ0KPiAgZnMvb2NmczIveGF0dHIuYyAgICAgICAgfCAx
MSArLS0tLS0tLS0tLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAxMiBk
ZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9vY2ZzMi9yZWZjb3VudHRyZWUuYyBi
L2ZzL29jZnMyL3JlZmNvdW50dHJlZS5jIGluZGV4IA0KPiAzZjgwYTU2ZDBkNjAuLjA1MTA1ZDI3
MWZjOCAxMDA2NDQNCj4gLS0tIGEvZnMvb2NmczIvcmVmY291bnR0cmVlLmMNCj4gKysrIGIvZnMv
b2NmczIvcmVmY291bnR0cmVlLmMNCj4gQEAgLTI1LDYgKzI1LDcgQEANCj4gICNpbmNsdWRlICJu
YW1laS5oIg0KPiAgI2luY2x1ZGUgIm9jZnMyX3RyYWNlLmgiDQo+ICAjaW5jbHVkZSAiZmlsZS5o
Ig0KPiArI2luY2x1ZGUgInN5bWxpbmsuaCINCj4gIA0KPiAgI2luY2x1ZGUgPGxpbnV4L2Jpby5o
Pg0KPiAgI2luY2x1ZGUgPGxpbnV4L2Jsa2Rldi5oPg0KPiBAQCAtNDE1NSw4ICs0MTU2LDkgQEAg
c3RhdGljIGludCBfX29jZnMyX3JlZmxpbmsoc3RydWN0IGRlbnRyeSAqb2xkX2RlbnRyeSwNCj4g
IAlpbnQgcmV0Ow0KPiAgCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBkX2lub2RlKG9sZF9kZW50cnkp
Ow0KPiAgCXN0cnVjdCBidWZmZXJfaGVhZCAqbmV3X2JoID0gTlVMTDsNCj4gKwlzdHJ1Y3Qgb2Nm
czJfaW5vZGVfaW5mbyAqb2kgPSBPQ0ZTMl9JKGlub2RlKTsNCj4gIA0KPiAtCWlmIChPQ0ZTMl9J
KGlub2RlKS0+aXBfZmxhZ3MgJiBPQ0ZTMl9JTk9ERV9TWVNURU1fRklMRSkgew0KPiArCWlmIChv
aS0+aXBfZmxhZ3MgJiBPQ0ZTMl9JTk9ERV9TWVNURU1fRklMRSkgew0KPiAgCQlyZXQgPSAtRUlO
VkFMOw0KPiAgCQltbG9nX2Vycm5vKHJldCk7DQo+ICAJCWdvdG8gb3V0Ow0KPiBAQCAtNDE4Miw2
ICs0MTg0LDI2IEBAIHN0YXRpYyBpbnQgX19vY2ZzMl9yZWZsaW5rKHN0cnVjdCBkZW50cnkgKm9s
ZF9kZW50cnksDQo+ICAJCWdvdG8gb3V0X3VubG9jazsNCj4gIAl9DQo+ICANCj4gKwlpZiAoKG9p
LT5pcF9keW5fZmVhdHVyZXMgJiBPQ0ZTMl9IQVNfWEFUVFJfRkwpICYmDQo+ICsJICAgIChvaS0+
aXBfZHluX2ZlYXR1cmVzICYgT0NGUzJfSU5MSU5FX1hBVFRSX0ZMKSkgew0KPiArCQkvKg0KPiAr
CQkgKiBBZGp1c3QgZXh0ZW50IHJlY29yZCBjb3VudCB0byByZXNlcnZlIHNwYWNlIGZvciBleHRl
bmRlZCBhdHRyaWJ1dGUuDQo+ICsJCSAqIElubGluZSBkYXRhIGNvdW50IGhhZCBiZWVuIGFkanVz
dGVkIGluIG9jZnMyX2R1cGxpY2F0ZV9pbmxpbmVfZGF0YSgpLg0KPiArCQkgKi8NCj4gKwkJc3Ry
dWN0IG9jZnMyX2lub2RlX2luZm8gKm5ld19vaSA9IE9DRlMyX0kobmV3X2lub2RlKTsNCj4gKw0K
PiArCQlpZiAoIShuZXdfb2ktPmlwX2R5bl9mZWF0dXJlcyAmIE9DRlMyX0lOTElORV9EQVRBX0ZM
KSAmJg0KPiArCQkgICAgIShvY2ZzMl9pbm9kZV9pc19mYXN0X3N5bWxpbmsobmV3X2lub2RlKSkp
IHsNCj4gKwkJCXN0cnVjdCBvY2ZzMl9kaW5vZGUgKm5ld19kaSA9IG5ld19iaC0+Yl9kYXRhOw0K
PiArCQkJc3RydWN0IG9jZnMyX2Rpbm9kZSAqb2xkX2RpID0gb2xkX2JoLT5iX2RhdGE7DQo+ICsJ
CQlzdHJ1Y3Qgb2NmczJfZXh0ZW50X2xpc3QgKmVsID0gJm5ld19kaS0+aWQyLmlfbGlzdDsNCj4g
KwkJCWludCBpbmxpbmVfc2l6ZSA9IGxlMTZfdG9fY3B1KG9sZF9kaS0+aV94YXR0cl9pbmxpbmVf
c2l6ZSk7DQo+ICsNCj4gKwkJCWxlMTZfYWRkX2NwdSgmZWwtPmxfY291bnQsIC0oaW5saW5lX3Np
emUgLw0KPiArCQkJCQlzaXplb2Yoc3RydWN0IG9jZnMyX2V4dGVudF9yZWMpKSk7DQo+ICsJCX0N
Cj4gKwl9DQo+ICsNCj4gIAlyZXQgPSBvY2ZzMl9jcmVhdGVfcmVmbGlua19ub2RlKGlub2RlLCBv
bGRfYmgsDQo+ICAJCQkJCW5ld19pbm9kZSwgbmV3X2JoLCBwcmVzZXJ2ZSk7DQo+ICAJaWYgKHJl
dCkgew0KPiBAQCAtNDE4OSw3ICs0MjExLDcgQEAgc3RhdGljIGludCBfX29jZnMyX3JlZmxpbmso
c3RydWN0IGRlbnRyeSAqb2xkX2RlbnRyeSwNCj4gIAkJZ290byBpbm9kZV91bmxvY2s7DQo+ICAJ
fQ0KPiAgDQo+IC0JaWYgKE9DRlMyX0koaW5vZGUpLT5pcF9keW5fZmVhdHVyZXMgJiBPQ0ZTMl9I
QVNfWEFUVFJfRkwpIHsNCj4gKwlpZiAob2ktPmlwX2R5bl9mZWF0dXJlcyAmIE9DRlMyX0hBU19Y
QVRUUl9GTCkgew0KPiAgCQlyZXQgPSBvY2ZzMl9yZWZsaW5rX3hhdHRycyhpbm9kZSwgb2xkX2Jo
LA0KPiAgCQkJCQkgICBuZXdfaW5vZGUsIG5ld19iaCwNCj4gIAkJCQkJICAgcHJlc2VydmUpOw0K
PiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIveGF0dHIuYyBiL2ZzL29jZnMyL3hhdHRyLmMgaW5kZXgg
DQo+IDNiODEyMTNlZDdiOC4uYTlmNzE2ZWM4OWUyIDEwMDY0NA0KPiAtLS0gYS9mcy9vY2ZzMi94
YXR0ci5jDQo+ICsrKyBiL2ZzL29jZnMyL3hhdHRyLmMNCj4gQEAgLTY1MTEsMTYgKzY1MTEsNyBA
QCBzdGF0aWMgaW50IG9jZnMyX3JlZmxpbmtfeGF0dHJfaW5saW5lKHN0cnVjdCBvY2ZzMl94YXR0
cl9yZWZsaW5rICphcmdzKQ0KPiAgCX0NCj4gIA0KPiAgCW5ld19vaSA9IE9DRlMyX0koYXJncy0+
bmV3X2lub2RlKTsNCj4gLQkvKg0KPiAtCSAqIEFkanVzdCBleHRlbnQgcmVjb3JkIGNvdW50IHRv
IHJlc2VydmUgc3BhY2UgZm9yIGV4dGVuZGVkIGF0dHJpYnV0ZS4NCj4gLQkgKiBJbmxpbmUgZGF0
YSBjb3VudCBoYWQgYmVlbiBhZGp1c3RlZCBpbiBvY2ZzMl9kdXBsaWNhdGVfaW5saW5lX2RhdGEo
KS4NCj4gLQkgKi8NCj4gLQlpZiAoIShuZXdfb2ktPmlwX2R5bl9mZWF0dXJlcyAmIE9DRlMyX0lO
TElORV9EQVRBX0ZMKSAmJg0KPiAtCSAgICAhKG9jZnMyX2lub2RlX2lzX2Zhc3Rfc3ltbGluayhh
cmdzLT5uZXdfaW5vZGUpKSkgew0KPiAtCQlzdHJ1Y3Qgb2NmczJfZXh0ZW50X2xpc3QgKmVsID0g
Jm5ld19kaS0+aWQyLmlfbGlzdDsNCj4gLQkJbGUxNl9hZGRfY3B1KCZlbC0+bF9jb3VudCwgLShp
bmxpbmVfc2l6ZSAvDQo+IC0JCQkJCXNpemVvZihzdHJ1Y3Qgb2NmczJfZXh0ZW50X3JlYykpKTsN
Cj4gLQl9DQo+ICsNCj4gIAlzcGluX2xvY2soJm5ld19vaS0+aXBfbG9jayk7DQo+ICAJbmV3X29p
LT5pcF9keW5fZmVhdHVyZXMgfD0gT0NGUzJfSEFTX1hBVFRSX0ZMIHwgT0NGUzJfSU5MSU5FX1hB
VFRSX0ZMOw0KPiAgCW5ld19kaS0+aV9keW5fZmVhdHVyZXMgPSBjcHVfdG9fbGUxNihuZXdfb2kt
PmlwX2R5bl9mZWF0dXJlcyk7DQoNCg==
