Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13C1CC43334
	for <ocfs2-devel@archiver.kernel.org>; Mon, 18 Jul 2022 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0G2acZWkiV3vVZMmUhzr6jfznMVQzIbJXsS9UtZQ90E=;
 b=FQ9AxzwqMkisENJORNkZyPfX+R8Bnjmzll9VPUERzwHlKtu004Qvl+JI2mN5qhzwiYDuEd6B6A4p
   HNGjnyms1CW/2GC5f/Kys2AABC/yIlgQAYJDoLrhUb2N6vHF6SlL/qimQkbHOv5Wc5oCsg4HdJTD
   OVcgj4r89EQrlzw4etQtcKd/SfxMB6phv5l1taUKp6N7H5evnMOuzNVQiMN5j3iDOmwNhU1eHnj7
   8rms8O0NklZkRrAZmqSs4/F38T0qHEgLDGtzG1exlpElWMQScFF4I7nfQvBu8/EUtVKWm5kAxLq2
   89ZRa6gg4PU6ZzrIvkMES7CXyCdSFOHfdOp2tg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0G2acZWkiV3vVZMmUhzr6jfznMVQzIbJXsS9UtZQ90E=;
 b=AshbgMlsKX5qfXOKCwMXLULjXjdNtxTd0z7RrFkWq7+PjfvzQFkGG2k0lprXZhDYMtNcBx7wthpY
   9tO4lHqqB4zYcPFUy79J37Ozj8C2+droFxzSU4Cd8MXl3Lm28k5hDmaLOxu6TgJKh/k9xgDtWBlL
   op+CQ5tHrPMaQHwuSxlyzzW9xXnxVlTTudAsD4KZHCFpk9lwfKQyJ14OP0lqe9gvHkB1/oHNTAzD
   e69zMN9NxIynrqeUzhN/AfyR3wIIWyxJytiysY/5oOd7MCcKwE2TapeYzQqgsuL2MY0PJ28yNpN9
   LSCfM0Gbh79XsRPPtemwFdJwzPs8flnMI2YRuw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF800GFOACCD830@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 18 Jul 2022 18:07:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=l/382ZIWv89MHabu7YBz+U2qU0IwDqLsi4YlDpU4EYQ=;
 b=xxPVd8NTJ2GPnY/KbARDsqkhqg0DTnsoKoClW+7d+sjKGaN/2iuPtQvfGAfD98uHpg6p
 WloLntd1UpaRzT7CHl9C4P9Myc3NF8Q1KgF/NTdX0z5cT8hEGnIfEiV0oT7Xt6iJpDQw
 W5epC41tiO/G0efT6Ea7tEo5PHpnPtvo0Gz6VEyx7KNr+fVOYqC0XK8MCU766eFMuDCT
 nKtx56kgDougbVR3B1YIvBI6pMwZbjLlNDFUny6vh60ulNwb20O+8ksvfLF2Ry3iJGgG
 DXMPEHq/b1f/LQzQyKhn/BunqvQhVLrPvZrX+WR1Jq9llTEl1rxvsAWniTBvnOsFW+QF Jg==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maOJoTEBwY43hCijxnCSQfjf5xpgLVuUfUFMKy5tNi2jwM6RcBVYxamXfkHMFjWDE+ZRbXwjK3Ddn85c0Lta423e43BSQmur89/sZmyCxmBlahoXRnnxrtwnPD9puZGRYNm4GfO2NW7obYVL7Z/0RIszjUJ1cT3TKak3/jezcRbNmASwIHBxk46kM7rfBvvQCvPJ+U6/gpOq6rwu4UWrsSO7y6MMl1x4FeTAb6NZUL4i7sbsVVuWGgx1zhAR3FJp/w5E6pK3vcYa5gv/asWsoywiSFvEzGgKs4mfUDKKKg0eXZ6wSv9AFuP8t0iGMaHIgBlygnVSAfzHxtKfIxTcig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/382ZIWv89MHabu7YBz+U2qU0IwDqLsi4YlDpU4EYQ=;
 b=iMXHKZD2euU791ZwWaKV/QNOy3ujj3gzZUvulL+r7C5IT1cdIIylyJAV7Y1+tFQhZnZv4K3LEuAnuvkmJOJRMUNYcO8IUb+pcH5Aw8kuhETr81UL8fnW6hFD4bea7tMDNsZjnVBXaTGlf9bIhHjgbuQde0IVld73dPSp+xNwjjC+Zc5C5ISSDr3B/h+u6Ys6oDCGa+tuPtNkuVOf9YT2ldPOwGiJlw3nvlraot79kVLoRfNNmzJH+W/YrCZCs9ZlU2UyhgCnR/SYEYUuwGmnPX6znYDekoC5sGihriKVjRCoW17Yq0+IWXJVZPgF7HXPqNkyUo5rxpdLo/uzVa5YUg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/382ZIWv89MHabu7YBz+U2qU0IwDqLsi4YlDpU4EYQ=;
 b=Hq2E8z+2rZ92QMSI4ABXVOyu9HdUBbP3SlFkr5N/2Liz9PuXQCpSgcxKdfoRu8cDm4XPqU6KjsITokmDLoG8IV7rRnEa3/JBp6LBhj3h0SaI0fXbG57YcVc3UIZrogvSBbBr/kGAVQAjvvqN748RVdCxyNyNT2DcW11bLP60aYA=
Message-id: <70bfaa1f-9a33-406f-3998-e185daea48b3@oracle.com>
Date: Mon, 18 Jul 2022 11:07:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 stable@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ghe@suse.com, gechangwei@live.cn, ocfs2-devel@oss.oracle.com
References: <20220717043751.51CD1C341C0@smtp.kernel.org>
In-reply-to: <20220717043751.51CD1C341C0@smtp.kernel.org>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 18:07:14.1091 (UTC)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_17,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207180077
Subject: Re: [Ocfs2-devel] [merged mm-hotfixes-stable]
 revert-ocfs2-mount-shared-volume-without-ha-stack.patch removed from -mm tree
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
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Junxiao Bi <junxiao.bi@oracle.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: CY5PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:930:1e::11) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f48a5c60-d52b-4e81-a47a-08da68e857b2
X-MS-TrafficTypeDiagnostic: BLAPR10MB5267:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 d0tI7c6DLnS70lmuq+KGGO7Xk/1JXE6qtoyiXOwHxeJgCI0LnveaeIBC7n2hvSJP7zmSpdGF67vZEXpzP1y7CE1JtQuleU01MBW1/oclvG0wYV8WKj9OTM87nuj563DzMHcPDt0WTp1w4xqinFRwL9EWurMuphmIi8I7mhTavIpc3JZ5sPhdA+lBTqx5IyK41UUFSoVrMYh6wE9V94asuOR9Et2358EdtJ4UB1WSxiTVaSiPUU1kk/gT3VzFCHRdvDLO5xPr0OqVzuCWryihSxCpqLSRYfjCXYQQ6Tjmzj21QZVumiztTSuUp6VgykohuQ+dhEB9mvGPOysFn2uhGrNikrCY6DA92ENONCqE1URASYCwAIwBritjA6P1ifWxlpLqr3OZKSwyi2IIXvYYuMlPDGDb8UWlWg1joxfqM4S5MB/fOEfOXYnEQU7ovSq6OptroqXU/J0qZ385DX6kB6om8NPaMuZAISln/lATLk987yGBy3Rd7logMcP2h4iNzEl8Wv8/OrO73g9Fkynn4YnaEn3R60OwOqlOR8wPkSg9b6NAbm5ahg236UCqyoO5qYziifKtj6x/j7QreAQlIzCAWEG5i9lmFq+LeAbujIl+kQDy0IPD/uNgFR0kzL9zSyj1b43S8ZUybbD4uKoJQXs8NrogKB0/U8+3auRyj6U=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f48a5c60-d52b-4e81-a47a-08da68e857b2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 UjAMrkjIrLmTtDl04t96N2V9F/IrVn3vX4KLYK6ydkgHZcRQoURW4PYN0kuyCiWbrWNxFcnH9qm2MByf6T6PiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5267
X-Proofpoint-GUID: QDZ3iAXUGOC9InZQCuI4kx7kCD35_-k3
X-Proofpoint-ORIG-GUID: QDZ3iAXUGOC9InZQCuI4kx7kCD35_-k3
Reporting-Meta:
 AAFGwzFqwlQ0ERhzswffbnoDM/2iNBZIj/ItJS5BW835afiSEJlZ3nYHyDFgrMLs
 kKnd8uhwBJWM1nenqBvgNOLpvJXSyPIlIf/5ZKYHs0HLsDCup0VOR0OMD1p6aiJV
 bQ/DOJRe4dp3E1yDoOR5Fj6fSyAwEV+ZDIWtRDkmMR8Teck3/Y68NOQ3rkH8CrZ8
 VXFOlrpZFx2KwxbMXHYCiQ09SuNMcbDhN9Jk22dp7lIyIMcOcUA9jdxK3uLA07a2
 PD6WwR0UcyTSdtV7Mnayn0gpzoKk7F87/M/kMerJZq2FeOsmubwqF+gcLFT69SIn
 2I4vlItWeZ5ORF2o7vNNEZpe3WtUCZyFVL2LRcnH1cZ5x0RPGiZl+liMOybKs0UO
 29gHnY7DeurvaS3+WOstWS9nL3KJw/RkAAkaO7FV/i89p3Yays1Eqw6IQZcJufZ2
 NTTFHwbVrPO6WRksJ+rYqXTKXeuKc7GTi5Q/63yNlt0FYzT9HTlwFo59C3Q9MYJL
 XffIQe8HzsmEaTQv04kWIoIsYS0c5UVpvv501zRxXvw3

Hi Andrew,

Can you help fix below "From:" to "From: Junxiao Bi <junxiao.bi@oracle.com>"

Thanks,

Junxiao.

On 7/16/22 9:37 PM, Andrew Morton wrote:
> From: Junxiao Bi via Ocfs2-devel<ocfs2-devel@oss.oracle.com>
> Subject: Revert "ocfs2: mount shared volume without ha stack"
> Date: Fri, 3 Jun 2022 15:28:01 -0700
>
> This reverts commit 912f655d78c5d4ad05eac287f23a435924df7144.
>
> This commit introduced a regression that can cause mount hung.  The
> changes in __ocfs2_find_empty_slot causes that any node with none-zero
> node number can grab the slot that was already taken by node 0, so node 1
> will access the same journal with node 0, when it try to grab journal
> cluster lock, it will hung because it was already acquired by node 0.
> It's very easy to reproduce this, in one cluster, mount node 0 first, then
> node 1, you will see the following call trace from node 1.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
