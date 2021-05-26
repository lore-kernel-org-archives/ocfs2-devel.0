Return-Path: <SRS0=dXbG=KV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15AEC2B9F7
	for <ocfs2-devel@archiver.kernel.org>; Wed, 26 May 2021 05:18:22 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 32EBD6135F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 26 May 2021 05:18:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32EBD6135F
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q5F83q195111;
	Wed, 26 May 2021 05:18:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=mF50NsnIGy8KUB1NSWGFxR4iA3jjlA5xInLJ017SGWs=;
 b=fDuiARlmO1qslwVxmxdmDoziMZzJd3CMN5rffZSSgqCKbpUeOE94j94a9U3mW+uYLXrN
 7zzVhOeZWLlSYnbFu7hfpTKvA89QjQQ9G3L69aufVxkCI58GD7XMWqXhTrAs0F3Qt3I0
 RrgwEo6BHVkqn42JKjiSolMuRWlHMSadgXBKHzscYVXJWe2qKOw1mkC4ngmquy0jmVUf
 eIaf9EAJdHXGh1fEo7ahR/NydDA03ZuXYV5FY1RhcO2CfNHG3U2ygxjiz1gaoFWOn4U5
 2o7JfGjNHdRBi9ZKauGY9/4X6KPbCbLxRnKkq9cxY+VL0+eyOGqj0l5LuBKhpXn4pJr/ XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 38rne43dw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 May 2021 05:18:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q5FI0M058814;
	Wed, 26 May 2021 05:18:20 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38pq2uxt1e-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 26 May 2021 05:18:19 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lllpo-0005OK-R9; Tue, 25 May 2021 22:12:00 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lllpl-0005Nu-Lq
	for ocfs2-devel@oss.oracle.com; Tue, 25 May 2021 22:11:57 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14Q54tMD103855
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 05:11:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by aserp3020.oracle.com with ESMTP id 38rehbw36k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 05:11:57 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB2599.namprd10.prod.outlook.com (2603:10b6:a02:b2::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Wed, 26 May 2021 05:11:55 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9%6]) with mapi id 15.20.4150.027;
	Wed, 26 May 2021 05:11:55 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20210521233612.75185-1-junxiao.bi@oracle.com>
	<35a1d32b-b8d7-ea9b-d28c-6b4fd837605d@linux.alibaba.com>
	<8aa90f5d-e4db-5107-1d3c-383294871196@oracle.com>
	<21d8b289-541d-50f5-6f86-de3ee69c56c5@linux.alibaba.com>
	<35283832-3294-19e0-6542-d1f925711fe8@oracle.com>
	<cbeec344-adb3-0dc4-51ee-4716c07176f3@linux.alibaba.com>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <297dcd1e-c741-007e-8f53-77eba9656e74@oracle.com>
Date: Tue, 25 May 2021 22:10:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <cbeec344-adb3-0dc4-51ee-4716c07176f3@linux.alibaba.com>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: BY5PR13CA0022.namprd13.prod.outlook.com
	(2603:10b6:a03:180::35) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-238-224.vpn.oracle.com (73.231.9.254) by
	BY5PR13CA0022.namprd13.prod.outlook.com (2603:10b6:a03:180::35)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12
	via Frontend Transport; Wed, 26 May 2021 05:11:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af4e0a79-5d1f-4cf6-34c6-08d92004c7e5
X-MS-TrafficTypeDiagnostic: BYAPR10MB2599:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: slL8QFQX5neDLIkOoN/ONQxiswmkb+VZTulrrqKgh5f3o7+CSyZD8FgvDLCuEgVTmbMjTvbwpvK+Pwiomob4mLB9RBB6Fd/cSL7leSlQ4FaXhMTLgzh/Ri4ge2DliB6D5irUU8VaNBOMHa/iJF8DqKsJPkXhtfj55ReGJSmbxqZynpskTe9hJx9tXd4lbehGfjPMudF52w06rPGWfEnqWzxLDvBrTzD7as8nOUkd7Imlm38irW2w0EoNlmNZftEy6geCgAy7Abv1PeIHHOQJtg/+HZg8IyNhGFU3nQHPFPz2v6FFgutQwsN5pdfVulRvhCoVzUuKflyZZH5B46yrPaOglWq7eCVPgjYwldD3VJaJqisNIVieqfc0+zYdqeWnWxpWBy4xCxDOQcNuMO+h9eGrRvM/pIKKWOKlav0j1D/whjiZnfddli3mWR27xX/Ce/OnO6fGT1zRB6pB6zf8iRqE5PmT2dLrb6NRpZBWWeYxbmrW1ozZ2E20g5dq2emq98Io/d8wvCwaluxeQWhY6UgR6gQfnexSCbSYv0PAKqcCSMSbrkRqSuVVmAsxqw5sG4iiKzNVPXCZoi1j0IuOtUK/KkyCjSKc3SxdiS0BXkZVEwHC4TvD/QGKZj8Gjrhh2ZN6cxu2DMDd84G6WL1lJzMgsWZGuIFYARj8i7VZJV8=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dGRQL1RpRFRhYnJJQUN0ajVXT3FKdVRtaDg2VENuYVQyRFJzeVQ3VkJjdTh4?=
	=?utf-8?B?WEorVFlLYlhnUjd1bWU0bzZDSTFiMnB5OTV2VE1YQll4OHdOR1JqQ1ZqSks2?=
	=?utf-8?B?clRndzZTV1hmSEg2SXpab1pPWmxuS2owWUY4SGVnNkpBajJJRTlnMWZDZkw0?=
	=?utf-8?B?aE1OOW91UVVOMXFRVFhkZHZPUFZXdE1zYWpJdjgxdHpDVjJzNE1ldyt0K0Nw?=
	=?utf-8?B?WEN5QldrMTBZS2RHczdqelUvcEhDenVsQ25wc1pDMnVRa2VvL2xLUzVGVzli?=
	=?utf-8?B?Q1RwcVRvZnd1dUEyWXI0QUN4bzd1YU8wMXdMSlhYdXN6WVcydXh6eU1vOENV?=
	=?utf-8?B?bFNack1VazFFek5CY2JrSGZhSzNSbkZZaWlXOEtNL1hOdFY4Mkp4M2I5b3Bj?=
	=?utf-8?B?VEIyUktuQkxyYU5aMno3YnRsaHF4NUxINmxxMmNjYTNUNkNrODBPdFJTMEN6?=
	=?utf-8?B?Y3c0YnlqcUcvWlowRnl4b1VmVC9HSGo5RmhFZXErSDRtRzIzS0N4L1hzZWhG?=
	=?utf-8?B?MUtoTlYxK0o2Zk1JUTZCRk9VVkRta2JWeEwya3hFeWxLYXhaUnNvQzByUUg3?=
	=?utf-8?B?QmJVcEp2Mzd1MnB4UUNPVHRGcGhtMTEyZW5xVTlrSTJtdTY1Z3FWSFNuVDJM?=
	=?utf-8?B?b0ZYUHdLQk4xT3EzZ0hKQUlZeW1ZaWR2Q0k1OXdYZTJmTldNZllseUFrUTNh?=
	=?utf-8?B?amlWd3kvckxMV2grMjV5dG0ycGxVSXJPMy9WenFpRGhva3padHQzVDcrVEE1?=
	=?utf-8?B?Q0JBb1cweFI3bkExZDM0VVBNcmI1OTU4VGFjTlQ4KzdXWFdUbXlySnB3NmRy?=
	=?utf-8?B?YWxRU0RZKy9uMHBWWjNhZzYxbXhwWE5ERGVRZEpkbEZxaW94MWRwWEFYQXhD?=
	=?utf-8?B?RGkxbVIvUEE3ZEpjYkJoTDU4anFWd204cU12TnVKV1NHaExuM1Avb1hsUWF5?=
	=?utf-8?B?Z1QvK2t1K0ZhTUdLUEYzYnhpRVFpdURrZnJ5ZHlTL0owbnpRSkZqRGl5WTVD?=
	=?utf-8?B?VFRmNXFKZnFCcGFQaWRSZllBKy9jS0lJdWhoeUZyeWJidCs4Vllrak05ZENm?=
	=?utf-8?B?ZVR6YXA1SHZ2SElHOHE2ZlZoRGFvZWN5VWRJeTBJbVJ5TWhlQ3UxTE5lT1VD?=
	=?utf-8?B?ODNZUDRtZnBIeHk2VE5VZ3p5dGI0WWlhQUUzeFgwd0UxU09tR2NkanR6NG9K?=
	=?utf-8?B?UGRUSW1ibjV0TTV2NkRsVTZVUGlmZkJ2c3Z1dnRjRmdsNDdIMnpqdHRrRC9D?=
	=?utf-8?B?T0JES0l1ZXpCYWxIUjhFb1pPVDMwODdsT1lGQ0ZZTU9ELzFXRk5DYlNkNzdI?=
	=?utf-8?B?WVpWOVMvSk5qKzRFcUhJME96VDRrNG1QREJjRitYdHUweU1TVjhXNzFueGlt?=
	=?utf-8?B?SC83YTJnSmowcXNQL2NTZnJVMFRJUEZWajBoem5yeXUwZ2tPcnRTVklGMUQx?=
	=?utf-8?B?ZXZlSFJrYlc5YXlvcjE0UFFKaEx3b0ltakZ3eU5aK3JoSmQrMWJTbExNODJY?=
	=?utf-8?B?TXN3N2tBMVRyajBXUmF5YTVHUE9KY2ZQNmlTUHRzRUtGVFAxQUJ5MnhzKzc3?=
	=?utf-8?B?VlE1bkZyTlRNczJTOFdMeFJMUjB5MmlrSkFOSVhEWHNidTkzSGVxQWpZSUNJ?=
	=?utf-8?B?ZTB3cURtQ2p4bUlQa0MxRUtpVzNBa3BMTFNPUkE1NnFXR3lZcFQ3QXlIaWVL?=
	=?utf-8?B?MHp0enVmek5RaVdyZDZZb3R3V0RBTzJTVE00TmV5YWVINFpacjVraXlkbGdL?=
	=?utf-8?Q?Bho58ENdRo3EFSoSvHvEDPT7OFY1PfbxiX4AByP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af4e0a79-5d1f-4cf6-34c6-08d92004c7e5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 05:11:55.7292 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JbLJJXjnyTS1M42Jkk5L0fW+/aIEL0edAIaE29sHVVvuvc2zF1jCacvoWC+HdUnzV5LTerNcfvNK+Ez75qz7SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2599
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
X-OrganizationHeadersPreserved: BYAPR10MB2599.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	spamscore=0 adultscore=0
	mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105260033
X-MIME-Autoconverted: from 8bit to base64 by aserp3020.oracle.com id
	14Q54tMD103855
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260034
X-Proofpoint-ORIG-GUID: 3aBdCU4ToBiGQ848iRAVJj0BcfoVc0vb
X-Proofpoint-GUID: 3aBdCU4ToBiGQ848iRAVJj0BcfoVc0vb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260034

QWZ0ZXIgbW92aW5nIHRoZXJlLCBpX3NpemVfd3JpdGUgd2lsbCBiZSBwcm90ZWN0ZWQgYnkgaXBf
YWxsb2Nfc2VtLCANCm9jZnMyX2Rpb19lbmRfaW9fd3JpdGUgd2lsbCB1cGRhdGUgaV9zaXplIHdp
dGhvdXQgaG9sZGluZyBpbm9kZSBsb2NrLCANCmJ1dCBpdCBkb2VzIGhvbGRpbmcgaXBfYWxsb2Nf
c2VtLg0KDQpUaGFua3MsDQoNCkp1bnhpYW8uDQoNCk9uIDUvMjUvMjEgNzoxMSBQTSwgSm9zZXBo
IFFpIHdyb3RlOg0KPiBDYW4gd2Ugc2ltcGx5IHJlcGxhY2UgaV9zaXplX3JlYWQoKSB3aXRoICdv
cmlnX2lzaXplJyBhbmQgbGVhdmUgaXNpemUNCj4gdXBkYXRlIGFsb25nIHdpdGggb3RoZXIgZGly
dHkgaW5vZGUgb3BlcmF0aW9ucz8NCj4gSSB0aGluayB0aGlzIG1ha2VzIG1vcmUgY29tZm9ydGFi
bGUgZm9yIHRoZSBkaXJ0eSBpbm9kZSB0cmFuc2FjdGlvbi4NCj4NCj4gVGhhbmtzLA0KPiBKb3Nl
cGgNCj4NCj4gT24gNS8yNi8yMSAxOjU4IEFNLCBKdW54aWFvIEJpIHdyb3RlOg0KPj4gSSB3b3Vs
ZCBsaWtlIG1ha2UgdGhlIGZvbGxvd2luZyBjaGFuZ2UgdG8gdGhlIHBhdGNoLCBpcyB0aGF0IG9r
IHRvIHlvdT8NCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvZmlsZS5jIGIvZnMvb2NmczIv
ZmlsZS5jDQo+PiBpbmRleCAxNzQ2OWZjN2IyMGUuLjc3NTY1Nzk0MzA1NyAxMDA2NDQNCj4+IC0t
LSBhL2ZzL29jZnMyL2ZpbGUuYw0KPj4gKysrIGIvZnMvb2NmczIvZmlsZS5jDQo+PiBAQCAtMTk5
OSw5ICsxOTk5LDEyIEBAIHN0YXRpYyBpbnQgX19vY2ZzMl9jaGFuZ2VfZmlsZV9zcGFjZShzdHJ1
Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGlub2RlICppbm9kZSwNCj4+ICDCoMKgwqDCoMKgwqDCoCB9
DQo+Pg0KPj4gIMKgwqDCoMKgwqDCoMKgIC8qIHplcm9vdXQgZW9mIGJsb2NrcyBpbiB0aGUgY2x1
c3Rlci4gKi8NCj4+IC3CoMKgwqDCoMKgwqAgaWYgKCFyZXQgJiYgY2hhbmdlX3NpemUgJiYgb3Jp
Z19pc2l6ZSA8IHNpemUpDQo+PiArwqDCoMKgwqDCoMKgIGlmICghcmV0ICYmIGNoYW5nZV9zaXpl
ICYmIG9yaWdfaXNpemUgPCBzaXplKSB7DQo+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHJldCA9IG9jZnMyX3plcm9vdXRfcGFydGlhbF9jbHVzdGVyKGlub2RlLCBvcmlnX2lzaXpl
LA0KPj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzaXplIC0gb3JpZ19pc2l6ZSk7DQo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIXJldCkNCj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpX3NpemVfd3JpdGUoaW5vZGUsIHNpemUpOw0K
Pj4gK8KgwqDCoMKgwqDCoCB9DQo+PiAgwqDCoMKgwqDCoMKgwqAgdXBfd3JpdGUoJk9DRlMyX0ko
aW5vZGUpLT5pcF9hbGxvY19zZW0pOw0KPj4gIMKgwqDCoMKgwqDCoMKgIGlmIChyZXQpIHsNCj4+
ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWxvZ19lcnJubyhyZXQpOw0KPj4gQEAg
LTIwMTgsOSArMjAyMSw2IEBAIHN0YXRpYyBpbnQgX19vY2ZzMl9jaGFuZ2VfZmlsZV9zcGFjZShz
dHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGlub2RlICppbm9kZSwNCj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXRfaW5vZGVfdW5sb2NrOw0KPj4gIMKgwqDCoMKgwqDC
oMKgIH0NCj4+DQo+PiAtwqDCoMKgwqDCoMKgIGlmIChjaGFuZ2Vfc2l6ZSAmJiBpX3NpemVfcmVh
ZChpbm9kZSkgPCBzaXplKQ0KPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaV9zaXpl
X3dyaXRlKGlub2RlLCBzaXplKTsNCj4+IC0NCj4+ICDCoMKgwqDCoMKgwqDCoCBpbm9kZS0+aV9j
dGltZSA9IGlub2RlLT5pX210aW1lID0gY3VycmVudF90aW1lKGlub2RlKTsNCj4+ICDCoMKgwqDC
oMKgwqDCoCByZXQgPSBvY2ZzMl9tYXJrX2lub2RlX2RpcnR5KGhhbmRsZSwgaW5vZGUsIGRpX2Jo
KTsNCj4+ICDCoMKgwqDCoMKgwqDCoCBpZiAocmV0IDwgMCkNCj4+DQo+PiBUaGFua3MsDQo+Pg0K
Pj4gSnVueGlhby4NCj4+DQo+PiBPbiA1LzI0LzIxIDc6MDQgUE0sIEpvc2VwaCBRaSB3cm90ZToN
Cj4+PiBUaGFua3MgZm9yIHRoZSBleHBsYW5hdGlvbnMuDQo+Pj4gQSB0aW55IGNsZWFudXAsIHdl
IGNhbiB1c2UgJ29yaWdfaXNpemUnIGluc3RlYWQgb2YgaV9zaXplX3JlYWQoKSBsYXRlcg0KPj4+
IGluIF9fb2NmczJfY2hhbmdlX2ZpbGVfc3BhY2UoKS4NCj4+PiBPdGhlciBsb29rcyBnb29kIHRv
IG1lLg0KPj4+IFJldmlld2VkLWJ5OiBKb3NlcGggUWkgPGpvc2VwaC5xaUBsaW51eC5hbGliYWJh
LmNvbT4NCj4+Pg0KPj4+IE9uIDUvMjUvMjEgMTI6MjMgQU0sIEp1bnhpYW8gQmkgd3JvdGU6DQo+
Pj4+IFRoYXQgd2lsbCBub3Qgd29yaywgYnVmZmVyIHdyaXRlIHplcm8gZmlyc3QsIHRoZW4gdXBk
YXRlIGlfc2l6ZSwgaW4gYmV0d2VlbiB3cml0ZWJhY2sgY291bGQgYmUga2lja2VkIGluIGFuZCBj
bGVhciB0aG9zZSBkaXJ0eSBidWZmZXJzIGJlY2F1c2UgdGhleSB3ZXJlIG91dCBvZiBpX3NpemUu
IEJlc2lkZSB0aGF0LCBPQ0ZTMl9JT0NfUkVTVlNQNjQgd2FzIG5ldmVyIGRvaW5nIHJpZ2h0IGpv
YiwgaXQgZGlkbid0IHRha2UgY2FyZSBlb2YgYmxvY2tzIGluIHRoZSBsYXN0IGNsdXN0ZXIsIHRo
YXQgbWFkZSBldmVuIGEgc2ltcGxlIGZhbGxvY2F0ZSB0byBleHRlbmQgZmlsZSBzaXplIGNvdWxk
IGNhdXNlIGNvcnJ1cHRpb24uIFRoaXMgcGF0Y2ggZml4ZWQgYm90aCBpc3N1ZXMuDQo+Pj4+DQo+
Pj4+IFRoYW5rcywNCj4+Pj4NCj4+Pj4gSnVueGlhby4NCj4+Pj4NCj4+Pj4gT24gNS8yMy8yMSA0
OjUyIEFNLCBKb3NlcGggUWkgd3JvdGU6DQo+Pj4+PiBIaSBKdW54aWFvLA0KPj4+Pj4gSWYgY2hh
bmdlX3NpemUgaXMgdHJ1ZSAoIUZBTExPQ19GTF9LRUVQX1NJWkUpLCBpdCB3aWxsIHVwZGF0ZSBp
c2l6ZQ0KPj4+Pj4gaW4gX19vY2ZzMl9jaGFuZ2VfZmlsZV9zcGFjZSgpLiBXaHkgZG8gd2UgaGF2
ZSB0byB6ZXJvb3V0IGZpcnN0Pw0KPj4+Pj4NCj4+Pj4+IFRoYW5rcywNCj4+Pj4+IEpvc2VwaA0K
Pj4+Pj4NCj4+Pj4+IE9uIDUvMjIvMjEgNzozNiBBTSwgSnVueGlhbyBCaSB3cm90ZToNCj4+Pj4+
PiBXaGVuIGZhbGxvY2F0ZSBwdW5jaGVzIGhvbGVzIG91dCBvZiBpbm9kZSBzaXplLCBpZiBvcmln
aW5hbCBpc2l6ZSBpcyBpbg0KPj4+Pj4+IHRoZSBtaWRkbGUgb2YgbGFzdCBjbHVzdGVyLCB0aGVu
IHRoZSBwYXJ0IGZyb20gaXNpemUgdG8gdGhlIGVuZCBvZiB0aGUNCj4+Pj4+PiBjbHVzdGVyIHdp
bGwgYmUgemVyb2VkIHdpdGggYnVmZmVyIHdyaXRlLCBhdCB0aGF0IHRpbWUgaXNpemUgaXMgbm90
DQo+Pj4+Pj4geWV0IHVwZGF0ZWQgdG8gbWF0Y2ggdGhlIG5ldyBzaXplLCBpZiB3cml0ZWJhY2sg
aXMga2lja2VkIGluLCBpdCB3aWxsDQo+Pj4+Pj4gaW52b2tlIG9jZnMyX3dyaXRlcGFnZSgpLT5i
bG9ja193cml0ZV9mdWxsX3BhZ2UoKSB3aGVyZSB0aGUgcGFnZXMgb3V0DQo+Pj4+Pj4gb2YgaW5v
ZGUgc2l6ZSB3aWxsIGJlIGRyb3BwZWQuIFRoYXQgd2lsbCBjYXVzZSBmaWxlIGNvcnJ1cHRpb24u
IEZpeA0KPj4+Pj4+IHRoaXMgYnkgemVybyBvdXQgZW9mIGJsb2NrcyB3aGVuIGV4dGVuZGluZyB0
aGUgaW5vZGUgc2l6ZS4NCj4+Pj4+Pg0KPj4+Pj4+IFJ1bm5pbmcgdGhlIGZvbGxvd2luZyBjb21t
YW5kIHdpdGggcWVtdS1pbWFnZSA0LjIuMSBjYW4gZ2V0IGEgY29ycnVwdGVkDQo+Pj4+Pj4gY292
ZXJ0ZWQgaW1hZ2UgZmlsZSBlYXNpbHkuDQo+Pj4+Pj4NCj4+Pj4+PiAgwqDCoMKgwqDCoCBxZW11
LWltZyBjb252ZXJ0IC1wIC10IG5vbmUgLVQgbm9uZSAtZiBxY293MiAkcWNvd19pbWFnZSBcDQo+
Pj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLU8gcWNvdzIgLW8gY29tcGF0PTEu
MSAkcWNvd19pbWFnZS5jb252DQo+Pj4+Pj4NCj4+Pj4+PiBUaGUgdXNhZ2Ugb2YgZmFsbG9jYXRl
IGluIHFlbXUgaXMgbGlrZSB0aGlzLCBpdCBmaXJzdCBwdW5jaGVzIGhvbGVzIG91dCBvZg0KPj4+
Pj4+IGlub2RlIHNpemUsIHRoZW4gZXh0ZW5kIHRoZSBpbm9kZSBzaXplLg0KPj4+Pj4+DQo+Pj4+
Pj4gIMKgwqDCoMKgwqAgZmFsbG9jYXRlKDExLCBGQUxMT0NfRkxfS0VFUF9TSVpFfEZBTExPQ19G
TF9QVU5DSF9IT0xFLCAyMjc2MTk2MzUyLCA2NTUzNikgPSAwDQo+Pj4+Pj4gIMKgwqDCoMKgwqAg
ZmFsbG9jYXRlKDExLCAwLCAyMjc2MTk2MzUyLCA2NTUzNikgPSAwDQo+Pj4+Pj4NCj4+Pj4+PiB2
MTogaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbGludXgtZnNkZXZlbC9tc2cxOTM5OTku
aHRtbA0KPj4+Pj4+DQo+Pj4+Pj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4+Pj4+
IENjOiBKYW4gS2FyYSA8amFja0BzdXNlLmN6Pg0KPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEp1bnhp
YW8gQmkgPGp1bnhpYW8uYmlAb3JhY2xlLmNvbT4NCj4+Pj4+PiAtLS0NCj4+Pj4+Pg0KPj4+Pj4+
IENoYW5nZXMgaW4gdjI6DQo+Pj4+Pj4gLSBzdWdnZXN0ZWQgYnkgSmFuIEthcmEsIHVzaW5nIHNi
X2lzc3VlX3plcm9vdXQgdG8gemVybyBlb2YgYmxvY2tzIGluIGRpc2sgZGlyZWN0bHkuDQo+Pj4+
Pj4NCj4+Pj4+PiAgwqDCoCBmcy9vY2ZzMi9maWxlLmMgfCA0OSArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+Pj4+Pj4gIMKgwqAgMSBmaWxlIGNoYW5n
ZWQsIDQ3IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+Pj4+Pj4NCj4+Pj4+PiBkaWZm
IC0tZ2l0IGEvZnMvb2NmczIvZmlsZS5jIGIvZnMvb2NmczIvZmlsZS5jDQo+Pj4+Pj4gaW5kZXgg
ZjE3YzNkMzNmYjE4Li4xNzQ2OWZjN2IyMGUgMTAwNjQ0DQo+Pj4+Pj4gLS0tIGEvZnMvb2NmczIv
ZmlsZS5jDQo+Pj4+Pj4gKysrIGIvZnMvb2NmczIvZmlsZS5jDQo+Pj4+Pj4gQEAgLTE4NTUsNiAr
MTg1NSw0NSBAQCBpbnQgb2NmczJfcmVtb3ZlX2lub2RlX3JhbmdlKHN0cnVjdCBpbm9kZSAqaW5v
ZGUsDQo+Pj4+Pj4gIMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPj4+Pj4+ICDCoMKgIH0NCj4+
Pj4+PiAgwqDCoCArLyoNCj4+Pj4+PiArICogemVybyBvdXQgcGFydGlhbCBibG9ja3Mgb2Ygb25l
IGNsdXN0ZXIuDQo+Pj4+Pj4gKyAqDQo+Pj4+Pj4gKyAqIHN0YXJ0OiBmaWxlIG9mZnNldCB3aGVy
ZSB6ZXJvIHN0YXJ0cywgd2lsbCBiZSBtYWRlIHVwcGVyIGJsb2NrIGFsaWduZWQuDQo+Pj4+Pj4g
KyAqIGxlbjogaXQgd2lsbCBiZSB0cmltbWVkIHRvIHRoZSBlbmQgb2YgY3VycmVudCBjbHVzdGVy
IGlmICJzdGFydCArIGxlbiINCj4+Pj4+PiArICrCoMKgwqDCoMKgIGlzIGJpZ2dlciB0aGFuIGl0
Lg0KPj4+Pj4+ICsgKi8NCj4+Pj4+PiArc3RhdGljIGludCBvY2ZzMl96ZXJvb3V0X3BhcnRpYWxf
Y2x1c3RlcihzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB1NjQgc3RhcnQsIHU2NCBsZW4pDQo+Pj4+Pj4gK3sNCj4+Pj4+
PiArwqDCoMKgIGludCByZXQ7DQo+Pj4+Pj4gK8KgwqDCoCB1NjQgc3RhcnRfYmxvY2ssIGVuZF9i
bG9jaywgbnJfYmxvY2tzOw0KPj4+Pj4+ICvCoMKgwqAgdTY0IHBfYmxvY2ssIG9mZnNldDsNCj4+
Pj4+PiArwqDCoMKgIHUzMiBjbHVzdGVyLCBwX2NsdXN0ZXIsIG5yX2NsdXN0ZXJzOw0KPj4+Pj4+
ICvCoMKgwqAgc3RydWN0IHN1cGVyX2Jsb2NrICpzYiA9IGlub2RlLT5pX3NiOw0KPj4+Pj4+ICvC
oMKgwqAgdTY0IGVuZCA9IG9jZnMyX2FsaWduX2J5dGVzX3RvX2NsdXN0ZXJzKHNiLCBzdGFydCk7
DQo+Pj4+Pj4gKw0KPj4+Pj4+ICvCoMKgwqAgaWYgKHN0YXJ0ICsgbGVuIDwgZW5kKQ0KPj4+Pj4+
ICvCoMKgwqDCoMKgwqDCoCBlbmQgPSBzdGFydCArIGxlbjsNCj4+Pj4+PiArDQo+Pj4+Pj4gK8Kg
wqDCoCBzdGFydF9ibG9jayA9IG9jZnMyX2Jsb2Nrc19mb3JfYnl0ZXMoc2IsIHN0YXJ0KTsNCj4+
Pj4+PiArwqDCoMKgIGVuZF9ibG9jayA9IG9jZnMyX2Jsb2Nrc19mb3JfYnl0ZXMoc2IsIGVuZCk7
DQo+Pj4+Pj4gK8KgwqDCoCBucl9ibG9ja3MgPSBlbmRfYmxvY2sgLSBzdGFydF9ibG9jazsNCj4+
Pj4+PiArwqDCoMKgIGlmICghbnJfYmxvY2tzKQ0KPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1
cm4gMDsNCj4+Pj4+PiArDQo+Pj4+Pj4gK8KgwqDCoCBjbHVzdGVyID0gb2NmczJfYnl0ZXNfdG9f
Y2x1c3RlcnMoc2IsIHN0YXJ0KTsNCj4+Pj4+PiArwqDCoMKgIHJldCA9IG9jZnMyX2dldF9jbHVz
dGVycyhpbm9kZSwgY2x1c3RlciwgJnBfY2x1c3RlciwNCj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICZucl9jbHVzdGVycywgTlVMTCk7DQo+Pj4+Pj4gK8KgwqDCoCBpZiAo
cmV0KQ0KPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPj4+Pj4+ICvCoMKgwqAg
aWYgKCFwX2NsdXN0ZXIpDQo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAwOw0KPj4+Pj4+
ICsNCj4+Pj4+PiArwqDCoMKgIG9mZnNldCA9IHN0YXJ0X2Jsb2NrIC0gb2NmczJfY2x1c3RlcnNf
dG9fYmxvY2tzKHNiLCBjbHVzdGVyKTsNCj4+Pj4+PiArwqDCoMKgIHBfYmxvY2sgPSBvY2ZzMl9j
bHVzdGVyc190b19ibG9ja3Moc2IsIHBfY2x1c3RlcikgKyBvZmZzZXQ7DQo+Pj4+Pj4gK8KgwqDC
oCByZXR1cm4gc2JfaXNzdWVfemVyb291dChzYiwgcF9ibG9jaywgbnJfYmxvY2tzLCBHRlBfTk9G
Uyk7DQo+Pj4+Pj4gK30NCj4+Pj4+PiArDQo+Pj4+Pj4gIMKgwqAgLyoNCj4+Pj4+PiAgwqDCoMKg
ICogUGFydHMgb2YgdGhpcyBmdW5jdGlvbiB0YWtlbiBmcm9tIHhmc19jaGFuZ2VfZmlsZV9zcGFj
ZSgpDQo+Pj4+Pj4gIMKgwqDCoCAqLw0KPj4+Pj4+IEBAIC0xODY1LDcgKzE5MDQsNyBAQCBzdGF0
aWMgaW50IF9fb2NmczJfY2hhbmdlX2ZpbGVfc3BhY2Uoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVj
dCBpbm9kZSAqaW5vZGUsDQo+Pj4+Pj4gIMKgwqAgew0KPj4+Pj4+ICDCoMKgwqDCoMKgwqAgaW50
IHJldDsNCj4+Pj4+PiAgwqDCoMKgwqDCoMKgIHM2NCBsbGVuOw0KPj4+Pj4+IC3CoMKgwqAgbG9m
Zl90IHNpemU7DQo+Pj4+Pj4gK8KgwqDCoCBsb2ZmX3Qgc2l6ZSwgb3JpZ19pc2l6ZTsNCj4+Pj4+
PiAgwqDCoMKgwqDCoMKgIHN0cnVjdCBvY2ZzMl9zdXBlciAqb3NiID0gT0NGUzJfU0IoaW5vZGUt
Pmlfc2IpOw0KPj4+Pj4+ICDCoMKgwqDCoMKgwqAgc3RydWN0IGJ1ZmZlcl9oZWFkICpkaV9iaCA9
IE5VTEw7DQo+Pj4+Pj4gIMKgwqDCoMKgwqDCoCBoYW5kbGVfdCAqaGFuZGxlOw0KPj4+Pj4+IEBA
IC0xODk2LDYgKzE5MzUsNyBAQCBzdGF0aWMgaW50IF9fb2NmczJfY2hhbmdlX2ZpbGVfc3BhY2Uo
c3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+Pj4+Pj4gIMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGdvdG8gb3V0X2lub2RlX3VubG9jazsNCj4+Pj4+PiAgwqDCoMKgwqDCoMKg
IH0NCj4+Pj4+PiAgwqDCoCArwqDCoMKgIG9yaWdfaXNpemUgPSBpX3NpemVfcmVhZChpbm9kZSk7
DQo+Pj4+Pj4gIMKgwqDCoMKgwqDCoCBzd2l0Y2ggKHNyLT5sX3doZW5jZSkgew0KPj4+Pj4+ICDC
oMKgwqDCoMKgwqAgY2FzZSAwOiAvKlNFRUtfU0VUKi8NCj4+Pj4+PiAgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgYnJlYWs7DQo+Pj4+Pj4gQEAgLTE5MDMsNyArMTk0Myw3IEBAIHN0YXRpYyBpbnQgX19v
Y2ZzMl9jaGFuZ2VfZmlsZV9zcGFjZShzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGlub2RlICpp
bm9kZSwNCj4+Pj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3ItPmxfc3RhcnQgKz0gZl9wb3M7
DQo+Pj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+Pj4+ICDCoMKgwqDCoMKg
wqAgY2FzZSAyOiAvKlNFRUtfRU5EKi8NCj4+Pj4+PiAtwqDCoMKgwqDCoMKgwqAgc3ItPmxfc3Rh
cnQgKz0gaV9zaXplX3JlYWQoaW5vZGUpOw0KPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCBzci0+bF9z
dGFydCArPSBvcmlnX2lzaXplOw0KPj4+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsN
Cj4+Pj4+PiAgwqDCoMKgwqDCoMKgIGRlZmF1bHQ6DQo+Pj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHJldCA9IC1FSU5WQUw7DQo+Pj4+Pj4gQEAgLTE5NTcsNiArMTk5NywxMSBAQCBzdGF0aWMg
aW50IF9fb2NmczJfY2hhbmdlX2ZpbGVfc3BhY2Uoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBp
bm9kZSAqaW5vZGUsDQo+Pj4+Pj4gIMKgwqDCoMKgwqDCoCBkZWZhdWx0Og0KPj4+Pj4+ICDCoMKg
wqDCoMKgwqDCoMKgwqDCoCByZXQgPSAtRUlOVkFMOw0KPj4+Pj4+ICDCoMKgwqDCoMKgwqAgfQ0K
Pj4+Pj4+ICsNCj4+Pj4+PiArwqDCoMKgIC8qIHplcm9vdXQgZW9mIGJsb2NrcyBpbiB0aGUgY2x1
c3Rlci4gKi8NCj4+Pj4+PiArwqDCoMKgIGlmICghcmV0ICYmIGNoYW5nZV9zaXplICYmIG9yaWdf
aXNpemUgPCBzaXplKQ0KPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBvY2ZzMl96ZXJvb3V0
X3BhcnRpYWxfY2x1c3Rlcihpbm9kZSwgb3JpZ19pc2l6ZSwNCj4+Pj4+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZSAtIG9yaWdfaXNpemUpOw0KPj4+Pj4+ICDC
oMKgwqDCoMKgwqAgdXBfd3JpdGUoJk9DRlMyX0koaW5vZGUpLT5pcF9hbGxvY19zZW0pOw0KPj4+
Pj4+ICDCoMKgwqDCoMKgwqAgaWYgKHJldCkgew0KPj4+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBtbG9nX2Vycm5vKHJldCk7DQo+Pj4+Pj4NCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBv
c3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2Nm
czItZGV2ZWw=
