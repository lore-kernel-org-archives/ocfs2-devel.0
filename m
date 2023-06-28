Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2054.outbound.protection.outlook.com [40.107.104.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1586E1847
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Jun 2023 03:10:07 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYDnFGuzAFSu1RHuyp785ergub9RIUBSb952FW0gweguYtx0OcSTU5/B2TV/tDfK87wtV/9TFQbxtz5QNtUnzJO5QbLuOqVQ6iHNNZU/CzXgrEhVpkjmg78Zlso12jOBOy6gx0bqTnsL6YEbi+Viny8vM8yVmPOvPvX1UWTJgnhEb5K7hTSRhngcUlp/6dwCbwnZyV/TeM1UTXbdZYIte3zXevSUgETUZUWFSJRkxioiqx7PD4vi5zPphnvDXHDWHoOXX+6Sqo+l0fjUbwJ6PjSff4mcvzNPpY/xZKUNKv3Ama2elLdWFYp0OmwBPQs3q0NYI62wmf7usopPIpYq/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MA1nFIaHoVpS0FRlLPkNUMcVuls1+D+czec9Uealns=;
 b=kYpOYl03/SeCRldr+RYGJh6PKRk43TU77tRvHMs7RsX5yHh3KwlCbIRp8TB9WPbo3CD8QnDGe1J/ow9ERwkMWv9fxVk1bPTdHC2LW7AI3V7puiBFFDrvi4YhkoD/gftdrVqlUQydGn7vn6LADbzmt5eufbkTl04z/WrrlbHVJgJfFiEUFoyou10m/VBax7JXWe7xXktbigsXP6hBWuMd8EaX0/68WEBpCRIzuwORB9lwc0M9aeoULglkn8fXm9VBukoRDSkGC8JCCR9Bhl05y7L0bq0hohux9vWA4rZZ3/qBWmJx3I1OGe/ILJrOeNBj6BewdtjiE1SD7YW1Jh8EbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MA1nFIaHoVpS0FRlLPkNUMcVuls1+D+czec9Uealns=;
 b=uJHIDsLY6On+NqEf4Qoydc0MU0Vl0EBQWRnvLRYPqzSMifYvFCDnljpOyV6PZG3XAZTTqDJHffTQSBMXX73pxtyTvwcPbMZLL74PZxv/0KkDR/ubwfJJrRIYArEP2UrTcBMvCJUoQ41tOGacPgaz0J72obedVd2VzrZmvIufoEu3GRAZGVXTyelbtUP5Pnl7vaKkatu4zzNTlUQobuPftJ8/A3BMJUQVd8P+w7L0P+03W2TqY6w8ElLNKlVqYPlip/G0TXYEBEEQQqS9jdtIoi3NAs/2yvB/ePyi0wSt1Jp8H2TKFdWpSnk1KOlM6rb3VkkQpBi0uNrrdLgFHfB8Iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
 by AS1PR04MB9287.eurprd04.prod.outlook.com (2603:10a6:20b:4dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Wed, 28 Jun
 2023 03:10:05 +0000
Received: from PA4PR04MB7997.eurprd04.prod.outlook.com
 ([fe80::1e8:ce3f:e018:320]) by PA4PR04MB7997.eurprd04.prod.outlook.com
 ([fe80::1e8:ce3f:e018:320%4]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 03:10:04 +0000
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Fix wrong search logic in
 __ocfs2_resv_find_window
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
References: <20230406154052.9863-1-heming.zhao@suse.com>
 <c5034daa-056a-7603-daaa-3db5138bd3b6@linux.alibaba.com>
 <b8f89579-118b-7697-f77b-dee588c3d3e0@suse.com>
Cc: ocfs2-devel@oss.oracle.com
From: Heming Zhao <heming.zhao@suse.com>
Message-ID: <f2b51fec-1e1b-6575-e5a0-c0222358b4c7@suse.com>
Date: Wed, 28 Jun 2023 11:09:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <b8f89579-118b-7697-f77b-dee588c3d3e0@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0188.apcprd06.prod.outlook.com (2603:1096:4:1::20)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AS1PR04MB9287:EE_
X-MS-Office365-Filtering-Correlation-Id: 59545d87-cfec-40e1-4a05-08db77852b3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0uNUY6qU2NS5HV7d5o8TkwZmYrD2oU+RmcghnNWL4RbgWYSfsP4UrFx8uNWxTjQFSVS0TeqD6HjSYiqrYXrBqcK2Zz68mVyC94Lrne6JDxiFlXT2oNYHjbW8A+K3IvcvyY2L3myAW0g+Q+9q2F/vSgCXP3Aizfz2uI20bE8rmihaqUjg8PaH/9CJltLqQpXMo3EcxIFcb6z4QblLjbTvbYwZFn0SGyM+jHZCPyEWqKIoIFhmrNe4jNlQMTbt41HfgMNTOC2TyEi1ShiYyjVaepulmifc3K5yOs4LbtT7JOty9Y7ptAmo4frEH/ixjvo70ARBgIYOkxWMKP9+x4fY9X1kOyBtu+0A/81DmX4VuV5R6Mxm3bSXKN7k6izOivZi+MdA62L0UTPRAerd/kg7Hjl0FYjG3mSn8V7xswB2oZVm8Boiw6H9MQviBNToFSPJYnKsyG9VxkHsEpwullqGs41SS34AThUi81kweNLPY3DHxIgrMbPeEiHhaY+474TysBAeKFIJ47zEQkLW2SDNN5MYpgthFIIMUMI0gryNi/v1Obqx1hK9erzziE8nnyX1KMoFoVMXs7FbBKFZqS3Zwck4FGhXvHnpqOkqMWNpVBmcI4fr1c6MzSBpohq+8BLs++BGXwQ9m0aak0oeM/Hpnw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7997.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199021)(478600001)(31696002)(86362001)(41300700001)(66476007)(66946007)(66556008)(4326008)(2906002)(36756003)(316002)(966005)(44832011)(6486002)(5660300002)(53546011)(6506007)(6512007)(26005)(186003)(31686004)(2616005)(83380400001)(6666004)(8676002)(8936002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVpaZ0dvaGhhUC9xRmxDT01kOEtITFJLQVhOR1ZGRlUyZkI5SktnSkh3Sm8x?=
 =?utf-8?B?dXFYNjg0dW0vSHp0SXkwSEhGR0ZBV3BXdEkzSDFjbEhPMzZkZGJRb0FuSlEw?=
 =?utf-8?B?U3IyRkdSYklob3lyUE5EZUY4TTdUSkszYXBxTVRoWWg2RldjL3N2cGFhNGhk?=
 =?utf-8?B?QTN3b3hzcmZKcms1N2NXSW5JSVNGOUFFdXIvaS8rOVcxeSt3Vk1zY2N0dEJz?=
 =?utf-8?B?dUNlZ1lOaGlEN21VOXdFT0lOVjRjb3o4OGN2UG5zRXNnTEtDeDc4d3ZDWXQ2?=
 =?utf-8?B?QWNoa3BoVFZQV0tSS2h1L1dLc2diVUIybkdKbDZ4bGM2b3dmTnI4Ukl0NGl4?=
 =?utf-8?B?L2F4K1ZjTXhyQTExSzVYbk55OUE2dWRaREIxMldKQnprMksxeko5OTFHcUNk?=
 =?utf-8?B?WnZxSmszNGEzeWMzQVZJWWVHdXJ5bTFNa0lmZlRWYW0zVStWamdUbVdjeWdn?=
 =?utf-8?B?TFJpNlVvdng1WlhlNWNtZldTcWh5TWZRMnRGNnRoaEw4NmxidS82azN1TTlJ?=
 =?utf-8?B?ejF0RjJReW5JYThWamFLWkcvYU92L1lwS1JMOFh1Y3AzYUczOXBrcDhGaXB5?=
 =?utf-8?B?QS9pQkVRUjhXc3BJU1FrbFQxeVJ2U0pMWFZRL1NtSDlkbHJmNnBWYTUzWVg5?=
 =?utf-8?B?dWQvOEtjbzlhMEY5bnFLbTYzb08rN2ZGL0laazl5NVl2ZzY3WUt1MVdUalk0?=
 =?utf-8?B?RjJaUlcyanBTY2JYcDNmVWkvMDQwdXNRRC90Q0VzbDVnOG1ML0hHdEExUlhS?=
 =?utf-8?B?L2w1M0dFT3VXL3NvR2t5VVlKcWVnc3liQ2dMaHNvL3EyM29tL294aVlpZllu?=
 =?utf-8?B?TEI5WkJKMDB4djlNbG5QZk1COTVKOHloMFU2b09mUFZ3NmxZa0dBS0VMUitr?=
 =?utf-8?B?UHord29ESUpZd0dtYk80RHRzZnNvbWxneVBrbUZHOHhZQVlmZDZGdmlZK05C?=
 =?utf-8?B?ZFdUYzA3cFB5TnZQbitBSXVmRFZ4UWxYSnpEcFpPZUdpZER2SEpHV1Y1b2di?=
 =?utf-8?B?ZVN6UlUyU1pBQUtKUDJ2RDNkcWMxa1hRQWhXSjFKZFlzdE5BWVd6SVB1ZThI?=
 =?utf-8?B?K1NsZ0k4by9RYXNSRUJ0aW9sVXBvMUppQXBCWDFsd3JJZFhOOW53RHBlbXU5?=
 =?utf-8?B?TExpVk1FK09lRjk5eXY4OHZzb0F6UDlzb0VPU0pNVmVlN21oaW8rV3BjRFA1?=
 =?utf-8?B?RnIrR3N3OVZHTHRNMG1WN0NxREtFckZGT3RuTVI3TzBjaGxSWlNLaGlCb0d4?=
 =?utf-8?B?R0JIOEhqK1ErNUIzY1NDN2p0dStzR3V0VHdZR3ZFSXUrNTRIT1plU2RTbXYr?=
 =?utf-8?B?NzdYbnR6d3BYYlh1RnFKTVZpNnU5TVV5MVRlcndEZjlPSVQxNDVuV0VmSWV3?=
 =?utf-8?B?ODVNcFZESVNNMXZQVmtmMy91Vm42NUFtVDVuZG1aY3ZyNTJzTG5OWGtFNW1m?=
 =?utf-8?B?WWRZbVFrcXEvZE93L0Q4V1lGWUdUWHd0N1RyNWIyNTdBWWt0dlN5NTFtL3Zs?=
 =?utf-8?B?UFNzcFVoR3ZvdEYyL3dFMFhBbzd0SzFCZ3MxbUxGRjI0bVlVdys4NUV1YXZu?=
 =?utf-8?B?U09laFFiZkxtaklqUWFlc2RTMjA3YWJaYzhKNkVJNmNQd054Qi96VGIyRVY5?=
 =?utf-8?B?R1NFdmY0eGdjZ1JWZ2ZEVGdaWUZQQ3hSemlDaUhTTHRGRXZTM2hISGJ2OE1l?=
 =?utf-8?B?Q01ML0pvVUVlZHdNMmhOOHoxb3Z0Y21DYlpUVE0yUERMTHhrQWhuL0huVkJM?=
 =?utf-8?B?K1FaK1JqRGhNaHo1VUZyU2p5UzlkODE5OXp0RkpEclptWjUrRkU5WGYxditn?=
 =?utf-8?B?OWhHNVh6SjVnbUZTSTFVeHFUK3RmN0RRUXI3M2lYRCtwRGVhY2NINTREK0lu?=
 =?utf-8?B?eUZWTjdPUmcySURtQzZTNzNnQ2RkK0pva0VoS2ZBUXI0eGFVZUdyU0pEL1F5?=
 =?utf-8?B?eXhFUmRXcXVPQU4zMDExQ1BMMjRSbW5zandHdEEzY0lZYjY5bTFOR2djV2tT?=
 =?utf-8?B?Y21tdGc5L1NCL1FmZEQ5c3BPb09kQmt0WEdNMjc1RXpkY3g1R3p0bEhtcCtI?=
 =?utf-8?B?RmFVY1lVSXJqS2lkRlZEWm5ubGRJVGRQMS9LeTdDMXJHVTdTYkQyNEhRRDRO?=
 =?utf-8?Q?nFXOfcsP0IiAmXlKBi3MIGUo+?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59545d87-cfec-40e1-4a05-08db77852b3c
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 03:10:04.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3IettOVbqTFCIW+jeW++vpmLACs+61iuYaMn38IjN3IvVEIDKdzt19zNRCn3+xFlciMNBuyW8Yf3RbiUGxKJQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9287
Message-ID: <20230628030955.uypVL2Ytd3czRqV4lUUB_g-Zw8G33ZHKAIL2S_bTN6o@z>

ping ...

On 4/29/23 2:37 PM, Heming Zhao via Ocfs2-devel wrote:
> ping...
> 
> On 4/21/23 3:35 PM, Joseph Qi wrote:
>> Hi,
>> Could you please share a reproducer?
>>
>> Thanks,
>> Joseph
>>
>> On 4/6/23 11:40 PM, Heming Zhao wrote:
>>> ** problem **
>>>
>>> Current code triggers a defragfs bug [1]:
>>>
>>> ```
>>> tw-tst:~ # defragfs.ocfs2 /mnt/test_from_dd1
>>> defragfs.ocfs2 1.8.7
>>> [ERROR]Move extent failed:"/mnt/test_from_dd1" - No space left on device
>>> [ERROR]"/mnt/test_from_dd1":No space left on device
>>> ```
>>>
>>> I added some debug messages in relevant functions. When above error
>>> messages appeared, the la-window still had enough continuous bitmap
>>> to use, the -ENOSPC is wrong.
>>>
>>> ** analysis **
>>>
>>> __ocfs2_resv_find_window should use resv node from rb-tree to do linear
>>> search. But current code logic uses un-managered area between two resvs.
>>> The searching logic deviates from this func job, which should only focus
>>> on reservation areas (when rb_root is non NULL). Another issue of
>>> __ocfs2_resv_find_window is more inclined to generate inner fragment.
>>> It doesn't search & consume existing reservations but be apt to create
>>> new reservation item.
>>>
>>> This patch pulls this func (__ocfs2_resv_find_window) to do what it
>>> should do: search & consume resev. if this func fails to get suitable
>>> bitmap area, caller ocfs2_resv_find_window fallbacks to use oldest
>>> resv from LRU to do the final search.
>>>
>>> [1]: https://bugzilla.suse.com/show_bug.cgi?id=1131931
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>   fs/ocfs2/reservations.c | 48 +++++++++++++++++++++++++++++------------
>>>   1 file changed, 34 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
>>> index a9d1296d736d..eda672622d1d 100644
>>> --- a/fs/ocfs2/reservations.c
>>> +++ b/fs/ocfs2/reservations.c
>>> @@ -458,10 +458,11 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>>   {
>>>       struct rb_root *root = &resmap->m_reservations;
>>>       unsigned int gap_start, gap_end, gap_len;
>>> -    struct ocfs2_alloc_reservation *prev_resv, *next_resv;
>>> +    struct ocfs2_alloc_reservation *prev_resv, *next_resv, *best_resv;
>>>       struct rb_node *prev, *next;
>>>       unsigned int cstart, clen;
>>>       unsigned int best_start = 0, best_len = 0;
>>> +    int create_new = 0;
>>>       /*
>>>        * Nasty cases to consider:
>>> @@ -540,8 +541,9 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>>           if (clen) {
>>>               best_len = clen;
>>>               best_start = cstart;
>>> +            create_new = 1;
>>>               if (best_len == wanted)
>>> -                goto out_insert;
>>> +                goto out_create;
>>>           }
>>>           prev_resv = next_resv;
>>> @@ -557,13 +559,9 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>>       while (1) {
>>>           next = rb_next(prev);
>>>           if (next) {
>>> -            next_resv = rb_entry(next,
>>> -                         struct ocfs2_alloc_reservation,
>>> -                         r_node);
>>> -
>>> -            gap_start = ocfs2_resv_end(prev_resv) + 1;
>>> -            gap_end = next_resv->r_start - 1;
>>> -            gap_len = gap_end - gap_start + 1;
>>> +            gap_start = prev_resv->r_start;
>>> +            gap_end = prev_resv->r_start + prev_resv->r_len - 1;
>>> +            gap_len = prev_resv->r_len;
>>>           } else {
>>>               /*
>>>                * We're at the rightmost edge of the
>>> @@ -575,8 +573,8 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>>               gap_end = resmap->m_bitmap_len - 1;
>>>           }
>>> -        trace_ocfs2_resv_find_window_next(next ? next_resv->r_start: -1,
>>> -                    next ? ocfs2_resv_end(next_resv) : -1);
>>> +        trace_ocfs2_resv_find_window_next(next ? prev_resv->r_start : -1,
>>> +                    next ? ocfs2_resv_end(prev_resv) : -1);
>>>           /*
>>>            * No need to check this gap if we have already found
>>>            * a larger region of free bits.
>>> @@ -589,10 +587,16 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>>           if (clen == wanted) {
>>>               best_len = clen;
>>>               best_start = cstart;
>>> -            goto out_insert;
>>> +            best_resv = prev_resv;
>>> +            if (!next)
>>> +                goto out_create;
>>> +            else
>>> +                goto out_insert;
>>>           } else if (clen > best_len) {
>>>               best_len = clen;
>>>               best_start = cstart;
>>> +            best_resv = prev_resv;
>>> +            create_new = 0;
>>>           }
>>>   next_resv:
>>> @@ -604,12 +608,28 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
>>>                        r_node);
>>>       }
>>> -out_insert:
>>> -    if (best_len) {
>>> +    if (!best_len)
>>> +        return;
>>> +
>>> +    if (create_new) {
>>> +out_create:
>>>           resv->r_start = best_start;
>>>           resv->r_len = best_len;
>>>           ocfs2_resv_insert(resmap, resv);
>>> +        return;
>>>       }
>>> +
>>> +out_insert:
>>> +    if (best_resv->r_len <= wanted) {
>>> +        resv->r_start = best_start;
>>> +        resv->r_len = best_len;
>>> +        __ocfs2_resv_discard(resmap, best_resv);
>>> +    } else {
>>> +        best_resv->r_len -= best_len;
>>> +        resv->r_start = ocfs2_resv_end(best_resv) + 1;
>>> +        resv->r_len = best_len;
>>> +    }
>>> +    ocfs2_resv_insert(resmap, resv);
>>>   }
>>>   static void ocfs2_cannibalize_resv(struct ocfs2_reservation_map *resmap,
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

