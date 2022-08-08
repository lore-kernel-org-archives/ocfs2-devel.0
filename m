Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C36E8C00140
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Aug 2022 12:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c2HNf25Gvz+pAprl95uh7LYGaNzNjseHDpIn5TkgIDg=;
 b=i6RQ/vmIb7A4j534T+VSbTstKNUFu7yji0F58CId2CN9toN1kKRH+e3DGjqvrbytUblpNt4vsH6Z
   x3Aj0giMgEaS45yK1FeCyidCMgrAQ7E2b+f558r1LT2Ye1j3Y9f3kxcY4DZmYqDHaHqPcIVBQhlg
   O0/necI/TyXupl11fEbzxefx3L8+nElOhJxeFfRi/mOvkd8sDdhGFlSgQKbh9yPmp1oC6DiddOL9
   ogUOcciuhMRurWDzlML7V60T2Gp3HgPQDIxkMnuDYeUz186C1QTy+hIWSBOowbARZ0cRpqRWtGV6
   ZPKobpTu6oa9MpuZHLYNNBDKhfHJzJ/8p7Mopw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c2HNf25Gvz+pAprl95uh7LYGaNzNjseHDpIn5TkgIDg=;
 b=RsaC3OSAuCLxqpSbTHarZa2oTBkwH7tW6JkIA9b1izhwUIwRJo8qr3LAKH/LtgXZCF75huoBv45m
   raxof15XA+C3SqH0rOYhmgCuQaXd4SIod0B4kx7sts9tbSZCAsUMs55a4tROTUWRd2fM659DsXhX
   5bBy9XMdNZ0MuHRcOvYDE3gsO6LdvmHKO8eHThqQBs2a9eXFZCeNZ45CH+pi/N8c3gklRk3sp96g
   Zn3O8/svuKxJlfErpvbJIWhXWp0Mj34tBiaVyLu/a28qyqRglIRFPeTWv5kSBwnXi+QrsEAXm/KQ
   M+s6sra6nDxgUhCtSs4gSCIF7HqQI0H9fSpU1g==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RGA00B5OPSRTOA0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 08 Aug 2022 12:10:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OY8EKkaVU3jqQlISx1jd6gfbarTFeknkq14Zev9zt6i9eiZxQ8TLmBzQxN5V0sjRB6Z3XOKOkpbpJ9TvD1q+9DDxVXTiQvBskalwVwPsKS324u6kEBG7L7hnPVS34899yhskxWubzZxXZ3fjbZ5T6mketv2a8bznra1Hck5xF7Nwd/k6B9g1tl1lV7grlQEclFGQfcpwNS2tX4foRC0+n7jUkhCRLKkqF0IyjiuQVcUKnD0vvEquDVFG+/S9gSL+6ys+TLvmCxTIhtYIZlA4/Hg7pzxHg3DJnYAJCOPIK3FVXX7roEqsuviav1iffdt28/qBfHUy5OmKSkEpNhXtfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ox90ypBpXYoLjpA4zRkAZE18gP9Sh6hYynMa4wQ93mE=;
 b=EGfkWB7etehfrQ1c+2nqrLTFBOfMX0j/2smesgVmSkBOFu6ngM8PrR4ANRdIqehshqkY2cHPqlIMoa2avhJVf0SPQp/KsYDdjjB549kR1i6rhNwuzJNQGONS5JUyNyR0D474Sc3igfw10uGoY3UpbyfFIZuIONtp1Vplg/m11v4AEcWekB9Q0fHV5Z2DkIFQLjn3z4n4ZO706z815Zpw7Bii96k2LdaK5p1HHetQegn0aycp1kc/Xiy6WZEHA6qkwWLka7F3LxGh1OJX8sEutZPehzGFihy52F6X4s9l6mOlzAm52ugWHwk9Dow6dlbrHg6Rg/+xvxABOPU/CWRK/Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ox90ypBpXYoLjpA4zRkAZE18gP9Sh6hYynMa4wQ93mE=;
 b=INFX3rW98QGYlEKgZAospbarxNvkMFXWqzwChHUh02m9Ye0GuP4cF9h286eV5w5fTgKlIZ2gPZT1scs/ttOCQkqq7o+rpi8f2G4Q3ae9DIt1R/eC79fAxGALokMxryvuHlGffZk6LT4MK7Qm6U8gQRWflFjfnhjN9PCAfaOteh7w7Ay6dVAntOyyXKm2cWjMraec78QzZrZnrq9o5c8SVJ5KoQ0OHjz6K9PQs4kg3/j78Qrd12yVjBWdB5H3cJfnXKz5q33jlr6bVk/S7h6eQY9g/yNxOGchWqilU1SfCxzZ+cFv1I8BACSOCnb8yI1hbXrlkKiBvR6goV75c3bShA==
Date: Mon, 8 Aug 2022 20:09:41 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20220808120852.6tuj3f3ivsuup2pd@c73>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-2-heming.zhao@suse.com>
 <2dd9c00b-bd33-7368-def9-9572dd7e6820@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <2dd9c00b-bd33-7368-def9-9572dd7e6820@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR04MB4671.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(7916004)(346002)(376002)(39860400002)(396003)(136003)(366004)(1076003)(5660300002)(316002)(6916009)(66556008)(44832011)(66476007)(186003)(2906002)(4326008)(8676002)(66946007)(8936002)(86362001)(478600001)(6486002)(6666004)(6512007)(33716001)(6506007)(26005)(9686003)(41300700001)(38100700002)(53546011)(83380400001)(21314003); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 12:09:49.3314 (UTC)
X-Source-IP: 40.107.7.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10432
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 clxscore=177 mlxscore=0 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 priorityscore=115 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2208080061
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/4] ocfs2: Fix freeing uninitialized
 resource on ocfs2_dlm_shutdown
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
X-ClientProxiedBy: SG2PR02CA0125.apcprd02.prod.outlook.com
 (2603:1096:4:188::13) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b80838df-effe-49fa-62e9-08da7936e42d
X-MS-TrafficTypeDiagnostic: AM6PR04MB5718:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 lsA32CHGXUNwrw75E6ozi+WW4x5RxYE3MPCRGx9h/nxbFj8vkzJWzVtTHAVMrGJGev1OPR6iKscEUywi/vw3RKbcJQlp98HQ+UNHhIMf37op8TfTJ+BdWiNUkFt5emUeuqnf4MJ4Uv4GRnUbEdx1Uz9yCVwPBlAtTpyNd3kHcYdNKoeEa3RPIxhaluVFGnzq2VdL63yX4rP4jaPSbvWZZ+ik1VL/kiWDirYzjjjT9xNP3/YGts+MCFfGKwL93eGBvfXACFyBiFOQV0K5BMh6D3sSSaziT5h+9AnLolpWDGYJ03bD/9Zdciqw363EJDdDTclFrrJU+qFE68YGvmYKIAusm8DUx0X0T/e0182V4pAWRXWhgK/stJMCMno3pk4qfzoclgh/MsTXrCGnj+uYiFU0AZNm75uMjo4VXhNJAyueV+xdh1qpc5n8YLC6r7iYYWzjVAHVzhDFBQo3RcI6waPX6YcflEpBLLzg3vsgxfhYCnHpYWCA7USdsHq1TX/XRO84x3euQ2jhnobsFt0ZPHcAFd1h12koTXj0rUJEvWriF0G4gAWrguf72OCxiEDJyeElcMtfKGARSbkJZRXLVyEAFjdqv+8/N7cZasakR6+9DfjWbKMgHxjccYPTg6faqUBtHz3S0n3UXzpcN15/A7YiJU75K7JehIr06YRdm6rST3etQtN3NrGCI8uibthOn0CJ+65B+Qeq2WY8yWq5VnThWzZFvHX3xiHAq9ch/OBNKc57/8OZq8B94xtS4wlirLLj6InrbtMz4RslqiY3qHD4irlZ018Y2RPgddTibMQ=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?xSDfEJx6lN7ThaqyiLE4p0ocge3fy1z8uJ/CNzV5ncudvVogk8evDEewwYae?=
 =?us-ascii?Q?/F/lChzBBlmRUjef9omV8COKkDudWK4u5XlWWVjEI+NGXxpFqvX7KcuzKRRL?=
 =?us-ascii?Q?dQdGN6C/baHVeX/42MG0+t4VEW3C+bA3SpWzn8ulVpBfrQPSrQLYooxHPPHI?=
 =?us-ascii?Q?eSTUg0I3oL9cEhLf1wSsd/WebDITPSqaKL0/qWyLsWQCWuTAH2kZL+u/Pex7?=
 =?us-ascii?Q?rSg3NvjUDYOb2vN5LSF2ynopN/IqlUA5SGPXCt7NzeJYAjOa5Lsyco1Z6fCf?=
 =?us-ascii?Q?6QbMPb/anyDZB+A+OTZJhEHTBSbWJvv52Gmatz4/d4s4LmLcu840ZtECq5rV?=
 =?us-ascii?Q?Nh25ZT/o6Lo1yb4Ovlx1cWijZ46cVotdX95R/1dBk8Dr5m1b/zgC1kkmQ5v5?=
 =?us-ascii?Q?oA666+GeMx64aGs2SvFCLZcmwjCAZfdP9/UTM+i4EoF2+UJBBdR1S2JL0NMF?=
 =?us-ascii?Q?WpP3V1jPdsrreMa2EV+PeoxYtJA7Rk3wdwj/Wxleg7EWBZVU9bM3L6xxHCeY?=
 =?us-ascii?Q?9iFYuAXVRx7JUuKt043ltVqG+tqesd7t/YeNVj+0JATVDA8hYKuc/I690nJ9?=
 =?us-ascii?Q?TJjO0P6ocMDMoBG3csJ0Re0K1+q8hew15JREgzmz3naqvv6VznGacp3H+8VO?=
 =?us-ascii?Q?xVaOabPbddla0IeHKMfGFobkASSkOYB863PO9M+yVf2R/2MywDmzoEdVK2NB?=
 =?us-ascii?Q?pRkcAbyXYwOjeTEWwwpiqc3kYejwDzYxQoq32L0ycxEB9ZA23eh2ob2MNmjC?=
 =?us-ascii?Q?aGf8qkCTOJsWx0X2C6uqJGq4iz5yIP/YNOt2B8xJh2YI46x8Yj9Fho7/LaBa?=
 =?us-ascii?Q?MwB1P1YoYpEdpB4jGq69jQ3HOqkTXNqK3seJI50RFMii4dNErChcNofMvSJY?=
 =?us-ascii?Q?n6zmUFU2hLPyOUrBKYxyligVXvYBcyz8G+SpMuCn49ZhvyW6JnHdbKZiZKBK?=
 =?us-ascii?Q?c0uhHrC5byRlh9ZZ/FHUQX05SxAU6da8jlubI1j8Bnkqn0+yPUX63r4Dzjhx?=
 =?us-ascii?Q?vCD1DQG1egQYD3cFJvb0NxZ8oYoGSf+Wp1s7yFH1xPJmuUUG/fSrteqauSea?=
 =?us-ascii?Q?ppW9Xsggv0y905afzxZt+7o7eDyBn0hfFmfDE2+Cu0EoM+Dy/fKkzW9AyJR0?=
 =?us-ascii?Q?uUejrRDYAM6zMBWPVZTlzfke/7pt/2/38/lQ5IOI3EfdS+iTWGFr7NF3dxLT?=
 =?us-ascii?Q?3CkkLzaKtpRFX4n6u0qpDZm0jjGJrTtQOhcYTfFzZEKHkY03v5pa3XO05HHT?=
 =?us-ascii?Q?O731cPz+BvC3KxV3CCl5ReoV79CcIwAwKQOYmVWBavggi5gbIzX+/dKJWc5L?=
 =?us-ascii?Q?aKN5JW8iyjr75mOuw/58SWq6dR5TnS2cskQ7gMHpiDe2QsIy6EoWK7DgMfA8?=
 =?us-ascii?Q?gXFkBx31FKWPnoHsOZU/8ESZmO3kxrUNZC73VebPzZIn6Atvbw10MNcR1Yo5?=
 =?us-ascii?Q?jhboa1pdIJr/z12+qPNM3VaiKlx+Ixkq8xtic8pSmkkUGl+kfU33LOZ9Wwen?=
 =?us-ascii?Q?hV/tnx546MrLo6n/ti8UEcLYcmIBwYmtdgqklExYfyciS0jCl/fvfmnB2fEx?=
 =?us-ascii?Q?fQScG2aWZ7IHeo374EIp7xns1+tJEvOh48vNY2rg?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 b80838df-effe-49fa-62e9-08da7936e42d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 TYoBZDfi+xbT3gSkE++AjSPi4AaiFBi3z1y0s+616IolvJjm4PYU+pp9sPipJrtafZI830Lq7OFu7uLxs/WM3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5718
X-ServerName: mail-eopbgr70075.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 3EbkMSL3dEzTIgC8E8oqP_-qH0kOS7MV
X-Proofpoint-ORIG-GUID: 3EbkMSL3dEzTIgC8E8oqP_-qH0kOS7MV
Reporting-Meta:
 AAGrv91M9+FICQNbrBvV+iBoYbcEXkuz9voJXg46kFjR77t1c1e3kbI6f+iykgps
 EVTJkJHkmEt3D4MkNVgZdAwVQlF6Ghrwncg2dYzEBj4VCkpv3MUGbhbnDCdGuR1R
 7TmGQIkQzoyoOtkJgwS75D55oZImc3yuYPbjkJGxVS7L4r4dadYl0mfrxiWXBFUk
 Xjt1y+649SzAMmBNHdbdIWyZAAUvy5yLclD6+4vab7HQZEMVdiCQH0u85af+VBOO
 QaGEvaXdJJMYrZhDrrF/ybm44pBQOiV85GvkPKzM1lY/CiFQfFt4SYnH+/U9gkQJ
 u0PLh1kluEdzE8o5rHyejeKl3ShFmk9p1dLBgNm3GzktXFLM0/+hInpKpyjqmpbY
 wjy/IyeL0sWsA/yYF33m5OMINAKUkLAiqzZc3/5drESLhaQI3WVV9sTmnfYWPH67
 uUls7yRkbyaFk2U3z+n6gJr+Y1iXqoC9a8P1SI5vNQXr8slW0dQHRqakKVo5TxVq
 ixPhi0a8U5NpBls91jWHpyCtgHxXIJwT7k3YHsq7yqp3

On Mon, Aug 08, 2022 at 02:51:12PM +0800, Joseph Qi wrote:
> 
> 
> On 7/30/22 9:14 AM, Heming Zhao wrote:
> > On local mount mode, there is no dlm resource initalized. If
> > ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling
> > flow will call ocfs2_dlm_shutdown(), then does dlm resource
> > cleanup job, which will trigger kernel crash.
> > 
> > Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before
> > return error")
> 
> Should be put at the same line.
OK

> 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/dlmglue.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> > index 801e60bab955..1438ac14940b 100644
> > --- a/fs/ocfs2/dlmglue.c
> > +++ b/fs/ocfs2/dlmglue.c
> > @@ -3385,6 +3385,9 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
> >  void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
> >  			int hangup_pending)
> >  {
> > +	if (ocfs2_mount_local(osb))
> > +		return;
> > +
> 
> IMO, we have to do part of ocfs2_dlm_shutdown() jobs such as
> ocfs2_lock_res_free(), which will remove lockres from d_lockres_tracking
> added by ocfs2_xxx_lock_res_init().
> 

ocfs2_dlm_shutdown does the cleanup job for ocfs2_dlm_init.
This patch fixed crash in local mount error flow.
In local mount mode, ocfs2_dlm_init does nothing, which should make
ocfs2_dlm_shutdown do nothing.

And I checked all calling ocfs2_dlm_shutdown cases:
1. mount flow:

   ocfs2_fill_super
    + xxx =fails=> label:out_super (checked, work fine)
    |
    + ocfs2_mount_volume =fails=> label:out_debugfs (checked, work fine)
    |  |
    |  + xxx =fails=> cleanup everything before returning
    |
    + xxx =fails=> label:out_dismout
         At this time, dlm has been init successfully, we can call all lines
         of ocfs2_dlm_shutdown.
    
   
2. ocfs2_dismount_volume => 'osb->cconn' is true.
   this MUST be dlm successfully init case. everything looks fine.

In previous mail/patch: [PATCH] test error handling during mount stage, I may
forget to test local mount mode. So this crash didn't be triggered.

> Before commit 0737e01de9c4, it seems this issue also exists since
> osb->cconn is already set under local mount mode. 

Yes. The bug exists since local mount feature was introduced, commit number:
c271c5c22b0a7ca45fda15f1f4d258bca36a5b94.  I will change 'Fixes' on next version.

(Hope 'CC' list takes effect for this mail. -_-# )

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
