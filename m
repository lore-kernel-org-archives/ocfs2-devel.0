Return-Path: <SRS0=bLRF=KU=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A73C2B9F8
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 May 2021 18:00:07 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A0353613CC
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 May 2021 18:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0353613CC
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHn6B5019238;
	Tue, 25 May 2021 18:00:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=1/qt2r0R8wIcmiYTMj7gSw6I7Wkw+n02yNgVu4HzyfU=;
 b=bvSIaQbrtfS0yDSLPqb7hTTzA03JKaqudMViA8IPYGAswV/oCcmzXtIUKHi8w726Q8sn
 pdlGyacaWdvXjfgn6wI9GRV/Vz8+K5naDrjEyTooZo0ZIOgbgi+GOeGkCwsUWGKGllgA
 YD8rUFePsaoo68Px7kDwhSiTWmMGrZXBRkn91vl+QdzQwfT+n5Znk8XLjd5j9lvFvHD4
 OpC8CZ4VdznZ07rHg3hxZ3jtew5379sIFWpDCTkvUKQsG9JNtKx+HnmdP6+ywPxKkYOJ
 xr5zoEUgCo8bHU/hCTGgNe0nkCCLzyjatDoEhKLYPFKLvQLMadYAwi4ba1Ro/Al2hN38 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38rne42fgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 18:00:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHoEPT153775;
	Tue, 25 May 2021 18:00:04 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38qbqsg3nq-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 25 May 2021 18:00:04 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1llbLW-0006ih-M9; Tue, 25 May 2021 11:00:02 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1llbLT-0006cT-Jd
	for ocfs2-devel@oss.oracle.com; Tue, 25 May 2021 10:59:59 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PHo3QT064031
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 17:59:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
	by aserp3030.oracle.com with ESMTP id 38pr0c0u9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 17:59:59 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB3653.namprd10.prod.outlook.com (2603:10b6:a03:11d::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20;
	Tue, 25 May 2021 17:59:57 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9%6]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 17:59:57 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20210521233612.75185-1-junxiao.bi@oracle.com>
	<35a1d32b-b8d7-ea9b-d28c-6b4fd837605d@linux.alibaba.com>
	<8aa90f5d-e4db-5107-1d3c-383294871196@oracle.com>
	<21d8b289-541d-50f5-6f86-de3ee69c56c5@linux.alibaba.com>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <35283832-3294-19e0-6542-d1f925711fe8@oracle.com>
Date: Tue, 25 May 2021 10:58:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <21d8b289-541d-50f5-6f86-de3ee69c56c5@linux.alibaba.com>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SJ0PR13CA0004.namprd13.prod.outlook.com
	(2603:10b6:a03:2c0::9) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-226-235.vpn.oracle.com (73.231.9.254) by
	SJ0PR13CA0004.namprd13.prod.outlook.com (2603:10b6:a03:2c0::9)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11
	via Frontend Transport; Tue, 25 May 2021 17:59:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1da72976-6df8-460c-192a-08d91fa6e838
X-MS-TrafficTypeDiagnostic: BYAPR10MB3653:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5UJchXNo7Tfg4QMZ49dGI76Dg1VcUTPXC4rXMAvXwp+WOGO6+SO3eqMba1DK92KaZRbQ4kq++vluCg2gUgUgjX2IDRgLgV9B9I3DsCgOvrQBOiYSJPbRt7HR6x7AffDpLK7Af8a9DpeEE62DIjyXV62dp8q0mchuT1Ud/SnMrrZ/2l2y0ALqvUBi4bUwhNs8es5kqXkC3MXtQeoBiS1qb4TGjwvkixCbNnch8WU6IeCVEYhGR+5ZqoMfKcptqc1i9eUziNUHfltNjO5f95StdmNMUhkr2r8+9aQmXUDIFwGeE3AqWolDfzlTv1SME5CM+v5gI6HI+BDs/hDgEy/bIhEnH4EiifUZ8QvBrdV0+BSlbHPm90u1MMSdWUkTbLwWeq0NQZr0lWz7yfT77CbFdEEtj8uwcYThX6FgPcfaT2wV5IFoGlALOgj9GYa9/JakC7LRLKHrlQJMhxdbDSi40YmjFNgwO6u5ThynZbvD+l46GHTw23dpETzTGdiCq4wFbuZW5YTLyiFwjngCn7r1Rx3W1CiYGcdVFvWlaeqh7+SnXcErv55Ca3+Ad9V0ZqZRghnUiOGOI46YpIKRL5CFTL4w+9l58H+5YmAgd0+AU/edwTfPDDmgOW52BxRBCCQGnBaRZiUd2QNgXCSSphUUubiCyBCJEw3yOlyAncpjGQY=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b0NNWGsrMXVWRFBtZ2hFcGlFNFF0RGQ3a1hVbEx3MDJDNTJpZ0ZqNXV1VHlN?=
	=?utf-8?B?QmpPVjN5ZFgwNUFyRFNzQ1FKeS9wZndIYllxc3NhZVNIY0Zad255aGYreFBk?=
	=?utf-8?B?bFNacE53andQQjJ2MGFzRXhmbHI2SlBEeUd5RVZtSHlZMmhZcGJ6QmI2UFgw?=
	=?utf-8?B?ZWNTTUtiamI4cnIrbXQ0NXRmc1RLRDhUQWhVQ25TMitCSE1XTk5nUEp2Wmwr?=
	=?utf-8?B?WHF3Skh3UEJyRzBpVmd6NnU3VzZxam9RMkJreVN2VXBnM2xTR01obTJmdGlL?=
	=?utf-8?B?V2NpRFJValZFZG9RTnFQQ213RE45VnN1b0pKd0VDb3hNZTB6eGFhNUdsZjZp?=
	=?utf-8?B?emJHOEdQeXB5WTVBeGRQV3FXelJXNXV0bkxIbEFnZ1dyazJxTUxHcDByZGxa?=
	=?utf-8?B?N28rc3ErUzBydXVHWVAwcVhpUHNYRWludFllNUtIbHZtVm1TZ1dLTG81RXdS?=
	=?utf-8?B?bzB4aDk1MC8xcGxKaWtySTNWTlZ3OEZ4MnhMQ2d5U0hRZTFpQUZ0dnR0cW9H?=
	=?utf-8?B?VWxtZG9UUEFpaXZtQ0hITlNtN3pYK0txNS9wK0FrTUxyUGdVaktDOG91VDM1?=
	=?utf-8?B?TmNNWU1vU1pycWYyK0s2QmMyOTFxeFlyeDVybGQyc3lTNGEyU0xIUnlRakI5?=
	=?utf-8?B?SmQvZ05USnhLTkZGbWY1R1Ivd1ZTaUpSeUJlY0NTcEJHYy9OeG5uVmZtazdZ?=
	=?utf-8?B?SDZNdkd0cUI1d0x5TzQxZ3dLMXpNL090MGMzZmJnd3FQaWswNHByclN1ZHo5?=
	=?utf-8?B?N0dQdFlnOFAzVDVvOW5KTVZuWmdXdTg2R3VZV3FnaDZGZnZLVXpOWForNHh6?=
	=?utf-8?B?enphK3FXYXBJbDFneVFuZEdjejNJUFVSdWZrVkJKNyt0UEwvSlZhWEM1L2tZ?=
	=?utf-8?B?NXNtSC9kSHRXQy83NmljTm9rSUFRd012bVVJTnozVjVuM3pYRXFSeEJNRG8v?=
	=?utf-8?B?Q0hCMGZsVGZJaUN4RVdlNkNwa1NzRldRZ3pYa2V2enEwM3JueElyTUI0UXJR?=
	=?utf-8?B?UHZycVdnYmtva3lSdzZwVlEvRWhxam8zQzc2dGlac3lGSXp1b1VzaUhBVmNN?=
	=?utf-8?B?elN1VVVBM1dCZTJtMWR6cnBpQitjaFNjaG14R2kwaThFTGVMOHNtcDFjcnRS?=
	=?utf-8?B?enlzdWdDdWdsZktheHFkVDJRNXRHK2dTTHdiQThGSHhsS05OcFN3MjBUUVJ3?=
	=?utf-8?B?cmFxekdidUxUMmhlRHZMejA1V2RobG5JYjM0c0NPRlUvUFhpQzVkR1J6U1Vs?=
	=?utf-8?B?MmdLWjUrSEp1eW5hbUZObmlHYUUyKzhiL1ZXNlV0Zmd3WXBXZXA5YkFhVnJZ?=
	=?utf-8?B?MFliLzBYWmIwRks4UFFmUEY1akQwK1h6aFdibTRoM0x5TEdUNFBud2lRcUtv?=
	=?utf-8?B?b2ZwaEhaUU1WUkNWcHhJenBoQjJYMXNhS3F5Yk5WUzZaemx2Mzl4ci8xR3Bo?=
	=?utf-8?B?NGhPV1BFcFJuRWNmSU81VXhMVDd3TDBqQVpLTDByRnMrNDRjNTN1Y3VkMzR0?=
	=?utf-8?B?VjlwRHdzNzViRlJHeXdPcDhvM1pDNFA4Y1ZDKzFqT2dMVGtNbGs5UTR6T3Jw?=
	=?utf-8?B?MkpBSmlmMk9mNy9SaUdLTjBwMHRnaVBEZUpVdWYwRnoyVnpWeG1KeUpYYTh5?=
	=?utf-8?B?akY1T0w1b1FpY0hielh2M1B6ZjhIdlp0aklpbDQ4SXBZMmZNc0IybC9uMkFy?=
	=?utf-8?B?OENibUpVMHBhUTVoWkFsUWVycGNmSURHVDlUYmlpUjA3Slg3SzFmTTM2VzM0?=
	=?utf-8?Q?wTg4l5uE1z+1SHwC2mK8KMLhfyfFqBCMP19ByHM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da72976-6df8-460c-192a-08d91fa6e838
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 17:59:57.1913 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZckniExi6BCBESai+ZaF70EK/yePMl2LFS/Fip8tEKV9ENh4s0PTdGhHv1GG1mj0QSmwq3V6UbdXbP5iMntWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3653
X-MS-Exchange-CrossPremises-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 14
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 73.231.9.254
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BYAPR10MB3653.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	bulkscore=0 spamscore=0
	mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250110
X-MIME-Autoconverted: from 8bit to base64 by aserp3030.oracle.com id
	14PHo3QT064031
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix data corruption by fallocate
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250110
X-Proofpoint-ORIG-GUID: a6dPZEhuE6tvJPWdB-pk8Vrsg7aIXLJW
X-Proofpoint-GUID: a6dPZEhuE6tvJPWdB-pk8Vrsg7aIXLJW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250110

SSB3b3VsZCBsaWtlIG1ha2UgdGhlIGZvbGxvd2luZyBjaGFuZ2UgdG8gdGhlIHBhdGNoLCBpcyB0
aGF0IG9rIHRvIHlvdT8NCg0KZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2ZpbGUuYyBiL2ZzL29jZnMy
L2ZpbGUuYw0KaW5kZXggMTc0NjlmYzdiMjBlLi43NzU2NTc5NDMwNTcgMTAwNjQ0DQotLS0gYS9m
cy9vY2ZzMi9maWxlLmMNCisrKyBiL2ZzL29jZnMyL2ZpbGUuYw0KQEAgLTE5OTksOSArMTk5OSwx
MiBAQCBzdGF0aWMgaW50IF9fb2NmczJfY2hhbmdlX2ZpbGVfc3BhY2Uoc3RydWN0IGZpbGUgDQoq
ZmlsZSwgc3RydWN0IGlub2RlICppbm9kZSwNCiDCoMKgwqDCoMKgwqDCoCB9DQoNCiDCoMKgwqDC
oMKgwqDCoCAvKiB6ZXJvb3V0IGVvZiBibG9ja3MgaW4gdGhlIGNsdXN0ZXIuICovDQotwqDCoMKg
wqDCoMKgIGlmICghcmV0ICYmIGNoYW5nZV9zaXplICYmIG9yaWdfaXNpemUgPCBzaXplKQ0KK8Kg
wqDCoMKgwqDCoCBpZiAoIXJldCAmJiBjaGFuZ2Vfc2l6ZSAmJiBvcmlnX2lzaXplIDwgc2l6ZSkg
ew0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBvY2ZzMl96ZXJvb3V0X3Bh
cnRpYWxfY2x1c3Rlcihpbm9kZSwgb3JpZ19pc2l6ZSwNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
c2l6ZSAtIG9yaWdfaXNpemUpOw0KK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFy
ZXQpDQorwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaV9zaXpl
X3dyaXRlKGlub2RlLCBzaXplKTsNCivCoMKgwqDCoMKgwqAgfQ0KIMKgwqDCoMKgwqDCoMKgIHVw
X3dyaXRlKCZPQ0ZTMl9JKGlub2RlKS0+aXBfYWxsb2Nfc2VtKTsNCiDCoMKgwqDCoMKgwqDCoCBp
ZiAocmV0KSB7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1sb2dfZXJybm8ocmV0
KTsNCkBAIC0yMDE4LDkgKzIwMjEsNiBAQCBzdGF0aWMgaW50IF9fb2NmczJfY2hhbmdlX2ZpbGVf
c3BhY2Uoc3RydWN0IGZpbGUgDQoqZmlsZSwgc3RydWN0IGlub2RlICppbm9kZSwNCiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXRfaW5vZGVfdW5sb2NrOw0KIMKgwqDCoMKg
wqDCoMKgIH0NCg0KLcKgwqDCoMKgwqDCoCBpZiAoY2hhbmdlX3NpemUgJiYgaV9zaXplX3JlYWQo
aW5vZGUpIDwgc2l6ZSkNCi3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlfc2l6ZV93cml0
ZShpbm9kZSwgc2l6ZSk7DQotDQogwqDCoMKgwqDCoMKgwqAgaW5vZGUtPmlfY3RpbWUgPSBpbm9k
ZS0+aV9tdGltZSA9IGN1cnJlbnRfdGltZShpbm9kZSk7DQogwqDCoMKgwqDCoMKgwqAgcmV0ID0g
b2NmczJfbWFya19pbm9kZV9kaXJ0eShoYW5kbGUsIGlub2RlLCBkaV9iaCk7DQogwqDCoMKgwqDC
oMKgwqAgaWYgKHJldCA8IDApDQoNClRoYW5rcywNCg0KSnVueGlhby4NCg0KT24gNS8yNC8yMSA3
OjA0IFBNLCBKb3NlcGggUWkgd3JvdGU6DQo+IFRoYW5rcyBmb3IgdGhlIGV4cGxhbmF0aW9ucy4N
Cj4gQSB0aW55IGNsZWFudXAsIHdlIGNhbiB1c2UgJ29yaWdfaXNpemUnIGluc3RlYWQgb2YgaV9z
aXplX3JlYWQoKSBsYXRlcg0KPiBpbiBfX29jZnMyX2NoYW5nZV9maWxlX3NwYWNlKCkuDQo+IE90
aGVyIGxvb2tzIGdvb2QgdG8gbWUuDQo+IFJldmlld2VkLWJ5OiBKb3NlcGggUWkgPGpvc2VwaC5x
aUBsaW51eC5hbGliYWJhLmNvbT4NCj4NCj4gT24gNS8yNS8yMSAxMjoyMyBBTSwgSnVueGlhbyBC
aSB3cm90ZToNCj4+IFRoYXQgd2lsbCBub3Qgd29yaywgYnVmZmVyIHdyaXRlIHplcm8gZmlyc3Qs
IHRoZW4gdXBkYXRlIGlfc2l6ZSwgaW4gYmV0d2VlbiB3cml0ZWJhY2sgY291bGQgYmUga2lja2Vk
IGluIGFuZCBjbGVhciB0aG9zZSBkaXJ0eSBidWZmZXJzIGJlY2F1c2UgdGhleSB3ZXJlIG91dCBv
ZiBpX3NpemUuIEJlc2lkZSB0aGF0LCBPQ0ZTMl9JT0NfUkVTVlNQNjQgd2FzIG5ldmVyIGRvaW5n
IHJpZ2h0IGpvYiwgaXQgZGlkbid0IHRha2UgY2FyZSBlb2YgYmxvY2tzIGluIHRoZSBsYXN0IGNs
dXN0ZXIsIHRoYXQgbWFkZSBldmVuIGEgc2ltcGxlIGZhbGxvY2F0ZSB0byBleHRlbmQgZmlsZSBz
aXplIGNvdWxkIGNhdXNlIGNvcnJ1cHRpb24uIFRoaXMgcGF0Y2ggZml4ZWQgYm90aCBpc3N1ZXMu
DQo+Pg0KPj4gVGhhbmtzLA0KPj4NCj4+IEp1bnhpYW8uDQo+Pg0KPj4gT24gNS8yMy8yMSA0OjUy
IEFNLCBKb3NlcGggUWkgd3JvdGU6DQo+Pj4gSGkgSnVueGlhbywNCj4+PiBJZiBjaGFuZ2Vfc2l6
ZSBpcyB0cnVlICghRkFMTE9DX0ZMX0tFRVBfU0laRSksIGl0IHdpbGwgdXBkYXRlIGlzaXplDQo+
Pj4gaW4gX19vY2ZzMl9jaGFuZ2VfZmlsZV9zcGFjZSgpLiBXaHkgZG8gd2UgaGF2ZSB0byB6ZXJv
b3V0IGZpcnN0Pw0KPj4+DQo+Pj4gVGhhbmtzLA0KPj4+IEpvc2VwaA0KPj4+DQo+Pj4gT24gNS8y
Mi8yMSA3OjM2IEFNLCBKdW54aWFvIEJpIHdyb3RlOg0KPj4+PiBXaGVuIGZhbGxvY2F0ZSBwdW5j
aGVzIGhvbGVzIG91dCBvZiBpbm9kZSBzaXplLCBpZiBvcmlnaW5hbCBpc2l6ZSBpcyBpbg0KPj4+
PiB0aGUgbWlkZGxlIG9mIGxhc3QgY2x1c3RlciwgdGhlbiB0aGUgcGFydCBmcm9tIGlzaXplIHRv
IHRoZSBlbmQgb2YgdGhlDQo+Pj4+IGNsdXN0ZXIgd2lsbCBiZSB6ZXJvZWQgd2l0aCBidWZmZXIg
d3JpdGUsIGF0IHRoYXQgdGltZSBpc2l6ZSBpcyBub3QNCj4+Pj4geWV0IHVwZGF0ZWQgdG8gbWF0
Y2ggdGhlIG5ldyBzaXplLCBpZiB3cml0ZWJhY2sgaXMga2lja2VkIGluLCBpdCB3aWxsDQo+Pj4+
IGludm9rZSBvY2ZzMl93cml0ZXBhZ2UoKS0+YmxvY2tfd3JpdGVfZnVsbF9wYWdlKCkgd2hlcmUg
dGhlIHBhZ2VzIG91dA0KPj4+PiBvZiBpbm9kZSBzaXplIHdpbGwgYmUgZHJvcHBlZC4gVGhhdCB3
aWxsIGNhdXNlIGZpbGUgY29ycnVwdGlvbi4gRml4DQo+Pj4+IHRoaXMgYnkgemVybyBvdXQgZW9m
IGJsb2NrcyB3aGVuIGV4dGVuZGluZyB0aGUgaW5vZGUgc2l6ZS4NCj4+Pj4NCj4+Pj4gUnVubmlu
ZyB0aGUgZm9sbG93aW5nIGNvbW1hbmQgd2l0aCBxZW11LWltYWdlIDQuMi4xIGNhbiBnZXQgYSBj
b3JydXB0ZWQNCj4+Pj4gY292ZXJ0ZWQgaW1hZ2UgZmlsZSBlYXNpbHkuDQo+Pj4+DQo+Pj4+ICDC
oMKgwqDCoCBxZW11LWltZyBjb252ZXJ0IC1wIC10IG5vbmUgLVQgbm9uZSAtZiBxY293MiAkcWNv
d19pbWFnZSBcDQo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtTyBxY293MiAtbyBj
b21wYXQ9MS4xICRxY293X2ltYWdlLmNvbnYNCj4+Pj4NCj4+Pj4gVGhlIHVzYWdlIG9mIGZhbGxv
Y2F0ZSBpbiBxZW11IGlzIGxpa2UgdGhpcywgaXQgZmlyc3QgcHVuY2hlcyBob2xlcyBvdXQgb2YN
Cj4+Pj4gaW5vZGUgc2l6ZSwgdGhlbiBleHRlbmQgdGhlIGlub2RlIHNpemUuDQo+Pj4+DQo+Pj4+
ICDCoMKgwqDCoCBmYWxsb2NhdGUoMTEsIEZBTExPQ19GTF9LRUVQX1NJWkV8RkFMTE9DX0ZMX1BV
TkNIX0hPTEUsIDIyNzYxOTYzNTIsIDY1NTM2KSA9IDANCj4+Pj4gIMKgwqDCoMKgIGZhbGxvY2F0
ZSgxMSwgMCwgMjI3NjE5NjM1MiwgNjU1MzYpID0gMA0KPj4+Pg0KPj4+PiB2MTogaHR0cHM6Ly93
d3cuc3Bpbmljcy5uZXQvbGlzdHMvbGludXgtZnNkZXZlbC9tc2cxOTM5OTkuaHRtbA0KPj4+Pg0K
Pj4+PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+Pj4+IENjOiBKYW4gS2FyYSA8amFj
a0BzdXNlLmN6Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBKdW54aWFvIEJpIDxqdW54aWFvLmJpQG9y
YWNsZS5jb20+DQo+Pj4+IC0tLQ0KPj4+Pg0KPj4+PiBDaGFuZ2VzIGluIHYyOg0KPj4+PiAtIHN1
Z2dlc3RlZCBieSBKYW4gS2FyYSwgdXNpbmcgc2JfaXNzdWVfemVyb291dCB0byB6ZXJvIGVvZiBi
bG9ja3MgaW4gZGlzayBkaXJlY3RseS4NCj4+Pj4NCj4+Pj4gIMKgIGZzL29jZnMyL2ZpbGUuYyB8
IDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4+
Pj4gIMKgIDEgZmlsZSBjaGFuZ2VkLCA0NyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0K
Pj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvZmlsZS5jIGIvZnMvb2NmczIvZmlsZS5j
DQo+Pj4+IGluZGV4IGYxN2MzZDMzZmIxOC4uMTc0NjlmYzdiMjBlIDEwMDY0NA0KPj4+PiAtLS0g
YS9mcy9vY2ZzMi9maWxlLmMNCj4+Pj4gKysrIGIvZnMvb2NmczIvZmlsZS5jDQo+Pj4+IEBAIC0x
ODU1LDYgKzE4NTUsNDUgQEAgaW50IG9jZnMyX3JlbW92ZV9pbm9kZV9yYW5nZShzdHJ1Y3QgaW5v
ZGUgKmlub2RlLA0KPj4+PiAgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPj4+PiAgwqAgfQ0KPj4+
PiAgwqAgKy8qDQo+Pj4+ICsgKiB6ZXJvIG91dCBwYXJ0aWFsIGJsb2NrcyBvZiBvbmUgY2x1c3Rl
ci4NCj4+Pj4gKyAqDQo+Pj4+ICsgKiBzdGFydDogZmlsZSBvZmZzZXQgd2hlcmUgemVybyBzdGFy
dHMsIHdpbGwgYmUgbWFkZSB1cHBlciBibG9jayBhbGlnbmVkLg0KPj4+PiArICogbGVuOiBpdCB3
aWxsIGJlIHRyaW1tZWQgdG8gdGhlIGVuZCBvZiBjdXJyZW50IGNsdXN0ZXIgaWYgInN0YXJ0ICsg
bGVuIg0KPj4+PiArICrCoMKgwqDCoMKgIGlzIGJpZ2dlciB0aGFuIGl0Lg0KPj4+PiArICovDQo+
Pj4+ICtzdGF0aWMgaW50IG9jZnMyX3plcm9vdXRfcGFydGlhbF9jbHVzdGVyKHN0cnVjdCBpbm9k
ZSAqaW5vZGUsDQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1
NjQgc3RhcnQsIHU2NCBsZW4pDQo+Pj4+ICt7DQo+Pj4+ICvCoMKgwqAgaW50IHJldDsNCj4+Pj4g
K8KgwqDCoCB1NjQgc3RhcnRfYmxvY2ssIGVuZF9ibG9jaywgbnJfYmxvY2tzOw0KPj4+PiArwqDC
oMKgIHU2NCBwX2Jsb2NrLCBvZmZzZXQ7DQo+Pj4+ICvCoMKgwqAgdTMyIGNsdXN0ZXIsIHBfY2x1
c3RlciwgbnJfY2x1c3RlcnM7DQo+Pj4+ICvCoMKgwqAgc3RydWN0IHN1cGVyX2Jsb2NrICpzYiA9
IGlub2RlLT5pX3NiOw0KPj4+PiArwqDCoMKgIHU2NCBlbmQgPSBvY2ZzMl9hbGlnbl9ieXRlc190
b19jbHVzdGVycyhzYiwgc3RhcnQpOw0KPj4+PiArDQo+Pj4+ICvCoMKgwqAgaWYgKHN0YXJ0ICsg
bGVuIDwgZW5kKQ0KPj4+PiArwqDCoMKgwqDCoMKgwqAgZW5kID0gc3RhcnQgKyBsZW47DQo+Pj4+
ICsNCj4+Pj4gK8KgwqDCoCBzdGFydF9ibG9jayA9IG9jZnMyX2Jsb2Nrc19mb3JfYnl0ZXMoc2Is
IHN0YXJ0KTsNCj4+Pj4gK8KgwqDCoCBlbmRfYmxvY2sgPSBvY2ZzMl9ibG9ja3NfZm9yX2J5dGVz
KHNiLCBlbmQpOw0KPj4+PiArwqDCoMKgIG5yX2Jsb2NrcyA9IGVuZF9ibG9jayAtIHN0YXJ0X2Js
b2NrOw0KPj4+PiArwqDCoMKgIGlmICghbnJfYmxvY2tzKQ0KPj4+PiArwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIDA7DQo+Pj4+ICsNCj4+Pj4gK8KgwqDCoCBjbHVzdGVyID0gb2NmczJfYnl0ZXNfdG9f
Y2x1c3RlcnMoc2IsIHN0YXJ0KTsNCj4+Pj4gK8KgwqDCoCByZXQgPSBvY2ZzMl9nZXRfY2x1c3Rl
cnMoaW5vZGUsIGNsdXN0ZXIsICZwX2NsdXN0ZXIsDQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgJm5yX2NsdXN0ZXJzLCBOVUxMKTsNCj4+Pj4gK8KgwqDCoCBpZiAocmV0KQ0K
Pj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4+Pj4gK8KgwqDCoCBpZiAoIXBfY2x1
c3RlcikNCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAwOw0KPj4+PiArDQo+Pj4+ICvCoMKg
wqAgb2Zmc2V0ID0gc3RhcnRfYmxvY2sgLSBvY2ZzMl9jbHVzdGVyc190b19ibG9ja3Moc2IsIGNs
dXN0ZXIpOw0KPj4+PiArwqDCoMKgIHBfYmxvY2sgPSBvY2ZzMl9jbHVzdGVyc190b19ibG9ja3Mo
c2IsIHBfY2x1c3RlcikgKyBvZmZzZXQ7DQo+Pj4+ICvCoMKgwqAgcmV0dXJuIHNiX2lzc3VlX3pl
cm9vdXQoc2IsIHBfYmxvY2ssIG5yX2Jsb2NrcywgR0ZQX05PRlMpOw0KPj4+PiArfQ0KPj4+PiAr
DQo+Pj4+ICDCoCAvKg0KPj4+PiAgwqDCoCAqIFBhcnRzIG9mIHRoaXMgZnVuY3Rpb24gdGFrZW4g
ZnJvbSB4ZnNfY2hhbmdlX2ZpbGVfc3BhY2UoKQ0KPj4+PiAgwqDCoCAqLw0KPj4+PiBAQCAtMTg2
NSw3ICsxOTA0LDcgQEAgc3RhdGljIGludCBfX29jZnMyX2NoYW5nZV9maWxlX3NwYWNlKHN0cnVj
dCBmaWxlICpmaWxlLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPj4+PiAgwqAgew0KPj4+PiAgwqDC
oMKgwqDCoCBpbnQgcmV0Ow0KPj4+PiAgwqDCoMKgwqDCoCBzNjQgbGxlbjsNCj4+Pj4gLcKgwqDC
oCBsb2ZmX3Qgc2l6ZTsNCj4+Pj4gK8KgwqDCoCBsb2ZmX3Qgc2l6ZSwgb3JpZ19pc2l6ZTsNCj4+
Pj4gIMKgwqDCoMKgwqAgc3RydWN0IG9jZnMyX3N1cGVyICpvc2IgPSBPQ0ZTMl9TQihpbm9kZS0+
aV9zYik7DQo+Pj4+ICDCoMKgwqDCoMKgIHN0cnVjdCBidWZmZXJfaGVhZCAqZGlfYmggPSBOVUxM
Ow0KPj4+PiAgwqDCoMKgwqDCoCBoYW5kbGVfdCAqaGFuZGxlOw0KPj4+PiBAQCAtMTg5Niw2ICsx
OTM1LDcgQEAgc3RhdGljIGludCBfX29jZnMyX2NoYW5nZV9maWxlX3NwYWNlKHN0cnVjdCBmaWxl
ICpmaWxlLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgIGdv
dG8gb3V0X2lub2RlX3VubG9jazsNCj4+Pj4gIMKgwqDCoMKgwqAgfQ0KPj4+PiAgwqAgK8KgwqDC
oCBvcmlnX2lzaXplID0gaV9zaXplX3JlYWQoaW5vZGUpOw0KPj4+PiAgwqDCoMKgwqDCoCBzd2l0
Y2ggKHNyLT5sX3doZW5jZSkgew0KPj4+PiAgwqDCoMKgwqDCoCBjYXNlIDA6IC8qU0VFS19TRVQq
Lw0KPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+PiBAQCAtMTkwMyw3ICsxOTQz
LDcgQEAgc3RhdGljIGludCBfX29jZnMyX2NoYW5nZV9maWxlX3NwYWNlKHN0cnVjdCBmaWxlICpm
aWxlLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgIHNyLT5s
X3N0YXJ0ICs9IGZfcG9zOw0KPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+PiAg
wqDCoMKgwqDCoCBjYXNlIDI6IC8qU0VFS19FTkQqLw0KPj4+PiAtwqDCoMKgwqDCoMKgwqAgc3It
Pmxfc3RhcnQgKz0gaV9zaXplX3JlYWQoaW5vZGUpOw0KPj4+PiArwqDCoMKgwqDCoMKgwqAgc3It
Pmxfc3RhcnQgKz0gb3JpZ19pc2l6ZTsNCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsN
Cj4+Pj4gIMKgwqDCoMKgwqAgZGVmYXVsdDoNCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoCByZXQg
PSAtRUlOVkFMOw0KPj4+PiBAQCAtMTk1Nyw2ICsxOTk3LDExIEBAIHN0YXRpYyBpbnQgX19vY2Zz
Ml9jaGFuZ2VfZmlsZV9zcGFjZShzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGlub2RlICppbm9k
ZSwNCj4+Pj4gIMKgwqDCoMKgwqAgZGVmYXVsdDoNCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXQgPSAtRUlOVkFMOw0KPj4+PiAgwqDCoMKgwqDCoCB9DQo+Pj4+ICsNCj4+Pj4gK8KgwqDCoCAv
KiB6ZXJvb3V0IGVvZiBibG9ja3MgaW4gdGhlIGNsdXN0ZXIuICovDQo+Pj4+ICvCoMKgwqAgaWYg
KCFyZXQgJiYgY2hhbmdlX3NpemUgJiYgb3JpZ19pc2l6ZSA8IHNpemUpDQo+Pj4+ICvCoMKgwqDC
oMKgwqDCoCByZXQgPSBvY2ZzMl96ZXJvb3V0X3BhcnRpYWxfY2x1c3Rlcihpbm9kZSwgb3JpZ19p
c2l6ZSwNCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemUg
LSBvcmlnX2lzaXplKTsNCj4+Pj4gIMKgwqDCoMKgwqAgdXBfd3JpdGUoJk9DRlMyX0koaW5vZGUp
LT5pcF9hbGxvY19zZW0pOw0KPj4+PiAgwqDCoMKgwqDCoCBpZiAocmV0KSB7DQo+Pj4+ICDCoMKg
wqDCoMKgwqDCoMKgwqAgbWxvZ19lcnJubyhyZXQpOw0KPj4+Pg0KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9j
ZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9s
aXN0aW5mby9vY2ZzMi1kZXZlbA==
