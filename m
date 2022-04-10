Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C315DC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Apr 2022 08:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IIQcMvNJDzzj5E9O6HumTnHrii97oO/B6IcccpbSUM4=;
 b=I4ztWi8r8pRCtzcXNuhmm6Hjk1b7w9CtYVTAkIkysVeDsH5EnFfpHxtiRhy0DXXFwOmPkzsFVTbS
   vDqjOOazwAkp+xuWm3A+sLRbmpNooAvXsG/5agzeQvKHy2uAZoiJyq5ilzNNwBoU+S5l2QA1Zt0M
   XmS91IRgTEbG+Kl1mWaidzCdzvwKlV75a2NbkrCiN3nIvGNOIHxDT9AZI4WVLItul8/vIE66RCgT
   qxpVi1GU923Xwoq+pFzvLmGq+JIhrj/zTiVJ6SwqS4+G4qlsWNbhRtOIhA5e7KHMgldJS3YcxxTn
   qzzumHebn8StN1+hZJ1Q6NunapidOIZ5FsvWJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IIQcMvNJDzzj5E9O6HumTnHrii97oO/B6IcccpbSUM4=;
 b=DYeL2p381niMFwlskc2+wOkNfGXxITdxxW/tMyzK2Vb3ZVsb7G+BRRGX52s5ENxeAjnQX5nuBydc
   izH8fFMtZ6ph8i0kZ5OTuoSimSd2PrKm1+6XsruaslK1Ak/dS3tp8SxHFEGyDw5PQE6k5Nd5nYGn
   zyXisfLL4dPlIqMlyMMzDuHaTDsB8uCc5e6HPLWTXWZIwRVsiHOIOjwAaepEcZxLqgMM5L9kNN7P
   brLvcQtevXPeZeBpjqIwt1L/LBpVYAjZWs5Ie9c9eD02ZBv21i96IK/eKtvqd08ywf/al4Abegft
   J4FW0EWVZXaV+bA3wNUml57+IIbDAddKsoItKg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA6003PH1OXBGD0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 11 Apr 2022 08:17:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649586328;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UR2q9ODbyvhYbG3iKvs0bzqn7Leidk/0/XQ4xWHQ/XE=;
 b=XHAzApDAfkQsrvapQdeveYNEr43YLQF26KXbcNAyM90hOPsw4ZdgBliLcnNOAWApOlGZEp
 9NnuprT9B79zEo1NtZYghbGwl/dj3Eg7w0DZFDsjxIDd+IpBcqLQ+qqeOzl3UwMSGdmREa
 wuswGeI3U7FuaFRCyBoas6NOwpDmi8s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0jIk0DMc8q0RhjXEdM5o+AbVQ4C0R1PhEvEk0hKgBxvADk6l9YQJ95Bgot6e8OjJ3aRrhyDM1cMFU0DDxvk3tLMK/eAq28kpyIuS+YAxFs300hMSZj9H9375XZmKHPF8wcdVa8NLKJ51LLHvP2/R4hGn45tn6xLoyyWeLQMUCYG1iHHHAmw1TYJr5MqsqOBoU0dT1CauQqQkD+kxxUArt2VpZPkrK1MGTWTLx9Scck5URkfEceWjZ7EEPCJMGg3Q7RxPbdlWA/m9wFVMcq9dHXQoq7DG/MXRknsL88im9vxdPl+J/mZ838wENh8fmYxKcXgjECG3mQEn8wYn+4WBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UR2q9ODbyvhYbG3iKvs0bzqn7Leidk/0/XQ4xWHQ/XE=;
 b=DKwVwOBxN8Ri6dJBGGpFQPpYV1vPpiup1EaTMOkk0O86TDtR/+NifRPGiSpEQPezJ/g2gucEIP+ocp1YCyveimzXTp7M2xfbpzYA26K7zOQuBwJOf/lMd5TfXeqoo3Ng16maTvWJS+g7BW0MmhGWSNpwvWKVY970wm8QYskdveHbmEv43vzXJXzSF49NEShHrnAXS5A8PUk4xJt/QPbgo6CD4jsda6lDeZEtPWrcFD5WS+L1l5utv71JAE6E6zV1/xIBy+aWzw0G2Dg2pWcMqJXA1Kfu698rILjhbCjAtTXpmiWjUPZnSr97B/xXk3mYl4WNme/H1mkM3zryXNP+lA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <53d98efd-396d-23ae-cb53-32d7a2adfc9e@suse.com>
Date: Sun, 10 Apr 2022 18:25:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-6-heming.zhao@suse.com>
 <c917d4bf-3405-08b5-41a3-60579733fde1@linux.alibaba.com>
In-reply-to: <c917d4bf-3405-08b5-41a3-60579733fde1@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6486002)(2616005)(26005)(186003)(31686004)(36756003)(508600001)(316002)(2906002)(31696002)(5660300002)(8936002)(66946007)(8676002)(66476007)(66556008)(6506007)(83380400001)(6512007)(53546011)(6666004)(86362001)(38100700002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2022 10:25:21.8847 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10312
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 phishscore=0 priorityscore=182 adultscore=0 bulkscore=0 clxscore=213
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204100068
Subject: Re: [Ocfs2-devel] [PATCH v1 5/5] ocfs2: rewrite error handling of
	ocfs2_fill_super
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: 1AX7q-VeMuKkMtJjhOzw4w-1
X-ClientProxiedBy: TYWP286CA0002.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::17) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 031b5741-3bb9-4a1a-87b5-08da1adc6ae8
X-MS-TrafficTypeDiagnostic: AM0PR04MB4130:EE_
X-Microsoft-Antispam-PRVS:
 <AM0PR04MB41303B1047FFD15401FEAAE997EB9@AM0PR04MB4130.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 ABGrrqekc+m6LUKLTWb+pkDp8qnKb7MNnGTkTOQCVrgJ8a0h1TqZS6uVnHFv17deWzg86EYecEjP/F6cGjZ6ExJaLKuAfOifmZ3HmpvgW1Jjw6p+cUe5GkxYIKEKIVpV6n6thzGtTdzn7KO2YXT0IDdXVIHrdqbhlxzKU0F3K+14Fd3KZ7wcQKgp7R21OImomjISl6vV147WLaUIxgRYdfsXui+ZOQkw0OQigHPlElzZRhVScyDkpQs7/XPRpaZEj0jQ0Z9YNPn4vytNVqmQMwljs3qQXtqUWWdwn9P7sTGgvYzoVHGZLCUm4lhrYjOJMIQBnGrTs0a5evkEP+JtJCEZxU++HiOdCv3YcsKPldgsWzxoPf4P5sKw0D19aFZPKqVt/jC4+fRpyPy1x3h92roT2lX5NysOwwpu/FzITMBGiCPYXIgu6Cv1Opkg9QAUNinjGgp8GAE61q2mu2Eh28799YpsPGdsRBdPkcimes5mIsiKRjIw37WDVVzexiTqASyiGlekqfzVq9tCDj7YJWa8k509rZ2KTj990SxfpZKrD9jaic11rEu362zmZ+05nYJxLW7pFz1xvGr8nmDsDBtAX1tZf/f2ivpviU0FSaUc22zbU+F5kPFOKa83mMiN5+pkoZmoDdeshri3QPALmRAwy6CES3ZA6DJrssf+uvJ+scMxKmhlmJZNGC8k3OLcNnZmvxv5k9lWMdCgfE1+JrCQzMMYqfqGJwcBgJdgsB0=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SUZhVTNIdU9oMTJORCtRbHJEc2VVV1FkT1BmMUY0SGd4NjZYV1l6dFJKNFM3?=
 =?utf-8?B?VDlpUjRwMzNURi9Kc3RGSnFQRFpZWkVQV2pkc05sQWh2WFJxUTFUQ0dXSkNr?=
 =?utf-8?B?MlNzbHJLd2dFTHlxM0wwTGpmZksveCtoaER3MStHZTIyRzN4SG02bFNRU3Z2?=
 =?utf-8?B?aWF3bTRUellnemFTa0NpTGJmWlhSalJWZ2UrRUVKd1NUNVRzbUg1STY3NXZY?=
 =?utf-8?B?ZXNKSnRxNFhqWFFRNC82VTEySkdwbG5GY3FRQWJlZlNmaVlGKzZlQnJrNlAw?=
 =?utf-8?B?cHZjMDd3QVJKVnphczlzdC9RMkdyNk11UDBHRFlIdWdZRklZWjkxUG1ieDZx?=
 =?utf-8?B?b3ZiSS9DS3o1ZGxOL2ZNNTFwOURvSWhqNmVPYnVhd2Job0dPTmtLbTVEODVr?=
 =?utf-8?B?Y0s0Zm9uYlFNaHRsV2VHeUV0eHhaM1F6NW5JcUFQNmpOUmZqcHcxeTRIR2xa?=
 =?utf-8?B?MVFrdHJVQUd0TU1EaGplcStDZHBUeVZRYWxlTnFiWEV0T25WMHlVMGZZNU8x?=
 =?utf-8?B?QmttNXRkZ282YUdRa25wOEEzczJhNUhROXgxRDZtYVNSSm5FQkdlYThNenA1?=
 =?utf-8?B?VGhLUVBzRDNaNEFyWTY3N01zeGZzTDFqcGJsRGRmcEtUeUlZN2hYb0UyVzZK?=
 =?utf-8?B?WW9QWkFDK2JMNzgzMFIvTkNZQzUveFh6NDNmSlNtb2VPSkdxWWtwQXE2aGp5?=
 =?utf-8?B?T28zTUdvbEs3TWo4VnhjUDJjZWdHVUgvZFBxTmpEbFFrSTBkU0tGZ1lYNnVq?=
 =?utf-8?B?czNXUDR2eTZta3IwZ1ZFam9VYmNCY3VQamg5MFpaTXh5VGpYTmlIV0ZWTHhr?=
 =?utf-8?B?V2dka3R1cW5OZ0F3encrLzZQcDZ0M0IrQ2NRZVpqbDVURWNLRmEvelh6U1BU?=
 =?utf-8?B?dFNUZ3ZTRlhBZFpQc2NwemF5REI3dzZBZVhzaElYMjRtTGFseFE3TmUwdHNN?=
 =?utf-8?B?ME5pbHU1NE1BY1phbkgvYU80SUFJT1EraVczRUdTKytZRUh2RnJSWUJtbTF6?=
 =?utf-8?B?TTVScHp1a1V1bEZldkpqTnQveXYrVW1qcVlKTnlTZkR5QWpBQmIyUUdMbGN0?=
 =?utf-8?B?NHF2TStlSm1XSE5VK29QRWhFcjY0MmF0eGx5TVc1QVF3RzMxaDZoZHkzYXF5?=
 =?utf-8?B?OE9TUXV5Ly9oY1RLdFhpSU9pY3dkTC8yTmF1NHFoSFhreEZGZXNORHRESFNy?=
 =?utf-8?B?ZEQ5LzJzNG9tU0h1WlpsOE1jN2Q2cU96Wm1FUHE3amc2RG9jSHk2ejRZRTNq?=
 =?utf-8?B?ejE1QmwvazduVERKbVhVSGxvYWVFRkpsVDBqTnc5Um1vSHlZTXpuUStvUHE1?=
 =?utf-8?B?cXY2bVV4V0phOStvUWJFb2E1ZTFXRTFjaDNVdXRaVGt2alcxZUNWQitEaU1u?=
 =?utf-8?B?RUxXa1JLb2RtOWJEaEp3TTRQMkZpUXBiVmw2dzV0MlRDQ2U4TW00OC9xeVBy?=
 =?utf-8?B?Qys5UVhsMHVOckUvZjlxemlwTXBSMFlLWVBHb0VYeUZneCtBcEI1M3NoeFBo?=
 =?utf-8?B?TTRhVnJtMkFVSHVtZUkyYkFoclVGUDlqQlNlbmdQZHh3aHErTzFFL0ZLZ3da?=
 =?utf-8?B?OUY3dXhqd1BFcjBuVmdnc3pEVld5dlUvVEJKaDhaQmdvOEVOTnJoUWJCbEU4?=
 =?utf-8?B?RUdxUGJrck5qMDdFQjQ3T1JpdTgwa211RElZNElnbFRvZEh3ZWJRWG54cVVn?=
 =?utf-8?B?VVkxU2dTa0FhMzl1YllMRW9SVHE1WXhaZU1PNm1sRVRhUXE5OWlpNEtBNUg1?=
 =?utf-8?B?dUJ1RXJWLzhIQ1pTallMaUM4bmNhak15Y3FtZFc2NlhmQldrNE5LNlNmSE5j?=
 =?utf-8?B?U2pwbUZkK01JN2V0K2xrTW9Gbno1WTQ1VkFsUlBPZHlPTEZ1djNnNEY4bVgx?=
 =?utf-8?B?aTRnV3ZJMG5iU3JJaWY3bEQ0emE5dnRGRDJqUFhFcC94QTU0a015N1NYNGU5?=
 =?utf-8?B?MXByNHQrTWJzWlA1K1R2MXIrc2VOS2d1U0pBNFI4NTVySW1UOVlYYUhmYVNa?=
 =?utf-8?B?TGlqQTVpamFHanZaWG5iN2Q2Ym85eHhLKzVBeXJIU3JOdFpCaHF4QTdJMjZK?=
 =?utf-8?B?MU1EU1Ftb3IxZjhPSVdib0h4cjNyTzJlMlR1RkZzMXJSRTlJS3VwU2pNYWxq?=
 =?utf-8?B?bUEvTVFFS2xXdjR0TDdrN2R3ejV3Z2gyRzh1a0N3R2YzV2JtODA3VXgxOGJz?=
 =?utf-8?B?VDNxOEFmbzVWbDJYdVNPOFlyUzhjTkJ5dTJUaHNoNjVMT1JQREpKR08wcVp1?=
 =?utf-8?B?dFAzazJUOTc3cTlsbnh5WmNIZng4c1Q3RXVoUXcyRVNJRzdIdStPK21VcFpF?=
 =?utf-8?B?TnI0S0dCejI3VEZMRkNJKzY2TXhsaTZSQStPeWpKQ1phRGg2cU5nZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 031b5741-3bb9-4a1a-87b5-08da1adc6ae8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 eJVLu+OsE2t04w5uWTkI8Ihz8aK1bjzHUxTtK57OgFjLolLyOeAb25lOAP4q5oZEkrUNJiUNXydFBD9YPOrzPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4130
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: Shp34LU6CPQd0nldhgyXmE9yitEUOYB1
X-Proofpoint-ORIG-GUID: Shp34LU6CPQd0nldhgyXmE9yitEUOYB1
Reporting-Meta:
 AAG5HUt1emcad487J3aATWsQu0WoxMGmBUBwDkmKcdvrjz+TGaakW3DmUqViQ+iW
 j4Wymt4vZnTQO5Caahx1njHHJGqIVa13BoG23/G8mnuhYFVsq9YEwanMIc/t7AQQ
 dmBOLVe/l9f2CLVqhrlFtymNDypiG47mf/ncghQj69rEN6v4W1NwqzzAkNDYuh1R
 oy2JsM73d/o9tee/u1j4lD4EMSyv4i3jHiVc1EIPt2FcAIaCdgb9f2w4uc08/JTm
 lzxTEzoq3Lww1SiNG6QUtrpnoBxatuoW4g/qlKx1PclK7wF2RpskliI3WC0UZzT9
 Gt/o94h/sgQ7G40nCJFwe5fK5Fg6Ksz7a/Q2QaoQW5e+7FiM9IsNEXRpVEtfKvBa
 GeLIl9vLOJVyLudvZYPmdUW4qQ8TLfzVQHKWvje84hF+eN8BggG7Esrg2vJV2bPq
 aoN/FE3uNNRv6JN24rGwGutfv8X1WdQfELzi0pkmSZlbJCr2Jqz4NMw99RpnnPs7
 MshEEWJj4wwx4jOxdUt545zpXcpWoFrjJ2fHg8Jgy7Tw

On 4/9/22 22:02, Joseph Qi wrote:
> 
> 
> On 4/8/22 6:30 PM, Heming Zhao wrote:
>> current ocfs2_fill_super error handling is very simple, and includes
>> kernel crash possibility.
>>
>> e.g.
>>
>> ocfs2_fill_super
>>    ocfs2_initialize_super // fails in check max_slots & return
>>
>> Then osb->osb_mount_event is not properly initialized, and then will
>> crash at wake_up(&osb->osb_mount_event) in goto label read_super_error.
>>
> With patch 3, this case won't exist any more.

Agree. After patch 3, ocfs2_initialize_super() will free osb before returning

failure, and this issue won't be triggered.
I will change it in next version.

> 
>> For fixing the issue and enhancing error handling, we rewrite error
>> handling of ocfs2_fill_super.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/super.c | 67 ++++++++++++++++++++++++------------------------
>>   1 file changed, 33 insertions(+), 34 deletions(-)
>>
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index d4b7a29cb364..c3efd9ad49ac 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -989,28 +989,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   
>>   	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
>>   		status = -EINVAL;
>> -		goto read_super_error;
>> +		goto out;
>>   	}
>>   
>>   	/* probe for superblock */
>>   	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
>>   	if (status < 0) {
>>   		mlog(ML_ERROR, "superblock probe failed!\n");
>> -		goto read_super_error;
>> +		goto out;
>>   	}
>>   
>>   	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
>> -	osb = OCFS2_SB(sb);
>> -	if (status < 0) {
>> -		mlog_errno(status);
>> -		goto read_super_error;
>> -	}
>>   	brelse(bh);
>>   	bh = NULL;
>> +	if (status < 0)
>> +		goto out;
>> +
>> +	osb = OCFS2_SB(sb);
>>   
>>   	if (!ocfs2_check_set_options(sb, &parsed_options)) {
>>   		status = -EINVAL;
>> -		goto read_super_error;
>> +		goto out_super;
>>   	}
>>   	osb->s_mount_opt = parsed_options.mount_opt;
>>   	osb->s_atime_quantum = parsed_options.atime_quantum;
>> @@ -1027,7 +1026,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   
>>   	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
>>   	if (status)
>> -		goto read_super_error;
>> +		goto out_super;
>>   
>>   	sb->s_magic = OCFS2_SUPER_MAGIC;
>>   
>> @@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   			status = -EACCES;
>>   			mlog(ML_ERROR, "Readonly device detected but readonly "
>>   			     "mount was not specified.\n");
>> -			goto read_super_error;
>> +			goto out_super;
>>   		}
>>   
>>   		/* You should not be able to start a local heartbeat
>> @@ -1050,7 +1049,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   			status = -EROFS;
>>   			mlog(ML_ERROR, "Local heartbeat specified on readonly "
>>   			     "device.\n");
>> -			goto read_super_error;
>> +			goto out_super;
>>   		}
>>   
>>   		status = ocfs2_check_journals_nolocks(osb);
>> @@ -1059,9 +1058,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   				mlog(ML_ERROR, "Recovery required on readonly "
>>   				     "file system, but write access is "
>>   				     "unavailable.\n");
>> -			else
>> -				mlog_errno(status);
>> -			goto read_super_error;
>> +			goto out_super;
>>   		}
>>   
>>   		ocfs2_set_ro_flag(osb, 1);
>> @@ -1077,10 +1074,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   	}
>>   
>>   	status = ocfs2_verify_heartbeat(osb);
>> -	if (status < 0) {
>> -		mlog_errno(status);
>> -		goto read_super_error;
>> -	}
>> +	if (status < 0)
>> +		goto out_super;
>>   
>>   	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
>>   						 ocfs2_debugfs_root);
>> @@ -1094,15 +1089,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   
>>   	status = ocfs2_mount_volume(sb);
>>   	if (status < 0)
>> -		goto read_super_error;
>> +		goto out_debugfs;
>>   
>>   	if (osb->root_inode)
>>   		inode = igrab(osb->root_inode);
>>   
>>   	if (!inode) {
>>   		status = -EIO;
>> -		mlog_errno(status);
>> -		goto read_super_error;
>> +		goto out_journal;
>>   	}
>>   
>>   	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
>> @@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   	if (!osb->osb_dev_kset) {
>>   		status = -ENOMEM;
>>   		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
>> -		goto read_super_error;
>> +		goto out_journal;
>>   	}
>>   
>>   	/* Create filecheck sysfs related directories/files at
>> @@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   		status = -ENOMEM;
>>   		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
>>   			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
>> -		goto read_super_error;
>> +		goto out_journal;
>>   	}
>>   
>>   	root = d_make_root(inode);
>>   	if (!root) {
>>   		status = -ENOMEM;
>> -		mlog_errno(status);
>> -		goto read_super_error;
>> +		goto out_journal;
>>   	}
>>   
>>   	sb->s_root = root;
>> @@ -1178,17 +1171,23 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   
>>   	return status;
>>   
>> -read_super_error:
>> -	brelse(bh);
>> +out_journal:
> 
> rename it to out_dismount?

agree.

> 
>> +	mlog_errno(status);
>> +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
>> +	wake_up(&osb->osb_mount_event);
>> +	ocfs2_dismount_volume(sb, 1);
>>   
>> -	if (status)
>> -		mlog_errno(status);
>> +	return status;
> 
> Or remove mlog_errno() before and then just goto out?

your mean: at the end of lable "out_journal", call "goto out"?

if yes, no problem for me.

> 
>>   
>> -	if (osb) {
>> -		atomic_set(&osb->vol_state, VOLUME_DISABLED);
>> -		wake_up(&osb->osb_mount_event);
>> -		ocfs2_dismount_volume(sb, 1);
>> -	}
>> +out_debugfs:
>> +	debugfs_remove_recursive(osb->osb_debug_root);
>> +out_super:
>> +	ocfs2_release_system_inodes(osb);
>> +	kfree(osb->recovery_map);
>> +	ocfs2_delete_osb(osb);
>> +	kfree(osb);
> 
> Seems we have to take care all resources in ocfs2_initialize_super()?

Yes, I checked every lines.



for ocfs2_initialize_super(), I lists all my found resources:

(list in time order):

   osb, osb->recovery_map, osb->vol_label, osb->slot_recovery_generations,

   osb->osb_orphan_wipes, osb->journal, osb->uuid_str

   - all above have itselves out_xx label.

   osb->osb_dlm_debug & dlm sysfs stuffs.

   - release by out_dlm_out

   system inodes (by ocfs2_init_global_system_inodes)

   - release by out_system_inodes

   osb->slot_info, osb->slot_info->si_bh

   - release by out_slot_info

   workqueue:osb->ocfs2_wq

   - will be freed in ocfs2_fill_super label "out_super": ocfs2_delete_osb().
     or be freed in ocfs2_dismount_volume => ocfs2_delete_osb().

> 
>> +out:
>> +	mlog_errno(status);
>>   
> As I described in your previous mail, ocfs2_sb_probe() may return error
> with non-NULL bh, so we should brelse here.
> 

I also explained why I dropped the brelse(bh), maybe anti-spam system ate my mail.

(I found my emails also disappeared in other mailling lists.)



I re-explain here. below code based on patch 5/5.

please note <2> & <4>.



```

static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)

{



     ... ...

     if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {

         status = -EINVAL;

         goto out;

     }



     //hm: <1> bh is alloced/created from here.

     /* probe for superblock */

     status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);

     if (status < 0) {

         mlog(ML_ERROR, "superblock probe failed!\n");

         //hm: <2> if error, ocfs2_sb_probe() will release bh. So "out" label

         //doesn't need to call brelse(bh).

         goto out;

     }



     status = ocfs2_initialize_super(sb, bh, sector_size, &stats);

     brelse(bh); //hm: <3> release bh before assessment status.

     bh = NULL;

     if (status < 0)

         goto out; //hm: <4> if error, bh is already released before "if()",

                   // So "out" label does't need to call brelse(bh)



     osb = OCFS2_SB(sb);



     ... ...



out:

     mlog_errno(status);



     return status;

}

```

Thanks,
Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
