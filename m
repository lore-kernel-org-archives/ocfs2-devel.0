Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7227CC43219
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 Jan 2022 02:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=boPMtkayv4eniYxsbmCyCAcdkDw/+4upckbZgb0SQlY=;
 b=ABQ9T8Rr8ZMOErIAybhcJqgCzDAG5E9UnGmGr0jR+51NUy2a3ItRKiPcX5U/LTpIt3KrqKvUcAfg
   9RRosw4mCAbhlDY9E76dD9VTuNPG0ZQA7fWDs4rE75p62TQfBzXoWXQojTfaQG90KTbterzgcR7J
   7lk4rxgRGaxx83659Wg6CR8pXAiL1wTJ3NI45DbO06dOjyL2RgSsHQqpMQbT4g0f3GO9sjy/nwcS
   HvbhxCczHFoEJPe8TrR6OU/5AStZ32RngIG1U5YO+MtJ4+5acpIcuIqB/FpAPwmu2xx8c574Ffcu
   CLze82CxAQW2G2FZfvYc4uIvpa0XRQ+c5dYevg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=boPMtkayv4eniYxsbmCyCAcdkDw/+4upckbZgb0SQlY=;
 b=grYgPHsTQGS89E2PLg8TwXImsjjhgCFCVQZSFfo8rGbgs2AmOtGs1Ex6mRamchPMMKTXCv6fauI4
   PY1Dp0QgoIGvfM+X2a20bBjadvVTdkjdzy81m2E+UZYX3pBFJawBHPtvRja6BZ4KKhHg3s/jYluk
   XH1X3zHnqA42OelGHEznk9o5WzfeAZixOT5J4leTw5jPV4Fl4nwCbEtpLOQK8Kb9Al6omaFK7psN
   8dLNK4rltC8Pp9v7ErTJy9OjaAF6NAXqognuI3ijHgZaIoXgKGYHMS2Gl0SszfZ763oTX1YAcK5O
   xbIrXjDI2JJyGJJOMYccITebv/Ugyo+h3tlkiA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R6700GNM0N0DM90@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 24 Jan 2022 02:37:48 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <206899ac-c1af-35bb-820a-62a45d93b52a@linux.alibaba.com>
Date: Mon, 24 Jan 2022 10:37:30 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "tytso@mit.edu" <tytso@mit.edu>,
 "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
References: <20220121071205.100648-1-joseph.qi@linux.alibaba.com>
 <20220121071205.100648-3-joseph.qi@linux.alibaba.com>
 <DS7PR10MB487883FE7025BE9FD4623C39F75D9@DS7PR10MB4878.namprd10.prod.outlook.com>
In-reply-to:
 <DS7PR10MB487883FE7025BE9FD4623C39F75D9@DS7PR10MB4878.namprd10.prod.outlook.com>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 clxscore=232
 priorityscore=128 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240015 domainage_hfrom=8320
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0V2cNU4c_1642991850;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: FRekIorjRrB2qzq1wjVTCwtT7W3iTtZx
X-Proofpoint-GUID: FRekIorjRrB2qzq1wjVTCwtT7W3iTtZx
Reporting-Meta:
 AAEzVbuQkqhyHpFd019oL1IHLzm/aNtVWV+Xi35fbN9HmwzxY0kOTTZTg+DRXI0o
 aJqu/gQVS3vk3tOKJqPq/hQRmBZYHg/pE0h/+XzIgeSAV3N1zpo8mH+pAqODhrZI
 mc7l/qOgEskcfuz8Dbf6yxGNedoDfwy6QcNZ8PUETtSR19Fjx65bNkRIofS5E+69
 upfwCeCcFe62Y6ohxDkCsa7nk9lFk2RB2luB89JBnigiPRXO5obdS3x0rgnU5NAI
 wpqxLzxCrmYopAF674XNT7JPbB3wru4lKqMd523G3Ps4yu7O+50fcpl/vsHPpYDE
 5NXRClUkmyzFv4eVeCmmI5DQuPK5v/ltPs6SAwwokCWEXlN/sXKn2xSGKfQhu/eo
 cngtqyp03KVucpt0fN5PgrHUsltrElNPDmZIm3s4Q0eQHb9hebxznxmIRFElIGPC
 wqK4vUQlEo8hnioqLuW+fC5hxYHjtgfqa2RIcjZHr0JTm1bjkdt0PPQomZz8ik0b
 cpEN148hvmGE33dtknScpr4yRN3pn/nWSD4LRX4MXwNE7A==

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
