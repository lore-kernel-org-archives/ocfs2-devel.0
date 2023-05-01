Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751B7C7EE25
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 May 2023 03:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GPeTgp9pq7Jzz+t+WRRTxzMu0vreY2bNw8HtGcrQEpw=;
 b=tvG4rFmTGiwiCfXhdSdQ1hHnuRZnjVTNtaRDbkefmq/4vF000wZzIf1LlDxsxCSlP/wyzktFwQq/
   SBByC9zYFp4nmGEV61TjPunnQSMSVZbAj0ROEiGbHci+TjrMFiUJY1GRjJ6YgiVz0sr5C0LPlIAm
   o+pmUtXN/1/yOS+mGg2zg4ZDDxscSO9OlomsZ0J+YAb93R7adRpzBgIEHCQJhYJeidTv32zqkZvs
   5e128d+hmpF2aSTSPlPLrnXslBBqidVB1Vte5Xznx2HeDCOZXfX2fev+UlN1/jzTeLtjCWj0yTF8
   o+/6O0bRwUBp9hK3CuQkjw/AeNmqxHm57yrgPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GPeTgp9pq7Jzz+t+WRRTxzMu0vreY2bNw8HtGcrQEpw=;
 b=JYVYK/SoGVBHrztVlJQhbyt+aR54iBrrqKR2rPE4ZCi+J86qRsYmBPdCWMcIlxlVmtHFhIjen40t
   uMmSmmC04pcNIfT+sqcqZ3rM4V4kPM2XaatWc8FRn4eWkfSKd/ddrZt1gMLzqmdomQJ18RtU5FBD
   7L+bPvEVTe3Bct3YlZBQTcYtlIBHjfnslx78hPxaroXiNMXo3ROuInh9FNscfhLdeLSJ29vQeRTP
   eH8tqRMA6q2nrY2EES50BKe45VOQqNZd/FhneA+pS/a4iZJ+CYe4sqRsWwGc6FAehyok7Hc6/q2O
   j/L4iKUxr6wEiVdr9X48mJ39V2+vrkJ+X9ugYg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTY00B95M5CF670@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 May 2023 03:10:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dgji9UVwHonNS/Phgh9SQhLOqU3plBSBSjdiolPw8TSoGiBCYympCFDOWJJlMRsHjFuqHtv6h7ce/eOfoXkhp7W8J5esfTPiwgRmM2DO5aMAC1/RDBJT57duAloQh5pyb5/HyDPvCZuDe1n10k9YWQwV2rZPtHgmETBNJhLH/40gsLIFn6ZhR2AlNghSXHtnEjoPDRrhB1xJPPFS8/bNRR4eMJDfbUv8IKVQMWb2sJ5lfpBrsUVHeTDyuwg4cFygi6Nn8ARRqrJ+0z52jU2enrGUMwIptBv7OU46GFrs5tBCv1vqAeqSk/dFEl9Q6cWPzfyFIbZKG8DMbd5QhQM3aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPEzoAR0NByjbmmo/9iTRnkGM62o24MDoOH3eq23Arg=;
 b=Owzyzge5jOe7vwdNEYkSSnHHrxEGjsql4vZFuyfs3MYqqKxtnrJD6YPhH3rNIqlFuO/SuOAe/CKEpkew1AwP3T9RETqFPNsQiW+0pK1uwA3BuvO1vIeHg/Qptk6YXNljvXScLkrQ67Z+vUOUn3O+Ix3mkuIbNbh7mZ4Egic0RE6Lm+UntmRQlKy7qCJotIlm7O76XCL3H4+cn/eEboD3fLWb7emL21yWrTZSyrDrfG/5iS8DM36qi84OeAfRXMypMq8psn/dVsir13vejSYifag8KdbJfy3gta7e5WfyjwpwgXdxu28w+7vYo9xk393z+CjH/AgQcfydZ+OdMMTn4Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPEzoAR0NByjbmmo/9iTRnkGM62o24MDoOH3eq23Arg=;
 b=QNEgkBEnZSQWkXCnSkvPg44Y4+WEK8LA9z9ZjBQZfja6kgmf+mPSFJ9vUNXxUD7HG7lr4asI261nE5y9hQUnQ9nggbgldJx2rpVXU4tJ7tXMEdjburc9hWNViwoPTKDi7mGwuQcr4cFsP5uEK4zpOHy7+EGMKXsrmwrhAXUU7pw4jEn4emWeYmTwzr0Z/xn19XVLdkGqxJFVgzSeJiV8eh/TwUWhn1UZrTsupIGcH1K/AEYWPJRLlDeFMGdIORJLV3LxiNIkEUrkVNKXjsGJxN5VNNNAZzDCP/JtN3lUPJ2xiV+FQw/bW4+mivlZvpSzdcbf4v/8kSeH/SkUr90JAg==
Date: Mon, 1 May 2023 11:09:58 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230501030958.ps6xssjcvu6pnpnl@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
 <20230501022628.avrcx3exv3nev3fl@c73>
 <d9d1fc18-39d8-2888-c540-faac2d3f5628@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <d9d1fc18-39d8-2888-c540-faac2d3f5628@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(136003)(39850400004)(366004)(396003)(346002)(376002)(451199021)(83380400001)(478600001)(6486002)(6666004)(6512007)(6506007)(1076003)(26005)(186003)(9686003)(53546011)(33716001)(44832011)(2906002)(30864003)(5660300002)(38100700002)(66476007)(66556008)(66946007)(4326008)(6916009)(41300700001)(8936002)(8676002)(86362001)(316002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 03:10:06.5672 (UTC)
X-Source-IP: 40.107.21.58
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10696
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 unknownsenderscore=20 priorityscore=85 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 clxscore=178 adultscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2303200000 definitions=main-2305010024
 domainage_hfrom=9715
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix missing reset j_num_trans	for
 sync
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
X-ClientProxiedBy: SG2PR06CA0190.apcprd06.prod.outlook.com (2603:1096:4:1::22)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM7PR04MB6902:EE_
X-MS-Office365-Filtering-Correlation-Id: fc9a5b85-2270-40c6-cb12-08db49f1908e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 LKIWp9bxs1wVWcejkobALHxEceTKlK+XdEz9C1sJlP10HTUsQrfPLcpN2c+IFQdx2PiMJOLo+HSINnNGzmIJZsrEhXr1PAqnECmNzhRB3FLW9mgQi9PNG0pM7sKL5OEyGvphVtmQ9pSSIGvGn6XOixgdGVN26NFAtSOQ/As2PPMtSLdckp0W0C+Eb1sTsYu9b9Pktl0OKrXsF36vtFet/c7zZlpJbAsVc3HaBvMCK8IMdUk+lokDdu7FjDtq5REv3wNWtJyYF3+DnyczSHjmNDlsBCgByjYPe+WKE0p83qzCQnWmE5UXK5fr9P2JOAnFqYLBJGqzC1v/zLR1BdXPfJ9NFpncL3U4FQ03S9DVP1DlEAa5Vn+lbUgXDGlPykj7Vff4qGSEP9ouQslGj6n8Fw/8bf2zI3PcMEZMoopXBYyZ74gmr5zc8dwV+SNKgOVTswubLMcKnrGiak3fiM+XGB65Jy0mKqnoTbxsf5NaV1oQNX2OmfQPofNEBhiUlVcpQUSpla9eUARtGwW9oS1qjZsikqHz2bp5MlTuCJcvS9O2zz90nbcLbRwSZoFTvi85
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?L8g/ef9xZQGvKrq0yJ2BtW2saGCEIYp5hypTsieanGJ/Yywb9COsRQfvJSth?=
 =?us-ascii?Q?NcnxdhyTW+3c6FiOs5VGYiHMwgauvtKHeELzqj+ux1b0wtZW0Tms8OHaRchn?=
 =?us-ascii?Q?YI07nxC2KaN8svUBSOow8SM2alfpRirTQ6JB/07cDMOiWfz6xSH5eQW6s2Sn?=
 =?us-ascii?Q?XJA1XSklyBcdcL+J4FfKWWQrs3D+VWM94zSaYF08cqFQrG9XlKROtobGL1Is?=
 =?us-ascii?Q?qZ69iZ2+sldQ7nHDwt16lpNm9DkqqPfbllg4XltC6m8waQAM99CW3RFEN90b?=
 =?us-ascii?Q?E47zW0Bp4tovNnKBfO7R0QPDdgNnHXyrZx+hKS4/p6kRTabNbjcpOG/DmrKq?=
 =?us-ascii?Q?p+7RkTehEROzO+vmexHZ77DBsI5SKmWGydJ0Tk83KUknD9kcPGpDOmcm3WZn?=
 =?us-ascii?Q?02hLs3P+W6uMLKDAOWRnL5zeoXPItUk8JaDfeWIxKDhaiPbIsr2d1cFgqNcW?=
 =?us-ascii?Q?I56OuOKFpVzU9YDsTUSXY4Gd9dbB7IvW0xhZc16z8JPlIlKWmYgdYgLRL7iZ?=
 =?us-ascii?Q?fNuI/P7NMtThMcpnvJl7Ywnf3xTTCDsqtnFcgGON2aU3/RusYzVsP7WFjHba?=
 =?us-ascii?Q?w+aEjttgUog9Y6tg/Akwy1b1Fk/pTu8Inn0MDCNvKV2OcY6ZgkfLqOSvJW7b?=
 =?us-ascii?Q?Y/l+6A92YdPfxtzb4X0ehxxjXkYaZE37O9lZpntibA+LOiOs9u06LNmxuaW6?=
 =?us-ascii?Q?rhQaKRNeKLHKigJvXeA/l15UZe7tX52lnniLDJv9z44chbQCrhAJDHch5Hn3?=
 =?us-ascii?Q?UNQ8wzjjOeLWOHaQRizwLjBRnmfAwUIlzk1GgT8bkK/ikbVwPyrOK922Jesr?=
 =?us-ascii?Q?QCZ3GPxp7DUcxU7ttXp+VBhTwlRYKo+mFIImFF1fUSpYsSC/CMfjcFR0UOr/?=
 =?us-ascii?Q?osnjsEbeKJnj94KlB1lCO75womMFltFN8euFonr1b8E3z7sq+5pGMKfrqiPf?=
 =?us-ascii?Q?0Ho2g7QiigWaJZ41mNoVg+SPwsXuM5fqJitG+O1Yf2fo6AZqTaUBEMlarHWs?=
 =?us-ascii?Q?MdB7LKDCRXJhpvcwnJmMF57hIiRKpUfcV8r09UaZtYf+C8+cZwlueuXgvJxB?=
 =?us-ascii?Q?9E9BOh01npjGAw4YVTo8H1oa6U0PMb+CKIQS+dn1DvJ732oHUY2wBiSazqz5?=
 =?us-ascii?Q?hXEFzVOd14VKmfzfkiRqFAAeXmxkIWBG8lNCUP/5+mVchRPoFtLVeHaEza5P?=
 =?us-ascii?Q?KklsNLiEidXyxSKjHN9udko+Ixhra9PKrmVqwhtdbVvQtSTRWVUmrV1xgI6U?=
 =?us-ascii?Q?NqYMpsPekcP5AwJvbH5bk1UnGi44s124Ko+Boi++OkqjRYjNkHrCkEPb36mT?=
 =?us-ascii?Q?+jHChCw+ysBTyA/o0hsPac4g4gNzjyGE6zsbpmQ4HUk6E8d0X6VHRBlyf7mX?=
 =?us-ascii?Q?2gIo5EUfe6wm8ej1QCNQwlPSBYC1ClR/3MkwTsR+ng/Hf58VF6gQCGFCqIoH?=
 =?us-ascii?Q?mbdcBZpN1EbhFDlRD+YIZvhk9J/MTMpnxGf6zBNH1hi8RHOlYOCHl/6HRPKz?=
 =?us-ascii?Q?KGc95kF0pvjIpNBUeM4lwL+yGN/9H5VYzWAztcd4lcpzK22fcDH9lpk2uyiP?=
 =?us-ascii?Q?mLYJprkZTalx7NimmbKjr4lPRNM4a1Y9zrThAAZf?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 fc9a5b85-2270-40c6-cb12-08db49f1908e
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 mibSD74ic9VzODLDfTIZAL1TTqizPCQOr8jN7xgq0BcJDkSJCbZENXmnQG+uPlMqZb0+3xtAmhrzfn3DE6apoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6902
X-ServerName: mail-vi1eur05on2058.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: LSW4iBe7agIELmRzxqi1UPMbFyNEvj26
X-Proofpoint-ORIG-GUID: LSW4iBe7agIELmRzxqi1UPMbFyNEvj26
Reporting-Meta:
 AAHtxFCqx2DP3sBkOse7NRIpNtDtbqKvunTbY3VBvywzlKICH0zUTD9hzbR00zNc
 59bQJZFDL81VZQHWXlR2nsvB2gHiLba+fVY5P5PbkkOIRPUHeFIoRhtpAZjfWlwy
 DmIZQSQ5fjuhg/B5Fq3J5YWKuIj/kRgj6+ibXb4xiw6n7HmIa+KCO+BRMMq5toyI
 gk9AKCbdUev+2sBzEVAiUvkpAVPgtkqgmDObfOfMyK3ixzB5h17lY5LOd0AN53R1
 Q9unoudqhKNibbEGARA8iVIwULPvoFUnZRAFB5HzqgNCASwY6w3qEuodn0lPRkji
 ewq4ler/eX+pZRt6IFRBXWBXviYdNOwHQkEFLvh4S6hFhVuj+hJaUlrnKLfDujmR
 UtLIMxxE3wvdF5pzkiAGdroOxY1SAKAtufdQJyhyeldgRyz33fsMmAQ2OlSS/RLY
 X9hGHHPxfOqukoqXq2rqGTL2P8z5hpNu0onTir7RsSE3lerQxR4+JFBV3PQDSomM
 +3RW+UKEMe3cqtM7RjCEqd4N6+oYRTCJleGfHHYe1mWc

On Mon, May 01, 2023 at 10:52:13AM +0800, Joseph Qi wrote:
> 
> 
> On 5/1/23 10:26 AM, Heming Zhao wrote:
> > On Mon, May 01, 2023 at 10:07:34AM +0800, Joseph Qi wrote:
> >> Hi,
> >>
> >> What's the journal status in this case?
> > jbd2 is marked with JBD2_ABORT
> > 
> >> I wonder why commit thread is not working, which should flush journal
> >> and reset j_num_trans during commit cache.
> > The reason is in my above answer.
> > 
> > below is the dmesg log for No. 266.
> > 
> > ```
> > [  595.071807] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> > [  595.080950] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> > [  595.081091] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> > [  595.081580] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> > [  595.081886] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> > [  595.082173] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> > [  595.082420] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> > [  595.082696] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> > [  595.082932] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> > [  595.083188] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> > [  595.084721] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> > [  595.095436] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> > [  595.787078] systemd[1]: Started /usr/bin/bash -c exit 77.
> > [  595.802650] systemd[1]: fstests-check.scope: Deactivated successfully.
> > [  596.195734] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: joining the lockspace group...
> > [  596.206310] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> > [  596.206350] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1
> > [  596.209667] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: add member 1
> > [  596.211433] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_members 1 nodes
> > [  596.213942] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: generation 1 slots 1 1:1
> > [  596.215668] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory
> > [  596.217171] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 in 0 new
> > [  596.218253] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 out 0 messages
> > [  596.219401] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1 generation 1 done: 0 ms
> > [  596.220628] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: join complete
> > [  596.224616] kernel: JBD2: Ignoring recovery information on journal
> > [  596.229686] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> > [  596.870008] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> > [  596.236135] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: leaving the lockspace group...
> > [  596.237431] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> > [  596.239442] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: release_lockspace final free
> > [  596.877286] ocfs2_hb_ctl[5436]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 78CE18109AE44E6AA896722A5E25CFC0
> > [  596.248299] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> > [  596.255888] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: leaving the lockspace group...
> > [  596.905718] systemd[1]: fstest-test.mount: Deactivated successfully.
> > [  596.280602] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> > [  596.281762] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: release_lockspace final free
> > [  596.921672] ocfs2_hb_ctl[5448]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 838DD74847E34AA1839D6C4AA31132F1
> > [  596.299507] kernel: ocfs2: Unmounting device (253,16) on (node 1)
> > [  596.481755] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> > [  596.484722] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> > [  596.484729] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> > [  596.485361] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> > [  596.485622] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> > [  596.485861] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> > [  596.486063] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> > [  596.486293] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> > [  596.486498] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> > [  596.486768] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> > [  596.487037] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> > [  596.491655] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> > [  597.139758] root[5475]: run xfstest generic/266
> > [  596.505896] unknown: run fstests generic/266 at 2023-05-01 10:19:02
> > [  597.186885] systemd[1]: Started /usr/bin/bash -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec ./tests/generic/266.
> > [  597.566466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> > [  597.579759] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> > [  597.579766] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> > [  597.581004] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> > [  597.581820] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> > [  597.582292] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> > [  597.582894] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> > [  597.583423] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> > [  597.583991] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> > [  597.584547] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 4 ms
> > [  597.585079] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> > [  597.590136] kernel: JBD2: Ignoring recovery information on journal
> > [  597.594258] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> > [  598.239046] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> > [  597.606575] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: leaving the lockspace group...
> > [  597.607446] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> > [  598.244507] ocfs2_hb_ctl[5680]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u AB0245F740984C25A9D0907D61DFCF8A
> > [  597.607843] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: release_lockspace final free
> > [  597.615474] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> > [  597.641624] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> > [  597.659435] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> > [  597.659479] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> > [  597.661482] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> > [  597.662340] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> > [  597.663211] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> > [  597.664150] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> > [  597.665466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> > [  597.666370] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> > [  597.667235] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 0 ms
> > [  597.668428] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> > [  600.194974] systemd[1]: Started Daily Cleanup of Snapper Snapshots.
> > [  600.207227] dbus-daemon[672]: [system] Activating via systemd: service name='org.opensuse.Snapper' unit='snapperd.service' requested by ':1.10' (uid=0 pid=5728 comm="/usr/lib/snapper/systemd-helper --cleanup")
> > [  600.209151] systemd[1]: Starting DBus interface for snapper...
> > [  600.217270] dbus-daemon[672]: [system] Successfully activated service 'org.opensuse.Snapper'
> > [  600.217370] systemd[1]: Started DBus interface for snapper.
> > [  600.218969] systemd[1]: snapper-cleanup.service: Deactivated successfully.
> > [  599.608010] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> > [  599.611041] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> > [  599.611127] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> > [  599.611813] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> > [  599.612019] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> > [  599.612227] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> > [  599.612397] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> > [  599.612559] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> > [  599.612712] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> > [  599.612880] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 0 ms
> > [  599.613078] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> > [  599.615320] kernel: JBD2: Ignoring recovery information on journal
> > [  599.619221] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> > [  600.392044] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> > [  599.780111] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: leaving the lockspace group...
> > [  599.781949] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> > [  599.784235] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: release_lockspace final free
> > [  600.426136] ocfs2_hb_ctl[5762]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u F06626AE7D754F11A0211679C145C8BF
> > [  599.808566] kernel: ocfs2: Unmounting device (254,0) on (node 1)
> > [  599.827803] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> > [  599.832848] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> > [  599.832984] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> > [  599.833810] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> > [  599.834272] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> > [  599.834663] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> > [  599.835030] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> > [  599.835474] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> > [  599.835868] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> > [  599.836365] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 4 ms
> > [  599.836829] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> > [  599.845790] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> > [  600.079285] kernel: Buffer I/O error on dev dm-0, logical block 2621424, async page read
> > [  600.090845] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> > [  600.091387] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> > [  600.091924] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> > [  600.092422] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> > [  600.094252] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> > [  600.095029] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> > [  600.095891] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> > [  600.096698] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> > [  600.099071] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> > [  600.099957] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> > [  600.100798] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> > [  600.101623] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> > [  600.107094] kernel: (xfs_io,5785,1):ocfs2_get_refcount_tree:358 ERROR: status = -5
> > [  600.107659] kernel: (xfs_io,5785,1):ocfs2_lock_refcount_tree:456 ERROR: status = -5
> > [  600.108175] kernel: (xfs_io,5785,1):ocfs2_refcount_cow_hunk:3417 ERROR: status = -5
> > [  600.108654] kernel: (xfs_io,5785,1):ocfs2_refcount_cow:3478 ERROR: status = -5
> > [  600.109128] kernel: (xfs_io,5785,1):ocfs2_prepare_inode_for_write:2326 ERROR: status = -5
> > [  600.109613] kernel: (xfs_io,5785,1):ocfs2_file_write_iter:2433 ERROR: status = -5
> > [  600.118113] kernel: (umount,5789,3):ocfs2_inode_lock_update:2354 ERROR: status = -5
> > [  600.118481] kernel: (umount,5789,3):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> > [  600.118898] kernel: (umount,5789,3):ocfs2_statfs:1654 ERROR: status = -5
> > [  600.119364] kernel: (umount,5789,3):ocfs2_statfs:1686 ERROR: status = -5
> > [  600.759255] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> > [  600.127135] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> > [  600.127373] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> > [  600.127615] kernel: Aborting journal on device dm-0-24.
> > [  600.127893] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> > [  600.128137] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> > [  600.128362] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  600.128591] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> > [  601.147704] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  602.171745] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  603.195707] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  604.219709] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  605.243712] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  606.267748] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  607.291715] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  608.315742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  609.339724] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  610.363774] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  611.387693] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  612.411727] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  613.435719] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  614.459743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  615.483742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  615.484503] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> > [  616.507742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  617.531751] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  618.555743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  619.579702] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > [  620.603758] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > ^C
> > tb-fstest1:/usr/src/linux/fs/ocfs2 #
> > ```
> 
> So the case is, flush journal in commit thread will never end if journal
> is abort, and then lead to umount hang since commit thread won't stop,
> right?
Yes.

> 
> If so, I don't think your changes in sync fs is a right solution. It
> seems it just for bypassing the testcase.
No. 
In my view, No. 266 shouldn't trigger jbd2 ABORT status. The 'sync' should
tidy up all already issued write IOs. After sync & load dm-error, new write IOs
fails on rw IOs, which shouldn't generate any journal IOs and shouldn't trigger
jbd2 to enter ABORT status.

> 
> If the expected behavior is to let umount ends even journal is abort,
> it seems we have to make journal shutdown happy in this case.
This is my [patch 2/2] job, which resolves fstest generaic NO. 347 361 628 629.

- Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
