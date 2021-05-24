Return-Path: <SRS0=V2o+=KT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35ACC04FF3
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 May 2021 16:22:03 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3E5EC60C3F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 May 2021 16:22:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E5EC60C3F
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OGEWIN062537;
	Mon, 24 May 2021 16:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=7C5zHir/IqM7JUZ/bWF+EYNwGWd61NcGM6VeN0Cm/pQ=;
 b=0MeuGvXZUT1aiCusqH7v39aOKOJNIUYWxyhq9dijCmewDBvgFJuOdHUAuazsBYGydjTm
 luVM54chDn77DGvURimbiM8xR3bxs4zhPPw7vMepOYo4x0uiaSCq89lOl2lz4T80U0/H
 xabP0BwV4oMYI7FLkOwU5z+3BjGJ46VcZYZwZIYkrUmuXgz6qhaU1ECVWy5P+QxPP0XY
 ZRuRMgEzsgK/R4sXRgcZtMHLfzTlPH6xl9Ezv4MYbUi35Z1LCu8AD3PdDafwmWUNMnDr
 CIEBM0AXZ9JneQI5fD8iG6Yk69f/pswQDFJ3HsCHEOxi9QWtSWGx/oviNJLarYooKI6T LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 38pqfcbmh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 May 2021 16:22:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OGF67e146890;
	Mon, 24 May 2021 16:22:00 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38pq2tg1ka-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 24 May 2021 16:22:00 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1llDEz-0003Qu-Ck; Mon, 24 May 2021 09:15:41 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1llDEv-0003QU-PC
	for ocfs2-devel@oss.oracle.com; Mon, 24 May 2021 09:15:37 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14OGEjs6111504
	for <ocfs2-devel@oss.oracle.com>; Mon, 24 May 2021 16:15:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by aserp3020.oracle.com with ESMTP id 38reh7e2pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 24 May 2021 16:15:36 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB2629.namprd10.prod.outlook.com (2603:10b6:a02:b7::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23;
	Mon, 24 May 2021 16:15:34 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9%6]) with mapi id 15.20.4150.027;
	Mon, 24 May 2021 16:15:34 +0000
To: Jan Kara <jack@suse.cz>
References: <20210521233612.75185-1-junxiao.bi@oracle.com>
	<20210524085508.GD32705@quack2.suse.cz>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <479301ea-042b-855d-fc52-0d7bbdc55bdc@oracle.com>
Date: Mon, 24 May 2021 09:14:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <20210524085508.GD32705@quack2.suse.cz>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SN7PR04CA0012.namprd04.prod.outlook.com
	(2603:10b6:806:f2::17) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-138-166.vpn.oracle.com (73.231.9.254) by
	SN7PR04CA0012.namprd04.prod.outlook.com (2603:10b6:806:f2::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23
	via Frontend Transport; Mon, 24 May 2021 16:15:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 395998f4-2666-4981-14e4-08d91ecf28b7
X-MS-TrafficTypeDiagnostic: BYAPR10MB2629:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ftyVmb/cGDYzfrViM3wiTXPfyfYWClK2dgiF07xn2914K93f0b76Ul6p3eEX8TzBje7QQRBtpgMdxlKWV2h9Cu6pXCXCU4+6YcUVLw1gg7BXXCz4bFPN032Q/Tf7Y6JxmrWoClGIJ3q4jsN9wUSVeWZZXcBV3Xdno1kD3QwWTp9NNd1j4J6nsAmNRTXAbSXSfa/upWQAyrszhAIU995m9R3vZA2Y1qlBdqDJ4vrLwGmPz5RMY5+UDrwz88ectOXzN2PZntRrmJrSoDu4p16BV0kiSOwyTqTYYdMxjJKkgg8HFXdnKhqkAFuwHgOhg9/CQmRBSJMvRjvZce6xT3Kia5RpMFOYhjn2P2XD8gugbSyNuQCap68mXXK/xOqtUGrL5PMgDvIQZW/FyY961Vshk6xL3CTGxYLt00HKLAWM6I29/utqK/CUzZ16kz2Kw2odoXGh/itQZaKDjSn7y2WyUQdNPM+DNGTG42lQpeDDVmX5GH6ZuNGvwc5c2RANEkjpdPSoZNe2rkSKtmd0VQVkTAnoOJ6dQGUnOCKjkqPGJqUw+e2li0sjLQuk8EvUyU0Wm3mzfOL6PtTThTAZ6Axph/iQB8/pMfOtbz89cKI50gcH+yir5TBkTWWQ8Ab40YpijIkENRgxyVaLGYA0bWSTN8MgNqugVwvcTuxjPfPUWx8=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Tm9sK2xIK05xdzdJUkJBNU5EVy9GYU05Slg0MkRFUFAwc1E3KytkRXdkZlpZ?=
	=?utf-8?B?WVh5S2JhRUFUeDMwMVRYamV4MWQvY2Z3S2g3T0pCQzF3dWFEVUkrQXU5WENp?=
	=?utf-8?B?Mzc1MnVVZ3pDdFV2UHAvaFR1RUh2UGh0M3huN3FWNVNIdUFHb2R2c3VMWXFD?=
	=?utf-8?B?SnJ1YjVVNzlPTW8wRUhnK3NLTFZOUXR2b3c4TFFWakhCQll2RVJRRXVyNjhk?=
	=?utf-8?B?eTJjTzBqZ1dONGx4R2xPV09hekJVZnYzdXEvZlM5SDIxZUdyWVAydlFEa2xI?=
	=?utf-8?B?NFQ1Z2tGeVN2WGg2MVpzbWxZOGxkbGdwbnlEc2J5dVd1dlhFb1hyaTBEdjlC?=
	=?utf-8?B?K0FqNGdkalg4VlVqaGtzZDNKYXBKbThLd3pYOVpNQ2M5M3BMdjFQVVZLYUVn?=
	=?utf-8?B?RmNPZ1Baa1FUeVBqdUI1N21QclZqWVdBTE4wMGRkNmRYb3ljWmRtZHRaeDF1?=
	=?utf-8?B?ZStEbkxRdDloSmpNdmFucmlwMU5OQlJ0dlVXcFM5eXBieC8vVHpQUHU5aXpG?=
	=?utf-8?B?S09mcmdaRE1vV0FwaUVDb3UwOXdRZncwLzFoZjNGMWdIbUJHdzdHcEthRm5a?=
	=?utf-8?B?V0loWS9MNU84TTI3ei9KbUJNbUdsNm90VnRzTVd5bUhVMXppdWEyYmhwaVJl?=
	=?utf-8?B?eC80cW05M0pLTHBtZzl4VU9nc00ycDhHWnBXVXBjMWlFMlF6OTJRSjhnaWl5?=
	=?utf-8?B?aU1pNW56THBOOEtvL2hORTZwK29zZzYyYUYxUkhBcUFiMndKMkszeUQ2T21Q?=
	=?utf-8?B?UnRuMUtxYXZUMDBsd0FRK0l1LzNPaW96NW12ck5EQm1ZZ1BIaXoya1J2VjZF?=
	=?utf-8?B?dmFxVWlSVVlWeWdUZTZqM0dxcmRONmRMN29sL2p3MEJLTHdVTHphZmliUnFE?=
	=?utf-8?B?UFlieHMwbFRiQnR6clJtWk1tWlppME1EcTMzNmZIbncyTk9hRWpVckt2Snpk?=
	=?utf-8?B?dDIwempFU0U2YkV0MnBuOUJva2F4WEo0UnVFOURzNCtuczQzbzl0NFhBTkVW?=
	=?utf-8?B?aVExYm5QeUh0R3o4RzcvYyt1SGg4MWZIK1l1cVRoemRCUEtRa3RkNUtEdGU2?=
	=?utf-8?B?RlZQUXoraTVUSHFxajhYUGsyUUJBRTlqeEhDaWFOUndYUlNJYjhJbmN1NWxU?=
	=?utf-8?B?NzJUekxhYkZXcHZ3RExVU0x3cVB1MTJ6UU5vMUNzOGNJUmFQV0VUbXlVcWtD?=
	=?utf-8?B?UzZpRUJjUEpiZGhaWlZKQS92UGJqdXpKL016dXdycldUelZjNmJDSWEzS2lO?=
	=?utf-8?B?cWw0SzcvYWd2a1N2dFFrT0ZTemdIZVFFZmc3MVFyNGpITUdWdzcweDI4UnZa?=
	=?utf-8?B?c2R5elBKbkMyUHBsdkkwQWNnMlJhcXAvSmZoUWFEWFBVM3haMkNDSWpRTUU4?=
	=?utf-8?B?bXZqczJaNW53V2d1cG5zZVE2SUZRanlXb3NrVTcxaEVRZlAyYkpXT0RBekFX?=
	=?utf-8?B?RmpaOVRDY1k2T25yL2EwVDRsOU5qYmNETnk4bDZpbXkwKzA0OEc4ZUc5akZo?=
	=?utf-8?B?ZElWMzcwLzhrSTlkWHN5K0p5UG1uVk1kdFFDcHg1YytDTkRETERSUnpRKzJm?=
	=?utf-8?B?ZmZtbGtJRWgyUDFmZGt4N1RpbTlSMlIxb2p6NDZYY283US9WeG4rNFhubURz?=
	=?utf-8?B?LzdqRnQ3WUlnNDFPc095MklINW1qVGdjRXJmUjlkNzRJMHh0VkFNMERlMkVm?=
	=?utf-8?B?ZFY3cEc0U1RwY0RQdTFnY0ZvMVRFaGZqQmliVjJhSkVrRGZ4Y2w1bkZGbUVH?=
	=?utf-8?Q?bOZkemgCrmvSihu3L+80IY/7S7Ky5P2obn+2N2D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 395998f4-2666-4981-14e4-08d91ecf28b7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 16:15:34.1807 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FbSgQH0O/gPCxuvq4DPfIh0juaBkhqsDab2Qnh9oJ+TeKb4Ubgs0EGlns+2B0TOp5xL/q9kqxnRZ4cjAwI5gag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2629
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
X-OrganizationHeadersPreserved: BYAPR10MB2629.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	spamscore=0 adultscore=0
	mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105240097
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240097
X-Proofpoint-ORIG-GUID: epm7D6ZXOo7zlrWb4jcahzyBei9EavBr
X-Proofpoint-GUID: epm7D6ZXOo7zlrWb4jcahzyBei9EavBr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240097

On 5/24/21 1:55 AM, Jan Kara wrote:

> On Fri 21-05-21 16:36:12, Junxiao Bi wrote:
>> When fallocate punches holes out of inode size, if original isize is in
>> the middle of last cluster, then the part from isize to the end of the
>> cluster will be zeroed with buffer write, at that time isize is not
>> yet updated to match the new size, if writeback is kicked in, it will
>> invoke ocfs2_writepage()->block_write_full_page() where the pages out
>> of inode size will be dropped. That will cause file corruption. Fix
>> this by zero out eof blocks when extending the inode size.
>>
>> Running the following command with qemu-image 4.2.1 can get a corrupted
>> coverted image file easily.
>>
>>      qemu-img convert -p -t none -T none -f qcow2 $qcow_image \
>>               -O qcow2 -o compat=1.1 $qcow_image.conv
>>
>> The usage of fallocate in qemu is like this, it first punches holes out of
>> inode size, then extend the inode size.
>>
>>      fallocate(11, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 2276196352, 65536) = 0
>>      fallocate(11, 0, 2276196352, 65536) = 0
>>
>> v1: https://www.spinics.net/lists/linux-fsdevel/msg193999.html
>>
>> Cc: <stable@vger.kernel.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>
>> Changes in v2:
>> - suggested by Jan Kara, using sb_issue_zeroout to zero eof blocks in disk directly.
>>
>>   fs/ocfs2/file.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 47 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index f17c3d33fb18..17469fc7b20e 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -1855,6 +1855,45 @@ int ocfs2_remove_inode_range(struct inode *inode,
>>   	return ret;
>>   }
>>   
>> +/*
>> + * zero out partial blocks of one cluster.
>> + *
>> + * start: file offset where zero starts, will be made upper block aligned.
>> + * len: it will be trimmed to the end of current cluster if "start + len"
>> + *      is bigger than it.
> You write this here but ...
>
>> + */
>> +static int ocfs2_zeroout_partial_cluster(struct inode *inode,
>> +					u64 start, u64 len)
>> +{
>> +	int ret;
>> +	u64 start_block, end_block, nr_blocks;
>> +	u64 p_block, offset;
>> +	u32 cluster, p_cluster, nr_clusters;
>> +	struct super_block *sb = inode->i_sb;
>> +	u64 end = ocfs2_align_bytes_to_clusters(sb, start);
>> +
>> +	if (start + len < end)
>> +		end = start + len;
> ... here you check actually something else and I don't see where else would
> the trimming happen.

Before the "if", end = ocfs2_align_bytes_to_clusters(sb, start), that is
the end of the cluster where "start" located.

Thanks,
Junxiao.

>
> 								Honza
>
>> +
>> +	start_block = ocfs2_blocks_for_bytes(sb, start);
>> +	end_block = ocfs2_blocks_for_bytes(sb, end);
>> +	nr_blocks = end_block - start_block;
>> +	if (!nr_blocks)
>> +		return 0;
>> +
>> +	cluster = ocfs2_bytes_to_clusters(sb, start);
>> +	ret = ocfs2_get_clusters(inode, cluster, &p_cluster,
>> +				&nr_clusters, NULL);
>> +	if (ret)
>> +		return ret;
>> +	if (!p_cluster)
>> +		return 0;
>> +
>> +	offset = start_block - ocfs2_clusters_to_blocks(sb, cluster);
>> +	p_block = ocfs2_clusters_to_blocks(sb, p_cluster) + offset;
>> +	return sb_issue_zeroout(sb, p_block, nr_blocks, GFP_NOFS);
>> +}
>> +
>>   /*
>>    * Parts of this function taken from xfs_change_file_space()
>>    */
>> @@ -1865,7 +1904,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>>   {
>>   	int ret;
>>   	s64 llen;
>> -	loff_t size;
>> +	loff_t size, orig_isize;
>>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>   	struct buffer_head *di_bh = NULL;
>>   	handle_t *handle;
>> @@ -1896,6 +1935,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>>   		goto out_inode_unlock;
>>   	}
>>   
>> +	orig_isize = i_size_read(inode);
>>   	switch (sr->l_whence) {
>>   	case 0: /*SEEK_SET*/
>>   		break;
>> @@ -1903,7 +1943,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>>   		sr->l_start += f_pos;
>>   		break;
>>   	case 2: /*SEEK_END*/
>> -		sr->l_start += i_size_read(inode);
>> +		sr->l_start += orig_isize;
>>   		break;
>>   	default:
>>   		ret = -EINVAL;
>> @@ -1957,6 +1997,11 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>>   	default:
>>   		ret = -EINVAL;
>>   	}
>> +
>> +	/* zeroout eof blocks in the cluster. */
>> +	if (!ret && change_size && orig_isize < size)
>> +		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
>> +					size - orig_isize);
>>   	up_write(&OCFS2_I(inode)->ip_alloc_sem);
>>   	if (ret) {
>>   		mlog_errno(ret);
>> -- 
>> 2.24.3 (Apple Git-128)
>>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
