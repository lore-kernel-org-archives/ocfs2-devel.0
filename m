Return-Path: <SRS0=6PEN=J6=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E5EC433ED
	for <ocfs2-devel@archiver.kernel.org>; Mon,  3 May 2021 17:33:06 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7060C610A6
	for <ocfs2-devel@archiver.kernel.org>; Mon,  3 May 2021 17:33:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7060C610A6
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 143HToOE193237;
	Mon, 3 May 2021 17:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=hVK7Xe58QW5lcnM5IT1Lp0ZWuqv+FyJrq/cuiq+9kiE=;
 b=zoWmjw/MZUjxSePDqtQd7f6XHF3J2JmvsC+fMX9KkMh3j4t2z1yyNBYZIICer88zpxsy
 3XDFeMYhDfNRCCWUuHVsA9yIGraxcdNYou6lxmdKH5vTjycKL5V8CIFsop9a4Ab+EPJh
 94wNDcWXO8gcZnFIM2n9b7q2XcSsZvVm9j0+sn62uQBFUh+5yrCInO2E6Yzt25aGHcpV
 sdzEy70yE0qNKOJu1ibHx509gb3ZC468AVWcP51CI96hK3QgSi+S8pUiWmxI+ULHwIz1
 QHM5ZVcxMA5BnMQK27R9Q1s+Fsrd7Ff20E6hgIA1K/57hnmBVpTiBSu+YhrRsmZEqZc9 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 388xdrvdxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 May 2021 17:33:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 143HVGOq013920;
	Mon, 3 May 2021 17:33:02 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 389grr028y-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 03 May 2021 17:33:02 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1ldcLD-0005Pl-6E; Mon, 03 May 2021 10:26:43 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1ldcL7-0005PK-R4
	for ocfs2-devel@oss.oracle.com; Mon, 03 May 2021 10:26:37 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	143HKCPR141725
	for <ocfs2-devel@oss.oracle.com>; Mon, 3 May 2021 17:26:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by aserp3020.oracle.com with ESMTP id 388xt2qda1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 03 May 2021 17:26:37 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB3125.namprd10.prod.outlook.com (2603:10b6:a03:14c::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.41;
	Mon, 3 May 2021 17:26:36 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4087.044;
	Mon, 3 May 2021 17:26:36 +0000
To: Jan Kara <jack@suse.cz>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<CAHc6FU62TpZTnAYd3DWFNWWPZP-6z+9JrS82t+YnU-EtFrnU0Q@mail.gmail.com>
	<3f06d108-1b58-6473-35fa-0d6978e219b8@oracle.com>
	<20210430124756.GA5315@quack2.suse.cz>
	<a69fa4bc-ffe7-204b-6a1f-6a166c6971a4@oracle.com>
	<20210503102904.GC2994@quack2.suse.cz>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <72cde802-bd8a-9ce5-84d7-57b34a6a8b03@oracle.com>
Date: Mon, 3 May 2021 10:25:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <20210503102904.GC2994@quack2.suse.cz>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SN4PR0701CA0003.namprd07.prod.outlook.com
	(2603:10b6:803:28::13) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-246-23.vpn.oracle.com (73.231.9.254) by
	SN4PR0701CA0003.namprd07.prod.outlook.com
	(2603:10b6:803:28::13) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4087.39 via Frontend Transport;
	Mon, 3 May 2021 17:26:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aee589d3-0d60-4e6a-d0ac-08d90e589a53
X-MS-TrafficTypeDiagnostic: BYAPR10MB3125:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e2Qqb4xuEiRy2SHrMdYGijjWaSJwSY6MAeJUZsPbHdS60Xfc2jpCTOvbOCSQ2gjIg9vAZ/j5BzqwfkJfraVsSMYLMQFG61qSCQleGi2Imk9gERB3xxdI+k/mt3i/ja7eq1Ime1va0J2slVmNqFnften8+i2CdNwysMRV2Bwz/btJ/dUlgbuksmyAuu5E82ryiIyghuh8ev0loIxXVicU57PjbHudg5Ah7E2QWK9GB+fwgrVHjM1aDFa8i56o1zdXnaYaaXTctd+Aw6GbzjjSGcEmdts6K585xDVYszoLffiwIJZHKntcg61fmE1DympqJ9NCgg0QIi/G6KMQPjVYad7LhoRk6zEJ/vfOxfI3ddYAfD3UkVdJh5UjZp4cHLZmrdqipIp7xgsfrSRKoI+vKUejQdax6aLon87Tu9BC6WJQPDE2eyGFyJDT9tFZU9PE5F0ce0I8qRZU82ftwifL9tDeDlPlPbs+u1wl1Y3qlzITmV/8gPh9gQ8GwEJXLVcVPzwE2tAM1K9XGaTNEKxARpVPVx1L03w1YDi9zUXqH6g=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SjNSWWg2THZ6QzB0V0VRWlNFa1lxOFN6S3NUNjgrMkpYMG5OdjVpQ0Q5VTFK?=
	=?utf-8?B?eWNzdVdMOWpLMGhsbUlvQ3dtM2JOa1QySEE5dTBCUUxJK3doY3hoUnBwRlpJ?=
	=?utf-8?B?Y3NDcTFVeVkwMEFiK3BLLzlyMjRIbUlaYWhNRVZKZ01TbUR6RDRtWVpCNVlj?=
	=?utf-8?B?blZWVWdYVzMwNXVtNzVZLzU1cklOSHFnVXFVUm1ZeVpWaGdlL1ZaVFY1MkRO?=
	=?utf-8?B?UW02b3Y3WGllaGVqbmFsUXFqcVBzbXM3d0tIRlpoR09kdjY5SktTNUZucG1W?=
	=?utf-8?B?QXJydWFJZG9VT2hoTEhBRUpOaE5SV05DbzIwa1BWNkxEQTl0cll6WXpXcUxT?=
	=?utf-8?B?aU1pUDhZdmhPNXVPSXl4ZFZjZ2JpaWhreGI1ZW5qc3dQVnpmS25qeWtYZWRi?=
	=?utf-8?B?OFVCNzByZEMwTXJqcWU4TTB5ZDEydGQ2eVdYTk8vakhqUW51QkxqdWk3c2Jh?=
	=?utf-8?B?SDY3eWthSzRaYU82VnJ0UGg1STY3OTRrODBjVmlYTHVJMjdSdTV4NWd1R1Na?=
	=?utf-8?B?a0wycERZbkdRU29wLzlac3NoM0xESEh5YVRJREVRQ2lzU1duNmpGcWlwYWRh?=
	=?utf-8?B?cFVhc2dicUtJUW0xS1EvYjIrUHh6UHVmNG1BV3ZQcGpNTUt2TThYbGZJRWdK?=
	=?utf-8?B?ZFRCZlpiM1lrMWRYdDVURHY4eEZqc01ROVJqUTM4a05LUEdPclEweUNiNnc4?=
	=?utf-8?B?ZmpnRzNud1UxQjIzMllTVWdwOS96YlRvSlBrcFpHZUwxN0NTREE3MEJFa0pm?=
	=?utf-8?B?NDJGTXFmZUhvc21ET0daWXpWekhBZm56eDdaSXFrMDB1T2xKQ1VHMXZsNXpm?=
	=?utf-8?B?TWlGem1UL3dlSXVtUFgzUFIwR0RELzAyRlhhajRhek1IMzlWak0rR2xPb0h5?=
	=?utf-8?B?NkI2eUowbFdtNXArOWlnUkkzQmxHL0krZlVMQ3J3cU1jMmNiUHNuTUl3eFd5?=
	=?utf-8?B?eXQ0c0hSQ0pKTGNXNnZEVW5pSHlNOW9IeVJ6NWhDeFByZnFQKzh2OFBKMVh4?=
	=?utf-8?B?dlZlTkpTZ1NLSTFsSm5OK29tRWNMVnpBSk5NV2RBdTBZdVE0Ulo5ZUs2WXVL?=
	=?utf-8?B?TXFjSEsyaDZSdmFsY1JCVDZydnlmUGF0KzlaM2JURUpJOE10WXQ4TzlFaVdT?=
	=?utf-8?B?Q3kvK29yRXd5eGhOTzlsVTYrbzVKR3VpRVpHN3Y1TGVCcTQzMy9xOHhDZml4?=
	=?utf-8?B?bVZSMFkvWW9HVjAvSGxFOFMwWUIvbHczcmlNQ2F4MHFhblN0YS9qTnFZWEN1?=
	=?utf-8?B?eFZlU1F2SCtzWTZFa3dUa1hPZXpaeGpmaUFGWFd6bFB5bFNVa3d2NVdqamw5?=
	=?utf-8?B?R0ZtdmJ2TEVCcVJ0NlFJaWs4bUlqR29xUC93dXRJUTRxUGc5cnlDOVpGNndC?=
	=?utf-8?B?REkrV3l3WkR6cm1hQm0zRElOUGtCYXhBZnFQK0FBcEVCUERDelFzVzdRckRM?=
	=?utf-8?B?OWl3VFY2MXRxY0tOWFpBd0VlVk9RdXZoU05yMVozRTlTRWVFVVNZMDdnSnpn?=
	=?utf-8?B?VTliRXF2QmhuYUhPSjkvSFpzb202WXVXL1c5dElVQ211MXhzdnlaVEx1RElo?=
	=?utf-8?B?MWFkTll6WjduaExZOCthQXBuZlNCOGpQV2ZQeUVCaFF2OE0xdWtuSkZSRk41?=
	=?utf-8?B?THpCTzFndWVnYzhrTzB5MnZ3amhTbUFEaVdvZk92UC9XKzVUWHJqdnZ3M085?=
	=?utf-8?B?d0w4cnpnZmFUYmVvcHM0NGNQQklKand2ek4zamdxS3RqQ25oaFIva3N5R2R3?=
	=?utf-8?Q?nM79Y2PSMBXQ4vvE4EmTs/Z9V25lnQES/DnHZ0H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee589d3-0d60-4e6a-d0ac-08d90e589a53
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 17:26:36.0254 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6IPnmU1lM/mJaPMVH7mEtmpDK8+GKFiOWu8S4lGZuPF505yWK5nndVmB9TD7GvtK2DNenzZB8D4i3TwJQyZsdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3125
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
X-OrganizationHeadersPreserved: BYAPR10MB3125.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9973
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	mlxlogscore=999
	phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2105030114
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9973 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105030115
X-Proofpoint-ORIG-GUID: HqpNb3uTz_IxgmxHspCbTegHkcVI3e5Z
X-Proofpoint-GUID: HqpNb3uTz_IxgmxHspCbTegHkcVI3e5Z
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9973 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105030115


On 5/3/21 3:29 AM, Jan Kara wrote:
> On Fri 30-04-21 14:18:15, Junxiao Bi wrote:
>> On 4/30/21 5:47 AM, Jan Kara wrote:
>>
>>> On Thu 29-04-21 11:07:15, Junxiao Bi wrote:
>>>> On 4/29/21 10:14 AM, Andreas Gruenbacher wrote:
>>>>> On Tue, Apr 27, 2021 at 4:44 AM Junxiao Bi <junxiao.bi@oracle.com> wrote:
>>>>>> When doing truncate/fallocate for some filesytem like ocfs2, it
>>>>>> will zero some pages that are out of inode size and then later
>>>>>> update the inode size, so it needs this api to writeback eof
>>>>>> pages.
>>>>> is this in reaction to Jan's "[PATCH 0/12 v4] fs: Hole punch vs page
>>>>> cache filling races" patch set [*]? It doesn't look like the kind of
>>>>> patch Christoph would be happy with.
>>>> Thank you for pointing the patch set. I think that is fixing a different
>>>> issue.
>>>>
>>>> The issue here is when extending file size with fallocate/truncate, if the
>>>> original inode size
>>>>
>>>> is in the middle of the last cluster block(1M), eof part will be zeroed with
>>>> buffer write first,
>>>>
>>>> and then new inode size is updated, so there is a window that dirty pages is
>>>> out of inode size,
>>>>
>>>> if writeback is kicked in, block_write_full_page will drop all those eof
>>>> pages.
>>> I agree that the buffers describing part of the cluster beyond i_size won't
>>> be written. But page cache will remain zeroed out so that is fine. So you
>>> only need to zero out the on disk contents. Since this is actually
>>> physically contiguous range of blocks why don't you just use
>>> sb_issue_zeroout() to zero out the tail of the cluster? It will be more
>>> efficient than going through the page cache and you also won't have to
>>> tweak block_write_full_page()...
>> Thanks for the review.
>>
>> The physical blocks to be zeroed were continuous only when sparse mode is
>> enabled, if sparse mode is disabled, unwritten extent was not supported for
>> ocfs2, then all the blocks to the new size will be zeroed by the buffer
>> write, since sb_issue_zeroout() will need waiting io done, there will be a
>> lot of delay when extending file size. Use writeback to flush async seemed
>> more efficient?
> It depends. Higher end storage (e.g. NVME or NAS, maybe some better SATA
> flash disks as well) do support WRITE_ZERO command so you don't actually
> have to write all those zeros. The storage will just internally mark all
> those blocks as having zeros. This is rather fast so I'd expect the overall
> result to be faster that zeroing page cache and then writing all those
> pages with zeroes on transaction commit. But I agree that for lower end
> storage this may be slower because of synchronous writing of zeroes. That
> being said your transaction commit has to write those zeroes anyway so the
> cost is only mostly shifted but it could still make a difference for some
> workloads. Not sure if that matters, that is your call I'd say.

Ocfs2 is mostly used with SAN, i don't think it's common for SAN storage 
to support WRITE_ZERO command.

Anything bad to add a new api to support eof writeback?

Thanks,

Junxiao.

>
> Also note that you could submit those zeroing bios asynchronously but that
> would be more coding and you need to make sure they are completed on
> transaction commit so probably it isn't worth the complexity.
>
> 								Honza

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
