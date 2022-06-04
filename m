Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157DFC433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat,  4 Jun 2022 00:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wC1my/eNVIvVnmuo6pBn3qvM8LWSmloqyR//Zmo/cPM=;
 b=RAh57NUDGpKh9PA3X7QewUQ3p8IWj5YuvVuDMKsu+13AbjGKKpVdoSCEI5g1qKfYL0LcMDB9BRN+
   ncNTeHO6lUBMFKRsbxbiDV7/atafRupviOGt8FyG89RicLDCaZrpRL9HKA1tGT7wZ6IKUNda7r1y
   PziUclU0aRp75RrGlHY2ucXKr7RgZT1WCXOsnhkJgygL1ZGor3mUjjAvF642NaM9jZKyfR61nwaG
   8SvH50RXeWQL7XJ+ORu9UuaSEUEAK36QOrtIkMhC2hOeW8UqlwDefz7bWx09w3g7QPQ2JoQWBsh/
   q2/qcSvY8YXTvL4vcQdmbrBqxw1V0OQ2r3+vAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wC1my/eNVIvVnmuo6pBn3qvM8LWSmloqyR//Zmo/cPM=;
 b=ZgZMWD9rtGmLTiXtEAsbe/Ks2vyXh/N9lEc+vqTm7PcWjkkYXxluWyVwClALtSwNqA2cssraK6vX
   mahpJP/5XeU1GzBy//cMD9MG8HML9Uf0Uo9n7uZfo5ZJReXxIZMOB2/xVq4JCToyM4LM+uM/eRr1
   5qD1D522a8xvtUDCP/wT2iYCtfl6lZQ5r1oUXHA9XHJesFQ9ZtWe1B+t0yTs0sPJ8FTc7iZ6z1QM
   YA5w6EmJZeATQbYqozX1DSkwGdwsbFEjBiPQrv8apQjivF5Wci0GaKfdOtJSu40wMW5EQ6EAGm9g
   zmTn5kT8GoIHyyZDIqfm9l7/MXDl89UIJffQDw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCX006KFF2YDSE0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 04 Jun 2022 00:08:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654301322;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Uv9lXWioHetOt5Nlr5XjM1L3lqi+wz37gEnfW8QOLIU=;
 b=lDUcdAbcDeeNBCBT/U/QykyoO4tKAYMFLmvWxz96AiFA6u4iVZIad1e/LkVjInT0lryzxd
 DRGtAxKX897mJSTC0KjVIkeDiqQH2YvCMVCEgq1f4oXp4rggog8PwWISdMLROiEUJI9VzB
 bCeBqHlMybrLjk36pUSvvySue8j/JCc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rqf5lfI0J8mnEkxfGSoLgaNyBEog68EvUft/IM+O8HCQxcpk9H8Ar2ymewI4d2e8YaSG3btOFcT9fiK1t8C2cPKiNr17qoBHsXBsWhUA+LB4f1LqZplZveyAdsLraENmjx2y1odaGuZdGpeF4kVyFU/7NvrGQXmye1McFjBXFqS79b4HQm3rAvBpcHCc0v5qFmFLKqDf6eM5v5cIwYByvDjWfLEwR8KMtUe6h8aAckFg8l67S2un4mXpKIt6lrflhauRdesmPl/QEnWw+w6+a5dCtw1pyZTbM+3XtJuAYwApJXoGvowvbIx5w+RFHyOEAxEp/fv4lPhgT17grYU8/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uv9lXWioHetOt5Nlr5XjM1L3lqi+wz37gEnfW8QOLIU=;
 b=QoV5hVKcK3ZVOyMt8Z6AdPeD1oIcA9fxfUz3+sMOiLEtKDQ2j4Fa3Xhc3l2wbCsHEG6GND9rN3Q1Tyojz5IQE3ePKD2jYkJmrbti3tqglS86hUag6+0hGorhBNtrRQdbKPSYfx9foSMbmMtw/Rsq3qReeRDQ3PoJWn+6TOJ1cFnC97aTYTide8hqIvcnwt+ICZ+Lc8p2vAKESVbFyk98MVWwhcwSRvcy4fwD56mstD7ryGASy63BMc/sqUjaOjxOQqy7rWdqP5iQDqHqLwAs3dH2b4WtgZtxsCeBkT/Rlfb5f7FCcZNWhEimJzM6D1qimNCJOeTteQ2T58qI2SE+Zw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Date: Sat, 4 Jun 2022 08:08:28 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
Message-id: <20220604000828.2b3arxq6txtq22d4@c73>
References: <20220521101416.29793-1-heming.zhao@suse.com>
 <b68e3888-9820-e065-239d-f8c8bb9564f9@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <b68e3888-9820-e065-239d-f8c8bb9564f9@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(7916004)(366004)(5660300002)(1076003)(2906002)(53546011)(186003)(6506007)(8936002)(6666004)(33716001)(316002)(86362001)(38100700002)(508600001)(6486002)(6512007)(66476007)(66946007)(66556008)(26005)(9686003)(83380400001)(44832011)(8676002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 00:08:39.6154 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10367
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=976 priorityscore=134 mlxscore=0
 clxscore=241 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030094
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix jbd2 assertion in	defragment
 path
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
X-MC-Unique: __5oO7JSPvClMshzozvkpA-1
X-ClientProxiedBy: SG2PR02CA0121.apcprd02.prod.outlook.com
 (2603:1096:4:188::21) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dafb5778-d949-4c7b-50ff-08da45be60b2
X-MS-TrafficTypeDiagnostic: DB8PR04MB5609:EE_
X-Microsoft-Antispam-PRVS:
 <DB8PR04MB560957F2B99CDA5406B09EAD97A09@DB8PR04MB5609.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 VR0/nhGzfWBqX52ouZjxmeFyhpxT/QFxjSf4FhOxF898JMRgXENkyZN+8CitWhT2Q6+kJVQrvkm1royfkI5i1SGQuUX6sRuhLqB+honPuIparzdBQW8tRZZGlN6eD4tA58w56JIZUskl5rRT6Y9DpBTzppVeEj49QnQA/lfYFZ/jZm0I2TQb3MKXjyg3oTFO+npbXF0dLn4k6f2R1BBfVKc/k6BY/mWQ3RmjWKm07JMpJioJfbSbZ7vkuGF1P3tc5k3zct2ZRaI1fQXzui8BtAN8e6xd2Zg8iX9RpPfNjg33Lrgs1npCyWLXub2xH4tQeONx/tqy+0GoPrmL2XP1rR11evBdfi9dHRbuTQFYbQf4e2MVGOC//aJ0H94jzOm6Mi0uV6sZQIt1z8eC+NnCjAFWgx4frwrbjAUCgbkqbLZEJeheBBy/HhR76bzMYMjWhuVf3tG8xvyHnTasRKnjRKiaxr32U/wiRF92KXySqnoqJpI+qq2ECWjaS0988GNJ+pp0+v3ygCJ7OXW8oTYxVB32kLYRIBR7FkiIF37EFHriaEJlerUYfu5OyASWsbrP9e5t/tPbMjW+J8a1b1eBjzrtpcHM1A/wT/GDcWZLUcyyN5Eqc5qcDuCCOp24EgclshQCrITw+4AROZ5/2o+BzQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?LST+oPWzkCp2dNA1Iuc7qHNKkMW8blca2r+58PaanRPAQJm01GE4MgKV7hh/?=
 =?us-ascii?Q?mDgPIhpPbZgYLAPBXQe9w8Qxbam8UFwqmyFg+162S4xKeFDuYGQVdspILA/M?=
 =?us-ascii?Q?oqeBPn9IOHaO391T3KwTyESqV3Is/MiBT0hzznGzpkd84auXXeDRR7NsdLNT?=
 =?us-ascii?Q?VXJWv2+hKowYo1IVDI2GKjFVHaatTHBPFqQ6WrtfIBcx5m2QPXwysvsca9X5?=
 =?us-ascii?Q?+hqEoHdExI3uPukD2y+lW/+NrrBAq56PFg6R79F1GGyiWukbOLsHbUO9NMdu?=
 =?us-ascii?Q?/R+eBLzPLplmL+c+zUoEKR1rpR5t7rnRG+GooCRWKzhA1rgM6RtFiNr9f4MI?=
 =?us-ascii?Q?TFjo8/rD7flYjiZ67+y6VYPWha/HYcTkW1r0z1X7i1IYrX7qG57UzATgIRS/?=
 =?us-ascii?Q?HwBHVlfhaBhnjh13fUWBAuWXbo1fTRfhebjaxFSX9Cq1aYDLFEvO6tkHdZH6?=
 =?us-ascii?Q?U5sTzSNk7xvgqvDeDAtmWM3TGjao5L1LFPopcSa808u2MYzV10Xtxq6THF2W?=
 =?us-ascii?Q?f7wI2SpRA/hzcCTXUIrBn7+kUy3wyQUAHh9CtAHVhHxxV/oVgJVW9NFNaIhs?=
 =?us-ascii?Q?ipDbJEQIyf1FIiw2q7KdLIu7SKySsn4fMSkUvfRiv6yZ2KYdi/Y8eIIJ8Ytl?=
 =?us-ascii?Q?Fo0YT8XWrUI19v4Ge9q3YOHjxqk9b+6wvRixNG8rFfGRmxcFziInCl8Q6m+F?=
 =?us-ascii?Q?HgqVi2Sy5cRQi8RwOLpETDzLO1kDZQeYwYgO7DrzZ4YAFUO/3MujYS0L7bXr?=
 =?us-ascii?Q?72udpNxz225TA21epSP25M/2mbXahjQJyvlzguURsbyaB8elh4nQYswUDsv1?=
 =?us-ascii?Q?BVbqaHfT99IKO/T8UBVmuHHRsPV9kjANJhyDX/9zcUm333AB7YVqVbRDydwE?=
 =?us-ascii?Q?AlUupdF/0ItotVNiMi3PRsmWtanS6t+TF/BG/VsBgCJtmJDBnss+6U7EOEXY?=
 =?us-ascii?Q?sd0Jpohq4TkegTE/Dl2LZO2NldJhCk4s3Wl0fzJpMxlasEWRKwJtSZI2vULJ?=
 =?us-ascii?Q?2UOikvcYh/ilY74Z5qY5fbgcFzdYRtEg4SEKpdQEYbVHyHLLqZkO4hwBusG+?=
 =?us-ascii?Q?Y8mvCzai75yZPOlyXQHbB3sbv3QjDsWEzDWLuH5NpHRBO4/FweUesL8/txYQ?=
 =?us-ascii?Q?okgWv9qoSms5HFuWiqgOsEFES+cCdaXPVdgB804R28MCHvqEBWDjS/Kv+HSf?=
 =?us-ascii?Q?cGUPxuaSVJwQUQkp8XugE7zt2pmRdfuV91d7yx6UhGaFGueOkKjGeIrx7xSW?=
 =?us-ascii?Q?W61Q+WraFhwwRa7kTYzjFuxR/ksAaoY8sbdiPrXQSbVuuERVKSRKZur6hDh+?=
 =?us-ascii?Q?mZBet69kEiaqjYfXQiB2cJlpRudVhuHmqyDc7aYleDiXwqvkaIIH3obwFxH/?=
 =?us-ascii?Q?EgtGZ+2YhUS4wqyV/SixOGIfyXoFmuzq/RuzUn12k/zUrbv0EOGeU4diDUUs?=
 =?us-ascii?Q?tiBIREP3nSLrXU92FaSu53oAFknLGrrYk8/r+AoW51ObEARa4nGLAQ4YZGwq?=
 =?us-ascii?Q?UfRz58UYeJ3cFCRGXnVd5pXtw3rpKcVqfLoBE+amL3UbV2lir+ScEqTUsnSo?=
 =?us-ascii?Q?rcUrxMKRCVlCCRGTDK7cMxP7dPbz5I+gy/P67Ud5TfdcrxWTdk7kchx7MXe6?=
 =?us-ascii?Q?FRS6z5snN64IIcIcHlCH9nWQNYIU7oOFqk+4YLdXXLlWOSuPujBSkjS1ocSc?=
 =?us-ascii?Q?jpZYJzDxS7kEB/PqPXPz44ccAkC1te0cgxcTNpLVtrW1q1KetpwGDvL44NxD?=
 =?us-ascii?Q?x/FFgswnzA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 dafb5778-d949-4c7b-50ff-08da45be60b2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 OLtXAxVI+VYT8V8kwr9Cx+xS/WzqUSkfWd9cgouBxB2rn7/g/GbUiyUxwv0rWEuOYjwx3AJAuzDp/1PGmvhAdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5609
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: of6AsTys9iUQZAq6rNT-JBrUJFlzTObb
X-Proofpoint-ORIG-GUID: of6AsTys9iUQZAq6rNT-JBrUJFlzTObb
Reporting-Meta:
 AAGEAS/XZsIin1cX+feC6FtDQN129WEmXGudlmjzu7Zh1oVW1Oty5I2kwT+aJp8x
 w8N9HSGYMEAA1HjX1Mb055vR+OJkfVngLrF2RdB42rXJS3LPi9xD3KSZESew7Loy
 iMra16z/inpmn9zeSYMtDD4qoANQrGXNNtf9hlYKbSKAC36o45L7zYoGUr7fBoj4
 Dsvo5l/c8tiwgy/ZfB2D6JOiOQfPg4joUZbySCbYvKpuvXMip8Pk2tYP7rOV7LxO
 Tq7vmpCWjHtgDFgop3E+ZIfqDZoEf/DFTrHOGbDVXTzJvlIMeTRFc04uYSyPggfU
 rLaJ8Y+vCUsjad/ZYyWu/JjJGUL82zg8BS3Xc31rj8xZtBrjnEBRDfSwUJYbBdh1
 +Itt2/SOgxOEe6KGQ4+r0Np+0+TUwv38UbRoU2rKtAkQERQXwcDjhNxKY2cjylVi
 MQwQww00UX9bDED8/3dqeZDGY9Q6U4DahifKNJTEQeExFKDtbK/gnRJiO2uDzYia
 uQQD82jscmxiKg/UHptxqvczbm2Bwmt6ZJx6R3qp+vg=

On Thu, Jun 02, 2022 at 05:34:18PM +0800, Joseph Qi wrote:
> Hi,
> 
> Sorry for the late response since I was busy on other things...
> 
> On 5/21/22 6:14 PM, Heming Zhao wrote:
> > defragfs triggered jbd2 report ASSERT when working.
> > 
> > code path:
> > 
> > ocfs2_ioctl_move_extents
> >  ocfs2_move_extents
> >   __ocfs2_move_extents_range
> >    ocfs2_defrag_extent
> >     __ocfs2_move_extent
> >      + ocfs2_journal_access_di
> >      + ocfs2_split_extent  //[1]
> >      + ocfs2_journal_dirty //crash
> > 
> > [1]: ocfs2_split_extent called ocfs2_extend_trans, which committed
> > dirty buffers then restarted the transaction. The changed transaction
> > triggered jbd2 ASSERT.
> > 
> > crash stacks:
> > 
> > PID: 11297  TASK: ffff974a676dcd00  CPU: 67  COMMAND: "defragfs.ocfs2"
> >  #0 [ffffb25d8dad3900] machine_kexec at ffffffff8386fe01
> >  #1 [ffffb25d8dad3958] __crash_kexec at ffffffff8395959d
> >  #2 [ffffb25d8dad3a20] crash_kexec at ffffffff8395a45d
> >  #3 [ffffb25d8dad3a38] oops_end at ffffffff83836d3f
> >  #4 [ffffb25d8dad3a58] do_trap at ffffffff83833205
> >  #5 [ffffb25d8dad3aa0] do_invalid_op at ffffffff83833aa6
> >  #6 [ffffb25d8dad3ac0] invalid_op at ffffffff84200d18
> >     [exception RIP: jbd2_journal_dirty_metadata+0x2ba]
> >     RIP: ffffffffc09ca54a  RSP: ffffb25d8dad3b70  RFLAGS: 00010207
> >     RAX: 0000000000000000  RBX: ffff9706eedc5248  RCX: 0000000000000000
> >     RDX: 0000000000000001  RSI: ffff97337029ea28  RDI: ffff9706eedc5250
> >     RBP: ffff9703c3520200   R8: 000000000f46b0b2   R9: 0000000000000000
> >     R10: 0000000000000001  R11: 00000001000000fe  R12: ffff97337029ea28
> >     R13: 0000000000000000  R14: ffff9703de59bf60  R15: ffff9706eedc5250
> >     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> >  #7 [ffffb25d8dad3ba8] ocfs2_journal_dirty at ffffffffc137fb95 [ocfs2]
> >  #8 [ffffb25d8dad3be8] __ocfs2_move_extent at ffffffffc139a950 [ocfs2]
> >  #9 [ffffb25d8dad3c80] ocfs2_defrag_extent at ffffffffc139b2d2 [ocfs2]
> > 
> > The fix method is simple, ocfs2_split_extent includes three paths. all
> > the paths already have journal access/dirty pair. We only need to
> > remove journal access/dirty from __ocfs2_move_extent.
> > 
> 
> I am not sure what you mean by "all three paths have journal access/
> dirty pair".

I am a newbie for ocfs2 & jbd2, I can't make sure this [1/2] patch is correct.
Below is my analysis.

All three paths (below 1.[123]):

__ocfs2_move_extent
 + ocfs2_journal_access_di
 |
 + ocfs2_split_extent           //[1]
 |  + ocfs2_replace_extent_rec  //[1.1]
 |  + ocfs2_split_and_insert    //[1.2]
 |  + ocfs2_try_to_merge_extent //[1.3]
 |
 + + ocfs2_journal_dirty       //crash

All three paths have itselves journal access/dirty pair.
So the access/dirty pair in caller __ocfs2_move_extent is unnecessary.

> 
> It seems we can't do it in your way, as journal access has different
> ocfs2_trigger with different offset, e.g. dinode is different from
> extent block.

There are 3 ocfs2_split_extent callers:
 fs/ocfs2/alloc.c <<ocfs2_change_extent_flag>>
 fs/ocfs2/move_extents.c <<__ocfs2_move_extent>>
 fs/ocfs2/refcounttree.c <<ocfs2_clear_ext_refcount>>

We can see, except defrag flow (caller __ocfs2_move_extent), other two
don't use jbd2 access/dirty pair around ocfs2_split_extent.

In my view, in defrag code flow, the struct ocfs2_triggers is changed many
times. The outermost ocfs2_triggers (belongs to __ocfs2_move_extent) must be
overwritten in sub-routine ocfs2_split_extent.

In another perspective, why ocfs2_change_extent_flag & ocfs2_clear_ext_refcount
don't use journal access/dirty pair to wrap ocfs2_split_extent? 

> 
> Or we may reserve enough credits to resolve this issue? 
> 

In my view, credits is not the key for this crash issue. The crash is
triggered by transaction changed:

crash code:

```jbd2_journal_dirty_metadata()

if (data_race(jh->b_transaction != transaction &&
		jh->b_next_transaction != transaction)) {
	spin_lock(&jh->b_state_lock);
	J_ASSERT_JH(jh, jh->b_transaction == transaction ||
		jh->b_next_transaction == transaction);
	spin_unlock(&jh->b_state_lock);
}
```

why transaction is changed?

ocfs2_split_extent
 ocfs2_split_and_insert
  ocfs2_do_insert_extent
    ocfs2_insert_path
       ocfs2_extend_trans //change transaction, and pls note this func comments

Thanks,
Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
