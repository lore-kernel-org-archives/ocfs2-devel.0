Return-Path: <SRS0=HKIw=J7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978CCC433B4
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 May 2021 23:37:36 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 258F7613C1
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 May 2021 23:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 258F7613C1
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 144Na7GV187651;
	Tue, 4 May 2021 23:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=bdLIrk0WryE8GqcuwLQilULGe6+igbOan97EjK/1lCo=;
 b=e4s+N8dJPBh1A6Lq2MFiv/oWyYkMLr5A7wlWSn8+koC3Qi6GScv5C3swLq30atMWlfYW
 nXaN9xKVp9RQO1NQhUYAVW4fiTB7FvjsTHJ6DCIkVlPrLo0W/8fiqgDTpqNFVtcGXxbx
 PFghRjCvvqWdFHO0NUvzWDY5IiIdilEU1re/g1PZ+vZJGID5WowxqiqJks4k4KPQIhgR
 nVq3be2jXFZjLjdhgwS8cZDw8MWzmjbraorQoF34E3Xe4mTD818eFAzNBfCa5Q7w+OIt
 gshM3U0u9jZlGktFboIaOZe7vcAUtXM8rUZv3Mdv0655mPztBmMsfXGC4/zIAvpTy8Y6 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 38bemjg4e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 May 2021 23:37:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 144NVCt7091136;
	Tue, 4 May 2021 23:37:32 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38bebstrt3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 04 May 2021 23:37:32 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1le4bb-00077Z-5c; Tue, 04 May 2021 16:37:31 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1le4b7-00076a-PI
	for ocfs2-devel@oss.oracle.com; Tue, 04 May 2021 16:37:01 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	144NVPs7017800
	for <ocfs2-devel@oss.oracle.com>; Tue, 4 May 2021 23:37:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by userp3020.oracle.com with ESMTP id 38bfur8cx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 04 May 2021 23:37:01 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by SJ0PR10MB4797.namprd10.prod.outlook.com (2603:10b6:a03:2d8::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.40;
	Tue, 4 May 2021 23:36:59 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4087.044;
	Tue, 4 May 2021 23:36:59 +0000
To: Jan Kara <jack@suse.cz>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<CAHc6FU62TpZTnAYd3DWFNWWPZP-6z+9JrS82t+YnU-EtFrnU0Q@mail.gmail.com>
	<3f06d108-1b58-6473-35fa-0d6978e219b8@oracle.com>
	<20210430124756.GA5315@quack2.suse.cz>
	<a69fa4bc-ffe7-204b-6a1f-6a166c6971a4@oracle.com>
	<20210503102904.GC2994@quack2.suse.cz>
	<72cde802-bd8a-9ce5-84d7-57b34a6a8b03@oracle.com>
	<20210504090237.GC1355@quack2.suse.cz>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <84794fdb-fb49-acf1-4949-eef856737698@oracle.com>
Date: Tue, 4 May 2021 16:35:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <20210504090237.GC1355@quack2.suse.cz>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SA0PR11CA0043.namprd11.prod.outlook.com
	(2603:10b6:806:d0::18) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-159-147.vpn.oracle.com (73.231.9.254) by
	SA0PR11CA0043.namprd11.prod.outlook.com (2603:10b6:806:d0::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25
	via Frontend Transport; Tue, 4 May 2021 23:36:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e19eb24-e745-4071-7ec1-08d90f5582c6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4797:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: crq6ypOKhnoumpFrneD2Ke9j1kW2KRUPxabR+W7f0rOdjSmOT1AskbyIvWrbWZPgE65Tlp+AsmRdQehL9vmypQBOxs0GrcYf3/2NjRVbKlWxyE1f92MD8/gisTNwyQRkMiUfSZqYqO+Ah26nZz7Som5ssgmrSqV5hanO6f1P+1PlAu5DcaWBmxdZqMiu4zWQyyuGPrakf7v0+TdSQSbyNwfA4iTYwSpvW9cwY8c+wXZF0OkTp7PKAd4E3tFwEK+stMN+SVdKtdU6w9qvsiy+6olzfnYVJcVcjF5jU99/m99UrCKF0FlLwrGbUfnYlVvWNx4m7SFvAf/K0NJ37QT4oC7gdDnh/U76y1rXUXpg6S95GKKk4J5RLpaYzQcg8FGM27AApLPu9EVOuieO9KX34q1ULPHiUVTOA7DpLlW61cJ3Ic84wdFsvZ7q3mZUfQPPLKA4SwsGKyvtUqxEbVw+ODUa+F7wjCJnWr7A1tbOibFWxZ19+DtGXFpjB4tiwyum8hbNeBG47imVOY69Xy2VyvcRg5mVbW43yOdm9MWO5TriwNKr8xVCkYVm3TrWetLr
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RXJEOEdDWEhKV2wzSnpCTE02RkdSY2ZYNUFBSTAzN1VMRDRWRHRxU2VPTk5I?=
	=?utf-8?B?eWh4K1N3U3hWTUFsWVVKVDE4T3BpbGxvdXJKRWVLT1JnVTNDS3ZKS0FYTmpE?=
	=?utf-8?B?VjlLWk55WlVCNXpsT2Z1MHhReFRrZ2dwYWRFSHhzaTZMUlM1NlQ3amU3bEl0?=
	=?utf-8?B?clMwQ2FPQSs5TVRacklhMkJybHM3elVLVkNEUldBWjdZVFhadkpTYTdCb1pP?=
	=?utf-8?B?VUUxZm5pZkYxSzF0Zmt6Y2ViaG9ORXgzZEVSanVURkZVWkpaSVFYR1Q4ellu?=
	=?utf-8?B?TVVvcXNNUHR3UlJjcTBseDNnMHJiUHM1eEVTMXJJQnozY2oweGlnQnRPOFRO?=
	=?utf-8?B?NThYM0EzRlZaS3pJNTB6Z0YwVzhwTURoN1FQYVNuRXAyQVNPWWtGb2RYRHYw?=
	=?utf-8?B?RFo2NlNvVytQcGlhMzV1ZUliYlBXZ1JqQncvWklzWCtYZ0crZG5QL0dwb1lF?=
	=?utf-8?B?bEhKREpBOXYxUlNtN2l0dUJUQVZ5cjRvell4VHByMmtDNSsxTGNkTFBtUFZW?=
	=?utf-8?B?YStaWmdPNStZOGRZeHJUUUlqdTVoVlZYL0lsM21YbHFCYzVwdWVVWXVCUWp4?=
	=?utf-8?B?WVFxbEhUYXNPMWtoVEtzRTg1cytQQjlISUdUR1I3OVc2YUxSRmQrcC9ocTFq?=
	=?utf-8?B?Wm1aMWlnOUFUSW1VMUpQdTRZeUs1SEFtVUVKU2x0L2hoM0ZWcWk5Q1BRR2Z1?=
	=?utf-8?B?bVErYm9sWHk1bHQ4U1hlMTN0MFpRcXZaOHhNVW9PRDQwZTJUMkhhS3krV2pD?=
	=?utf-8?B?T0ZzMXVtRW1wZFhxVHo3ckQ0anpLaEFlbWdxbGNEMUJnNjM2dGlQdTludGxZ?=
	=?utf-8?B?T2VNMEJBSU0xNGY4Vktsa1N1WTNnL25TWDFkUTgrZkRSLzNkWkRYVXRiSWNC?=
	=?utf-8?B?VFRXMi9jVGlxa2tBSUtnU1VmVGpWV3BzMTJxY3A2NGhyMTE5TldUbkovMFEv?=
	=?utf-8?B?czZrc3ZEWDkyV2hSY1d1M3BHVmwxNVZFM2VRQTFYNXFhZk11RHBsdU1VNTVo?=
	=?utf-8?B?M1o1NVQyMjk2aitUU0xJQ2VDbmNFSmNQNG9Ua3dlLzVjVEYwUWppMFFiaitK?=
	=?utf-8?B?YUlFNGdCYnFBbXRZbCt6N1NKV2Y3d2U2ZnpjMFZHTmxLZUdWTGR1OXVNbFk1?=
	=?utf-8?B?WUswbnQ1S3Zkcis5N0VkbXA0cTJJUUVONmVoYURta2ZGWk1PczQwRHFnQ0V3?=
	=?utf-8?B?Vy83ai9xejBzdXhvVkZJUDdvMFA1UTdBcUcxSllpU1g4Y0VPallPZmc3WFov?=
	=?utf-8?B?eC9yRXRKWDQzbWFCOWIzZlhIZ0tTSmZ6cmhNTnZUNXNkK3NJT2RwNlVCOVFu?=
	=?utf-8?B?OEVxVEVzQStxN2FpWngyYkhhVVJOVzZGYVBhRW53UlIwM09HckFlbUxmVFYy?=
	=?utf-8?B?cHVMeXcxZENDeUZrVHNoQzFXR0s0SEh3RnIzcTY0Z2UrbXJaZFhNYTdBMWFl?=
	=?utf-8?B?bFNDdFhWOGlXWm1mM2tPSmlUTk9IOFdHL3VHZWYrMGNzRU9VMkcwdkpvL1RJ?=
	=?utf-8?B?N280a2pPQ1YxYXExQTNXNVVhN0VpZjBkVWhaeTNZdEpQQUozRzY2ZFZZbVhW?=
	=?utf-8?B?cDc5dDdlOEpzU3RCbG9JK0duakVNMGNvaU1iRHF4OFNSYkk4cjFFTlZRemNu?=
	=?utf-8?B?YnJRR21EMlg2Nk9iQmd2NVQ0QWRPd001WFh1ZWx2QjU0dW8zTm5JaEJuMGxT?=
	=?utf-8?B?bjBSaWl5blg3QnQzanFvTEEwS0ZJS1RxRmVQQUYxUlZuMzIvVklvekFVSU56?=
	=?utf-8?Q?3esUTJyuHgkzODiwIMuXuY0Uk2o8FkZNXxUG/2W?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e19eb24-e745-4071-7ec1-08d90f5582c6
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 23:36:59.1743 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjAjKZkI3YQ4qEgR+6GIYNEr8O5TlkP3kfGk0Zu6ihGBa4slVc+ix6XDNkBSBa6F0WhmrkkBwrCKkIlAGMuxHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4797
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
X-OrganizationHeadersPreserved: SJ0PR10MB4797.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	phishscore=0 mlxscore=0
	adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2105040161
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	144NVPs7017800
Cc: cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Cluster-devel] [PATCH 1/3] fs/buffer.c: add new
 api to allow eof writeback
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040161
X-Proofpoint-ORIG-GUID: E0YXbBL72dMbTNdCm7R8LNwTPRKZnPum
X-Proofpoint-GUID: E0YXbBL72dMbTNdCm7R8LNwTPRKZnPum
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040161

T24gNS80LzIxIDI6MDIgQU0sIEphbiBLYXJhIHdyb3RlOgoKPiBPbiBNb24gMDMtMDUtMjEgMTA6
MjU6MzEsIEp1bnhpYW8gQmkgd3JvdGU6Cj4+IE9uIDUvMy8yMSAzOjI5IEFNLCBKYW4gS2FyYSB3
cm90ZToKPj4+IE9uIEZyaSAzMC0wNC0yMSAxNDoxODoxNSwgSnVueGlhbyBCaSB3cm90ZToKPj4+
PiBPbiA0LzMwLzIxIDU6NDcgQU0sIEphbiBLYXJhIHdyb3RlOgo+Pj4+Cj4+Pj4+IE9uIFRodSAy
OS0wNC0yMSAxMTowNzoxNSwgSnVueGlhbyBCaSB3cm90ZToKPj4+Pj4+IE9uIDQvMjkvMjEgMTA6
MTQgQU0sIEFuZHJlYXMgR3J1ZW5iYWNoZXIgd3JvdGU6Cj4+Pj4+Pj4gT24gVHVlLCBBcHIgMjcs
IDIwMjEgYXQgNDo0NCBBTSBKdW54aWFvIEJpIDxqdW54aWFvLmJpQG9yYWNsZS5jb20+IHdyb3Rl
Ogo+Pj4+Pj4+PiBXaGVuIGRvaW5nIHRydW5jYXRlL2ZhbGxvY2F0ZSBmb3Igc29tZSBmaWxlc3l0
ZW0gbGlrZSBvY2ZzMiwgaXQKPj4+Pj4+Pj4gd2lsbCB6ZXJvIHNvbWUgcGFnZXMgdGhhdCBhcmUg
b3V0IG9mIGlub2RlIHNpemUgYW5kIHRoZW4gbGF0ZXIKPj4+Pj4+Pj4gdXBkYXRlIHRoZSBpbm9k
ZSBzaXplLCBzbyBpdCBuZWVkcyB0aGlzIGFwaSB0byB3cml0ZWJhY2sgZW9mCj4+Pj4+Pj4+IHBh
Z2VzLgo+Pj4+Pj4+IGlzIHRoaXMgaW4gcmVhY3Rpb24gdG8gSmFuJ3MgIltQQVRDSCAwLzEyIHY0
XSBmczogSG9sZSBwdW5jaCB2cyBwYWdlCj4+Pj4+Pj4gY2FjaGUgZmlsbGluZyByYWNlcyIgcGF0
Y2ggc2V0IFsqXT8gSXQgZG9lc24ndCBsb29rIGxpa2UgdGhlIGtpbmQgb2YKPj4+Pj4+PiBwYXRj
aCBDaHJpc3RvcGggd291bGQgYmUgaGFwcHkgd2l0aC4KPj4+Pj4+IFRoYW5rIHlvdSBmb3IgcG9p
bnRpbmcgdGhlIHBhdGNoIHNldC4gSSB0aGluayB0aGF0IGlzIGZpeGluZyBhIGRpZmZlcmVudAo+
Pj4+Pj4gaXNzdWUuCj4+Pj4+Pgo+Pj4+Pj4gVGhlIGlzc3VlIGhlcmUgaXMgd2hlbiBleHRlbmRp
bmcgZmlsZSBzaXplIHdpdGggZmFsbG9jYXRlL3RydW5jYXRlLCBpZiB0aGUKPj4+Pj4+IG9yaWdp
bmFsIGlub2RlIHNpemUKPj4+Pj4+Cj4+Pj4+PiBpcyBpbiB0aGUgbWlkZGxlIG9mIHRoZSBsYXN0
IGNsdXN0ZXIgYmxvY2soMU0pLCBlb2YgcGFydCB3aWxsIGJlIHplcm9lZCB3aXRoCj4+Pj4+PiBi
dWZmZXIgd3JpdGUgZmlyc3QsCj4+Pj4+Pgo+Pj4+Pj4gYW5kIHRoZW4gbmV3IGlub2RlIHNpemUg
aXMgdXBkYXRlZCwgc28gdGhlcmUgaXMgYSB3aW5kb3cgdGhhdCBkaXJ0eSBwYWdlcyBpcwo+Pj4+
Pj4gb3V0IG9mIGlub2RlIHNpemUsCj4+Pj4+Pgo+Pj4+Pj4gaWYgd3JpdGViYWNrIGlzIGtpY2tl
ZCBpbiwgYmxvY2tfd3JpdGVfZnVsbF9wYWdlIHdpbGwgZHJvcCBhbGwgdGhvc2UgZW9mCj4+Pj4+
PiBwYWdlcy4KPj4+Pj4gSSBhZ3JlZSB0aGF0IHRoZSBidWZmZXJzIGRlc2NyaWJpbmcgcGFydCBv
ZiB0aGUgY2x1c3RlciBiZXlvbmQgaV9zaXplIHdvbid0Cj4+Pj4+IGJlIHdyaXR0ZW4uIEJ1dCBw
YWdlIGNhY2hlIHdpbGwgcmVtYWluIHplcm9lZCBvdXQgc28gdGhhdCBpcyBmaW5lLiBTbyB5b3UK
Pj4+Pj4gb25seSBuZWVkIHRvIHplcm8gb3V0IHRoZSBvbiBkaXNrIGNvbnRlbnRzLiBTaW5jZSB0
aGlzIGlzIGFjdHVhbGx5Cj4+Pj4+IHBoeXNpY2FsbHkgY29udGlndW91cyByYW5nZSBvZiBibG9j
a3Mgd2h5IGRvbid0IHlvdSBqdXN0IHVzZQo+Pj4+PiBzYl9pc3N1ZV96ZXJvb3V0KCkgdG8gemVy
byBvdXQgdGhlIHRhaWwgb2YgdGhlIGNsdXN0ZXI/IEl0IHdpbGwgYmUgbW9yZQo+Pj4+PiBlZmZp
Y2llbnQgdGhhbiBnb2luZyB0aHJvdWdoIHRoZSBwYWdlIGNhY2hlIGFuZCB5b3UgYWxzbyB3b24n
dCBoYXZlIHRvCj4+Pj4+IHR3ZWFrIGJsb2NrX3dyaXRlX2Z1bGxfcGFnZSgpLi4uCj4+Pj4gVGhh
bmtzIGZvciB0aGUgcmV2aWV3Lgo+Pj4+Cj4+Pj4gVGhlIHBoeXNpY2FsIGJsb2NrcyB0byBiZSB6
ZXJvZWQgd2VyZSBjb250aW51b3VzIG9ubHkgd2hlbiBzcGFyc2UgbW9kZSBpcwo+Pj4+IGVuYWJs
ZWQsIGlmIHNwYXJzZSBtb2RlIGlzIGRpc2FibGVkLCB1bndyaXR0ZW4gZXh0ZW50IHdhcyBub3Qg
c3VwcG9ydGVkIGZvcgo+Pj4+IG9jZnMyLCB0aGVuIGFsbCB0aGUgYmxvY2tzIHRvIHRoZSBuZXcg
c2l6ZSB3aWxsIGJlIHplcm9lZCBieSB0aGUgYnVmZmVyCj4+Pj4gd3JpdGUsIHNpbmNlIHNiX2lz
c3VlX3plcm9vdXQoKSB3aWxsIG5lZWQgd2FpdGluZyBpbyBkb25lLCB0aGVyZSB3aWxsIGJlIGEK
Pj4+PiBsb3Qgb2YgZGVsYXkgd2hlbiBleHRlbmRpbmcgZmlsZSBzaXplLiBVc2Ugd3JpdGViYWNr
IHRvIGZsdXNoIGFzeW5jIHNlZW1lZAo+Pj4+IG1vcmUgZWZmaWNpZW50Pwo+Pj4gSXQgZGVwZW5k
cy4gSGlnaGVyIGVuZCBzdG9yYWdlIChlLmcuIE5WTUUgb3IgTkFTLCBtYXliZSBzb21lIGJldHRl
ciBTQVRBCj4+PiBmbGFzaCBkaXNrcyBhcyB3ZWxsKSBkbyBzdXBwb3J0IFdSSVRFX1pFUk8gY29t
bWFuZCBzbyB5b3UgZG9uJ3QgYWN0dWFsbHkKPj4+IGhhdmUgdG8gd3JpdGUgYWxsIHRob3NlIHpl
cm9zLiBUaGUgc3RvcmFnZSB3aWxsIGp1c3QgaW50ZXJuYWxseSBtYXJrIGFsbAo+Pj4gdGhvc2Ug
YmxvY2tzIGFzIGhhdmluZyB6ZXJvcy4gVGhpcyBpcyByYXRoZXIgZmFzdCBzbyBJJ2QgZXhwZWN0
IHRoZSBvdmVyYWxsCj4+PiByZXN1bHQgdG8gYmUgZmFzdGVyIHRoYXQgemVyb2luZyBwYWdlIGNh
Y2hlIGFuZCB0aGVuIHdyaXRpbmcgYWxsIHRob3NlCj4+PiBwYWdlcyB3aXRoIHplcm9lcyBvbiB0
cmFuc2FjdGlvbiBjb21taXQuIEJ1dCBJIGFncmVlIHRoYXQgZm9yIGxvd2VyIGVuZAo+Pj4gc3Rv
cmFnZSB0aGlzIG1heSBiZSBzbG93ZXIgYmVjYXVzZSBvZiBzeW5jaHJvbm91cyB3cml0aW5nIG9m
IHplcm9lcy4gVGhhdAo+Pj4gYmVpbmcgc2FpZCB5b3VyIHRyYW5zYWN0aW9uIGNvbW1pdCBoYXMg
dG8gd3JpdGUgdGhvc2UgemVyb2VzIGFueXdheSBzbyB0aGUKPj4+IGNvc3QgaXMgb25seSBtb3N0
bHkgc2hpZnRlZCBidXQgaXQgY291bGQgc3RpbGwgbWFrZSBhIGRpZmZlcmVuY2UgZm9yIHNvbWUK
Pj4+IHdvcmtsb2Fkcy4gTm90IHN1cmUgaWYgdGhhdCBtYXR0ZXJzLCB0aGF0IGlzIHlvdXIgY2Fs
bCBJJ2Qgc2F5Lgo+PiBPY2ZzMiBpcyBtb3N0bHkgdXNlZCB3aXRoIFNBTiwgaSBkb24ndCB0aGlu
ayBpdCdzIGNvbW1vbiBmb3IgU0FOIHN0b3JhZ2UgdG8KPj4gc3VwcG9ydCBXUklURV9aRVJPIGNv
bW1hbmQuCj4+Cj4+IEFueXRoaW5nIGJhZCB0byBhZGQgYSBuZXcgYXBpIHRvIHN1cHBvcnQgZW9m
IHdyaXRlYmFjaz8KPiBPSywgbm93IHRoYXQgSSByZXJlYWQgdGhlIHdob2xlIHNlcmllcyB5b3Un
dmUgcG9zdGVkIEkgdGhpbmsgSSBzb21ld2hhdAo+IG1pc3VuZGVyc3Rvb2QgeW91ciBvcmlnaW5h
bCBwcm9ibGVtIGFuZCBpbnRlbnRpb24uIFNvIGxldCdzIGZpcnN0IHNldHRsZQo+IG9uIHRoYXQu
IEFzIGZhciBhcyBJIHVuZGVyc3RhbmQgdGhlIHByb2JsZW0gaGFwcGVucyB3aGVuIGV4dGVuZGlu
ZyBhIGZpbGUKPiAoZWl0aGVyIHRocm91Z2ggdHJ1bmNhdGUgb3IgdGhyb3VnaCB3cml0ZSBiZXlv
bmQgaV9zaXplKS4gV2hlbiB0aGF0Cj4gaGFwcGVucywgd2UgbmVlZCB0byBtYWtlIHN1cmUgdGhh
dCBibG9ja3MgKG9yIHRoZWlyIHBhcnRzKSB0aGF0IHVzZWQgdG8gYmUKPiBhYm92ZSBpX3NpemUg
YW5kIGFyZSBub3QgZ29pbmcgdG8gYmUgYWZ0ZXIgZXh0ZW5zaW9uIGFyZSB6ZXJvZWQgb3V0Lgo+
IFVzdWFsbHksIGZvciBzaW1wbGUgZmlsZXN5c3RlbXMgc3VjaCBhcyBleHQyLCB0aGVyZSBpcyBv
bmx5IG9uZSBzdWNoIGJsb2NrCj4gLSB0aGUgb25lIHN0cmFkZGxpbmcgaV9zaXplIC0gd2hlcmUg
d2UgbmVlZCB0byBtYWtlIHN1cmUgdGhpcyBoYXBwZW5zLiBBbmQKPiB3ZSBhY2hpZXZlIHRoYXQg
YnkgemVyb2luZyBvdXQgdGFpbCBvZiB0aGlzIGJsb2NrIG9uIHdyaXRlb3V0IChpbgo+IC0+d3Jp
dGVwYWdlKCkgaGFuZGxlcikgYW5kIGFsc28gYnkgemVyb2luZyBvdXQgdGFpbCBvZiB0aGUgYmxv
Y2sgd2hlbgo+IHJlZHVjaW5nIGlfc2l6ZSAoYmxvY2tfdHJ1bmNhdGVfcGFnZSgpIHRha2VzIGNh
cmUgb2YgdGhpcyBmb3IgZXh0MikuIFNvIHRoZQo+IHRhaWwgb2YgdGhpcyBibG9jayBpcyB6ZXJv
ZWQgb3V0IG9uIGRpc2sgYXQgYWxsIHRpbWVzIGFuZCB0aHVzIHdlIGhhdmUgbm8KPiBwcm9ibGVt
IHdoZW4gZXh0ZW5kaW5nIGlfc2l6ZS4KPgo+IE5vdyB3aGF0IEkgZGVzY3JpYmVkIGRvZXNuJ3Qg
d29yayBmb3IgT0NGUzIuIEFzIGZhciBhcyBJIHVuZGVyc3RhbmQgdGhlCj4gcmVhc29uIGlzIHRo
YXQgd2hlbiBibG9jayBzaXplIGlzIHNtYWxsZXIgdGhhbiBwYWdlIHNpemUgYW5kIE9DRlMyIHVz
ZXMKPiBjbHVzdGVyIHNpemUgbGFyZ2VyIHRoYW4gYmxvY2sgc2l6ZSwgdGhlIHBhZ2Ugc3RyYWRk
bGluZyBpX3NpemUgY2FuIGhhdmUKPiBhbHNvIHNvbWUgYnVmZmVycyBtYXBwZWQgKHdpdGggdW5k
ZXJseWluZyBibG9ja3MgYWxsb2NhdGVkKSB0aGF0IGFyZSBmdWxseQo+IG91dHNpZGUgb2YgaV9z
aXplLiBUaGVzZSBibG9ja3MgYXJlIG5ldmVyIHdyaXR0ZW4gYmVjYXVzZSBvZiBob3cKPiBfX2Js
b2NrX3dyaXRlX2Z1bGxfcGFnZSgpIGN1cnJlbnRseSBiZWhhdmVzIChuZXZlciB3cml0ZXMgYnVm
ZmVycyBmdWxseQo+IGJleW9uZCBpX3NpemUpIHNvIGV2ZW4gaWYgeW91IHplcm8gb3V0IHBhZ2Ug
Y2FjaGUgYW5kIGRpcnR5IHRoZSBwYWdlLAo+IHJhY2luZyB3cml0ZWJhY2sgY2FuIGNsZWFyIGRp
cnR5IGJpdHMgd2l0aG91dCB3cml0aW5nIHRob3NlIGJsb2NrcyBhbmQgc28KPiB0aGV5IGFyZSBu
b3QgemVyb2VkIG91dCBvbiBkaXNrIGFsdGhvdWdoIHdlIGFyZSBhYm91dCB0byBleHBhbmQgaV9z
aXplLgpDb3JyZWN0Lgo+Cj4gRGlkIEkgdW5kZXJzdGFuZCB0aGUgcHJvYmxlbSBjb3JyZWN0bHk/
IEJ1dCB3aGF0IGNvbmZ1c2VzIG1lIGlzIHRoYXQKPiBvY2ZzMl96ZXJvX2V4dGVuZF9yYW5nZSgp
IChvY2ZzMl93cml0ZV96ZXJvX3BhZ2UoKSBpbiBmYWN0KSBhY3R1YWxseSBkb2VzCj4gZXh0ZW5k
IGlfc2l6ZSB0byBjb250YWluIHRoZSByYW5nZSBpdCB6ZXJvZXMgb3V0IHdoaWxlIHN0aWxsIGhv
bGRpbmcgdGhlCj4gcGFnZSBsb2NrIHNvIGl0IHNob3VsZCBiZSBwcm90ZWN0ZWQgYWdhaW5zdCB0
aGUgcmFjZSB3aXRoIHdyaXRlYmFjayBJCj4gb3V0bGluZWQgYWJvdmUuIFdoYXQgYW0gSSBtaXNz
aW5nPwoKVGhhbmsgeW91IGZvciBwb2ludGluZyB0aGlzLiBJIGRpZG4ndCByZWFsaXplIG9jZnMy
X3plcm9fZXh0ZW5kKCkgd2lsbCAKdXBkYXRlIGlub2RlIHNpemUsCgp3aXRoIGl0LCB0cnVuY2F0
ZSB0byBleHRlbmQgZmlsZSB3aWxsIG5vdCBzdWZmZXIgdGhpcyBpc3N1ZS4gVGhlIApvcmlnaW5h
bCBpc3N1ZSBoYXBwZW5lZCB3aXRoCgpxZW11IHRoYXQgdXNlZCB0aGUgZm9sbG93aW5nIGZhbGxv
Y2F0ZSB0byBleHRlbmQgZmlsZSBzaXplLiBUaGUgZmlyc3QgCmZhbGxvY2F0ZSBwdW5jaGVkCgpo
b2xlIGJleW9uZCB0aGUgaW5vZGUgc2l6ZSgyMjc2MTk2MzUyKSBidXQgbm90IHVwZGF0ZSBpc2l6
ZSwgdGhlIHNlY29uZCAKb25lIHVwZGF0ZWQKCmlzaXplLCB0aGUgZmlyc3Qgb25lIHdpbGwgZG8g
c29tZSBidWZmZXIgd3JpdGUgdG8gemVybyBlb2YgYmxvY2tzIGluIApvY2ZzMl9yZW1vdmVfaW5v
ZGVfcmFuZ2UKCi0+b2NmczJfemVyb19wYXJ0aWFsX2NsdXN0ZXJzLT5vY2ZzMl96ZXJvX3Jhbmdl
X2Zvcl90cnVuY2F0ZS4KCiDCoMKgwqAgZmFsbG9jYXRlKDExLCBGQUxMT0NfRkxfS0VFUF9TSVpF
fEZBTExPQ19GTF9QVU5DSF9IT0xFLCAyMjc2MTk2MzUyLCAKNjU1MzYpID0gMAogwqDCoMKgIGZh
bGxvY2F0ZSgxMSwgMCwgMjI3NjE5NjM1MiwgNjU1MzYpID0gMAoKClRoYW5rcywKCkp1bnhpYW8u
Cgo+Cj4gCQkJCQkJCQlIb256YQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFj
bGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZl
bA==
