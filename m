Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705D1C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sat, 21 May 2022 10:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lRxdgetcag4COer2eANwTXhd4G9pPbTLXlF7vtlLLP4=;
 b=YU9XUQiS/2hUqxlpq9zl2MFgcoPHHr+pv9ppwBL7PGINeRZMkpKKdIdgWATRazgKKZxXeNF5sTud
   tN5YqdVhOCK98MXFUKmjSwA8esQuYLmPQw31q0Bu2ngRN82oGFPBdnx0FkOvQzfy5XlAIl/uJkig
   DK+zuFyjvXUzwXXKRwHIVtVu5dBFkJFp4UHHtdtrtxhFuj9FPnTeW6mtE90IUQh38+kPbIs7Slvb
   CLkkiskj1ejtjNq75I6jAiueoSlA4BUrrLL/b0N6zhVrlcjWFYAcn8ZhwPfi9mwYeTFG5GamgT1b
   BVrk1+Ao6e72iKJ3Q0slDD0WTKVhuAfsTbPZfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lRxdgetcag4COer2eANwTXhd4G9pPbTLXlF7vtlLLP4=;
 b=Nzl8/yr/FY9tCAWGUVs2SZ5YRlNZeb3EdJOpNPjfd8LC/yn/9JHn3PXLeLTCSBMbY68fcgi4anPx
   lPGgdy5OW+xS0F27rd4m/XdYTG9cLIbLMuIa/hld6WhalJb13C8NaBvtXGl46rDwDna9g0rBS4mx
   ykdcafXxDE3xkhF4kUFRxmYTVZs+Tj9jR3+LLEiqKsHBn7tPBb85DJVM6+cL0QSDL9iSQxnZuMYw
   Eq348UWUjiXpqPcb2wVQo6YPm/ARAAQIAXl/5In8++DQNvu5eO2AspMLv0dUf4wNjsAGDFyR7i1R
   r4YlDOxAFTGma5Vv/HLYIdZwknww4T/tJw+JWA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC800KGC9SQMS20@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 21 May 2022 10:14:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1653128077;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AwWuPlc+Ovm81Wj4q0BFfvQsfDt+azsvN4ToAucNzTM=;
 b=VHMDoUrCzygpBu0CR8ZU5y0bgMyPB0/X7GZZ6ZTtCeOq/PwvnD5aVJzoZUab1f5xloxb64
 nrnvCpkQo0KB1+jqIoXMmgnuHBPErqyC2ayhAH5RRJ7KuN4byZcKptogv+E3jghunrJb3I
 0qg5C1JDVnn5I+DUNtpe9+cztugLghs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIpzdf/l6o/NjHceTk6m5y3V6CEidArxE0K/tTlWT8X7Y3AFrtquDCZgjkGNkfdXqknzp+Wocia5uzKyBy9lABUkpsI051xz4jQArre6f+kL3hB3AkdTviXAqANvPBVSw9YbBuRAnxN3CD5GuG9iMKDvjczyBQdE4JzF3dr67gkdEPhh3Rc/Os+fYRNFPMHtakGKtdaK3CoIXE4eVO8KLZiHYfTr+3ZQ/r3O1OsD/UocgcK25rEyhZOI86nROHx91NntmkP0+eiImQSXPFOreycZvBGiK8hBfgmC5FzfvW8DaugCRcy5uAA/GKaxEcwbAs+4tfD652UCH084vgmfEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mm2FGWGMjIbeKYaV1hx6Z8t+ZZPIyg2NqGcBbWlxrLs=;
 b=ZuET6hnXXrkb3iA07zoGldzQHzZc3NBdtqbOUck0rIe/jLKNPHBlUMV2FwG0isJt6wMlnPQjNvjWE6+DJH7o1pIkhkrtQuCz82IgOCZX/K8naMbB8zKOvyiyivQEfuSwS437M3sHrZK8ZgwLR+dQDyzY1r4rpEktvSq6RX0TGzcLJ5n6FF9s/B4LXjhq4PdzHuWywI97rvZVlyU7BholurQMYwW7d0ZasekYYfsbd96M1PVzrmGLN7TsmzcTK0rsxlxpRZGqBEpWpIpT33B9OcuB6gYzAEQM3F+0q1nOSIQdYeKqP8Bqi8fF8MYKkoRpq3nbHGu6OBcAZurKnNYgRQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sat, 21 May 2022 18:14:16 +0800
Message-id: <20220521101416.29793-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220521101416.29793-1-heming.zhao@suse.com>
References: <20220521101416.29793-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66476007)(86362001)(6666004)(38100700002)(508600001)(8676002)(316002)(6486002)(66946007)(66556008)(4326008)(186003)(1076003)(83380400001)(6506007)(2616005)(5660300002)(26005)(6512007)(44832011)(107886003)(36756003)(8936002)(2906002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 10:14:34.8514 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10353
 signatures=594197
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 priorityscore=128 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 bulkscore=0 clxscore=228 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205210062
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix for local alloc window restore
	unconditionally
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
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: oOxrmcXyP_uUYLdwuDEbNQ-1
X-ClientProxiedBy: TYAPR01CA0203.jpnprd01.prod.outlook.com
 (2603:1096:404:29::23) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1043194-d76d-4723-fd38-08da3b12b435
X-MS-TrafficTypeDiagnostic: AM0PR04MB5556:EE_
X-Microsoft-Antispam-PRVS:
 <AM0PR04MB555661F938C3A52C93162B4D97D29@AM0PR04MB5556.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 r6GtAfW/s4hmW40YVSiJmzMZor8Dg6Ht8CXXJpHRr/jRISpOj7Z5P7EWdCOCk5bxPpczLDkEjGSKnrn6DwdCGCIUy0hxPtecCXXHHmr3gyPkgyvWkr+7TxAPUYk49JjUlSkxLjqOpDBALsDg5C3J+/CmldJeAfl0fOQxEeF384FUq7hmmmYhfJsSruTX+npnzocZRnYXyvIbFuP4ntsfYpDVU4RY/ZH+quuS1lt0UoDKEOeIjZg947Io1grU6bbscbZYqf2TbP8F8pDCVPLx/3CTdqhcWjQgGh0Kbz04BybM0wWhczluDB5wNPzE3yaU+PoqzVKtZfE4YGeuSsxcQHNxnRem5mzNOwX6l08zXaOnDTFZPDHuyfj0JKnmSe5ddRas2xP6nWzjQYEpOZF67H2QYPhOLXSDwAcTwb3JijsKAKDgLu4p48XHkyYheB24140mWCSA+AJmtP5u1ZfuMGu5UeW2VNZ3fdNpj8BMF6wc9Y65rNiKcVjuTlhU1oNcXkwSp+nQP4mWw4bDhzW8XfEZaA0Cro23ytOQL4ZsFuavk/ymsoRom17fDo4hUQLKxuWzWWOCsK2aRr5rMoJhC+KAxzBWVrIwFfU4ODgA/KaTxFzPJvQXUf6qnWuuudRLdprKMF+0KAkirE83mnM5cw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?e5ORUmKuCv5s6iG449neA0VPEIbY1XNXOFu6QNz3PylShxYmErcSTyo6wrRV?=
 =?us-ascii?Q?9yPW+ZfIVP+ZfKZHHADfWY/CcELIlO6qp3c3ebriQQXzxINARTGhr/cG6Jyp?=
 =?us-ascii?Q?Wq93lb/eMsewaxJO7gAwNDIjAGtJrlO7o5yQxHLOKjqgzVcYHElXOa01iaTp?=
 =?us-ascii?Q?6Pns0mySTe9URL6s89rhSmnBQfghO+MOeAWJ8UVqXvczOsTLK95zHcPi5fts?=
 =?us-ascii?Q?sQfRHBlemysWilpJo2aO7qfMWDAafwRP9DISvyESRq5K6e/8FK1fE5zhJOrC?=
 =?us-ascii?Q?OuhkQR64juJxWg80KkJQsBpUk14tLZkV9Yb5i2uwXxbH9O6vZV4056OCKzYB?=
 =?us-ascii?Q?E4wGg8WVZ+OpBUy0I0gM/aBacgvRJaw351UuTfaSgWp72rZWE/RkHwliqL7N?=
 =?us-ascii?Q?O9ssqHWJz8yPMv3M6hSqmBXrGLh+mhOoCWrVTilq/6UUS5Cem7CO8WIK23cL?=
 =?us-ascii?Q?PGdrTC386OB++P5TFm15wcfUnOOyzwZ/lnWc29k86ajShTaElqfpntWwoGLP?=
 =?us-ascii?Q?JzMsREWYji8XtYOhtHef4o73+fQ0okO2DyUYTDK0qfIUPyGZoPDe7ZZ/QtVd?=
 =?us-ascii?Q?NFQW2YsYIpXpxqhGjJ4nw0ABW/wtvUoFnHmdxHXDThWRtCzetGArtctgi3ND?=
 =?us-ascii?Q?HrFHLDEMDKkDTRE060oePjzd3Tu70qFzOeDJgC2nsf0FVISatKrSrsI4428+?=
 =?us-ascii?Q?X30Qzasf90yWcSAHBet6AzcwNRvTTR90CQs3OoSudOUC8Pwa2eJKWHDx1Aqu?=
 =?us-ascii?Q?BGHNNq0ItKtahyHnaW0PADpbf0ir09hdBMZGiCNb79lCY9CPNhVOwwvyxatf?=
 =?us-ascii?Q?8DL6WgpQ9EVAzingJakNqLcfCmdX83AK9BP61MtQD4BRct8HVOuEC002s4bW?=
 =?us-ascii?Q?kKRbQVZ8/Q7LJbnRVhnZStIFlNYobFqBx9ChymSDfptHRq3sC3nW+rcEtR9+?=
 =?us-ascii?Q?AglaKX7KmroH8vo3IwhlADCBiANQRfS3t87Ncx/rxAziVOxRZdsZ8Izd6MmI?=
 =?us-ascii?Q?qBsQB7HKJvll33rcid9rj5rMP3WgBOIXKoZXf/lwHR91g3siG/jtaKQ+Z3xS?=
 =?us-ascii?Q?YJO/X3KnDHh9p9wltLhBUN1KnU8LgiKeCV/kG6xVy8QhzUZAC5SebkSzmMiE?=
 =?us-ascii?Q?YeAJx6LRhje/dYncK0rgoQZGpVHR+fhbYhhB3p9V8qIp3avySLtXbmjjf490?=
 =?us-ascii?Q?vvukTWMJ6Aj2QuKAYOHmnlPK0PmXHOAIZ78oneCsBvR1Z42JalRvgJKaIn+5?=
 =?us-ascii?Q?P5ITp1sPJzttndfIOv3JVFVaWv/Y9C94x2tzRkIJjc1LWfxqJ9MMr3xURcgn?=
 =?us-ascii?Q?2ywL8UOZv3jv3vQBc5yMwXbOZTE/aaHf18E2ljWiscyUvxpwPHQfVnAeBhnD?=
 =?us-ascii?Q?F/xhOBr9zhynG0+PiGq95WlWKgvnBcL7FL0aQtDlqgnDMsjexRgZUyGg2pOc?=
 =?us-ascii?Q?cxBv0j6ZSGDd5caF3E8LZ7PFvkszmOqUf43z+AvFHP3j6WIEI/IyIEunM4HE?=
 =?us-ascii?Q?eCzOESs5KcLYtuGDb7ZisebCZgik1v2vpaHa6s27EPu/hGRkeqEa1gXmpzW0?=
 =?us-ascii?Q?CZndVqydanRgEfddHqj/ukbsB9mZsaxReQhLEnhqx8gwzrTE9Q9rBqrEH5qj?=
 =?us-ascii?Q?7nfXGeLSY/AdRU6n/jj+WO1tyaUKNZENzZKfzPoz7KZvUTD0Mdmf5u+kAhfo?=
 =?us-ascii?Q?mAaIYji8wNyjT8JHoo8FEzjJZihaeafwVW5oZCXTvEQQ7VYq7ZBoYw63jSL/?=
 =?us-ascii?Q?ThRbvnnmng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 e1043194-d76d-4723-fd38-08da3b12b435
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 jVAmx1FEBMn/yIlvNM5xHfBf9WjLhL8It9KnckNj0UraPMe8PYyO3+NlicWxoQUz6teMiQ6kKsUkLOJky0d9hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5556
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: ZjhDNrzDtcZSiSa70PwotrvH4UaF1eBV
X-Proofpoint-ORIG-GUID: ZjhDNrzDtcZSiSa70PwotrvH4UaF1eBV
Reporting-Meta:
 AAFDFthjS9xoi2LsSMHTuYz1IZ5Mwx8Z4+c8jtfMitFYJeo2ktN921Gj16wjypI/
 sjNZ8H8sktuESHBcAwOmo6L9Nyk5qG8PYz8BrumW/HMzVNwMYfrepQvd2dNJQmcL
 kehSimp5qGxPZ9jJzmsoMMqXfwstR7KkElogO0KVGv7zlI7Ld9XCJy3N94B8+QN1
 y4GeUTvFR7h63+qgig+JAxNX9oOPrgGFvStxOmclkq2GL1dP11dbeD6SlUqFaS1L
 OzlJmRcivtA6iSS0n1sAT5u33JLYNRPTgDfNzd7AELkBciORv5zfAxO94ghOEn64
 8yRzRUTtBdFphBQKBm9TGznaCymOzAff2uV+6M5DeNkyT06tdgRVtMaf7MoBWJif
 vR8RTyo9CrJEKwR5vRUac5DDnK+OjpXiumGat+PgEE1sFLgbrR5xryrpgVVhSjIn
 16cX636XA5MhMwwAvxpmFKqxGPSh/xQ5qZjNbEW5R6Mw32v6VT3AJzB8nIRtKCYp
 bG3OC27te+LvgjJPoJey+3ot4dN4wpbaVnVfk9CY3pDsUA==

When la state is ENABLE, ocfs2_recalc_la_window restores la window
unconditionally. The logic is wrong.

Let's image below path.

1. la state (->local_alloc_state) is set THROTTLED or DISABLED.

2. About 30s (OCFS2_LA_ENABLE_INTERVAL), delayed work is triggered,
   ocfs2_la_enable_worker set la state to ENABLED directly.

3. a write IOs thread run:

   ```
   ocfs2_write_begin
    ...
     ocfs2_lock_allocators
      ocfs2_reserve_clusters
       ocfs2_reserve_clusters_with_limit
        ocfs2_reserve_local_alloc_bits
         ocfs2_local_alloc_slide_window // [1]
          + ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_SLIDE) // [2]
          + ...
          + ocfs2_local_alloc_new_window
             ocfs2_claim_clusters // [3]
   ```

[1]: will be called when la window bits used up.
[2]: under la state is ENABLED (eg OCFS2_LA_ENABLE_INTERVAL delayed work
     happened), it unconditionally restores la window to default value.
[3]: will use default la window size to search clusters. IMO the timing
     is O(n^4). The timing O(n^4) will cost huge time to scan global
     bitmap. It makes write IOs (eg user space 'dd') become dramatically
     slow.

i.e.
an ocfs2 partition size: 1.45TB, cluster size: 4KB,
la window default size: 106MB.
The partition is fragmentation by creating & deleting huge mount of
small file.

the timing should be (the number got from real world):
- la window size change order (size: MB):
  106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
  only 0.8MB succeed, 0.8MB also triggers la window to disable.
  ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
  runs in worst case.
- group chain number: 242
  ocfs2_claim_suballoc_bits calls for-loop 242 times
- each chain has 49 block group
  ocfs2_search_chain calls while-loop 49 times
- each bg has 32256 blocks
  ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
  for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
  (32256/64) for timing calucation.

So the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)

In the worst case, user space writes 100MB data will trigger 42M scanning
times, and if the write can't finish within 30s (OCFS2_LA_ENABLE_INTERVAL),
the write IO will suffer another 42M scanning times. It makes the ocfs2
partition keep pool performance all the time.

The fix method:

1.  la restores double la size once.

current code logic decrease la window with half size once, but directly
restores default_bits one time. It bounces the la window between '<1M'
and default_bits. This patch makes restoring process more smoothly.
eg.
la default window is 106MB, current la window is 13MB.
when there is a free action to release one block group space, la should
roll back la size to 26MB (by 13*2).
if there are many free actions to release many block group space, la
will smoothly roll back to default window (106MB).

2. introduced a new state: OCFS2_LA_RESTORE.

Current code uses OCFS2_LA_ENABLED to mark a new big space available.
the state overwrite OCFS2_LA_THROTTLED, it makes la window forget
it's already in throttled status.
'->local_alloc_state' should keep OCFS2_LA_THROTTLED until la window
restore to default_bits.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/localalloc.c | 30 +++++++++++++++++++++---------
 fs/ocfs2/ocfs2.h      | 18 +++++++++++-------
 fs/ocfs2/suballoc.c   |  2 +-
 3 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index c4426d12a2ad..28acea717d7f 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -205,20 +205,21 @@ void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
 
 static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
 {
-	return (osb->local_alloc_state == OCFS2_LA_THROTTLED ||
-		osb->local_alloc_state == OCFS2_LA_ENABLED);
+	return osb->local_alloc_state & OCFS2_LA_ACTIVE;
 }
 
 void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
 				      unsigned int num_clusters)
 {
 	spin_lock(&osb->osb_lock);
-	if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
-	    osb->local_alloc_state == OCFS2_LA_THROTTLED)
+	if (osb->local_alloc_state & (OCFS2_LA_DISABLED |
+		OCFS2_LA_THROTTLED | OCFS2_LA_RESTORE)) {
 		if (num_clusters >= osb->local_alloc_default_bits) {
 			cancel_delayed_work(&osb->la_enable_wq);
-			osb->local_alloc_state = OCFS2_LA_ENABLED;
+			osb->local_alloc_state &= ~OCFS2_LA_DISABLED;
+			osb->local_alloc_state |= OCFS2_LA_RESTORE;
 		}
+	}
 	spin_unlock(&osb->osb_lock);
 }
 
@@ -228,7 +229,10 @@ void ocfs2_la_enable_worker(struct work_struct *work)
 		container_of(work, struct ocfs2_super,
 			     la_enable_wq.work);
 	spin_lock(&osb->osb_lock);
-	osb->local_alloc_state = OCFS2_LA_ENABLED;
+	if (osb->local_alloc_state & OCFS2_LA_DISABLED) {
+		osb->local_alloc_state &= ~OCFS2_LA_DISABLED;
+		osb->local_alloc_state |= OCFS2_LA_ENABLED;
+	}
 	spin_unlock(&osb->osb_lock);
 }
 
@@ -1067,7 +1071,7 @@ static int ocfs2_recalc_la_window(struct ocfs2_super *osb,
 			 * reason to assume the bitmap situation might
 			 * have changed.
 			 */
-			osb->local_alloc_state = OCFS2_LA_THROTTLED;
+			osb->local_alloc_state |= OCFS2_LA_THROTTLED;
 			osb->local_alloc_bits = bits;
 		} else {
 			osb->local_alloc_state = OCFS2_LA_DISABLED;
@@ -1083,8 +1087,16 @@ static int ocfs2_recalc_la_window(struct ocfs2_super *osb,
 	 * risk bouncing around the global bitmap during periods of
 	 * low space.
 	 */
-	if (osb->local_alloc_state != OCFS2_LA_THROTTLED)
-		osb->local_alloc_bits = osb->local_alloc_default_bits;
+	if (osb->local_alloc_state & OCFS2_LA_RESTORE) {
+		bits = osb->local_alloc_bits * 2;
+		if (bits > osb->local_alloc_default_bits) {
+			osb->local_alloc_bits = osb->local_alloc_default_bits;
+			osb->local_alloc_state = OCFS2_LA_ENABLED;
+		} else {
+			/* keep RESTORE state & set new bits */
+			osb->local_alloc_bits = bits;
+		}
+	}
 
 out_unlock:
 	state = osb->local_alloc_state;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 337527571461..1764077e3229 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -245,14 +245,18 @@ struct ocfs2_alloc_stats
 
 enum ocfs2_local_alloc_state
 {
-	OCFS2_LA_UNUSED = 0,	/* Local alloc will never be used for
-				 * this mountpoint. */
-	OCFS2_LA_ENABLED,	/* Local alloc is in use. */
-	OCFS2_LA_THROTTLED,	/* Local alloc is in use, but number
-				 * of bits has been reduced. */
-	OCFS2_LA_DISABLED	/* Local alloc has temporarily been
-				 * disabled. */
+	/* Local alloc will never be used for this mountpoint. */
+	OCFS2_LA_UNUSED = 1 << 0,
+	/* Local alloc is in use. */
+	OCFS2_LA_ENABLED = 1 << 1,
+	/* Local alloc is in use, but number of bits has been reduced. */
+	OCFS2_LA_THROTTLED = 1 << 2,
+	/* In throttle state, Local alloc meets contig big space. */
+	OCFS2_LA_RESTORE = 1 << 3,
+	/* Local alloc has temporarily been disabled. */
+	OCFS2_LA_DISABLED = 1 << 4,
 };
+#define OCFS2_LA_ACTIVE (OCFS2_LA_ENABLED | OCFS2_LA_THROTTLED | OCFS2_LA_RESTORE)
 
 enum ocfs2_mount_options
 {
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 166c8918c825..b0df1ab2d6dd 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1530,7 +1530,7 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 		 * of bits. */
 		if (min_bits <= res->sr_bits)
 			search = 0; /* success */
-		else if (res->sr_bits) {
+		if (res->sr_bits) {
 			/*
 			 * Don't show bits which we'll be returning
 			 * for allocation to the local alloc bitmap.
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
