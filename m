Return-Path: <SRS0=KHNm=J3=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385CBC433B4
	for <ocfs2-devel@archiver.kernel.org>; Fri, 30 Apr 2021 21:19:30 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFE216145A
	for <ocfs2-devel@archiver.kernel.org>; Fri, 30 Apr 2021 21:19:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFE216145A
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13ULB3DP106073;
	Fri, 30 Apr 2021 21:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=UwCn3oV7T/npJwrLwoRg0hmp+hX+KIAfkSzn/uDQ6Sw=;
 b=aklV2WXjICgPcjV52Cebq93quds18kslXCWsTOTNNgFGmfbiE0YjcBOaEL3Mrtt9hBTo
 OFC9xDJXgvFUVnAOVRGMyIhsRvYXGfPc7xyAemDh7hBiXiG+TFPHjcmtBGcaxeiFYtAA
 lm4yhTExLh+Y2D+QvG9VGSjYMtkFBhdOf6Aah073TWjsUxFXn9p4llicfoeC1eYz+cAw
 4ilgEFaDLrVFjxHKF8P0opMOq5liB62pslgNSB3DlTqy+CKRz+2FYTz7wNyiS71Wu1A+
 QwesGOw5oWR9Azn+rcScbMmYymJY9YEWZSpepjZAy+FmDc5eYm3NaY7ogIcg/lHBknoH cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 385afq92ym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Apr 2021 21:19:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13ULAqsR071180;
	Fri, 30 Apr 2021 21:19:26 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 384w3y959h-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 30 Apr 2021 21:19:26 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lcaXl-0001Bw-EG; Fri, 30 Apr 2021 14:19:25 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lcaXg-0001BV-JR
	for ocfs2-devel@oss.oracle.com; Fri, 30 Apr 2021 14:19:20 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13UL9xLb068716
	for <ocfs2-devel@oss.oracle.com>; Fri, 30 Apr 2021 21:19:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
	by aserp3020.oracle.com with ESMTP id 388s411c7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 30 Apr 2021 21:19:20 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB2632.namprd10.prod.outlook.com (2603:10b6:a02:b2::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21;
	Fri, 30 Apr 2021 21:19:18 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4087.035;
	Fri, 30 Apr 2021 21:19:18 +0000
To: Jan Kara <jack@suse.cz>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<CAHc6FU62TpZTnAYd3DWFNWWPZP-6z+9JrS82t+YnU-EtFrnU0Q@mail.gmail.com>
	<3f06d108-1b58-6473-35fa-0d6978e219b8@oracle.com>
	<20210430124756.GA5315@quack2.suse.cz>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <a69fa4bc-ffe7-204b-6a1f-6a166c6971a4@oracle.com>
Date: Fri, 30 Apr 2021 14:18:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <20210430124756.GA5315@quack2.suse.cz>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: BY3PR04CA0005.namprd04.prod.outlook.com
	(2603:10b6:a03:217::10) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-227-62.vpn.oracle.com (73.231.9.254) by
	BY3PR04CA0005.namprd04.prod.outlook.com (2603:10b6:a03:217::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.29
	via Frontend Transport; Fri, 30 Apr 2021 21:19:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 210107aa-c664-4f86-e8f3-08d90c1d9d50
X-MS-TrafficTypeDiagnostic: BYAPR10MB2632:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HhvaE2DAa96AgXpN6Fg2bwQuDYfwd6W1xMK3DqdzAR5G9vJJ+UkBx4Ksk9fV+VQxbMnZ50z8iOY/dYoMkl/GFJihFFE+fUyeAtyhMbrJn6eqstmkFVQcz4UKWuI2pRSNP3HHUTQ5bT9FNYu8lCBh+B1jOaUPssdy1WwL+3r/0ugTVPGBDNEk8Vt8GiLLkrcZ2rhVOxm8D/Ca8q1/U86MAjEPISlUpWLLjfGiFk/HkWBeM8A9vbBf1JjpHZ7S73xn2yJOLnwRX+CGENn1HgxeHoPmrkT1epTbIQyievWhY6l/hGSprkPgINMmlkQzg2/A1JM71ne+5l4QqPyZlMhkZUv+jaSDsS2hWCrk2ETI8l0URLLMNVEL+gxrKGTT1sr2GycfR3BNSK3C065yxYljfSC9dxYSLJ7zkaNS/2i8GYFHhMYUnZ+wVR3egWMkzjJuZfvkPeZQiZ7+/fmUVG/+5GLVJNmkLx87we4MxOgFVdkX98UuMXTf8WAnc/092qdCILGrLPPKoxMV3R4SyvigFECMTEnFCs1PUXUy0oxjpZJau1kRxErtffPl8Y+yH5da
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUplWXZyWFNlNXduL1JJOWtrR1c2TXhCaCtBTVRYVDhGOG9kWlQ2WTEvb3BI?=
	=?utf-8?B?ZkJnUlZmRWs3QzhYUlBnQlhLd2J2L2dyVFQ2aUNKZ2JSOGMxanJEYzA2dlov?=
	=?utf-8?B?UG1pRThtaDJwNlllOGhObUZTRkJPVHErTll5Y2svY2JmZENWUlJDdHJJWGQ2?=
	=?utf-8?B?Vk9HR3BVcHRCMnlqNEd5MUJpTlFiSVZtL0hKY25kRXI1SmhTbWFEQnpnY25G?=
	=?utf-8?B?NGJEb2xMQzZkQmdaeVp1MHM1ZHpVSDZ0STNZTlRQZklSa2hDV2dLTzhTam1I?=
	=?utf-8?B?cXNock1RSGUwendpc0tTV3laSld2QTNKS3NjOHVFWWIzZE16U254MVE2UXRT?=
	=?utf-8?B?Rkd2em1ZV1ZGN3dmRk9reUFyOVdTZW94eFBGUVZ3T0wybFVVRnpaZit0dFNP?=
	=?utf-8?B?VlJNZEdKb3Vyd3RmZk9CampoV0pGeWZDazlYOHJwRXlUL2N0YVh5N2hwZjlG?=
	=?utf-8?B?amhnUUo5UEtKeCtsNUlJOTZsV25LWnBaUXF3eFhsYk0yWnFMdm5zWlh2eUh1?=
	=?utf-8?B?alA5Y1lqRGNQaVJGRC9FTmtveUpPazdkQmxjRGJoWS9JYzJHSWpTQm0zTGRi?=
	=?utf-8?B?RWJLYSsrZ3hPUGJ2S2Qybis1c1NCcmw3V0x2elVZNFBFZEsrcVZOVjh3NzQ1?=
	=?utf-8?B?MU1LanpsRGNaK3lpT0VBa0tpRjY0NXZhRGxyNFpGcU4yWTJDTkxrbjJEK1JT?=
	=?utf-8?B?MlVzUnF6OElOT3kwVTU2Z3kyeXR5YTNpczRlMU5wUi9oeFI3UWhQZG93OFJk?=
	=?utf-8?B?TUJBdmVodXFwbDc0YjFEYzlhbDlVSCtLVHBldFJZN2N5Snh6VUZaWGIxQmtr?=
	=?utf-8?B?TmpzMWVNME5tckNldjN0MU9NRXQyQXNzczNuQklFWHA3ODFEM0RwSm1GVVBx?=
	=?utf-8?B?QytEVWtLNTNHN2tTWmQ0NHVzVWI4dkJBZk1PeHdFU3c0azdWeW4rOVZKZlh6?=
	=?utf-8?B?NDFvWUorbTMrd1RSR2RmcjV6TFkyalRJZEVURU5zY1pQZFdXNXgzYnZaVFhH?=
	=?utf-8?B?akxGblZMUTYzZTQyRGVzWklGNEUzUmh0aHR0OVZwNkwzemFHTzUwSnpUNWxJ?=
	=?utf-8?B?VDVKQ0l5M1RPbjBwbFFUSnlTbmRwdk9HWDFlc3AwVGtjWjN6T2d5YTVDd3F0?=
	=?utf-8?B?VEtTM214cFRXM2p3czY5dXNIaDNSdHMxTmIwR2g0TzgxbXhUdDY2MHFrRkNZ?=
	=?utf-8?B?a3VsaDNNdGo5UGRnZ05KNExtQ3N5d0cyMW5NdW12Z1JIWFVFMVZadWRjbHlk?=
	=?utf-8?B?ZTRqSS9TZk5QMVNMVlN5YktwOCtYR0c1bVVPckRmemVFRm9reXJYRmpWcmNl?=
	=?utf-8?B?Y05GQ25qdW1hMUQ4VkdZU2xRVU5IcmNvZi9mSkF4UWdCUEFTY3o5eStneXdW?=
	=?utf-8?B?RlN0YU9aR3dMMU80SUwyS1NZR0oybzFReER1eTdUSiswcG8ydjc5ak15K1lm?=
	=?utf-8?B?QkJ6MDdHOEErWmJOQmc0aVcwSHZTQTZJbW96a3lUOFVpMHJlZUZQU2RselBP?=
	=?utf-8?B?L2ZjbmFKUnhKSmFBZC9WZGNyc3hUbGlOVW5tTDJxVStBMlhoUC9OQkFWS01Y?=
	=?utf-8?B?SkFyS2YrbWpJQkt2UGpOVitmaHpqSnNvRUltZVhwa2xHTFI3MmM0R1dQUWFr?=
	=?utf-8?B?V1U1OXF5QzRjSFNpT1orbVBRNElEc3ZnaVV6SEtEN3lmd1RDSW1mRDdPdit1?=
	=?utf-8?B?VHlFN1NvdEZhaXRsalhxUTdPNjBwTWZPWnVDMGJGUVdsbDZLMnpuWXhNQ3hl?=
	=?utf-8?Q?KcyRv9jidAJ84MzN+ZEVXBEzVjezOj3nN1OQ7kZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 210107aa-c664-4f86-e8f3-08d90c1d9d50
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 21:19:18.3611 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /TznfTj39CDQx77AxWj1vphPpxFv7Klqbp3ISzjgAQTxEs8mFhgBXD0iF2viHxh7K7kRz9IKEmW/XdXQqCE52A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2632
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
X-OrganizationHeadersPreserved: BYAPR10MB2632.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0 suspectscore=0
	spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104300149
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300149
X-Proofpoint-ORIG-GUID: Ao_twD90xDw9FMxcePd2TrLQ8fELRNK6
X-Proofpoint-GUID: Ao_twD90xDw9FMxcePd2TrLQ8fELRNK6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300149

On 4/30/21 5:47 AM, Jan Kara wrote:

> On Thu 29-04-21 11:07:15, Junxiao Bi wrote:
>> On 4/29/21 10:14 AM, Andreas Gruenbacher wrote:
>>> On Tue, Apr 27, 2021 at 4:44 AM Junxiao Bi <junxiao.bi@oracle.com> wrote:
>>>> When doing truncate/fallocate for some filesytem like ocfs2, it
>>>> will zero some pages that are out of inode size and then later
>>>> update the inode size, so it needs this api to writeback eof
>>>> pages.
>>> is this in reaction to Jan's "[PATCH 0/12 v4] fs: Hole punch vs page
>>> cache filling races" patch set [*]? It doesn't look like the kind of
>>> patch Christoph would be happy with.
>> Thank you for pointing the patch set. I think that is fixing a different
>> issue.
>>
>> The issue here is when extending file size with fallocate/truncate, if the
>> original inode size
>>
>> is in the middle of the last cluster block(1M), eof part will be zeroed with
>> buffer write first,
>>
>> and then new inode size is updated, so there is a window that dirty pages is
>> out of inode size,
>>
>> if writeback is kicked in, block_write_full_page will drop all those eof
>> pages.
> I agree that the buffers describing part of the cluster beyond i_size won't
> be written. But page cache will remain zeroed out so that is fine. So you
> only need to zero out the on disk contents. Since this is actually
> physically contiguous range of blocks why don't you just use
> sb_issue_zeroout() to zero out the tail of the cluster? It will be more
> efficient than going through the page cache and you also won't have to
> tweak block_write_full_page()...

Thanks for the review.

The physical blocks to be zeroed were continuous only when sparse mode 
is enabled, if sparse mode is disabled, unwritten extent was not 
supported for ocfs2, then all the blocks to the new size will be zeroed 
by the buffer write, since sb_issue_zeroout() will need waiting io done, 
there will be a lot of delay when extending file size. Use writeback to 
flush async seemed more efficient?

Thanks,

Junxiao.

>
> 								Honza

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
