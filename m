Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE937C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 20 Mar 2022 15:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pvRCVFAfl/I/rjvLF9y53DzvAFGU62o9BzcRL4L0G4E=;
 b=T4cAml0kSatd5mIg3MFg7p+M/Qnu9GpoN0eUKA0/9nne+Q9WvmVlFKBNcSNr/5umB0GSs4Q0BDSf
   jBPJtG0OxdeY66qWaAudDygrLlBWDRPced6Gnx5vO5zAxuMVBjnhFGJ+rijg83ZAoj67NVJ6/nF1
   eWD1LcTzjeKbO0VMKCQSeQxP6Yp2ESkYbVMmrOwpS6bs3RfyqDfxiGgro9sCNlEWc317/XmvbxqF
   XR8YgMQO15p/gqg9nDhnNJJKxVKXUuOkHx2VTAxcNETNvI/1fxzKP1vm37anzNpt5jOKpug/vpUC
   f+nOa1Kh5863Stftve9Ig82OQMrGYRzF3DNSwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pvRCVFAfl/I/rjvLF9y53DzvAFGU62o9BzcRL4L0G4E=;
 b=J0bJFTn3gI2gxhlLTPT/N8uUxyOqw4UuKDI3MB9EsrAiAT9m39FU0gYhvDEudieEv8ZEHDAaRDeU
   4tNDWH570SF5vVE7PaoyGYwPWYNE7HpZikJMur2Mx6jLm7XC6a6SrxzTdS8rKOnjMWwYOTfu9kcC
   xJUmK4I50bDXSn7krTrcjSXFcj8WL4MsrffJ32CmFr1QSS67yrTb+6EPWrLmGC7nGsTqR7CMfV9w
   pgDiKbMECPPjUlZdd5DsqmzQs4d1nIWE5uvgP+CDtlSiynfRoJDZ6yvh/oms3Fyl6dtzAszObPPD
   LosgTT5ytGPtcHbUQI+eyD1sdTWB/f32Ee2ohQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R91008CCUHU1370@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 20 Mar 2022 15:17:54 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=heming.zhao@suse.com; dkim=pass header.s=mimecast20200619
 header.d=suse.com; dmarc=pass header.from=suse.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1647789457;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=8ZNm0yc1fAyf3ohKfBZjNwUhNnKQjP+WodLviAZ+1cY=;
 b=lKd7Ji9/Hlj9Dh2J7TpH2tQ14RQHvyfqEXiuEpaueF+CA6tZ2302jX1zgYkG3SGEXKercn
 h0PUc6P5MdL+GVnBDKOnh8h80wSBtXEXek+m9Du4TVLkwKJ3crQHCCHkbhE0NDVNuUzAZU
 9O5MGAckebINCl1P2QEe9E13XFJdgZA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YoMxWRswFZEFMWafcsEQ9zAueMMJ4MTdn1weAU7wMa8ZQ9lMyT+3l7o2RizrVEFZY3mEZ9wqQmpZk75eXREJxHu3CVGSrBtzOZk7ahr+KQcgW6x1JjRrNpiAHswvG47WDG4H5zdV/mv/1xRHIymMvbwyqK7uIgwKQ+kq5M34MN5ZmMKmq+/8Ya3Kkv2AuG3PrubLAxa61mwwWtVt+oXI+ab/eNhYDz/+vf6661btJoqQBct/W6iVfvmLxm/Qn4QD3mqfOeCjABRuLfVOqf6lLxEFzcTUjEQCCi0VD9OEmdv3qWQLGyTum95qF6lS0WT1q2H9lTDeCglPhK0iSx09xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ZNm0yc1fAyf3ohKfBZjNwUhNnKQjP+WodLviAZ+1cY=;
 b=MjFdwP60WQ+sWV7utzrvB7xuVht1BFMab+UsfABFjLI/6bZn/NIft1kxJZxX8AgDBJ4Roz5R1xOaS0yArpdXp1/af3j8xblO6sucmL8eyxiaqeearA/JbkCO9EgOkzukhOP9DCCpGs1gGJmfbf6H4z4WjH03q9DIhm3JKPDi6YftkTZrAzoqfGHqcA4ql6OrST6magRLKvQywl1w61RFONz4KzMhcCmnkJsW/M+S+xSyGlSaXHu8s6QuWYOgZZVc3fMYzKRtHNBK9fwcufYveRZJ2tyktp8LX/lOLoWvpexNBGP2lx/o9l9jVVPMzkUAVSnRDMU0QUxXKph7zhgUSg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <b234830b-be10-1f20-68fe-5f0e056dc09f@suse.com>
Date: Sun, 20 Mar 2022 23:17:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220318150401.2411-1-heming.zhao@suse.com>
 <3e2bc324-cfc9-f25e-e5ff-0440f784256b@linux.alibaba.com>
In-reply-to: <3e2bc324-cfc9-f25e-e5ff-0440f784256b@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(186003)(2906002)(53546011)(26005)(38100700002)(66946007)(6506007)(6512007)(6666004)(66556008)(83380400001)(8676002)(66476007)(5660300002)(2616005)(508600001)(31696002)(36756003)(8936002)(316002)(31686004)(6486002)(86362001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 15:17:33.8418 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291
 signatures=694221
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=180 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 priorityscore=120 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203200113
Subject: Re: [Ocfs2-devel] [Resend PATCH v3] ocfs2: fix kernel crash after
 mounting when journal doesn't ready
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
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: 1QcZshplPcivf8yPI_Z9MQ-1
X-ClientProxiedBy: HK2PR02CA0160.apcprd02.prod.outlook.com
 (2603:1096:201:1f::20) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1845e43c-30ad-408d-83e8-08da0a84c21a
X-MS-TrafficTypeDiagnostic: AM9PR04MB8843:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB8843B64630F40A0B34CB2CD997159@AM9PR04MB8843.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 JtvFLceQq6UmDPvjkOPCJcH/YvribMRu96EbG+OSVQzKfRdZNshraLo8W+6kdeWjvA1vorSX6WqvwxOu4h782WIUHEwr5JMDCrDspT/2aZ9yzNWfoLhOU92suLLzFJOt4+zMKslTCt7EDEAhK4CdEAZd1hl2iJQ12dMtDMRoR5n29yNSXUIx/PQ/gQoP8wr5VL3cDT7ljB4+UKbXRQxu6W/Rn6H84gnRMpdPxaoGdctNo8sHpuGVObNu3LhPEN/F5R3mCuA+FNY+cZ/xHLA1p+Tj/xj41zRd1+nfwyf+y2mAVLERqcmLzfLCCz9dqjZMzDHZ2rfadLwrJ1Np5XTmlekurInRhmA1zmV/1KgeCBBcXUqI9STFMzOpxxXocGBH4f3lBlc6GoIcBRsMKUKvG99Wir0EtoLbKT0eIgrwwbHUvej5LINUubvD3vg8plhmeKqPfU3seuLoWShFYibaHTSjF5SIc9KhfX1yMQwVUFU1dKprGp/AOswVixs389kj4Yq7ZXr9qjlxCAxhmSBALpQrIckF2lD3nJSRrBqMxVe15y+nBLRYNk+rU1MaRHMRqi4LKd9ITm/3Etm1Gyc+Dlzxd7kQ3kuHDJ1wFNZDE8UFVt0X5opLCm4na8KZ1rjDI87qJQ4voY8ReKrAVxr7ctRIa9fib/IpLWsWhJEUeYIeY4s9x1hGMFEJVDNT3ZPFskhslFuNPDiCGTL+zdtAzF3Q46oajZVsXI7tyX6pVYs=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Rko0WFJwZDdwQmJ0OFM2cjBMbzlVVFF6eVVKVlBpSGtZOXh1T1ZaL0F2NVZW?=
 =?utf-8?B?cFBETTkxUmJwc3pPSkxqbmVUaVV4blF6VE1GaDZNVzFBVXZKemlsblpFaitE?=
 =?utf-8?B?djdkdDZydXlBR2Z4b1BxdUNYbktMalM4WnFQS25kVDJaNVFJQlJzaDFRZjU1?=
 =?utf-8?B?UFZJVU4ranlOaGNnNmNZWEZUZ01SeGgvYUh3MkE2aVR2T2EwRXg0RnZvVW1U?=
 =?utf-8?B?dndWajR4M095QkJRSkhGcnpQbVVMRHFGejMrd2JSc2MvVHpDS1BDZWNjaXhi?=
 =?utf-8?B?ODFhMHo1cDkzWDN4eUhyZE5aTEQ2c2JYcytJNmlZQ2tnTktkVDNraWxDd2NU?=
 =?utf-8?B?SnIySDZ5WjJ2V0twVlFpRkFlblFPclRybG42MVcxVEY5Y2d0RkZsS0p3cU0r?=
 =?utf-8?B?WmIxYWtPQ1d4ZDRiZEpPVU8rWTZJRnhiRk9SaEs1dzQrMkVmc1JHQ1JTQWJX?=
 =?utf-8?B?bGtNbzZBTVFkaERaVm82Y3c3b2NWU0dMZkduYWxRQW9LOEJ3VWJDSDhkS0VI?=
 =?utf-8?B?eExrallZMTBKdngyMEVRaUZNbWxINWwzVk00MENld0sxS09oU3V4VjZiSUkz?=
 =?utf-8?B?MmttMitiWnhHbzFKSlB0VWRIOGhFMmtvd0tQd1ZaMlY4emtzam92YmZCSnNY?=
 =?utf-8?B?RThNRGZQTFB0UVJWRkRpZFRhc21SQzdHVlR4bDhLTXVua1B0T2dMTytUcmY1?=
 =?utf-8?B?cDJYQzAvNENYMEJiT2c0U3l6MDBQWlcrUCtnbU9BZGFVVWVmejc3bEZSVi9i?=
 =?utf-8?B?SjVWd3pFWXRHRUM3UWw1MkgzTFFRdGo3OWdvOEczd2lQbDZZUUtheHZzZjk3?=
 =?utf-8?B?MlM4OVZ5VnBKTGRmRWRJdmRId0VISVZTSXZ2K0ZnYnBuUk9LaTB4d0xaWGU1?=
 =?utf-8?B?NXYvUUsyYUlpVlNpQkRKYjBQQXNYOGdVY2hkZVo3TzM4T0pJRmQ5RzhvZWk2?=
 =?utf-8?B?dHIvcDBnYjdPMklxRlR2dEJic0JBTVEzTW1WalY3SWw1dkNQMW9NbVJSenFS?=
 =?utf-8?B?ZHJmRUpLR0FBTFJYNzB1SWEwMytMVU50WUNrUlpESVpDejFBb09QNE9qTFJa?=
 =?utf-8?B?MktBU3ZxZG4zVW5zdWRtZmJJUnRnN0hBNHphM2hMb2ZOSWpUZFV4dytYOGRl?=
 =?utf-8?B?RE1oSzBRQzhBdVJlUjJHTE8yUGwwU245SE5IOU9SdW0vZklsUzlsdVlUT1Ns?=
 =?utf-8?B?NTJNT29HT0s0T2o1U2R5TUZ4UzVhSFBGQUdGZXlkb1VNc0kwVWxvU1dHS21k?=
 =?utf-8?B?RDhCcXBNNmpldGVGV0xja2ZXd1FYaDUrNjZRZUxuZnlXVXc2bDFuK3F2WHZN?=
 =?utf-8?B?eU1mbXowSnRZK01TejljU2Fnd3lmYmJlRVhEVmwzSVQrc2h3djhXQURFODF2?=
 =?utf-8?B?K29KTCtWSnZMMnRBWllSb2UxNEVtMkxWSElpOTVmOU1acUhnTXlPcVRmdXZC?=
 =?utf-8?B?WUEwc25qWlBRTWwxV1o1NElpYWl6WnkyejJxbC9uY0psK2hidTY5M2Z1M3hE?=
 =?utf-8?B?ZXYvVXV4SHlXSXUzUy80aXpNNVFvSTRSUThWa293ZjgwaEZSUzVXUUt0b0VJ?=
 =?utf-8?B?c2lFRnJZdFZoemtQUGVEQTg4VzUybEN6aFR2ajhHK2FHWkpSbnlQOGZqUE0x?=
 =?utf-8?B?b3J2Z2RMT052b2dXVHpxeXlqVVIrczJWODlMUnVqZDl3KzJiYzJaZkdlNllr?=
 =?utf-8?B?eWlRYm0vTys3OXQ1WG01d2NhakdQd2tBUkcvN0YwQWVBc1hrYmMxYnNPR3VC?=
 =?utf-8?B?ZFpUa1hCRzM3VjRxRXRuYU80RUdHaVJaR2Y3TVJyaW5MaS9kbmw5S0NkWkRh?=
 =?utf-8?B?dElQWUppZnE0Z253emkweTQwSkN5eXFCR1pXNzh3MitNOS90dXJoMXRFSHhM?=
 =?utf-8?B?N0djZXlqczJNajBZNy9hQWFNQmp4SEF5VFVXaXZtZlZLcExiUENzbkJuTWhF?=
 =?utf-8?Q?FwJXSh/+vUXhf47x1gg15upHxHfwmVuF?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 1845e43c-30ad-408d-83e8-08da0a84c21a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 VWRPeghlppwGovZZH6CNdovUOgB+oCC7/DVmxJA4pjD9qQzbXgPI4so1iCN/YeyNq+M13sRXLwA6LZJBh+Cdyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8843
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: fa8FI8Vq6HMyvgWmMSQNasGT6jSI2HVh
X-Proofpoint-ORIG-GUID: fa8FI8Vq6HMyvgWmMSQNasGT6jSI2HVh
Reporting-Meta:
 AAG3OcFVxDAcdPYzBAROm4Gfp8j2s9n+kG/egkoo0CAoGaBQG3XcytP1dMsyHf1r
 pMV7gx53OgpPGvpJd2UU1zVh2PW9x8i+HzIbLKN9/xxuuBO+rzDbycOrRawrPsAb
 I/M/tn7iPZbXbxpdswUPNWaWu7yB0kVmxSKh/upwHjOA5dGLz7gUVrFirkfIba5d
 9wYtYpxGgKXZfDOK0rdJPTx74qeJ31B3oh6beI2DV1onBCSa6niP3p5Oa+M1PxgP
 dq+Txur/zrSaigTTTk2T2M0Z0QUwa+HwFpK9NGeG8xIyFHHEmwHAXa3XrDzMSuA0
 hGyGx1y4hJOsQNVHW7pf9jEfWVwRKtJEB26aaXBHXvTtSp6Wo4luhNH52xsgi34D
 yJqyh4JxzgTe6zQSz2YDnG7wGt6ERFtg+4YJxun+nfKM74bmoKywRE6dq06FEVZh
 6Zl92+5+ZLTBMmZzzR21yXtVlFQR8KeDBxuWs/DmHUKqc850xJn84Ia75dyjDCpb
 BLveMPwqb4dos5k00GOpTWVT5x9FleBQF7Bxz+ZdimBR

On 3/20/22 21:51, Joseph Qi wrote:
> I don't think it deserves a complex fix like this.
> iput() is a common action and we don't want to re-create a private flow
> in ocfs2. Also I think it's not safe.

I have another viewpoint, it's not complex, the v3 is only related with "error mount"
or umount flow (I could change it only focus on error mount flow).
all modified functions: ocfs2_shutdown_local_alloc & ocfs2_release_system_inodes.
these two funcs won't be used in normal IOs flow. IMO the changes are safe.



> I suggest we take the way to make sure ocfs2 journal is there as a
> prerequisite.

with this idea, journal should be inited before any inode operations. it's tricky and
developers should take care of it all the time. commit da5e7c87827e8 is the cost of the
tricky code. But with v3 patch, (in theory) journal could be initialized at any time when
mounting. which could avoid similar bugs afterwards.

Thanks,
Heming

> 
> On 3/18/22 11:04 PM, Heming Zhao wrote:
>> Call trace:
>>
>>    ocfs2: Registered cluster interface user
>>    dlm: no local IP address has been set
>>    dlm: cannot start dlm lowcomms -107
>>    (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
>>    (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
>>    (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
>>    BUG: kernel NULL pointer dereference, address: 0000000000000030
>>    #PF: supervisor read access in kernel mode
>>    #PF: error_code(0x0000) - not-present page
>>    PGD 0 P4D 0
>>    Oops: 0000 [#1] PREEMPT SMP NOPTI
>>    CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1
>> openSUSE Tumbleweed b40...e84
>>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ...
>>    RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
>>    ...
>>    Call Trace:
>>     <TASK>
>>     ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
>>     evict+0xc0/0x1c0
>>     ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
>>     ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
>>     ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
>>     mount_bdev+0x182/0x1b0
>>     ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
>>     legacy_get_tree+0x24/0x40
>>     vfs_get_tree+0x22/0xb0
>>     path_mount+0x465/0xac0
>>     __x64_sys_mount+0x103/0x140
>>     do_syscall_64+0x59/0x80
>>     ? syscall_exit_to_user_mode+0x18/0x40
>>     ? do_syscall_64+0x69/0x80
>>     ? syscall_exit_to_user_mode+0x18/0x40
>>     ? do_syscall_64+0x69/0x80
>>     ? exc_page_fault+0x68/0x150
>>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> How to trigger:
>>
>>    tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
>>    tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb \
>>               --cluster-name=ocfstst
>>
>>               == there is no dlm running ==
>>    tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
>>               == kernel crash ==
>>
>> Analysis:
>>
>> After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
>> Journal init later than before, it makes NULL pointer access in free
>> routine.
>>
>> ocfs2_fill_super
>>   + ocfs2_mount_volume
>>   |  ocfs2_dlm_init //failed, osb->journal still NULL.
>>   + ...
>>   + ocfs2_dismount_volume
>>      ocfs2_release_system_inodes
>>        ...
>>         evict
>>          ...
>>           ocfs2_clear_inode
>>            ocfs2_checkpoint_inode
>>             ocfs2_ci_fully_checkpointed
>>              time_after(journal->j_trans_id, ci->ci_last_trans)
>>               + journal is empty, crash!
>>
>> ...



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
