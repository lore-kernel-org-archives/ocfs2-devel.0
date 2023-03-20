Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BAAC761AF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=M+/weKnKVyFdZ3Mp4ZbjMRtMFY3tfDIDyxOqes3npfc=;
 b=N1YcqRcG5qXlYjGOCLYxupqFMm6OtGAf5x4nNmKXdOdX7l4qbVfjH4u735WR238vmm+gcnkeK/Ho
   BhujSsC+RT0AdpewwNv7Wlr//adnNnqYsF2tgCWohdKytOmOekLVlL98wGvlS45n8FLnTQVxv8LG
   OeBJ+czL7ho6J66vEtSkP9xvMsKbxEOErA/XpPnI00Iii5sv+wCpa1EVurc5iZTwsWLg85tjsnBB
   e9R8unMVoPQw+RESAfMoFv4LICG7sNpFMzXc6vr3G+48hFeGyCPnam0MtIv02YLOBEsPXAuWYC6y
   4h+oTnGxUPt016VhLx7XlFUPMfYXg8vdqGdPlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=M+/weKnKVyFdZ3Mp4ZbjMRtMFY3tfDIDyxOqes3npfc=;
 b=T0iuRu/cens0jSJcVd3o0Vp0Wt3qZsLnU6VB5U0Ppzt1lsnIFgNWHBF4mHkEoFNF4rAsuan+p0xx
   UDcLbNm97r20fotptpCDPEb0xBibBzGTUsRfVWTw6IP38hmtg65ifT1TV0+e6ehjZ2iHJ8u/lSBE
   e0gtJ2M0XLcBl+oAdCYdlM2buU+xWopLjik7qnDwp3NRASifvgVZg8IQOeeZb3NzMb4NmlFbYdxz
   v85mSzw94pElIZkhIW6Mq8U59BIwZNqC88BuYVAwBbvEdpRZFaWcsija75AfRxIkeTo+e8TfuPR0
   kSve/hHf6pqyVFPqzNVZR8zdI8EXeWPtEwYWPQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00KG1M191T20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEhCxh8D02rcHC6dO7kSOfQ+AGgqO7UxxE69tDyIm4Tqs3aweJ2dCq3UPkCLzV1UZ4dCLggR86K54XogG9H75P/5oJbWN3Ba6Wj3cGM6kQ42z+B4bFqJ7+nT4QasBoWWWNjZVEgCadrqhLpDCGGlApiRTNukDbmIEwtYHlHziyn3tLOFMVSeP4xPlntuwMq1LzzQfOpwWSp56AJ/ohgpVKYqPnOHJZjrgFkkxoNC7gV68ucQZxKEnI+wUcVzya47akjjoTVLURODESNAW7SDu5/xOkqEZJi8jBA7od1DMqCyN/EIGgQKBjL4MJQ97gRM9taOqDh8vMOb4eA3AmXF3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcSocjSGVTF5aPxsLKaFBjySrnM82IY/w/dRKgIVLtQ=;
 b=gry7E8prSKnGmd/mnLmfUklTMk8F8AMmcWZqTtxEv2Grerwl0LY4m7aQ6ZY5ZkwGG4gRAE87lSYHjrqeNyYtyMMWY8RnHLmkE75DsqpKupAdGopskoG76nqzkrtz1G38ewu490FMsWiNviE+Mk4nNrf7EcETDNPLPwiNMaRJrXZWNSPW5QzWZBB2BJ8FpGyc8eJB9nXNOu6b0+JijkLVRSEDCQx8wbW95+aqN0L19GMhgUvlAVBizJbsGCG0og+du33uwgxtamFzQrDsjzPYZfXOjIXMO5IZpGDVHxDa2tNSRVrmGfcOCG1ZSFlZ/UNoNdq4D/Uj1QqgWxdM/XkWCg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcSocjSGVTF5aPxsLKaFBjySrnM82IY/w/dRKgIVLtQ=;
 b=AJe7Jj4ygTrfHsWmTT4gnppAGvUAtxhf60mNZ9snE2grxP1YAVIKUBTbJ/FhJ5/07pv8NeiaL6A0EZa+g5rqelTm3a0QrRsAiby1xgmZIMDm2bFMzFic3A4Ap5WaN/3eXitQCTaKrI5A+3QSsXTbt2M68c4+uZktefL9Z3fLqeW6/lu+5gysxjGPeHLC9oRgqOFrQBpJs4tJfyf6Rq2xGn1cu82nJjuy1FyxVvwVKYWDfDDhttvFoqM+VaHI1Wg1Z76w3xT8mXwPlMgZYh/Mo3P96N+cvuT2fYhTrbVfImLo75Husxpwqnv7+ngdcX8cHu+TQp/EiAT08AePZWmV1Q==
To: clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, xiang@kernel.org,
 chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com,
 jaegeuk@kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org,
 konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org,
 damien.lemoal@opensource.wdc.com, naohiro.aota@wdc.com, jth@kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org
Date: Mon, 20 Mar 2023 11:34:36 +0800
Message-id: <20230320033436.71982-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(316002)(86362001)(83380400001)(36756003)(186003)(6512007)(41300700001)(26005)(1076003)(6506007)(2906002)(8936002)(66556008)(4326008)(8676002)(66946007)(66476007)(2616005)(6666004)(4744005)(38350700002)(38100700002)(966005)(6486002)(52116002)(5660300002)(921005)(7416002)(7406005)(478600001); DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 03:34:48.1827 (UTC)
X-Source-IP: 40.107.117.125
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=8 impostorscore=0
 lowpriorityscore=0 spamscore=8 suspectscore=0 adultscore=0 clxscore=106
 malwarescore=0 phishscore=0 priorityscore=191 mlxscore=8 bulkscore=0
 mlxlogscore=106 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200030 domainage_hfrom=9113
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2,
	RESEND 01/10] kobject: introduce kobject_del_and_put()
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
X-ClientProxiedBy: SI2PR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:4:197::11) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|TY0PR06MB5332:EE_
X-MS-Office365-Filtering-Correlation-Id: f751e256-4fc1-47fb-8f9e-08db28f40e26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 wKv53Xg11R61xkWPk5mnClQ8de5hrpPWB8AtDbwQpOKWpR4TXtFRutbBhVfXYH4DJ/Fn7Uc+kee0v3FfsmfoCGKYw5Dqn7O6Cl7WWRXXfYDhl7o5kGtWqGOIfdSt+2RJPg1iUeifueBc3OlZb0UF7GUrerp95f10B5uwqhHFdR/BMn+HsajL11VjH0aY7jZ6ApJOC7NDOChCoO53Fkf1afmcztY5g+7L0qfc2lffod92lIaWCBcd6xqLok7w6Otx21yGeuY8ujiXBKEV5IqEisg7MqgpkDacRtRk0i6ZRWpZoZDGaeSU0S/Im1JXWfsifOgwoVfjS+olFjwJyhx6V/RZw8TJZJxJFhgRZemJjDpYSqGe0j1QtO971xFWo7GA34jPFEzG2M63xnpXCtnucsOGdijZDAU8CdD/1C7tbB8Al+Z7JJHoR+3wAp9DITt6TVM0hSrddjGTz702PBOIzx0pik7kONo8x+qeadcN6AGfbQ9aRyv1h1gG+xIyoB3EuP8LsinkxT3gLiJ3qoju+Ss23clyia7rf78Q03tj6wErySRJGfo/P8QikEvF1C8YbVqC4FfTu/1OJtXCSXj8ZDaKM7IhDERccfaehkWxuep3cqtzu0MgkpZy9UvFsNbEylkeKRo+UgjCle131FWoQ1yQWA/HQIWtJQvUIF2NK3Jj265bMqBRoDaFBefcMI/Hdcy3NsEuFV8xo719E0d9Yw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?bOVviU4OLZJXsyvg+Cb0Zd596sZD6jRFwETNbK1ENMei6KQLqPYkZn/LWAod?=
 =?us-ascii?Q?LFlYVQLzwo8ZkahzIgB9vkOYF9xWmlRxFJ6XRH2kCXHb5W0cm69FKoIB+IpQ?=
 =?us-ascii?Q?GHjuHbM7LAdvFXK26er7Ca4bPDbl/fCXddz5xckZu+/WFjvozf45clS3WlSQ?=
 =?us-ascii?Q?ZpTnah+B0wvHpxem+IYteQU0SwUGQfpEMRtOYbLyL6qAgF6uLWLyzt3756EQ?=
 =?us-ascii?Q?FMIZQ1qa4D2vFqz9IVIxtbu2KR+MUeiWandNIubSwD90yNIXSSPL3CRR7Kt2?=
 =?us-ascii?Q?UusFHeFqL2ZqdQGEkGmZPlhRFz0l4LaZKOgmzaiz2TvXy48bsydY5EoVC1Bx?=
 =?us-ascii?Q?c/9c8/gnepgZqLafuQ25SMlRkyINhLjju/CkTzLmJSFyWvVNr2CF4s+aj2v9?=
 =?us-ascii?Q?PTk/sv1C5pG0j+pHmx3vYdG+18eu/36mz1+MLUjt7KzrRTi58NncC2+0JTEZ?=
 =?us-ascii?Q?PLSdCL4Cp5NM77atOMH9fsIM3/VVz0sKqV2ICmanDVZI6ytbpObbBGU+bLhL?=
 =?us-ascii?Q?7SQy5atPh09G6KyykYMqyvIBWdB3T59fR+d97iAgPvGwCNBrSCehASBAcpmD?=
 =?us-ascii?Q?IqeJ59M2DWghrEpHRvyxap0VLXHY8N3f2BfUqq2NAXx3FjCAAUwasD2OWQNR?=
 =?us-ascii?Q?oP/b+x/deMyJcfGccGjtfBicWhArQgNBFT+kaRIfqNEiDIHFDUvMgb0ocERb?=
 =?us-ascii?Q?vdVbavspQUeeN9J/Og0talyjCFHNaJ75gQfz0MBvb7FXZjgPDRkHQGV3NoWG?=
 =?us-ascii?Q?R6zd4sJkyhgSHp5DghjArtkDyVPb3W1TOhcMMpQN0DrG/q7laXgKYHBB8Gs+?=
 =?us-ascii?Q?1xjv12UqQQBnOaXb8rmN4ltbQuDzHAiwlWVkvOCnN7XF9Q6ATwIHwPaIIHgJ?=
 =?us-ascii?Q?9c8obY9R+9cJAlZNFLWbXZgMr3ubMCyUooH16xG8yMoUPguLfy27PgiEsX2E?=
 =?us-ascii?Q?4CABBhAlb47zI9UEmWX3c6qoV9H1Z9c6ImmtB4G/qVGAXiYTv75Oni4VLOw0?=
 =?us-ascii?Q?Rn1MVMpc0uemHzcJ8QsYiKJOw1u1jI98d3H4l7qKiK2tqedbEBoe0z3nLiZC?=
 =?us-ascii?Q?RIOuLg9i55zHr3Z5ADGDOuigyjPSsWkEKqtjIOmUHU82tp9MUVDyowDA4AsN?=
 =?us-ascii?Q?TkTFLvQlKbg9lLVCQ0YkuSJT1fL78Zrjs1VmyVN+OLFbpZucVKY7vSOugBvJ?=
 =?us-ascii?Q?DUQ80xXsUOiY2Prv9xt1L/p3L5A1Dkdegk+hytx9NAp86EavEZjmahLYZdHX?=
 =?us-ascii?Q?VDyaqIWm2Wj7xIO05JdwEiKk8aNnXlaAPklbsh0b86kGhRJ2Or3S8d1SfEKz?=
 =?us-ascii?Q?4Llmo3ydrxoXnM92o+riWRsOUoQxo4kyFK/cUTbYeUl2KluYmYBo3hwoyG2N?=
 =?us-ascii?Q?MNy+uxpZ5Mr7yp2cP9iA+irRpXiQSu9n1LY9SI6PENKCAO8/XgjsK2/K+Oqs?=
 =?us-ascii?Q?d61g+cMbVL5QdiYE1PxJz8xlMBFO1y3LYZymTzbyfVvuzpwOug/UAd9y+85I?=
 =?us-ascii?Q?4Oo9UrWozu5FOUmkgGxE3a9SDmgtwR1haH2DcGDVSqtZbM8YJTcSv3otjWoe?=
 =?us-ascii?Q?plFj9G8asOeg74gqs1ExMB/ErjQMGIVhsm0uOCwr?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f751e256-4fc1-47fb-8f9e-08db28f40e26
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 ERXWBy66ojC7BGjyoEPIS3BCt+Up0pT8AUuN8PWEg2BC2RV9hvUWam5vNjfOSBOyJhCm7utXsOgYJTYwzm48HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5332
X-ServerName: mail-tyzapc01on2125.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: RmT0Kgu9q_OQMij6e_J-6Avivqr8EA5a
X-Proofpoint-GUID: RmT0Kgu9q_OQMij6e_J-6Avivqr8EA5a
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAG3wcyqsF4lCeJdoz6b3Xr4ab9afnh5FvFBqIm2FcJJnNLCLkswR9vlVcHpf6aO
 Ma1mv5KA7PLzLx01gCOvaVIPsHdkUMzNlAHBlWo8tvTp4F2NpY4iY2WQWFPDnwQL
 GHoaVIfH00L9oYdNjhi4oHmlODfbwgf/5MY42PaeLCLP+2ztogYERlK0wumOgfgq
 5xRqEzKAALMk130e6hkVBemaU1J3+WTPmBPH6cufcqgaWK+8LfcZXvAn04fYnkFh
 JFLK1sHmD5krR1psgzrOAZ7Ul9XCfGVxX7hcg5VMRscRAkNHjeSO4gNHDWyD5cAB
 Q9hYVpMMN5OC5FK+asD3GIwq8KYfIgnb+Od4LiGGBnjMPZXQT2pBrlyHWkrjN/RY
 Oh66wmZPbuwOJdV489f0K82uO7DCnF5CC/cIGFr075W3vMYbwY3uVoVXj3ylw+WO
 ZU9wD3Zco7dt9jCigpFtaEEosA7qZebgPRk+S+hQ5EfhKAzvE21WBaD7Iysjny40
 PSDUBfwbrjpefaIJBvxAeS4QCEVTaMwK8xq/f0LqjDNWNA==

Hi all,

Out of consideration for minimizing disruption, I did not send the
patchset to everyone. However, it seems that my consideration was
unnecessary, so I CC'd everyone on the first patch. If you would
like to see the entire patchset, you can access it at this address.

https://lore.kernel.org/lkml/20230319092641.41917-1-frank.li@vivo.com/

Thx,
Yangtao

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
