Return-Path: <SRS0=T5gl=PH=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C08C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Oct 2021 14:15:15 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DE35561057
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Oct 2021 14:15:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DE35561057
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JDU03a031175;
	Tue, 19 Oct 2021 14:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2021-07-09; bh=tnpFdX/CudgRjBw8mzgni3QZot9LlR4AX6QvyyTYqjE=;
 b=rSqLq9MbQ/erVU0Do80Lfnx5jR7z4qQY3eC383XWZ2PoabR8nQbuFiPhnnuoXm2YOuVK
 J+bucGm451/SA09+ApHe30YFhkeJEyFfXR/cnixSW720PQq90eEZhSu65WrUjTi5NBxy
 QeDkSXHqo0VSjUcn1gBkYpKSHs8JNIiESH5XFYAWts4RhtUwbUy9T84QCMlZthY4fnSv
 SwL3UWq9rxTK4N05Q/JFqLO6zVXxoRBTzgHYPW/gT0pHfb7ioHj81HpMYQ97xs0mnmiD
 lZmzQ8zLBEgaG07D36I0/tFDsxhfr1RE45kRxBMFyWmodGKahK7ECAa2K4Z424FHE2JJ HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bsruc2mgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Oct 2021 14:15:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JEBeL4168243;
	Tue, 19 Oct 2021 14:14:58 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bqkuxbswd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 19 Oct 2021 14:14:58 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mcptJ-0004Vd-1N; Tue, 19 Oct 2021 07:14:57 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <gautham.ananthakrishna@oracle.com>)
	id 1mcptF-0004VD-Ao
	for ocfs2-devel@oss.oracle.com; Tue, 19 Oct 2021 07:14:53 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JEBZ2r100518
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 14:14:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by userp3020.oracle.com with ESMTP id 3br8gsdsq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 14:14:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=j2NdMIwrOQEhOlwMpE+0SrjoI2gxH+25Z8bsUYVFgvLuL1j8gt/8YLqJHg05v+UOopf04DPcjUXfvyqExEhd84wL7Vr7nk+9uHeN8raUsXjrlxOfM1e01GVC4AvLTYogfQ12jELoxfxD09Jn5zGWVliy8SfSVdv7KWU6gp8a/qYJ6wetRQQ/xegjupbEy7jsZgAO6nc1r5QHRJSSqUq8+2sC/MfhTvuz1tL7Q20F8lGEk1hZG++PU0Q2MGoDLVNs1ci8/PL2se36QaQ3b45R5nVSA9tBEhu6mYSvEZsdXQQQWMCF2jbJsHZs0jYNsfK3qCa1FflAhnr76OyxTYGuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=0bOzUvCOFdLFwFpuKnvBg1LH/PmuRahPYvWbhtAcUdQ=;
	b=WZf7VQJBw2UUOPx3nhXK9X0Q2A060cVaKXBCXGY57yZGkCK0oOPFDma1oGodAQWZNpjlwUhDenKBumJyumMt9T4+WeJqa9VBbglMOuCMWVBx02YQvGgwQ0Jl2SoMVTYInCdDhX/FDV55Z1tbrsZLsi83hJUtlnIIUq7TsuL12/8U3EP3LucYjNoX87v/gC87pSj0Lnjf3M89OHtVfJ6gmJbO8qS7bgszUhUZi9ILjUddUgy9+x88YTOGGaFe6rJD9sEjj0k9kcNJrntzNbk4qPTwP52Y8f6ppk+Cy/7o3F/0i5chKdoNXosIzbv4Bnc5Z9rFmqZfynge271h3Y4q0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
	dkim=pass header.d=oracle.com; arc=none
Received: from DS7PR10MB4878.namprd10.prod.outlook.com (2603:10b6:5:3a8::6) by
	DS7PR10MB5101.namprd10.prod.outlook.com (2603:10b6:5:3b0::17) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4608.17; Tue, 19 Oct 2021 14:14:51 +0000
Received: from DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2]) by
	DS7PR10MB4878.namprd10.prod.outlook.com
	([fe80::a011:8d3a:6e64:d5d2%6]) with mapi id 15.20.4608.018;
	Tue, 19 Oct 2021 14:14:51 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
        "ocfs2-devel@oss.oracle.com"
	<ocfs2-devel@oss.oracle.com>
Thread-Topic: [PATCH RFC 1/1] ocfs2: race between searching chunks and release
	journal_head from buffer_head
Thread-Index: AQHXud+74b/hZFJ4XkKJzZqeCw4chqvIqtQAgAexW2CAAEMSgIAJ0/oA
Date: Tue, 19 Oct 2021 14:14:50 +0000
Message-ID: <DS7PR10MB4878D9524FE0F9F70282E827F7BD9@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <1633434852-26662-1-git-send-email-gautham.ananthakrishna@oracle.com>
	<af8792a6-cb2a-b529-1262-b0254b407018@linux.alibaba.com>
	<DS7PR10MB4878CEFE0D1FEE9BE668A025F7B79@DS7PR10MB4878.namprd10.prod.outlook.com>
	<1c54b00d-cda6-bb56-6389-008ecda91ede@linux.alibaba.com>
In-Reply-To: <1c54b00d-cda6-bb56-6389-008ecda91ede@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea291a04-6525-43a7-fea5-08d9930ad0ee
x-ms-traffictypediagnostic: DS7PR10MB5101:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7CV3w+5hsfHfaqVz6Zmht4Cdv7O8L3LMdLavfSIfN3WqbHtwtMpRXp3ApQ65KvakTgg6gpNDwxkjaSb6C2KIcQcE8qqsoDTTHlTS0OAKw630HhcDkuawmWtQ12NVKGSNBuGoQZ3wB3gOTOS7ZXSEQ3O+NXa28SUpjvvPItIeW84Ub/w+2WHwyEZC2tZvzo/R/W4G1hg71DU2TXAHkIlhfV5opJsLbqeh6vg+281antoR03F2mUlQu3q6QyjmpKgWd1r/khrpVwmNQ9trgaISwlZXX7d0N/ipnK9dFSUX1B07upB9/boYrBJw034uMDCAZ8iLTuIPeRIWf5bWvnXkFkGOwLFDGAuq6opio4a2NNTlRpWElBlf4GBslxNNpEPxn11hStfiYUc37gTKaud7qp5py5U7fLQm+T2zG7zY1CBeiM/Lb5lEspvnTggVN8sXzC0lfeoi4RsuSIDY12iroclj4WdZGpPOf05z5V+KQG8LZSEbhtSTn34+QrXp9T6uIqNOvOzx10NwpC9ZcEZH+TWrr8hDT5qLLrYYwoPIVdd6sRIzcSe3s1TaUW/z7zO46lhYIveeQ738LMBR3GwpcYRfDQcDOl8dBZ5Q2X+3bQM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:DS7PR10MB4878.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea291a04-6525-43a7-fea5-08d9930ad0ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2021 14:14:51.2382 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gautham.ananthakrishna@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5101
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 138.3.205.11
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: DS7PR10MB5101.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 adultscore=0
	spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110190087
Cc: Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH RFC 1/1] ocfs2: race between searching
 chunks and release journal_head from buffer_head
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190087
X-Proofpoint-ORIG-GUID: M0y4uhwV3hyxV2B9ifXcFCXXDY1b0s4P
X-Proofpoint-GUID: M0y4uhwV3hyxV2B9ifXcFCXXDY1b0s4P

Hi Joseph,

Yes.. we can have fast and slow paths. I will make changes and send V1 version of the patch.

Thanks,
Gautham.


-----Original Message-----
From: Joseph Qi <joseph.qi@linux.alibaba.com> 
Sent: Wednesday, October 13, 2021 1:38 PM
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>; ocfs2-devel@oss.oracle.com
Cc: Junxiao Bi <junxiao.bi@oracle.com>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH RFC 1/1] ocfs2: race between searching chunks and release journal_head from buffer_head



On 10/13/21 12:08 PM, Gautham Ananthakrishna wrote:
> Hi Joseph.
> 
> In jbd2_journal_put_journal_head(), we decrement jh->b_jcount before calling __journal_remove_journal_head().
> 
> However in any of the calling functions of ocfs2_test_bg_bit_allocatable(), we dont increment jh->b_jcount.
> Because of this, __journal_remove_journal_head() raced and set bh->b_private to NULL in ocfs2_test_bg_bit_allocatable().

Agree.

> This race happened after we checked "if (!buffer_jbd(bg_bh))" but 
> before we referenced b_privatelater. This is how we go the stack described in this patch. Hence we need to lock bit BH_JournalHead while checking ""if (!buffer_jbd(bg_bh))" as well as referencing b_private.

What I mean is we can still keep !buffer_jbd(bg_bh) as 'fast path'.
So the code may be like:

if (!buffer_jbd(bg_bh))
	return 1;

jbd_lock_bh_journal_head(bg_bh);
if (buffer_jbd(bg_bh)) {
	jh = bh2jh(bg_bh);
	...
}
jbd_unlock_bh_journal_head(bg_bh);

Thanks,
Joseph	


> 
> Thanks,
> Gautham.
> 
> -----Original Message-----
> From: Joseph Qi <joseph.qi@linux.alibaba.com>
> Sent: Friday, October 8, 2021 12:10 PM
> To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>; 
> ocfs2-devel@oss.oracle.com
> Cc: Junxiao Bi <junxiao.bi@oracle.com>; Rajesh Sivaramasubramaniom 
> <rajesh.sivaramasubramaniom@oracle.com>
> Subject: Re: [PATCH RFC 1/1] ocfs2: race between searching chunks and 
> release journal_head from buffer_head
> 
> Hi Gautham,
> 
> On 10/5/21 7:54 PM, Gautham Ananthakrishna wrote:
>> Encountered a race between ocfs2_test_bg_bit_allocatable() and
>> jbd2_journal_put_journal_head() resulting in the below vmcore.
>>
>> PID: 106879  TASK: ffff880244ba9c00  CPU: 2   COMMAND: "loop3"
>>  0 [ffff8802435ff1c0] panic at ffffffff816ed175
>>  1 [ffff8802435ff240] oops_end at ffffffff8101a7c9
>>  2 [ffff8802435ff270] no_context at ffffffff8106eccf
>>  3 [ffff8802435ff2e0] __bad_area_nosemaphore at ffffffff8106ef9d
>>  4 [ffff8802435ff330] bad_area_nosemaphore at ffffffff8106f143
>>  5 [ffff8802435ff340] __do_page_fault at ffffffff8106f80b
>>  6 [ffff8802435ff3a0] do_page_fault at ffffffff8106fc2f
>>  7 [ffff8802435ff3e0] page_fault at ffffffff816fd667
>>     [exception RIP: ocfs2_block_group_find_clear_bits+316]
>>     RIP: ffffffffc11ef6fc  RSP: ffff8802435ff498  RFLAGS: 00010206
>>     RAX: 0000000000003918  RBX: 0000000000000001  RCX: 0000000000000018
>>     RDX: 0000000000003918  RSI: 0000000000000000  RDI: ffff880060194040
>>     RBP: ffff8802435ff4f8   R8: ffffffffff000000   R9: ffffffffffffffff
>>     R10: ffff8802435ff730  R11: ffff8802a94e5800  R12: 0000000000000007
>>     R13: 0000000000007e00  R14: 0000000000003918  R15: ffff88017c973a28
>>     ORIG_RAX: ffffffffffffffff  CS: e030  SS: e02b
>>  8 [ffff8802435ff490] ocfs2_block_group_find_clear_bits at
>> ffffffffc11ef680 [ocfs2]
>>  9 [ffff8802435ff500] ocfs2_cluster_group_search at ffffffffc11ef916 
>> [ocfs2]
>> 10 [ffff8802435ff580] ocfs2_search_chain at ffffffffc11f0fb6 [ocfs2]
>> 11 [ffff8802435ff660] ocfs2_claim_suballoc_bits at ffffffffc11f1b1b 
>> [ocfs2]
>> 12 [ffff8802435ff6f0] __ocfs2_claim_clusters at ffffffffc11f32cb 
>> [ocfs2]
>> 13 [ffff8802435ff770] ocfs2_claim_clusters at ffffffffc11f5caf 
>> [ocfs2]
>> 14 [ffff8802435ff780] ocfs2_local_alloc_slide_window at 
>> ffffffffc11cc0db [ocfs2]
>> 15 [ffff8802435ff820] ocfs2_reserve_local_alloc_bits at 
>> ffffffffc11ce53f [ocfs2]
>> 16 [ffff8802435ff890] ocfs2_reserve_clusters_with_limit at
>> ffffffffc11f59b5 [ocfs2]
>> 17 [ffff8802435ff8e0] ocfs2_reserve_clusters at ffffffffc11f5c88 
>> [ocfs2]
>> 18 [ffff8802435ff8f0] ocfs2_lock_refcount_allocators at
>> ffffffffc11dc169 [ocfs2]
>> 19 [ffff8802435ff960] ocfs2_make_clusters_writable at 
>> ffffffffc11e4274 [ocfs2]
>> 20 [ffff8802435ffa50] ocfs2_replace_cow at ffffffffc11e4df1 [ocfs2]
>> 21 [ffff8802435ffac0] ocfs2_refcount_cow at ffffffffc11e54b1 [ocfs2]
>> 22 [ffff8802435ffb80] ocfs2_file_write_iter at ffffffffc11bf8f4 
>> [ocfs2]
>> 23 [ffff8802435ffcd0] lo_rw_aio at ffffffff814a1b5d
>> 24 [ffff8802435ffd80] loop_queue_work at ffffffff814a2802
>> 25 [ffff8802435ffe60] kthread_worker_fn at ffffffff810a80d2
>> 26 [ffff8802435ffec0] kthread at ffffffff810a7afb
>> 27 [ffff8802435fff50] ret_from_fork at ffffffff816f7da1
>>
>> When ocfs2_test_bg_bit_allocatable() called bh2jh(bg_bh), the 
>> bg_bh->b_private NULL as jbd2_journal_put_journal_head() raced and 
>> released the jounal head from the buffer head. Needed to take bit lock for the bit 'BH_JournalHead'
>> to fix this race.
>>
>> Signed-off-by: Gautham Ananthakrishna 
>> <gautham.ananthakrishna@oracle.com>
>> ---
>>  fs/ocfs2/suballoc.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c index 
>> 8521942..0e4e11b 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -1256,8 +1256,11 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
>>  	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
>>  		return 0;
>>  
>> -	if (!buffer_jbd(bg_bh))
>> +	jbd_lock_bh_journal_head(bg_bh);
>> +	if (!buffer_jbd(bg_bh)){
>> +		jbd_unlock_bh_journal_head(bg_bh);
>>  		return 1;
>> +	}
> 
> Seems !buffer_jbd() case we don't have to lock bit BH_JournalHead.
> 
> Thanks,
> Joseph
> 
>>  
>>  	jh = bh2jh(bg_bh);
>>  	spin_lock(&jh->b_state_lock);
>> @@ -1267,6 +1270,7 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
>>  	else
>>  		ret = 1;
>>  	spin_unlock(&jh->b_state_lock);
>> +	jbd_unlock_bh_journal_head(bg_bh);
>>  
>>  	return ret;
>>  }
>>
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
