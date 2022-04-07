Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A28CC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=q41LIj56uFdjXscCUfQgaaQSy+QlcaQL0M78ueAkroE=;
 b=wbAKglCfCiu2w74gn0WoeE+bf16Hr5wWgVkwLfrGXHUmlfiXIvANkCuDI2v2ixHrXa5YMwGq++7k
   pskJQ/U0N6HKN0KNTQ/i1mfJQvO/zTqYfmTxJA35wrRHlZiCFPmRlZhKsnwBBOHgjls527Lnap55
   bONnhvLsf9HQ79KT/bK4844EV7j+2tfIi1AH50V42XXNUSGlMQGWYJEASS+a46bigeC0iPjPTjH8
   MhJ9PqwUUgRAUuPvcNSZYCnm3RPxk+r5YeeO6KBQf2EDtygHMXykX1TTiqiZC6xsD/0xMKiUjAbu
   zR1SPkxUh+jqYwA6ypOS0Iqe3G8YfWfCakfL7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=q41LIj56uFdjXscCUfQgaaQSy+QlcaQL0M78ueAkroE=;
 b=E6/WGF16iWFmObYoUuolKD/IoY3poj1C/22Mw2aC6bvNIPc9+/8TL7OVine6A1IBhMH2xj7Z8cMj
   0l4HatQcE07TEcYa2sNhLCRL49NB0xyIS97/T6NRt3uhgf4X6FS4Jz7zt98Syq62ntwWCZYsx8PE
   Pn/OSwWNP03oasrjWJii6eeIF3h1ZyeH2hsO0n8aedXYNA3EXKvrLhgzIt4HAcwWQpK3svk8mAV+
   ao9GYlSAjHVzILCr8jza+by7xvtcfhn/8bjIcwgCbvgqyCY61f67LX0EvcKDY/OLmoE/LpUp/7uS
   9TTZKn7X8qPqbJXKN8twk3fG8iYX0ayVwRjaqw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00AMZ9ABSLD0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:20:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=m/EtCka1eaYsLn4wuLA71mCTmTy3QS19BJ8BeeqSuOU=;
 b=ZPHXH9uSshBLgJPOxwZdazVTI+3fnYybLxHdKrsDfbz5gkyocWDiaMS5jDrpJhY6dH5t
 e3roP2aEvv+YiJGGj3Z3QpMrYYwBTf9bl4ClquniFhHPfEJr4qm2Ds/oGFYCcZW7QCdw
 vQNumMDNVOrEzJbwGs4lvvr1Ud3XtzCYD36ZWDl8nKE3T0bnZudKB6NDXQ2OkGYiGJ/r
 DBND1X6o67sgshKOphRvOHMKUI7ve5ERUZzP10He02rnpHiV9o6r9EN38BXG5yjXwQQz
 Y28XuFlAWl8LJodhIZpPSjsQxEVlq9XeTW3ytrox3m87QG2hyIs+lG1EQs5JwJqYG3i/ SQ==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.s=selector2-oracle-onmicrosoft-com header.d=oracle.onmicrosoft.com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WoBLT2m27j+xZ2yRmxfA/ONjamP4BtjCE6/bTbdGWpApvL5jpK76+WDfN2ozSGukvpjXkQ03c92oa5HVOu3FbONUuY45nUDAu+jMy+qiWXnxgHt1Y5VDU6gInBwy48/6JzG+r0Hy/+8OYMMzPbpW2npxP4RY3JoTncSvDCDk1I8JGTFG4zIkwbX0aQ194QiH4Yb65/VO0oP3rhTD1MXCP9cnQNZenxQH2/UH0CLnqEdBvMRSLWdZI4XHzP+KU3lIO9Qjl1n+uJRxtxkbbZki2QtCGivnxc8WbPJO+jvQSeQfwX0ZxPXKJg96dW6dWvFDjmMb5Pbo33tej/vdnphB2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/EtCka1eaYsLn4wuLA71mCTmTy3QS19BJ8BeeqSuOU=;
 b=bRuJ0dlOsuGk/q4fSoA3Ukq7fOUxedbzJ7rzf2AZjufzuZI9qbYZI89zNeNb52lPVuYvzs2dV9UjQBD9FKEvAYkrHMu6mjg+Cs6tR9kGkHhh9BOfk0K0TzmbxPdKOfXXsjLiDkXl7MhdsPSQ6PkEHt5BmwgGcq/xTLPHlKwIuOfsm46eWM+xIe8O2Ve8AFtPbgFGfAgUYqMUHkc+YCJdJtA93+2hUUa2QMcGe4jHTHV7SqlJeJGVFLo+BUw1lVDjV3gtZTvJc0qBw7c/YlUxuNg2RU8IQZpc4ohTE1HaFqOOjLdNLdYYQvfy5wYdpsO7uYHYnpHFsH9Ohfs90jxL2A==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/EtCka1eaYsLn4wuLA71mCTmTy3QS19BJ8BeeqSuOU=;
 b=vhuqbXFsRe2eFvPxnnA/LL/RgswpldunnT9smQg0eANyImOK/H/2B0dgapp0rPou06Qve4oe8yxOAaCHydW5KKAPjY6IdfvhtgJk0ZDXvANcSqeniwcsnC52Z8rtJjNqlyyzdmTNWvU4S8cz5UXykWWsofiqrHYKsup/XXbZnd4=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1bkxdinq1.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-18-hch@lst.de>
Date: Wed, 06 Apr 2022 23:20:22 -0400
In-reply-to: <20220406060516.409838-18-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:06
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:20:24.8162 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=856 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: Re: [Ocfs2-devel] [PATCH 17/27] block: use bdev_alignment_offset in
 disk_alignment_offset_show
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
X-ClientProxiedBy: DM6PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:5:335::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87fc0a92-fd00-4c0d-f908-08da18458e5e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 NwAZ6dEPM8H1XWavnTIEms/MC/OGkDgnGXiY/GJAcN9DAxrwJ2hrVymZtROR7KMxMCBVl23CjUnrEkYZ74jMfGOGHcDHw+oZ/54dNt8iEs/RyRH3ibtspR0KtKinATkBlXSrlrMs2c2S7Jaygu+w9GEvHjQn841tcERKRmXVP3sofwocbJu5YvtjY8Jli24QPxd3iKgdsu1Gr5I41nUoEICdBm74UEkpwyQrcyUlX0/AWt85FSQp55kUUjntcQSokGS2vYEAmAyu5jxgK14kv371eaZ3bpafKnhPTxlVyZjtyKcfJa/M5v3AClI8rfmtsXSlNRs5a7BsjFqHwMr06zTxTBsHjidLTZ/AHeqqdDVt7WAXZT1S9dHSPosCJaDz9k8aL/z9XuXzmPAEeVeCYHxlKOT4hwbdCnYaI8e31/Qg1439w6/nRq+0YK64fjg0s59ho7E7mHoMEqERjMK60PfpnZOQVuo1mjYX86pFKNN9BSVM2M15zGpzfOPtZy5g19X8a5WRq4HN6+rEKWYfnuMg+GN3wl1AUzo3oG8ocEhkTyLDCLlDVTD+qGQUsBGbh/B+C7UvwFtdK45X4zA/O4l92nazOScUswF0G2m04TA=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 87fc0a92-fd00-4c0d-f908-08da18458e5e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 VFEnsGp9iNzofXDdWVUeVagsevQzAzfKAOUZ7RC8FjwjaI0mXTbFbRwcCPA8WoGfksB8fb4MPqkE7YwP7Z8bcHVScgdeWqmGWAJHw3IuqJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
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
X-OrganizationHeadersPreserved: PH0PR10MB4408.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: Nh4qW9_v6BKQAUQ3_-Jc5_z9zntN-LJ8
X-Proofpoint-GUID: Nh4qW9_v6BKQAUQ3_-Jc5_z9zntN-LJ8
Reporting-Meta:
 AAHeQrrvUBE8PCnftjt65ztCIkivsandck3yZ3wGeyspNfVZeEx+wFgK+pHe3Hjj
 LIboktdaQZepe0H1hexosDqxqr6akN+kAGn6BfU6qGyB1a1xPkkQSQneM7K3W60C
 VMG1J2zd/+k8eKiter0bXKMztWdxOjojLa9tsDtbMHF3lAXgSo6PsW30W854woDY
 9XLBKm30J6lYC63yX9HyYfNUb8K6ozsiiLLUROZFWGujiJGe3rFtHq/1IM72dyig
 rxJdiFu5u/ArFAGZjC1px5BWoOK1Vxup/NyJXUS/ERfTWlKLZIJKJMZTm16Y8xjL
 47I3kKVM7thdTK+B3xAZqg8rOByCu0XhQzojqmzsSH+HpF8XMwCYhWNaKLgTOtrm
 sK/4QNtew+kcWSE5x6e47aCh18sDzUaJl3Nvos/Vm98aspsE6BdnaLN+9XDU0cm7
 XGTpY7w3dEw86M3rrU1XQz5dbEZJgem45JBmu3ytKVE5YHAqJMQIcbl3NRu1J+Sg
 VC9HmP4HHLgkmLdVzoM/vUKAl/t4a8BMCRBzM3GqQvfw


Christoph,

> This does the same as the open coded variant except for an extra
> branch, and allows to remove queue_alignment_offset entirely.

Also fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
