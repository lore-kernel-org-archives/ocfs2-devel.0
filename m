Return-Path: <SRS0=5yvb=JZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E65C433B4
	for <ocfs2-devel@archiver.kernel.org>; Wed, 28 Apr 2021 16:01:43 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 67829613D8
	for <ocfs2-devel@archiver.kernel.org>; Wed, 28 Apr 2021 16:01:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67829613D8
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13SFihCO071361;
	Wed, 28 Apr 2021 16:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : subject : list-id
 : list-unsubscribe : list-archive : list-post : list-help : list-subscribe
 : content-type : content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=pA72bp/KJeZtg6TjtNs1j0IQ+WPRmOWLvKkBVRWpf/E=;
 b=GtHjF9AOSqIxsIzzj+qw+MyVjseUBI1BV+oVefc607jLrSGcC9e53QolMhrpJuTau0YO
 U3sdWSbVCQirl5T1eMp+cN0h3GWYsm3vmD3SVZ0DeTOYAovTGAR6fXhOwa1Nfl/vM0FM
 t+eziyTlqxZZd3ZEIrKjIeMZHwaaKgqjNptvI4l5Ixiz7kiMFwfKZQNRx0YylP6AaWeC
 huyo43fEwOfpx9yWZZFIrKQb8a2mMCG9j0OKT+AbcdUaj4BRJKYM80k3NsUZZmXTIe4x
 7QCs7yk3jXu7SR6oHn3s3tv2GZSaE+B5GXWUJyJYagjUvIk2D5/m9Ky3aBJC+Z8pxjXo 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 385afq1d5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Apr 2021 16:01:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13SFl825079226;
	Wed, 28 Apr 2021 16:01:40 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 384w3uvcs2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 28 Apr 2021 16:01:39 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lbmd8-00083d-Lu; Wed, 28 Apr 2021 09:01:38 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lbmcf-00081m-J1
	for ocfs2-devel@oss.oracle.com; Wed, 28 Apr 2021 09:01:09 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13SFmBwF105882
	for <ocfs2-devel@oss.oracle.com>; Wed, 28 Apr 2021 16:01:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
	by aserp3020.oracle.com with ESMTP id 384b58rv1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 28 Apr 2021 16:01:09 +0000
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB3574.namprd10.prod.outlook.com (2603:10b6:a03:119::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20;
	Wed, 28 Apr 2021 16:01:07 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4065.027;
	Wed, 28 Apr 2021 16:01:07 +0000
To: ocfs2-devel@oss.oracle.com, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<20210426220552.45413-2-junxiao.bi@oracle.com>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <9aeafe69-0bf2-f4cb-431a-1cb4329a178c@oracle.com>
Date: Wed, 28 Apr 2021 09:00:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <20210426220552.45413-2-junxiao.bi@oracle.com>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SN7PR04CA0207.namprd04.prod.outlook.com
	(2603:10b6:806:126::32) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-154-52.vpn.oracle.com (73.231.9.254) by
	SN7PR04CA0207.namprd04.prod.outlook.com (2603:10b6:806:126::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25
	via Frontend Transport; Wed, 28 Apr 2021 16:01:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 472ccd39-0bb8-4576-802b-08d90a5ed53f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3574:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JX0d3kUQaMHm7GQsiTZ43ySz6neTI/hl2+T0RA0ugJCfgZGX+hrBb/l51aaDRNW3qgp2SXPmm4c2A6+YD3BdgD30pr/uHpUqBn3TWO8jyQGaBarXR4kigxJpF1hoeEgCmHqobhAUp8gUdZB+F+UU5jT36GLjv/T6oqeHTxtXeevHHQD4xg7FPly9IGE+mBl6qDVC8A9+tByqvQ+sN9zMFv9uudIBX1dcdCTQFp/8GfzZEZ5yxZav7AcfrjiQ1X+xXW7G6E4itp9h13AulSQMmNDPglWrdae6AmtvLOFzlSTRBorQ2ysmunFi4GrsXToAayKwIF0yKm2298joRvae4ikyJW5b+sirykADHCnOjAZXhaVRe1PQ7JgclqnlQ5H8iM5zPJ2xsF0cla65gSbUuJLEUSGS+k2DjI4+4zRm2aamlOHJSL9uuktWXEfaneFJ9ikeE5zXNYqYlDxBXU3k7qVUTZ2jOWB8JNvub+3qOhwQKl14tD/r2X4nA0LocKkRF1VzhENzEkJ9PMPSzcpNkYHcuqEjsLvoY678t9qYfVoWyAOvIsqp01Nt+MB50g9k
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bVovSVJESWlsaTJEMFdBMk13S3NwNEprdmQ2aDJhTEcwTXFRajZ2L205VzQv?=
	=?utf-8?B?MmxVaWpVUHJ2OEJHK08rNEllaFZVMUxuSHdXazgxN3c5WFp2dkpEa3hEeVF2?=
	=?utf-8?B?VzAyUDNvLzVJZlJzOWUrTVN4cEg2dy93VWtFWE0ybDNMSnJPWFlHcHgwNUNa?=
	=?utf-8?B?dm4yQ2FTRFA2bHhIcjM4dW5zUkNpSS8zc21lM2E0UnRIS2diK2FWWW1idSsz?=
	=?utf-8?B?L3hXUk5BbTFMbFRrRTA3VHFQTVIrVStzeDBIVHFJWlk3cFNiTFpFMWlWTVd1?=
	=?utf-8?B?bHQ1NUs5RXcwNlhYc1pPTXhCeE1zRUVyRHd6ZUtXQzhYQlVweXNGampkVnRa?=
	=?utf-8?B?MjU2WWVNR0ZsU29odU9RakdmVmphbzNZZmc4bFExaXJYZWZ6b3NRK2NSTUpr?=
	=?utf-8?B?NGdZL1A4ZU84cnptNW5YZU8vbzZnWEg5TFAxdExXWWY5TjJqd3ErUVVmS25h?=
	=?utf-8?B?anp1UVRIekdIMW82VjAxNjV3R0ZHVGl4Z2xlVjR5Z1pNOXRQU3RUM3RRanZ5?=
	=?utf-8?B?SGJtRlQ3aUh0MXVpZDZzR2EzSjR2TkZYL2dPcVRyZnMrODA3Y1ZlbVZBUm9K?=
	=?utf-8?B?SFQ3a21aa3hybGpLVW5XSEx6dmYxY2N3Sjc0enQ1V0hxVStaNHp5aEc4dUw2?=
	=?utf-8?B?SDI4ajk4YjJVRFY1Uk0rMkMrL0xDZHIxWHhjbkQ5YVRBektYSlFHWDBaYzFD?=
	=?utf-8?B?MzR2Wi9SZmI1L01UMTBrSDl3NWhGTStLeFVuMTF5Vy9YS292ak5ESEhwUTBr?=
	=?utf-8?B?a0liYXdEU0QyV2FITkROQWJxRGpZaHp4aGYyakZ1K09oOWR0aGhYZWJjeXF0?=
	=?utf-8?B?bTVxb2FRYlhHeU5oZm5PZ2pLckZQQXpRT3FoZG54Z1BuVW5ZTmtmV3VHeWtm?=
	=?utf-8?B?SWhPMWRpNzh4Wm1yMXBNY0tUWkJsdWM3VmVyVXlEekRwOFZka2YxaExYdmox?=
	=?utf-8?B?QjRxc1Ixa3J6aGlybUZ0YklYMlgrVVl0ZG1JUEQza0hCNlFwSXNMMTYzNHE3?=
	=?utf-8?B?YWdnSlRxQU5EcmZnbkZpUHh4V21ibG9BenhmdENtMXdETlMwdmh5UTR6U1dO?=
	=?utf-8?B?aFRRZ3lMWlhaN05nYW8rT2Uwc1NwNXhXUnN4aGt5OXgxQ29VbFhZQjVLdmg0?=
	=?utf-8?B?YjlSVVZsYjlxYUxJMHJuYWpWdFVIRDU5WGhVT0tTVWlQT3VYbnQxUkR5Ulc5?=
	=?utf-8?B?TXJYcGs4aTdGaUx4T2hXeXBxMGwxUzdqUENwR29BTlRadmlkS1RsV2tjRWdk?=
	=?utf-8?B?K2hsYVVpRWxGRGhFRXY1N1QvZTdFa2pEY1ptcHdKTTY5Zm5XcEcxODMyUjhY?=
	=?utf-8?B?dVl2ejlpaDk5Um1ZWFdnRlhRUUhBZDFDaGVYVk50N3BSUWhWNURWTkh3d044?=
	=?utf-8?B?WEEzcXpEZ1dLNnpMNXlXVG0xUTd2ejJiZzBJWjcvVW9FZlNoYmxlcS83RGhY?=
	=?utf-8?B?ZzVQQ1hSNVdwbi90bHp5MTBld1RNRUhVRjNyQXNtOEJHRVloWTh0bUFaTkdh?=
	=?utf-8?B?OWdQOHZXR3BjaVpHRi9IYzVJZ1dNZEtPdnZ2Y3Q3U3R6ck12MXBJcXRKQzFK?=
	=?utf-8?B?Y2JnYUZXZGFpVzAyNDZGVmhZMExNU1phYkNUTndHaUhZaWRNaEtSNXFUZDg5?=
	=?utf-8?B?NW5MY0gxb25nOVY1RVF0NkViemNoTEFmZ3VudzlwcVJINEVTNHYyNWsydGFn?=
	=?utf-8?B?bFhDd05FZ216RjlZWUpqYm5NZG1HUGFyRURZZU1CM0xZUXIvZlNodVM0QXhL?=
	=?utf-8?Q?J4jouihaLQTXY+mwgz275fp2a5BqGbKsJqXmnyb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472ccd39-0bb8-4576-802b-08d90a5ed53f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 16:01:07.1892 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4z9NQiEs0hTnuMEdV/G5qpqvEBFKL15grlvJ8D4A1iAaCXucz3ZbqD7xJWRaQ5GswjGFKfrb5/HVDXIRuAE4Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3574
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
X-OrganizationHeadersPreserved: BYAPR10MB3574.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	bulkscore=0 mlxscore=0
	malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104280102
Subject: Re: [Ocfs2-devel] [PATCH 2/3] ocfs2: allow writing back pages out
	of inode size
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280102
X-Proofpoint-ORIG-GUID: 5pniCoHsA_aTE45zy7Emu1LAkAPLwjyD
X-Proofpoint-GUID: 5pniCoHsA_aTE45zy7Emu1LAkAPLwjyD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280102

Hi Joseph,

Can you help review the first two patches?

Thanks,

Junxiao.

On 4/26/21 3:05 PM, Junxiao Bi wrote:
> When fallocate/truncate extend inode size, if the original isize is in
> the middle of last cluster, then the part from isize to the end of the
> cluster needs to be zeroed with buffer write, at that time isize is not
> yet updated to match the new size, if writeback is kicked in, it will
> invoke ocfs2_writepage()->block_write_full_page() where the pages out
> of inode size will be dropped. That will cause file corruption.
>
> Running the following command with qemu-image 4.2.1 can get a corrupted
> coverted image file easily.
>
>      qemu-img convert -p -t none -T none -f qcow2 $qcow_image \
>               -O qcow2 -o compat=1.1 $qcow_image.conv
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   fs/ocfs2/aops.c | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index ad20403b383f..7a3e3d59f6a9 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -402,11 +402,28 @@ static void ocfs2_readahead(struct readahead_control *rac)
>    */
>   static int ocfs2_writepage(struct page *page, struct writeback_control *wbc)
>   {
> +	struct inode * const inode = page->mapping->host;
> +	loff_t i_size = i_size_read(inode);
> +	const pgoff_t end_index = i_size >> PAGE_SHIFT;
> +	unsigned int offset;
> +
>   	trace_ocfs2_writepage(
>   		(unsigned long long)OCFS2_I(page->mapping->host)->ip_blkno,
>   		page->index);
>   
> -	return block_write_full_page(page, ocfs2_get_block, wbc);
> +	/*
> +	 * The page straddles i_size.  It must be zeroed out on each and every
> +	 * writepage invocation because it may be mmapped.  "A file is mapped
> +	 * in multiples of the page size.  For a file that is not a multiple of
> +	 * the  page size, the remaining memory is zeroed when mapped, and
> +	 * writes to that region are not written out to the file."
> +	 */
> +	offset = i_size & (PAGE_SIZE-1);
> +	if (page->index == end_index && offset)
> +		zero_user_segment(page, offset, PAGE_SIZE);
> +
> +	return __block_write_full_page_eof(inode, page, ocfs2_get_block, wbc,
> +			end_buffer_async_write, true);
>   }
>   
>   /* Taken from ext3. We don't necessarily need the full blown

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
