Return-Path: <SRS0=V2o+=KT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02570C04FF3
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 May 2021 16:24:33 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 882AE613FC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 May 2021 16:24:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 882AE613FC
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OGF48p006094;
	Mon, 24 May 2021 16:24:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=OMWs7UMM8n+MJmfvxXf2VECSCMwypMQcmPySntJvVYA=;
 b=VAy+TbK8BBWmKtgxH/fO0i2HshJ9lvFWKtkNkTMmdu7vxz3F2MB2DcOWNyZym6/AN321
 1/vSYKGBF1/O0Nk9rkQWrT4aa4UUruDNduQbWvOz+T7YN35f31SzikGNYXkOScm27oex
 Z2ytZTXSy0p1TuWO1Faykhte/NfVtznZcYj8mOtvA0dwofymG/VPmRlz7kbO4jwM1vAk
 f4xCgzpMcT4vG4G1EhJwq/Dy51oaS7g6RV6h6sfwlqiaF2LQbBtAuXOj4soq4IDqH20h
 HKC3+GKv3jBIqW5tpXMjrAO9aw20iZGqXdut+csCP1YDv33FDoOBlin4T/JERRthW1WH Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38pswnbjdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 May 2021 16:24:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OGG7U7086780;
	Mon, 24 May 2021 16:24:30 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38qbqrcjgv-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 24 May 2021 16:24:30 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1llDNV-0003lM-J9; Mon, 24 May 2021 09:24:29 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1llDNT-0003l5-8Y
	for ocfs2-devel@oss.oracle.com; Mon, 24 May 2021 09:24:27 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14OGEiOb111407
	for <ocfs2-devel@oss.oracle.com>; Mon, 24 May 2021 16:24:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by aserp3020.oracle.com with ESMTP id 38reh7eqk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 24 May 2021 16:24:26 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23;
	Mon, 24 May 2021 16:24:24 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9%6]) with mapi id 15.20.4150.027;
	Mon, 24 May 2021 16:24:24 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20210521233612.75185-1-junxiao.bi@oracle.com>
	<35a1d32b-b8d7-ea9b-d28c-6b4fd837605d@linux.alibaba.com>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <8aa90f5d-e4db-5107-1d3c-383294871196@oracle.com>
Date: Mon, 24 May 2021 09:23:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <35a1d32b-b8d7-ea9b-d28c-6b4fd837605d@linux.alibaba.com>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: BY5PR13CA0019.namprd13.prod.outlook.com
	(2603:10b6:a03:180::32) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-138-166.vpn.oracle.com (73.231.9.254) by
	BY5PR13CA0019.namprd13.prod.outlook.com (2603:10b6:a03:180::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11
	via Frontend Transport; Mon, 24 May 2021 16:24:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71f5a440-a7cf-47d3-c2ac-08d91ed064c9
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+7WOBJqwkGoEShiyNajPaTcwMG3T3bzE040ipUGA6brRkg6XRZEn4VYbqQSttAbj8Q64OkqKBKz+Ovk0IGdBKN7UDhkbcGUm74dSmDBYZ8UXJmwl6Zpe8m6O+/y57xP7JpGWjggBi77wegY0jCfjv8MC8E5gTILB0FFOnrHalGUePHrsvELNridPoiPXUrkmnlmaSVsIw4A4Zyxh2RNmuwxb3JbUnQKIuJM02NUo596JwJJ8GzZvpvog7wNS9cH7Fq+y07sWit36Tj2LFO5py91FKdy4cY61PAUwHa7KkGQBmZO4/jPC4ZXzI9RHZ9OSrM3KRk/x1SWUhI+dNVMkwyz6T5XQrWiQekjJppVLlsqkzXuvSQ/WxwQCairSYnQPmghNWm6mlUwZFejF5Y3aQt2XiNjcboplHdLNG5EKduR4FoOFa5EjxFD0s8Bw+zaiS27USCrWW0X3aajgLmm07kU6g7shVw9jJYCSRZTVpsD7LXB8yAm1BUf0pyaqm249CeBeuTT7n1ue0ubHGAW8O7kTeYzUK5WyCBtSMq7XWOUm/uXwF85sSu22xcEBOpMTunbpJV4/dpQqaG2LxIwajEkfQJG48A7NHxuxkFAz5VyFToUOfuj3nH+xNRO37dD/6sIRafdgdke3QzYujt0svhl54mQJjXhIvOfm7rBTTI=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WWRBTGpPRzE2bjRTckwvcnN5S3gyM0N2dGE1L0ZUMlluU3B6bUo2RnF2V2JR?=
	=?utf-8?B?Q1BMWFFyMHMwODU5MXo0ckM5RG91WlJaRWE2SS93L1hVeC9ld2p2bTZNb01U?=
	=?utf-8?B?QmdOYVFleUJ6VWtJeHFKQWM3WGV1bStDWHhwbFBkSzVHcDhTSVFPOFVmc01V?=
	=?utf-8?B?d1RxQ3NzSHNicXpTb2FyVG1Ca2MzQjJRR2JCNjZaTWNVQzlPZEdMYkJET2dT?=
	=?utf-8?B?WnQ4ZzlsOHlDUmcrOXB1QkoxMVJQWVBpZ1psVjI3TmhiaWZRaFRmV2ZET0RS?=
	=?utf-8?B?dW1LcDB3Vzd2OUdPZHA5aS9CVEJjdDd2b1JpVHEzSmVBbXk3Q3l1U016S3lJ?=
	=?utf-8?B?Y3F2Zlcwd2orb3d2Y2Vqa3BMUUNINmdvVitIWGJNRVNONFhVZzZRYW9JL2FM?=
	=?utf-8?B?dFQ5MktZNG1SSUdiUU5QSzBOWjYxSHZzZjgyOUJmWVZ3RENGd3Nsa0lMb3ZD?=
	=?utf-8?B?SUVpdUJxSlpCRGx1Z1JNMEltYi9Sa0FlQ0RKakliaHR2YlFUU0c1TFFhMHRs?=
	=?utf-8?B?c0RuR201NlZnNEhQZWVlWkpveithWW9QaXlQMmdYOFJ3SjgrMUoyaWpmVVM1?=
	=?utf-8?B?N3JrVjlIa2NGenhtVzEzeUg3UWtNRFphN1VUUndFbnM3OUs1TExyM2FRdHJt?=
	=?utf-8?B?MVJpdHpCL0VmNzBZOEFuR3BMSFVXWmw3ZFZsTzZlSlpCcXFEQVBHVnc2YVdq?=
	=?utf-8?B?Ykh2SnBDOUtDdWwwdGh5a1ErUnFSVzNwanlQWkFsVWlxZS9ZNHIwbCtZdHRQ?=
	=?utf-8?B?by9VbmtXZk9wOVR0RzYveER2aENjMTJsMzc0ZlJodnExMEdaYkxzVGxreFc3?=
	=?utf-8?B?cllML1RaOWZuSzRzd2pEU2VSMmVIQTltQUpvN3JjWktzYmUwR0F4ZkpCcXBD?=
	=?utf-8?B?Qm90ck02bXZWcmhEaXJvRW0rUUp0TDlFVEdpdHhocG5WZzF1VCtoMkRhNDYy?=
	=?utf-8?B?TE1aU3lkWVlDb1VHV0JtYkowcWFzS0Zja2VwZTN5NVBpcEtxYU04dm1DNVhj?=
	=?utf-8?B?WFFsdFVRS05tNDZHK0dFbXBEajZBNTd3cnZLSVU4Ylp6Mm1haU5OS0k2TTR2?=
	=?utf-8?B?UGwvN3JIbFA4OExadHZxRzl0eG1PM3ptaC9HQ0liUmhiVXBSY1hrRGtSYlVB?=
	=?utf-8?B?dlpyQ0xhMkYzemQ5c0RpTGFzSW9ZbkxUcWFld3lMNnVHNkh5V1drOHRqQkVi?=
	=?utf-8?B?VlpFdG1uY2h4SFN1UXNyUWVtZmR0bDJXVHJBMlNEZ1ZzUjhpVGpsNE9qbG84?=
	=?utf-8?B?SkxkL1VTalFOWVRIdlQ0Wk9ENVZDMk5rOWhJeXZuM2lPa2h3enlKV3BxYk91?=
	=?utf-8?B?TmxkQnFlRVRhcXFOTmJzc256RXZRdTNwMzRnSWdXeUN3REJrckkxOHZNTDBl?=
	=?utf-8?B?cUliRi9lOUhXM3VWUnlMbnI5WFd4aTFvblB4eW9HQkw5OEFmdFpwY2k3R2oy?=
	=?utf-8?B?dHNLZHNjRjlVR0M1SmNQNXp5QmFmRGMrTUVucllTU0xyc0d5ZCtkN25ndWRU?=
	=?utf-8?B?VUVPaDJBQ0o2VHFYc1R3bzloRTlyREE5TGU3R3VmcUQ0ZVhuTUhScnlESnI0?=
	=?utf-8?B?WndtelZnUi9YV2VRc3JWNjBZQ0ZVK25nU3BDTVVkUGhxRGdXZ21TNlRPUnVD?=
	=?utf-8?B?U1RWUHUvWWxCcnpWRjVYcjM5WVFhM0h1U1NoMnBMalBXUTV5OFhPcWtpeGNI?=
	=?utf-8?B?OVladURxd1NWNFlMQXRjTnZoK1Q2TWpKWE5tVDdQNXM2ZzhxTDhhNENUYVVq?=
	=?utf-8?Q?WS1XXgGvNDkEMEa7wzpnTxc2OyLHmKsoqqjBoN5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f5a440-a7cf-47d3-c2ac-08d91ed064c9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 16:24:24.3277 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cfCLUJX/gvCuNz72WRts6yFWPGdTX4kWlQWcDXomelVX+lPRDZrpe7hZECTdVOzjNjS4kKqKqzK+RpanyVj6Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
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
X-OrganizationHeadersPreserved: BYAPR10MB2469.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	spamscore=0 adultscore=0
	mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105240097
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240097
X-Proofpoint-GUID: voZvLMo4I3q-brKZ4fcpxWG1aIuU5Luj
X-Proofpoint-ORIG-GUID: voZvLMo4I3q-brKZ4fcpxWG1aIuU5Luj
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240097

That will not work, buffer write zero first, then update i_size, in 
between writeback could be kicked in and clear those dirty buffers 
because they were out of i_size. Beside that, OCFS2_IOC_RESVSP64 was 
never doing right job, it didn't take care eof blocks in the last 
cluster, that made even a simple fallocate to extend file size could 
cause corruption. This patch fixed both issues.

Thanks,

Junxiao.

On 5/23/21 4:52 AM, Joseph Qi wrote:
> Hi Junxiao,
> If change_size is true (!FALLOC_FL_KEEP_SIZE), it will update isize
> in __ocfs2_change_file_space(). Why do we have to zeroout first?
>
> Thanks,
> Joseph
>
> On 5/22/21 7:36 AM, Junxiao Bi wrote:
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
>>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
