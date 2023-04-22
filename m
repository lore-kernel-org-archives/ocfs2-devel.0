Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE09FC6FD18
	for <ocfs2-devel@archiver.kernel.org>; Sat, 22 Apr 2023 08:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XjqJswArMlAenhyerYnHAyEaOg1cnrGWq9PmKFrmU3c=;
 b=Th/mHTPyQlWCnS3A3ocTdJpCXBjb9tff0nY1Lcs8T5F1jKQYT/Iob95VJ0Tg6N38/bwA8eCzSlc6
   j9NLZlkQgNy5+WOZrpBvFtxAN9QrBN6cOUltOAzhupuCmQ4zfw/ldBqwlh8Zg7rT/izyQuG+V4EP
   sZbT3BL/1cWc1XdvjzBfhwBEdQCxP7hGihg7Q7gklGnVlqV4xGk3FPOdw1dXI16ON2/yS0Xd64qK
   XxBJ/oVEkC7788skPm+jjKViP7ZfobR7dibeTZhwwG4zIjgT491UIz6d9/ZlIuq7AkalfcyXnI/y
   p2SA9gjvbuMggBqL2bFnT0D1MIXwgvlgOOUOFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XjqJswArMlAenhyerYnHAyEaOg1cnrGWq9PmKFrmU3c=;
 b=f6e1PCeV7vDVXTtb8bvUbhEJ17wEDfm87WmBIGy4Hsj+/wMioJfBU6lsGnc3jyT2QEnQdZ0z2nX8
   tLYgnfXgWdy8r95ddVp7n/RpFJlDuxRT8OCd7h/GMUKJvXwRkYPbnpfnTEKP9Hmaag1wYjRC/TN3
   GEceJe28GF3m5efn91HbGNzQFlX6DHEt89eCKnUHYohUfu736ICvdWaxkPb6uCXIIotphFaCONG0
   1ClB8ehMAIJGMcL11hM3dltFdr93dksq2OXR0DkGa0HCH03O2ZMM1rJ9Et+HeBbPaJvTI1+AWW9F
   Vs0wMzmwHbrsELQpn09G4YS8LqzO4VrFexYxDQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTI00OWOE57YY00@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 22 Apr 2023 08:55:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQ12AW9w+BbfcKGrUSoA+L11HUFcURbmXMq1Lc3QqMCkIsmzdMdJ1tuBcAW5f9h+Rv4gfLs6fjTG6vJ+1V4fDBENhOSrKwFt4Rn6cLYphn22hcIXRtT37Yr+Bp6XLMupEDfb3W2+fW2ViTCdSidngI1Ze/u2N2w76Ud4j7kXWs8TyWv9y7VICSP9FwQThbU4Kle0A4/E7amGt4AGu4xumGI9XT44T5n9O9ZYLNz8CdWImp8qbk1WYYyCqwX9f2NopXFE/Wx7azVLDJedGITsn6K+eBdMn2PKw6+LaNw1zC3uU+NFpSdSLTgjmhkvyjXsiWLUL5UcBzZpvkvNzAkUtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09XOKm43dd0cGl7lCXeMi0LpuksuDulCgMprwBYqL/k=;
 b=XtFmxXRnfIpiiml2b98btv3Xe/V3HQCOSDv3ba76F9fg58nCloU+gI/pkiyDpcgN3Kslf1PmK5BXvmleqLdBGmPjFfsOyyaWvtZf3UZYXZYx9e+BovTkdAaextwMGlXpIFVq+BKCotTZyM/Zth54Bunp6LRBp2atcnKjqVkB8X76rJOWP+Jo7vH5Tvmw52AsTVn05VW9JyVQ5kzsnFKtRX+5BExMPBMGaNZFR8LqZktNpq6KVDqOuYcj4VpJPooDgPuspuEJ7290u92iHyiNlSpAGjFPP0FGmo/a4ksiSzYKUp8E/EWnw53iBndbmvbpHGdLQmkH3anyskjKldyQEg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09XOKm43dd0cGl7lCXeMi0LpuksuDulCgMprwBYqL/k=;
 b=3dL84vDzxL8IBus3abM7bbZezj+8+4hweEGocb2CSET81IDYwZ1eZtGJa3OarYdXxY3ymvyJDNBj0kuXFYI0SOM0UG5oOy1arZRh030aZMddtHXcsy5q6WpWaOT1JYxb74bHAtr8HJ9KB9MY11csbw3ZlKVpzaRM0krqHUvzAurPJUkD3TDSKq1007X0whgfAIt511vBWvbuyUWYakbJUpU/mdag9zai34gZAnj+lHX4fpqWwcd8iv0M2Ce0mdiHfwTI07E6xPdt1OYZHCpX15D10UEULXt0S6+2u/X552fmE8t+z02eluFmYVei3424iSjLDaJ1ruCD6WoBSFoQAA==
To: joseph.qi@linux.alibaba.com
References: <20230421083653.20380-1-heming.zhao@suse.com>
Message-id: <46f6fa85-9001-2cb9-3972-327ad8ba33a0@suse.com>
Date: Sat, 22 Apr 2023 16:55:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-reply-to: <20230421083653.20380-1-heming.zhao@suse.com>
Content-language: en-US
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(396003)(39850400004)(136003)(346002)(376002)(451199021)(6506007)(6512007)(53546011)(26005)(2616005)(36756003)(83380400001)(186003)(38100700002)(2906002)(44832011)(5660300002)(31696002)(478600001)(8676002)(8936002)(86362001)(6916009)(66476007)(66556008)(41300700001)(4326008)(316002)(6486002)(66946007)(6666004)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 08:55:40.2886 (UTC)
X-Source-IP: 40.107.247.88
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10687
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 impostorscore=0 priorityscore=111
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=189
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304220077 domainage_hfrom=9706
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix missing reset j_num_trans for	sync
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
X-ClientProxiedBy: SI1PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::19) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DU2PR04MB9212:EE_
X-MS-Office365-Filtering-Correlation-Id: 235398c5-e0e9-4644-4009-08db430f590d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 f2UlTgvlYsGuVGrzbyvjJuz9o4b9QEsBsg1+9q6Fv+B7CZrMBq9tISm0/+IcSoTUMo956PKnzYhpmkvMVBdhXMWEeVmhMoRxWaXWzG7Gq2KANQGEQ5/oBDprSF+lfokBUNbQm0PbAaUbB9qbshTyojZb63nLs/3rP/D1FWBKG490fgCZ+sK7pA9iSqRZDu4TCvA2wojlbMOnZdF67N2eXxfPqMpgB9hurLJ8SgpjChTXR/VUF8EQynKtS/JX36XgtvYp05G8onehCxsPGYAhuiW3SQby1NcWeUcRz6jA8nBbWo8oZHoEm0/MnfwY/r+lWIjivJObCccsjD4KZWmlL0HR7H4GNdmDaxAWonLXXmuNsU65onshi3e0aziZ6bnpK0iU6nwFJDRPo5p0KPYW4pwqvrHdvSaeXGrpgCdk6WSXluEWOOSY1nic6HWLgk3SJ/AShpdpzNiNFZ/XjTYGUBFGB8X4LyoLcGg06sWe29xtlhrB4oV6uqtCDI3erRrF5Q5kF5W93fyh8rEQLKM0f42YRk4E5zIuJAPYOa0Dri71BtwJmNVAyx8aonxn33pMwdUcG/TlMKeSHAaEcLZfK3A5QsMcV2LuKfBnVW3fBRciWn2dAJACzEPvcJzUldpMz0bCgmqmBHYoNBL9OUp0KA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RlJtTmtHMUNpUTlKL2NUdXNTSnBRYVBOZTBWWDVBRXJVY2g4bWVKOVQyYUJ4?=
 =?utf-8?B?R00rNkxnZDlMZGN6RWd2Q2h6ZGJoYzQxK2JTYXNReGpReFExVkpxamIzN2Ni?=
 =?utf-8?B?SDNkMGNNelNaWXVGdjR5MkptanlsZ3VLQWZFYW5UN1p3dHVPMjhIU0tmTDFS?=
 =?utf-8?B?MHhvQWtwc2htNHJweFlzUkdYVlAyVHIwN2RINlNXUy9jWk81dGZJK3V3TlRq?=
 =?utf-8?B?R05sak9VY24zUXBDelZFaHNKQnlCb0wwSnhPYWpYWEUrZDhqcVdTaThDMlNn?=
 =?utf-8?B?bGhQbUNsYzdSZnpOYnRDMUFBb2hiQTVKVUJoVytDdTBtZ0ZJVlV1NDQrTGlI?=
 =?utf-8?B?QnFVeGZuQTNXY250VmRlOGRoQ0hodFpYSjZ2VWdFeUxZNmtpZFQwMkczUk0z?=
 =?utf-8?B?cmpvOXpINTZVTHNLbDRxVVRHSmxpekVGWDFzTHIyblRaSUpTNEt4YkhJZG9X?=
 =?utf-8?B?Z1NLeEZtMktlN2diVFhQTWhVMG9VS2JqSS9wK2RKWE5UV3NIM0czYUtRbTJR?=
 =?utf-8?B?NFl1S01GN3dqUXMzMG0xSTQ0ckRXa0E3SUdUenBXNmJubXFueC8yYVBDNlBK?=
 =?utf-8?B?Q3VYUmNPUUJEOWxFQUdCc2d0djNsZFY4Rzg4MmhYdE5OMDlpVGtyc25kV1hw?=
 =?utf-8?B?WlVPZ1RwandWUG0vWUV1ZUhZL1Z1R2xFMFVJUE9La2l4RDkyWlFSbWRrT01i?=
 =?utf-8?B?all0R1RCN2R1MytYMmdMMWZTdVhVZHZJaGVNS3lraEVud2N2N2JqU1E1NlMy?=
 =?utf-8?B?dEFHZ0N6THVrb2FwWmdnS0p1TVVQRENpWkdBVXhrRXBJejVhcjNnR05BWktj?=
 =?utf-8?B?bWRIWHhLZUVpbXNQY0tMOWlBZ2hsNHd3dGUwS3pOKzlpQXJGNEdZTUtMTjhu?=
 =?utf-8?B?dU1pSWlRakNxNVZvOWxubTcrZ2VlWEY4WDJUeW92RUlwc3BjMVJneFdRVHJp?=
 =?utf-8?B?QjRubm9vdEk3NVNxUnJ5WGVWWmF0Njl2TDg3c1huN3dsNXhobURpd29TcVZV?=
 =?utf-8?B?dHNxcklhbzBjVFcrbDhBYmVsWExLbnBZNDYxZGtSU2VKbzlSbUFZUWpxVm5o?=
 =?utf-8?B?TzV0V3R0Wm5sOC80UHE3SjVzcDg0MzI4MUpUSGtKYkRrL1I1SHNUNXB3ZHEv?=
 =?utf-8?B?TTVtd0dqZDI3bWpPNlNoNkdXZmFnYU55S09mZng4K2JvakhGcDNnNHpDNWl4?=
 =?utf-8?B?MXRRTFNLVjJ0TkpMQzlrYXFudHFzd2tLcS9sYklzVmZVeHkxeVpaaEhQL1hw?=
 =?utf-8?B?Uk9YQjJmeHVLSkp2RnpHa3Y1TGJTNVFFOXU0d2lPeUErZmFrMDFURDRrY3NW?=
 =?utf-8?B?bGpRR0ViWEhtSS9VbHhJR3BDdERNL3Nxa29BZllsMStjRG1BaUFLOG5Jd1Rx?=
 =?utf-8?B?eUZhaE1JZUpIa29Pbzc2bGhtbVRoUUxNZHlXa2lGby9rL1JnVUNNcjl1WnVB?=
 =?utf-8?B?NEhFcEZTWGtUbHV3K0ZzMElscjQ4WnljbjZmQ040YU9PRnV0Z1lQZnZKeVcv?=
 =?utf-8?B?WmNyRXNLY202UEJHaUZkSVB2MFVQUXF4MWNaRVJwUzc0TEVDbTVzZ1A0VkN5?=
 =?utf-8?B?MzJEeE9kTmdzK3o2SVRlRHZiaVZzRXZtdmlTMXZ4Nk9HeWFjZ0RtSlhqMFV0?=
 =?utf-8?B?S0NZZFREL202bzZ3dFZ1WWtzZXhIZ1lKcTR1WHlUVTBoKzFGSHh4SWZ3Tm5o?=
 =?utf-8?B?UWdyci9HZ2NhamxabzNmQ3kwSXdpMGtjTzRDQUxSNFA0ZENKQjhpdU5HRWRU?=
 =?utf-8?B?TjB5Ti9VK1o4dGc3aVBrZXhPMEt5K3FSQlBFUHN3ZEJLKzZxd0Uxc1J3RFM1?=
 =?utf-8?B?Sk5ORDFiQ3AzaDVYemlSOFd0N3ovZ0J6UGtVTHcxdlRVcDZpZEpjNDBRQWNX?=
 =?utf-8?B?aEtiZFpvV0N3dFU1ZGNobk95Um15b1RIV3VtVjVpRUYzUjc4T0VxbDJaNVRP?=
 =?utf-8?B?OVNFS2JoLyswMXZ3dDlWaWtoZGp0SCtVMlR3SzE4WTRJbFpkQnNHNGNwMVcx?=
 =?utf-8?B?WjhLTCtZZWlsRGd5aG40NUx6V0lGTDZEUDhVYVpWWnlyT1E1bGFCb3RRd0M5?=
 =?utf-8?B?bUxlSU9WVXU5Z0tqRVFEQldEMzNxL2JZd1FCd25oZldrdEFJMFR5ajZQZzFS?=
 =?utf-8?Q?iRWSDSkw/OESlTXDxZWvRHHO1?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 235398c5-e0e9-4644-4009-08db430f590d
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 zTicI1xE3KBfeaHJ2hBvCK9z+9xpf52wyECpCVn+F7GANAARYt4Yn3znDV1sIgb/Ii5mrFPpT4DX5Hd9RdKKJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9212
X-ServerName: mail-am0eur02on2088.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: _pboRBYlfV08VxcNxZJxGmcXYosIRyZv
X-Proofpoint-ORIG-GUID: _pboRBYlfV08VxcNxZJxGmcXYosIRyZv
Reporting-Meta:
 AAFcukRKDhz7kN1DzMnJi1o74B2WojWr/s+S/TmIpPeNQ5ch2Z0AnSH79otK0ac2
 gSd8BS/44KHORrEXIkelqMhoiTbxumUf+dm/IX+rUuJzV9oWkk8YvdptrOPpkMSt
 I7Uz4UXsEDE93H+ZIp7zKBXuHkADVOPlIuVrtKLPRpf0JcNyTmgYyvlcfHJ3Ge6x
 AxEdMVX97ULPFOHALj3bYN0QF2nK1u0fGY0WgGqFsVPLEKwOSo/zapBkz/UDE7g6
 yo4bEhZY0Aweun3205vn6VJDGOA8bNI7su9bQDPc/zTnUS8TgnEjkuc2wrI/tNWv
 JEDxsLW08Zxk4bxtGZIf1eG4NyQDdAH7mHlrgPsNwDX5NGOCiCwPYgWw85TlG+ok
 PXMMPgrmG8jBU2iRCPxcdlE6czrFxQB9clE8ZVPjLE0hXQZ+bx8cIza4Y4LMsHhK
 9TfPvXLb3Ublx4bRHm04HQlkK3ZfYhTo/SliWgMCJqKs1/T0k01iKZnK7wJcIaKy
 iKf7GdMVqkhnG6y445UxUINKm0edhUgc9xjJhVryr/E=

Sorry, please pause this patch review.
When I was investigating fstest generic failed case 347 361, I found
the wake_up() action should move out the 'if()' area. The correct way
is calling wake_up() unconditionally.

Thanks,
Heming

On 4/21/23 4:36 PM, Heming Zhao wrote:
> fstest generic case 266 272 281 trigger hanging issue when umount.
> 
> I use 266 to describe the root cause.
> 
> ```
>   49 _dmerror_unmount
>   50 _dmerror_mount
>   51
>   52 echo "Compare files"
>   53 md5sum $testdir/file1 | _filter_scratch
>   54 md5sum $testdir/file2 | _filter_scratch
>   55
>   56 echo "CoW and unmount"
>   57 sync
>   58 _dmerror_load_error_table
>   59 urk=$($XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" \
>   60     -c "fdatasync" $testdir/file2 2>&1)
>   61 echo $urk >> $seqres.full
>   62 echo "$urk" | grep -q "error" || _fail "pwrite did not fail"
>   63
>   64 echo "Clean up the mess"
>   65 _dmerror_unmount
> ```
> 
> After line 49 50 umount & mount ocfs2 dev, this case run md5sum to
> verify target file. line 57 run 'sync' before line 58 changes the dm
> target from dm-linear to dm-error. this case is hanging at line 65.
> 
> In 266, md5sum calls jbd2 trans pair: ocfs2_[start|commit]_trans to
> do journal job. but there is only ->j_num_trans+1 in ocfs2_start_trans,
> the ocfs2_commit_trans doesn't do reduction operation.
> 
> call flow:
> ```
> [md5sum]
>   vfs_read
>    ocfs2_file_read_iter
>     ocfs2_inode_lock_atime
>      ocfs2_update_inode_atime
>       + ocfs2_start_trans //atomic_inc j_num_trans
>       + ...
>       + ocfs2_commit_trans//no modify j_num_trans
> 
> sync //no modify j_num_trans
> 
> _dmerror_load_error_table //all write will return error after this line
> 
> _dmerror_unmount //found j_num_trans is not zero, run commit thread
>                 //but the underlying dev is dm-error, journaling IO
>                 //failed all the time and keep going to retry.
> ```
> 
> *** How to fix ***
> 
> kick commit thread in sync path, which can reset j_num_trans to 0.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   fs/ocfs2/super.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0b0e6a132101..9929320bd967 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -408,6 +408,9 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
>   
>   	if (jbd2_journal_start_commit(osb->journal->j_journal,
>   				      &target)) {
> +		/* kick commit thread to reset journal->j_num_trans */
> +		wake_up(&osb->checkpoint_event);
> +
>   		if (wait)
>   			jbd2_log_wait_commit(osb->journal->j_journal,
>   					     target);
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
