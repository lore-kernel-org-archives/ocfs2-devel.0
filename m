Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D5DC05027
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 04:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=35WRe+vrFdKPqwgwY/a4J0GVoa0SvnMbbIn8oI1vlc8=;
 b=gGLtE4JqnkkF2JzlXHVWg+O2wqE97bqOQHm+7C/6ShrzzDxqUd+kFwofkIhP1TSmqA2hPy7nC8D7
   xLnps/h/c1njq7s/gEz55RNIz9ZJ+h7Xi8e+rA7M1tpThPBg3d9pWkSxS1eAbgwMxy5R36Y91/0t
   fRe3/9kaHMKm9KIZ+EbslrHnPg4xJODCnVvaeCvwk7/ykRUOfvdEmCcdQzd/hZSfxj05rWNOwtjd
   86WC32eP7oi4EnEfUmfV/dPxiL1T3YNnTdSRnZmTteEk6gz0rCpEcDWQ6aMLlysK+1q4G0U8gJ2y
   EzpejS6J9Fs/J66TGEKP12aNMPmmhC1oSN8ZqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=35WRe+vrFdKPqwgwY/a4J0GVoa0SvnMbbIn8oI1vlc8=;
 b=KuUPOuTfeIzbgmYqLw/NqXZRbwa4SpmNakVy7SsvdmOL2z5oK3IAdk3c7vDIru0TZaHilaBL4uWi
   VHonHU1I3248mDvf9xMn4PnkW3bW/GppPYJCw2sZ8+2ngCoRx9VwomeZu0J/UMwonqvdibXs9Cs7
   bjRCcUFgeJpYv5E2+osO3N89TZZyWdHpt1n2pEfqfgkNC0HdzDm+3mWcP/lv/IjZklpXC5JA7Eae
   l6WQi7Pc+DKO9wqc6nSvZXfm5mqcbzA/6imX3xrNG+mCXNKl5p2mUHjaw8gvyt9WYPd9MBHKOt9G
   vCZHg7tY5gWuNal6AP8OfgOQcD721jyBADPWRg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD006VD34VGA90@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 04:29:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMKNsjFkx+Qv78RZeIgOzZeWeZbvI0tvDw8CDFld5jsHgFqnZUWiLyq7FdyhonKpn9K9Aj5Pm/hIJ7jmbMGQ3OqXJzreFnO6H+ek/SuVwAr7eS9KSf8nhPabu8pD7XzHynxtwDYTVjx3Li1ROufDB6/JO7jx4mRNJPWc1kjN6ewoV0k/ITWRLJF/6bmgClp0wtsnad+En8mc/mdA/m2H77szXPW5zS9HHw6T1WX5CfeIl/Dd7+k2ocGZUhhPqHL3lCn7xX4IudQFVCjHe9T+MhHw8WsFvP0BWafw+uMSRqwGg35VwYWWuK4/V12KE+Ub5/hWOlRSfg5OmdsHTVl85Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2NGmJosGAaPkcQgOHt83od/1Wu8DiqPPyofDohBIpj8=;
 b=Sobkg48at1+TmakYXVTFPQiaUwO0fAAegCa22SVWLfb4TCUI7aaaMVrq46PdNoQts5jmKKxZcYSqnWwduw0Z8ynONEnEWuNYP9C9eCvth5cYkAme2iV9YZ49wm7LdcdE8HaJo6OxuWFOu3tNdtjKGQprdjDZffANepPOfu4MGcaqzNuF3TTqUluANFI3xUIfqpVJqd56iw8J+/e0LcG1Nn6I6O4bim2Cm+yl3adDbAp+BcuZgamVbByUaw6vP+jEDGb9SdIVdhKRDpPJ5c1xQK6SqEoOfcvBNwypMLb7Y7i96J7JUmcYztM5R6pGXVFUOroCVYxI9F8md/Kufad73w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NGmJosGAaPkcQgOHt83od/1Wu8DiqPPyofDohBIpj8=;
 b=mdhnzXSz6ZWhTJk1y6ktvbMeHoc9M2WltqduVfN3LMgWnOPYobhZdGvbNeDcSwaDSCmUnjHbesI26x1le1fRZcuNXQqxP1OHwsHyVExZrObixXW2KMj2YEBn+nrsVkhXzv8d3gOgPLYwfR8UQk3M8aLk2s93pe/rbF7Vn/YpAFS1UfQam88Xd4z9Y9jTYO8hpEiSHiQYd3lnb6SHPPWjqUUsUqpdCOEDvdeqpDFLASrSUWUi5UCV6/6v1+v6XiU/fH3kkc+U4IXTShwOoZiLAPK2nSxrN4ErpB3GoOCB9cgxVOU6x2jvgZsHXTBXzFDh4twObqr73tzsbm/8Z7kXhA==
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20230217012000.5774-1-heming.zhao@suse.com>
 <650b3d8d-35cb-3385-f9ac-0ad31f9fcdc2@linux.alibaba.com>
Message-id: <ca674f18-03a7-1b65-ca06-f377e0d6f12f@suse.com>
Date: Mon, 20 Feb 2023 12:28:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-reply-to: <650b3d8d-35cb-3385-f9ac-0ad31f9fcdc2@linux.alibaba.com>
Content-language: en-US
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199018)(31686004)(66946007)(8676002)(66556008)(316002)(6486002)(8936002)(44832011)(41300700001)(5660300002)(31696002)(86362001)(36756003)(66476007)(478600001)(6666004)(38100700002)(6506007)(26005)(53546011)(186003)(6512007)(2616005)(2906002)(83380400001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 04:29:03.6703 (UTC)
X-Source-IP: 40.107.21.86
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 clxscore=174
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 priorityscore=111 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200040
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix non-auto defrag path not	working
 issue
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
X-ClientProxiedBy: TY2PR06CA0024.apcprd06.prod.outlook.com
 (2603:1096:404:42::36) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM9PR04MB8569:EE_
X-MS-Office365-Filtering-Correlation-Id: b922602e-389a-4285-a7a5-08db12faff2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 SjSxtra3u5igQmy+vquHNoQWVJrEClzBAOhpfndZUdZsX6rInrNDaBNX4/TXcvIWYc+U2tY+qlOPZKEwDxrpNEXvoASTcMdukPxjWygWYqFI9wCoOyXIbokK+S25CmexWf4S7wYriEr+wj5XBixbZZa8lyFs2q9x7HFKoBAhrirxFk1+OJxDNXLZ+iK6IuXoNFuBfMcBDdg5bB+w+wefIKjvezSe8rrqLrRVZZKdnuFmjXFR3QAy0HSKbzGP+eM7gu4cOf2l5rEAB2IJdq985b8ENGZu9UXatfNebwsLhZa388jsvbpAA1JLEetDPgnyVUaDWN30Gijb3oMKt1iAO9A/nBfsqbinduH3Y5YyMJdFL6ICEiaU184ziDdqob74rm2tMkYpkSL/mO+5H5914S03cbZDzk+/f/vzfZSq/oRgJm+J09UKXyYy9yyTgLavpAcez8x+ZCIeO+h5L5sX/5/7ls8tr1FBSDZtW173/K9zftnLauDjhcxuG32nuqNg16BlaZCEeA+i7xcIkJujgTY/WN5OB3pIf7UTohLQrQm4lgzFgy7Mxa+9rQv3B9icQbLt8W/fRx3rq0m+PrzoqK+Dr2c/VKz56KsrDLTIuK02jBIFqGy0vFs0QDCXJp0Pa8QxzfS/ZVbGuHVzoRDtfhCSfXI1K6MCtvGY1jRkUXIaRCKAaQTs47k0LMAarge3gOLXStuMMcUQs133aGrK9QQQhVHwYxbJt+dMKxND/0U=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ejhMNDhYQ0R5Y2RDa3NCSm1TclpUa2Z5V3NDUnhEUjNWSVRmWWkreDVTcllN?=
 =?utf-8?B?WlBublNhVkpmRmI2REhWeWE1NVhwellIb1hycjNWVlh6MTRNN3VBUWRlSW9N?=
 =?utf-8?B?UzJiN2lTM29xVm93NDNLS21mdFE0Rm5YQ0FuZTJleWJ5WXlqUDgwSjZVSDE5?=
 =?utf-8?B?RzFHSlZSU0gzRUlFWDV4WmtMcFlBZFJ0aVNEVTdUWkhYeUdidU1hSHNQY2Ra?=
 =?utf-8?B?aHpIZ1ZiSkw5OHl4dGY2MWlTS3NNRXJPZ2Q3UDNFelRnSWEwakFmM2dYMjRq?=
 =?utf-8?B?eGdWMDduL2V3emtNdEFhWmFvTmo3T3RPWGlQeTdCbmN6NWgxTGZNbGV2d2JV?=
 =?utf-8?B?ckNYZ1JnTlUwNnYxNW1HSjJ3V0p6L0NSTTJvdXZURlYxL3NPeTVqNFNoRkpI?=
 =?utf-8?B?QXEvN3NKU3VFai9WMm1Tc09SYUhtZ2w0eUpiMWVjSzBucmRoc3FaRGROZjlp?=
 =?utf-8?B?blhGSE9iNFVyZTdockFkc25aeTA3YjNpYjhLUEV6Mi9HU0N2ZFp6ditrbWpS?=
 =?utf-8?B?U0pINzMzVGw2L0hSMkpKMEs3a1hhbDlKT3BVSVJoWmFuVVZqVmtOVG8yZkZD?=
 =?utf-8?B?RlRRNVhKSmluU2M2dHNNYkhQSDRQeTJ2enJSTnp5ZXY1cEx6dktrK2N0M1Ew?=
 =?utf-8?B?WFJEcFlyWWEzbTJjVyt0cnhXbW5RanVjbW84dC9ZZ0FSQm1NR3E2Wm5jUlpY?=
 =?utf-8?B?RE10Rk0xYlIyMGwrUFdUNElRakpCNnNvekRjMVpnT2ZZNUVmQktpYTZZZDU5?=
 =?utf-8?B?UE44RWh5WEdOS0RMakQ1eHQ4eDdCM2NsTmFaQ2VLY01wU2Y4d3MvRkFjYmRJ?=
 =?utf-8?B?amwzN3d6N2tjc0ZvLzlWOTRHM0tONFl1UWVPQThDOUo1QW1sdTZWNUpYZHZk?=
 =?utf-8?B?bmdCaHV0bGw0ZlkzK1h4RnpqSVhnSUViQWJLOGd4M1gxWVRxS1laNmR5YndW?=
 =?utf-8?B?ZnJ3T010OEJkMXlsV2krTmxFam9hQjhadE5NN0ZmSFRaYU41Y0trNUpRYkp3?=
 =?utf-8?B?WCtQZm5mRTQ2eEFZaHFmOGRGeThRVko5TWFGbmxHeUVhQ1lObFZHNUxKK3k3?=
 =?utf-8?B?Y1lSZUlUNHppYWRqQUpiQzl5WFZpSWZtVVZCb0hhbnBGTEVWZWlocDFVRU1i?=
 =?utf-8?B?d3pHUitwSXFRVEVHU1RJMjlRMnV2UWNjTU1FQzZJUVA3MGhPNklJUUhGMmVm?=
 =?utf-8?B?a3V4ZDRTbitaeVp1cGJNT1BPRlFmSGI3aVpVYURObDJYaDFQTkEwTmNwU1hu?=
 =?utf-8?B?cVlveGpMclBtc0hIakNsUnE1RlBCL1VRMmJRTHlmNnQ2QkNEdEczclFLQ2RR?=
 =?utf-8?B?RUoydkY3UEdPanllRytUc2VlNTFHaVgyYjN6ckJKOXBhblJpVXh4SVk4UUhW?=
 =?utf-8?B?aUF4ZjZBYkMxRWdoQXNWMmxZK3EwdnlCUWcvQjF4WlBkeUtMWDdqcUNSTlk0?=
 =?utf-8?B?VW5OK09CdFJ6YTlCeTMvNWhjRXd3d0hJUnhVUGhjVDg1YXJjV1QyNUsvRkwy?=
 =?utf-8?B?eDRpNUpINkV6MlBPZlNaOExQcEtjUk1sSUVUZkRsUVBSRUpFUzFsUjd1WjQx?=
 =?utf-8?B?U0VHQzAwU2I2V0JYZ25xU2xUYnVnTytPcE1rRlZ6eG40ZlNCQlIrYkpQWFdX?=
 =?utf-8?B?dEl2Vm11YkdtSEU4Z1hBakhuaGMyVXRLSVRRRnVLaXJRR2w4Wk5OZEc4cDdr?=
 =?utf-8?B?SkJaUTA0eE1PMGRiNkh0ZWhJcWljZWVhMUluZlZhdlZ6djViVWtZTmJxZE5r?=
 =?utf-8?B?ZkRJbFB3V1ZYVDZrTjhtSVBpTi9Wa0VtM3NkM1NxWGJ3VGNqSGxDZjVWUHJW?=
 =?utf-8?B?MHdzVTJWd1pLQ0JhR2szVERQQWlWVEU2VnFnMkdJYWorbGFTYW5JZThHTUdX?=
 =?utf-8?B?bkdGTVdiVUUzTmlWREFxMHp5ZVZqcldiNXM3Uk45ekoyRDEzZ0wrUjZFb0tm?=
 =?utf-8?B?YkZiMXlzMDhvRmNLandsczI3VkFIUHpqQ1p2dFlDSGFVNmR6YlNwY3dKR3Na?=
 =?utf-8?B?WjBSRDdXckVxejZ3THFVZU12N2tMdi9wSGVkSWxHSTJZQ2hqcFlnM2N2RUV1?=
 =?utf-8?B?Vmw3MmpJdDVYdmFtWk5Wa3dlb0h0SjJtM1ZQUFFYRXU1ZG1YVXJySlNMQjU4?=
 =?utf-8?B?TDRUczNtRFRjeFA2UjdBRHRPWU1OK29SWU9ZYnZxV3lWVlpaSzNJd3g5UWg4?=
 =?utf-8?B?N0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 b922602e-389a-4285-a7a5-08db12faff2c
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 qmxBQC/pGFhZvsk8TPoEObBJEoLLfAwEfmklT58iwcwZ/wFu9TsmI8WfPc1oY3U9gKgfj0auA+eA5OV1IVhAJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8569
X-ServerName: mail-vi1eur05on2086.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: hOGLkQd9BWVslVIG0ssKL1N4g6EqdDff
X-Proofpoint-GUID: hOGLkQd9BWVslVIG0ssKL1N4g6EqdDff
Reporting-Meta:
 AAEBKZD7Oe/NkV94WjK8K63OYE0nImWlLFX8/eo6+vobO5qn5Jf41HDQ6no4l0EC
 bahzvR8FOEXRMixFj4SemcwNKLLD9ejPmI5oJimbI7f/CAeJNtCczgl81l/w/m+t
 DuIkSuQ2kopZAJi1ELSCzQdg1l4VWdvH50fyNYgioSJdvVNft5BGK1jqjv15Kdmp
 eugZeSdzV0ayTi5HY1GI3wtB/8VrSLviyNiRzhFAzuFMbT5HP88bBAoqhbnWmgoT
 i9V6OByqUJ6BMUzanym65LysIjt6luSwUD2VWOipRh15LjTZoFDMAJFNjoQ63+je
 E1LAp4heH5OntObo4fgd14cO40WxI7vmrpb3/vmQlqQHCLMcDnGqfpEMEa9upj9R
 koo6MP/EHfRguDy5cKJ4eqAoBQYVtwMtCaq22o9ii9vR8ACpaoXowE5QJ6/GzTJ2
 HDYXhCT7iVISQeN/QGcf4Rh9oKzYry9VOnoPTLDHqVUjP0uneI17dBG3wxl/daFZ
 pblS4483zU2E949EtQ4lDb/HZmdXtutHhH23Tlo/hss2

On 2/20/23 11:18 AM, Joseph Qi wrote:
> 
> 
> On 2/17/23 9:20 AM, Heming Zhao wrote:
>> This commit fixes three issues on non-auto defrag path (defragfs.ocfs2
>> doesn't set OCFS2_MOVE_EXT_FL_AUTO_DEFRAG on range.me_flags):
>> - For ocfs2_find_victim_alloc_group(), old code forgot enlarge bitmap
>>    range for global_bitmap case. Old code could generate negative
>>    vict_bit.
>> - For ocfs2_probe_alloc_group(), old code forgot back off move_len when
>>    finding enough bitmap space. Old code has possibility to make data
>>    corruption.
>> - For ocfs2_ioctl_move_extents(), this func should set me_threshold for
>>    both auto & non-auto path. Without setting me_threshold,
>>    ocfs2_move_extent() will make 'move_max_hop = 0', then
>>    ocfs2_probe_alloc_group() returns 'phys_cpos == 0' under max_hop is 0.
>>
>> Another info is current defragfs.ocfs2 doesn't have ability to trigger
>> non-auto defrag path. I modified defragfs.ocfs2 source code ".me_flags"
>> and hardcode ".me_goal" for running test.
>>
> 
> I'm fine with the code changes. But the commit log needs improve.
> How about the following?

OK, I will send v2 patch.
Thank you for your review and spent time to revise my commit log.

Thanks,
Heming

> 
> This fixes three issues on move extents ioctl without auto defrag:
> 
> a) In ocfs2_find_victim_alloc_group(), we have to convert bits to block
> first in case of global bitmap.
> b) In ocfs2_probe_alloc_group(), when finding enough bits in block group
> bitmap, we have to back off move_len to start pos as well, otherwise it
> may corrupt filesystem.
> c) In ocfs2_ioctl_move_extents(), set me_threshold both for non-auto and
> auto defrag paths. Otherwise it will set move_max_hop to 0 and finally
> cause unexpectedly ENOSPC error.
> 
> Currently there is no tools triggering the above issues since
> defragfs.ocfs2 enables auto defrag by default. Test with manually
> changing defragfs.ocfs2 to run non auto defrag path.
> 
> Thanks,
> Joseph
> 
> 
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/move_extents.c | 24 +++++++++++++-----------
>>   1 file changed, 13 insertions(+), 11 deletions(-)
>>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
