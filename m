Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39519C05027
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Feb 2023 11:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yKfucymDP3xzCdlxKtgKGNWqtxBXzlPUwWpFmEpPhwQ=;
 b=2iwFGiakypzt1dLKpLA4jkW4T56JnmFn7DRa5nNT5WGwDgdhxRO8DzmQoU11uEFGyTQdhheqg6DY
   7tui8jhl1RQDsOOlEqvvPck9xqWiLzueVuK4E4ASbmUy4L+xXNhJAt4pZOzdFggyBUXgy9kOZep5
   o/yxZNPNQRKrnh947GVs/iAe6XjoUWJsiMJ7X8WNbzBnhEYZFwvG7DjsU2dJphJOvceKkXu2NKBA
   VopZIfXrQS83q5v+K0Co8vQ4DAgs/m/wTIxOO86a7jJ9KamMkuakNlEroWW9CZktZMrSRs7wTHUC
   seQ7CrDl1bbW7XesIFTyu8gmb5R/M7Rwn7V6aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yKfucymDP3xzCdlxKtgKGNWqtxBXzlPUwWpFmEpPhwQ=;
 b=gIFvFsE7w6Wz4RgWyBzhNnPeAZtnqEz/s05nTXClTOUYX/v5f4UhseO3yKJqj4LMJNtheogSHtX9
   Pp9dsOS73x5ifEAqFN5Wpd3B2VxoBHY4KQm+BDxzQlYBDlykwnaADfnaQrENS/uFijjFEV3uoetG
   Z5aq7Fuv3U7vNSBB6LMYa1tJPaBbWKa5eu8nFsaiVB5UZUUEQM8d9b1Nvmz889aU2v7FDKpbD1J8
   4o8nf9o6u/tuKQU67VvLWIcCx3EcJDhEO7ol632LcZBRbq7ikCBzyjKkkDSpJK20V9IXPJhxP1Ep
   ffHDHwboQGmeSLhflsRGGhfj8x1Jl4B8UeHPMA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ200FNLJHO3K80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Feb 2023 11:49:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZ2ZS3XuaZVaOe4BzFhsZO351gwAoG29HgTLuwRFylvfqqvoR43VA8ftX6h33I9OUVRrz7FcY55BdYIfumqunvkf+Nu4M0qtTu5n2HQPjLo81vBk0KTT98S/Z/FL3a1SLMaaOs3LuqpkMLIxmXsCaP2tUy0uUhLHz6N2Xv+OaVeRa9bazulwHCr3YVW8aBQyAEVtedBnmLJyO/69WIErRvP0UdthBQq8VpqvtJbSuMPyYzNr4smvNml7oxdOGXcchx88bwgQk2gZqNNUr+32MC3yPeyTvAKNI1s5ScnsurwsDB99jHwVayLUy+00suPzJ2Ol+Uho/XwBI/FOaqooxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwLTy96p5swSwSH272GduUXkr7zLdKV1kjvfNMas5/E=;
 b=a1xzOje17tgP7EwSrmMsdtKujdEqiz2Nsk9M5X+TQI6kPKX6xzLpk+gVb+8KTRV4rdnllH1HpI/OhvfRND4BcDSNsTyYaVSZ4qnvkFY0euOZdWDLJHwoThFUWVXNn1i+p/pglxv5rTltQJgGMXlSTBs605Vm5ILe0YMt0Z+S3E0UlXmHlKp+Mn20Nlk1pnGDb+TbK7QzwTKtAzZnHipQ96gQYPvmKDREltIQCrgEH/Z9LIveo37iZPHdzFNOtI9CEDcbL904p+U6MoQzeE5h1bBsJNZkaYCRAs2GYePKwAticfO2R98mJuC+oXvKaBlTVIR9l15c1icBJvDXuauKIQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwLTy96p5swSwSH272GduUXkr7zLdKV1kjvfNMas5/E=;
 b=Em9eLoTeCVCuoicrs2yIEBId2QjCS4burggmJ8vw5XyXORzoJvwB16Prfqel1KIaYYPO+EoILZxz2QdCKkOagOMWxLjIkRTpZHqoUgU+JYeMf7oYkjyiyBRzbbf8tb+WMIjRRVmbf2ku3ihLkHsg6N1tu4nH6FKdnUfHm3B0mMtyHWRpcX/35+gee5W0WjEddwVrUTi0k/3Gvpj6CVS7fil90Sm4RtODzhk83v5uz09IId9yFliICs7MbjXnNuE2mP/E10piepip0z4e+VTjje3wdb6jo8p/IMQSKz7TRwodj8EAAbbLPeJ2ZRLEncKReTG8DoI6uryoPVS6HfwQxg==
Date: Tue, 14 Feb 2023 19:48:29 +0800
To: joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com
Message-id: <20230214114829.zxemgnnb22sdba3l@c73>
References: <20230210100457.xv5wchadnd7kkazb@c73>
 <9ceabc71-5b18-5a1f-12e2-ea63aecd78e5@linux.alibaba.com>
 <20230214043344.szvhwukkdkzsky5n@c73>
 <c60fddf7-f49d-3f7c-9383-5fee2ccf7a65@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <c60fddf7-f49d-3f7c-9383-5fee2ccf7a65@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(7916004)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199018)(5660300002)(6512007)(26005)(83380400001)(186003)(44832011)(2906002)(6506007)(53546011)(1076003)(86362001)(6666004)(107886003)(478600001)(41300700001)(6486002)(9686003)(8936002)(66476007)(316002)(66946007)(66556008)(33716001)(8676002)(4326008)(38100700002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 11:48:36.4274 (UTC)
X-Source-IP: 40.107.21.71
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10620
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 clxscore=204 suspectscore=0
 mlxlogscore=736 impostorscore=0 priorityscore=192 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140101
Cc: jack@suse.com
Subject: Re: [Ocfs2-devel] discuss about jbd2 assertion in defragment path
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
X-ClientProxiedBy: SG2PR04CA0192.apcprd04.prod.outlook.com (2603:1096:4:14::30)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|PA4PR04MB8014:EE_
X-MS-Office365-Filtering-Correlation-Id: a4312c35-39e0-4feb-6215-08db0e81680e
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 OnCb9/UBvuBzKlNxgrGhTh3cFSFwLy8C0MzVTOXn8LsrKLWDlmbwEMMRT8LZWPGrMwsxx2YBUWRiwaeqy9NnRe6878BW34RsEwxygQjLpJUdtSyU4GaUQ2DwYwDCU86hoGezvwJEfDeh4IpwndJz/OhPyuQ7r4mR2AuqYp/I+LB1ttylTaF2D2wRfoA42edhpkElXvL7NAXfQL8pC3YYvwtisPgb0lLZ8Yxjzz1mWSetgDRTLFWA7GtyM82QrH7V/FWYNVm3onRJc7tgalzmnIu7aBAAfrjZ/bEg/13l11VyvnFBVsbh29BgxPx3CUqrA9NGYfX0Kn6JgbQOmIWh4Y4KKGQgdp9MtXWhlO2ZGVQORmJL0RYqC9kV1QilsPoirHafyX2DOtlNvUfCwQX1qHLy0iKdCMiz8KjPE2yfEFTa+mPrqcI8r85GMlFR/w7O9CJ/opIX1iVkHF+j7TJrS47i4tUtSz1llcCN+X64KmXF4EI/2VonA4p8ooarpigo+WKRpv2BygfNiiDUENoyC3lNEQ7ldxzCz0N8jmoHXmLpPBW8Us9xjBkoYP7lArCOIIuYgX1P57ct6hoidy7fyzJJcpHrctvL19pWlPoJKf163tNy1LboCCWzD4t/MF0MvMnaO4pDLVslDMBq3Swq3A==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?9nA+1DsXV2JcZjCRi37niU7WdZ/fCePvTR/9QWKQgynaCtXQXb5GIYc/RvmS?=
 =?us-ascii?Q?wyqsHK0O7Oauy6ZeKDpABmRmLOcmdq7cz6Foxg/ZYiHflhDkEdDmPFwIo8BL?=
 =?us-ascii?Q?sVgk7uHi1pOb2k8kdPqKcCXT338xqsveJMEuFpRHULZhVzspedXsannEqOXK?=
 =?us-ascii?Q?gatVUkNOwHbxSKcep+I85nO5Kt/QVQigTIiZWSWJNUvGxZcgYLsXUuQ5NYLO?=
 =?us-ascii?Q?YAOJqyHuX0x1k+JLjtu7PAvqodS7jIlgya7tSIb3OYLPW96fVgdMqnpTjKHH?=
 =?us-ascii?Q?MQHD5YEpcdYtqBYEPrlBYYGtCIYKl4iQu8e2B9n9TdfHp9EIIhpu5456kT5p?=
 =?us-ascii?Q?rbtWK9NbnvR+idoh0WzCmjlm532Pw5PiGYRWc9h/PA5yS/FKrkbNCZlrni59?=
 =?us-ascii?Q?/Xz/HUJn/AggJz3GYoNMdERWgWBdl/ts+nNcXxrpeNY0yH5jQ6L/JtUQTl6g?=
 =?us-ascii?Q?8KyZ2Jko81PuLLCs6s+JH+R89jyN3kkxxwMDR4HHPa2ltjk/BDQnXLFAdsQm?=
 =?us-ascii?Q?AOfTdXwUWqL/kcJP0qZyrecaGsm5ItvubMVo593uY094xzjlNJJzuarV/6pJ?=
 =?us-ascii?Q?0rIONQCPyHUI0V2BEReBgrMtnuKt7KbbEChtrJQ9SCGVynl1aG4yhp+qqfUz?=
 =?us-ascii?Q?Dc3rWIaDuyn7sHUHlNUNWsd5zIk8wkCaN3vXYcIV7VXwzoroesoVvMD8cP+c?=
 =?us-ascii?Q?8bgrcU6emiGD91OV6a4klLZflcZITro/jyMnplsPOjyDv2efcPYu2QgV7xKP?=
 =?us-ascii?Q?aajOQQz/Ls6J0r6uahHQmUVUT4oWvt2yCW0SAEefCJJL/hxotgcdkgCPjMF5?=
 =?us-ascii?Q?xZRR5zjwDeoA37ZUmlJCenrmrqKOKUG+N8eWk952HCUX1+WedYLI2FV/LMhS?=
 =?us-ascii?Q?RsGLYeGzHG3cRCwItQdEF5n1SUALovY72Q5pP8s2BH5xfpPE2MDcfw1iZpAI?=
 =?us-ascii?Q?jcvvgccFHq9im2NmJk+uPBwMYXPamYFF1kTSodz9hXUQCTD/gWrRP5C+Yt2o?=
 =?us-ascii?Q?oywnfL+5s91f4+DAAOXB07mnaMSX26OUhc1iB06r8cbCBPdgAAPPzqU2AX6l?=
 =?us-ascii?Q?lcgN0yP1G1UQLoQ5E/rD5sNe+lJ6E1RSfgi90SF2tcK4VDQxjawCBKq1pYOQ?=
 =?us-ascii?Q?lYi0C2IrI6m4/Iify5whPxkF9vxhzQ1ux/qlPVdH7M1CkwJvYFYT6sQiAHAb?=
 =?us-ascii?Q?eFWPXhlkRk40gWqpza7KV9YpCNG5GbRzw11jNcqkPVSPVtHTakSbiT1RD8bj?=
 =?us-ascii?Q?kZqKNZsukiBBE/ypdbC3Nivb1/3v9mz8R5nuEf06sQOLWgEcd04qX/oxn8VH?=
 =?us-ascii?Q?0Vk/MvEH0nq/iPLHFwxeEIvcZIdqL6u/P4T25OHuZ+LbugiOIgfx9rTGq6SA?=
 =?us-ascii?Q?l+3HmYxPQt0FD6+1mxPibU4wuIN/BLMyDhheTA5Nk5ue4vkuPX/AZTgmtp2K?=
 =?us-ascii?Q?NslBMvkFMUe1KEC6BXeWoquVtin5oCL59WeSPj7skCus/4ebsuj4pI9+XInI?=
 =?us-ascii?Q?7y8cbxhk6YZe6yXy50bJAk6inGWPwKd46GvC6o5ex/DG44d3AmdSHrM1eNfP?=
 =?us-ascii?Q?xDAuM7jFjC6jcvevKsa9eRyJP7cfIqFDxErgzJNP?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 a4312c35-39e0-4feb-6215-08db0e81680e
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 e2HNvbLtWXfF5oyMqDHcyjStpJjME6wU0Fs2LaSi87u3K3FPQpJ88I3LwImFVhH3pq0wMYhQ9X0z4ESgcKyFxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8014
X-ServerName: mail-vi1eur05on2071.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: YGVy_DIJRmbbqlnt8GXpW26AKVckV4eZ
X-Proofpoint-ORIG-GUID: YGVy_DIJRmbbqlnt8GXpW26AKVckV4eZ
Reporting-Meta:
 AAG/V2/pkIaiK0Gzo6dvzwvzRcTlBNHxUQH0sdJn00B7S7OF6UTZEqhFaXUk7jPQ
 kutO1J03/60j5uEsuDk2c3UhABMuPhb8ex3fArxA/3P6DNJoh0TsRtrsZQSFh8MT
 fZ/spawn4DvFPZpvMSpIJnkF2JElIdBLqUY8gWHCJ9jdx6BqasZBsFQOTeRsBEPw
 rD/8OyE25NLEoEq00s9OIZMN4x2Pl+phBRWrwFRkA1yzxxdsm3Qkb+xjRxI7RFkc
 m4rVeaLxT8YsZdcPefv2bD19/1uqzzbX/RSHQlChyFlL5IBi4HyYFqcSulPyUnQm
 g2XH2qZGllgGpeIYgSS9S/26p42LRvjaDpuD9CKMZGBNRRp5VlyOGtsluH5Gyhp2
 b3NQCO7ByXk8v9J81VHEvYKNqGYvVyGwVxczqn6JMYSQtndIzzoArpPImNu10yMz
 neXzZ5fOEZ/tsv6KKpONbz0bkKamDPaaFMOH8C0Qt/5KDBJ94j6jntJuskRfsSTZ
 Ut26IWHIj8erXYfOVYg8wlK25IHhT5Mk37YWgHgp+Ck=

On Tue, Feb 14, 2023 at 07:08:16PM +0800, Joseph Qi wrote:
> Hi,
> 
> On 2/14/23 12:33 PM, Heming Zhao wrote:
> > On Tue, Feb 14, 2023 at 10:52:30AM +0800, Joseph Qi wrote:
> >> Hi, Sorry about the late reply.
> >> This thread is indeed a long time ago:(
> >> It seems that I said the two ocfs2_journal_access_di() are for different
> >> buffer head. Anyway, I have to recall the discussion before and get back
> >> to you.
> >>
> > If you belive from [a] to [b.1] doesn't need any journal protection, my patch
> > makes sense from theory.
> > 
> > From code logic, if the defrag path (ocfs2_split_extent) doesn't call
> > jbd2_journal_restart(), current code is absolute correct. Increasing credits
> > can't help avoid jbd2 assert crash, but make more easily to trigger crash,
> > because it makes jbd2_journal_extend() more easily to return "status > 0". In my
> > view, the correct fix should delete the access/dirty pair and make sure the
> > ocfs2_split_extent() is journal self-service.
> > 
> > Different buffer head issue could be handled by rechecking ocfs2_split_extent(),
> > make sure all journal handle branches are correct. I already checked
> > ocfs2_split_extent, but I can't assure my eyes didn't miss any corner.
> 
> ocfs2_split_extent are not just 'read' operations, it may grow the tree,
> that's why we have to do a transaction here.

You misunderstand my meaning, my mean: from the caller __ocfs2_move_extent()
calling ocfs2_journal_access_di() (below [a]) to (before) the handling
ctxt.c_contig_type (below [b.1]) in ocfs2_split_extent, this area is purely read
operations. It's the range [ [a], [b.1]) (include [a], not include [b.1])

__ocfs2_move_extent
 + ocfs2_journal_access_di //[a]   <------+
 + ocfs2_split_extent      //[b]          | [a, b.1) area is read operations
 |  + if                   //[b.1] <------+
 |  |  A
 |  |  +---- from this line, this func starts r/w IOs & needs jbd2 operations
 |  |  
 |  |   ocfs2_replace_extent_rec()/ocfs2_split_and_insert()
 |  + else
 |      ocfs2_try_to_merge_extent ()
 |
 + ocfs2_journal_dirty     //[c]

> 
> The whole code flow:
> ocfs2_ioctl_move_extents
>   ocfs2_move_extents
>     __ocfs2_move_extents_range
>       ocfs2_defrag_extent  [1]
>         ocfs2_start_trans  [a]
>         __ocfs2_move_extent
>           ocfs2_journal_access_di
>           ocfs2_split_extent
>           ocfs2_journal_dirty
>         ocfs2_commit_trans
>       ocfs2_move_extent  [2]
>         ocfs2_start_trans
>         __ocfs2_move_extent
>           ocfs2_journal_access_di
>           ocfs2_split_extent
>           ocfs2_journal_dirty
>         ocfs2_commit_trans
>     ocfs2_start_trans  [b]
>     ocfs2_journal_access_di
>     ocfs2_journal_dirty
>     ocfs2_commit_trans
> 
> In above, [a] and [b] are different transaction start/commit pair, and
> each allocates different journal credits, even they are operate the same
> bh, they are still different operations.

I agree above writing, but it can't change my conclusion: ocfs2_split_extent()
is journal self-service.
It seems the author meaning: he wanted [a] to protect defragging actions (extents
changes), wanted [b] to protect inode ctime changes. the
ocfs2_start_trans/ocfs2_commit_trans in [a] area is necessary. but the
access/dirty pair in __ocfs2_move_extent() is potential crash risk.

> 
> My another question is, __ocfs2_move_extent will be called by both
> ocfs2_defrag_extent and ocfs2_move_extent, why this doesn't happen on the
> other path?

The reason is userspace defragfs.ocfs2 never trigger ocfs2_move_extent().
see do_file_defrag():

struct ocfs2_move_extents me = {
	.me_start = 0,
	.me_len = buf->st_size,
	.me_flags = OCFS2_MOVE_EXT_FL_AUTO_DEFRAG, //<-- It makes do_defrag becomes 1
	                                 //in kernel space __ocfs2_move_extents_range()
};

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
