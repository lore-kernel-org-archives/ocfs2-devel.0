Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BAEC77B7F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ksoE2JbYL9ZVcBnRhR988JDjEoPxJkYP784B1T1PdGM=;
 b=kKu9j7PpC5YYbF7izrK5qfR9buaRmJumw4GqmJ+DlzCLdXlDVKceMz6CaZ9Z0I5wxKPx++6U0Cod
   pc4312s3uoLb4F8+DRMNMnUPMSZa33JFcP8hkgCzXK9Z2pFUnhnYjcWDFsTm0el+ue4lu2t7env4
   zTgtdylgM9D40aqiFfU7OJQ57gXHTCztxu9tF2p4XLJqCUFUQe9g8Tbi85ypIx7MK6DwftOeKbV+
   Mla6prJ1c5UfHqGKbk4EmW7MIF2JcqkifYuapZAtLdc0XW0HSoqLs4F9qSKNdBfV+gDh45RbT/pY
   w/xHLl1/0cgpfHY4nGiJ7aSYvtlKqXmJszVH5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ksoE2JbYL9ZVcBnRhR988JDjEoPxJkYP784B1T1PdGM=;
 b=Y1WgYVOaQL1cZU+5ru4DNyVC7UkDJdDecSmFI1veHZCOpIuNj3nvex/0CbdzY4acL7dwVSFmkfCY
   wSavVIsy914EzeTDC/D/wg5f6uFPhuFXsgMMauYxq97gUJVcvmId67SK49iJkjg3XH5SMVKlFcrA
   eBzia5GJRoDupsKrxL01nF2oerMn55ev0O5iVdbg2nV+CgVgvQnKF+nOz8cKIDwIH8je5qJdVwKz
   AOCIJR7o2bYiTGqo0tiPtMqAWJeStrOBZrrsfSyQcBbW/PXxKk9XXL8wBtSVp0zbC2bF3pFFl7eX
   +q+s8nbew6J7Vz1kv1IOk3LhxXD7YbhfYHzQ7w==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00FN1M19UM20@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezbdg+W3b9vNhUcY5aduDnZEdzkxNfjiXr7xKG4kSmMj2vlvwDp/ji1vuUHDd2aYOMqfOcHcqXkaYuOMwVVSS1EtXgEIMZo0LiOjXOZDfg+Egw07wXjM3Tuti1jHfYaF4uq+VwQgFTP1urvj+Meg6iuM/2sjODm3j//laG1h6OUEdKQvPH541hzw4Q+MWiHVMy58fT6zztqCkyBzOXAV6DQCt8VE2A1wlTeQEGn/RTmQt2cXW8N2r89lzHBHuMKrrSi7YNNA1JoW9vORYLU1qZB0CM0YyBJm7J09q6TvFh0q0jMa7+BItH7X4z+FoSzXuvI3bTR19CY+SBxEuKrMRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pex9aEt2J/rXn68Q7Mhe+oUcnvnN1Kkk+C785IQtocg=;
 b=mSG3wnzLjliIU9PdHI0E19DQb7dOwzaBxQR7/GDOA8B3kQPPGUjGjclqbOuC6NYIklgtMMfq888QBRqxZrj52kN5phjKUc3tfsrPdHiJ7fLdFwcaM/k2bY8maRW6Qlwrj3Bw3FnP8znoLkHIenteNXzF/KpeXig4e39akDKq7F6WiU1jHvrNqa9jzdq+ncS/rgT+VJC47QdVFk/A6pjmyO1ONRJ69+M96lRkB1YqhTlJXVUcQZSi1Nxk2R/lq0w632jkR1ArZ6FVwg3Mvk9OrPXH5Y1I3yPElMvUWP4/iBt8Qq50V8yFFNunLL+Aqne/hDSOKD4TE9lsOybHkSqn2A==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pex9aEt2J/rXn68Q7Mhe+oUcnvnN1Kkk+C785IQtocg=;
 b=aQ33MwahQWbbBn2++ZkGngd7GAzn9+SpCsNs2abi33tNUAQq46qbaAGDPAVDsZ6slSgqcjpL5uZABFvALN3fq8IF7RjO5almr6Jv/5I3KBcmQaeOEYCYLmo6MsRBIlDGG87jzGQj6bXYFvitNcLaFQGAapgRYnEF9wJcm/RSslNxHtOlrHWGpAZstrrblQE0rKnQy1lxmBTeQnPEj4c2axJXUscY4jW0gUVYrquSw9pirtkkJH/qDW/z76DTP0uiE8+o9xmHiYDJU+Q1tFQnJ9dzTEXj4cjbfEoWeifOcYSh0uM6kZ2jPGJgmPovMwjO4wU4EaRYJjJ+Uu+B/hy6Mg==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Fri, 10 Mar 2023 14:50:34 +0800
Message-id: <20230310065034.62340-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230310040508.GN3390869@ZenIV>
References: <20230310040508.GN3390869@ZenIV>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199018)(2906002)(5660300002)(7416002)(26005)(8936002)(36756003)(66476007)(8676002)(41300700001)(66556008)(4326008)(558084003)(66946007)(316002)(86362001)(52116002)(478600001)(921005)(966005)(6486002)(38100700002)(6666004)(1076003)(38350700002)(6506007)(6512007)(186003)(2616005); DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 06:50:45.2529 (UTC)
X-Source-IP: 40.107.215.136
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 clxscore=105
 impostorscore=0 mlxlogscore=250 phishscore=0 priorityscore=218
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100052 domainage_hfrom=9103
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] erofs: convert to use i_blockmask()
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
From: Yangtao Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yangtao Li <frank.li@vivo.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR04CA0193.apcprd04.prod.outlook.com (2603:1096:4:14::31)
 To SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SEYPR06MB5327:EE_
X-MS-Office365-Filtering-Correlation-Id: 203119cc-15b1-4f75-5403-08db2133c5d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 JgJbj/huh9APjUupHDrNv+G6xx3b3bGJmK88sf3xYGB5e8nOK7WSfjJ+GTEr/gsoEFlpwXo0EK0+AdiV94/m9bIw2JGWfWKwI4zjTIy7v2LEEnSKVtrrwib7vNQHzdKSAEt4JDlip9upoF9kxt+/nYzJ9g75oPRDu4olaU7NtSU/HnYDCZ0KnibOaIqkhKcKCV2RjHl85Q72AQrZeEG1sTHEMukEtzu6g/RcObh/UFxYJfC8HaAZj/iJ5WgCUBogudchs0yBuKUqDGu9P9H3uHRMW20IXqvj3ouRxtQMOMo4QAqL63Y0YrPkvRv42WCj4AoGMI1JsI5xIUR6MY928+NW2Nw2RKNLGKqXAvr6uTx0EDKhaxN1Wt2ovpUVJ3usFdcMVG2Wno2zUQz42qZ/DSTOSRwCTaBlO1Ww67K9L6YqIU1plmF10bhVUGVHDGctWTi7C9M0dvPXehJu5ZoSbyyU27UznKEa/f9CfIu06Eu/gDDpysXnR5f+L1LT0xmgB06PF7lwOczBwWEdcCGVuHqW8VICryHP6QudTDinIXYN/HKtdClh+N0flxvvNxyOybzZvjpNkzWntja0DFOrOHxFG5f0NtwfEG9BEpiAw85UL4LbFjBl3CZ9qOgHAkq3Ga1pZ5s3qs13K+wDrw6LVLMaNRvKxCS5gQKX3h49HDjoMSk4eF0ye3WTPWe2+iEao20pshGj+mKbbmKYlL3CDw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?I6Vq5WUZhkZFCYCL6wFKVPQhhOoRsvYiiu9qvv0ekAqFgXpvKw59OjYKykI/?=
 =?us-ascii?Q?dIZ9VT5TJCkR3uHr1lfoFZgxcPgR2YwUcR38Xjmcb2Niqgn09j4bznyNcqRF?=
 =?us-ascii?Q?aJnobe/5Kdz2YNjIy5xKN/TSKyhUBQFQeanWatH0TKeb+RgTK5czo/PDPB6J?=
 =?us-ascii?Q?e02rednEDTX01XjU8Di1U9vA+PElbY6yngSM7SL8LhaIich+1K3x9a6Gy0Sh?=
 =?us-ascii?Q?wDXcQLkNLpy8ROzfXkl9ndni8UNHY11P9A5KtvaB+mXniiyw3m9Mc8sIiT2I?=
 =?us-ascii?Q?o/Lxpq+U7OugrQGspV8snqUx3wpKHW9ibaOllwCaXHctqTLF31Y+a+oQIVkO?=
 =?us-ascii?Q?iZZ5yX9M2F4nbFducQcMGxoj5cv7vMT306NHH5Y2xmR170A8jgsIJO6nTF/C?=
 =?us-ascii?Q?8MdUCkLqDoNAP7LQaHI4agkNUwV3rXgkjhx147otDxxMgewonFuk6YSXRlab?=
 =?us-ascii?Q?ylC1yFV1juolTFk9tjqeTTJ4LyQ0PnLKEyvr5CPpaIzESYViZT0TGmgkuS/m?=
 =?us-ascii?Q?CNnUJ3Zmpu9EXFD671x+E77qY4XUH9E0+Dvf2RhTtChdBzPzQjCR9el3QOBf?=
 =?us-ascii?Q?RaWAthdU5PXwcQmpjKnXPMPmz12/3P6l0XoNhoMzhrz+kQ/8Tg7SbMrpDTW0?=
 =?us-ascii?Q?h8Wejyx+dvkJ199P85Ngk+RWm9eaQEL0s1XrnQEJQZXReK+FB2sgAhOrGxy3?=
 =?us-ascii?Q?Lm36yLZqvZC+J25+7evH2qpMBxKj4OAswOT+KdpCVehce7/Ha8c//09rEBy4?=
 =?us-ascii?Q?nB5dYQVAOs16vj0QfZutcBw3Kjt1nsrAylCoRELEMA/50gUDgcWonlQAN6DE?=
 =?us-ascii?Q?mvKsOAs6dWVq2B+JI+nVqF+t3lFMuRfJubT7EMNZr4lbEwbJ6M+2xzGUC1c9?=
 =?us-ascii?Q?XooEDUX0w1ZUmBQZwGAyty9lwYrwvAd7Rpz+Goyal+fmyyx6BIbEHo6uxqyr?=
 =?us-ascii?Q?QgtqiAs4qlewCr0Uksjvv512cd4Zdrr8hBPXvFe7U4cPOn5FIZDFg0GZd6Uf?=
 =?us-ascii?Q?jq1KYqLbnvJyVC5vIio6bBrXxJo/WB1B6De8kw+9B2GydAviWw95vggiOcNl?=
 =?us-ascii?Q?3SeJVzIQGvz5ysGB6CX8rNALrHPONr3PLn++AgE5mPwdi2sFu4Ucqt/0q+vP?=
 =?us-ascii?Q?R+WAo1Y5fPTWOAh5/C5zo5Ex+6br6toXA4+zQHP8N7Bx3AqOALvZroXs5x/9?=
 =?us-ascii?Q?/GqCS5emv1aH9exuSXBnRG3ePep4bDSOLvLf/qKzBTmVBvrDikFz0zvQlzFL?=
 =?us-ascii?Q?j5z37DiH6BOcJfGSfrBQFaIuiZUxgTGduMfujpcd2jN9b0GxAVlY4IoILvx8?=
 =?us-ascii?Q?ppP3PwoqahMJBnvjHkvWSwaGl340b88fwBn/5j+fDwGj8BKvSf1l86wbTpJR?=
 =?us-ascii?Q?J/1xRW0v8jV4oRTSdYxBp3uBtYIqNFnGVVQK9OT88eeqmMyWFoVo0rnGlRBH?=
 =?us-ascii?Q?OOuKZbmIRFP/smp32LI5eO8GdT6V7OtpbA3GfWs9Q/Y13FqUtNRWXm2Bs8ni?=
 =?us-ascii?Q?hJwRLT7++A18wofqK+ml4OX6ykhdMOVs0nTbkFztDEIMrjOgngR4E93HS/LP?=
 =?us-ascii?Q?uAqMZkToYtDNPgGQuV14kMeKXhdRzI5opia3Y+kz?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 203119cc-15b1-4f75-5403-08db2133c5d1
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 /Q0ck/xcFXaRje+KC1xWYIwFMs8gx5V3IcVYhhp2PWIritf1xxrCfwe5WtKAZkqjSAVMxDWvxR5DXfmyxXOYlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5327
X-ServerName: mail-sgaapc01on2136.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: jrAbIkg-gmTyP7PuZiduSIZBDb1h1E5E
X-Proofpoint-ORIG-GUID: jrAbIkg-gmTyP7PuZiduSIZBDb1h1E5E
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAGJSUENx/Gn6GTccNnQXmaUgkQeoi65ztZRbNZLHi2Lm6virr1aa7kFRthQfKri
 8RUWWU12F5NJ9Dk/Opc98FVL0RKAxUsFeWReb5GAvxSmiP7fl64e2mdXK+I4xKjv
 dA03iGcpxfDj1z0GfqiS/3QdNipWV3BDMxZHrewrnSncqMmorD5TZRQFvMtQeNZM
 V62yCvlQwpA39xOFzafWxNb+uIT5h0SsBlC+xRQHvbwf2AKl9pjaZZJXvLRsIIYO
 HN2hL1H8vneX8L2wMyfm/jrOxRyfI4Vjp3UuQemfxpa6XM/SocYrfhwufxi4V5oO
 KX5Z60es4/bIWOKdN90aFqNskHCG7Cs9f47kIT3E5PfP9xsCKvcndAt656b/p65g
 uNW6tZmfnS9jjni7uGR98jjExlpso53jFgfNjyvWmdi9CLrEtRMlNzYTDnzQjR4S
 e8cs/MRSvHUwPZow0VYlO8/WR9LN8elXJEx3AUS53yPi/XKMfv9SFUUPYTjFarKn
 sLpkiITt9iJVKsBd8x05c3ivZuFHZFS8u4zNEyr6M8fi

> I can pick the stuff in the areas that don't have active development.

Could you please consider helping to pick this
patch("ecryptfs: make splice write available again")?
ecryptfs seems to be unmaintained.

https://lore.kernel.org/lkml/20220831033505.23178-1-frank.li@vivo.com/

Thx,
Yangtao

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
