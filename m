Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E68C61DA3
	for <ocfs2-devel@archiver.kernel.org>; Fri, 24 Feb 2023 07:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=m4t1IztX8nHcoxzRb/lJswYHCm4EiGm715Ucz2bDVxU=;
 b=OZahS2ZpLbYXnYaU4JZ8paYkDA+GXnjHifBn1Mwgu8DdBPjZmMkRP6aca8s+r56uVJA0xHPSGWlI
   dN0dgzMoU+Hjnssbp+HZRY0msQSdvnR6bpbbrGmxgvRL5tjPMk7jeEP6Vri+TrL/ZUxs3AiF7A4x
   8TgQJNWqlzvrRGU7pq9Rbmy/zyVg/PC2bQk22Fb2WqCFlWBzHIZw8VIjborOq7aB9xRYyKQJQfGC
   baTPeZ7qrwdzR1gvePtDBuJoCyM4Ff3ImWZsp7g3aJlaCGBqFAMkamvofwQ9vh752Qg9mBCzbn0i
   MnH8Ik9sWW+4uwUftDQ02V61T/i0RwRNaDLDyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=m4t1IztX8nHcoxzRb/lJswYHCm4EiGm715Ucz2bDVxU=;
 b=Fc53t8ib6m7u8WhHR4lKSJvLCBUSKU2ShnKt4U+zX6JRB4yd8u6pofihR2OvH5CUiTjf3N354ynI
   ZUtG34OOojSEiDhTqJfqDucX4yLR2TVGCL67bukD5Se+z6pvak9UrAN7DSoAvRGjzFwAqABlBLJY
   HJUBzYUoak5nr90+3tIkdYcWPC2fuJJgC4L/fB1MLxxvpL85W3AjDqjm/Ni07xuucg48Zi3l82Bv
   BN8tpme4HCPAIyLa0oT9vyMibK82oEPxoq4QemejIqFXZLQ1IcTtTK5No8TkbukavWJfsj/GOQmh
   bVI4ohlRayfBTig3V1gFfcMut9t0bGZP9WI+fA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQK00031R1WO160@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 24 Feb 2023 07:49:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtG9zF5y9skND8GqQZ93r2VYdocLRIrD05E12VK7q6ngFemvKjEJDB7OmB7K6eGJ75RorGE7KQbe19rZip/D2QDyBsWbwZVam0LG472gG6V6vfC5qGiL6kLlFRB4P/VluS1cN9QRmAVsrPQKCkZavCCJyOBa3Q6oCHaMEuYzCwSlG6G41XsBlEF1YED70crji/0mxL2DtknAS1rC55+T6PTrUi8Y9CloznGBerTSOznLUYGExoFn7yRNlmiCseb4t19XNKGdwTTE63tcY5xlxUN9ceCW8BdFWU2lPlJh27CIeLMlGfmcTrFG+cWSjZ/MPKM5qB3O956s3T4N+SlfuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZcVUloiNWHV+5mYaRdJdDnDoG9AvoYtd/KSAC78rFA=;
 b=n3W+7HSrcUUfUyudGY75wfk1FKH/++90t2h6REJcb8y7JNWDuodwgmu57c5jqoN/+2ScK9T0lBSjYz3SsZTIEJS1oNvLzE1FcroiqBHXY3IPUQb6YIlydU0gzShoEB+Zd3TIhSn16dCqvh6w8EphsGQXlDAlT312d/PvusAhHLB0gxj5I+iKo3THd0Cf6nOr/1tc+zBIhijMYoaquDiA8v6f2FWM4E2DszgnWw6y+FdsSiqEULHh3+riFxfY6KWePSB6ZyQXnq3+PLwfxDURjOYVKO4kepr9V3uQPj/arFQu9V94HqQqyZViFThholAD0Lf8Q3olKhvq2JKyKnYRAA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZcVUloiNWHV+5mYaRdJdDnDoG9AvoYtd/KSAC78rFA=;
 b=3YqnxtgoaphVIRsHrwvdges8pcauTKbdvF+pl2mX53iQkSDZipi/84ob07SX5B5r13ziRoeEPwQweckhz/1969EbKBKxxoXrhmCSBio5RLRhzGhvQcMB/AKTAr402u0Sl8SfVMQF9RU0e3AKjpLof/C0HQaIq/7P8gQSm6xl/dWEZKoeneDfztdIdZVK2j8X02JRE3tYHSoV/ZDA61SlGRQDezobLzAASnVh+qMRbhBDPs40PlFPIt/DaJoiIU14eM7RIRQuQBD5X+La2+OHiuH2hXwmdy5Ygc9VnOqk0qfdOuGqyGU0Z/F3Ov41ZLKOWVWPnU9BC699b3baY7YLPQ==
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20230224003251.otqzmap2f64o3fpf@c73>
 <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
Message-id: <913a31c3-c3fe-b421-da63-e7d436ec674f@suse.com>
Date: Fri, 24 Feb 2023 15:48:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-reply-to: <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
Content-language: en-US
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199018)(6486002)(83380400001)(31696002)(86362001)(38100700002)(6506007)(53546011)(6666004)(36756003)(26005)(186003)(6512007)(2616005)(316002)(66946007)(8936002)(478600001)(44832011)(66476007)(66556008)(31686004)(5660300002)(41300700001)(8676002)(2906002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 07:48:51.4254 (UTC)
X-Source-IP: 40.107.22.55
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10630
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=175
 mlxlogscore=999 impostorscore=0 suspectscore=0 clxscore=206 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240063
Subject: Re: [Ocfs2-devel] report BUG: io_uring triggers umount error
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: TY2PR0101CA0034.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::20) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM8PR04MB7731:EE_
X-MS-Office365-Filtering-Correlation-Id: 44c24ee1-222d-424f-4e10-08db163b91f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 ua4FvI9l7OCQirnFFdq9SSKDdT2gx5oDXQb9b8q7YFArdgkr7b8Yz0aZkjxH+E4rBPL3Nwnwr7FwTMo8Y3WuwjMw4EwexvjzrpzT6xBr+u8MW7CmGHYEaWlntzk6M6Ak0DZRm0tToH5rXXR+dMwSTG9fPoog6yF+nRgrt/Fa6UWJftZXPZ1oJwISBns2dV6pr6FZFQ8u2ZVKFfc9Xc1r/q+y7S8HdHplV8gHYFA9EJAvJJQ3I2dW94BSbUXixT0S5U0QpFOpTcMl+PZ2nOcl49G3VaHcyji2DWCwhkUVJo4r/YBSdbga9khGopO/OmnJ+VawZWf0fZD3UHqlVDQx2xuE8DALdxFcKk/JTl2dvj59OYL/bXsftNnQfzEhxxSpvVK2yTCujpbShwypJnVdzcA4Vi1vLLVJSFbQW8G6IxukPOOHft3GRvbchFRdbhU3nf7ZY/GP5Rcn5KdDPKAkD1MaNAgx4tzi/AQLpK38XeZri4yLjYO4DyvZfr3sLJVIXhDqakXUug6ASfKjT4y8dqgHRKeC0mee2TH40AkfVuJ1EeKSlpk6UmHI31Lszt2pcy2LuDoeEsIe8XQ19n02hK8aUdcQO7g6+NhLll1U1WDjBG+VQwDTpNPus+U/fAzosmnllNp131PXeHRCTfEs7GAc0vWpZqLQ8OSmkFm1XE8fh/VfCGewzDpdAa7zBWuDP4zB70Qg0+QFLRV+vg8xDyZcKqcA3+7BZc0LCigidgo=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?OGlxZFNteThlRGFwL3kyK2Y5TEFRWTAya09kM0pUajl4dElFK1oyeDZZeXIw?=
 =?utf-8?B?VVBWVGoyVFdMbk8rZ01FdExGbkI3bDFtenpodW5sTXFiOXRqRVFLNlUrekNq?=
 =?utf-8?B?SmhJZlV0YzNIZU1NQU8zdFV3a3RxaSt1UG4wc0dPV21tWjArNXk5VythT2wx?=
 =?utf-8?B?L3g2RVQxbnowMTZUdTh2a1JKV2JDQ1hUQjdDZXMrenpPR0FLOFpDUDN0bXEr?=
 =?utf-8?B?ZzNBMEloVEQvdGw1ZG1WNURJWk9WcnFKM3RlNzROczVyeTlneVA4N3Zwb1ZE?=
 =?utf-8?B?b1lGb2Z2TlA3b2FPdnV2WG1yNWdTMjY5RGJHTWFLNGNsYk9ZZUJaZU9neDl2?=
 =?utf-8?B?bWpha2h1UjVUTVZXcmJQSTRUZVVSNHVIUDdxVDYwcWhRRlBKUGJNT1BPcmRa?=
 =?utf-8?B?OU1TY2dOOVA4S2JMeWdHU0dMOGxuRVEyZlI2UTJERDF6RHpnb3VUY3VLc0JM?=
 =?utf-8?B?OXJoTmQxd1ZSN0swMjZJODcrNStyR1h0U3l6WlR3SmlUSmhMdHN3TGRSYXlk?=
 =?utf-8?B?dmsvWGFodXNvL1RyOGdBcWY5akhIOERDaG90MmUrVUQ1Nm9qc0RINks1V2dK?=
 =?utf-8?B?eWpMOUMwempBekgrRlVrZ0VBZHYxb011WGRCaWVnQVRyRWFNNWVPOTJ6ZVVn?=
 =?utf-8?B?RmVOZVF5MlNibWZFc21qTDZ3STBjdG9GNHBoUlduNnFYUkNQN2NFRG4yeWdu?=
 =?utf-8?B?ZGZqa1JPbk5saWdBTXZTVEgyZjlNMzZjSFlldFRURVlPRXZabjh0WHhKbkxv?=
 =?utf-8?B?Z1psOFRJa1IyL2RrcUxRZG5QVklMbHBQN09KMCszOXRHR2dMTUdMeUY0Y3Qy?=
 =?utf-8?B?SERIUU9acG0wZ3R6blFGNFlDSUpOeVBiaEJURWhQeGVSUHB3K1pBL2JLUlRM?=
 =?utf-8?B?K1JqQkNENHJCVDF1OTkyTmduUkZIYzlQbDJwcnpCSllBWmtCYngyRFpkdUhx?=
 =?utf-8?B?VFhHaExYLzZpQytRWDU5Qk1SaWhoUTJOSHU4THViMTJoVVgvR2dJejBUaWJj?=
 =?utf-8?B?M2ZmdEpDeitUenpHV3I4WG1BWEV2ZWE5SEF0cDE1d3RZc2ZtZ0hjU2ZodEdz?=
 =?utf-8?B?RjlWc1NQRVZMUENWbGJ4QkZpWmhQVmRTZVN6bUZ1cWt3RGlQM1lRS0czMEZk?=
 =?utf-8?B?cmNhRHE1ZTRxTUpaQjFFdXB1bzJiMTJmSUVNNlFtWUU4YkpycWtJc1BCM2lG?=
 =?utf-8?B?M1JXNDJLMUd3TGgyUWNUWVQ0ZjlWN0luQ3I3TTF5cHRHY2xGcDRpRDJ3a1pY?=
 =?utf-8?B?cnV0U1M0SFA2RFdWQmhjZUhEcElsams4VEhTbUxMc2hPSWN0dkx2RWt2MWtr?=
 =?utf-8?B?VlhqWnJZQWdKQURjTnFvY0hKbVgrN1VRY0tRNWNiRWdMSkN6T2FDRk9TZU9o?=
 =?utf-8?B?cjlqZzN3YVJBdHUvWEdBaTVMSkg3K1RzUjRTZU4xeWZXcHFXUDlNdGM2em5M?=
 =?utf-8?B?dGx0RWdHMExZNjdzRHVDOXNvTnRsVmF1VDN1UlNqTnhPaHhGQk1PbXhMY2Ra?=
 =?utf-8?B?VFN5eUlRcVpWdmEyaTB2eHhWQ1VVcDQrVWdnZ3QrZHNyMlhZdE5JSjJ6Z1ZE?=
 =?utf-8?B?Qi80VDlvakVLK1BMWEk5Y1BUaWR4YmVjRWpmVXU3Y01sbVBsaDR5bExxSjFL?=
 =?utf-8?B?R0N6NlJ2YmhFZGlvYVRtTmF1L1YydUJUdW5FcndGOHFXb3JjNjZJYlhENlAr?=
 =?utf-8?B?R2pDNUhnZVpUbnA1dStVOEpzOEZXQ0JtSXo0bERNMU53ZU95Z0FKMG8xRUl6?=
 =?utf-8?B?NUlmMTVac3Rpb2x6SzBDbzg3S1ZuczlvRG1pM0dDaDhUaVl4WmltQTBQaXQw?=
 =?utf-8?B?L0FuSktkeTJIYlh4bUNWdUhHNUlMaUFQa1c5b2JBVld6aDFFVU03Tk83bTFp?=
 =?utf-8?B?dVJBNGpja29pUXhGUmRxdmZoN0Y0ekZaYXRIaGhvZndWUlQzZUtLUGhwMkZz?=
 =?utf-8?B?VWNvSGV3K2VUZGYxOEtPQnUrNEc3cHNQdGZFeUMrZ0NjSmxwYXdlaTh4c2dr?=
 =?utf-8?B?dWJDRUQyeU94UC8xcUNxd1Q0aUJMRkRta2d0VVR4ZHVMbWxkZW1CNzY4WWU1?=
 =?utf-8?B?RWdVNFVvc2RVcEoxZThJL0pNbjBKRDZNbkEyTTg2aitQSmhQZHZRVms0bU1P?=
 =?utf-8?Q?ZoFqQ4bDY5wydyE+I+1WkoNL5?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 44c24ee1-222d-424f-4e10-08db163b91f9
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 VGJwE3fwwH8EPNqWcNSYIfNRmlGUhhjY1VJabBr3UVT2Rtxb7QYTf3AE8dRaI6dLdM+WarvUDeEmAcAQxBMnfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7731
X-ServerName: mail-am6eur05on2055.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: zH0XueS98Z2-7d5BQSPZQYbXOjbjU5Fs
X-Proofpoint-GUID: zH0XueS98Z2-7d5BQSPZQYbXOjbjU5Fs
Reporting-Meta:
 AAFdvB1vcqrL4onC7NnXMJ90We+eO/mASFp09ZwvwEKp6BcbsQ9kc5mdEFsw/nIF
 ooFJXyMypdxuaZQi3jMRzuwKedbUc5jM5eq3VqncayD9A1qD2fwN/fkecDYUrP86
 gffCt7kY+fxMHdSjgNeLsD2OLFfH7s2kOsS3DArmMQ23gOfY+P78CAuz+MuuqBbV
 eWc2o01DIBmodjyONJQEAMrAwSIJtaDvYR21YIjBcD3zcDdOW7T7cG7kGIf2cKcf
 0FVUTGf+DGZageJuE9NcniKDs4jpCsaXxxNjOLJEDMGBtM8DVJd+KeaMy7dlLsnM
 CZPaGsyGlcqtfcYxz14ssfvRiRFk+LY1xVTfzU1ipIZkn+8ZfxiCLBdh7GAzymHW
 LIgCbh6LRRHrA7/r/424HDS7VCWjxDlfeC60jHwgQFf8Izhrk7uE+/qo9sQDxg1o
 SB3U+lrs/LEeswNV149S0i8uC4II6vP6/LAMFt2kN36+5YvCKkmtQ3cW0p8ZL3M3
 OklLvlCtZo1vxsoJeXlTxQRkzYo1ln9kD/tdWCE5j/Ld

On 2/24/23 2:54 PM, Joseph Qi wrote:
> I can reproduce this in my local VM.
> I've traced ocfs2_dismount_volume and found that it hasn't been called.
> So EBUSY is returned in VFS layer. I guess something wrong when doing
> a copy with linked SQEs (normal copy seems no problem).
> 

I am inclined to agree with you. I also test liburing examples apps
on ext4 partition, everything looks fine.

I used below bpftrace method, the retval is '3'.
  bpftrace -e 'kr:mnt_get_count{printf("%d\n", retval);}'

It responds to flow: path_umount() => do_umount => mnt_get_count (gets '3')

Thanks,
Heming

> 
> On 2/24/23 8:32 AM, Heming Zhao wrote:
>> Hello List,
>>
>> I found a weird bug on ocfs2. I am busying with other jobs, if anyone have time
>> he/she could fix it. This bug is blocking fstest generic/013 test case, and also
>> blocking fstest to do later test cases.
>>
>> How to trigger:
>> ```
>> git clone git://git.kernel.dk/liburing.git
>> cd liburing
>> make
>> cd examples
>> mount -t ocfs2 /dev/sda /mnt
>> cp /etc/hosts /mnt/a
>> ./link-cp /mnt/a /mnt/b
>> umount /mnt
>> ```
>>
>> umount trigger error message:
>> ```
>> # umount /mnt
>> umount: /mnt: target is busy.
>> ```
>>
>> The umount error can only be triggered by liburing write operation.
>>
>> Thanks,
>> Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
