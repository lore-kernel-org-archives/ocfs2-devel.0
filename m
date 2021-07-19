Return-Path: <SRS0=S1qZ=ML=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406A0C07E95
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 16:31:35 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C919F6128A
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 16:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C919F6128A
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JGG3Q4005012;
	Mon, 19 Jul 2021 16:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to :
 references : message-id : date : in-reply-to : mime-version : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2021-07-09; bh=kqjG2cQP72rUaCfMTN9xAd4ssijvShpmQvXmVnC2790=;
 b=bgiY7VhxE8tSFt+taB7E89UkrR2RcdeXg3RlEk+EIyD2UFQpi9k1pXMFJeTl+qRPzahI
 M5QLZKtc+aQ/wNNT84/kqEyvsgyb3+brFK3J+ADMPycl8wtfk4SrXYt59XzRTDoWsN4q
 kLXacvsv2xbZy9FOFE0yfSzU2XU6NsxyBsjqDnlEyV7STcElz85b9l0kWLEWyyR7A5Db
 FHGqoPY2WKwX0kBVS5ehcUgk5pHKsZ5HDmsOOq4fC2quvdMW7rFDx34H/djspoTazwck
 U2jRetQI4mSloknDnCIQbe3CehfFedebZIpqW1TFoZDwraxXBrQu+g/oNRz7PxlpDCAO qw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to :
 references : message-id : date : in-reply-to : mime-version : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=kqjG2cQP72rUaCfMTN9xAd4ssijvShpmQvXmVnC2790=;
 b=eb3Z1EGHurmCPBJ9r5TuxWOCk311DFeXkNe1LzoF+Yq8n7QHM7fa82jf/zWQqMNcAPxk
 D0+vo1kfT1qp/c6NiyXYqZGJN9Vo1t3qm7ib3Gdvi+xrfLpekv99f+um3Rl2VjMHThPp
 PWbTuWoMsKIk4IvL3hLUShn3YgFLBPrAAIF03zyXOAyqV3MIGh6LFzifAXJRkaZ9IHJI
 0MXlCohGZFfBZ1qRfJBuojUC01sE9FuGmLrlIGLl2oihFxJ7k7TmblUthOu1zWgzDMaE
 6VxdKm8yQhNSLw1JqVIpwFB7WLiMJ2DHVA+FNkKWqBU/crbC1h52vdfXlmi1tCCaDW89 tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39w9hfrj4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jul 2021 16:31:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JGGOl9131663;
	Mon, 19 Jul 2021 16:31:32 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 39umax7pqp-1;
	Mon, 19 Jul 2021 16:31:32 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m5W7y-0005S0-QC; Mon, 19 Jul 2021 09:28:22 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1m5W7T-0005Qv-19
	for ocfs2-devel@oss.oracle.com; Mon, 19 Jul 2021 09:27:51 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16JGFDcP182823
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 16:27:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by aserp3030.oracle.com with ESMTP id 39upe8hg2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 16:27:50 +0000
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21;
	Mon, 19 Jul 2021 16:27:49 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756%6]) with mapi id 15.20.4331.033;
	Mon, 19 Jul 2021 16:27:49 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com
References: <20210713211306.50593-1-junxiao.bi@oracle.com>
Message-ID: <4aa9b048-2480-55a7-876c-f02b472cd8e4@oracle.com>
Date: Mon, 19 Jul 2021 09:27:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210713211306.50593-1-junxiao.bi@oracle.com>
Content-Language: en-US
X-ClientProxiedBy: SJ0PR05CA0140.namprd05.prod.outlook.com
	(2603:10b6:a03:33d::25) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-158-26.vpn.oracle.com (73.231.9.254) by
	SJ0PR05CA0140.namprd05.prod.outlook.com (2603:10b6:a03:33d::25)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9
	via Frontend Transport; Mon, 19 Jul 2021 16:27:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bbef237-29ab-41dc-6551-08d94ad22612
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMg8Fm2JoTdOXhdieZE9VNoU3sJa6+Lfz482BTU/l1MjLcb0J7qRppzk/z1ADyPZhEKD8yYQlupkcT61/U2kSYhMJ6R8jwv44oRsi73113+DyzpPWi6+FWeXwWyRWAp7NFooqtv/HmeIpDCQbiWHPaZp0Wbou7wR1hzPU2ctjmW6Q948KwuoWFg+gQE84iv2boxAuKDYTGGXwLqwkYQmJVroiOJFm6ASamR2NChKovlRSyzisGhKknlRyJEGzKjMvLnPJy3bjxk56qWR8RDYi8rt6RogcQpcuBNdz1B8xfkaT6AuxOz7D+GfiMHKCNhF8AZMAYRBXh3OhM524gym+DCA0yBYWvNrS+nGcvR+ijgojQR9szL/sJbmtojuR5G4SNI55WaAzZeBd/P3RrfFyjs9ZiykUbnGNxUEMkBlSsAaZAcm6tgC4jIH2L49JuNPX5x0PcSAnB2AsDCNvl1gq73mFaI8YQgwOmTN6NmIPGQ/D7mQF3xmMNGGjKtvKXZ50EuM3dPVZ3+iRKmL+2eofR1ZytkxasXLRC/PERQgZlg9FCKqU9Fi1MTsdYAHHGT0W2ktVPWNwGi5xYb+K+WevudtfUMmaM2RCpzJpWMBXR0=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WURBeTBBbmJUK0huVk9oWC9iSXVsUTNiMlFjWlltZHcrR0VkZVlnRHA2bGtG?=
	=?utf-8?B?R3ZBbldnSUdCNjYzamNNc2pEb0w3WnF3N2c2dlczc2c1Yko5dWVMK1dZa2hR?=
	=?utf-8?B?SU1ET1dNY3lJS2RjeDB4azBPaGwvOVVxWXZMQTUwVm9FdHR4Q2JKa2NCZTdX?=
	=?utf-8?B?VUZnL29FL1NFN1laQVJPeExhNGhTL3JPVG90WW8vRWRTamZrd0ZFWUE4OWtV?=
	=?utf-8?B?MWlCRkgwVDF2SGMvSE5oajNnZmVkWEFpNVgzU0dNM2RQZVUvWXNNT3dWeWI1?=
	=?utf-8?B?Q0sydGVGVEhyc0lGOTQ5WHFiTDY4UUY5NUFYL0cwdndQN0FuSDIzN0tQajNw?=
	=?utf-8?B?bkh5aHU0K1ZNeVJpRFpkUGI1Q3JZL282WGhjalJCL3p6c0U0TWRkdjhScmlo?=
	=?utf-8?B?dTJtQXpYQ0ZYbUIrSkQ2Y3B5V0Z0VlhUYWZpQXp3TVozNkJWN2xOdTJRVDF1?=
	=?utf-8?B?dzhmV1Y5UWhvbzhoSkV0dDI0YkZXMEtOKzlGOXgzSHcxZkdMMCs4VW9uNGhG?=
	=?utf-8?B?a0lxVUNOWEE4OWo3VHlqOENqQ3hiMGw1cEphUnBXTzJ0clo5V1RyWWExUFF4?=
	=?utf-8?B?NnFnbDRFZjVSc1J2V1NJVWJhQ1Fjc2wwdWlIZGJML2xrY0lobFhXNWt3cWlp?=
	=?utf-8?B?ZTcwaEl2Ymo2VEhXUEc1L1VRVmlQWEd5bVFWeWI0cWNVRk9zNk1mMmFNWXpZ?=
	=?utf-8?B?d1dZQ3g1SW8wN2NtVmhSeFNQbStkSThoRGpTRUR0ZnhKclI5Sk5JNXdaU2U4?=
	=?utf-8?B?YVByRW1aRjVWWVdHcjhBQmN2VTVBcEFaUm54NnF2UWZlc0xMVTZpYmhSaEZ4?=
	=?utf-8?B?UFdYdjRobmZtMFVxdDNaM3VkdHljN1IyTlB5MjVnUlk1RDFkZ0ErcG51RHdV?=
	=?utf-8?B?ekZrR3pIa1FSb2d3RjdkdlMzWW02elgwOGQzOFplM0pMNmtSM3hoUmxMQ2FV?=
	=?utf-8?B?OVpiMmdIZ3lka2ovTTdCaGdrK3VnUUJOSWF3Q28wRDJETnExN2RZYjRmR0Np?=
	=?utf-8?B?RXprMG1pckRlMXE0OGk3SmRkWHRicmFiSlRScHRtK0V3UmlYK1FBMnc2eWdp?=
	=?utf-8?B?Z3p6M0Zld3JWVkhQZWZjajdHdmVla3FuVlNLY21aN2dhRUF3UWJ0VGJudjE4?=
	=?utf-8?B?d1V0R3BURnIvaCtRaGpLeVdtOXduZnBKR00xQnNrUS9LSENoUGFVT2crUG9V?=
	=?utf-8?B?TnlXT3Vzd3FMT0pFZ3FRV2x3QUJZemNVWFVnSnpROW1RNmlWRnJnVHA2WUJ6?=
	=?utf-8?B?K2s3b3lQRXdYY1V1d1pxMk9JQm9ZbWlUN09WNW5kZllRMW4wWS8vSmI3OCsv?=
	=?utf-8?B?SnJKVUtnbklnNmxHdWRmcTVNeElkMFVtMUthekp4MXBLdDI0RzF2S1pZQy96?=
	=?utf-8?B?djU0SGRvWXAzY3dNU21MREpMMjV4VGRwKzFuQTBxYzAycnI2Z2VveEN1T1NL?=
	=?utf-8?B?ZGVDSE5pbzE5N3Nuei9lSktYbzJDeU5Ka0krN3lpdDNxUTlsaFU5cElhWkNu?=
	=?utf-8?B?dlJHQ2tSUU96TUFLZ1MwU3NJa3BNTGJJV1JXZjI2clBwTnRaNGFPSzRJQXJt?=
	=?utf-8?B?cXFvaEtlSFdQTHFIVWFIdkdReGFMdGdUYU03MnFvdi9kTjV4Ly9oWnorL0Rw?=
	=?utf-8?B?aXd1dzdoZWFxUUk3Q2lYbUtrMzJuUDVPZDl3SXpMZUllelNiQmxNTDVIdzdu?=
	=?utf-8?B?d1MydCs5STBCcjVvWExHcVJaTDNJVk81cFdlTFY2cU85d3hrdUhBNHlmVnJJ?=
	=?utf-8?Q?70qLHoT1ws1p8s5bXk/qkv5HZbXXnv13uFp1Qnl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbef237-29ab-41dc-6551-08d94ad22612
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 16:27:49.3655 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49urWgwPk6yXa5Nyh/6Ymhj6eWBr8PW3dZhm/Eg/bGR4mBau7HkXQ2UfetKw3scit1gnYhzfyDsdxA8Jp2qMXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
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
X-OrganizationHeadersPreserved: SJ0PR10MB4480.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	suspectscore=0 bulkscore=0
	malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107190094
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix zero out valid data
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190094
X-Proofpoint-GUID: OhV-1x0ifp4rCJ8ulTwLGuS3mMI-OiGF
X-Proofpoint-ORIG-GUID: OhV-1x0ifp4rCJ8ulTwLGuS3mMI-OiGF

Anybody help review this?

Thanks,

Junxiao.

On 7/13/21 2:13 PM, Junxiao Bi wrote:
> If append-dio feature is enabled, direct-io write and fallocate could run
> in parallel to extend file size, fallocate used "orig_isize" to record
> i_size before taking "ip_alloc_sem", when ocfs2_zeroout_partial_cluster()
> zeroout EOF blocks, i_size maybe already extended by ocfs2_dio_end_io_write(),
> that will cause valid data zeroed out.
>
> Fixes: 1733438b1d06 ("ocfs2: fix data corruption by fallocate")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: <stable@vger.kernel.org>
> ---
>   fs/ocfs2/file.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 775657943057..53bb46ce3cbb 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1935,7 +1935,6 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>   		goto out_inode_unlock;
>   	}
>   
> -	orig_isize = i_size_read(inode);
>   	switch (sr->l_whence) {
>   	case 0: /*SEEK_SET*/
>   		break;
> @@ -1943,7 +1942,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>   		sr->l_start += f_pos;
>   		break;
>   	case 2: /*SEEK_END*/
> -		sr->l_start += orig_isize;
> +		sr->l_start += i_size_read(inode);
>   		break;
>   	default:
>   		ret = -EINVAL;
> @@ -1998,6 +1997,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>   		ret = -EINVAL;
>   	}
>   
> +	orig_isize = i_size_read(inode);
>   	/* zeroout eof blocks in the cluster. */
>   	if (!ret && change_size && orig_isize < size) {
>   		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
