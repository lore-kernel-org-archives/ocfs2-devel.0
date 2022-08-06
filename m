Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9E7C19F2D
	for <ocfs2-devel@archiver.kernel.org>; Sat,  6 Aug 2022 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qUJT37SPfJdsKco3Mzy7gIyw+utIa/hVy972a/19vkQ=;
 b=1vlJNPJ0eMrJx6Hx6aDiF4XpkiEK3EHnUdd24Xo/h4Rz03ZBsz8Udg7YXCitmQMR7FrOCHnai4Mv
   EHdNMZCKfj1nJIR+eCWQUfpwOq/aUi+0/A3XWlS9X2S7SlIkeDzAREsedoUpCRFOcAFYQXuI3KE1
   3G9E1pKu/RLRD0e0EZJ/xN133hkDZVi0LpdzJpw02V4YoRMS4FRpvuFYEsoH9kgl13/2hwPHDDuZ
   dZ3D2oyWY8r/luT2Cl3N7fYQDWf36PR4S0jKD5nfVjhclXoUAW49c+LIlJbdqfy29EzRke3obbQX
   1XUeUcOlnZQVYRpFGGABoI+ga2hltAzxmP65Hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qUJT37SPfJdsKco3Mzy7gIyw+utIa/hVy972a/19vkQ=;
 b=WRM1DO4z/2lalwk+Wg1npiS+t9I5xYLKiVnaBOSgAbaeUgyNFZLotUaKpWitdiU+WueZCNNQxZUT
   +LAWaGENWjAZ+erJhYn5SWlsp1jTWFB/I8SHs/NLSXRSNV17Vc/FL6wxX0YA6+Pt+TTyHyN745Ih
   q5ikTZOsZ+hZkNd/qEfx3nOxRv9m0FIp5E92MSQbrLucr4sxdWxBmPx6rUHnrhpsYzfh5e7zl/Ap
   fhsISdLFHml/caygbXrOpW4haWJNiNHogkSOTPUxOfWRTC0Q4DaYN5B0Ugo6uaDh9KwS+G7ivFX0
   pDpweZrAlo+ycWzay9+bRQRIFDhMe7VuB2FWFQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RG7007JAC2OY6B0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 06 Aug 2022 16:20:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTwTjtGbtEB8oMHa5rrf3+Cf2xS/P3Tuoy0SpPxZp85gWcrBxzVpHMbb6IMf7qogXsw2JUnQlCzTTIWkrE8/Nd1L2nywNkfA09NMQQxE1sNKt8gqPI11I2jbmgX8prnT74kPDxxZVqLb86ka1v8e8wUXgOa9F/PfaVRljlRPdIuRUjzdUBQ9hL2V8E5seB6VCuBpNy0MW2+7YDDnFDr9pPbXQEZ9oZriDDA4akTtTtu0caFKvwLeuIT+/9IqTeEfZ3fJ7IHyYXo7jB9nHhpSUxznM3Lr8zQqZhOJGDPn9p957X3duQxIzbMv74yC91J8GZKBUXl48F5KWbWrICBsDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8GLpDHcVl93gjHGrz1/fDcUE2G/MppF0sDraP/Ila0=;
 b=BrfIV+WZRL0z7FBkcS7qh0lxnIBh8/ic7H9gdaY/y8JvvQhr0Fw/gmwLgsWT94IyvaaZokvLbylQ5dxtBypMfFp90vMGmCnaviyayJhYsG1NyW29TmWE8vEK/3CjqxSfXiTBIkf8Kfq1MmeeotRgsNSMQDk+YTSFqpLI4l91ACrlIy2hMN9bS+dJwaJz3IBLR4MHKsrVLEcpEsbJ9CgdaUS+pz9bh4sB6su6W+xLGnyQByxpgjGYIxsq0nMQbYH6RxROuqBhQGKW2vjM4aDBc1ALtuJQCbChWlRK+L/+1D/389b9AlHGwjRkJekFBlUXWHLAC/QpdZda+gmsEwc5PA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8GLpDHcVl93gjHGrz1/fDcUE2G/MppF0sDraP/Ila0=;
 b=O1oujV81/oGTnQbR2+LcMQ1rnykE9l/zMRBFC04cZFqCE/kEIQnJFOnZ8DbvXjnMyuHc/Fb9VTPSqeWo997HQCaiLepRx+Fha7827PR67VEt1E2gMtjX+UIffkCVgLRoZEgmanc8hrtLBTP9guRULRnqcUHRTAe2Y366Wji7j0RwjLm5IlbUShWDMZ6Pm4P6v5tCp8seXlVh+3LD6WdkoMbibNQzGT0ucdaQij0LZg7gr8xtFsqTpSou60o0zvRKnjamFKiRqChzAUptZ1Q83zlu9usY7/EBmZdmWO+Pce6DXRz2Aj6Q1piIbfKhTZq4S63C9/hiIlkuublSXmc3sQ==
Date: Sun, 7 Aug 2022 00:20:29 +0800
To: Mark Fasheh <mark@fasheh.com>
Message-id: <20220806162029.acpxcid3wjwyu536@c73>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-4-heming.zhao@suse.com>
 <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
 <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
 <CAGe7X7n7J52w3Jn5Sz5=f2AQohLMK5xK2Pjsd9oPAMSn52+SrQ@mail.gmail.com>
 <CAGe7X7=F16yaowhTrLgSGcS4gsGUbtjBgEamfur5n1C0hgRA=Q@mail.gmail.com>
Content-disposition: inline
In-reply-to:
 <CAGe7X7=F16yaowhTrLgSGcS4gsGUbtjBgEamfur5n1C0hgRA=Q@mail.gmail.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR04MB4671.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(7916004)(376002)(396003)(39850400004)(346002)(136003)(366004)(6512007)(86362001)(26005)(9686003)(6666004)(53546011)(6506007)(41300700001)(83380400001)(1076003)(38100700002)(186003)(8676002)(4326008)(66946007)(66556008)(66476007)(33716001)(44832011)(2906002)(8936002)(5660300002)(478600001)(6916009)(6486002)(316002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 16:20:35.4070 (UTC)
X-Source-IP: 40.107.8.52
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10431
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 mlxlogscore=999 clxscore=206 bulkscore=0 adultscore=0 spamscore=0
 malwarescore=0 priorityscore=158 lowpriorityscore=0 impostorscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208060088
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/4] re-enable
 "ocfs2: mount shared volume without ha stack"
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
X-ClientProxiedBy: SG2PR02CA0123.apcprd02.prod.outlook.com
 (2603:1096:4:188::22) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f7c9968-f51e-43e7-f70e-08da77c797a8
X-MS-TrafficTypeDiagnostic: VE1PR04MB7278:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 r0YEe6l8s+A4gWstlHaGzmYbtBDQIaGYDYvpGygGwe9FP03vOjA/qAdF8JVNDfH6XdXE8lvQXy6w3u/D4zXseTSwAHNi+TACZ8oA1UM/fR7pjIuEuRo83uKvgkPx5VPCGD/vaF8gV9CQgCzAYV9hk2vRehxJiZgokqpC3UIqOH+zyRAZ5UxiTbs6TZwJii/wmdJpGdYR2CfsG1h/gSt2UVYLT9myaNVALWDSBKUJCcBXc0hw4KScoe5WcusSOEyhhgqhlLpxMNFf87m6mxWRkBrNpJxhSfpS1eQD+57m9mmhmBgw4M6ecZIilBE6iyPtSXz+kueK6ZxULGozhHfH8EmolT6wwxuLvyfQVaZwEuewwr69i/j6+ZaSeovaSloyn52nzLGTmbzyXbBhAYnnY4Rq+OHnyW6+Kw8eOQs74QJPlGzr6LJp9PKAV6Kozwp9UKfZ8ruVd47111qRDn99IfvkgiIqfWaJ06ZAlpHY4FwMnuQTfyJHZm3Gk1KjnVn0GLSssCEBnq35RX7tBBuTFGR19T5YQRc/zVNmvBqfoj/x19s0MSmtZWUHS6PwCqPQoDToeYuX4JuuEuS+YFp8FC4id0NBx7SF/oji+vrPHfnieJn5ZnYACsKLpvWClBzZ/MCDn50VMFEHjuJHpIkDRSec5r0D3UyIAhy4qA6AAZ+PLR5vdGTEv80kLW2VPwUTOtSPwuNePWgvTorBIC0WNY5BsmNOYc+AABui1bZhoFzhslyGboOKg3iUUqEG4MCh
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?yskZUgB4EMbMb2rIDctaaS3KkQxdPzr4w9ZGomtQLxk3inaN5jiKY9Sme1xP?=
 =?us-ascii?Q?eBBPHGkreRxHbegRTCSuC77ZjuN37FgsnaJ8xqsDJdzQ1i82GAfw6kf2M8iL?=
 =?us-ascii?Q?0XcfvOAS1ixf8kcfK5omagKj3rfm4xqDyeJxYwt1qBO6mmZ2G9jaQj0486SJ?=
 =?us-ascii?Q?VcOvuNtWCGJsxPpY6p1h4JbH2p5LSS0T4tIj3K+YMut+x9x5xeNs7lDN2RJc?=
 =?us-ascii?Q?I7P13EBeIX2Uhff6VD11V7Rie4LoofIi0fQai4ZL6Aya3/dHDbO+xGpOS/IX?=
 =?us-ascii?Q?KYIQ3wJeHUp11bQJdKbt/by6b/qRJrefKYp4Ktq2iq42sW1VWcFXd5v+BhqY?=
 =?us-ascii?Q?OjBWzbGJNQmtJ5hMPCW3BO/xmaveFdijGo8c88iu6THNBSzCrq4Q12k9ItuC?=
 =?us-ascii?Q?/EnCNMIdnPNvrEHc994/32hVD5kxCKAkAx9iUq9iJzJ05K+q7WAq7H46o57n?=
 =?us-ascii?Q?f1BTzJ6AeadApG6axS0QBNqNJ2+3FhhFNlR3Hx/otfICPXFJRvYCyKerrYD2?=
 =?us-ascii?Q?sM9u2OwQtYtxF1ZwPm6fv8ceYTXazBT7hGdigAlqg/YYrJlQHSo+BIBjr46a?=
 =?us-ascii?Q?X29cg/PF8vQ97S4CL0iG1wSfiOsEQQyf1hdhmBWqyuJcKYYHCGAggxAXSHQe?=
 =?us-ascii?Q?TvNhvXQReLhomGaWlSQ7NFXQv0on8inAuyGGl+f0/H4v6iknB83NeDrQvemR?=
 =?us-ascii?Q?EJV5kylHxF+T43qUN/R7o3XhO5zCQ8yTfgLsJXQe2iYnuVzBUtkvFkxvQq3Y?=
 =?us-ascii?Q?Hf0xm2bt9fADxCqYPn39XQpXIV+zbJ7B9vIz6wSdFlW4pMS2dJ7HJaykdjwi?=
 =?us-ascii?Q?S+hPNJSDQxyZkkkJ5ndhW0YbrWk18et+t398kq3+TFFb69lc/+RyRjZoaJ8W?=
 =?us-ascii?Q?Dem6u0KeusLaERPAjZ5aSRqOZ6H7BhZDHKIQUjvYIZcKGc57h7oCOzRF71K3?=
 =?us-ascii?Q?/WvuQ+YRil6YLpX2Ns4JxCgYJP8meSRywUhchD6BlSsRSTDr0aoFI2ax39lu?=
 =?us-ascii?Q?RULjUP/kfxOfIs+pfPYYeJfy31Mc4QKnHt34i7O9gVSHRoaIs/p6h4qNqntA?=
 =?us-ascii?Q?bM+Bthyb09iep3NUKf1uqZIcC+fG4IkVkSFR/KFl4cWcDsAHfhjOMQWFAkxH?=
 =?us-ascii?Q?13yl02if2mm2bV4JDkg9V5vbzS/e+5Qltw2bBAKwn3xBDuMlYDG/47gTP/LV?=
 =?us-ascii?Q?HLSkJxPckL5IRIQj27YbjiFdqX+BiaeMss+fCtY9iJJ27pg98aA1P0nMKVTD?=
 =?us-ascii?Q?VFA5ZjPRbXAc/3r55jr/z1TFasQxoE+ndLA0Rk1HbKEu6eJNnO+Vqc5yt661?=
 =?us-ascii?Q?gbIxb8yS43NC1Z0vS/Ip4yYJReNtPwYDoMJn6ITK2t8GVYHXrBlZZekxIhoW?=
 =?us-ascii?Q?tuNnWWXoFvK0af7XCw5iKus9+aSbHKD4NSHCtM8LNcieTgpxhFse5s/aOLEd?=
 =?us-ascii?Q?MYROadwnA9ZHqaIg54rvIrxUOLWIrem6I1FcbzEeR+uumgan8IV4nuoBZSIE?=
 =?us-ascii?Q?HMuj3Tc4qQK5HUfQxk9MTNj4gslFkOet/H8UxVyNnQg5gWkGVXI2ICtKCWwL?=
 =?us-ascii?Q?wkqVOtEJoFkMnJ8ALlXy7S6pjk0ZvzQuzqYHka4t?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 1f7c9968-f51e-43e7-f70e-08da77c797a8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 9LGYV4DfxkbaeThyefC8z4kmEPYcsQSlPfGYI2x4lx5cCbqFBscw29ClIqFcH4JsCtWFgckQwjiZSu1ke6pqKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7278
X-ServerName: mail-eopbgr80052.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: BQFI4HUPLSnpRfYZPNFnoDuIL-vC0OSI
X-Proofpoint-GUID: BQFI4HUPLSnpRfYZPNFnoDuIL-vC0OSI
Reporting-Meta:
 AAHc4E8Sx2pLGGgtTHRf37b6z7UP/2pj74dkCRnl0cJHU6Lu8fX+6cIe+cbEMo0p
 oKiAq424xy/+gI/LzZ7G7NTLIxXmG1qaxOZlkKq4hojE0mnKoY7LB7IRF7GmKjZi
 yNmbN5m/ZQCnhPam9f+qu6H1W02+bE4wgi9uTYAmIIfE6d2+/oy0hZAurzFPjv2n
 AoZ0rfcdH0zqZcHkAozFUXRl7KqhPT7CliP/pEA1ZLPNkz6n2Uq1o7p/YRqNdgmF
 aI4RwPH/ui8qLkQ/LFjj6/hlzlj4KjAaxwEFuLjy6IcpV1a3Nup4BBRtGbKlAEWX
 A1bQhFNeGYlIsnp6bKArdMca6y3e1nMSKD+RQXFxw0L2dEtavRoNDAt0y9aDPFvR
 iOsuqkVAj5txICyK/QFcxjSqSAdFQjlMcMp/2cSnrPYtf/B6BnEjcgB0pvzbiaZe
 TZFrPgJFTwf8TnJIWNDonOOOnY2AL4EY6HBP7z5Ra8cdToJGtu/7yNApQjeZ02eG
 W2GtxYRVuBomwXxnxK6OdzwQyxGL6Cn8i00zcqBtO+UX

Hello Mark and Joseph,

please ignore my previous mess formated reply mail

On Thu, Aug 04, 2022 at 09:11:53PM -0700, Mark Fasheh wrote:
> On Thu, Aug 4, 2022 at 4:53 PM Mark Fasheh <mark@fasheh.com> wrote:
> > 2) Should we allow the user to bypass our cluster checks?
> >
> > On this question I'm still a 'no'. I simply haven't seen enough
> > evidence to warrant such a drastic change in policy. Allowing it via
> > mount option too just feels extremely error-prone. I think we need to
> > explore alternative avenues to help
> > ing the user out here. As you noted in your followup, a single node
> > config is entirely possible in pacemaker (I've run that config
> > myself). Why not provide an easy way for the user to drop down to that
> > sort of a config? I know that's kind
> > of pushing responsibility for this to the cluster stack, but that's
> > where it belongs in the first place.
> >
> > Another option might be an 'observer mode' mount, where the node
> > participates in the cluster (and the file system locking) but purely
> > in a read-only fashion.
> 
> Thinking about this some more... The only way that this works without
> potential corruptions is if we always write a periodic mmp sequence,
> even in clustered mode (which might mean each node writes to its own
> sector). That way tunefs can always check the disk for a mounted node,
> even without a cluster stack up. If tunefs sees anyone writing
> sequences to the disk, it can safely fail the operation. Tunefs also
> would have to be writing an mmp sequence once it has determined that
> the disk is not mounted. It could also write some flag alongisde the
> sequence that says 'tunefs is working on this disk'. If a cluster
> mount comes up and sees a live sequence with that flag, it will know
> to fail the mount request as the disk is being modified. Local mounts
> can also use this to ensure that they are the only mounted node.
> 

Above tunefs check & write seq steps are mmp feature work flow.

Your mentioned tunefs work flow matches my patch[4/4] idea, and this
patch does all the works in kernel ocfs2_find_slot().

Because sequences should be saved in SB, update it should grab ->osb_lock,
which influence the performance.

And for saving seqs, for saving space, we won't alloc different disk block for
different node. If multi-nodes share the same disk block (eg, keep using
slot_map for saving seqs), the updating job will make IO performance issue.

For fixing performance issue, in my view, we should disable mmp sequences
updating when mounting mode is clustered. So I make a rule:
** If last mount didn't do unmount, (eg: crash), the next mount MUST be same mount type. **

above rule another meaning:
new coming node mounting type should same with exist mounting type.

and there is a basic knowledge:
current ocfs2 code under cluster stack already have the ability to prevent
multiple mount when mounting type is clustered.

(from patch 4/4) there are mount labels:
+#define OCFS2_MMP_SEQ_CLEAN 0xFF4D4D50U /* mmp_seq value for clean unmount */
+#define OCFS2_MMP_SEQ_FSCK  0xE24D4D50U /* mmp_seq value when being fscked */
+#define OCFS2_MMP_SEQ_MAX   0xE24D4D4FU /* maximum valid mmp_seq value */
+#define OCFS2_MMP_SEQ_INIT  0x0         /* mmp_seq init value */
+#define OCFS2_VALID_CLUSTER   0xE24D4D55U /* value for clustered mount
+                                              under MMP disabled */
+#define OCFS2_VALID_NOCLUSTER 0xE24D4D5AU /* value for noclustered mount
+                                              under MMP disabled */

whenever mount successfully, there should be three types living labels
in slotmap area:
- OCFS2_MMP_SEQ_CLEAN, OCFS2_VALID_NOCLUSTER - for local/non-clustered mount
- OCFS2_VALID_CLUSTER - for clustered mount

new coming node will check if any slot contains living labels.

whenever unmount successfully, there should be two types left labels in slotmap area:
- OCFS2_MMP_SEQ_CLEAN or 0 (zero)

when a node does unmount, according to the mount type, it will clean (zeroed)
or write OCFS2_MMP_SEQ_CLEAN in the slot. 

> As it turns out, we already do pretty much all of the sequence writing
> already for the o2cb cluster stack - check out cluseter/heartbeat.c.
> If memory serves, tunefs.ocfs2 has code to write to this heartbeat
> area as well. For o2cb, we use the disk heartbeat to detect node
> liveness, and to kill our local node if we see disk timeouts. For
> pcmk, we shouldn't take any of these actions as it is none of our
> responsibility. Under pcmk, the heartbeating would be purely for mount
> protection checks.

From my thinking, under cluster stack, there is enough protecting logic.

For local/non-clustered mount, mmp will give the ability for detecting node
liveness. So I only enable kmmpd-<dev> kthread for local/non-clustered mount. 

> 
> The downside to this is that all nodes would be heartbeating to the
> disk on a regular interval, not just one. To be fair, this is exactly
> how o2cb works and with the correct timeout choices, we were able to
> avoid a measurable performance impact, though in any case this might
> have to be a small price the user pays for cluster aware mount
> protection.
> 

I already considered this performance issue in patch [4/4].

> Let me know what you think.
> 
> Thanks,
>   --Mark

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
