Return-Path: <SRS0=5yvb=JZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A04C433B4
	for <ocfs2-devel@archiver.kernel.org>; Wed, 28 Apr 2021 16:03:21 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2DD5B61407
	for <ocfs2-devel@archiver.kernel.org>; Wed, 28 Apr 2021 16:03:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DD5B61407
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13SFimeL071402;
	Wed, 28 Apr 2021 16:03:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=YVvCkuXMNY/iDs1xHIgadNaFICsHongk5Btp6vB8gDc=;
 b=b0LaqJrAQL6b5Rc9529xiUT25brvYSbHfXGsR+0594ZFqcKV4jrDJYnCEsl+HQQIRUVd
 trFbzzQgRKTq42JQoGzGSgtLA4mp/60tpOae4ul0sHuxOhUKFWd+jDpEtIoQE/oSM9Aq
 wMlGGdPEb31Fd/ieC9kdjZF4iNOQ+JSxJNwpjk0mzNkKggjPM6Nd79tQJAjR3PdsIdfz
 6O50iDiUdaYPPgMjOIyynjR4oFH0d5QC2Pdy3cP+LW+86CYLd1XShtTuu0HOLBAOuL/9
 ypRPoLPL42lGJVvVn2FpgkjmRf7+qNCz2thoU8ARgTr1hco299whR3yu0GwKafhw67Nx JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 385afq1dcm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Apr 2021 16:03:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13SFlCiO013434;
	Wed, 28 Apr 2021 16:03:19 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3848eys1r6-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 28 Apr 2021 16:03:18 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lbmej-00089u-Pt; Wed, 28 Apr 2021 09:03:17 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lbmei-00089b-0D
	for ocfs2-devel@oss.oracle.com; Wed, 28 Apr 2021 09:03:16 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13SFl9CF079985
	for <ocfs2-devel@oss.oracle.com>; Wed, 28 Apr 2021 16:03:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by userp3020.oracle.com with ESMTP id 384w3uvf2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 28 Apr 2021 16:03:15 +0000
Authentication-Results: redhat.com; dkim=none (message not signed)
	header.d=none; redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by SJ0PR10MB4543.namprd10.prod.outlook.com (2603:10b6:a03:2d9::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22;
	Wed, 28 Apr 2021 16:03:13 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4065.027;
	Wed, 28 Apr 2021 16:03:13 +0000
To: ocfs2-devel@oss.oracle.com, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<20210426220552.45413-3-junxiao.bi@oracle.com>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <3d364174-53dd-ee07-ac3a-6ea57878f8d8@oracle.com>
Date: Wed, 28 Apr 2021 09:02:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <20210426220552.45413-3-junxiao.bi@oracle.com>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SN7PR04CA0047.namprd04.prod.outlook.com
	(2603:10b6:806:120::22) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-154-52.vpn.oracle.com (73.231.9.254) by
	SN7PR04CA0047.namprd04.prod.outlook.com (2603:10b6:806:120::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27
	via Frontend Transport; Wed, 28 Apr 2021 16:03:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15d3c761-a299-49d2-c8c5-08d90a5f20b2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4543:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A0PDEiuuEaBDXZhY5+4qeicWB/6e3x8rMCSLAOUp2ypndPCWMC+jyqBP9G/z9gCtQ7Qt0J42deRUHGRCBIVpi0a6k4/Ub+x81HnsSegCgZ5dK3JL6pZncro0grw9ZAAInzL0rSZZ+qvEb1g0cuft2uRyvHV3A0wQLdisrm0AXuBZJboomZNoJTmIwkHpMGAIR00LWvm3mwQPFLwcdVYM/BIpll4nx34pshq3u7unWAnHaAtd8ioAm7dBEgPXHzMrvOr0++4wowmzfWG6iug0W17PlID7ifSr5pi52ZbRApuip/I0/DrJCfst8Wggph9qs/HpFbvZDxBaODuai+s7SxgfoqQj5Lc5IFA7lcH8ZxHRkB3cPvjv4B/uLbvxmyEvHb3oon/Y1ZTYKIplGJ49U8OfWgD9C8hJgke9q6BZxOJV/Od0qLVa8Dv+OfZ/pf/qefUQw3bZBR3D/B+lEZX0cWr7suGyXzB1kxbV0YqRqFPreV7FA9kDr9m8+2MjX29zeeqyNhVYL/6eMjKwh6/wXWH+fqo+ojp3mDbHb4fdwN08nIpwU4+JLSlIX5NMRNV6
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YzlYZE1xTjA2dGJXZVRZVkdJMEN5V29ZT3lVK1VoaWNEK3lQTDJKNzhrZ1dK?=
	=?utf-8?B?dTVMQXdMeEpDUUduZlBvUXpOSTMvOUwwWlZKWG5qdXR0SmdrSEF1VHQrRnUy?=
	=?utf-8?B?RDhPKzZ2bnNQMnRCUFBHM3hqOVVDVmpmNFV2cVp4UDV5WEkvU1ljbGV0WVJj?=
	=?utf-8?B?K2xuS2ZnN2ZCckl2MkNDS3pzOW81MkR2Wmw4eWhVNFVsUHpMRlVEVWY5MC9r?=
	=?utf-8?B?RkVtUVV4L0ZzUElwQTk4ZWtIcFpGYTlIV2NtSjUvTUdGWXgrQ0FTbFJ2WjN2?=
	=?utf-8?B?SzAxNWgxNEMvU1hyMTZWdkw5RklCMEFDeVNoUGplaks4NUJkdENmTDIzay80?=
	=?utf-8?B?VFNRVTlkc2YvY010cE9QSU1jT2ZzTm9lSno4eWgxVUlFUEx3anZoMVZxcEUr?=
	=?utf-8?B?SVJXZ2dRWGl0RVoxNHQ4YW8vbFRraGNLTWRRUWk2MkdNYnBzWU9oM3dUWjI5?=
	=?utf-8?B?OWVwMHM3RTFQMkFDT2dWa1dMSTBpY1pjZm16TmdIYUMxbldmL3UxeXZzZUF0?=
	=?utf-8?B?K3FITzJSQ1lvZXFjRXp2bWxpTUYzR2FNOVNDQXREWUNIYkY5bXFJaDZIYUU1?=
	=?utf-8?B?bDlFUW5KekZzcEUxVU56bmp4NWUyNkpNd3hHWnlHMDFtRDRPSjd2MElaSTBF?=
	=?utf-8?B?djRPYVBWaXlWTW05dStHWTVXSTVaaGY1TWZTM0NjM1E1a3kvZk5Rb3N3RFBu?=
	=?utf-8?B?SThKQzRIMVdDRnViSDlRcFBTNEV2c3pVZTdrUFJSUVJqVzA1ckc3ZmhiZjJn?=
	=?utf-8?B?ZWt3VFF2ckVXMVpnNWtudVUwalJNSS9BVlJKK1RJaHFXZE91VjRLY0tKWDJ4?=
	=?utf-8?B?c1pQYXdyR3psSlFBNXk0Z0hEeFpncjJVcTdsWWlKaHhqVy9BcXcrVkJUUENG?=
	=?utf-8?B?YTk5dlg5KzNTSkR6M3gvM1dSM0VTZzQ2RFZaOFBVRTI0THcra0V2YkJjMzBJ?=
	=?utf-8?B?REpmODkwTi9YZWdXWXdlZFlldnNBbHliaExkbFpmTVJNYlNEcHNEeDJta3NX?=
	=?utf-8?B?NFhNT2ZnVlcyWUdJUmNIUFY5b0o3dDFsM2dhV0dmbXdockRSMzdaWnFXZlZS?=
	=?utf-8?B?K3BiMXFWb3FoNVdiWVBiL1hITmkrTm9DZlFXdlFZbG9LMkFzQVVJMHpOV1Ro?=
	=?utf-8?B?NithY1pHeVFhdDB6WXNFWnY0dEdVUCtKdWlCSjRjbzRXOUkrY202OVZMaGN5?=
	=?utf-8?B?T0pWMmFUbHVneFF0TFFFelpUQklZczgwRDVWcHpHN25RRlpFckYyVnVUL3Qw?=
	=?utf-8?B?amhNb1lsRTM5Qnl6QURyTXhuNzVzWlllb0tseU9RMUtpbGI5Qy9UQW1NVk55?=
	=?utf-8?B?NlZNam9Kay9QMTduVjJ5SDVkUGIzUHBVUlphOTZ6QnM2b0FWV2pFVDJXUEEz?=
	=?utf-8?B?c3ZaZ1crSHFzdXpmd3hxYVRCcE9XOXRMVjh6SFkzVUZyUVJzSFVOZDJuWHZI?=
	=?utf-8?B?cGY1L2NkZHJrVnJEcGZwTlJOQUU0NU9IZmt4YlFWbVFMMmdFV1FzeVI0N0pv?=
	=?utf-8?B?Uy9GSmRlYlVkRC8vM1RHSytub252TVhQekJxR3VucitUeC9IQXBSa21vbHZh?=
	=?utf-8?B?aWxQRkFXdGRkUW8rUW1oVkJOZnMyZnJoREhlalpzUHFCYStUWnhSQXN4SmlY?=
	=?utf-8?B?cHRuTmhHTUtZK3pzeWczUkMzSlU4czhiNm1CT0xIR3ptZDFTOE0zVXR4cG1O?=
	=?utf-8?B?NENteSt5N3dHUzRIdENlZk84RnN5dGVqVmJDaGt6Z1lrbStHQ2NxZTQ4MTF2?=
	=?utf-8?Q?y9lLmyBCau4XxyIppbhL8LN3+AiHwJR9ckrwQ6r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d3c761-a299-49d2-c8c5-08d90a5f20b2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 16:03:13.8126 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZYrHrqhxWh6iK/wdJ2nV25vg1/mMfzUo/w6jGon/GeH196JRsIW6xOSfx4PS6j3kbUq8msiqg7dQ5xio7BuBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4543
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
X-OrganizationHeadersPreserved: SJ0PR10MB4543.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	malwarescore=0 mlxscore=0
	mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104280102
Cc: rpeterso@redhat.com, agruenba@redhat.com
Subject: Re: [Ocfs2-devel] [PATCH 3/3] gfs2: fix out of inode size writeback
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280102
X-Proofpoint-ORIG-GUID: CHbI_CXI_VoX9KH4PFUAcAkyyWbxoKwX
X-Proofpoint-GUID: CHbI_CXI_VoX9KH4PFUAcAkyyWbxoKwX
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280102

Hi Bob & Andreas,

Can you help review this patch?

Thanks,

Junxiao.

On 4/26/21 3:05 PM, Junxiao Bi wrote:
> Dirty flag of buffers out of inode size will be cleared and will not
> be writeback.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   fs/gfs2/aops.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index cc4f987687f3..cd8a87555b3a 100644
> --- a/fs/gfs2/aops.c
> +++ b/fs/gfs2/aops.c
> @@ -133,8 +133,8 @@ static int gfs2_write_jdata_page(struct page *page,
>   	if (page->index == end_index && offset)
>   		zero_user_segment(page, offset, PAGE_SIZE);
>   
> -	return __block_write_full_page(inode, page, gfs2_get_block_noalloc, wbc,
> -				       end_buffer_async_write);
> +	return __block_write_full_page_eof(inode, page, gfs2_get_block_noalloc, wbc,
> +				       end_buffer_async_write, true);
>   }
>   
>   /**

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
