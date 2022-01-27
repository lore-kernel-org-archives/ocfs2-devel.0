Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE6B2C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 27 Jan 2022 12:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VTYFGq5ApKcTEI7Pot6X/Z84+SOyIDCQQ3OTdhIwTFU=;
 b=aSNllYqT3xFeqWxdjDnumjmWec/K8OnE9Yfo/+d9S7Te9WuSQYkcy6IfaxdDRCJ5iYca4eAiV5M5
   Fcm/jIdwa9+ucBk31qlc1KzJh43BkDVpGfjVGFr98mPiE5AKxxmciR0vUMJZGeYFnMSFt5Gpdc+h
   khMvRmrybPx5GlqUtzTWiwmUhQxjgZ11MoBjdCpDzxFh/5PJNp70tO/lmqbv4SZgfZ/FiB8vhXxk
   dLzAvzKiGNVT5bdp6OCQEK+N0A/xmabDwp4CGQ5VVBV8kMZDU4zCMtCE5rfL5kyo2snPvUastePM
   GKvYx3B5VRpeKux8lhcyGEIVW5pt7AnUsbkhwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VTYFGq5ApKcTEI7Pot6X/Z84+SOyIDCQQ3OTdhIwTFU=;
 b=T6vH1fZ5qEcxFvsFd4kMK69acYarNwsfTX4pMabYuiDizb6DQE6a1wEXDwJbtIQNKDCwDeppG/+F
   c1/jfges6PiUaoODPLhxgoNRpsrQdLzxqMxAvyfoLzxOy+mnWNRZvkmFEy99G/7mIE3aB/pVgxsU
   JnP3EYI9SkDWU49UG5xDGQ3ljCkQQQEIl725gwExn0EstnGW3zkxuDR8LCvCG5tE6L5sPcQ7lwFW
   LhLRoNv/dbRy5jj6QoWr0X5bc6+R1kj27TNgRL3WK3K/ccWuIlgEj7ZO/6qwEwdLX9X4/uv0Lg6K
   mTIhs2rzwRBlVQw5BRWZWlkVdMwxUYpylYrpVQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220119 64bit (built Jan 19
 2022))
 with ESMTPS id <0R6D00EJSCU8NX80@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 27 Jan 2022 12:46:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Tf04wbWyIaiEQNjHeo/cIHHjVcO06nD0pDHLjoCnQD4=;
 b=Cn7PGEf8sJvD4YNKs0h1uhbMZeXE/myz1Z5kNnqNObQTkODTntCa2B3VPsxejuZIjy6V
 Mezc0MovZOHt/quygaggEXmDfzVlS0cyEIYYhqQJ5jh1t+5v7XbreF8ovBDQH/x5yJeU
 yG5hw0NG8y7GF1LacccZzWyfCBL0zTwMS0Zr4Vx20+Igt19LmevnTqCM6OjFJQCKHuh0
 zEtp2OkWvWfYC1GyILKW7Mt1MbD8l6EV0J1FmK1Us8OPz/Y6pwfZlzKajfEegtgg2QfI
 lfISJdTgvTYhiVVLegC/gfWT2evrT2+vO+wmap8G10aW+Yh+IknBEnAZsbKFdIhEmynZ ng==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=gautham.ananthakrishna@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAXNJvvkKaNE4098LarIewf4xiMPOET4yzmArWVGMatCTdejZgzXk7ImghyR31j3iLodRDFrqqdF5OrNYQy01YAFIPMlNsvcbYDlT1i0WFXytORNMw18K6pcDP+fhpBxNwID/fR1sE1MSuU8hzVLrq3e/v6TVTylBCLfoeo6PfM2/2hJqb/9ktp4Yq2tCAalPgUH3JAul8b6bgF07dgEteQrOglSeTqugZZC6DWiuePiLQzhiUxHLpIrzKIaWnOQpLsad+mReETZiz3Zj3VMrPaOQ2hSXACyFmeH1kjbBR3FrnAxgcg2ZQPZuHha3C5GN1eDomhFsr6BUUXL9iHjOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tf04wbWyIaiEQNjHeo/cIHHjVcO06nD0pDHLjoCnQD4=;
 b=ZxU9a5VIGSWFwxZb6nvLlMK2ZXNeg9Zu9a46DmfC5j+CR7xjFEL+GVVbzplM9XFiQMRGVhmJwsLFcajtoYQhJuH4tKJdWi6i0+tfFAt8/Vj4tvhlziB27Qev2eIWXgYKnVbVGVbCUJOcB4zG251lrNEvr3ug+pjFaa1mV67yRjTKtUIq33o0InSHTCjGPE3SbKCVFZYs8mMRHqkjo3HVa7p4dAyQacS8E9mk4WxMQZdbZXbFAHwONd0FVMA+2khhueuLOXrASrvQ6k2Kjt3C62E6QFFFTgbI5oh3MSwPXdhvpqCXxmOIUA025p6A/hhILYekphpH6tM+aVSIYvs/Xg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tf04wbWyIaiEQNjHeo/cIHHjVcO06nD0pDHLjoCnQD4=;
 b=vN3KDO37XejzwilKqi0m8kRvP2q1xmXRY0XdJhtKtsAs2sPoOXz27V7iXftu6QqRiNnHGVduUEhyM40AZhZidAb4Sy08inTR9qtEBDpb9ehxMYqP6wuuz7Htk5D5fbedT9iv9aOo6JKCqrMAkCA24fUMMcXZkdHwDN2/gEQg8WI=
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "tytso@mit.edu" <tytso@mit.edu>,
 "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
Thread-topic: [PATCH 2/2] ocfs2: fix a deadlock when commit trans
Thread-index: AQHYDpY4QxT3B/KhD0KLG3FGeJTJ0KxwFvKQgAFiiwCABWEEQA==
Date: Thu, 27 Jan 2022 12:46:41 +0000
Message-id:
 <DS7PR10MB487856DF1F951F8ABB7956C8F7219@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <20220121071205.100648-1-joseph.qi@linux.alibaba.com>
 <20220121071205.100648-3-joseph.qi@linux.alibaba.com>
 <DS7PR10MB487883FE7025BE9FD4623C39F75D9@DS7PR10MB4878.namprd10.prod.outlook.com>
 <206899ac-c1af-35bb-820a-62a45d93b52a@linux.alibaba.com>
In-reply-to: <206899ac-c1af-35bb-820a-62a45d93b52a@linux.alibaba.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach:
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:DS7PR10MB4878.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
MIME-version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 12:46:41.9184 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239
 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270076
Cc: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix a deadlock when commit	trans
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
From: Gautham Ananthakrishna via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9059e1e4-a962-4013-1f3a-08d9e1931186
x-ms-traffictypediagnostic: DM5PR10MB1481:EE_
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 8T0G0nNPi0nIpct2yfWC3jcufFV1D//LKyZ5EbGVoOpKd8WaIgrhMRLxGLgAE1yWvQraozSbpS5NLR936CBOdGoTDGhis/3qXAic9B92v42820Nr+pt5YNtsFnSTDlBgs2RBR35rVcom0MAaJNJZu7MXlA0dKoppsrc1EKeJSvgDXKCF1hOSCRCmiS8lp3z6icGBdf49ZnVpy36uGpdt4RecKR7pQ4VC2DGqvzUqvLcH75YfLzVxBozy1Sw89TjtPPWau4HWce3wavoggNLefI+3ec3mLDZwz7COPMNhyJ/S5rxf8NthoUpD3Q2P8PwrdA7WBUdjmEcociUyQ/YOWu/vXf85RAWds/kobVYa2zG1BGnDQaZcDR5tT0IGf5yoGvYiLioFLVc772tcWALVMBSGpV5gt0dBNNjpYgrqraZQV6XS/X64vlOEUnCOh5jTf9leWTtGwJhwroQT+x6uMB1nqaLJRiJzUp6DQPGD7yBDk8Kew3qTl6OKFN3HW9p00Si4i35RFZbPMmlwMQcXgTrE7DUaqrHS+8NUiGctCoX0VS+H1cexQlpg68uHClZ2f4lNG2rywIimCl8COGB++OehWfvL4TIt47CkPLFmXmI=
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id:
 9059e1e4-a962-4013-1f3a-08d9e1931186
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname:
 f5R+LesgwbSQQLMIfEaH4Sv60H5EDbtFVyD7ImwfmqeA68k7TlDmANto7S7xQVNhFDvEVuUQPvsJxXdF4Dwq6Qhe3Q/K80drDNmBTokHAyIP0f4uvLeB87XuKB/XPhzA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1481
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC:
X-MS-Exchange-CrossPremises-originalclientipaddress: 138.3.205.62
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: DM5PR10MB1481.namprd10.prod.outlook.com
X-Proofpoint-GUID: QcEOOeWCDMXl9gfJfUsS9g924h13RYU-
X-Proofpoint-ORIG-GUID: QcEOOeWCDMXl9gfJfUsS9g924h13RYU-
Reporting-Meta:
 AAFKQ9HQPV2nGLlo/izg+mwav3RK+pWBJMkhNHlVKAOwGeEkqY9gmz0K5ss3zIXa
 m+FHFmTIC9u5DyeiOtSBjiQOWW9XEoJ3bMD3DL6fdrSEjiygxGleSKtpHhGEvKl6
 0wD8apBPAgMod4guhiulqt9ZkzLGWlmhyPNe+eyTzbpLDCC35HKkH1K7Ao+sAzBq
 vBfCyRJhMrSwKV1Byqp4Wdbstk/BXe3MgmrEYSA/V01fVZlIaBAc3UQdqNozjXUJ
 DL/F7i5BlXlWsTxzN24JF6cs+RAawqTSyZruIrMG1Bpx2xNDsGrZRehiO0S2uQyd
 PUXte/OX23O0otBsdmtWudwfGTr2WAaL7gP4cCBLpoPJRN+9zbeFXCo0b+4CxhVU
 r2BK1Da1/vTcftAdVs+GbAKZ4gwlY9QfXoezbANpBIrCU/ljg3Rr6wxqAhA58p8m
 i2GzE9BJnMJctedi9oY7gfo8cBMzikd1nPYL/a+aWSHvBnxgBQOZ/nRS7NvmA3u4
 zAw+0iT2dG//rS8limeOPGtPtesd2jbOaUisSeO5zCM=

Yes. The patch has resolved the issue.

Thanks,
Gautham.

-----Original Message-----
From: Joseph Qi <joseph.qi@linux.alibaba.com> 
Sent: Monday, January 24, 2022 8:08 AM
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>; akpm@linux-foundation.org; tytso@mit.edu; adilger.kernel@dilger.ca
Cc: ocfs2-devel@oss.oracle.com; linux-ext4@vger.kernel.org; Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Subject: Re: [PATCH 2/2] ocfs2: fix a deadlock when commit trans

Sure, will do it in v2.
So could this patch resolve your issue?

Thanks,
Joseph

On 1/23/22 1:31 PM, Gautham Ananthakrishna wrote:
> Hi,
> This deadlock was originally reported by saeed.mirzamohammadi@oracle.com  Could you please add Saeed as the reportedby.
> 
> Thanks,
> Gautham.
> 
> -----Original Message-----
> From: Joseph Qi <joseph.qi@linux.alibaba.com> 
> Sent: Friday, January 21, 2022 12:42 PM
> To: akpm@linux-foundation.org; tytso@mit.edu; adilger.kernel@dilger.ca
> Cc: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>; ocfs2-devel@oss.oracle.com; linux-ext4@vger.kernel.org
> Subject: [PATCH 2/2] ocfs2: fix a deadlock when commit trans
> 
> commit 6f1b228529ae introduces a regression which can deadlock as
> follows:
> 
> Task1:                              Task2:
> jbd2_journal_commit_transaction     ocfs2_test_bg_bit_allocatable
> spin_lock(&jh->b_state_lock)        jbd_lock_bh_journal_head
> __jbd2_journal_remove_checkpoint    spin_lock(&jh->b_state_lock)
> jbd2_journal_put_journal_head
> jbd_lock_bh_journal_head
> 
> Task1 and Task2 lock bh->b_state and jh->b_state_lock in different order, which finally result in a deadlock.
> 
> So use jbd2_journal_[grab|put]_journal_head instead in
> ocfs2_test_bg_bit_allocatable() to fix it.
> 
> Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> Fixes: 6f1b228529ae ("ocfs2: fix race between searching chunks and release journal_head from buffer_head")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/suballoc.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c index 481017e1dac5..166c8918c825 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1251,26 +1251,23 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,  {
>  	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
>  	struct journal_head *jh;
> -	int ret = 1;
> +	int ret;
>  
>  	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
>  		return 0;
>  
> -	if (!buffer_jbd(bg_bh))
> +	jh = jbd2_journal_grab_journal_head(bg_bh);
> +	if (!jh)
>  		return 1;
>  
> -	jbd_lock_bh_journal_head(bg_bh);
> -	if (buffer_jbd(bg_bh)) {
> -		jh = bh2jh(bg_bh);
> -		spin_lock(&jh->b_state_lock);
> -		bg = (struct ocfs2_group_desc *) jh->b_committed_data;
> -		if (bg)
> -			ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
> -		else
> -			ret = 1;
> -		spin_unlock(&jh->b_state_lock);
> -	}
> -	jbd_unlock_bh_journal_head(bg_bh);
> +	spin_lock(&jh->b_state_lock);
> +	bg = (struct ocfs2_group_desc *) jh->b_committed_data;
> +	if (bg)
> +		ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
> +	else
> +		ret = 1;
> +	spin_unlock(&jh->b_state_lock);
> +	jbd2_journal_put_journal_head(jh);
>  
>  	return ret;
>  }
> --
> 2.19.1.6.gb485710b
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
