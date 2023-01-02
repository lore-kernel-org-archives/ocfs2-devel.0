Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF154C46467
	for <ocfs2-devel@archiver.kernel.org>; Mon,  2 Jan 2023 12:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4L+GHPgoOUdnpnebLMTihyZwl3c7vAX94W2FmF4B+/Y=;
 b=hNtkV0mZL014i/8hWDdrs+3S/8PS1PFn1HPUknIuRzlJinUsXt16CCkcLxwLjpqZjcPdsUZKUGLA
   ZJ4cSRHjRxmCFXO0oMh7Kre7CRMptT92XEEE8M14pD7C0vheoRktCwc7GRXOVshUgo56DwKT5uFo
   N35iIsAOqebkexPSaNH1324hFnfWaFUnc5ax5Fv3V7nvAEAu0cVHcL/RUIAWfozeDEsgLP/N4fCv
   6ea0Jn8o0zymz2U+r1ky8rVlpqdJlRb/rO94L4KxmNaqoPOyqJa8/yQ7rNTlvlks365/oS8lJoS2
   1DSpg0p8wUoGNN4Zb/oDoLHs8yglC1IGV5NNfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4L+GHPgoOUdnpnebLMTihyZwl3c7vAX94W2FmF4B+/Y=;
 b=unVzaUNcDNJORgqC2K3QAG5UTZHNrcPan1rnfxz2Db7ql03Movpqz1vLJrnfRUuPbJTy3DGb6E9K
   HkfxBW7crt39yIhydg6D3vfs9jgg8yTLYyYC5s25oKSNsjHzJHbNZGZwIka7s+7cQ5d0ONWwe9Uo
   NCS74UMlN+edkRTPwwTNmUHxriT/sQrHu0mE8Yzk//WuSMjn1JDFynS3q8JiqIVPFmgXtT3vPRL4
   Mpkirf9oU3G64NUMjUyQ0TrrrRUwVmq4G8MwemoeUDLk1smpPiY/pKAppOnpKA+iiQN83+oM6PM0
   odHpWDWposgYw6S2cJFdAY3sbQ5zESbkPFCezw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNU00003XYUKG80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 02 Jan 2023 12:13:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1672661606;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=tLH69wvDgw4zlrii5ssfaa8PJzW+0Xgf+S3GjAQjclc=;
 b=O3X5uNr30fACrbTuGy88BO/nRLzdSVEm2bxn/xKiI+MpkbqJN5mRMd7HJ8HvLHcTYgjnul
 T1kABhab6ZerssRLV+082h0drbFI0NxPisaG4yhBbgoUD7mZ3K5JF5IzFQSqBa4eM7UCjy
 zsC5iKSZreJNKK8xkH3kwsC2ep5D8lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1672661606;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=tLH69wvDgw4zlrii5ssfaa8PJzW+0Xgf+S3GjAQjclc=;
 b=aB8cuOBt2GCeTl1/MOPlOVFJIPokVJ83QnUy+vrqechFA1EvlGXkDRJFBrSsx+awFiQdU7
 tAP9c4Iwzy8UA7BQ==
Date: Mon, 2 Jan 2023 13:13:25 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230102121325.swmgrnjgvvnxz2fh@quack3>
References: <20221229161031.391878-1-hch@lst.de>
 <20221229161031.391878-2-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221229161031.391878-2-hch@lst.de>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10577
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=9 malwarescore=0
 spamscore=9 impostorscore=0 priorityscore=100 bulkscore=0 suspectscore=0
 clxscore=152 lowpriorityscore=0 mlxscore=9 mlxlogscore=103 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301020111
Cc: ntfs3@lists.linux.dev, Theodore Ts'o <tytso@mit.edu>, linux-mm@kvack.org,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/6] fs: remove an outdated comment on
	mpage_writepages
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
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: y6DZ8MyYEodrazEA6KIuDU90ITSR6lSn
X-Proofpoint-ORIG-GUID: y6DZ8MyYEodrazEA6KIuDU90ITSR6lSn
Reporting-Meta:
 AAH81Tmpz7EiURFNDG+dXpekV9J0tPXuFOdfawKCoo1ID+2NUUXQ/qMF9Li+xZdA
 zD0xLvMnjTFaKZBVTCSAe5PiyOLXd9CnefFud//96zdHOQFs4wfCMStxufrvpy8+
 46QGuB93kfIR1mrrmLfAA4fdKpMc7vFm084XQHEg5AYh5yRek+Xy4VeulmeZyw2m
 8WlSiJpFZVRSzjqBHyKJoqS3blpHqneeBhSI37xHaRhInmji1oonV/1VGLj6kxO4
 XyZ50zwsAFybYqv9xgaq7LUR2CaIa/rhEeIsEczREbTdI9SJREUaWULAV/uzAP8l
 u8FYAPTcylK1kym5Kzm+MPaEg06UQCPbGPSLBKrgeQVqWYliwnCOHFDf22LaRkDA
 cS5KB9Y1CLNmnYfxM/wfPFumRfh/E41I59JJpLmeRLmWuZfa9PkksyNfDp8oCqz7
 JCsDFtt8c49rhxypwIK+j56BbnU3omwehIGhsp3mHMASfanwPschSY7unovM7mu9
 RsUW/37G84d4d/eGs1Dma7Pb3Qb5P7OKYYOFt6YxCHo=

On Thu 29-12-22 06:10:26, Christoph Hellwig wrote:
> mpage_writepages doesn't do any of the page locking itself, so remove
> and outdated comment on the locking pattern there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/mpage.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 0f8ae954a57903..910cfe8a60d2e4 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -641,14 +641,6 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
>   *
>   * This is a library function, which implements the writepages()
>   * address_space_operation.
> - *
> - * If a page is already under I/O, generic_writepages() skips it, even
> - * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
> - * but it is INCORRECT for data-integrity system calls such as fsync().  fsync()
> - * and msync() need to guarantee that all the data which was dirty at the time
> - * the call was made get new I/O started against them.  If wbc->sync_mode is
> - * WB_SYNC_ALL then we were called for data integrity and we must wait for
> - * existing IO to complete.
>   */
>  int
>  mpage_writepages(struct address_space *mapping,
> -- 
> 2.35.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
