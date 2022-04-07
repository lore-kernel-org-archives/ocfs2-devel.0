Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3748FC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cNMQcTADFF52TllcV2/PYj93Tgh5N2sNOAN7Hp/IGYo=;
 b=Wd1lBwUmdl5GfUDc6sgSW+nYukSnr13u8TYJjYB/iIuBdGOC+QhduxrI/qP2Vx8PAgJ8qtd0aDG9
   IwMmxmiO9Qy0jJcdOelsnpctX7Xxcb+NwvDo2hfEiJGwTzU/7E7ZLzXgS4+tyaEnFZXLEnzeFWM2
   K4zVzyD9oWcsuR4Pnuz1SFiflMcMkQbh5WTEbQbdDzJx9nACNBl6CFQzT7TdZcE0AYc9NPtEUUAX
   6vznfz3Lb8XkK5EJzldSdhIbIsaNOAlPCofek2LuefVpD08I9nhMsOgUv2Hpv8Et2ZohY/BsrsEW
   A8wSJWT11k7IunqFbtbTdSzU827rAcS9kUiGNA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cNMQcTADFF52TllcV2/PYj93Tgh5N2sNOAN7Hp/IGYo=;
 b=ZNNu8SQe+HCRv1JI3WZOID7pUH8js+wivIPZYK7vfUR9od3/iOYzVW1IhPBLzWbJUF4eub5MKfgA
   tQ77o9n93sDZCruzWRuVlgjhUjCzsPsGNctJWXCPAZmrZkEzGFtjJNxXr6LM3S5x3kN9vFE9Y7nV
   gGXLDTOwhAd88RTntkv+YVfNAanlyFP5vKGatNJxMxY69Id4j4ZIizCmieJwGHW+g4hHcR3j90SA
   UlSR4UAYu3hEsEa9IZQo9/CkoyBGZz2YdD4TiLQvqST9pBYMVADoxNmaA0US4fOo+ACVJExDBJ9N
   sKMoO4R5mL8rUAlARG7n5QbNptMP4RT00k8DUw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y006039P1IL20@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:29:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=FspSHwF13B9BbpmnqcGUERmum6Re9oIDd5MfxvXKoCc=;
 b=jXI1CzYEboy0GNUF6p687VbmW9R550d6ikVNLtrqzG9nquNygNVHYrP7eoa7jctskKF4
 KeIloS+shiz5kphPTwYWc3pNDEJIw4HsW7QNmTCxbwps+wQB4YldmJn7P9mJzS23yiDV
 fqqvbkec3PqVydLqQO+y1Wn0ajviBVE0KsO5mht5RlWI0SnUfHb1FIYWN7fRxxOxwnbg
 RzCw2JiYddeM+gS6fA9duMVLmrj+YKLOGXTlWrqOBtXKQd/pZKAPX0igHD6aGPdWJyxD
 YLsXGiTgCfXwNpPSTUa2L4ZwNM4ZZfuKydW/34EIQ1j6QH499OtWj8aIkGpYfH4Gpa22 hA==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDAtrDU3F6pV3UaS6VXZ6LQqfcrbE7N7aDgV8u1aCVNO1yvnPEqmH8Lu1ReKJ3EObtoITffKGCJBohCu63tVkpKCFQouU8YwBbGVNTYkaV0WiAmtkvbOcTZzJ/RWoLah19eN+1Nxj3TPNZXZdDAgJs5NA8vyA6NQoMb4ekoDYAFUbZoSxBRT4MOvSpwLGQlMpV1ag1sRoBM/UBe2gLgi9PuovwAbYlTYvZRAVI0oZ1F6YExg88Dvt2IhJ/u/8+Ixk4Lx09LnGat0wvzXz5MDvMzrJVnzMswK/dhQb7aeOBV4VAvtKb7M5FYo+TaGMTzuxtNVQNwnXBKFauvjf+0Ahw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FspSHwF13B9BbpmnqcGUERmum6Re9oIDd5MfxvXKoCc=;
 b=ToGBGX3xdLyEJJ/ECE0vDrCtvE/2BMf7odv4eHZZZnqQxu40tTwE7wmy1QswnU7wJxiL7SlzZBDW+v36lnn2zjRC8Wts875XPRn6NivYH9SsyFzpc6YDtg/4IHKEmhWr7PIJXrWiZcL2eAE4k4qP4pj3pfXGFscraMQt2pjdDgZH3joFVznkNG/j5gwxNVNrOspsfTdWll/pF8Uroi0Y6lozG1u74XfB04so5NGYypA4bXHhZyDbPm6Dd2SMshDafl5Y2qccxy8MxJEB1kcdE8XCaHDr7xAa7H/iuu7hiowK/9qfnlEnu5IwYQIGDIP3hc5kinFYFu8OgiuDOdJMtA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FspSHwF13B9BbpmnqcGUERmum6Re9oIDd5MfxvXKoCc=;
 b=D5VBReJNuJ/cS+DMVeVZ5PBuPeBz+prE674Zi2hVRueo/yBWZU3xcRWvc1KfeZRuMTszdrZmbrwRO+DwXLbGH/uF9/YzD07DwfFUaf4of/CEBzh2l6Z82iurC+gwztKi9FXB/nFzK09amni8zQPsGcjCcSpGuu5ad/0Qskzc3u4=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1ee29h8qx.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-23-hch@lst.de>
Date: Wed, 06 Apr 2022 23:29:08 -0400
In-reply-to: <20220406060516.409838-23-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:11
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:29:11.1892 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070017
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 22/27] block: refactor discard bio	size
	limiting
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: "Martin K. Petersen via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Martin K. Petersen" <martin.petersen@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: DM6PR02CA0141.namprd02.prod.outlook.com (2603:10b6:5:332::8)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8070910-ebee-4181-449c-08da1846c81d
X-MS-TrafficTypeDiagnostic: SN6PR10MB2637:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 9aO5hdeMoF/wBGFyj/1pl8Xi/uxBqAryOZkExctcxQsJFbnA+D0fGljTFYTA4gFS6BgS+6eWVeZ2Zmu6Wt+fYB4Ug2vDBr81T8z3z7DV9B1PF0AW38V3lc6mG1yAkO0rcXAyvowAsgmMetthj7WdKtrREk4YlGpHY4rwQPDseEVjTVuGjsbWxPfCKm9SKwLesPzmQgJtt3YIVaYo5b5TacI9MNrXbSEebMWUAllMYt9hESZ5tHvMD91ZBBm7HqY+2Q7LUKDzaKKkAYFukrddZTbVtJ77kgsCqP/eIzo6d+sV5/DTV6LnI7V6DOBp8AAaRqQx0eSxQMf5AW9KpLKaawciRlCbLAxukFmozt2a1QeUXWzkeXtt1lf1pVBfdppBpA+0tMLVzt21hfmdy5EZGcenky51NT2BgXVxeHDRiSSx9vtiwKmUT9Ho/fswvYMfHlThWunKPF63WdHBo2g0caPVUXURT0ejAzDmKpQl8q/NZDe3VHceqgxNQupe2l3DIC1+/uZIxwziTuKDHhInEFQRNrXUq9yp64RY/z14zVzstRcOUpYyYPArdDvwOaK4N2qEndApe0CONUHWtckhTjzRgOatD7x7cS8xqrqjFDo=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 e8070910-ebee-4181-449c-08da1846c81d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 gi0BFA2Ok7V3tE3LFDdJiO5tuxtDLwrPwtU1KTZgJtOze8Mi+AtLFgp/5Z2pc2BPvLLQTZ5iuHjo0466k0W+Blb8S3MwLDwPCIAyDfcmlAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2637
X-MS-Exchange-CrossPremises-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Martin Petersen <martin.petersen@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 138.3.201.44
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN6PR10MB2637.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: IIxefS_cniV6iEk19TTQxCG7GNXovzh5
X-Proofpoint-GUID: IIxefS_cniV6iEk19TTQxCG7GNXovzh5
Reporting-Meta:
 AAFjSKhETlaPLY8NNvhy599cUNqLbkHMQ44aD+cORvhU4HKrBs9r1vVX9IloyVyI
 YBCT7qFQAMl/oiWVWFhsdPMfZIteuc6CN10rDm4VK40JqSf/16XkP8IK94nl+ZxO
 j+pjiYrnYmaTdlvKZSSrxXEyEQOKwmJmi5+wk8QfSXWicYuCwi1jxEInbmq2Alpj
 XvAR2RaAqRwun9wHJchHKqsq23qLBAk5Hq/XFF8xWV7oaFAmqLPF+K6xc/22kEez
 jndUuQRT2wKXXe4j55exYTJ+TOMsanajQ6uSo7w+jy5kZhUsFGPMpW3LSKxKJaQr
 oREl12BB7llsiz3kK1W+6xlfF3WtjO7mSKn0EheOvmN0ITsv2OM3ppS33CP+ez5Q
 5gNoWbifRZusTI4JBwoO/QuEsat9F66HGR1yxGI6QU3NgHz4c06iWPfTmZPvCLq/
 oK1cB6eb4iepzXrgB11TAatTMAfUGhV9aBRm30FaDZMBJQXUTZhv0bRT9wyj4sIR
 SDCX23rf3817lpOFveDlpZSzeAuRrQpo6bNCq3z8M2I=


Christoph,

> Move all the logic to limit the discard bio size into a common helper
> so that it is better documented.

Looks OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
